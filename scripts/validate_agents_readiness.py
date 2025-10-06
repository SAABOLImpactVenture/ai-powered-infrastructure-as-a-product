#!/usr/bin/env python3
from __future__ import annotations
import json, os, shutil, sys, subprocess, time
from dataclasses import dataclass, asdict
from typing import Optional, List

REQUIRED_CMDS = ["python", "pip", "terraform"]
OPTIONAL_CMDS = ["docker", "git", "curl"]

@dataclass
class CheckResult:
    name: str
    ok: bool
    version: Optional[str] = None
    detail: Optional[str] = None

def which_ver(cmd: str) -> CheckResult:
    path = shutil.which(cmd)
    if not path:
        return CheckResult(name=cmd, ok=False, detail="Not found on PATH")
    for flag in ("--version", "-v", "version"):
        try:
            out = subprocess.check_output([cmd, flag], stderr=subprocess.STDOUT, text=True, timeout=10)
            return CheckResult(name=cmd, ok=True, version=out.strip())
        except Exception:
            continue
    return CheckResult(name=cmd, ok=True, version="(unknown)")

def check_python():
    return CheckResult(name="python-runtime", ok=True, version=sys.version.split()[0])

def main():
    strict = "--strict" in sys.argv
    results: List[CheckResult] = []
    results.append(check_python())
    for cmd in REQUIRED_CMDS:
        if cmd == "python":
            continue
        results.append(which_ver(cmd))
    for cmd in OPTIONAL_CMDS:
        results.append(which_ver(cmd))
    ok = all(r.ok for r in results if r.name in REQUIRED_CMDS or r.name == "python-runtime")
    summary = {
        "timestamp": int(time.time()),
        "strict": strict,
        "overall_ok": ok if not strict else ok and all(r.ok for r in results),
        "results": [asdict(r) for r in results],
    }
    print(json.dumps(summary, indent=2))
    if not summary["overall_ok"]:
        sys.exit(1)

if __name__ == "__main__":
    main()
