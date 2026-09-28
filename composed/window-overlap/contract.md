# window_overlap — contract

`(s1: i64, e1: i64, s2: i64, e2: i64) -> Result<(i64,i64),WindowError>`

Measures two closed intervals `[s1, e1]` and `[s2, e2]`: the overlap
length and the gap length. Exactly one of the two is nonzero, except
touching intervals — which meet at one point and yield `(0, 0)`.

## Parameter semantics

- Each interval must be ordered: `s1 > e1` returns `Err(BadFirst)`,
  `s2 > e2` returns `Err(BadSecond)`. Zero-length intervals (points) are
  valid inputs.
- `os = max(s1, s2)` is the overlap start; `oe = min(e1, e2)` is the
  overlap end; `d = oe - os`, checked.

## Policy (final, v2)

1. `d > 0` → `Ok((d, 0))`: positive-length intersection. The gap is
   definitionally zero.
2. Otherwise → `Ok((0, -d))`: disjoint or touching. The negation is
   checked; negating `i64::MIN` returns `Err(Overflow)`.
3. Touching intervals (`d = 0`, e.g. `[0, 10]` and `[10, 20]`) and
   coincident points (`[5, 5]` and `[5, 5]`) collapse to `(0, 0)`: zero
   overlap and zero gap. A point strictly inside an interval
   (`[7, 7]` in `[0, 10]`) likewise yields `(0, 0)`.

So `(0, 10, 5, 15)` → `(5, 0)`, `(0, 30, 10, 20)` → `(10, 0)`
(containment), `(0, 10, 20, 30)` → `(0, 10)`, and `(0, 10, 10, 20)` →
`(0, 0)`. The initial v1 policy returned the raw signed difference as
the gap; the worked modification negates it (see `modifications.md`).

## Error precedence (evaluation order in `entry`, then the measure arms)

1. `BadFirst` — checked first. `(5, 0, 9, 2)` yields `BadFirst`, not
   `BadSecond`.
2. `BadSecond` — checked second.
3. `Overflow` — from `oe - os` (e.g. full-range overlap, where the true
   difference exceeds `i64::MAX`), then from negating the gap
   (`[MAX, MAX]` against `[-1, -1]`, where the gap difference is exactly
   `i64::MIN`). Arithmetic runs before the overlap/disjoint branch, so an
   unrepresentable measure reports `Overflow`.

## Types

- `WindowError = BadFirst | BadSecond | Overflow`
- Success is the `(overlap, gap)` pair of nonnegative lengths, with the
  touching/point collapse to `(0, 0)` stated above.
