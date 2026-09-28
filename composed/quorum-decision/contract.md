# quorum_decision — contract

`(yes: i64, no: i64, abstain: i64, quorum: i64) -> Result<QuorumOutcome,QuorumError>`

Decides a governance vote. `yes`, `no`, and `abstain` are ballot counts;
`quorum` is the minimum number of ballots present for any decision.
Abstentions count toward presence (quorum) but are not votes cast and
never decide the outcome.

## Parameter semantics

- `yes`, `no`, `abstain` = ballot counts. Each must be `>= 0`; a negative
  count returns `Err(NegativeVotes)`.
- `quorum` = minimum ballots present. Must be `>= 1`; anything less
  returns `Err(BadQuorum)`. There is no zero-quorum configuration: at
  least one ballot must be present.
- `present = yes + no + abstain`, checked; `cast = yes + no`, checked.
  Both additions always run, so an absurd count overflows before the
  quorum rule below applies.

## Policy (final, v2)

1. `present < quorum` → `Ok(NoQuorum)`: too few ballots present for any
   decision, even a unanimous one.
2. Otherwise the majority is of votes cast only: `yes > no` →
   `Ok(Pass)`, `yes < no` → `Ok(Fail)`, `yes = no` → `Ok(Tie)`.
   Abstentions never move the outcome: `(1, 0, 3)` with quorum met →
   `Pass` (the single vote cast decides), and `(0, 0, 5)` → `Tie`
   (quorum met, no majority either way). The initial v1 policy counted
   abstentions with the `no` side; the worked modification removes them
   (see `modifications.md`).

## Error precedence (evaluation order in `entry`)

1. `NegativeVotes` — checked first, in order `yes`, `no`, `abstain`.
   `(-1, 0, 0, 0)` yields `NegativeVotes`, not `BadQuorum`.
2. `BadQuorum` — checked second.
3. `Overflow` — from `yes + no`, then from `cast + abstain`. Arithmetic
   runs before the quorum branch, so an unrepresentable total reports
   `Overflow` even when the vote would fail quorum.

## Types

- `QuorumError = NegativeVotes | BadQuorum | Overflow`
- `QuorumOutcome = Pass | Fail | Tie | NoQuorum`
