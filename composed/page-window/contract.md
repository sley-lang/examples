# page_window — contract

`(total: i64, page: i64, per_page: i64) -> Result<(i64,i64,bool),PageError>`

Computes the visible window of one page over `total` items: the start
offset, the item count on this page, and whether a further page exists.
Pages are zero-based; page 0 is the first page.

## Parameter semantics

- `total` = item count. Must be `>= 0`; a negative value returns
  `Err(NegativeTotal)`.
- `page` = zero-based page index. Must be `>= 0`; a negative value
  returns `Err(NegativePage)`.
- `per_page` = items per full page. Must be `>= 1`; anything less returns
  `Err(BadPerPage)`.

## Policy (final, v2)

1. `start = page * per_page`, checked; overflow returns `Err(Overflow)`.
   The offset multiplication always runs, so an absurd page can overflow
   before the beyond-end policy below applies.
2. `start >= total` → `Ok((total, 0, false))`: a page at or past the end
   yields the empty trailing window, normalized to offset `total`. This
   covers `total = 0` with no special case.
3. Otherwise `end = start + per_page`, checked; overflow returns
   `Err(Overflow)`. `count = min(per_page, total - start)`; the last page
   is short. `has_more = (end < total)`: a window ending exactly on
   `total` is the last page, so equality reports no further page.

So `(100, 9, 10)` → `(90, 10, false)` (full last page, nothing beyond),
`(95, 9, 10)` → `(90, 5, false)` (short last page), and `(7, 0, 10)` →
`(0, 7, false)`. The initial v1 policy used `end <= total` for `has_more`;
the worked modification changed it to `<` (see `modifications.md`).

## Error precedence (evaluation order in `entry`, then `window`)

1. `NegativeTotal` — checked first. `(-5, -2, 0)` yields
   `NegativeTotal`, not `NegativePage` or `BadPerPage`.
2. `NegativePage` — checked second.
3. `BadPerPage` — checked third.
4. `Overflow` — from the offset multiply, then from the window-end add.
   No subtraction can fail: `total - start` only runs when
   `start < total`.

## Types

- `PageError = NegativeTotal | NegativePage | BadPerPage | Overflow`
- Success is the `(start, count, has_more)` triple; `count` is `0` exactly
  for empty windows.
