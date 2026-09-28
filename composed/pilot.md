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
