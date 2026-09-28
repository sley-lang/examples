# Ledger Post (C05)

Two-sided balance posting as a 2.0.3 `sley-agent` composed example:
`(balance, debit, credit, overdraft) -> Result<i64,LedgerError>`.
See `contract.md` for flow/floor semantics and error precedence,
`modifications.md` for the worked `le` → `lt` floor fix.

## Reproduce from this directory (needs the 2.0.3 agent binary)

```sh
AGENT=/path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
rm -rf /tmp/c05 && mkdir -p /tmp/c05
cp packs/ledger-committed.pack /tmp/c05/base.pack
cp packs/names.json /tmp/c05/names.json
"$AGENT" test --workspace /tmp/c05          # workbench checks: 15/15
python3 tests/check_external.py --agent "$AGENT" --workspace /tmp/c05  # 15/15
```

Or run all composed examples at once: `../reproduce.sh --agent "$AGENT"`.

## Contents

- `contract.md` — signature, two-sided flow, floor policy, precedence.
- `frames/ledger-v1.json` — initial authoring frame as run (`le` floor, 14 tests).
- `frames/ledger-v2.json` — follow-up frame as run via `try --on`
  (`lt` floor, flipped expectations, added extreme case, 15 tests).
- `frames/ledger-code.json` — final code as committed (transaction `84d85be1`).
- `frames/ledger-tests.json` — final tests as committed (transaction `235440e4`).
- `tests/cases.json` — 15 independently expected cases.
- `tests/check_external.py` — external assertions, 15/15 at commit time.
- `views/` — readable workbench view of the committed function.
- `packs/ledger-committed.pack` + `packs/names.json` — export + the
  workbench's author name map (`.sley/names.json` of the authoring
  workspace), needed for `view`/`call` in a fresh workspace.
- `modifications.md` — before/after inputs and observed results.

Persistence: code-only `84d85be1` then tests-after `235440e4` via the
documented split route (combined code+tests commit is refused with
`TXN_TEST_EVIDENCE_UNSUPPORTED`, re-confirmed first-hand on the C04
content). Native test admission: not run — unavailable in 2.0. Neither
the workbench checks nor the external assertions are test admission.
