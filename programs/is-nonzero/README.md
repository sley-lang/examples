# Is Nonzero (S12)

Decides whether a signed value differs from zero with native `not_equal`.

`"0"` returns `false`; `"1"`, `"-1"`, and both signed extremes return `true`. Portable artifact: `artifact/native-graph.json`, bound in `program.json` (5 external assertions, PASS on import).
