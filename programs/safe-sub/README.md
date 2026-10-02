# Safe Sub (S09)

Subtracts two `SInt64` values with native `int_sub_checked` and reports overflow in a one-field record `{difference: CheckedSInt64}`.

Reproduce:

```sh
TOOLS=~/Work/workspaces/sley-lang-tools/target/debug/sley-tools
CORE=/tmp/sley-simple-core/sley-2.0.1-linux-x86_64/bin/sley
"$TOOLS" init /tmp/sst-safe-sub \
  --graph programs/safe-sub/build/graph.json \
  --tests programs/safe-sub/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-safe-sub
```

`["5","3"]` returns `{"difference":{"ok":"2"}}`; `["9223372036854775807","-1"]` returns `{"difference":{"error":{"code":1}}}`. Portable artifact: `artifact/native-graph.json` (5 external assertions, PASS on import).
