# safe_quotient — worked modification (guard after div → guard before div)

The initial frame (`frames/quotient-v1.json`) ran the checked division
first and guarded the zero denominator second: `div?Overflow` unwraps
every arithmetic failure — including divide-by-zero — into `Overflow`,
so the later `!DivByZero` guard was dead code. Workbench checks 7/7,
external 7/7, with the defect encoded in the table.

## Before (v1, candidate c1)

- `(5, 0)` → `{"Err": "Overflow"}` (misattributed: the denominator is zero)
- `(6, 3)` → `{"Ok": 2}`, `(-7, 2)` → `{"Ok": -3}` (unaffected rows)

## Authoring input

Full replacement frame `frames/quotient-v2.json` layered on the v1 draft
via `try --on d1`: moved `["!DivByZero", "if", ["eq", "den", 0]]` ahead of
`["q", "div?Overflow", "num", "den"]` and added the negative-denominator
truncation row. The table grew from 7 to 8 cases. This reordered
evaluation precedence — not an argument value.

## After (v2, candidate c2 → committed)

Workbench checks 8/8, external 8/8 (`tests/check_external.py`):

- `(5, 0)` → `{"Err": "DivByZero"}`
- `(-9223372036854775808, -1)` → `{"Err": "Overflow"}` (still the
  arithmetic case: the guard only fires on a zero denominator)
- `(7, -2)` → `{"Ok": -3}` (truncation toward zero, new row)
- Unaffected rows unchanged: `(6, 3)` → `2`, `(7, 2)` → `3`,
  `(-7, 2)` → `-3`, `(0, 5)` → `0`, `(9, 1)` → `9`

Final code as committed (transaction `80fabe7a`) is
`frames/quotient-code.json`; final tests as committed (transaction
`845d1de9`) are `frames/quotient-tests.json`. Both verified field-equal
to the committed candidates.
