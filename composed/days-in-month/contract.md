# days_in_month — contract

`(year: i64, month: i64) -> Result<i64,DateError>`

Returns the number of days in a proleptic Gregorian calendar month:
31, 30, 28, or 29 for February in a leap year.

## Parameter semantics

- `year` = common-era year. Must be `>= 1`; year zero and negatives
  return `Err(BadYear)`. There is no year zero in the common era, and
  the leap rule below is stated for positive years only.
- `month` = month number 1–12. Anything else returns `Err(BadMonth)`.

## Policy (final, v2)

- Months 1, 3, 5, 7, 8, 10, 12 → `Ok(31)`; months 4, 6, 9, 11 → `Ok(30)`.
- February → `Ok(29)` in a leap year, `Ok(28)` otherwise. A year is leap
  when divisible by 4, except centuries, except multiples of 400:
  `(year % 4 = 0) and (year % 100 != 0 or year % 400 = 0)`. All operands
  are positive, so every remainder is exact. The initial v1 policy used
  divisibility by 4 alone; the worked modification adds the century rules
  (see `modifications.md`).

So `(2024, 2)` → `29`, `(2023, 2)` → `28`, `(1900, 2)` → `28` (century,
not leap), `(2000, 2)` → `29` (multiple of 400, leap), and `(2024, 7)` →
`31`.

## Error precedence (evaluation order in `entry`)

1. `BadYear` — checked first. `(0, 13)` yields `BadYear`, not `BadMonth`.
2. `BadMonth` — checked second.
3. No arithmetic case exists: remainders are by nonzero positive
   constants, so no `Overflow`, divide-by-zero, or sign failure is
   possible.

## Types

- `DateError = BadYear | BadMonth`
