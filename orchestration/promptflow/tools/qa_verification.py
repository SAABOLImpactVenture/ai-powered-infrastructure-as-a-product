from typing import Any, Dict, List, Optional

from .common_types import IaCPlan, QASummary, TestCase, to_safe_dict
from .evidence_logging import log_node_event


def _tests_for_plan(plan: IaCPlan) -> List[TestCase]:
    tests: List[TestCase] = []
    for mod in plan.modules:
        tests.append(
            TestCase(
                id=f"unit-{mod.id}",
                name=f"Unit tests for {mod.id}",
                description=f"Terraform validate and plan for module {mod.id}.",
                type="unit",
                mandatory=True,
            )
        )
    for pol in plan.policies:
        tests.append(
            TestCase(
                id=f"policy-{pol.id}",
                name=f"Policy pack {pol.id} enforcement",
                description=f"Verify {pol.id} denies non‑compliant configs.",
                type="policy",
                mandatory=True,
            )
        )
    return tests


def run(
    iac_plan: Optional[Dict[str, Any]] = None,
    qa_summary: Optional[Dict[str, Any]] = None,
    repo_pr_path: str = "",
    backstage_template_path: str = "",
) -> Dict[str, Any]:
    if iac_plan is not None:
        plan = IaCPlan.model_validate(iac_plan["iac_plan"])
        tests = _tests_for_plan(plan)
        qa = QASummary(
            product=plan.product,
            test_cases=tests,
            acceptance_criteria=[
                "All mandatory tests succeed in CI.",
                "Policy packs block non‑compliant plans in pre‑prod.",
            ],
            risk_summary="Residual risk acceptable for controlled rollout.",
            status="ready-for-approval",
        )
        result = {"qa_summary": to_safe_dict(qa)}
        log_node_event("QA", result)
        return result

    if qa_summary is not None:
        # Record approval
        approved = dict(qa_summary["qa_summary"])
        approved["status"] = "approved"
        record = {
            "approval_record": {
                "qa_summary": approved,
                "repo_pr_path": repo_pr_path,
                "backstage_template_path": backstage_template_path,
                "decision": "approved",
            }
        }
        log_node_event("Approvals", record)
        return record

    raise ValueError("qa_verification.run requires iac_plan or qa_summary.")
