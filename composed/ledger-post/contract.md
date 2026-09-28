# post_ledger — contract

`(balance: i64, debit: i64, credit: i64, overdraft: i64) -> Result<i64,LedgerError>`

Posts one debit and one credit against a signed balance under an
overdraft floor. Returns the new balance, or declines the posting.

## Parameter semantics

- `balance` = current signed balance. Any `i64` is accepted, including a
  balance already below the floor; there is no `NegativeBalance` case.
- `debit` = amount to subtract. Must be `>= 0`; a negative value returns
  `Err(NegativeDebit)`.
- `credit` = amount to add. Must be `>= 0`; a negative value returns
  `Err(NegativeCredit)`.
- `overdraft` = permitted negative excursion. Must be `>= 0`; a negative
  value returns `Err(NegativeOverdraft)`. The floor is `-overdraft`.

## Policy (final, v2)

1. `tmp = balance + credit`, checked; overflow returns `Err(Overflow)`.
2. `new = tmp - debit`, checked; overflow returns `Err(Overflow)`. Either
   direction can fail: a large credit overflows upward, a minimum balance
   with any debit underflows.
3. `floor = -overdraft` (checked negation; unreachable for
   `overdraft >= 0`, still unwrapped because every integer operation
   returns a checked result).
4. `new < floor` → `Err(InsufficientFunds)`; otherwise `Ok(new)`. A
   balance resting exactly on the floor posts: `(0, 100, 0, 100)` →
   `Ok(-100)`. The initial v1 policy declined at equality (`<=`); the
   worked modification changed it to `<` (see `modifications.md`).

So `(1000, 200, 50, 100)` → `Ok(850)`, `(0, 101, 0, 100)` →
`Err(InsufficientFunds)`, and `(-150, 0, 0, 100)` →
`Err(InsufficientFunds)` (a posting that leaves the balance below the
floor is declined even with zero amounts moving).

## Error precedence (evaluation order in `entry`)

1. `NegativeDebit` — checked first. `(0, -1, -2, -3)` yields
   `NegativeDebit`.
2. `NegativeCredit` — checked second.
3. `NegativeOverdraft` — checked third.
4. `Overflow` — credit-add first, then debit-sub. Arithmetic runs before
   the floor comparison, so an overflowing posting reports `Overflow`,
   never `InsufficientFunds`.

## Types

- `LedgerError = NegativeDebit | NegativeCredit | NegativeOverdraft | InsufficientFunds | Overflow`
- Success is the exact new signed balance.
