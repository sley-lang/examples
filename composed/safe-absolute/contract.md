# abs_value — contract

`(x: i64) -> Result<i64,AbsError>`

Magnitude of a signed value. Non-negative inputs pass through untouched;
negative inputs are negated with the checked `neg` operator.

## Policy (final, v2)

- `x >= 0` → `Ok(x)` (identity, no arithmetic runs)
- `x < 0` → `neg?NegativeOverflow(x)`
- `MIN` (`-9223372036854775808`) → `Err(NegativeOverflow)` — the only
  input with no representable magnitude

The initial v1 frame negated unconditionally (see `modifications.md`);
positive inputs came back negated.

## Types

- `AbsError = NegativeOverflow`
