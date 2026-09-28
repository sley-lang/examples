# UInt32 Minimum (S03)

Decides whether an unsigned `level` meets the configured minimum of `5` with native `greater_equal`.

Reproduce:

```sh
TOOLS=~/Work/workspaces/sley-lang-tools/target/debug/sley-tools
CORE=/tmp/sley-simple-core/sley-2.0.1-linux-x86_64/bin/sley
"$TOOLS" init /tmp/sst-uint32-minimum \
  --graph programs/uint32-minimum/build/graph.json \
  --tests programs/uint32-minimum/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-uint32-minimum
```

`"4"` returns `false`; `"5"` and `"4294967295"` return `true`. Portable artifact: `artifact/native-graph.json` (5 external assertions, PASS on import).
