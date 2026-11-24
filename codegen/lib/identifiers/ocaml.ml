(* The kinds of id as the OCaml SDK holds them (ocaml/sdk/lib/identifiers.ml):
   a module per kind whose of_string asks the kind's pattern, compiled to the
   steps its required shape states, and a test of each case kinds.json
   accepts or refuses. A kind's required shape is a string and its pattern,
   and nothing else, or the module would not hold all its schema says. *)

module O = Ocaml_syntax

let banner =
  Banner.ocaml
    ~from_:
      "protocol/specs/src/identifiers/kinds.json and the kinds' required shapes"
    __FILE__

let files (spec : Spec.t) (shapes : (string * Required.Shape.shape) list) =
  let kinds = spec.tables.identifiers_kinds.kinds in
  let refusals = ref [] in
  let modules =
    List.mapi
      (fun i (k : Tables.Identifiers_kinds.kinds_item) ->
        let steps =
          match List.assoc_opt k.schema shapes with
          | Some
              (Shape
                 {
                   kinds = Some [ String ];
                   pattern = Some steps;
                   recognized = None;
                   enum = None;
                   min_length = None;
                   max_length = None;
                   minimum = None;
                   maximum = None;
                   min_items = None;
                   max_items = None;
                   required = None;
                   members = [];
                   closed = None;
                   items = None;
                   values = None;
                   one_of = [];
                   discriminator = None;
                   all_of = [];
                   not_all = [];
                   min_members = None;
                   names = None;
                 }) ->
              steps
          | _ ->
              refusals :=
                {
                  Decode.file = "identifiers/kinds.json";
                  pointer = Printf.sprintf "/kinds/%d/schema" i;
                  message =
                    Printf.sprintf
                      "is %s, whose required shape is not a string and its \
                       pattern alone"
                      k.schema;
                }
                :: !refusals;
              []
        in
        (k, String.capitalize_ascii (Text.snake k.schema), steps))
      kinds
  in
  let value = O.ident "value" in
  let t = O.type_ "t" and string = O.type_ "string" in
  let implementation ((k : Tables.Identifiers_kinds.kinds_item), name, steps) =
    O.module_ name
      [
        O.type_item (O.type_declaration "t" Abstract ~manifest:string);
        O.let_ "of_string"
          (O.fun_
             [ O.Pattern.var "value" ]
             (O.if_
                (O.apply
                   (O.ident "Pattern.matches")
                   [ O.list (List.map Required.Ocaml.term steps); value ])
                (O.construct "Ok" ~arg:value)
                (O.construct "Error" ~arg:(O.string ("Invalid " ^ k.schema)))));
        O.let_ "to_string" (O.fun_ [ O.Pattern.var "value" ] value);
        O.let_ "compare" (O.ident "String.compare");
        O.let_ "equal" (O.ident "String.equal");
      ]
  in
  let signature (_, name, _) =
    O.module_spec name
      [
        O.type_spec (O.type_declaration "t" Abstract);
        O.val_ "of_string"
          (O.arrow string (O.type_ "result" ~args:[ t; string ]));
        O.val_ "to_string" (O.arrow t string);
        O.val_ "compare" (O.arrow t (O.arrow t (O.type_ "int")));
        O.val_ "equal" (O.arrow t (O.arrow t (O.type_ "bool")));
      ]
  in
  let tests ((k : Tables.Identifiers_kinds.kinds_item), name, _) =
    let case accepted (id, why) =
      O.apply (O.ident "Alcotest.check")
        [
          O.ident "Alcotest.bool";
          O.string (k.schema ^ ": " ^ why);
          O.bool accepted;
          O.apply (O.ident "Result.is_ok")
            [
              O.apply
                (O.ident ("Xynolog.Identifiers." ^ name ^ ".of_string"))
                [ O.string id ];
            ];
        ]
    in
    List.map (case true)
      (List.map
         (fun (a : Tables.Identifiers_kinds.accepts_item) -> (a.id, a.why))
         k.accepts)
    @ List.map (case false)
        (List.map
           (fun (r : Tables.Identifiers_kinds.accepts_item) -> (r.id, r.why))
           k.refuses)
  in
  match !refusals with
  | [] ->
      Ok
        [
          O.implementation ~path:"ocaml/sdk/lib/identifiers.ml" ~banner
            (List.map implementation modules);
          O.interface ~path:"ocaml/sdk/lib/identifiers.mli" ~banner
            (List.map signature modules);
          O.implementation ~path:"ocaml/sdk/test/identifiers.ml" ~banner
            [
              O.let_unit
                (O.sequence (List.concat_map tests modules @ [ O.unit ]));
            ];
        ]
  | errors -> Error (List.rev errors)
