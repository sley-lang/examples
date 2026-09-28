# line_total — contract

`(qty: i64, unit_cents: i64, fee_cents: i64) -> Result<i64, InvoiceError>`

Prices one invoice line: `total = qty * unit_cents + fee_cents`, with
checked arithmetic and a booking cap.

## Parameter semantics

- `qty` = item count. Must be `>= 1`; `0` or negative returns `Err(BadQty)`.
- `unit_cents` = unit price in cents. Must be `>= 0`, else `Err(BadPrice)`.
- `fee_cents` = flat fee in cents. Must be `>= 0`, else `Err(BadFee)`.

## Policy (final, v2)

1. Multiply with overflow check: `mul?Overflow`.
2. Add the fee with overflow check: `add?Overflow`.
3. Cap the computed total at 1,000,000 cents: above it returns
   `Err(OverLimit)`. The boundary is inclusive — exactly 1,000,000 is `Ok`.

## Error precedence (evaluation order in `entry`)

1. `BadQty`, 2. `BadPrice`, 3. `BadFee` — input guards, in this order.
   `(-1, -5, -1)` would yield `BadQty`.
4. `Overflow` from the multiply — e.g. `(MAX, 2, 0)`.
5. `Overflow` from the add — e.g. `(1, MAX, 10)`.
6. `OverLimit` — checked last, on the computed total. Arithmetic overflow
   therefore always wins over the cap: an unrepresentable product is
   `Overflow`, never `OverLimit`. Conversely `(1, MAX, 0)` is `OverLimit`
   because `MAX` is representable but exceeds the cap.

## Types

- `InvoiceError = BadQty | BadPrice | BadFee | OverLimit | Overflow`
  (`OverLimit` was added by the worked modification; v1 had four variants.)
