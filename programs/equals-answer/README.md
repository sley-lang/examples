# Equals Answer (S05)

Decides whether a signed value equals `42` with native `equal`.

Reproduce:

```sh
TOOLS=~/Work/workspaces/sley-lang-tools/target/debug/sley-tools
CORE=/tmp/sley-simple-core/sley-2.0.1-linux-x86_64/bin/sley
"$TOOLS" init /tmp/sst-equals-answer \
  --graph programs/equals-answer/build/graph.json \
  --tests programs/equals-answer/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-equals-answer
```

Only `"42"` returns `true`. Portable artifact: `artifact/native-graph.json` (5 external assertions, PASS on import).
