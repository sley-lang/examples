# Safe Mul (S11)

Multiplies two `SInt64` values with native `int_mul_checked` and reports overflow in a one-field record `{product: CheckedSInt64}`.

Reproduce:

```sh
TOOLS=/path/to/sley-tools   # sley-tools v0.0.1-rc.5 from github.com/sley-lang/tools (pairs with the 2.0.1 core)
CORE=/path/to/sley-2.0.1-linux-x86_64/bin/sley   # the pinned 2.0.1 core
"$TOOLS" init /tmp/sst-safe-mul \
  --graph programs/safe-mul/build/graph.json \
  --tests programs/safe-mul/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-safe-mul
```

`["6","7"]` returns `{"product":{"ok":"42"}}`; `["9223372036854775807","2"]` returns `{"product":{"error":{"code":1}}}`. Portable artifact: `artifact/native-graph.json` (5 external assertions, PASS on import).
