# Boolean Negation (S16)

Negates one `Bool` value with native `bool_not` (unary `operand` slot) — the dedicated single-op primitive for the last Boolean op previously exercised only inside `bool-status`.

Reproduce:

```sh
TOOLS=~/Work/workspaces/sley-lang-tools/target/debug/sley-tools
CORE=/tmp/sley-simple-core/sley-2.0.1-linux-x86_64/bin/sley
"$TOOLS" init /tmp/sst-bool-not \
  --graph programs/bool-not/build/graph.json \
  --tests programs/bool-not/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-bool-not
```

Two cases cover the complete input domain (`true→false`, `false→true`). Portable artifact: `artifact/native-graph.json` (2 external assertions, PASS on import).
