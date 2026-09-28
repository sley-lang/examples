# Quorum Decision (C07)

Governance vote decision as a 2.0.3 `sley-agent` composed example:
`(yes, no, abstain, quorum) -> Result<QuorumOutcome,QuorumError>`.
See `contract.md` for the votes-cast majority, quorum rule, and error
precedence, `modifications.md` for the worked abstention fix.

## Reproduce from this directory (needs the 2.0.3 agent binary)

```sh
AGENT=/path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
rm -rf /tmp/c07 && mkdir -p /tmp/c07
cp packs/quorum-committed.pack /tmp/c07/base.pack
cp packs/names.json /tmp/c07/names.json
"$AGENT" test --workspace /tmp/c07          # workbench checks: 14/14
python3 tests/check_external.py --agent "$AGENT" --workspace /tmp/c07  # 14/14
```

Or run all composed examples at once: `../reproduce.sh --agent "$AGENT"`.

## Contents

- `contract.md` — signature, votes-cast/Tie/NoQuorum semantics, precedence.
- `frames/quorum-v1.json` — initial authoring frame as run (abstentions
  with `no`, 12 tests).
- `frames/quorum-fix-expect.json` — two hand-computed expectation
  corrections as run (equals-quorum evaluated, valid `quorum = 1`).
- `frames/quorum-v2.json` — follow-up frame as run via `try --on`
  (votes-cast branches, flipped expectations, added tie cases, 14 tests).
- `frames/quorum-code.json` — final code as committed (transaction `73c40f0b`).
- `frames/quorum-tests.json` — final tests as committed (transaction `0d2b561b`).
- `tests/cases.json` — 14 independently expected cases.
- `tests/check_external.py` — external assertions, 14/14 at commit time.
- `views/` — readable workbench view of the committed function.
- `packs/quorum-committed.pack` + `packs/names.json` — export + the
  workbench's author name map (`.sley/names.json` of the persistence
  workspace), needed for `view`/`call` in a fresh workspace.
- `modifications.md` — before/after inputs and observed results.

Persistence: code-only `73c40f0b` then tests-after `0d2b561b` via the
documented split route (combined code+tests commit is refused with
`TXN_TEST_EVIDENCE_UNSUPPORTED`, re-confirmed first-hand on this
content). Native test admission: not run — unavailable in 2.0. Neither
the workbench checks nor the external assertions are test admission.
