(lang dune 2.7)

(name sqlite3-static-link)

(generate_opam_files false)

(source
 (github mmottl/sqlite3-ocaml))

(license MIT)

(homepage "https://mmottl.github.io/sqlite3-ocaml")

(documentation "https://mmottl.github.io/sqlite3-ocaml/api")

(maintainers "Markus Mottl <markus.mottl@gmail.com>")

(authors "Markus Mottl <markus.mottl@gmail.com>"
  "Christian Szegedy <csdontspam@metamatix.com>")

(package
 (name sqlite3-static-link)
 (synopsis "SQLite3 bindings for OCaml (statically linked)")
 (description
   "Drop-in replacement for the [sqlite3] opam package that statically links the SQLite amalgamation. The amalgamation is generated at build time from the upstream sqlite/sqlite git submodule pinned to a specific release tag (requires tclsh on the build host). The OCaml interface is unchanged: client code still does [open Sqlite3] / [(libraries sqlite3)].")
 (depends
  (ocaml
   (>= 4.12))
  (ppx_inline_test :with-test))
 (conflicts sqlite3)
 (tags (clib:sqlite3)))
