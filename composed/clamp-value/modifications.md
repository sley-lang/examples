# clamp_value — worked modification (reject → clamp)

The initial frame (`frames/clamp-v1.json`) rejected out-of-range values:
guards `BadRange`, then `!OutOfRange if lt(value, lo)`, then
`!OutOfRange if gt(value, hi)`. An in-range value passed through, anything
outside was an error. Workbench checks 8/8, external 8/8.

## Before (v1, candidate c1)

- `(2, 5, 9)` → `{"Err": "OutOfRange"}`
- `(12, 5, 9)` → `{"Err": "OutOfRange"}`
- `(7, 5, 9)` → `{"Ok": 7}`

## Authoring input

Full replacement frame `frames/clamp-v2.json` layered on the v1 draft via
`try --on d1`: dropped the `OutOfRange` variant from `ClampError` and
replaced the two rejection guards with a two-`cond` clamp (`entry` →
`use_lo` / `check_hi` → `use_hi` / `use_value`). The table grew from 8 to
10 cases. This changed the policy branch plus the error type — not an
argument value.

## After (v2, candidate c2 → committed)

Workbench checks 10/10, external 10/10 (`tests/check_external.py`):

- `(2, 5, 9)` → `{"Ok": 5}`
- `(12, 5, 9)` → `{"Ok": 9}`
- `(7, 5, 9)` → `{"Ok": 7}` (unchanged)
- `(5, 5, 9)` / `(9, 5, 9)` → `{"Ok": 5}` / `{"Ok": 9}` (boundaries inclusive)
- Guards unchanged: `(7, 9, 5)` → `Err(BadRange)`,
  `(5, 9, 5)` → `Err(BadRange)` (bad range shadows an in-range value)

Final code as committed (transaction `e746a959`) is
`frames/clamp-code.json`; final tests as committed (transaction
`339f4e52`) are `frames/clamp-tests.json`. Both verified field-equal to
the committed candidates.
