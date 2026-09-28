# Days in Month (C09)

Proleptic Gregorian month length as a 2.0.3 `sley-agent` composed
example: `(year, month) -> Result<i64,DateError>`.
See `contract.md` for the leap-year rule and error precedence,
`modifications.md` for the worked century-rule fix and the retained
trap-handler repair for the infallible remainders.

## Reproduce from this directory (needs the 2.0.3 agent binary)

```sh
AGENT=/path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
rm -rf /tmp/c09 && mkdir -p /tmp/c09
cp packs/month-committed.pack /tmp/c09/base.pack
cp packs/names.json /tmp/c09/names.json
"$AGENT" test --workspace /tmp/c09          # workbench checks: 15/15
python3 tests/check_external.py --agent "$AGENT" --workspace /tmp/c09  # 15/15
```

Or run all composed examples at once: `../reproduce.sh --agent "$AGENT"`.

## Contents

- `contract.md` — signature, Gregorian/leap semantics, precedence.
- `frames/month-v1.json` — initial authoring frame as run
  (divisible-by-4 only, 13 tests).
- `frames/month-fill1.json` — retained single-iteration repair as run
  (`rem?Overflow` refusal → `rem?remtrap` trap handler).
- `frames/month-v2.json` — follow-up frame as run via `try --on`
  (full leap rule, flipped century expectation, added cases, 15 tests).
- `frames/month-code.json` — final code as committed (transaction `10e4887c`).
- `frames/month-tests.json` — final tests as committed (transaction `cf4e4cab`).
- `tests/cases.json` — 15 independently expected cases.
- `tests/check_external.py` — external assertions, 15/15 at commit time.
- `views/` — readable workbench view of the committed function.
- `packs/month-committed.pack` + `packs/names.json` — export + the
  workbench's author name map (`.sley/names.json` of the persistence
  workspace), needed for `view`/`call` in a fresh workspace.
- `modifications.md` — before/after inputs and observed results.

Persistence: code-only `10e4887c` then tests-after `cf4e4cab` via the
documented split route (combined code+tests commit is refused with
`TXN_TEST_EVIDENCE_UNSUPPORTED`, re-confirmed first-hand on this
content). Native test admission: not run — unavailable in 2.0. Neither
the workbench checks nor the external assertions are test admission.
