# Boolean And (S01)

Conjoins two `Bool` inputs with one native `bool_and` operation.

Reproduce against the pinned core:

```sh
TOOLS=~/Work/workspaces/sley-lang-tools/target/debug/sley-tools
CORE=/tmp/sley-simple-core/sley-2.0.1-linux-x86_64/bin/sley
"$TOOLS" init /tmp/sst-bool-and \
  --graph programs/bool-and/build/graph.json \
  --tests programs/bool-and/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-bool-and
```

Portable artifact: `artifact/native-graph.json`, bound in `program.json`.
Reimport check: `sley-tools artifact import artifact/native-graph.json PROJECT --core "$CORE"` then `sley-tools test` (4 external assertions, PASS).
Native core test admission is `PENDING_CORE_EXECUTOR` on the selected 2.0.1 core; cases are external assertions against native execution.
