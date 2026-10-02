#!/usr/bin/env bash
# Rebuild every simple-tools native package from its checked-in recipe and cases.
# Verifies init + test, binds a fresh portable artifact, reimports into a fresh
# workspace, and re-tests. Refreshes program.json and artifact/native-graph.json.
set -euo pipefail

TOOLS=""
CORE=""
ALLOW_DIRTY=0
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for arg in "$@"; do
  case "$arg" in
    --tools=*) TOOLS="${arg#--tools=}";;
    --tools) shift;;
    --core=*) CORE="${arg#--core=}";;
    --core) shift;;
    --allow-dirty) ALLOW_DIRTY=1;;
  esac
done
# Support space-separated form too.
while [ $# -gt 0 ]; do
  case "$1" in
    --tools) TOOLS="$2"; shift 2;;
    --core) CORE="$2"; shift 2;;
    --allow-dirty) ALLOW_DIRTY=1; shift;;
    *) shift;;
  esac
done

[ -n "$TOOLS" ] || { echo "missing --tools /path/to/sley-tools" >&2; exit 2; }
[ -n "$CORE" ] || { echo "missing --core /path/to/sley" >&2; exit 2; }
[ -x "$TOOLS" ] || { echo "tools binary not executable: $TOOLS" >&2; exit 2; }
[ -x "$CORE" ] || { echo "core binary not executable: $CORE" >&2; exit 2; }

if [ "$ALLOW_DIRTY" -eq 0 ] && [ -d "$REPO/.git" ]; then
  if [ -n "$(git -C "$REPO" status --porcelain)" ]; then
    echo "repo has uncommitted changes; pass --allow-dirty to rebuild anyway" >&2
    exit 2
  fi
fi

PROGRAMS="bool-and bool-nor bool-or uint32-minimum is-negative is-positive at-or-below at-or-above equals-answer not-equal safe-add safe-sub safe-mul safe-neg bool-status"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

for p in $PROGRAMS; do
  echo "=== $p ==="
  rm -rf "$WORK/sst-$p" "$WORK/sst-$p-reimport"
  "$TOOLS" init "$WORK/sst-$p" \
    --graph "$REPO/programs/$p/build/graph.json" \
    --tests "$REPO/programs/$p/tests/cases.json" \
    --core "$CORE" > /dev/null
  "$TOOLS" test --project "$WORK/sst-$p" > /dev/null
  "$TOOLS" artifact export --project "$WORK/sst-$p" \
    --output "$WORK/sst-$p/artifact/native-graph.json" --bind-manifest > /dev/null
  cp "$WORK/sst-$p/program.json" "$REPO/programs/$p/program.json"
  cp "$WORK/sst-$p/artifact/native-graph.json" "$REPO/programs/$p/artifact/native-graph.json"
  "$TOOLS" artifact import "$REPO/programs/$p/artifact/native-graph.json" \
    "$WORK/sst-$p-reimport" --core "$CORE" > /dev/null
  "$TOOLS" test --project "$WORK/sst-$p-reimport" > /dev/null
  echo "PASS $p"
done

echo "All 15 programs rebuilt, reimported, and re-tested."
