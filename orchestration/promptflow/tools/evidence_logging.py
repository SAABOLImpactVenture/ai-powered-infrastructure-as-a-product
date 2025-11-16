import json
from pathlib import Path
from typing import Dict, Any


def _ensure_dir() -> Path:
    base = Path("artifacts") / "evidence" / "runs"
    base.mkdir(parents=True, exist_ok=True)
    return base


def log_node_event(node: str, payload: Dict[str, Any]) -> None:
    base = _ensure_dir()
    path = base / f"{node}.jsonl"
    record = {"node": node, "payload": payload}
    with path.open("a", encoding="utf-8") as f:
        f.write(json.dumps(record, sort_keys=True) + "\n")
