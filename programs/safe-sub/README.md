# Safe Sub (S08)

Subtracts `b` from `a` with native `int_sub_checked`; result is `{difference: CheckedSInt64}`.

`["10","4"]` returns `{"difference":{"ok":"6"}}`; `["9223372036854775807","-1"]` returns `{"difference":{"error":{"code":1}}}`. Portable artifact: `artifact/native-graph.json`, bound in `program.json` (5 external assertions, PASS on import).
