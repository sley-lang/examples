# Equals Answer (S05)

Decides whether a signed value equals `42` with native `equal`.

Reproduce:

```sh
TOOLS=/path/to/sley-tools   # sley-tools v0.0.1-rc.5 from github.com/sley-lang/tools (pairs with the 2.0.1 core)
CORE=/path/to/sley-2.0.1-linux-x86_64/bin/sley   # the pinned 2.0.1 core
"$TOOLS" init /tmp/sst-equals-answer \
  --graph programs/equals-answer/build/graph.json \
  --tests programs/equals-answer/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-equals-answer
```

Only `["42"]` returns `true`. Portable artifact: `artifact/native-graph.json` (5 external assertions, PASS on import).
