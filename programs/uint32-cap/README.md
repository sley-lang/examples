# UInt32 Cap (S11)

Decides whether an unsigned `count` stays within the configured cap of `100` with native `less_equal`.

`"100"` returns `true`; `"101"` and `"4294967295"` return `false`. Portable artifact: `artifact/native-graph.json`, bound in `program.json` (5 external assertions, PASS on import).
