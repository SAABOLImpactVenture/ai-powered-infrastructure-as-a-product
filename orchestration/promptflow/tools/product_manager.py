from typing import Any, Dict, List

from .common_types import ProductRequest, ArchitectureSpec, ArchitectureComponent, SLO, to_safe_dict
from .evidence_logging import log_node_event


def _default_description(name: str) -> str:
    return (
        f"Infrastructure product '{name}' provisions secure, opinionated cloud resources "
        "for regulated workloads, exposed via Backstage templates."
    )


def run(
    product_name: str,
    target_clouds: List[str],
    data_classification: str,
    rto_target: int,
    rpo_target: int,
) -> Dict[str, Any]:
    req = ProductRequest(
        product_name=product_name,
        target_clouds=target_clouds,  # type: ignore[arg-type]
        data_classification=data_classification,  # type: ignore[arg-type]
        rto_target=rto_target,
        rpo_target=rpo_target,
        description=_default_description(product_name),
    )

    slo = SLO(
        rto_minutes=req.rto_target,
        rpo_minutes=req.rpo_target,
        availability_percentage=99.9 if req.data_classification in ("sensitive", "restricted") else 99.5,
    )

    components = []
    for cloud in req.target_clouds:
        components.append(
            ArchitectureComponent(
                name=f"{cloud}-control-plane",
                responsibility=f"Registers and governs resources for {req.product_name} on {cloud}.",
                cloud=cloud,  # type: ignore[arg-type]
                tier="control-plane",
                dependencies=[],
            )
        )
        components.append(
            ArchitectureComponent(
                name=f"{cloud}-data-plane",
                responsibility=f"Hosts data and app-facing infra for {req.product_name} on {cloud}.",
                cloud=cloud,  # type: ignore[arg-type]
                tier="data-plane",
                dependencies=[f"{cloud}-control-plane"],
            )
        )

    spec = ArchitectureSpec(
        product=req,
        components=components,
        shared_services=["central-logging", "central-monitoring", "identity-provider"],
        slo=slo,
        assumptions=[
            "Identity is centralised in Entra ID with federated roles into each cloud.",
            "All workloads are on boarded through Backstage templates.",
        ],
        decisions=["Azure remains the authoritative control plane for policy and monitoring."],
    )

    result = {"product_spec": to_safe_dict(spec)}
    log_node_event("ProductManager", result)
    return result
