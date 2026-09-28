# quorum_decision — worked modification (abstentions counted with `no` → votes-cast majority)

The initial frame (`frames/quorum-v1.json`) compared `yes` against
`no + abstain`: abstentions voted with the `no` side and the `Tie`
outcome was unreachable. Under it, a lone yes ballot surrounded by
abstentions lost and every tie reported `Fail`. Workbench checks 12/12,
external 12/12 — the table encoded the policy error, so green checks
did not catch it; the contract's "majority of votes cast" clause against
the observed `(1, 0)` → `Fail` did.

Two hand-written expectations were also corrected before the policy
change (same run, `frames/quorum-fix-expect.json`): `(4, 4, 4, 12)` was
first listed as `NoQuorum`, but `present = 12` meets `quorum = 12`
(`12 < 12` is false), so the vote is evaluated; and `(0, 13, 0, 1)` was
first listed as `BadQuorum`, but `quorum = 1` is valid — the row now
reads `(0, 13, 0, 0)` to exercise `BadQuorum` with valid counts. Both
justified from the contract (`present < quorum`, `quorum >= 1`), not
from the tool's output alone.

## Before (v1, candidate c1/c2)

- `(1, 0, 3, 1)` → `{"Ok": "Fail"}` (lone yes vetoed by abstentions)
- `(2, 2, 0, 1)` → `{"Ok": "Fail"}` (tie reports Fail)
- `(0, 0, 5, 5)` → `{"Ok": "Fail"}` (quorum met, no votes against, still Fail)
- `(5, 3, 0, 1)` → `{"Ok": "Pass"}` (unaffected arm)

Observed via `call quorum_decision … --on c2` in the scratch workspace.

## Authoring input

The follow-up frame (`frames/quorum-v2.json`) drops the `against`
addition, redefines the compare as a two-stage branch (`yes > no` →
`pass`, `yes < no` → `failb`, else `tie`), flips the three abstention
rows to their votes-cast outcomes, flips the equals-quorum row to `Tie`,
and adds `(0, 0, 5, 5)` and `(3, 3, 4, 2)` tie cases. Applied with
`try --on d1` (draft d1@r3 → candidate c3); the same-named test table
was replaced, not appended. This removed abstentions from the decision,
not an argument value.

## After (v2, candidate c3 → committed)

Workbench checks 14/14, external 14/14 (`tests/check_external.py`):

- `(1, 0, 3, 1)` → `{"Ok": "Pass"}`
- `(2, 2, 0, 1)` → `{"Ok": "Tie"}`
- `(0, 0, 5, 5)` → `{"Ok": "Tie"}` (new case)
- `(3, 3, 4, 2)` → `{"Ok": "Tie"}` (new case)
- `(4, 4, 4, 12)` → `{"Ok": "Tie"}` (flipped: quorum met exactly)
- Guards unchanged: `(-1, 0, 0, 0)` → `Err(NegativeVotes)`,
  `(1, 1, 1, 0)` → `Err(BadQuorum)`,
  `(MAX, 1, 0, 1)` → `Err(Overflow)`

Observed via `call quorum_decision … --on c3`. Final code as committed
(transaction `73c40f0b`) is `frames/quorum-code.json`; final tests as
committed (transaction `0d2b561b`) are `frames/quorum-tests.json`. Both
verified identical to the persistence workspace's stored draft inputs
(`draft d1 --input`, `draft d2 --input`).
