(* The moves of a client's stream as the TypeScript HTTP transport reads them
   (typescript/http-transport/src/transport/connection-state-moves.ts): each
   ConnectionState with the states it moves to. *)

module T = Typescript_syntax

let path = "typescript/http-transport/src/transport/connection-state-moves.ts"
let state = T.T_name "ConnectionState"

let file (t : Table.t) =
  {
    Output.path;
    text =
      T.text
        {
          banner = Banner.typescript_lines ~authority:[ Table.from_ ] __FILE__;
          body =
            [
              T.import ~type_only:true [ "ConnectionState" ] "@xynolog/core";
              T.const
                ~about:
                  [
                    T.Doc
                      "Each state of a client's stream, with the states it \
                       moves to and no other.";
                  ]
                ~annotation:
                  (T.T_generic
                     ("Record", [ state; T.T_readonly (T.T_array state) ]))
                "CONNECTION_STATE_MOVES"
                (T.Object
                   {
                     layout = Rows;
                     entries =
                       List.map
                         (fun (s, moves) ->
                           T.entry (Ident s)
                             (T.Array
                                (List.map (fun m -> T.element (T.Str m)) moves)))
                         t;
                   });
            ];
        };
  }
