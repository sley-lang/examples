# Window Overlap (C06)

Two-interval overlap measure as a 2.0.3 `sley-agent` composed example:
`(s1, e1, s2, e2) -> Result<(overlap,gap),WindowError>`.
See `contract.md` for max/min selection, the touching collapse, and error
precedence, `modifications.md` for the worked gap-negation fix.

## Reproduce from this directory (needs the 2.0.3 agent binary)

```sh
AGENT=/path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
rm -rf /tmp/c06 && mkdir -p /tmp/c06
cp packs/overlap-committed.pack /tmp/c06/base.pack
cp packs/names.json /tmp/c06/names.json
"$AGENT" test --workspace /tmp/c06          # workbench checks: 15/15
python3 tests/check_external.py --agent "$AGENT" --workspace /tmp/c06  # 15/15
```

Or run all composed examples at once: `../reproduce.sh --agent "$AGENT"`.

## Contents

- `contract.md` — signature, overlap/gap semantics, precedence.
- `frames/overlap-v1.json` — initial authoring frame as run (raw-difference gap, 14 tests).
- `frames/overlap-v2.json` — follow-up frame as run via `try --on`
  (negated gap, flipped expectations, added cases, 15 tests).
- `frames/overlap-code.json` — final code as committed (transaction `ff526edf`).
- `frames/overlap-tests.json` — final tests as committed (transaction `65a093d7`).
- `tests/cases.json` — 15 independently expected cases.
- `tests/check_external.py` — external assertions, 15/15 at commit time.
- `views/` — readable workbench view of the committed function.
- `packs/overlap-committed.pack` + `packs/names.json` — export + the
  workbench's author name map (`.sley/names.json` of the authoring
  workspace), needed for `view`/`call` in a fresh workspace.
- `modifications.md` — before/after inputs and observed results.

Persistence: code-only `ff526edf` then tests-after `65a093d7` via the
documented split route (combined code+tests commit is refused with
`TXN_TEST_EVIDENCE_UNSUPPORTED`, re-confirmed first-hand on the C04
content). Native test admission: not run — unavailable in 2.0. Neither
the workbench checks nor the external assertions are test admission.
