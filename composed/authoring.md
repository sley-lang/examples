# Authoring discipline for composed examples (sley-agent 2.0.3)

Authoritative copy of the frame-authoring discipline. Agent-facing
instructions elsewhere (e.g. `README.md`) point here; the text below is
the single source, not duplicated. `pilot.md` and its recorded results
are historical and unchanged by this file.

## Default workflow

1. Start with the pinned guide (`sley-agent help guide`, plus
   `help afx|af1|opcodes|types|refusals` as needed) and the frozen
   appendix below — not preloaded example packages.
2. Construct AF1/AF1-X frames as structured data, serialize with an
   existing JSON library, and parse the exact file bytes before
   submitting the file to `sley-agent try`.
3. Preserve exact numeric values and supported AF1/AF1-X representations
   (no hand-edited minified heredocs, no invented opcodes or edit verbs).
4. Do not resubmit an unchanged rejected file without a specific reason.
5. After three unsuccessful repairs of the same failure pattern,
   reconstruct the frame from structured data rather than repeating
   dumps or superficial edits. Reconstruction continues within the
   original task cap; it does not reset any budget.
6. Consult a small relevant example when a specific unresolved problem
   warrants it. Do not wait for an entire attempt to fail before
   consulting, and do not read the whole corpus automatically. Record
   any consultation that materially helped in the example's own notes.

Local parsing checks syntax only; Sley remains authoritative for
validation of the envelope, dialect, types, and program.

## Frozen appendix (verbatim)

Frozen `2026-09-28T07:10:48Z`, sha256
`43adb7a672c0400187a2f85af687eb31cdfd8746d14ffb2f1d3d96f09f51fa94`,
demonstrated in the diagnostic repeat to coincide with zero
JSON-envelope refusals across six attempts. Preserved exactly:

- Construct AF1/AF1-X frames as structured data and serialize them with an
  existing JSON library, preserving exact numeric values and supported types.
- Locally parse the exact file bytes before submitting that file to
  `sley-agent try`. Locally invalid JSON never reaches `try`.
- JSON parsing checks syntax only; Sley still judges the envelope, dialect,
  types, and program.
- Do not resubmit an unchanged rejected file without a specific reason.
- After three unsuccessful repairs of the same failure pattern, reconstruct
  the frame from structured data instead of repeating dumps or superficial
  edits. Continue within the original task cap; reconstruction does not
  reset the budget.

This is serializer-produced JSON via existing tools (e.g. python3 json),
not a new canonical format, parser, normalizer, or authoring language.
No helper framework is built around it.

## Package standard (summary; each example demonstrates it)

- Contract fixed before implementation: input domains, output meaning,
  boundaries, overflow behavior, error precedence.
- Exact authoring frames as run, readable workbench view, exported pack
  plus the workbench's author name map.
- Independently specified expected results with boundary and negative
  cases; an external checker invoking the committed function.
- One genuine program modification with observed before/after behavior.
- Reproduction from durable files in a fresh workspace
  (`reproduce.sh --agent …`).
- Persistence via the documented split route (combined code+tests commit
  is refused with `TXN_TEST_EVIDENCE_UNSUPPORTED`); workbench checks,
  external assertions, persistence, and native test admission are
  reported separately. Never delete tests or weaken policy to force a
  commit.
