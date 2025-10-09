from __future__ import annotations
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.get("/health")
def health():
    return jsonify({"status": "ok"}), 200

@app.post("/evidence")
def evidence():
    data = request.get_json(silent=True) or {}
    import json, time, pathlib
    outdir = pathlib.Path(".local-outbox"); outdir.mkdir(exist_ok=True)
    fp = outdir / f"mock-server-evidence-{int(time.time())}.json"
    fp.write_text(json.dumps(data, indent=2))
    return jsonify({"received": True, "path": str(fp)}), 200

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=False)
