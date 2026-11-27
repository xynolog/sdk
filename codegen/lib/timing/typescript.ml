(* The timing as the TypeScript SDK reads it (typescript/core/src): a constant
   per entry under its name in upper case, and for each record of what a
   caller may set its interface and the table's values of it. *)

module T = Typescript_syntax

let path = "typescript/core/src/client-timing.ts"
let name (e : Table.entry) = Text.upper_snake e.name

let constant (e : Table.entry) =
  let name = name e and about = [ T.Doc e.docs ] in
  match e.value with
  | Duration n | Count n -> T.const ~about name (Int n)
  | Budget { attempts; initial_delay_ms; max_delay_ms } ->
      T.const ~about name ~annotation:(T_name "RetryBudget")
        (Object
           {
             layout = Inline;
             entries =
               [
                 T.entry (Ident "attempts") (Int attempts);
                 T.entry (Ident "initialDelayMs") (Int initial_delay_ms);
                 T.entry (Ident "maxDelayMs") (Int max_delay_ms);
               ];
           })

let record (t : Table.t) record =
  let record_name = Table.record_name record in
  let members = Table.members record t in
  let member (e : Table.entry) =
    T.member ~about:[ T.Doc e.docs ] (T.Ident e.name)
      (T.T_name
         (match e.value with
         | Duration _ | Count _ -> "number"
         | Budget _ -> "RetryBudget"))
  in
  [
    T.Interface
      {
        about = [ T.Doc (Table.record_docs record) ];
        export = true;
        name = record_name;
        members = List.map member members;
      };
    T.const
      ~about:[ T.Doc ("The table's values of " ^ record_name ^ ".") ]
      ~annotation:(T.T_name record_name)
      ("DEFAULT_" ^ Text.upper_snake record_name)
      (T.rows
         (List.map
            (fun (e : Table.entry) ->
              T.entry (T.Ident e.name) (T.Name (name e)))
            members));
  ]

let text (t : Table.t) =
  T.text
    {
      banner =
        Banner.typescript_lines
          ~authority:[ "protocol/specs/src/client/timing.json" ]
          __FILE__;
      body =
        T.import ~type_only:true [ "RetryBudget" ] "./retry"
        :: (List.map constant t @ List.concat_map (record t) Table.records);
    }

let file t = { Output.path; text = text t }
