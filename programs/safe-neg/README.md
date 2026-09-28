# Safe Neg (S10)

Negates one `SInt64` with native `int_neg_checked`; result is `{negated: CheckedSInt64}`.

`["5"]` returns `{"negated":{"ok":"-5"}}`; `["-9223372036854775808"]` returns `{"negated":{"error":{"code":1}}}` (negation of the minimum overflows). Portable artifact: `artifact/native-graph.json`, bound in `program.json` (5 external assertions, PASS on import).
