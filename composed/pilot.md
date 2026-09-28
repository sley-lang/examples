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
