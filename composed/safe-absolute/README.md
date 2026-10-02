# Safe Absolute (C12)

Checked magnitude as a 2.0.3 `sley-agent` composed example:
`(x) -> Result<i64,AbsError>`.
See `contract.md` for branch semantics, `modifications.md` for the
worked unconditional-negate fix.

## Reproduce from this directory (needs the 2.0.3 agent binary)

```sh
AGENT=/path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
rm -rf /tmp/c12 && mkdir -p /tmp/c12
cp packs/abs-committed.pack /tmp/c12/base.pack
cp packs/names.json /tmp/c12/names.json
"$AGENT" test --workspace /tmp/c12          # workbench checks: 8/8
python3 tests/check_external.py --agent "$AGENT" --workspace /tmp/c12  # 8/8
```

Or run all composed examples at once: `../reproduce.sh --agent "$AGENT"`.

## Contents

- `contract.md` — signature, branch/negate semantics.
- `frames/abs-v1.json` — initial authoring frame as run (unconditional negate, 6 tests).
- `frames/abs-v2.json` — full replacement frame layered on the v1 draft (sign branch, 8 tests).
- `frames/abs-code.json` — final code as committed (transaction `0f217af2`).
- `frames/abs-tests.json` — final tests as committed (transaction `a2d6cd98`).
- `tests/cases.json` — 8 independently expected cases.
- `tests/check_external.py` — external assertions, 8/8 at commit time.
- `views/` — readable workbench view of the committed function.
- `packs/abs-committed.pack` + `packs/names.json` — export + author name
  map needed for `view`/`call` in a fresh workspace.
- `modifications.md` — before/after inputs and observed results.

Persistence: combined code+tests commit refused
(`TXN_TEST_EVIDENCE_UNSUPPORTED`); committed split as code-only `0f217af2`
then tests-after `a2d6cd98`. Native test admission: not run — unavailable
in 2. Neither the workbench checks nor the external assertions are test
admission.
