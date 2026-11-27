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

let rpc_key r = String.uncapitalize_ascii (Table.rpc_pascal r)

(* The JSON-RPC codes the control API answers with, a constant each, and the
   one each control code is answered under, with whether it is retryable. *)
let control_answers (t : Table.t) =
  [
    T.const "controlRpcCodes" ~as_const:true
      ~about:
        [
          Doc
            "Each JSON-RPC error code the launcher's control API answers with \
             (control/rpc-codes.json), by its name.";
        ]
      (T.rows
         (List.map
            (fun (r : Tables.Control_rpc_codes.codes_item) ->
              T.entry ~about:[ Doc r.docs ] (Ident (rpc_key r)) (T.Int r.number))
            t.rpc_codes));
    T.type_alias "ControlRpcCode"
      ~about:
        [ Doc "A JSON-RPC error code the launcher's control API answers with." ]
      (T_index
         ( T_paren (T_typeof "controlRpcCodes"),
           T_keyof (T_typeof "controlRpcCodes") ));
    T.const "controlErrorCodeAnswers" ~as_const:true
      ~about:
        [
          Doc
            "Each control code's JSON-RPC code, the one an answer carries it \
             under, and whether it is retryable: whether the same request can \
             succeed sent again unchanged, once something outside it changes.";
        ]
      ~satisfies:
        (T_mapped
           {
             layout = Inline;
             readonly = true;
             key = "code";
             in_ = T_name t.control.name;
             value =
               T_object
                 ( Inline,
                   [
                     T.member ~readonly:true (Ident "rpc")
                       (T_name "ControlRpcCode");
                     T.member ~readonly:true (Ident "retryable")
                       (T_name "boolean");
                   ] );
           })
      (T.rows
         (List.map
            (fun (a : Table.answered) ->
              T.entry (Quoted a.control_code.code)
                (T.Object
                   {
                     layout = Inline;
                     entries =
                       [
                         T.entry (Ident "rpc")
                           (T.Member (Name "controlRpcCodes", rpc_key a.rpc));
                         T.entry (Ident "retryable") (T.Bool a.retryable);
                       ];
                   }))
            t.answered));
  ]

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
          T.const "limitRefusalTransportCodes" ~as_const:true
            ~about:
              [
                Doc
                  "Each gateway refusal of a limit that is a transport code \
                   too: its status, its `LimitRefusal` code, and the transport \
                   code it is.";
              ]
            (T.array
               (List.map
                  (fun (status, limit, (c : Table.code)) ->
                    T.Object
                      {
                        layout = Inline;
                        entries =
                          [
                            T.entry (Ident "status") (T.Int status);
                            T.entry (Ident "code") (T.Str limit);
                            T.entry (Ident "transport") (code c);
                          ];
                      })
                  t.limit_refusals));
        ]
        @ List.map union t.others
        @ (union t.control :: control_answers t);
    }

let file t = { Output.path; text = text t }
