# Invoice Line Total (C02)

Checked invoice-line pricing as a 2.0.3 `sley-agent` composed example:
`(qty, unit_cents, fee_cents) -> Result<i64, InvoiceError>`.
See `contract.md` for parameter semantics and error precedence,
`modifications.md` for the worked booking-cap addition.

## Reproduce from this directory (needs the 2.0.3 agent binary)

```sh
AGENT=/path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
rm -rf /tmp/c02 && mkdir -p /tmp/c02
cp packs/invoice-committed.pack /tmp/c02/base.pack
cp packs/names.json /tmp/c02/names.json
"$AGENT" test --workspace /tmp/c02          # workbench checks: 12/12
python3 tests/check_external.py --agent "$AGENT" --workspace /tmp/c02  # 12/12
```

Or run all three examples at once: `../reproduce.sh --agent "$AGENT"`.

## Contents

- `contract.md` — signature, parameter semantics, error precedence.
- `frames/invoice-v1.json` — initial authoring frame as run (no cap, 9 tests).
- `frames/invoice-v2.json` — full replacement frame as run (cap added, 12 tests).
- `frames/invoice-code.json` — final code as committed (transaction `773fea0f`).
- `frames/invoice-tests.json` — final tests as committed (transaction `81a8a6da`).
- `tests/cases.json` — 12 independently expected cases.
- `tests/check_external.py` — external assertions, 12/12 at commit time.
- `views/` — readable workbench view of the committed function.
- `packs/invoice-committed.pack` + `packs/names.json` — export + author name
  map needed for `view`/`call` in a fresh workspace.
- `modifications.md` — before/after inputs and observed results.

Persistence: combined code+tests commit refused
(`TXN_TEST_EVIDENCE_UNSUPPORTED`); committed split as code-only `773fea0f`
then tests-after `81a8a6da`. Native test admission: not run — unavailable
in 2.0. Neither the workbench checks nor the external assertions are test
admission.
