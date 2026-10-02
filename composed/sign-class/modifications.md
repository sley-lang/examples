# sign_class — worked modification (two-way split → three-way split)

The initial frame (`frames/sign-v1.json`) branched once on `lt(x, 0)`:
negatives went to `Negative`, everything else fell through to
`Positive` — zero had no arm. Workbench checks 3/3, external 3/3,
with the defect encoded in the table.

## Before (v1, candidate c1)

- `(0)` → `"Positive"` (defect: zero is not positive)
- `(-5)` → `"Negative"`, `(7)` → `"Positive"` (unaffected rows)

## Authoring input

Full replacement frame `frames/sign-v2.json` layered on the v1 draft
via `try --on d1`: the `else` arm became a `check_zero` block branching
on `eq(x, 0)` into `is_zero` / `is_pos` leaves. The table grew from 3
to 7 cases with `(-1)`, `(MIN)`, `(1)`, `(MAX)` added. This added a
missing classification arm — not an argument value.

## After (v2, candidate c2 → committed)

Workbench checks 7/7, external 7/7 (`tests/check_external.py`):

- `(0)` → `"Zero"`
- `(-9223372036854775808)` → `"Negative"`,
  `(9223372036854775807)` → `"Positive"` (extremes classify, no arithmetic)
- Unaffected rows unchanged: `(-5)` → `"Negative"`, `(7)` → `"Positive"`

Final code as committed (transaction `ee5d5dc5`) is
`frames/sign-code.json`; final tests as committed (transaction
`18fffc7b`) are `frames/sign-tests.json`. Both verified field-equal
to the committed candidates.
