# days_in_month — worked modification (divisible-by-4 only → full Gregorian rule)

The initial frame (`frames/month-v1.json`) decided February by
divisibility by 4 alone: every century year divisible by 4 reported 29.
Under it, 1900 and 2100 — not leap years — reported 29, while 2000
reported 29 for the wrong reason. Workbench checks 13/13, external
13/13 — the table encoded the rule error, so green checks did not catch
it; the contract's century clause against the observed `(1900, 2)` →
`29` did.

## Authoring repair (retained, single iteration)

The first submission used `rem?Overflow`, which the workbench refused:
`AGENT_X_PROPAGATION`, since `Overflow` is not a case of `DateError`
— and the contract states no arithmetic case exists (remainders by
nonzero positive constants cannot fail). The repair (`frames/month-fill1.json`,
via `fill d1 … --revision 1`) routes each remainder through a handler
block instead: `rem?remtrap` with `remtrap` terminating in
`["trap", "unreachable"]`. The trap documents the impossibility and can
only fire if the kernel's arithmetic ever contradicts it. The v2 frame
reuses the same trap for all three remainders. This is the first corpus
use of the trap-handler pattern for an infallible checked operation.

## Before (v1, candidate c1)

- `(1900, 2)` → `{"Ok": 29}` (century, not leap)
- `(2100, 2)` → `{"Ok": 29}` (century, not leap)
- `(2000, 2)` → `{"Ok": 29}` (right value, wrong reason)
- `(2024, 2)` → `{"Ok": 29}` (unaffected arm)

Observed via `call days_in_month … --on c1` in the scratch workspace.

## Authoring input

The follow-up frame (`frames/month-v2.json`) extends the `feb` block to
three remainders (`r4`, `r100`, `r400`, all via `rem?remtrap`) and
branches on `(r4 = 0) and (r100 != 0 or r400 = 0)`, flips `(1900, 2)` to
28, and adds `(2100, 2)` → 28 and `(2400, 2)` → 29. Applied with
`try --on d1` (draft d1@r3 → candidate c2); the same-named test table
was replaced, not appended. This completed the leap rule, not an
argument value.

## After (v2, candidate c2 → committed)

Workbench checks 15/15, external 15/15 (`tests/check_external.py`):

- `(1900, 2)` → `{"Ok": 28}`
- `(2100, 2)` → `{"Ok": 28}` (new case)
- `(2400, 2)` → `{"Ok": 29}` (new case)
- `(2000, 2)` → `{"Ok": 29}` (unchanged value, now for the right reason)
- `(2024, 2)` → `{"Ok": 29}` (unchanged)
- Guards unchanged: `(0, 13)` → `Err(BadYear)`,
  `(2024, 13)` → `Err(BadMonth)`

Observed via `call days_in_month … --on c2`. Final code as committed
(transaction `10e4887c`) is `frames/month-code.json`; final tests as
committed (transaction `cf4e4cab`) are `frames/month-tests.json`. Both
verified identical to the persistence workspace's stored draft inputs
(`draft d1 --input`, `draft d2 --input`).
