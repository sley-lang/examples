# Admission probe: function edit on a fresh import (C01 pack)

Question: does the split-commit limitation still apply when the workspace
is a fresh import that already contains the final committed tests?

## Procedure (temporary workspace, not retained)

1. Fresh workspace from durable material only:
   `packs/retry-committed.pack` → `base.pack`, `packs/names.json` →
   `names.json` (i.e. the `reproduce.sh` import path).
2. Baseline: `test` → **11/11 passed**.
3. Small function edit via a `fns`-redefine frame (probe input, not
   retained): the policy op `["go", "le", "attempt", "limit"]` replaced
   with `["go", "ge", "limit", "attempt"]` — the same predicate with
   swapped operands, so all 11 expectations must still hold. No test
   touched, no guard weakened.
4. `try` → `c1: Valid (+0 created, 1 replaced, 0 deleted)`, draft d1@r1,
   `tests: 11/11 passed [provided 11]`. The pre-existing final tests ran
   against the edited function and passed, confirming behavioral
   equivalence.
5. `submit d1` → `submitted c1 from d1@r1`, candidate accepted.
6. `commit c1` → refused, exit 2, verbatim:

```text
error AGENT_SUBMISSION_REFUSED: commit refused: TXN_TEST_EVIDENCE_UNSUPPORTED
```

(A first attempt with `commit d1` was refused with
`AGENT_HANDLE_UNKNOWN: 'd1' is not a candidate handle, file, or stored
hex` — a handle-shape usage error on the operator side, corrected to
`commit c1`; the outcome above is the workbench's answer to the correct
invocation.)

## Result

The limitation persists on fresh imports: even with the final tests
present and passing (11/11 provided), a candidate carrying test evidence
cannot be committed atomically. The edit was left uncommitted in the
temporary workspace; the retained C01 example is unchanged. A documented
refusal — not a blocker to retaining the examples, and not to be worked
around by removing tests or weakening policy.
