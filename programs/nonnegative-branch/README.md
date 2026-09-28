# Nonnegative Branch (S14)

Decides nonnegativity with an explicit two-way native branch: the entry block tests `value < 0` and `cond_branch` selects the `negative` block (returns `false`) or the `nonnegative` block (returns `true`). First multi-block program in this repo; all others are single-block.

`"-1"` returns `false`; `"0"` and `"1"` return `true`. Portable artifact: `artifact/native-graph.json`, bound in `program.json` (5 external assertions, PASS on import; 12 native objects).
