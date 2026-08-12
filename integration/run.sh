#!/usr/bin/env bash

# Integration test for the sqlite3-static-link package: verifies that a
# project depending on the ordinary upstream "sqlite3" opam package can
# switch its opam dependency to "sqlite3-static-link" without touching any
# of its dune files or OCaml source. The `integration/consumer` project
# below only ever references the library as "sqlite3" ((libraries sqlite3),
# `open Sqlite3`), exactly as it would against the upstream package.

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

prefix="$(mktemp -d)"
trap 'rm -rf "$prefix"' EXIT

echo "Building and installing sqlite3-static-link into $prefix..."
dune build @install
dune install --prefix="$prefix" sqlite3-static-link >/dev/null

echo "Building the consumer project against the installed package..."
export OCAMLPATH="$prefix/lib"
rm -rf integration/consumer/_build
# --root forces dune to treat integration/consumer as its own workspace
# instead of walking up to this repo's dune-project, so `(libraries
# sqlite3)` can only resolve through the installed, OCAMLPATH-visible
# sqlite3-static-link package, never through the local "sqlite3" library
# built above.
dune build --root integration/consumer
output="$(dune exec --root integration/consumer ./main.exe)"
if [ "$output" != "OK" ]; then
  echo "Integration test failed: expected 'OK', got '$output'" >&2
  exit 1
fi

echo "Integration test passed: consumer resolved (libraries sqlite3) to sqlite3-static-link."
