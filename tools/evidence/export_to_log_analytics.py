#!/usr/bin/env python3
import base64
import hashlib
import hmac
import json
import os
import sys
import time

import requests

# Inputs: LOG_ID, LOG_KEY, LOG_TYPE, EVIDENCE_DIR
ws = os.environ["LOG_ID"]; key = os.environ["LOG_KEY"]; logtype = os.environ.get("LOG_TYPE","Evidence")
evidence_dir = sys.argv[1] if len(sys.argv)>1 else "evidence"
def build_sig(date, content_length, method="POST", content_type="application/json", resource="/api/logs"):
    x_headers = 'x-ms-date:' + date
    string_to_hash = method + "
" + str(content_length) + "
" + content_type + "
" + x_headers + "
" + resource
    bytes_to_hash = bytes(string_to_hash, encoding="utf-8")
    decoded_key = base64.b64decode(key)
    encoded_hash = base64.b64encode(hmac.new(decoded_key, bytes_to_hash, digestmod=hashlib.sha256).digest()).decode()
    return f"SharedKey {ws}:{encoded_hash}"
def post_records(body):
    rfc1123date = time.strftime('%a, %d %b %Y %H:%M:%S GMT', time.gmtime())
    sig = build_sig(rfc1123date, len(body))
    headers = {'content-type':'application/json','Authorization':sig,'Log-Type':logtype,'x-ms-date':rfc1123date}
    resp = requests.post(f"https://{ws}.ods.opinsights.azure.com/api/logs?api-version=2016-04-01", data=body, headers=headers, timeout=30)
    resp.raise_for_status()
acc=[]
for root,_,files in os.walk(evidence_dir):
    for f in files:
        if f.endswith(".json"):
            p = os.path.join(root,f)
            try:
                doc = json.load(open(p))
                doc["_path"]=p; acc.append(doc)
            except Exception as e:
                print("skip",p,e)
if acc:
    post_records(json.dumps(acc))
    print("Uploaded", len(acc), "records")
else:
    print("No records found")
