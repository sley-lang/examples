# split_duration — worked modification (days layer)

The initial frame (`frames/duration-v1.json`) decomposed seconds into a
3-tuple `(hours, minutes, seconds)` via `total / 3600`, `% 3600`, `/ 60`,
`% 60`, with a `NegativeDuration` guard. Workbench checks 12/12, external
12/12.

## Before (v1, candidate c1)

- `90061` → `{"Ok": [25, 1, 1]}`
- `86400` → `{"Ok": [24, 0, 0]}`
- `MAX` → `{"Ok": [2562047788015215, 30, 7]}`
- `-1`, `-3600` → `{"Err": "NegativeDuration"}`

## Authoring input

Full replacement frame `frames/duration-v2.json` layered on the v1 draft:
return arity changed to a 4-tuple, a `k_86400` constant and the
`d = total / 86400` / `r1 = total % 86400` steps were prepended, and the
hour/minute steps were re-chained onto the day remainder. The table went
from 12 cases (3-tuple) to 9 cases (4-tuple). This changed the function
arity and op chain — not an argument value.

## After (v2, candidate c2 → committed)

Workbench checks 9/9, external 9/9 (`tests/check_external.py`):

- `90061` → `{"Ok": [1, 1, 1, 1]}`
- `86400` → `{"Ok": [1, 0, 0, 0]}`
- `172799` → `{"Ok": [1, 23, 59, 59]}`
- `MAX` → `{"Ok": [106751991167300, 15, 30, 7]}`
- `-1` → `{"Err": "NegativeDuration"}`

The `MAX` row was verified independently (see CORRECTION-3 in
`composed/corrections.md`): `24*d + h` reproduces the v1 hours
`2562047788015215` exactly.

Final code as committed (transaction `fb236485`) is
`frames/duration-code.json`; final tests as committed (transaction
`a94779c9`) are `frames/duration-tests.json`. Both verified field-equal to
the committed candidates.
