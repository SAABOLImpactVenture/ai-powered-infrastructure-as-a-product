from typing import Any, Dict, List

from .common_types import (
    ArchitectureSpec,
    SecurityProfile,
    SecurityGuardrail,
    DataClassification,
    to_safe_dict,
)
from .evidence_logging import log_node_event


def _families(dc: DataClassification) -> List[str]:
    if dc in ("sensitive", "restricted"):
        return ["AC", "AU", "CM", "CP", "IA", "SC", "SI"]
    if dc == "internal":
        return ["AC", "AU", "CM", "CP", "SC"]
    return ["AC", "AU", "SC"]


def run(architecture_spec: Dict[str, Any], data_classification: str) -> Dict[str, Any]:
    spec = ArchitectureSpec.model_validate(architecture_spec["architecture_spec"])
    dc = DataClassification(data_classification)

    guardrails: List[SecurityGuardrail] = []
    for family in _families(dc):
        if family == "SC":
            guardrails.append(
                SecurityGuardrail(
                    id="sc-encryption-at-rest",
                    description="All stateful services must enforce encryption at rest.",
                    control_family="SC",
                    required=True,
                    configuration_ref="policy:encryption-at-rest",
                )
            )
        if family == "AC":
            guardrails.append(
                SecurityGuardrail(
                    id="ac-least-privilege",
                    description="Access to infra products uses least‑privilege RBAC tied to Entra groups.",
                    control_family="AC",
                    required=True,
                    configuration_ref="policy:rbac-least-privilege",
                )
            )

    profile = SecurityProfile(
        product=spec.product,
        architecture=spec,
        data_classification=dc,
        guardrails=guardrails,
        logging_standards=["All control and data planes send logs to central SIEM."],
        encryption_standards=["AES‑256 at rest", "TLS 1.2+ in transit"],
        network_segmentation_model="hub-spoke-with-zero-trust-segmentation",
    )

    result = {"security_profile": to_safe_dict(profile)}
    log_node_event("SecurityCompliance", result)
    return result
