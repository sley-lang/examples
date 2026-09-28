# window_overlap — worked modification (raw difference → negated gap)

The initial frame (`frames/overlap-v1.json`) returned the raw signed
difference `d = oe - os` as the gap for disjoint intervals. Under it,
separated intervals reported a negative gap: `(0, 10, 20, 30)` →
`(0, -10)`, `(0, 0, 5, 5)` → `(0, -5)`. Workbench checks 14/14, external
14/14 — the table encoded the sign error, so green checks did not catch
it; the contract's "nonnegative lengths" clause against the observed
`(0, -10)` did.

## Before (v1, candidate c1)

- `(0, 10, 20, 30)` → `{"Ok": [0, -10]}` (negative gap)
- `(0, 0, 5, 5)` → `{"Ok": [0, -5]}` (negative gap)
- `(0, 10, 5, 15)` → `{"Ok": [5, 0]}` (overlap arm unaffected)

Observed via `call window_overlap … --on c1` in the authoring workspace.

## Authoring input

The follow-up frame (`frames/overlap-v2.json`) redefines the disjoint
leaf from `[["w", "tuple", {"type": "i64", "value": 0}, "d"]]` to
`[["g", "neg?Overflow", "d"], ["w", "tuple", {"type": "i64", "value": 0},
"g"]]`, flips the two disjoint expectations to positive gaps, flips the
extreme case to `Err(Overflow)` (below), and adds the point-inside case
`(7, 7, 0, 10)` → `(0, 0)`. Applied with `try --on d1` (draft d1@r2 →
candidate c2); the same-named test table was replaced, not appended.
This added the missing negation, not an argument value.

The negation is checked for a reason it exercises: `[MAX, MAX]` against
`[-1, -1]` has gap difference exactly `i64::MIN`, so
`(MAX, MAX, -1, -1)` → `Err(Overflow)` rather than a wrapped gap.

## After (v2, candidate c2 → committed)

Workbench checks 15/15, external 15/15 (`tests/check_external.py`):

- `(0, 10, 20, 30)` → `{"Ok": [0, 10]}`
- `(0, 0, 5, 5)` → `{"Ok": [0, 5]}`
- `(MAX, MAX, -1, -1)` → `{"Err": "Overflow"}` (new negation boundary)
- `(7, 7, 0, 10)` → `{"Ok": [0, 0]}` (new point-inside case)
- `(0, 10, 10, 20)` → `{"Ok": [0, 0]}` (unchanged: touching)
- Guards unchanged: `(10, 0, 0, 5)` → `Err(BadFirst)`,
  `(0, 5, 10, 3)` → `Err(BadSecond)`

Observed via `call window_overlap … --on c2`. Final code as committed
(transaction `ff526edf`) is `frames/overlap-code.json`; final tests as
committed (transaction `65a093d7`) are `frames/overlap-tests.json`. Both
verified identical to the workbench's stored draft inputs
(`draft d1 --input`, `draft d2 --input` in the authoring workspace).
