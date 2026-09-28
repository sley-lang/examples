# Is Negative (S04)

Decides whether a signed value is below zero with native `less_than` against constant `0`.

Reproduce:

```sh
TOOLS=~/Work/workspaces/sley-lang-tools/target/debug/sley-tools
CORE=/tmp/sley-simple-core/sley-2.0.1-linux-x86_64/bin/sley
"$TOOLS" init /tmp/sst-is-negative \
  --graph programs/is-negative/build/graph.json \
  --tests programs/is-negative/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-is-negative
```

`"-1"` and `"-9223372036854775808"` return `true`; `"0"` and above return `false`. Portable artifact: `artifact/native-graph.json` (5 external assertions, PASS on import).
