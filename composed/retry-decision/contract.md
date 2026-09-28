# retry_decision — contract

`(attempt: i64, limit: i64) -> Result<RetryState, RetryError>`

Decides whether a bounded operation may be attempted again.

## Parameter semantics

- `attempt` = attempts consumed so far. Must be `>= 0`; a negative value
  returns `Err(NegativeAttempt)`.
- `limit` = inclusive retry cutoff. Must be `>= 1`; anything less returns
  `Err(BadLimit)`. Note `limit = 0` is rejected — there is no "zero retries
  allowed" configuration; the smallest cutoff is one. `limit` is not a
  count of permitted attempts: it is the largest consumed-attempt value at
  which another retry is still granted.

## Policy (final, v2)

Retry while consumed attempts do not exceed the cutoff:

- `attempt <= limit` → `Ok(Retry)`
- `attempt > limit` → `Ok(Exhausted)`

Equality permits another retry: `(3, 3)` → `Retry` (consumed attempts sit
exactly on the cutoff, so one more try is still covered) and `(4, 3)` →
`Exhausted`. The initial v1 policy used strict `attempt < limit`; the
worked modification changed it to `<=` (see `modifications.md`).

## Error precedence (evaluation order in `entry`)

1. `NegativeAttempt` — checked first. `(-1, -4)` yields
   `NegativeAttempt`, not `BadLimit`.
2. `BadLimit` — checked second.
3. The policy branch. No arithmetic runs, so no `Overflow` case exists.

## Types

- `RetryError = NegativeAttempt | BadLimit`
- `RetryState = Retry | Exhausted`
