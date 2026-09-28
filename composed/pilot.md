# Example-assisted learning pilot (directional smoke test)

Six attempts, one inexpensive agent, three unseen tasks, two conditions.
This is a directional smoke test, NOT a statistically conclusive
benchmark. Held-out task statements, reference solutions, and evaluator
cases are deliberately NOT in this repo (they live in a scratch area
outside the corpus); only methodology and aggregates are recorded here.

## Harness (actually used, no framework built)

- `opencode run --dir <attempt> --model opencode-go/glm-5.3-flash --auto
  --format json`, one process per attempt, 8-minute wall cap each.
- Same model, tools, prompt scaffolding, and caps for all six attempts.
  Run order alternated per task: T1 (A then B), T2 (B then A), T3 (A then B).
- Condition A: pinned guide (the 2.0.3 `help`/`afx`/`opcodes` text as
  files) + the task statement. No corpus paths, no examples.
- Condition B: identical guide + task + two relevant verified examples
  from this corpus (each: `contract.md`, final code frame,
  `tests/cases.json`, `views/fn.txt`), copied into the attempt dir.
- Each attempt worked in its own scratch directory from an empty seed
  pack. Grading: the attempt's self-contained `solution.json` was run
  through `try` in a FRESH workspace and checked against private cases
  via `call`. Success = all private cases pass.
- The three tasks were unseen checked-arithmetic compositions (two
  linear, one requiring a branch), none present in the S, N, or C
  corpus; reference solutions were validated against the private cases
  before the pilot ran.

## Results (harness-reported tokens/cost, summed over run steps)

| Attempt | Private cases | Elapsed | Steps | Input tok | Output tok | Cost (USD) |
|---------|---------------|---------|-------|-----------|------------|------------|
| T1A (guide) | 12/12 | 61s | 10 | 53,636 | 4,807 | 0.020464 |
| T1B (guide+examples) | 12/12 | 305s | 10 | 155,661 | 3,193 | 0.032629 |
| T2A (guide) | 15/15 | 64s | 13 | 46,891 | 3,449 | 0.021012 |
| T2B (guide+examples) | 15/15 | 478s | 110 | 421,323 | 15,527 | 0.261518 |
| T3A (guide) | 13/13 | 150s | 18 | 65,369 | 9,484 | 0.036228 |
| T3B (guide+examples) | 13/13 | 152s | 24 | 59,387 | 4,852 | 0.039700 |

Totals: success 3/3 in A, 3/3 in B. Six-attempt cost $0.411551
(harness-reported; compute is not claimed free). B consumed ~3.8x the
input tokens of A (165,896 vs 636,371), almost entirely the supplied
example files. One B attempt (T2B) thrashed for 110 steps / 478s —
near the cap — yet still passed; the other two B attempts finished in
comparable time to their A twins. Audited solutions were genuine
implementations (guards + checked arithmetic + branch), not hardcodes.

## Reading

- Ceiling effect: with these tasks and this model, the guide alone
  sufficed, so success does not discriminate between conditions. The
  pilot does NOT show that examples help (or hurt); it shows the corpus
  examples are readable and usable by a cheap agent (all B attempts
  actually read the supplied contracts/frames/cases/views) without
  breaking its workflow.
- Cost direction: supplying examples raises input-token spend several
  fold; whether that buys success on harder tasks is untested here.

## Restriction audit (from run transcripts)

- A attempts: zero references to corpus paths; guide + task + workspace only.
- B attempts: read only the supplied example files inside their own dirs.
- No attempt read another attempt, the task source files, the reference
  solutions, or the evaluator. One B attempt listed the scratch parent
  directory (filenames only); it read no content outside its own dir.
- Caveat: restriction was by instruction plus isolated directories plus
  post-hoc audit — not a sandbox. A sufficiently adversarial agent could
  have read the filesystem; these did not.

## Limitations

n=6, one model, tasks designed to be solvable, wall-clock includes model
latency, token/cost figures are harness-reported sums (not independently
metered). Unavailable measurements: none — elapsed, steps, tokens, and
cost were all reported; per-step latency breakdown was not collected.

## Audit (post-hoc transcript reconciliation, no new model calls)

Reconciled from the six retained `run.jsonl` transcripts plus the
`run_attempt.sh` accounting (`result.txt`). No new tasks, calls,
spend, or framework. Task IDs stay opaque; no task text, solutions,
evaluator cases, or solution-bearing excerpts are included.

### Reconciled paired table (harness-reported sums)

| Attempt | Private | Elapsed | Steps (=model reqs) | Tool calls | Input / Output tok | Cache read / write | Cost (USD) | Try refusals | Failing test runs | Commit try/refused |
|---------|---------|---------|---------------------|------------|--------------------|--------------------|------------|--------------|-------------------|--------------------|
| T1A | 12/12 | 61s | 10 | 10 | 53,636 / 4,807 | 333,824 / 0 | 0.020464 | 0 | 0 | 0 / 0 |
| T1B | 12/12 | 305s | 10 | 16 | 155,661 / 3,193 | 256,128 / 0 | 0.032629 | 0 | 0 | 0 / 0 |
| T2A | 15/15 | 64s | 13 | 13 | 46,891 / 3,449 | 408,448 / 0 | 0.021012 | 2 (1 literal-range, 1 wrong-path IO) | 1 (9/10 then 10/10) | 0 / 0 |
| T2B | 15/15 | 478s | 110 | 119 | 421,323 / 15,527 | 6,351,872 / 0 | 0.261518 | 8 frame-envelope (1 initial JSON, 2 envelope/dialect, 5 same-offset JSON) | 0 (1/1, 2/2, 10/10 Valid runs) | 0 / 0 |
| T3A | 13/13 | 150s | 18 | 21 | 65,369 / 9,484 | 722,688 / 0 | 0.036228 | 2 (1 literal-type, 1 propagation) | 0 | 0 / 0 |
| T3B | 13/13 | 152s | 24 | 28 | 59,387 / 4,852 | 945,536 / 0 | 0.039700 | 2 (1 wrong-path IO, 1 scope with 2 obligations) | 0 | 0 / 0 |

Harness tool-level errors (not workbench refusals): T1A 2 write-fallbacks,
T1B 2 write-fallbacks, T2A 1 write-fallback, T2B 3 wrong-path reads +
1 write-fallback, T3A 2 unrelated search-tool errors, T3B 2 write-fallbacks.
No attempt ran a `commit`; `TXN_TEST_EVIDENCE_UNSUPPORTED` appears nowhere
in the six transcripts, so repeated commit-refusal is not an observed cause.

Totals reconcile exactly: A input 53,636+46,891+65,369=165,896 (~166k);
B input 155,661+421,323+59,387=636,371 (~636k); combined cost
0.020464+0.032629+0.021012+0.261518+0.036228+0.039700=0.411551.
No numeric overwrite was needed.

### Metric definitions (what the harness counts)

- `Steps` = count of `step_finish` events (one model iteration each,
  ending `tool-calls` or `stop`). Model requests = steps; not separately metered.
- `Input tok` = sum of `tokens.input` across `step_finish`. This excludes
  `tokens.cache.read`, which is reported separately per step.
- `Total` per step = `input + cache.read + output` here (`cache.write` is 0
  in all six records, so there is no write accounting to add). Do not sum
  `input + cache.read + total`; that double-counts.
- Cumulative input (the table) is the sum across requests, not peak context.
  Peak single-step `total` for reference: T1A 41,767; T1B 47,668;
  T2A 37,086; T2B 77,520; T3A 49,245; T3B 46,976.
- `Cost` = sum of `part.cost` across `step_finish` (harness-reported, not
  independently metered). `Elapsed` = wall time around the single
  `opencode run` process per attempt (includes model latency and tool exec);
  per-step latency breakdown was not collected.
- `Tool calls` = count of `tool_use` events; it can exceed steps when one
  step issues parallel calls (e.g. T1B 16 calls / 10 steps).

### Expensive B attempt (110 steps / 478s, near the 480s cap)

Phases from transcript ordering (119 tool calls: 16 reads, 2 globs,
1 write-attempt, 100 bash):

1. Guide + supplied-example reads, including 3 wrong-path guesses repaired
   by listing then reading the correct filenames. Small one-time cost.
2. Initial frame refused as invalid JSON; help queries on refusals, types,
   dialect, and drafts.
3. Minimal probes: single-case Valid, then a two-case probe that introduced
   the persistent same-offset JSON refusal. ~20 follow-up probes re-dumped
   the same ~469-byte file (`od`, byte offsets, local Python parses) and
   re-hit the identical refusal; local Python and the workbench agreed on
   the offset, confirming malformed JSON rather than a kernel judgment.
4. Outside-dir reference reads plus a pretty-printed rewrite generated via
   script: first multi-case Valid. Final frame then Valid (10/10 authored),
   followed by submit, two calls, and the solution write. Post-Valid work is
   only the last few steps.

Quantified contributors: per-step fresh input averaged ~3.8k (T2B) vs
~3.6k (T2A twin), so the 421,323 vs 46,891 gap scales with step count
(110 vs 13), not per-step size. Two mid-run steps with `cache.read=0`
resent 66,866+67,100=133,966 fresh input (31.8% of the attempt's input);
the rest is the long cached tail (cumulative cache-read 6,351,872, peak
total 77,520). Final artifact size does not show copied example structure
(B solution bytes are smaller than the A twin's on this pair).

Observed vs hypothesis: observed = JSON-envelope thrash, self-generated
debug-output resend, two prefix-cache misses, outside-dir reads, and late
first task-Valid (only the final ~5 steps are post-Valid). Not observed =
commit-refusal loop (zero commits), scope/checked-result routing errors on
this attempt, or verbatim example-structure copying. The co-occurrence with
condition B does not by itself show examples caused the slowdown.

### Pair comparison (primary result keeps all attempts)

- B/A input: T1 2.90x, T2 8.99x, T3 0.91x (B used fewer input tokens).
  B/A cost: T1 1.59x, T2 12.45x, T3 1.10x. B/A time: T1 5.0x, T2 7.5x, T3 1.01x.
- Overall B/A input 636,371/165,896=3.84x. The expensive attempt holds
  421,323/636,371=66.2% of B input (52.5% of all six attempts' input) and
  63.5% of total cost.
- Secondary sensitivity only: dropping the entire T2 pair (not just the
  expensive B run) leaves A 119,005 vs B 215,048 (T1+T3 only) — still B
  higher, but n=2. No significance claim is made from three pairs.
- Equal success (3/3 both conditions) permits an efficiency comparison but
  establishes no general model capability and no training-data effect. The
  isolation qualification stands: instruction plus separate dirs plus
  post-hoc audit, not a sandbox.

### Corrections to the earlier prose (not silent overwrites)

- "Almost entirely the supplied example files": corrected. Example bytes
  (~11KB on disk per B attempt) add per-step overhead, but the B total is
  dominated by the T2 step-count amplification plus the two cache-miss
  resends above. T3B with examples used fewer input tokens than T3A.
- Restriction audit "read no content outside its own dir": corrected. One B
  attempt additionally read reference-frame content outside its dir (6+
  reads) and staged via a `/tmp` path outside its dir; another B attempt
  verified its solution via a `/tmp` path outside its dir. Still observed:
  no reads of other attempts, task sources, reference solutions, or the
  evaluator. Parent-dir listing remained filenames-only.
- "Unavailable measurements: none": corrected. Per-step tokens/cache/cost,
  tool-call counts, and refusal texts exist in `run.jsonl` but were not in
  the pilot table (now reconciled above); per-step latency breakdown
  remains uncollected and figures remain harness-reported.

### Uncertainties and recommended next experiment

Unknowns: the exact byte-level cause of the minified-tail JSON failure
beyond "both parsers agree at the same offset" (records show valid-looking
ASCII but consistent refusal; the pretty-printed rewrite succeeded, so no
kernel bug is established); why exactly two steps lost prefix cache
(provider eviction vs elapsed-time expiry vs size — no cache-TTL or
per-step timing in records); exact per-step example-token cost (no
tokenizer breakdown in records).

Single most justified adjustment (not run): author frames through a script
that emits canonical JSON and local-parses before `try` (never hand-edit
minified heredocs), with an early stop after three identical refusals at
the same offset forcing a from-scratch pretty-printed rewrite. Rationale:
the pretty-printed rewrite ended a ~50-step identical-offset loop
immediately in the observed transcript.

## Diagnostic repeat R2 (shared JSON-authoring appendix; no new corpus/framework)

Diagnostic rerun of the same three tasks, evaluator, pinned guide, and
exact per-task example files — not a fresh held-out benchmark. No corpus
batch, framework, or core changes; programs, artifacts, tests, pins,
original records, and the above audit are preserved.

### Frozen method (verbatim; frozen before any R2 result)

Frozen file `/tmp/sley-pilot-r2/APPENDIX_FROZEN.md`
(sha256 `43adb7a672c0400187a2f85af687eb31cdfd8746d14ffb2f1d3d96f09f51fa`,
`2026-09-28T07:10:48Z`), copied verbatim into each attempt as
`appendix.md` and read after the pinned guide under both conditions:

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

Serializer-produced JSON via existing tools (e.g. python3 json); not a new
canonical format, parser, normalizer, or authoring language. No new helper
framework was built.

Harness identity: `opencode 1.18.32`, model string
`opencode-go/glm-5.3-flash` (same string as the original pilot; the
original opencode version was unrecorded so full version sameness cannot
be verified), `sley-agent 2.0.3`, seed pack sha256
`13bd44079dd8756c81ea3513999d8b0f85169e2abd662353bc7f8dfa8d933dea`,
guide/task/example bytes verified identical to the original
(`GUIDE_SAME`, `TASK_SAME`, `EX_SAME` diff checks). One `opencode run`
process per attempt with `--auto --format json` and the same 480s wall
cap. Run order alternating, same scheme as the original: T1 A then B,
T2 B then A, T3 A then B.

Permitted access (frozen in `/tmp/sley-pilot-r2/PROTOCOL_FROZEN.md` before
execution, applied equally): A = guide + appendix + task only, inside its
own dir, no corpus. B = same plus ONLY its two supplied example files
inside its own `examples/`. Both execute the workbench binary only and
work only in their own dir; prior attempts, transcripts, the above audit,
task sources, reference solutions, evaluator files, other R2 dirs, and
filesystem search for Sley material are forbidden. Isolation remains
instruction-plus-audit, not a sandbox.

### R2 results (same metric definitions as the audit; harness-reported sums)

| Attempt | Private | Elapsed | Steps | Tools | Input / Output | Cache rd / wr | Cost | Sley JSON/envelope | Other authoring | Local-JSON caught | Unchanged resubmit | Reconstruct |
|---------|---------|---------|-------|-------|----------------|---------------|------|--------------------|-----------------|-------------------|--------------------|-------------|
| R2-T1A | 12/12 | 44s | 8 | 10 | 47,378 / 2,156 | 257,536 / 0 | 0.015911 | 0 | 0 | 0 | 0 | not triggered |
| R2-T1B | 12/12 | 101s | 22 | 30 | 145,600 / 3,973 | 879,232 / 0 | 0.050203 | 0 | 1 harness usage-flag | 0 | 0 | not triggered |
| R2-T2A | 15/15 | 51s | 8 | 8 | 63,641 / 1,953 | 209,152 / 0 | 0.016797 | 0 | 1 missing-file IO after local script fail | 1 (script NameError, never sent) | 0 | not triggered |
| R2-T2B | 15/15 | 312s | 11 | 14 | 118,052 / 3,612 | 320,640 / 0 | 0.029133 | 0 | 0 | 0 | 0 | not triggered |
| R2-T3A | 13/13 | 225s | 19 | 20 | 55,036 / 12,468 | 722,688 / 0 | 0.036170 | 0 | 1 propagation + 2 failing test runs (8/10, 8/10, then 10/10) | 1 (script NameError, never sent) | 0 | not triggered |
| R2-T3B | 13/13 | 154s | 23 | 29 | 165,412 / 7,466 | 928,768 / 0 | 0.056408 | 0 | 2 scope + 2 unknown-handle + 1 usage-flag; 1 failing run (14/15) then 15/15 | 0 | 0 | not triggered |

No timeouts (`rc=0` all six), no missing solutions, no commit attempts.
Metric definitions unchanged: steps = `step_finish` count; input = summed
`tokens.input` (cache-read separate, never added to input); cost = summed
`part.cost`; elapsed = wall around the single run process; tools =
`tool_use` count. No double-counting; nothing invented.

Aggregates: R2 A input 47,378+63,641+55,036=166,055; R2 B input
145,600+118,052+165,412=429,064 (B/A 2.58x). R2 A cost
0.015911+0.016797+0.036170=0.068878; R2 B cost
0.050203+0.029133+0.056408=0.135744 (B/A 1.97x). R2 A time
44+51+225=320s; R2 B time 101+312+154=567s (B/A 1.77x). Six-attempt total
$0.204622. Success 3/3 in A and 3/3 in B (observed alongside costs, kept
in the aggregate).

Descriptive comparison with the original (same three pairs, no causal or
general claim; one repeat cannot prove causation): original A 165,896 /
$0.077704 / 275s vs original B 636,371 / $0.333847 / 935s (B/A 3.84x
input, 4.30x cost, 3.40x time; total $0.411551). R2 A input is nearly
identical to original A (166,055 vs 165,896); R2 B input is lower than
original B (429,064 vs 636,371) because the long loop did not recur —
the T2 pair collapsed from 46,891 vs 421,323 (13 vs 110 steps, 64 vs
478s) to 63,641 vs 118,052 (8 vs 11 steps, 51 vs 312s). Per-pair R2 B/A
input: T1 3.07x, T2 1.86x, T3 3.01x; cost: T1 3.16x, T2 1.73x, T3 1.56x;
time: T1 2.30x, T2 6.12x (steps 8 vs 11, so time gap is latency, not
iteration count), T3 0.68x (B faster). R2-T2B remains the slowest R2
attempt (312s) despite only 11 steps; two single steps account for ~140s
of wall time and the harness records no per-step latency breakdown, so
the cause (provider latency vs tool wait) is uncollected — same
limitation as the original.

Guidance adherence: all six attempts read `appendix.md` and built frames
through an existing JSON library with a byte-level local reparse before
every `try` (transcript markers: `parsed OK`, `parse ok`, `wrote+reparsed
OK`, `local parse ok, bytes:`). Zero locally-invalid JSON reached `try`
(zero Sley JSON/envelope refusals across all six, vs 8 on the original
expensive attempt). The two local script failures (R2-T2A, R2-T3A) were
caught before submission, which is the intended behavior. All repairs
changed the artifact (byte sizes evolve; no unchanged rejected file was
resubmitted). The three-repair reconstruction rule never triggered
because no same-pattern failure reached three; agents rebuilt from
structured data each iteration regardless.

Protocol deviations: R2-T3B staged helper scripts and deltas under
`/tmp/opencode/` (outside its own dir) — a work-only-dir violation;
no reads of forbidden content (prior attempts, task sources, reference
solutions, evaluator, audit, other R2 dirs, corpus beyond its two
supplied examples) were observed for any attempt, and no parent/scratch
listing beyond its own dir except that staging path. No result-driven
reruns, example substitutions, or mid-run tuning; exactly six measured
attempts, failures retained.

Answers: (1) Repeated JSON-failure loops did not recur — zero Sley
JSON/envelope refusals in six attempts; the original 110-step loop's
signature (identical-offset resubmits, dump/token resend) is absent.
(2) The serialization/parse/no-resubmit guidance was followed by all
six; the reconstruction clause was never triggered; one staging
violation (R2-T3B `/tmp/opencode` temp files) is retained above.
(3) Supplied examples did not improve success here (3/3 both conditions,
same ceiling as the original) and did not justify their measured cost on
these tasks: +263,009 input tokens (+158%), +$0.066866 (+97%), +247s
(+77%) for B over A with equal observed success. (4) Uncertain: why R2-T2B
took 312s over 11 steps (no per-step timing); whether the appendix or
chance ended the loop (one repeat, no control without appendix); exact
per-step example-token cost (no tokenizer breakdown); whether examples
pay off on harder tasks where the guide alone fails (untested — success
did not discriminate here).

Evidence-supported recommendation: keep the frozen appendix as the
default authoring discipline (it coincides with zero JSON-envelope
refusals across six attempts and first-try Valid on four of six, vs the
original loop), but do not make supplied examples the default: after the
improvement they still cost ~2.6x input / ~2.0x cost / ~1.8x time at
equal success, so gate examples to tasks where the guide-plus-appendix
alone observably fails. No further experiment was run and the corpus was
not altered for this repeat.
