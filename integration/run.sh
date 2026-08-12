#!/usr/bin/env bash

# Integration test for the sqlite3-static-link package: verifies that a
# project depending on the ordinary upstream "sqlite3" opam package (built
# dynamically against the system libsqlite3) can switch its opam dependency
# to "sqlite3-static-link" (statically linked, no system libsqlite3 needed)
# without touching any of its dune files or OCaml source, and that the two
# behave identically. The `integration/consumer` project below only ever
# references the library as "sqlite3" ((libraries sqlite3), `open Sqlite3`),
# exactly as it would against the upstream package.
#
# Requires opam, since it installs the real upstream "sqlite3" package (and
# its system libsqlite3 dependency) into the current switch.

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

static_prefix="$(mktemp -d)"
dynamic_prefix="$(mktemp -d)"
trap 'rm -rf "$static_prefix" "$dynamic_prefix"' EXIT

echo "Building and installing sqlite3-static-link (static) into $static_prefix..."
dune build @install
dune install --prefix="$static_prefix" sqlite3-static-link >/dev/null

echo "Installing the upstream sqlite3 (dynamic) opam package into $dynamic_prefix..."
opam install sqlite3 --destdir="$dynamic_prefix" --yes >/dev/null

run_consumer() {
  local ocamlpath="$1"
  rm -rf integration/consumer/_build
  # --root forces dune to treat integration/consumer as its own workspace
  # instead of walking up to this repo's dune-project, so `(libraries
  # sqlite3)` can only resolve through the installed, OCAMLPATH-visible
  # package, never through the local "sqlite3" library built above.
  OCAMLPATH="$ocamlpath" dune build --root integration/consumer >&2
  OCAMLPATH="$ocamlpath" dune exec --root integration/consumer ./main.exe
}

echo "Running the consumer against the dynamically-linked upstream sqlite3..."
dynamic_output="$(run_consumer "$dynamic_prefix/lib")"

echo "Running the consumer against the statically-linked sqlite3-static-link..."
static_output="$(run_consumer "$static_prefix/lib")"

echo "dynamic: $dynamic_output"
echo "static:  $static_output"

if [ "$dynamic_output" != "$static_output" ]; then
  echo "Integration test failed: dynamic and static sqlite3 gave different results" >&2
  exit 1
fi

echo "Integration test passed: (libraries sqlite3) resolves to both sqlite3 and sqlite3-static-link with the same effect."
