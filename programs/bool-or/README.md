# Boolean Or (S10)

Disjoins two `Bool` inputs with one native `bool_or` operation.

Reproduce against the pinned core:

```sh
TOOLS=/path/to/sley-tools   # sley-tools v0.0.1-rc.5 from github.com/sley-lang/tools (pairs with the 2.0.1 core)
CORE=/path/to/sley-2.0.1-linux-x86_64/bin/sley   # the pinned 2.0.1 core
"$TOOLS" init /tmp/sst-bool-or \
  --graph programs/bool-or/build/graph.json \
  --tests programs/bool-or/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-bool-or
```

Portable artifact: `artifact/native-graph.json`, bound in `program.json`.
Reimport check: `sley-tools artifact import artifact/native-graph.json PROJECT --core "$CORE"` then `sley-tools test` (4 external assertions, PASS).
Native core test admission is `PENDING_CORE_EXECUTOR` on the selected 2.0.1 core; cases are external assertions against native execution.
