# page_window — worked modification (le → lt)

The initial frame (`frames/page-v1.json`) computed the flag as
`has_more = (end <= total)`. Under it, a window ending exactly on the
item count claimed a further page: `(100, 9, 10)` → `(90, 10, true)`,
`(10, 0, 10)` → `(0, 10, true)`. Workbench checks 15/15, external 15/15
— the table encoded the off-by-one, so green checks did not catch it;
reading the contract's "last page" clause against the observed `(90, 10,
true)` did.

## Before (v1, candidate c1)

- `(100, 9, 10)` → `{"Ok": [90, 10, true]}` (claims page 10 exists)
- `(10, 0, 10)` → `{"Ok": [0, 10, true]}` (claims page 1 of a 10-item,
  10-per-page listing exists)

Observed via `call page_window … --on c1` in the authoring workspace.

## Authoring input

The follow-up frame (`frames/page-v2.json`) redefines the function with
the policy op changed from `["more", "le", "end", "total"]` to
`["more", "lt", "end", "total"]`, flips the `(100, 9, 10)` expectation to
`false`, and adds the exact-end boundary `(10, 0, 10)` →
`(0, 10, false)`. Applied with `try --on d1` (draft d1@r2 → candidate
c2); the same-named test table was replaced, not appended. This changed
one comparison operator, not an argument value.

## After (v2, candidate c2 → committed)

Workbench checks 16/16, external 16/16 (`tests/check_external.py`):

- `(100, 9, 10)` → `{"Ok": [90, 10, false]}`
- `(10, 0, 10)` → `{"Ok": [0, 10, false]}` (new boundary case)
- `(95, 9, 10)` → `{"Ok": [90, 5, false]}` (unchanged: short last page)
- `(100, 10, 10)` → `{"Ok": [100, 0, false]}` (unchanged: empty window)
- Guards unchanged: `(-1, 0, 10)` → `Err(NegativeTotal)`,
  `(100, -1, 10)` → `Err(NegativePage)`, `(100, 0, 0)` → `Err(BadPerPage)`

Observed via `call page_window … --on c2`. Final code as committed
(transaction `8da11225`) is `frames/page-code.json`; final tests as
committed (transaction `7f14f6e7`) are `frames/page-tests.json`. Both
verified identical to the workbench's stored draft inputs
(`draft d1 --input`, `draft d2 --input` in the authoring workspace).

## Authoring repairs (retained as lessons, not frames)

- First `try` of v1 was refused `AGENT_X_SCOPE` (5 problems): a value
  unwrapped by a checked operation (`mul?`, `add?`, `sub?`) is visible
  only in its own block, so downstream blocks must declare it as a
  parameter (`window` takes `start`; `full` takes `start`; `part` takes
  `start`, `rem`). Plain comparison results (`more`) and function
  parameters propagate without declaring. Fixed in the frame; the
  successful `try` is the retained v1.
- First `try` also taught that a bare `0` in tuple position fixes no
  type: the kernel asks for `{"type": "i64", "value": 0}` (confirmed by a
  prior throwaway probe; booleans and comparisons need no annotation).
