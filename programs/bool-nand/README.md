# Boolean Nand (S13)

Negates the conjunction of two `Bool` inputs with native `bool_and` then `bool_not`. Completes the boolean basis set with S01 (and) and S02 (nor).

Only `[true, true]` returns `false`. Portable artifact: `artifact/native-graph.json`, bound in `program.json` (4 external assertions, PASS on import).
