# Sign Class (C13)

Three-way sign classification as a 2.0.3 `sley-agent` composed example:
`(x) -> Sign`, the first composed example returning a bare variant via
the `return` terminator.
See `contract.md` for arm semantics and evaluation order,
`modifications.md` for the worked missing-zero-arm fix.

## Reproduce from this directory (needs the 2.0.3 agent binary)

```sh
AGENT=/path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
rm -rf /tmp/c13 && mkdir -p /tmp/c13
cp packs/sign-committed.pack /tmp/c13/base.pack
cp packs/names.json /tmp/c13/names.json
"$AGENT" test --workspace /tmp/c13          # workbench checks: 7/7
python3 tests/check_external.py --agent "$AGENT" --workspace /tmp/c13  # 7/7
```

Or run all composed examples at once: `../reproduce.sh --agent "$AGENT"`.

## Contents

- `contract.md` — signature, arm semantics, variant encoding.
- `frames/sign-v1.json` — initial authoring frame as run (two-way split, 3 tests).
- `frames/sign-v2.json` — full replacement frame layered on the v1 draft (nested zero check, 7 tests).
- `frames/sign-code.json` — final code as committed (transaction `ee5d5dc5`).
- `frames/sign-tests.json` — final tests as committed (transaction `18fffc7b`).
- `tests/cases.json` — 7 independently expected cases.
- `tests/check_external.py` — external assertions, 7/7 at commit time.
- `views/` — readable workbench view of the committed function.
- `packs/sign-committed.pack` + `packs/names.json` — export + author name
  map needed for `view`/`call` in a fresh workspace.
- `modifications.md` — before/after inputs and observed results.

Persistence: combined code+tests commit refused
(`TXN_TEST_EVIDENCE_UNSUPPORTED`); committed split as code-only `ee5d5dc5`
then tests-after `18fffc7b`. Native test admission: not run — unavailable
in 2. Neither the workbench checks nor the external assertions are test
admission.
