from typing import Any, Dict, List

from .common_types import SecurityProfile, IaCPlan, IaCModuleRef, PolicyPackRef, to_safe_dict
from .evidence_logging import log_node_event


def run(security_profile: Dict[str, Any]) -> Dict[str, Any]:
    profile = SecurityProfile.model_validate(security_profile["security_profile"])

    modules: List[IaCModuleRef] = []
    policies: List[PolicyPackRef] = []

    for cloud in profile.product.target_clouds:
        modules.append(
            IaCModuleRef(
                id=f"{cloud}-secure-storage",
                cloud=cloud,
                path=f"cloud-packs/{cloud}/modules/secure-storage",
                description=f"Secure {cloud} storage with private endpoints.",
            )
        )
        policies.append(
            PolicyPackRef(
                id=f"{cloud}-baseline-guardrails",
                cloud=cloud,
                path=f"cloud-packs/{cloud}/policy/baseline-guardrails",
                description=f"Baseline {cloud} guardrails for encryption, tags, and no public storage.",
            )
        )

    plan = IaCPlan(
        product=profile.product,
        modules=modules,
        policies=policies,
        state_model="remote-state-with-workspaces",
        tagging_strategy={
            "owner": profile.product.business_owner,
            "product": profile.product.product_name,
            "classification": profile.data_classification,
            "managed-by": "ai-iaap-platform",
        },
    )

    result = {"iac_plan": to_safe_dict(plan)}
    log_node_event("IaCEngineer", result)
    return result
