# Sley Simple Tools

Micro programs written in Sley: native `graph_authoring.v0` packages with bound portable artifacts and independently expected cases. The goal is ecosystem breadth plus real Sley code for future models to study — small, readable, verifiable programs.

This repo complements the serious adoption toolkit in `sley-lang-tools` (Rust `sley-tools` CLI, Python/TypeScript/MCP SDKs, Playground, Repair Lab, Data Pipe, importers, Review). That toolkit is the machinery; this repo is the shelf of tiny native programs built with it. It does not duplicate the N01–N10 catalog (release-readiness, resource-admission, benchmark trio, tier-classifier, range-predicate, bounded-clamp, quota-remaining, generated-payload-validator).

## Programs (14 total, 65 external assertions)

| ID | Program | What runs natively | Cases |
|----|---------|-------------------|-------|
| S01 | `programs/bool-and` | `bool_and` on two `Bool` | 4 |
| S02 | `programs/bool-nor` | `bool_or` + `bool_not` | 4 |
| S03 | `programs/uint32-minimum` | `greater_equal` vs minimum 5 | 5 |
| S04 | `programs/is-negative` | `less_than` vs 0 | 5 |
| S05 | `programs/equals-answer` | `equal` vs 42 | 5 |
| S06 | `programs/safe-add` | `int_add_checked` → `{sum: CheckedSInt64}` | 5 |
| S07 | `programs/bool-status` | `bool_and`/`bool_or`/`bool_not` → `{both, either, neither}` | 4 |
| S08 | `programs/safe-sub` | `int_sub_checked` → `{difference: CheckedSInt64}` | 5 |
| S09 | `programs/safe-mul` | `int_mul_checked` → `{product: CheckedSInt64}` | 5 |
| S10 | `programs/safe-neg` | `int_neg_checked` → `{negated: CheckedSInt64}` | 5 |
| S11 | `programs/uint32-cap` | `less_equal` vs cap 100 | 5 |
| S12 | `programs/is-nonzero` | `not_equal` vs 0 | 5 |
| S13 | `programs/bool-nand` | `bool_and` + `bool_not` | 4 |
| S14 | `programs/nonnegative-branch` | `cond_branch` on sign test (3 blocks) | 5 |

Each package holds `build/graph.json` (authoring recipe), `tests/cases.json` (independently expected), `program.json` (manifest bound to the artifact by `sley-tools artifact export --bind-manifest`), and `artifact/native-graph.json` (portable native graph). Sley has no source syntax: the accepted SSMC1 graph is the program; the recipe is only the authoring input.

## Toolchain pin

- Core: Sley `2.0.1` (`sley-2.0.1-linux-x86_64.tar.gz`, commit `c748dda`), binary sha `90f48df4…`.
- Builder: `sley-lang-tools` `sley-tools` backend, `graph_authoring.v0`.
- Native core test admission: `PENDING_CORE_EXECUTOR` on this core — all cases are external assertions against native execution, all PASS at build time, and every artifact reimports into a fresh workspace and re-passes.

## Rebuild everything

```sh
./scripts/rebuild.sh \
  --tools ~/Work/workspaces/sley-lang-tools/target/debug/sley-tools \
  --core /tmp/sley-simple-core/sley-2.0.1-linux-x86_64/bin/sley
```

The script re-runs `init` + `test` + bound `artifact export` + fresh-workspace `artifact import` + re-`test` for all seven programs and refreshes `program.json` and `artifact/native-graph.json` in place. It refuses to run with uncommitted changes unless `--allow-dirty` is passed.

License and any publication decision remain owner calls; nothing here is published yet.
