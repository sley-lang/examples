# safe_quotient — contract

`(num: i64, den: i64) -> Result<i64, QuotientError>`

Truncating integer division with the zero denominator reported as its
own case.

## Parameter semantics

- `num` = dividend. Any `i64`, no guard.
- `den` = divisor. `0` returns `Err(DivByZero)` — checked before any
  arithmetic runs, so a zero denominator is never misattributed to the
  arithmetic failure case.

## Policy (final, v2)

- `den == 0` → `Err(DivByZero)`
- otherwise `div?Overflow(num, den)` — truncating toward zero
  (`(7, 2)` → `3`, `(-7, 2)` → `-3`, `(7, -2)` → `-3`), with the single
  representable overflow `(MIN, -1)` → `Err(Overflow)`

The initial v1 frame ran the division before the zero guard
(see `modifications.md`); a zero denominator then surfaced as
`Err(Overflow)`.

## Error precedence (evaluation order in `entry`)

1. `DivByZero` — checked first.
2. `Overflow` — from the checked division.

## Types

- `QuotientError = DivByZero | Overflow`
