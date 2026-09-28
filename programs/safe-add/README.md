# Safe Add (S06)

Adds two `SInt64` values with native `int_add_checked` and reports overflow in a one-field record `{sum: CheckedSInt64}`.

Reproduce:

```sh
TOOLS=~/Work/workspaces/sley-lang-tools/target/debug/sley-tools
CORE=/tmp/sley-simple-core/sley-2.0.1-linux-x86_64/bin/sley
"$TOOLS" init /tmp/sst-safe-add \
  --graph programs/safe-add/build/graph.json \
  --tests programs/safe-add/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-safe-add
```

`["2","3"]` returns `{"sum":{"ok":"5"}}`; `["9223372036854775807","1"]` returns `{"sum":{"error":{"code":1}}}`. Portable artifact: `artifact/native-graph.json` (5 external assertions, PASS on import).
