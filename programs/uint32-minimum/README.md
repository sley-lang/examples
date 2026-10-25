# UInt32 Minimum (S03)

Decides whether an unsigned `level` meets the configured minimum of `5` with native `greater_equal`.

Reproduce:

```sh
TOOLS=/path/to/sley-tools   # sley-tools v0.0.1-rc.5 from github.com/sley-lang/tools (pairs with the 2.0.1 core)
CORE=/path/to/sley-2.0.1-linux-x86_64/bin/sley   # the pinned 2.0.1 core
"$TOOLS" init /tmp/sst-uint32-minimum \
  --graph programs/uint32-minimum/build/graph.json \
  --tests programs/uint32-minimum/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-uint32-minimum
```

`["4"]` returns `false`; `["5"]` and `["4294967295"]` return `true`. Portable artifact: `artifact/native-graph.json` (5 external assertions, PASS on import).
