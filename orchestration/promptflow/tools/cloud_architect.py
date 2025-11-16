from typing import Any, Dict, List

from .common_types import ArchitectureSpec, ArchitectureComponent, to_safe_dict
from .evidence_logging import log_node_event


def run(product_spec: Dict[str, Any]) -> Dict[str, Any]:
    spec = ArchitectureSpec.model_validate(product_spec["product_spec"])

    refined: List[ArchitectureComponent] = []
    for comp in spec.components:
        deps = list(dict.fromkeys(comp.dependencies + ["shared-observability"])) if comp.tier == "data-plane" else comp.dependencies
        refined.append(
            ArchitectureComponent(
                name=comp.name,
                responsibility=comp.responsibility,
                cloud=comp.cloud,
                tier=comp.tier,
                dependencies=deps,
            )
        )

    new_spec = ArchitectureSpec(
        product=spec.product,
        components=refined,
        shared_services=sorted(set(spec.shared_services + ["shared-observability"])),
        slo=spec.slo,
        assumptions=spec.assumptions,
        decisions=spec.decisions + ["Shared observability is mandatory for all execution planes."],
    )

    result = {"architecture_spec": to_safe_dict(new_spec)}
    log_node_event("CloudArchitect", result)
    return result
