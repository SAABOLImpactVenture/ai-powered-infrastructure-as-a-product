#!/usr/bin/env python3
from __future__ import annotations

import argparse
import base64
import datetime as dt
import hashlib
import hmac
import json
import os
import pathlib
import sys
import time
import uuid

try:
    import requests  # type: ignore
except Exception:
    requests = None  # type: ignore

def build_signature(workspace_id: str, shared_key: str, date: str, content_length: int, method: str, content_type: str, resource: str) -> str:
    x_headers = f"x-ms-date:{date}"
    string_to_hash = f"{method}\n{content_length}\n{content_type}\n{x_headers}\n{resource}"
    bytes_to_hash = string_to_hash.encode("utf-8")
    decoded_key = base64.b64decode(shared_key)
    encoded_hash = base64.b64encode(hmac.new(decoded_key, bytes_to_hash, digestmod=hashlib.sha256).digest()).decode()
    return f"SharedKey {workspace_id}:{encoded_hash}"

def send_to_log_analytics(workspace_id: str, shared_key: str, log_type: str, body: str, endpoint: str | None = None):
    if requests is None:
        raise RuntimeError("requests module not available in this environment")
    resource = "/api/logs"
    endpoint = endpoint or f"https://{workspace_id}.ods.opinsights.azure.com{resource}?api-version=2016-04-01"
    rfc1123date = dt.datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT')
    signature = build_signature(workspace_id, shared_key, rfc1123date, len(body), 'POST', 'application/json', resource)
    headers = {'Content-Type': 'application/json','Authorization': signature,'Log-Type': log_type,'x-ms-date': rfc1123date}
    resp = requests.post(endpoint, data=body, headers=headers, timeout=30)
    if not (200 <= resp.status_code < 300):
        raise RuntimeError(f"Log Analytics ingestion failed: {resp.status_code} {resp.text}")
    return resp.status_code

def local_outbox_write(prefix: str, payload: dict) -> str:
    outdir = pathlib.Path(".local-outbox")
    outdir.mkdir(parents=True, exist_ok=True)
    fname = outdir / f"{prefix}-{int(time.time())}.json"
    fname.write_text(json.dumps(payload, indent=2))
    return str(fname)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--kind", required=True)
    ap.add_argument("--status", required=True)
    ap.add_argument("--detail", default="")
    ap.add_argument("--extra", default="")
    args = ap.parse_args()

    payload = {
        "id": str(uuid.uuid4()),
        "timestamp_utc": dt.datetime.utcnow().isoformat() + "Z",
        "kind": args.kind,
        "status": args.status,
        "detail": args.detail,
        "repo": "ai-powered-infrastructure-as-a-product-main",
        "workflow": os.environ.get("GITHUB_WORKFLOW", ""),
        "run_id": os.environ.get("GITHUB_RUN_ID", ""),
        "runner": os.environ.get("RUNNER_NAME", ""),
    }
    if args.extra:
        try:
            payload["extra"] = json.loads(args.extra)
        except json.JSONDecodeError:
            payload["extra"] = {"raw": args.extra}

    env = {k: os.environ.get(k) for k in ["LA_WORKSPACE_ID", "LA_SHARED_KEY", "LA_LOG_TYPE", "LA_ENDPOINT"]}
    log_type = env.get("LA_LOG_TYPE") or "IaapInfraEvidence_CL"
    body = json.dumps([payload])
    if env.get("LA_WORKSPACE_ID") and env.get("LA_SHARED_KEY"):
        status = send_to_log_analytics(env["LA_WORKSPACE_ID"], env["LA_SHARED_KEY"], log_type, body, endpoint=env.get("LA_ENDPOINT"))
        print(json.dumps({"mode": "cloud", "status": status, "payload": payload}, indent=2))
    else:
        path = local_outbox_write("infra-evidence", payload)
        print(json.dumps({"mode": "local", "saved": path, "payload": payload}, indent=2))

if __name__ == "__main__":
    main()
