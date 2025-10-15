#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import time
import uuid
from importlib import import_module
from pathlib import Path


def _dump_payload(out: Path | str, prefix: str, payload: dict) -> Path:
    """Write payload to out/prefix-<epoch>.json and return the Path."""
    import json as _json
    import pathlib as _pl
    import time as _time

    out_path = _pl.Path(out)
    out_path.mkdir(exist_ok=True)
    fp = out_path / f"{prefix}-{int(_time.time())}.json"
    fp.write_text(_json.dumps(payload, indent=2))
    return fp


def local_write(prefix: str, payload: dict) -> str:
    out = Path(".local-outbox")
    fp = _dump_payload(out, prefix, payload)
    return str(fp)


def emit(payload: dict) -> None:
    ws = os.environ.get("LA_WORKSPACE_ID")
    key = os.environ.get("LA_SHARED_KEY")
    log_type = os.environ.get("LA_LOG_TYPE") or "AoaiRequests_CL"
    endpoint = os.environ.get("LA_ENDPOINT")

    if ws and key:
        emitter = import_module("scripts.emitters.infra-evidence.emit_evidence_to_log_analytics")
        body = json.dumps([payload])
        status = emitter.send_to_log_analytics(ws, key, log_type, body, endpoint=endpoint)
        print(json.dumps({"mode": "cloud", "status": status, "payload": payload}, indent=2))
    else:
        path = local_write("aoai-request", payload)
        print(json.dumps({"mode": "local", "path": path, "payload": payload}, indent=2))


def main() -> None:
    parser = argparse.ArgumentParser(description="Emit AOAI request payload to LA or local file.")
    parser.add_argument("--input", help="Path to JSON payload file")
    args = parser.parse_args()

    if args.input:
        payload = json.loads(Path(args.input).read_text())
    else:
        payload = {"id": str(uuid.uuid4()), "ts": int(time.time())}

    emit(payload)


if __name__ == "__main__":
    main()
