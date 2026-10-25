# Boolean Status (S07)

Reports conjunction, disjunction, and joint negation of two `Bool` inputs in one record `{both, either, neither}` using native `bool_and`, `bool_or`, `bool_not`, and `record_new`.

Reproduce:

```sh
TOOLS=/path/to/sley-tools   # sley-tools v0.0.1-rc.5 from github.com/sley-lang/tools (pairs with the 2.0.1 core)
CORE=/path/to/sley-2.0.1-linux-x86_64/bin/sley   # the pinned 2.0.1 core
"$TOOLS" init /tmp/sst-bool-status \
  --graph programs/bool-status/build/graph.json \
  --tests programs/bool-status/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-bool-status
```

`[true,true]` returns `{"both":true,"either":true,"neither":false}`; `[false,false]` returns `{"both":false,"either":false,"neither":true}`. Portable artifact: `artifact/native-graph.json` (4 external assertions, PASS on import).
