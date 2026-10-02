# Is Positive (S08)

Decides whether a signed value is above zero with native `greater_than` against constant `0`.

Reproduce:

```sh
TOOLS=~/Work/workspaces/sley-lang-tools/target/debug/sley-tools
CORE=/tmp/sley-simple-core/sley-2.0.1-linux-x86_64/bin/sley
"$TOOLS" init /tmp/sst-is-positive \
  --graph programs/is-positive/build/graph.json \
  --tests programs/is-positive/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-is-positive
```

`"1"` and `"9223372036854775807"` return `true`; `"0"` and below return `false`. Portable artifact: `artifact/native-graph.json` (5 external assertions, PASS on import).
