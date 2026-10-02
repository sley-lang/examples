# At Or Above Zero (S15)

Decides whether an `SInt64` value is at or above zero with native `greater_equal` against a zero constant — the inclusive mirror of `is-positive`, completing the comparison set beside `is-negative`.

Reproduce:

```sh
TOOLS=~/Work/workspaces/sley-lang-tools/target/debug/sley-tools
CORE=/tmp/sley-simple-core/sley-2.0.1-linux-x86_64/bin/sley
"$TOOLS" init /tmp/sst-at-or-above \
  --graph programs/at-or-above/build/graph.json \
  --tests programs/at-or-above/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-at-or-above
```

`["0"]` returns `true`; `["-1"]` returns `false`. Portable artifact: `artifact/native-graph.json` (5 external assertions, PASS on import).
