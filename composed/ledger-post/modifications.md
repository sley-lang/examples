# post_ledger — worked modification (le → lt)

The initial frame (`frames/ledger-v1.json`) declined the posting when
`new <= floor`. Under it, a balance resting exactly on the permitted
floor was declined: `(0, 100, 0, 100)` → `Err(InsufficientFunds)`,
`(0, 0, 0, 0)` → `Err(InsufficientFunds)`. Workbench checks 14/14,
external 14/14 — the table encoded the strict floor, so green checks did
not catch it; the contract's "resting exactly on the floor posts" clause
against the observed declines did.

## Before (v1, candidate c1)

- `(0, 100, 0, 100)` → `{"Err": "InsufficientFunds"}` (exact floor declined)
- `(0, 0, 0, 0)` → `{"Err": "InsufficientFunds"}` (zero posting declined)
- `(1000, 200, 50, 100)` → `{"Ok": 850}`

Observed via `call post_ledger … --on c1` in the authoring workspace.

## Authoring input

The follow-up frame (`frames/ledger-v2.json`) redefines the function with
the policy branch changed from `["cond", ["le", "new", "floor"],
["decline"], ["post"]]` to `["cond", ["lt", "new", "floor"], ["decline"],
["post"]]`, flips the two floor-exact expectations to `Ok`, and adds the
extreme floor-exact case `(MAX, MAX, 0, 0)` → `Ok(0)`. Applied with
`try --on d1` (draft d1@r2 → candidate c2); the same-named test table was
replaced, not appended. This changed one comparison operator, not an
argument value.

## After (v2, candidate c2 → committed)

Workbench checks 15/15, external 15/15 (`tests/check_external.py`):

- `(0, 100, 0, 100)` → `{"Ok": -100}`
- `(0, 0, 0, 0)` → `{"Ok": 0}`
- `(MAX, MAX, 0, 0)` → `{"Ok": 0}` (new boundary case)
- `(0, 101, 0, 100)` → `{"Err": "InsufficientFunds"}` (unchanged: below floor)
- Guards unchanged: `(0, -5, 0, 0)` → `Err(NegativeDebit)`,
  `(0, 0, -5, 0)` → `Err(NegativeCredit)`,
  `(0, 0, 0, -1)` → `Err(NegativeOverdraft)`

Observed via `call post_ledger … --on c2`. Final code as committed
(transaction `84d85be1`) is `frames/ledger-code.json`; final tests as
committed (transaction `235440e4`) are `frames/ledger-tests.json`. Both
verified identical to the workbench's stored draft inputs
(`draft d1 --input`, `draft d2 --input` in the authoring workspace).
