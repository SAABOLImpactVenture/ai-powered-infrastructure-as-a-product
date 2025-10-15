from __future__ import annotations

import os

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="Policy Evidence Adapter")

# Environment configuration
LAKE = os.getenv("LAKE", "adx")  # "adx" or "athena"

ADX_URI = os.getenv("ADX_URI")
ADX_DB = os.getenv("ADX_DB")
ADX_TOKEN = os.getenv("ADX_TOKEN")  # bearer token (use MSI/az in prod)

ATHENA_DB = os.getenv("ATHENA_DB")
ATHENA_TBL = os.getenv("ATHENA_TBL")
AWS_REGION = os.getenv("AWS_REGION", "us-east-1")


class Query(BaseModel):
    query: str


def agg_adx(q: Query) -> dict:
    # TODO: real ADX query
    if not (ADX_URI and ADX_DB and ADX_TOKEN):
        raise HTTPException(status_code=500, detail="ADX configuration is incomplete")
    return {"lake": "adx", "query": q.query, "status": "ok"}


def agg_athena(q: Query) -> dict:
    # TODO: real Athena query
    if not (ATHENA_DB and ATHENA_TBL and AWS_REGION):
        raise HTTPException(status_code=500, detail="Athena configuration is incomplete")
    return {"lake": "athena", "query": q.query, "status": "ok"}


@app.post("/aggregate")
def aggregate(q: Query):
    if LAKE == "adx":
        return agg_adx(q)
    elif LAKE == "athena":
        return agg_athena(q)
    raise HTTPException(status_code=500, detail="Unsupported lake")


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        app,
        host="0.0.0.0",
        port=int(os.getenv("PORT", "8000")),
    )
