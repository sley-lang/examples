# retry_decision — worked modification (lt → le)

The initial frame (`frames/retry-v1.json`) used a strict policy:
`attempt < limit` → `Retry`. Under it, a budget exactly consumed meant
exhaustion: `(3, 3)` → `Exhausted`, `(1, 1)` → `Exhausted`,
`(MAX, MAX)` → `Exhausted`. Workbench checks 10/10, external 10/10.

## Before (v1, candidate c1)

- `(3, 3)` → `{"Ok": "Exhausted"}`
- `(1, 1)` → `{"Ok": "Exhausted"}`
- `(MAX, MAX)` → `{"Ok": "Exhausted"}`

## Authoring input (repair path)

The first edit attempt used an `edit`/`replace_op`-style payload with the
operation written name-first in the `with` position. The workbench refused
it. The workbench event log records refusal `AGENT_FRAME_INVALID`
(event seq 23, draft d1@r2); the CLI stderr identified the unknown
opcode `go` — per `help guide`, `with` carries opcode-first, so the result
name `go` was read as an opcode.

The retained repair delta (`frames/retry-fix1.json`, 86 bytes) sets one op
in place and was applied through the `fill` path (event seq 26,
`delta_targets: 1`, draft d1@r3 → candidate c2):

```json
{"set": [{"at": "/fns/0/blocks/0/ops/2", "value": ["go", "le", "attempt", "limit"]}]}
```

i.e. the policy op changed from `["go", "lt", "attempt", "limit"]` to
`["go", "le", "attempt", "limit"]`. This episode is also recorded as
CORRECTION-1 in `composed/corrections.md`. It changed one comparison
operator, not an argument value.

## After (v2, candidate c2 → committed)

Workbench checks 11/11, external 11/11 (`tests/check_external.py`):

- `(3, 3)` → `{"Ok": "Retry"}`
- `(1, 1)` → `{"Ok": "Retry"}`
- `(MAX, MAX)` → `{"Ok": "Retry"}`
- `(4, 3)` → `{"Ok": "Exhausted"}` (new boundary case added to the table)
- Guards unchanged: `(-1, 3)` → `Err(NegativeAttempt)`,
  `(0, 0)` → `Err(BadLimit)`

Final code as committed (transaction `96994710`) is
`frames/retry-code.json`; final tests as committed (transaction `8e8e8384`)
are `frames/retry-tests.json`. Both verified field-equal to the committed
candidates.
