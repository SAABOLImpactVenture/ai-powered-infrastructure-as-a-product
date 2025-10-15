import glob
import json
import os

from fastapi import FastAPI

app = FastAPI()


@app.get("/healthz")
def healthz():
    return {"ok": True}


@app.get("/evidence")
def evidence():
    files = glob.glob(os.path.join("evidence", "**", "*.json"), recursive=True)
    records = []
    for fp in files[:100]:
        try:
            with open(fp, "r") as f:
                records.append(json.load(f))
        except Exception:
            pass
    return {"count": len(records), "samples": records[:5]}
