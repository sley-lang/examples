# Page Window (C04)

Pagination window as a 2.0.3 `sley-agent` composed example:
`(total, page, per_page) -> Result<(start,count,has_more),PageError>`.
See `contract.md` for offset/clamp/flag semantics and error precedence,
`modifications.md` for the worked `le` → `lt` flag fix.

## Reproduce from this directory (needs the 2.0.3 agent binary)

```sh
AGENT=/path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
rm -rf /tmp/c04 && mkdir -p /tmp/c04
cp packs/page-committed.pack /tmp/c04/base.pack
cp packs/names.json /tmp/c04/names.json
"$AGENT" test --workspace /tmp/c04          # workbench checks: 16/16
python3 tests/check_external.py --agent "$AGENT" --workspace /tmp/c04  # 16/16
```

Or run all composed examples at once: `../reproduce.sh --agent "$AGENT"`.

## Contents

- `contract.md` — signature, offset/clamp/flag semantics, precedence.
- `frames/page-v1.json` — initial authoring frame as run (`le` flag, 15 tests).
- `frames/page-v2.json` — follow-up frame as run via `try --on`
  (`lt` flag, flipped expectation, added exact-end case, 16 tests).
- `frames/page-code.json` — final code as committed (transaction `8da11225`).
- `frames/page-tests.json` — final tests as committed (transaction `7f14f6e7`).
- `tests/cases.json` — 16 independently expected cases.
- `tests/check_external.py` — external assertions, 16/16 at commit time.
- `views/` — readable workbench view of the committed function.
- `packs/page-committed.pack` + `packs/names.json` — export + the
  workbench's author name map (`.sley/names.json` of the authoring
  workspace), needed for `view`/`call` in a fresh workspace.
- `modifications.md` — before/after inputs and observed results.

Persistence: combined code+tests commit refused
(`TXN_TEST_EVIDENCE_UNSUPPORTED`); committed split as code-only `8da11225`
then tests-after `7f14f6e7`. Native test admission: not run — unavailable
in 2.0. Neither the workbench checks nor the external assertions are test
admission.
