# Sley Examples

[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-3b82f6)](LICENSE)
[![sleylang.org](https://img.shields.io/badge/sleylang.org-website-22d3ee)](https://sleylang.org)
[![Follow @SleyLanguage](https://img.shields.io/badge/@SleyLanguage-000000?logo=x&logoColor=white)](https://x.com/SleyLanguage)

Thirty small [Sley](https://github.com/sley-lang/sley) programs you can run, test and change.
Seventeen primitives each exercise one to three native operations, such as checked addition or a Boolean
combinator. Thirteen composed programs solve everyday problems: retry decisions, invoice line
totals, page windows, ledger posting, quorum decisions, days in a month. Every example ships its
authoring input, a portable executable artifact, independently expected cases and a script that
rebuilds or reimports it and checks the results.

Counts, kept as separate categories: 233 external assertions across the corpus (78 primitive +
155 composed) and 155 advisory workbench checks in the composed collection.

## Run the composed examples

With the [Sley 2.1.6 release](https://github.com/sley-lang/sley#quickstart) unpacked next to this
checkout:

```sh
git clone https://github.com/sley-lang/examples.git && cd examples
./composed/reproduce.sh --agent ../sley-2.1.6-linux-x86_64/bin/sley-agent
```

The script imports each example's checked-in pack into a fresh workspace, runs its workbench
tests and its external checker, and refreshes `views/fn.txt`, which comes out identical.

New programs are easiest to write in Sley's typed Python dialect (`sley-agent try --familiar`);
the [Sley Quickstart](https://github.com/sley-lang/sley#write-and-test-your-first-program) starts
there. The [sley-lang/tools](https://github.com/sley-lang/tools) toolkit (the `sley-tools` CLI,
Python/TypeScript/MCP SDKs, Playground, Repair Lab, Data Pipe, importers and Review) built the
primitives below. Its own N01–N10 catalog of ready-to-run programs is not duplicated here.

## Primitive examples (17 total, 78 external assertions)

| ID | Program | What runs natively | Cases |
|----|---------|-------------------|-------|
| S01 | `programs/bool-and` | `bool_and` on two `Bool` | 4 |
| S02 | `programs/bool-nor` | `bool_or` + `bool_not` | 4 |
| S03 | `programs/uint32-minimum` | `greater_equal` vs minimum 5 | 5 |
| S04 | `programs/is-negative` | `less_than` vs 0 | 5 |
| S05 | `programs/equals-answer` | `equal` vs 42 | 5 |
| S06 | `programs/safe-add` | `int_add_checked` → `{sum: CheckedSInt64}` | 5 |
| S07 | `programs/bool-status` | `bool_and`/`bool_or`/`bool_not` → `{both, either, neither}` | 4 |
| S08 | `programs/is-positive` | `greater_than` vs 0 | 5 |
| S09 | `programs/safe-sub` | `int_sub_checked` → `{difference: CheckedSInt64}` | 5 |
| S10 | `programs/bool-or` | `bool_or` on two `Bool` | 4 |
| S11 | `programs/safe-mul` | `int_mul_checked` → `{product: CheckedSInt64}` | 5 |
| S12 | `programs/safe-neg` | `int_neg_checked` → `{negated: CheckedSInt64}` | 5 |
| S13 | `programs/not-equal` | `not_equal` vs 42 → `Bool` | 5 |
| S14 | `programs/at-or-below` | `less_equal` vs 0 → `Bool` | 5 |
| S15 | `programs/at-or-above` | `greater_equal` vs 0 → `Bool` | 5 |
| S16 | `programs/bool-not` | `bool_not` → `Bool` | 2 |
| S17 | `programs/wrap-ok` | `result_ok` → `{wrapped: CheckedSInt64}` | 5 |

Each package holds `build/graph.json` (authoring recipe), `tests/cases.json` (independently expected), `program.json` (manifest bound to the artifact by `sley-tools artifact export --bind-manifest`), and `artifact/native-graph.json` (portable native graph). The accepted SSMC1 graph is the program; the recipe is only the authoring input. Sley has no canonical source text. Later cores also accept optional text authoring (the familiar frontend from 2.0.5, the Python dialect from 2.1.1), which compiles to the same graph; these examples do not use it.

## Toolchain pin

- Core: Sley `2.0.1` (`sley-2.0.1-linux-x86_64.tar.gz`, commit `c748dda`), binary sha `90f48df4…`.
- Builder: [`sley-lang/tools`](https://github.com/sley-lang/tools) `sley-tools` backend, `graph_authoring.v0`.
- External execution assertions: 78 total across the seventeen programs, all PASS at build time; every artifact reimports into a fresh workspace and re-passes.
- Native test admission: `PENDING_CORE_EXECUTOR` on the selected 2.0.1 core (`NOT_RUN: production native executor unavailable`). This is reported separately and is not covered by the assertion counts above.

## Rebuild everything

```sh
./scripts/rebuild.sh \
  --tools /path/to/sley-tools-v0.0.1-rc.5/bin/sley-tools \
  --core /path/to/sley-2.0.1-linux-x86_64/bin/sley
```

Use `sley-tools` [`v0.0.1-rc.5`](https://github.com/sley-lang/tools/releases/tag/v0.0.1-rc.5)
for the 2.0.1 pin: each `sley-tools` release targets one core, and rc.5 is
the release built for 2.0.1 (`sley-tools --version` prints the tested core
commit, `c748dda…`). `--tools=PATH` and `--core=PATH` are accepted too.

The script re-runs `init` + `test` + bound `artifact export` + fresh-workspace `artifact import` + re-`test` for all seventeen programs and refreshes `program.json` and `artifact/native-graph.json` in place. It refuses to run with uncommitted changes unless `--allow-dirty` is passed. Entity and object ids are assigned per workspace, so every rebuild rewrites the artifacts and manifests even when the recipes are unchanged; review a rebuild diff for changes to the core pin, interface or cases rather than ids.

## Running with newer Sley releases

The checked-in examples also run on current releases without changes:

- **Composed (C01–C13):** `./composed/reproduce.sh --agent` with the Sley
  2.1.6 `sley-agent` reproduces all thirteen examples: 155/155 workbench
  checks, 155/155 external assertions, and identical `views/fn.txt`
  (checked 2026-10-26; 2.1.5 gave the same on 2026-10-24). Every
  per-example reproduce block in `composed/*/README.md` passed the same way
  with 2.1.5.
  `--dist` verifies only the pinned 2.0.3 archive, so pass `--agent` for a
  newer release.
- **Primitives (S01–S17):** `sley-tools`
  [`v0.0.1-rc.6`](https://github.com/sley-lang/tools/releases/tag/v0.0.1-rc.6)
  targets the Sley 2.1.1 core and imports the checked-in 2.0.1 artifacts
  directly: `sley-tools artifact import programs/<id>/artifact/native-graph.json
  PROJECT --core /path/to/sley-2.1.1-linux-x86_64/bin/sley`, then
  `sley-tools test --project PROJECT`, re-passes all 78 assertions, and every
  input/output example in `programs/*/README.md` returns the documented value
  under `sley-tools run`. Running `rebuild.sh` with rc.6 and the 2.1.1 core
  also passes, and rebinds the artifacts to 2.1.1.

## Composed examples (C01–C13, sley-agent 2.0.3)

Thirteen composed programs authored with the official 2.0.3 `sley-agent`
workbench, kept in `composed/` strictly separate from the seventeen 2.0.1
primitives above. The 2.0.1 pin, the seventeen packages, and the rebuild script
are unchanged by them.

| ID | Example | Function | Workbench checks / External |
|----|---------|----------|-----------------------------|
| C01 | `composed/retry-decision` | `retry_decision` → `Result<RetryState,RetryError>` | 11 / 11 |
| C02 | `composed/invoice-line-total` | `line_total` → `Result<i64,InvoiceError>` | 12 / 12 |
| C03 | `composed/duration-breakdown` | `split_duration` → `Result<(d,h,m,s),DurationError>` | 9 / 9 |
| C04 | `composed/page-window` | `page_window` → `Result<(start,count,has_more),PageError>` | 16 / 16 |
| C05 | `composed/ledger-post` | `post_ledger` → `Result<i64,LedgerError>` | 15 / 15 |
| C06 | `composed/window-overlap` | `window_overlap` → `Result<(overlap,gap),WindowError>` | 15 / 15 |
| C07 | `composed/quorum-decision` | `quorum_decision` → `Result<QuorumOutcome,QuorumError>` | 14 / 14 |
| C08 | `composed/cooldown-gate` | `cooldown_gate` → `Result<(GateState,i64),GateError>` | 15 / 15 |
| C09 | `composed/days-in-month` | `days_in_month` → `Result<i64,DateError>` | 15 / 15 |
| C10 | `composed/clamp-value` | `clamp_value` → `Result<i64,ClampError>` | 10 / 10 |
| C11 | `composed/safe-quotient` | `safe_quotient` → `Result<i64,QuotientError>` | 8 / 8 |
| C12 | `composed/safe-absolute` | `abs_value` → `Result<i64,AbsError>` | 8 / 8 |
| C13 | `composed/sign-class` | `sign_class` → `Sign` | 7 / 7 |

Each example holds exact authoring frames as run, a contract (parameter
semantics, error precedence), independently expected cases, an external
checker, a readable workbench view, the exported pack plus author name
map, and a before/after record of one genuine program modification.
`composed/corrections.md` retains one repaired authoring error and two
independently justified expectation corrections.
`composed/admission-probe.md` records the fresh-import edit/commit probe.

Reproduce (needs the 2.0.3 agent binary):

```sh
./composed/reproduce.sh --agent /path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
```

The workbench and scripts need writable scratch space. If the default
temporary directory is small or quota-limited, point `TMPDIR` at a
writable directory before running (the scripts and the agent honor it);
no path is hardcoded and no cleanup infrastructure is provided.

Authoring workflow: `composed/authoring.md` is the default — pinned guide
plus the frozen serializer/parse/recovery appendix first, with targeted
consultation of a small relevant example only when a specific problem
warrants it.

Persistence limitation: a combined code+tests `commit` is refused
(`TXN_TEST_EVIDENCE_UNSUPPORTED`), so each example was committed split —
code-only, then tests-after (transactions in `catalog.json`). Code-only
plus tests-after is two transactions, not a test-admitted atomic commit.
Native test admission is not run — unavailable in 2.0 — and no count in
`composed/` is test admission.

## More Sley

- [sleylang.org](https://sleylang.org): documentation, the Python dialect and the walkthrough.
- [Sley Arena](https://sleylang.org/arena): write a bot in Sley and climb a public ladder.
- [sley-lang/tools](https://github.com/sley-lang/tools): the toolkit that built the primitives.

## License

This repository is licensed under the [Apache License, Version 2.0](LICENSE).
That covers the original examples, documentation, supporting scripts, and
project-owned artifacts, except where another license or notice is
expressly identified. See [NOTICE](NOTICE) for attribution.

---

<p align="center">
  <b>Found a useful pattern?</b> <a href="https://github.com/sley-lang/examples">Star Sley Examples on GitHub</a> · <a href="https://x.com/SleyLanguage">Follow @SleyLanguage</a> · <a href="https://sleylang.org">sleylang.org</a>
</p>

<p align="center"><sub>Built by <a href="https://greyforge.tech">Greyforge Labs</a></sub></p>
