from typing import Dict, List
from uuid import uuid4
from datetime import datetime, timezone

from jsonschema import validate


OSCAL_MINIMAL_SCHEMA = {
    "type": "object",
    "required": ["uuid", "metadata", "results"],
    "properties": {
        "uuid": {"type": "string"},
        "metadata": {
            "type": "object",
            "required": ["title", "version", "last-modified"],
        },
        "results": {"type": "array"},
    },
}


def build_assessment_results(system_id: str, qa_summary: Dict) -> Dict:
    now = datetime.now(timezone.utc).isoformat()
    assessment_uuid = str(uuid4())
    result_uuid = str(uuid4())

    findings: List[Dict] = []
    for case in qa_summary.get("test_cases", []):
        findings.append(
            {
                "uuid": str(uuid4()),
                "title": case["name"],
                "description": case["description"],
                "target": {"target-id": system_id},
                "remarks": f"type={case['type']}; mandatory={case['mandatory']}",
            }
        )

    doc = {
        "uuid": assessment_uuid,
        "metadata": {
            "title": f"QA Assessment Results for {system_id}",
            "version": "1.0.0",
            "last-modified": now,
        },
        "results": [
            {
                "uuid": result_uuid,
                "title": f"QA run for {system_id}",
                "start": now,
                "findings": findings,
            }
        ],
    }

    validate(instance=doc, schema=OSCAL_MINIMAL_SCHEMA)
    return doc
