# line_total — worked modification (booking cap)

The initial frame (`frames/invoice-v1.json`) computed the total with
checked arithmetic only: guards `BadQty`/`BadPrice`/`BadFee`, then
`mul?Overflow`, then `add?Overflow`. Any representable total was accepted,
however large. Workbench checks 9/9, external 9/9.

## Before (v1, candidate c1)

- `(100000, 50000, 0)` → `{"Ok": 5000000000}` (accepted, no cap)
- `(20, 50000, 1)` → `{"Ok": 1000001}` (accepted, no cap)
- `(1, MAX, 0)` → `{"Ok": 9223372036854775807}` (accepted, no cap)
- Overflow still reported at either step: `(MAX, 2, 0)` → `Overflow`,
  `(1, MAX, 10)` → `Overflow`

## Authoring input

Full replacement frame `frames/invoice-v2.json` layered on the v1 draft:
added the `OverLimit` variant to `InvoiceError` and appended the cap guard
`["!OverLimit", "if", ["gt", "total", 1000000]]` after the add. The table
grew from 9 to 12 cases. This added a type variant plus a guard op — not
an argument change.

## After (v2, candidate c2 → committed)

Workbench checks 12/12, external 12/12 (`tests/check_external.py`):

- `(100000, 50000, 0)` → `{"Err": "OverLimit"}`
- `(20, 50000, 0)` → `{"Ok": 1000000}` (boundary inclusive)
- `(20, 50000, 1)` → `{"Err": "OverLimit"}`
- `(1, MAX, 0)` → `{"Err": "OverLimit"}` (representable, over cap)
- `(MAX, 2, 0)` → `{"Err": "Overflow"}` (overflow still beats the cap)
- `(1, MAX, 10)` → `{"Err": "Overflow"}`
- Guards unchanged: `(0, 499, 10)` → `BadQty`, `(3, -5, 10)` → `BadPrice`,
  `(3, 499, -1)` → `BadFee`

Final code as committed (transaction `773fea0f`) is
`frames/invoice-code.json`; final tests as committed (transaction
`81a8a6da`) are `frames/invoice-tests.json`. Both verified field-equal to
the committed candidates.
