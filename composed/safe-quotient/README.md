# Safe Quotient (C11)

Guarded truncating division as a 2.0.3 `sley-agent` composed example:
`(num, den) -> Result<i64,QuotientError>`.
See `contract.md` for guard semantics and error precedence,
`modifications.md` for the worked guard-reorder fix.

## Reproduce from this directory (needs the 2.0.3 agent binary)

```sh
AGENT=/path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
rm -rf /tmp/c11 && mkdir -p /tmp/c11
cp packs/quotient-committed.pack /tmp/c11/base.pack
cp packs/names.json /tmp/c11/names.json
"$AGENT" test --workspace /tmp/c11          # workbench checks: 8/8
python3 tests/check_external.py --agent "$AGENT" --workspace /tmp/c11  # 8/8
```

Or run all composed examples at once: `../reproduce.sh --agent "$AGENT"`.

## Contents

- `contract.md` — signature, guard/divide semantics, precedence.
- `frames/quotient-v1.json` — initial authoring frame as run (division before guard, 7 tests).
- `frames/quotient-v2.json` — full replacement frame layered on the v1 draft (guard before division, 8 tests).
- `frames/quotient-code.json` — final code as committed (transaction `80fabe7a`).
- `frames/quotient-tests.json` — final tests as committed (transaction `845d1de9`).
- `tests/cases.json` — 8 independently expected cases.
- `tests/check_external.py` — external assertions, 8/8 at commit time.
- `views/` — readable workbench view of the committed function.
- `packs/quotient-committed.pack` + `packs/names.json` — export + author name
  map needed for `view`/`call` in a fresh workspace.
- `modifications.md` — before/after inputs and observed results.

Persistence: combined code+tests commit refused
(`TXN_TEST_EVIDENCE_UNSUPPORTED`); committed split as code-only `80fabe7a`
then tests-after `845d1de9`. Native test admission: not run — unavailable
in 2. Neither the workbench checks nor the external assertions are test
admission.
