# At Or Below Zero (S14)

Decides whether an `SInt64` value is at or below zero with native `less_equal` against a zero constant — the inclusive mirror of `is-positive`.

Reproduce:

```sh
TOOLS=/path/to/sley-tools   # the sley-tools CLI from github.com/sley-lang/tools
CORE=/path/to/sley-2.0.1-linux-x86_64/bin/sley   # the pinned 2.0.1 core
"$TOOLS" init /tmp/sst-at-or-below \
  --graph programs/at-or-below/build/graph.json \
  --tests programs/at-or-below/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-at-or-below
```

`["0"]` returns `true`; `["1"]` returns `false`. Portable artifact: `artifact/native-graph.json` (5 external assertions, PASS on import).
