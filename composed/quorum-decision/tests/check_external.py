#!/usr/bin/env python3
"""External assertions for quorum-decision (final v2 policy).

Invokes `sley-agent call` per case in tests/cases.json against the given
workspace and compares against the independently listed expectations.
Exits nonzero on any mismatch.

Cases identical to frames/quorum-tests.json as committed.
"""
import argparse
import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
FN = "quorum_decision"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--agent", required=True, help="path to sley-agent 2.0.3")
    ap.add_argument("--workspace", required=True)
    args = ap.parse_args()

    cases = json.loads((HERE / "cases.json").read_text())["cases"]
    fails = 0
    for case in cases:
        p = subprocess.run(
            [args.agent, "call", FN, *[str(a) for a in case["input"]],
             "--workspace", args.workspace],
            capture_output=True, text=True)
        try:
            observed = json.loads(p.stdout)
        except json.JSONDecodeError:
            observed = (f"NON-JSON rc={p.returncode} out={p.stdout!r} "
                        f"err={p.stderr!r}")
        ok = observed == case["expected"]
        fails += not ok
        print(("PASS " if ok else "FAIL "), case["id"], case["input"], "->",
              observed, "" if ok else f"(expected {case['expected']})")
    print(f"external: {len(cases) - fails}/{len(cases)} passed")
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
