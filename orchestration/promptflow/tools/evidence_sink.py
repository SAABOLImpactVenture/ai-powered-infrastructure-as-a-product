from typing import Any, Dict, List

from .common_types import (
    ProductRequest,
    ArchitectureSpec,
    SecurityProfile,
    IaCPlan,
    QASummary,
    EvidenceItem,
    EvidenceRecord,
    to_safe_dict,
)
from .evidence_logging import log_node_event


def run(
    product_spec: Dict[str, Any],
    architecture_spec: Dict[str, Any],
    security_profile: Dict[str, Any],
    iac_plan: Dict[str, Any],
    qa_summary: Dict[str, Any],
    approval_record: Dict[str, Any],
    repo_pr_path: str,
    backstage_template_path: str,
) -> Dict[str, Any]:
    product = ProductRequest.model_validate(product_spec["product_spec"]["product"])
    ArchitectureSpec.model_validate(architecture_spec["architecture_spec"])
    SecurityProfile.model_validate(security_profile["security_profile"])
    IaCPlan.model_validate(iac_plan["iac_plan"])
    QASummary.model_validate(qa_summary["qa_summary"])

    slug = product.product_name.lower().replace(" ", "-")
    bundle_root = f"artifacts/evidence/bundles/{slug}"

    items: List[EvidenceItem] = [
        EvidenceItem(type="jsonl", path="artifacts/evidence/runs/ProductManager.jsonl", description="Product decisions"),
        EvidenceItem(type="jsonl", path="artifacts/evidence/runs/CloudArchitect.jsonl", description="Architecture decisions"),
        EvidenceItem(type="jsonl", path="artifacts/evidence/runs/SecurityCompliance.jsonl", description="Security decisions"),
        EvidenceItem(type="jsonl", path="artifacts/evidence/runs/IaCEngineer.jsonl", description="IaC plan"),
        EvidenceItem(type="jsonl", path="artifacts/evidence/runs/QA.jsonl", description="QA summary"),
        EvidenceItem(type="jsonl", path="artifacts/evidence/runs/Approvals.jsonl", description="Approvals"),
    ]

    record = EvidenceRecord(
        product_name=product.product_name,
        bundle_path=bundle_root,
        items=items,
        repo_pr_path=repo_pr_path,
        backstage_template_path=backstage_template_path,
        status="ready-for-review",
    )

    result = {
        "repo_pr_path": repo_pr_path,
        "backstage_template_path": backstage_template_path,
        "evidence_bundle_path": bundle_root,
        "evidence_record": to_safe_dict(record),
    }
    log_node_event("EvidenceSink", result)
    return result
