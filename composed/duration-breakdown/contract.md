# split_duration — contract

`(total_seconds: i64) -> Result<(i64, i64, i64, i64), DurationError>`

Decomposes a non-negative second count into
`(days, hours, minutes, seconds)`.

## Parameter semantics

- `total_seconds` must be `>= 0`; a negative value returns
  `Err(NegativeDuration)`. There is no other input validation.

## Policy (final, v2)

Checked `div`/`rem` chain, remainders feeding the next step:

- `d = total_seconds / 86400`, `r1 = total_seconds % 86400`
- `h = r1 / 3600`, `r2 = r1 % 3600`
- `m = r2 / 60`, `s = r2 % 60`
- result `(d, h, m, s)`

Every `div`/`rem` uses `?Overflow` propagation, as required for checked
composition; on the guarded non-negative domain no overflow is reachable,
and division truncates toward zero. The initial v1 returned a 3-tuple
`(hours, minutes, seconds)`; the worked modification added the days layer
(see `modifications.md`).

## Error precedence (evaluation order in `entry`)

1. `NegativeDuration` — checked first.
2. The div/rem chain in order `d, r1, h, r2, m, s`. A hypothetical
   `Overflow` would surface at the earliest failing step.

## Types

- `DurationError = NegativeDuration | Overflow`
