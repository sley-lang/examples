# abs_value — worked modification (unconditional negate → guarded negate)

The initial frame (`frames/abs-v1.json`) ran `neg?NegativeOverflow`
on every input with no branch: magnitude for negatives, negation for
non-negatives. Workbench checks 6/6, external 6/6, with the defect
encoded in the table.

## Before (v1, candidate c1)

- `(5)` → `{"Ok": -5}` (defect: a non-negative input is negated)
- `(9223372036854775807)` → `{"Ok": -9223372036854775807}` (defect)
- `(-7)` → `{"Ok": 7}`, `(0)` → `{"Ok": 0}`,
  `(-9223372036854775808)` → `{"Err": "NegativeOverflow"}` (unaffected rows)

## Authoring input

Full replacement frame `frames/abs-v2.json` layered on the v1 draft
via `try --on d1`: branched `entry` on `lt(x, 0)` into a `negate`
block (`neg?NegativeOverflow`, then `ok`) and a `keep` block (`ok(x)`
directly). The table grew from 6 to 8 cases with `(1)` and
`(-9223372036854775807)` added. This added a branch on the sign —
not an argument value.

## After (v2, candidate c2 → committed)

Workbench checks 8/8, external 8/8 (`tests/check_external.py`):

- `(5)` → `{"Ok": 5}`, `(9223372036854775807)` → `{"Ok": 9223372036854775807}`
- `(-9223372036854775808)` → `{"Err": "NegativeOverflow"}` (still the
  arithmetic case: the guard only selects the branch, negation still fails)
- Unaffected rows unchanged: `(0)` → `0`, `(-7)` → `7`, `(-1)` → `1`

Final code as committed (transaction `0f217af2`) is
`frames/abs-code.json`; final tests as committed (transaction
`a2d6cd98`) are `frames/abs-tests.json`. Both verified field-equal
to the committed candidates.
