#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import pathlib
import time
import uuid

try:
    import requests  # type: ignore
except Exception:
    requests = None  # type: ignore

from importlib import import_module
from pathlib import Path


def local_write(prefix: str, payload: dict) -> str:
    out = Path(".local-outbox"); out.mkdir(exist_ok=True)
    fp = out / f"{prefix}-{int(time.time())}.json"
    fp.write_text(json.dumps(payload, indent=2))
    return str(fp)

def emit(payload: dict):
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
        path = local_write("aoai-requests", payload)
        print(json.dumps({"mode": "local", "saved": path, "payload": payload}, indent=2))

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--operation", default="inference")
    ap.add_argument("--model", default="gpt-4o-mini")
    ap.add_argument("--latency_ms", type=int, default=120)
    ap.add_argument("--status", default="success")
    ap.add_argument("--tokens_in", type=int, default=0)
    ap.add_argument("--tokens_out", type=int, default=0)
    ap.add_argument("--user_id", default="")
    ap.add_argument("--correlation_id", default="")
    args = ap.parse_args()

    payload = {
        "id": str(uuid.uuid4()),
        "timestamp_utc": dt.datetime.utcnow().isoformat() + "Z",
        "operation": args.operation,
        "model": args.model,
        "latency_ms": args.latency_ms,
        "status": args.status,
        "tokens": {"input": args.tokens_in, "output": args.tokens_out},
        "user_id": args.user_id,
        "correlation_id": args.correlation_id or str(uuid.uuid4()),
    }
    emit(payload)

if __name__ == "__main__":
    main()
