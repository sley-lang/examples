# Wrap Checked Success (S17)

Wraps one `SInt64` value in the checked success arm with native `result_ok` and reports it in a one-field record `{wrapped: CheckedSInt64}` — the constructor counterpart to the checked-arithmetic error arm.

Reproduce:

```sh
TOOLS=~/Work/workspaces/sley-lang-tools/target/debug/sley-tools
CORE=/tmp/sley-simple-core/sley-2.0.1-linux-x86_64/bin/sley
"$TOOLS" init /tmp/sst-wrap-ok \
  --graph programs/wrap-ok/build/graph.json \
  --tests programs/wrap-ok/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-wrap-ok
```

Every input succeeds, including both `i64` extremes: `["-9223372036854775808"]` returns `{"wrapped":{"ok":"-9223372036854775808"}}`. Portable artifact: `artifact/native-graph.json` (5 external assertions, PASS on import).
