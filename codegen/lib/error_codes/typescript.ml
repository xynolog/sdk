(* The vocabularies as the TypeScript SDK reads them (typescript/core/src): a
   union type per vocabulary, the control plane's among them, the bus code
   each wire code becomes, and the transport code an HTTP status becomes. *)

module T = Typescript_syntax

let path = "typescript/core/src/error-codes.ts"
let code (c : Table.code) = T.Str c.code

let union (v : Table.vocabulary) =
  T.type_alias v.name ~about:[ Doc v.docs ]
    (T_cases
       (List.map
          (fun (c : Table.code) -> T.case ~about:[ Doc c.docs ] (T_str c.code))
          v.codes))

let text (t : Table.t) =
  T.text
    {
      banner =
        Banner.typescript_lines
          ~authority:[ "protocol/specs/src/errors/codes.json" ]
          __FILE__;
      body =
        [
          union t.bus;
          T.const "busRequestCodeByWireCode" ~as_const:true
            ~about:
              [
                Doc
                  "The bus code a failure's own wire code \
                   (`CommandError.code`) becomes.";
              ]
            (T.rows
               (List.map
                  (fun (wire, c) -> T.entry (Quoted wire) (code c))
                  t.wire));
          T.const "unrecognizedFailureCode" ~as_const:true
            ~about:
              [
                Doc
                  "What a failure becomes when it states no code, or one \
                   CommandError does not list, which is read as none.";
              ]
            (code t.unrecognized);
          union t.transport;
          T.Function
            {
              about = [ Doc "The transport code an HTTP status becomes." ];
              export = true;
              name = "transportErrorCodeForStatus";
              params = [ { name = "status"; type_ = T_name "number" } ];
              returns = T_name t.transport.name;
              body =
                T.Switch
                  ( Name "status",
                    List.map
                      (fun (status, c) -> (T.Int status, T.Return (code c)))
                      t.exact )
                :: List.map
                     (fun (status, c) ->
                       T.If
                         ( Binary (Name "status", Ge, Int status),
                           Return (code c) ))
                     (Option.to_list t.from)
                @ [ Return (code t.unclassified) ];
            };
        ]
        @ List.map union t.others
        @ [ union t.control ];
    }

let file t = { Output.path; text = text t }
