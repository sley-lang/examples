# Not Equal (S13)

Decides whether an `SInt64` value differs from 42 with native `not_equal` against a constant, completing the equality pair beside `equals-answer`.

Reproduce:

```sh
TOOLS=/path/to/sley-tools   # the sley-tools CLI from github.com/sley-lang/tools
CORE=/path/to/sley-2.0.1-linux-x86_64/bin/sley   # the pinned 2.0.1 core
"$TOOLS" init /tmp/sst-not-equal \
  --graph programs/not-equal/build/graph.json \
  --tests programs/not-equal/tests/cases.json --core "$CORE"
"$TOOLS" test --project /tmp/sst-not-equal
```

`["42"]` returns `false`; anything else (`41`, `43`, `0`, `-42`) returns `true`. Portable artifact: `artifact/native-graph.json` (5 external assertions, PASS on import).
