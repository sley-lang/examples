# cooldown_gate — worked modification (elapsed reported as remaining → cooldown minus elapsed)

The initial frame (`frames/gate-v1.json`) returned `elapsed` in the
`remaining` position for the `Open` state: the gate reported how long it
had been blocked instead of how long block remained. Under it, a
just-tripped breaker reported zero remaining while still blocked, and a
mid-cooldown breaker understated what was left. Workbench checks 13/13,
external 13/13 — the table encoded the direction error, so green checks
did not catch it; the contract's `cooldown - elapsed` clause against the
observed `(Open, 0)` at trip time did.

## Before (v1, candidate c1)

- `(5, 5, 100, 90, 30)` → `{"Ok": ["Open", 10]}` (10 elapsed, 20 remain)
- `(3, 3, 50, 50, 10)` → `{"Ok": ["Open", 0]}` (just tripped, 10 remain)
- `(5, 5, 120, 90, 30)` → `{"Ok": ["HalfOpen", 0]}` (unaffected arm)

Observed via `call cooldown_gate … --on c1` in the scratch workspace.

## Authoring input

The follow-up frame (`frames/gate-v2.json`) redefines the `open` leaf
from `[["s", "variant", "GateState.Open"], ["w", "tuple", "s",
"elapsed"]]` to compute `["r", "sub?Overflow", "cooldown", "elapsed"]`
first and tuple `(Open, r)`, flips the two `Open` expectations to
remaining time, and adds the mostly-fresh `(5, 5, 95, 90, 30)` and
one-tick-left `(5, 5, 119, 90, 30)` cases. Applied with `try --on d1`
(draft d1@r2 → candidate c2); the same-named test table was replaced,
not appended. This corrected the direction of the measure, not an
argument value.

The subtraction is checked for uniformity, not because it can fail
here: `trip` establishes `0 <= elapsed < cooldown` before the `open`
edge runs, so `cooldown - elapsed` is strictly positive by construction.

## After (v2, candidate c2 → committed)

Workbench checks 15/15, external 15/15 (`tests/check_external.py`):

- `(5, 5, 100, 90, 30)` → `{"Ok": ["Open", 20]}`
- `(3, 3, 50, 50, 10)` → `{"Ok": ["Open", 10]}`
- `(5, 5, 95, 90, 30)` → `{"Ok": ["Open", 25]}` (new case)
- `(5, 5, 119, 90, 30)` → `{"Ok": ["Open", 1]}` (new case)
- `(5, 5, 120, 90, 30)` → `{"Ok": ["HalfOpen", 0]}` (unchanged: expiry)
- Guards unchanged: `(-1, 0, 0, 0, -5)` → `Err(NegativeFailures)`,
  `(5, 5, 80, 90, 30)` → `Err(BadClock)`,
  `(5, 5, MAX, -1, 30)` → `Err(Overflow)`

Observed via `call cooldown_gate … --on c2`. Final code as committed
(transaction `3be8a5b0`) is `frames/gate-code.json`; final tests as
committed (transaction `b4e51dd4`) are `frames/gate-tests.json`. Both
verified identical to the persistence workspace's stored draft inputs
(`draft d1 --input`, `draft d2 --input`).
