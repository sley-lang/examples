# Duration Breakdown (C03)

Checked seconds→(days, hours, minutes, seconds) decomposition as a 2.0.3
`sley-agent` composed example:
`(total_seconds) -> Result<(i64, i64, i64, i64), DurationError>`.
See `contract.md` for parameter semantics and error precedence,
`modifications.md` for the worked days-layer extension.

## Reproduce from this directory (needs the 2.0.3 agent binary)

```sh
AGENT=/path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
rm -rf /tmp/c03 && mkdir -p /tmp/c03
cp packs/duration-committed.pack /tmp/c03/base.pack
cp packs/names.json /tmp/c03/names.json
"$AGENT" test --workspace /tmp/c03          # workbench checks: 9/9
python3 tests/check_external.py --agent "$AGENT" --workspace /tmp/c03  # 9/9
```

Or run all six composed examples at once: `../reproduce.sh --agent "$AGENT"`.

## Contents

- `contract.md` — signature, parameter semantics, error precedence.
- `frames/duration-v1.json` — initial authoring frame as run (3-tuple, 12 tests).
- `frames/duration-v2.json` — full replacement frame as run (4-tuple, 9 tests).
- `frames/duration-code.json` — final code as committed (transaction `fb236485`).
- `frames/duration-tests.json` — final tests as committed (transaction `a94779c9`).
- `tests/cases.json` — 9 independently expected cases.
- `tests/check_external.py` — external assertions, 9/9 at commit time.
- `views/` — readable workbench view of the committed function.
- `packs/duration-committed.pack` + `packs/names.json` — export + author name
  map needed for `view`/`call` in a fresh workspace.
- `modifications.md` — before/after inputs and observed results.

Persistence: combined code+tests commit refused
(`TXN_TEST_EVIDENCE_UNSUPPORTED`); committed split as code-only `fb236485`
then tests-after `a94779c9`. Native test admission: not run — unavailable
in 2.0. Neither the workbench checks nor the external assertions are test
admission.
