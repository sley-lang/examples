#!/usr/bin/env bash
# Reproduce the six composed 2.0.3 examples from their durable locations.
# Needs only this repo plus the official 2.0.3 agent binary — no pilot dir.
#
#   ./reproduce.sh --agent /path/to/sley-2.0.3-linux-x86_64/bin/sley-agent
#   ./reproduce.sh --dist  /path/to/sley-2.0.3-linux-x86_64.tar.gz
#
# --dist verifies the tarball sha256 against composed/toolchain.json, then
# unpacks it to a temp dir. Each example is imported from its checked-in
# pack into a fresh temp workspace (pack as base.pack + author names.json),
# then workbench `test` and the external checker are run. Views of the
# committed functions are refreshed into each views/fn.txt.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT=""
DIST=""
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

while [ $# -gt 0 ]; do
  case "$1" in
    --agent) AGENT="$2"; shift 2;;
    --dist) DIST="$2"; shift 2;;
    *) echo "unknown arg: $1 (want --agent PATH or --dist TARBALL)" >&2; exit 2;;
  esac
done

if [ -n "$DIST" ]; then
  [ -f "$DIST" ] || { echo "dist not found: $DIST" >&2; exit 2; }
  WANT="$(python3 -c "import json; print(json.load(open('$REPO/toolchain.json'))['release']['archive_sha256'])")"
  GOT="$(sha256sum "$DIST" | cut -d' ' -f1)"
  [ "$GOT" = "$WANT" ] || { echo "sha256 mismatch: got $GOT want $WANT" >&2; exit 1; }
  echo "dist sha256 OK"
  rm -rf "$WORK/dist" && mkdir -p "$WORK/dist"
  tar -xzf "$DIST" -C "$WORK/dist"
  AGENT="$(echo "$WORK"/dist/sley-2.0.3-linux-x86_64/bin/sley-agent)"
fi

[ -n "$AGENT" ] || { echo "missing --agent PATH or --dist TARBALL" >&2; exit 2; }
[ -x "$AGENT" ] || { echo "agent not executable: $AGENT" >&2; exit 2; }
"$AGENT" --version

# name pack-dir check-script expected-workbench expected-external
run_one() {
  echo "=== $1 ==="
  rm -rf "$WORK/$1" && mkdir -p "$WORK/$1"
  cp "$REPO/$2/$3" "$WORK/$1/base.pack"
  cp "$REPO/$2/packs/names.json" "$WORK/$1/names.json"
  "$AGENT" view --focus "$5" --workspace "$WORK/$1" > "$REPO/$2/views/fn.txt"
  "$AGENT" test --workspace "$WORK/$1"
  python3 "$REPO/$2/$4" --agent "$AGENT" --workspace "$WORK/$1" | tail -n 1
}

run_one retry-decision    retry-decision    packs/retry-committed.pack    tests/check_external.py    retry_decision
run_one invoice-line-total invoice-line-total packs/invoice-committed.pack tests/check_external.py    line_total
run_one duration-breakdown duration-breakdown packs/duration-committed.pack tests/check_external.py    split_duration
run_one page-window        page-window        packs/page-committed.pack       tests/check_external.py    page_window
run_one ledger-post        ledger-post        packs/ledger-committed.pack     tests/check_external.py    post_ledger
run_one window-overlap     window-overlap     packs/overlap-committed.pack    tests/check_external.py    window_overlap

echo "All six composed examples reproduced from durable locations."
