open Sqlite3

let assert_ok rc = if rc <> Rc.OK then failwith (Rc.to_string rc)

let () =
  let db = db_open ":memory:" in
  assert_ok (exec db "CREATE TABLE t (a INTEGER)");
  assert_ok (exec db "INSERT INTO t VALUES (42)");
  let result = ref None in
  assert_ok
    (exec db "SELECT a FROM t" ~cb:(fun row _ -> result := row.(0)));
  ignore (db_close db);
  match !result with
  | Some v -> print_endline v
  | None -> failwith "unexpected query result"
