from __future__ import annotations

import base64
import datetime as dt
import hashlib
import hmac
import requests  # type: ignore
from typing import Optional


def _build_signature(
    customer_id: str,
    shared_key: str,
    date: str,
    content_length: int,
    method: str,
    content_type: str,
    resource: str,
) -> str:
    x_headers = f"x-ms-date:{date}"
    string_to_hash = f"{method}\n{content_length}\n{content_type}\n{x_headers}\n{resource}"
    bytes_to_hash = string_to_hash.encode("utf-8")
    decoded_key = base64.b64decode(shared_key)
    hashed = hmac.new(decoded_key, bytes_to_hash, hashlib.sha256).digest()
    encoded_hash = base64.b64encode(hashed).decode()
    return f"SharedKey {customer_id}:{encoded_hash}"


def send_to_log_analytics(
    workspace_id: str, shared_key: str, log_type: str, body: str, endpoint: Optional[str] = None
) -> int:
    """
    Send a JSON payload (array of objects) to Log Analytics.
    Returns the HTTP status code.
    """
    resource = "/api/logs"
    method = "POST"
    content_type = "application/json"
    rfc1123date = dt.datetime.utcnow().strftime("%a, %d %b %Y %H:%M:%S GMT")
    content_length = len(body.encode("utf-8"))
    signature = _build_signature(
        workspace_id, shared_key, rfc1123date, content_length, method, content_type, resource
    )

    if not endpoint:
        endpoint = (
            f"https://{workspace_id}.ods.opinsights.azure.com{resource}?api-version=2016-04-01"
        )
    else:
        # Ensure the path and api-version exist
        if "api-version=" not in endpoint:
            sep = "&" if "?" in endpoint else "?"
            endpoint = f"{endpoint}{sep}api-version=2016-04-01"

    headers = {
        "Content-Type": content_type,
        "Authorization": signature,
        "Log-Type": log_type,
        "x-ms-date": rfc1123date,
    }

    resp = requests.post(endpoint, data=body, headers=headers, timeout=30)
    return resp.status_code
