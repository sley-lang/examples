# Retry Decision (C01)

Bounded-retry policy as a 2.0.3 `sley-agent` composed example:
`(attempt, limit) -> Result<RetryState, RetryError>`.
See `contract.md` for parameter semantics and error precedence,
`modifications.md` for the worked `lt` → `le` policy change.

## Reproduce from this directory (needs the 2.0.3 agent binary)

```sh
AGENT=/path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
rm -rf /tmp/c01 && mkdir -p /tmp/c01
cp packs/retry-committed.pack /tmp/c01/base.pack
cp packs/names.json /tmp/c01/names.json
"$AGENT" test --workspace /tmp/c01          # workbench checks: 11/11
python3 tests/check_external.py --agent "$AGENT" --workspace /tmp/c01  # 11/11
```

Or run all three examples at once: `../reproduce.sh --agent "$AGENT"`.

## Contents

- `contract.md` — signature, attempt/limit semantics, precedence.
- `frames/retry-v1.json` — initial authoring frame as run (`lt` policy, 10 tests).
- `frames/retry-fix1.json` — retained repair delta for the policy edit.
- `frames/retry-code.json` — final code as committed (transaction `96994710`).
- `frames/retry-tests.json` — final tests as committed (transaction `8e8e8384`).
- `tests/cases.json` — 11 independently expected cases.
- `tests/check_external.py` — external assertions, 11/11 at commit time.
- `views/` — readable workbench view of the committed function.
- `packs/retry-committed.pack` + `packs/names.json` — export + author name
  map needed for `view`/`call` in a fresh workspace.
- `modifications.md` — before/after inputs and observed results.

Persistence: combined code+tests commit refused
(`TXN_TEST_EVIDENCE_UNSUPPORTED`); committed split as code-only `96994710`
then tests-after `8e8e8384`. Native test admission: not run — unavailable
in 2.0. Neither the workbench checks nor the external assertions are test
admission.
