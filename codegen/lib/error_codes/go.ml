(* The vocabularies as the Go SDK reads them (go/errors.go): a named type per
   vocabulary with a constant per code, the bus code a wire code becomes, and
   the transport code an HTTP status becomes. They are in package api, beside
   the types that name them ([Typing.Code]). A wire code's constant is the one
   the Go types group writes for CommandErrorCode's value, named by the same
   rule ([Naming.variant]). *)

module G = Go_syntax

let path = "go/api/errorcodes_gen.go"
let wire_constant wire = G.Name ("CommandErrorCode" ^ Naming.variant wire)

(* A vocabulary: its type, and a constant per code in the table's order, each
   under its comment. *)
let vocabulary (v : Table.vocabulary) =
  [
    G.Type
      { doc = G.prose v.docs; name = v.go_name; def = G.Is (G.Named "string") };
    G.Consts
      {
        doc = [];
        spacing = G.Packed;
        specs =
          List.map
            (fun (c : Table.code) ->
              G.spec ~doc:(G.prose c.docs) ~type_:(G.Named v.go_name) c.go
                (G.Quoted c.code))
            v.codes;
      };
  ]

let returning pairs =
  List.map (fun (case, result) -> ([ case ], [ G.Return result ])) pairs

let text (t : Table.t) =
  let bus = G.Named t.bus.go_name and transport = G.Named t.transport.go_name in
  let code = G.Name "code" and status = G.Name "status" in
  G.text
    {
      header =
        G.verbatim
          "Code generated from protocol/specs/src/errors/codes.json; DO NOT \
           EDIT.\n\n\
           Regenerate: make generate (codegen/lib/error_codes/go.ml)\n\
           The TypeScript, Python and Rust vocabularies are generated from the \
           same\n\
           table.";
      package = "api";
      imports = [];
      decls =
        vocabulary t.bus
        @ [
            G.func
              ~doc:
                (G.prose
                   (Printf.sprintf
                      "%sOfWire is the code a failure's own code \
                       (CommandError.code) becomes, a case for each of \
                       CommandErrorCode's codes. A failure that states none is \
                       %s. A reader leaves a code the required table does not \
                       recognize out of the failure before it decodes it, so a \
                       code CommandErrorCode does not name is none a failure \
                       is read with: given one, it panics."
                      t.bus.go_name t.unrecognized.go))
              ~params:[ ("code", G.Pointer (G.Named "CommandErrorCode")) ]
              ~results:(G.Unnamed [ bus ]) (t.bus.go_name ^ "OfWire")
              (G.Block
                 [
                   G.If
                     ( G.Binary (code, G.Eq, G.Name "nil"),
                       [ G.Return [ G.Name t.unrecognized.go ] ] );
                   G.Switch
                     {
                       tag = Some (G.Unary (G.Deref, code));
                       cases =
                         returning
                           (List.map
                              (fun (wire, (c : Table.code)) ->
                                (wire_constant wire, [ G.Name c.go ]))
                              t.wire);
                       default =
                         Some
                           [
                             G.Do
                               (G.call "panic"
                                  [
                                    G.Binary
                                      ( G.Binary
                                          ( G.Quoted "a failure's code \"",
                                            G.Add,
                                            G.Convert
                                              ( G.Named "string",
                                                G.Unary (G.Deref, code) ) ),
                                        G.Add,
                                        G.Quoted
                                          "\" is none of CommandErrorCode's: \
                                           the required table recognizes a \
                                           code CommandError does not list" );
                                  ]);
                           ];
                     };
                 ]);
            G.func
              ~doc:
                (G.prose
                   "Wire is the wire code a peer stated, when this code \
                    restates one: what a service answers its own caller with. \
                    A failure only this side knows states none, and ok is \
                    false.")
              ~receiver:("c", bus)
              ~results:
                (G.Named_results
                   [
                     ("code", G.Named "CommandErrorCode");
                     ("ok", G.Named "bool");
                   ])
              "Wire"
              (G.Block
                 [
                   G.Switch
                     {
                       tag = Some (G.Name "c");
                       cases =
                         returning
                           (List.map
                              (fun (wire, (c : Table.code)) ->
                                ( G.Name c.go,
                                  [ wire_constant wire; G.Name "true" ] ))
                              t.wire);
                       default =
                         Some [ G.Return [ G.Quoted ""; G.Name "false" ] ];
                     };
                 ]);
          ]
        @ vocabulary t.transport
        @ [
            G.func
              ~doc:
                (G.prose
                   (Printf.sprintf
                      "%sOfStatus is the code an HTTP status becomes."
                      t.transport.go_name))
              ~params:[ ("status", G.Named "int") ]
              ~results:(G.Unnamed [ transport ])
              (t.transport.go_name ^ "OfStatus")
              (G.Block
                 [
                   G.Switch
                     {
                       tag = None;
                       cases =
                         returning
                           (List.map
                              (fun (n, (c : Table.code)) ->
                                ( G.Binary (status, G.Eq, G.Int n),
                                  [ G.Name c.go ] ))
                              t.exact
                           @ List.map
                               (fun (n, (c : Table.code)) ->
                                 ( G.Binary (status, G.Ge, G.Int n),
                                   [ G.Name c.go ] ))
                               (Option.to_list t.from));
                       default = Some [ G.Return [ G.Name t.unclassified.go ] ];
                     };
                 ]);
          ]
        @ List.concat_map vocabulary t.others
        @ vocabulary t.control;
    }

let file t = { Output.path; text = text t }
