# clamp_value — contract

`(value: i64, lo: i64, hi: i64) -> Result<i64, ClampError>`

Pins a signed value into a closed interval.

## Parameter semantics

- `value` = the candidate. Any `i64`, no guard.
- `lo`, `hi` = inclusive bounds. `lo > hi` returns `Err(BadRange)` —
  checked first, so a bad range shadows even an in-range value:
  `(5, 9, 5)` → `BadRange`. `lo == hi` pins everything to that point.

## Policy (final, v2)

Clamp, boundaries inclusive:

- `value < lo` → `Ok(lo)`
- `value > hi` → `Ok(hi)`
- otherwise → `Ok(value)`

The initial v1 policy rejected out-of-range values with
`Err(OutOfRange)` (see `modifications.md`); the worked modification
changed rejection to clamping.

## Error precedence (evaluation order in `entry`)

1. `BadRange` — checked first.
2. The clamp branch. No arithmetic runs, so no `Overflow` case exists.

## Types

- `ClampError = BadRange`
