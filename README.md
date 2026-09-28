# Sley Simple Tools

Primitive Sley examples: seven native `graph_authoring.v0` packages with bound portable artifacts and independently expected cases. These are primitive examples of single operations and small compositions — not substantial end-user tools. They exist to pin the verified 2.0.1 authoring baseline: one readable recipe per program, one executable artifact, and a round-trip check each.

This repo complements the serious adoption toolkit in `sley-lang-tools` (Rust `sley-tools` CLI, Python/TypeScript/MCP SDKs, Playground, Repair Lab, Data Pipe, importers, Review). That toolkit is the machinery; this repo holds small native programs built with it. It does not duplicate the N01–N10 catalog (release-readiness, resource-admission, benchmark trio, tier-classifier, range-predicate, bounded-clamp, quota-remaining, generated-payload-validator).

## Primitive examples (7 total, 32 external assertions)

| ID | Program | What runs natively | Cases |
|----|---------|-------------------|-------|
| S01 | `programs/bool-and` | `bool_and` on two `Bool` | 4 |
| S02 | `programs/bool-nor` | `bool_or` + `bool_not` | 4 |
| S03 | `programs/uint32-minimum` | `greater_equal` vs minimum 5 | 5 |
| S04 | `programs/is-negative` | `less_than` vs 0 | 5 |
| S05 | `programs/equals-answer` | `equal` vs 42 | 5 |
| S06 | `programs/safe-add` | `int_add_checked` → `{sum: CheckedSInt64}` | 5 |
| S07 | `programs/bool-status` | `bool_and`/`bool_or`/`bool_not` → `{both, either, neither}` | 4 |

Each package holds `build/graph.json` (authoring recipe), `tests/cases.json` (independently expected), `program.json` (manifest bound to the artifact by `sley-tools artifact export --bind-manifest`), and `artifact/native-graph.json` (portable native graph). Sley has no source syntax: the accepted SSMC1 graph is the program; the recipe is only the authoring input.

## Toolchain pin

- Core: Sley `2.0.1` (`sley-2.0.1-linux-x86_64.tar.gz`, commit `c748dda`), binary sha `90f48df4…`.
- Builder: `sley-lang-tools` `sley-tools` backend, `graph_authoring.v0`.
- External execution assertions: 32 total across the seven programs, all PASS at build time; every artifact reimports into a fresh workspace and re-passes.
- Native test admission: `PENDING_CORE_EXECUTOR` on the selected 2.0.1 core (`NOT_RUN: production native executor unavailable`). This is reported separately and is not covered by the assertion counts above.

## Rebuild everything

```sh
./scripts/rebuild.sh \
  --tools ~/Work/workspaces/sley-lang-tools/target/debug/sley-tools \
  --core /tmp/sley-simple-core/sley-2.0.1-linux-x86_64/bin/sley
```

The script re-runs `init` + `test` + bound `artifact export` + fresh-workspace `artifact import` + re-`test` for all seven programs and refreshes `program.json` and `artifact/native-graph.json` in place. It refuses to run with uncommitted changes unless `--allow-dirty` is passed.

License and any publication decision remain owner calls; nothing here is published yet.

## Composed examples (C01–C03, sley-agent 2.0.3)

Three composed programs authored with the official 2.0.3 `sley-agent`
workbench, kept in `composed/` strictly separate from the seven 2.0.1
primitives above. The 2.0.1 pin, the seven packages, and the rebuild script
are unchanged by them.

| ID | Example | Function | Workbench checks / External |
|----|---------|----------|-----------------------------|
| C01 | `composed/retry-decision` | `retry_decision` → `Result<RetryState,RetryError>` | 11 / 11 |
| C02 | `composed/invoice-line-total` | `line_total` → `Result<i64,InvoiceError>` | 12 / 12 |
| C03 | `composed/duration-breakdown` | `split_duration` → `Result<(d,h,m,s),DurationError>` | 9 / 9 |

Each example holds exact authoring frames as run, a contract (parameter
semantics, error precedence), independently expected cases, an external
checker, a readable workbench view, the exported pack plus author name
map, and a before/after record of one genuine program modification.
`composed/corrections.md` retains one repaired authoring error and two
independently justified expectation corrections.
`composed/admission-probe.md` records the fresh-import edit/commit probe.

Reproduce without the pilot directory (needs the 2.0.3 agent binary):

```sh
./composed/reproduce.sh --agent /path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
```

Persistence limitation: a combined code+tests `commit` is refused
(`TXN_TEST_EVIDENCE_UNSUPPORTED`), so each example was committed split —
code-only, then tests-after (transactions in `catalog.json`). Code-only
plus tests-after is two transactions, not a test-admitted atomic commit.
Native test admission is not run — unavailable in 2.0 — and no count in
`composed/` is test admission.
