# SQLite3-OCaml - SQLite3 Bindings for OCaml

## What is SQLite3-OCaml?

SQLite3-OCaml is an [OCaml](http://www.ocaml.org) library with bindings to the
[SQLite3](http://www.sqlite.org) client API. Sqlite3 is a self-contained,
serverless, zero-configuration, transactional SQL database engine with
outstanding performance.

The design of these bindings allows for a friendly coexistence with the old
(version 2) SQLite and its OCaml wrapper `ocaml-sqlite`.

## Usage

The API documentation is in file `src/sqlite3.mli` and also here:
[online](http://mmottl.github.io/sqlite3-ocaml/api/sqlite3).

SQLite3 has its own [online documentation](http://www.sqlite.org/docs.html).

### Examples

The `test`-directory in this distribution contains simple examples for
testing features of this library. You can execute the tests by running:
`dune runtest`.

### SQLite source

The SQLite C source is consumed via a git submodule pinned to a specific
upstream tag (`vendor/sqlite`, currently `version-3.47.2`). Initialize it
after cloning:

```sh
git submodule update --init --recursive
```

The amalgamation (`sqlite3.c`, `sqlite3.h`, `sqlite3ext.h`) is generated at
build time from the submodule. This requires `tclsh` and a working C
toolchain on the build host. The resulting object is statically linked into
the OCaml library, so loadable extensions are disabled
(`SQLITE3_DISABLE_LOADABLE_EXTENSIONS`).

To bump SQLite, check out a different tag in `vendor/sqlite` and commit the
submodule pointer.

### Drop-in replacement for the `sqlite3` opam package

The opam package is named `sqlite3-static-link` (and conflicts with
`sqlite3`), but the OCaml library it installs is still named `sqlite3`. A
project that currently depends on the upstream `sqlite3` opam package can
switch to `sqlite3-static-link` by changing only its `depends:` field; every
`(libraries sqlite3)` stanza and `open Sqlite3` in its own dune files and
source code keeps working unchanged.

`integration/run.sh` exercises this guarantee: it installs the upstream
`sqlite3` package (dynamically linked against the system libsqlite3) and
`sqlite3-static-link` (statically linked) side by side, then runs the same
standalone project (`integration/consumer`) against each in turn. The
consumer only ever refers to the library as `sqlite3`, exactly as it would
against the upstream package, and the script fails if the two runs don't
produce identical output.

## Credits

- Mikhail Fedotov wrote ocaml-sqlite for SQLite version 2. His bindings
  served as a reference for this wrapper, but SQLite3 is a complete rewrite.

- Christian Szegedy wrote the initial release for SQLite version 3.

- Markus Mottl rewrote Christian's bindings for Jane Street Holding, LLC to
  clean up some issues and to make it perform better in multi-threaded
  environments.

- Enrico Tassi contributed support for user-defined scalar functions.

- Markus W. Weissmann contributed backup functionality.

## Contact Information and Contributing

Please submit bugs reports, feature requests, contributions to the
[GitHub issue tracker](https://github.com/mmottl/sqlite3-ocaml/issues).

Up-to-date information is available at: <https://mmottl.github.io/sqlite3-ocaml>
