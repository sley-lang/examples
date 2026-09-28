# Composed examples (C01–C09, sley-agent 2.0.3)

Nine composed Sley programs authored with the official 2.0.3 `sley-agent`
workbench, kept strictly separate from the seven 2.0.1 primitive examples
in `programs/`. Nothing here changes the 2.0.1 pin, the seven primitives,
or the serious toolkit — and no new framework was introduced: each example
is authoring frames in, workbench checks plus external assertions out,
with an exported pack for reimport.

| ID | Example | Function | Checks / External |
|----|---------|----------|-------------------|
| C01 | `retry-decision` | `retry_decision(attempt,limit) -> Result<RetryState,RetryError>` | 11 / 11 |
| C02 | `invoice-line-total` | `line_total(qty,unit,fee) -> Result<i64,InvoiceError>` | 12 / 12 |
| C03 | `duration-breakdown` | `split_duration(total) -> Result<(d,h,m,s),DurationError>` | 9 / 9 |
| C04 | `page-window` | `page_window(total,page,per_page) -> Result<(start,count,has_more),PageError>` | 16 / 16 |
| C05 | `ledger-post` | `post_ledger(balance,debit,credit,overdraft) -> Result<i64,LedgerError>` | 15 / 15 |
| C06 | `window-overlap` | `window_overlap(s1,e1,s2,e2) -> Result<(overlap,gap),WindowError>` | 15 / 15 |
| C07 | `quorum-decision` | `quorum_decision(yes,no,abstain,quorum) -> Result<QuorumOutcome,QuorumError>` | 14 / 14 |
| C08 | `cooldown-gate` | `cooldown_gate(failures,threshold,now,tripped_at,cooldown) -> Result<(GateState,i64),GateError>` | 15 / 15 |
| C09 | `days-in-month` | `days_in_month(year,month) -> Result<i64,DateError>` | 15 / 15 |

Toolchain identity: `toolchain.json` (release archive, sha256, binary
shas, build commit). The release documentation's own composition sketches
were starting points only; every claim below was observed by execution.

## Authoring discipline

New examples are authored under `authoring.md` (single authoritative
copy): pinned guide plus the frozen serializer/parse/recovery appendix
first, no preloaded example packages; a small relevant example is
consulted only when a specific unresolved problem warrants it.

## Reproduce (no pilot directory needed)

```sh
./reproduce.sh --agent /path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
# or: ./reproduce.sh --dist /path/to/sley-2.0.3-linux-x86_64.tar.gz
```

The script verifies the tarball sha256 against `toolchain.json` (for
`--dist`), imports each checked-in pack into a fresh temp workspace
(`base.pack` + author `names.json`), runs workbench `test` and the
example's external checker, and refreshes `views/fn.txt`.

## Persistence limitation (explicit)

A combined code+tests `commit` is refused on every workspace with
`AGENT_SUBMISSION_REFUSED: commit refused: TXN_TEST_EVIDENCE_UNSUPPORTED`.
Each example was therefore persisted split: a code-only commit
(`--untested`) followed by a tests-after commit. Transactions:

- C01: code `96994710`, tests `8e8e8384`
- C02: code `773fea0f`, tests `81a8a6da`
- C03: code `fb236485`, tests `a94779c9`
- C04: code `8da11225`, tests `7f14f6e7`
- C05: code `84d85be1`, tests `235440e4`
- C06: code `ff526edf`, tests `65a093d7`
- C07: code `73c40f0b`, tests `0d2b561b`
- C08: code `3be8a5b0`, tests `b4e51dd4`
- C09: code `10e4887c`, tests `cf4e4cab`

Code-only plus tests-after is two transactions, **not** a test-admitted
atomic commit. See `admission-probe.md` for the fresh-import edit/commit
probe.

## Outcome ledger (kept separate)

- **Advisory workbench checks**: `try`/`test` kernel-executed checks —
  11/11, 12/12, 9/9, 16/16, 15/15, 15/15, 14/14, 15/15, 15/15. Advisory only; they do not admit tests to any core.
- **External assertions**: `tests/check_external.py` per example invokes
  the committed function through the agent CLI and compares against
  independently listed cases — 11/11, 12/12, 9/9, 16/16, 15/15, 15/15,
  14/14, 15/15, 15/15 at commit time.
- **Persistence**: split commits above, plus export packs that reimport
  into fresh workspaces and re-pass (verified again by `reproduce.sh`).
- **Native test admission**: not run — unavailable in 2.0
  (`NOT_RUN: production native executor unavailable`, same status as the
  2.0.1 primitives). No count in this tree is test admission.

## Conventions

Each example mirrors the `programs/` package shape where practical:
`contract.md`, `frames/` (exact authoring inputs as run), `tests/cases.json`
(independently expected cases) + `tests/check_external.py`, `views/`
(readable workbench view), `packs/` (export + name map), `modifications.md`
(before/after inputs and observed results), `README.md`. `corrections.md`
collects the retained corrections with their justifications. `pilot.md`
records the example-assisted learning smoke test (methodology and
aggregates only; held-out material stays out of the repo).
