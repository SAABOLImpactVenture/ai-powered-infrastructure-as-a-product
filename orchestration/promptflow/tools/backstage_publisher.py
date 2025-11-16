from typing import Any, Dict

from .common_types import ProductRequest, IaCPlan, BackstageBundle, to_safe_dict
from .evidence_logging import log_node_event


def run(product_spec: Dict[str, Any], iac_plan: Dict[str, Any], qa_summary: Dict[str, Any]) -> Dict[str, Any]:
    spec = product_spec["product_spec"]
    product = ProductRequest.model_validate(spec["product"])
    IaCPlan.model_validate(iac_plan["iac_plan"])

    slug = product.product_name.lower().replace(" ", "-")
    template_path = f"backstage/templates/infra-product/{slug}/template.yaml"
    catalog_path = f"backstage/templates/infra-product/{slug}/catalog-info.yaml"
    pr_path = f"products/{slug}/.pull-requests/bootstrap"

    bundle = BackstageBundle(
        product=product,
        template_path=template_path,
        catalog_info_path=catalog_path,
        repo_pr_path=pr_path,
        notes="Backstage bundle computed by persona framework.",
    )

    result = {
        "repo_pr_path": pr_path,
        "backstage_template_path": template_path,
        "backstage_bundle": to_safe_dict(bundle),
    }
    log_node_event("BackstagePublisher", result)
    return result
