# Boolean Nor (S02)

Negates the disjunction of two `Bool` inputs with native `bool_or` then `bool_not`.

Reproduce:

```sh
TOOLS=~/Work/workspaces/sley-lang-tools/target/debug/sley-tools
CORE=/tmp/sley-simple-core/sley-2.0.1-linux-x86_64/bin/sley
"$TOOLS" init /tmp/sst-bool-nor \
  --graph programs/bool-nor/build/graph.json \
  --tests programs/bool-nor/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-bool-nor
```

Only `[false, false]` returns `true`. Portable artifact: `artifact/native-graph.json`, bound in `program.json` (4 external assertions, PASS on import).
