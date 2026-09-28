# Safe Mul (S09)

Multiplies `a` by `b` with native `int_mul_checked`; result is `{product: CheckedSInt64}`.

`["6","7"]` returns `{"product":{"ok":"42"}}`; `["9223372036854775807","2"]` returns `{"product":{"error":{"code":1}}}`. Portable artifact: `artifact/native-graph.json`, bound in `program.json` (5 external assertions, PASS on import).
