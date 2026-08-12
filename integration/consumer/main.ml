open Sqlite3

let assert_ok rc = if rc <> Rc.OK then failwith (Rc.to_string rc)

let () =
  let db = db_open ":memory:" in
  assert_ok (exec db "CREATE TABLE t (a INTEGER)");
  assert_ok (exec db "INSERT INTO t VALUES (42)");
  let result = ref None in
  assert_ok
    (exec db "SELECT a FROM t" ~cb:(fun row _ -> result := row.(0)));
  (match !result with
  | Some "42" -> ()
  | _ -> failwith "unexpected query result");
  ignore (db_close db);
  print_endline "OK"
