from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os, json, requests, boto3

app = FastAPI(title="Policy Evidence Adapter")

class Query(BaseModel):
    kind: str | None = None
    status: str | None = None
    days: int = 30

LAKE = os.getenv("EVIDENCE_LAKE", "adx")  # 'adx' or 'athena'

# ADX settings
ADX_URI = os.getenv("ADX_URI")  # https://<cluster>.<region>.kusto.windows.net
ADX_DB  = os.getenv("ADX_DB")
ADX_TOKEN = os.getenv("ADX_TOKEN")  # bearer token; or use msi/az cli in prod

# Athena settings
ATHENA_DB   = os.getenv("ATHENA_DB")
ATHENA_TBL  = os.getenv("ATHENA_TBL")
AWS_REGION  = os.getenv("AWS_REGION", "us-east-1")

@app.post("/aggregate")
def aggregate(q: Query):
    if LAKE == "adx":
        return agg_adx(q)
    elif LAKE == "athena":
        return agg_athena(q)
    raise HTTPException(500, "Unsupported lake")

def agg_adx(q: Query):
    if not (ADX_URI and ADX_DB and ADX_TOKEN):
        raise HTTPException(500, "ADX configuration missing")
    kql = f"Evidence | where timestamp > ago({q.days}d)"
    if q.kind:   kql += f" | where kind == '{q.kind}'"
    if q.status: kql += f" | where status == '{q.status}'"
    kql += " | summarize count() by status, kind"
    payload = { "db": ADX_DB, "csl": kql }
    r = requests.post(f"{ADX_URI}/v1/rest/query", json=payload, headers={"Authorization": f"Bearer {ADX_TOKEN}"})
    if r.status_code != 200:
        raise HTTPException(r.status_code, r.text)
    data = r.json()
    # Simplify ADX result
    tables = data.get("Tables", [])
    rows = tables[0].get("Rows", []) if tables else []
    return [{"status": r[0], "kind": r[1], "count": r[2]} for r in rows]

def agg_athena(q: Query):
    if not (ATHENA_DB and ATHENA_TBL):
        raise HTTPException(500, "Athena configuration missing")
    client = boto3.client("athena", region_name=AWS_REGION)
    where = []
    if q.kind: where.append(f"kind = '{q.kind}'")
    if q.status: where.append(f"status = '{q.status}'")
    where.append("from_iso8601_timestamp(timestamp) > current_timestamp - interval '%d' day" % q.days)
    sql = f"SELECT status, kind, count(1) as cnt FROM {ATHENA_DB}.{ATHENA_TBL} WHERE " + " AND ".join(where) + " GROUP BY status, kind"
    res = client.start_query_execution(
        QueryString=sql,
        ResultConfiguration={"OutputLocation": os.getenv("ATHENA_OUTPUT","s3://tmp-athena-results/")},
    )
    qid = res["QueryExecutionId"]
    # NOTE: In production poll for completion; simplified here to return the query id.
    return {"athena_query_id": qid}
