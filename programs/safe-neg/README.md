# Safe Neg (S12)

Negates one `SInt64` value with native `int_neg_checked` (unary `operand` slot) and reports overflow in a one-field record `{negated: CheckedSInt64}`.

Reproduce:

```sh
TOOLS=/path/to/sley-tools   # sley-tools v0.0.1-rc.5 from github.com/sley-lang/tools (pairs with the 2.0.1 core)
CORE=/path/to/sley-2.0.1-linux-x86_64/bin/sley   # the pinned 2.0.1 core
"$TOOLS" init /tmp/sst-safe-neg \
  --graph programs/safe-neg/build/graph.json \
  --tests programs/safe-neg/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-safe-neg
```

`["5"]` returns `{"negated":{"ok":"-5"}}`; `["-9223372036854775808"]` returns `{"negated":{"error":{"code":1}}}`. Portable artifact: `artifact/native-graph.json` (5 external assertions, PASS on import).
