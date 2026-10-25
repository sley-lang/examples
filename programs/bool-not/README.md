# Boolean Negation (S16)

Negates one `Bool` value with native `bool_not` (unary `operand` slot) — the dedicated single-op primitive for the last Boolean op previously exercised only inside `bool-status`.

Reproduce:

```sh
TOOLS=/path/to/sley-tools   # sley-tools v0.0.1-rc.5 from github.com/sley-lang/tools (pairs with the 2.0.1 core)
CORE=/path/to/sley-2.0.1-linux-x86_64/bin/sley   # the pinned 2.0.1 core
"$TOOLS" init /tmp/sst-bool-not \
  --graph programs/bool-not/build/graph.json \
  --tests programs/bool-not/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-bool-not
```

Two cases cover the complete input domain (`true→false`, `false→true`). Portable artifact: `artifact/native-graph.json` (2 external assertions, PASS on import).
