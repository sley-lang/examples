# Clamp Value (C10)

Closed-interval clamp as a 2.0.3 `sley-agent` composed example:
`(value, lo, hi) -> Result<i64,ClampError>`.
See `contract.md` for bound semantics and error precedence,
`modifications.md` for the worked reject → clamp policy change.

## Reproduce from this directory (needs the 2.0.3 agent binary)

```sh
AGENT=/path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
rm -rf /tmp/c10 && mkdir -p /tmp/c10
cp packs/clamp-committed.pack /tmp/c10/base.pack
cp packs/names.json /tmp/c10/names.json
"$AGENT" test --workspace /tmp/c10          # workbench checks: 10/10
python3 tests/check_external.py --agent "$AGENT" --workspace /tmp/c10  # 10/10
```

Or run all composed examples at once: `../reproduce.sh --agent "$AGENT"`.

## Contents

- `contract.md` — signature, bound/range semantics, precedence.
- `frames/clamp-v1.json` — initial authoring frame as run (reject policy, 8 tests).
- `frames/clamp-v2.json` — full replacement frame layered on the v1 draft (clamp policy, 10 tests).
- `frames/clamp-code.json` — final code as committed (transaction `e746a959`).
- `frames/clamp-tests.json` — final tests as committed (transaction `339f4e52`).
- `tests/cases.json` — 10 independently expected cases.
- `tests/check_external.py` — external assertions, 10/10 at commit time.
- `views/` — readable workbench view of the committed function.
- `packs/clamp-committed.pack` + `packs/names.json` — export + author name
  map needed for `view`/`call` in a fresh workspace.
- `modifications.md` — before/after inputs and observed results.

Persistence: combined code+tests commit refused
(`TXN_TEST_EVIDENCE_UNSUPPORTED`); committed split as code-only `e746a959`
then tests-after `339f4e52`. Native test admission: not run — unavailable
in 2.0. Neither the workbench checks nor the external assertions are test
admission.
