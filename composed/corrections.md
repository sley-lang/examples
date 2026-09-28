# Corrections retained from the pilot

Three corrections were made during authoring. Each is kept with its
evidence and its independent justification. None of them weakens a guard,
removes a test, or loosens a policy to make checks pass.

## CORRECTION-1 — repaired authoring error (retry policy edit)

During the retry `lt` → `le` modification, the first edit attempt used an
`edit`/`replace_op`-style payload with the operation written name-first
(`["go", "le", ...]` in the `with` position). The workbench refused it:
refusal `AGENT_FRAME_INVALID` in the workspace event log (seq 23, draft
d1@r2); the CLI stderr identified the unknown opcode `go`. The mechanism
is documented in `help guide`: `with` carries opcode-first
(`"with": ["mul?Overflow", "h", "w"]`), so the result name `go` was read
as an opcode. The original refused payload is not retained beyond that
refusal record.

The repair kept the same intent and used a valid operation: the retained
delta `retry-decision/frames/retry-fix1.json` (86 bytes)

```json
{"set": [{"at": "/fns/0/blocks/0/ops/2", "value": ["go", "le", "attempt", "limit"]}]}
```

applied through the `fill` path (event seq 26, `delta_targets: 1`,
draft d1@r3 → candidate c2), which then passed 11/11 workbench checks.
Lesson: address a single op in place with `set`/`fill`; do not invent
edit opcodes. Full account in `retry-decision/modifications.md`.

## CORRECTION-2 — wrong expectation after the retry policy change

After the policy changed to `attempt <= limit`, the draft expectation for
`(MAX, MAX)` was first written as `Exhausted` (carried over from the v1
table). The program returned `Retry`, and the program was right:
`MAX <= MAX` holds, both guards pass (`MAX >= 0`, `MAX >= 1`), and no
arithmetic runs on the inputs, so no overflow is possible. The expectation
was corrected to `{"Ok": "Retry"}` on that basis — justified from the
contract (`attempt <= limit` → `Retry`), not from the tool's output alone.
The same reasoning covers `(3, 3)` → `Retry` and `(1, 1)` → `Retry`.

## CORRECTION-3 — wrong hand-computed MAX row (duration days layer)

The first draft of the v2 duration table listed
`MAX → [106751991167, 7, 30, 7]`, computed by hand. Before running, it was
recomputed exactly (`divmod` chain) as `[106751991167300, 15, 30, 7]` and
cross-checked: `24*d + h = 24*106751991167300 + 15 = 2562047788015215`,
which reproduces the independently established v1 `MAX` hours exactly.
The corrected row went into `frames/duration-v2.json` and passes.
Justification: exact recomputation plus the cross-check against the v1
boundary result — not the tool's output alone.
