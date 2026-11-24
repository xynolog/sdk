(* What each component requires, as the OCaml SDK holds it: each shape built
   as a Schema_shape value (ocaml/sdk/lib/schema_shapes.ml), with its keywords
   in the order the table states them, and a descriptor per component
   (ocaml/sdk/lib/models.ml). *)

module O = Ocaml_syntax

(* A number as JavaScript's String writes one. *)
let number value =
  if Float.is_integer value then Printf.sprintf "%.0f" value
  else
    List.find
      (fun s -> float_of_string s = value)
      (List.map
         (fun digits -> Printf.sprintf "%.*g" digits value)
         [ 15; 16; 17 ])

let literal : Schema.literal -> Parsetree.expression = function
  | String_literal s -> O.variant "Stringlit" ~arg:(O.string (Text.quoted s))
  | Int_literal n -> O.variant "Intlit" ~arg:(O.string (string_of_int n))
  | Bool_literal b -> O.variant "Bool" ~arg:(O.bool b)

let any = O.ident "any"
let strings values = O.list (List.map O.string values)
let max = function None -> O.none | Some max -> O.some (O.int max)

let rec term : Shape.term -> Parsetree.expression = function
  | Step step ->
      O.construct "Step"
        ~arg:
          (O.tuple
             [
               O.list
                 (List.map
                    (fun (lo, hi) -> O.tuple [ O.int lo; O.int hi ])
                    step.of_);
               O.int step.min;
               max step.max;
             ])
  | Group group ->
      O.construct "Group"
        ~arg:
          (O.tuple
             [
               O.list
                 (List.map
                    (fun terms -> O.list (List.map term terms))
                    group.either);
               O.int group.min;
               max group.max;
             ])

let rec shape : Shape.shape -> Parsetree.expression = function
  | Ref name -> O.record ~with_:any [ ("reference", O.some (O.string name)) ]
  | Shape b ->
      let part name write = Option.map (fun v -> (name, write v)) in
      let some write v = O.some (write v) in
      let nonempty name write = function
        | [] -> None
        | items -> Some (name, write items)
      in
      let updates =
        List.filter_map Fun.id
          [
            part "kinds"
              (some (fun kinds ->
                   O.list
                     (List.map
                        (fun k ->
                          O.construct
                            (String.capitalize_ascii (Shape.kind_name k)))
                        kinds)))
              b.kinds;
            part "recognized" (some strings) b.recognized;
            part "enum" (some (fun e -> O.list (List.map literal e))) b.enum;
            part "pattern"
              (some (fun terms -> O.list (List.map term terms)))
              b.pattern;
            part "min_length" (some O.int) b.min_length;
            part "max_length" (some O.int) b.max_length;
            part "minimum" (some (fun n -> O.string (number n))) b.minimum;
            part "maximum" (some (fun n -> O.string (number n))) b.maximum;
            part "min_items" (some O.int) b.min_items;
            part "max_items" (some O.int) b.max_items;
            part "required" strings b.required;
            nonempty "members"
              (fun members ->
                O.list
                  (List.map
                     (fun (name, s) -> O.tuple [ O.string name; shape s ])
                     members))
              b.members;
            part "closed" (some strings) b.closed;
            part "items" (some shape) b.items;
            part "values" (some shape) b.values;
            nonempty "variants" (fun s -> O.list (List.map shape s)) b.one_of;
            part "discriminator"
              (some (fun (d : Shape.discriminator) ->
                   O.tuple
                     [
                       O.string d.property;
                       O.list
                         (List.map
                            (fun (v, i) -> O.tuple [ O.string v; O.int i ])
                            d.mapping);
                     ]))
              b.discriminator;
            nonempty "all_of" (fun s -> O.list (List.map shape s)) b.all_of;
            nonempty "not_all"
              (fun sets -> O.list (List.map strings sets))
              b.not_all;
            part "min_members" (some O.int) b.min_members;
            part "names" (some shape) b.names;
          ]
      in
      if updates = [] then any else O.record ~with_:any updates

let banner =
  Banner.ocaml
    ~from_:"OpenAPI component schemas through codegen/lib/required/shape.ml"
    __FILE__

let schema = O.type_var "schema"
let t = O.type_ "t" ~args:[ schema ]
let descriptor kind = O.type_ "descriptor" ~args:[ kind ]

let fault =
  O.Record
    [
      ("member", O.type_ "string"); ("reason", O.tags [ "Lacks"; "Malformed" ]);
    ]

let decode_error =
  O.Variant
    [
      O.constructor "Invalid_json" ~args:[ O.type_ "string" ];
      O.constructor "Invalid_payload" ~args:[ O.type_ "fault" ];
    ]

let files shapes =
  let names = List.map fst shapes in
  (* Each shape is built by a function of its own: built in the module's
     initializer, the table is more than the native compiler can allocate
     registers for. *)
  let definitions =
    List.mapi
      (fun i (_, s) ->
        O.let_
          (Printf.sprintf "shape_%d" i)
          (O.fun_ [ O.Pattern.unit ] (shape s)))
      shapes
  in
  let all =
    O.let_ "all"
      (O.list
         (List.mapi
            (fun i name ->
              O.tuple [ O.string name; O.ident (Printf.sprintf "shape_%d" i) ])
            names))
  in
  let value_name = Text.snake in
  let api =
    [
      O.type_spec (O.type_declaration "t" ~params:[ "schema" ] Abstract);
      O.type_spec
        (O.type_declaration "descriptor" ~params:[ "schema" ] Abstract);
      O.type_spec (O.type_declaration "fault" fault);
      O.type_spec (O.type_declaration "decode_error" decode_error);
      O.val_ "decode"
        (O.arrow (descriptor schema)
           (O.arrow (O.type_ "string")
              (O.type_ "result" ~args:[ t; O.type_ "decode_error" ])));
      O.val_ "encode" (O.arrow t (O.type_ "string"));
      O.val_ "json" (O.arrow t (O.type_ "Yojson.Raw.t"));
    ]
    @ List.map
        (fun name -> O.val_ (value_name name) (descriptor (O.tags [ name ])))
        names
  in
  let impl =
    [
      O.type_item
        (O.type_declaration "t" ~params:[ "schema" ]
           ~manifest:(O.type_ "Yojson.Raw.t") Abstract);
      O.type_item
        (O.type_declaration "descriptor" ~params:[ "schema" ]
           ~manifest:(O.type_ "string") Abstract);
      O.type_item
        (O.type_declaration "fault"
           ~manifest:(O.type_ "Schema_codec.fault")
           fault);
      O.type_item
        (O.type_declaration "decode_error"
           ~manifest:(O.type_ "Schema_codec.error")
           decode_error);
      O.let_ "decode"
        (O.fun_
           [ O.Pattern.var "name" ]
           (O.apply
              (O.ident "Schema_codec.decode")
              [ O.apply (O.ident "Schema_shape.reference") [ O.ident "name" ] ]));
      O.let_ "encode"
        (O.fun_
           [ O.Pattern.var "value" ]
           (O.apply (O.ident "Yojson.Raw.to_string") [ O.ident "value" ]));
      O.let_ "json" (O.fun_ [ O.Pattern.var "value" ] (O.ident "value"));
    ]
    @ List.map (fun name -> O.let_ (value_name name) (O.string name)) names
  in
  [
    O.implementation ~path:"ocaml/sdk/lib/schema_shapes.ml" ~banner
      ((O.open_ "Schema_shape" :: definitions) @ [ all ]);
    O.interface ~path:"ocaml/sdk/lib/models.mli" ~banner api;
    O.implementation ~path:"ocaml/sdk/lib/models.ml" ~banner impl;
  ]
