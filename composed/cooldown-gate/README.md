# Cooldown Gate (C08)

Circuit-breaker gate as a 2.0.3 `sley-agent` composed example:
`(failures, threshold, now, tripped_at, cooldown) -> Result<(GateState,i64),GateError>`.
See `contract.md` for the Closed/Open/HalfOpen policy, remaining-time
semantics, and error precedence, `modifications.md` for the worked
remaining-time fix.

## Reproduce from this directory (needs the 2.0.3 agent binary)

```sh
AGENT=/path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
rm -rf /tmp/c08 && mkdir -p /tmp/c08
cp packs/gate-committed.pack /tmp/c08/base.pack
cp packs/names.json /tmp/c08/names.json
"$AGENT" test --workspace /tmp/c08          # workbench checks: 15/15
python3 tests/check_external.py --agent "$AGENT" --workspace /tmp/c08  # 15/15
```

Or run all composed examples at once: `../reproduce.sh --agent "$AGENT"`.

## Contents

- `contract.md` — signature, gate/remaining semantics, precedence.
- `frames/gate-v1.json` — initial authoring frame as run (elapsed as
  remaining, 13 tests).
- `frames/gate-v2.json` — follow-up frame as run via `try --on`
  (remaining subtraction, flipped expectations, added cases, 15 tests).
- `frames/gate-code.json` — final code as committed (transaction `3be8a5b0`).
- `frames/gate-tests.json` — final tests as committed (transaction `b4e51dd4`).
- `tests/cases.json` — 15 independently expected cases.
- `tests/check_external.py` — external assertions, 15/15 at commit time.
- `views/` — readable workbench view of the committed function.
- `packs/gate-committed.pack` + `packs/names.json` — export + the
  workbench's author name map (`.sley/names.json` of the persistence
  workspace), needed for `view`/`call` in a fresh workspace.
- `modifications.md` — before/after inputs and observed results.

Persistence: code-only `3be8a5b0` then tests-after `b4e51dd4` via the
documented split route (combined code+tests commit is refused with
`TXN_TEST_EVIDENCE_UNSUPPORTED`, re-confirmed first-hand on this
content). Native test admission: not run — unavailable in 2.0. Neither
the workbench checks nor the external assertions are test admission.
