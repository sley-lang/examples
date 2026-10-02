# sign_class — contract

`(x: i64) -> Sign`

Three-way sign classification returning a bare `Sign` variant
(first composed example with a non-`Result` return, via the `return`
terminator).

## Policy (final, v2)

- `x < 0` → `Negative`
- `x == 0` → `Zero`
- otherwise → `Positive`

Evaluation order in `entry`: the negativity check runs first; only
non-negative inputs reach the zero check. The initial v1 frame had no
zero check (see `modifications.md`); zero fell through to `Positive`.

## Encoding (harness fact, confirmed via `call`)

Bare unit variants surface as JSON strings (`"Negative"`); the class
mapping itself is fixed by this contract, not by observed output.

## Types

- `Sign = Negative | Zero | Positive`
