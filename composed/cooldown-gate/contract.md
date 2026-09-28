# cooldown_gate — contract

`(failures: i64, threshold: i64, now: i64, tripped_at: i64, cooldown: i64) -> Result<(GateState,i64),GateError>`

Reports a circuit-breaker gate: whether traffic flows (`Closed`), is
blocked (`Open` with remaining cooldown), or may send one probe
(`HalfOpen`). `remaining` is the cooldown left in the `Open` state and
`0` otherwise.

## Parameter semantics

- `failures` = consecutive failure count. Must be `>= 0`; a negative
  value returns `Err(NegativeFailures)`.
- `threshold` = failures that trip the breaker. Must be `>= 1`; anything
  less returns `Err(BadThreshold)`.
- `now`, `tripped_at` = clock readings in the same unit. `now` must not
  precede `tripped_at`; clock regression returns `Err(BadClock)`.
- `cooldown` = blocked duration in the clock unit. Must be `>= 0`; a
  negative value returns `Err(BadCooldown)`. Zero means a tripped breaker
  is immediately probe-ready.

## Policy (final, v2)

1. `failures < threshold` → `Ok((Closed, 0))`: the count alone keeps the
   gate shut; the clock is not consulted.
2. Otherwise `elapsed = now - tripped_at`, checked. `elapsed >= cooldown`
   → `Ok((HalfOpen, 0))`: the block has expired, one probe may pass.
3. Otherwise → `Ok((Open, cooldown - elapsed))`: still blocked, with the
   time left. The subtraction cannot fail: `0 <= elapsed < cooldown` is
   established before it runs. The initial v1 policy reported `elapsed`
   as the remaining time; the worked modification reports
   `cooldown - elapsed` (see `modifications.md`).

So `(2, 5, 100, 90, 30)` → `(Closed, 0)` (count below threshold),
`(5, 5, 100, 90, 30)` → `(Open, 20)`, `(5, 5, 120, 90, 30)` →
`(HalfOpen, 0)`, and `(5, 5, 90, 90, 0)` → `(HalfOpen, 0)`.

## Error precedence (evaluation order in `entry`)

1. `NegativeFailures` — checked first. `(-1, 0, 0, 0, -5)` yields
   `NegativeFailures`, not `BadThreshold` or `BadCooldown`.
2. `BadThreshold` — checked second.
3. `BadCooldown` — checked third.
4. `BadClock` — `now < tripped_at`, checked fourth; the subtraction never
   runs on a regressed clock.
5. `Overflow` — from `now - tripped_at` (e.g. extreme opposite clocks
   with the breaker tripped). Only the tripped path does arithmetic.

## Types

- `GateError = NegativeFailures | BadThreshold | BadCooldown | BadClock | Overflow`
- `GateState = Closed | Open | HalfOpen`; success is the
  `(state, remaining)` pair with `remaining = 0` outside `Open`.
