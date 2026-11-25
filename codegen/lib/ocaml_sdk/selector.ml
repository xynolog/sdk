(* The selector (components/schemas/Selector.json) as the OCaml SDK reads and
   writes it (ocaml/sdk/lib/selector.ml): a variant per branch its
   discriminator maps, each a record of the branch's members and whatever
   else the object holds. A branch is an open object whose tag is its own
   name alone, and each other member a string or an integer, with at most a
   least value; the mapping and the branches are one to one. The module reads
   and writes through ocaml/sdk/lib/selector_codec.ml and has no interface,
   so each type is stated once and each member named once a direction. *)

let file = "components/schemas/Selector.json"

module O = Ocaml_syntax

type field = {
  name : string;
  label : string;
  reader : Parsetree.expression;
  type_ : Parsetree.core_type;
  writer : string;
  optional : bool;
}

type variant = { constructor : string; fields : field list; record : string }

let derive (spec : Spec.t) =
  let ( let* ) = Result.bind in
  let refuse ?(file = file) pointer message =
    Error [ { Decode.file; pointer; message } ]
  in
  let* schema =
    match List.assoc_opt file spec.schemas with
    | Some (Schema.Schema s) -> Ok s
    | _ -> refuse "" "is no schema"
  in
  let* tag, mapping =
    match schema.discriminator with
    | Some { property_name; mapping = Some mapping } ->
        Ok (property_name, mapping)
    | _ -> refuse "/discriminator" "maps no branch"
  in
  let branches =
    List.filter_map
      (function
        | Schema.Schema { ref_ = Some r; _ } -> Some r.target | _ -> None)
      (Option.value ~default:[] schema.one_of)
  in
  let* () =
    if
      List.length (List.sort_uniq compare branches) <> List.length branches
      || List.length branches
         <> List.length (Option.value ~default:[] schema.one_of)
      || List.sort compare branches <> List.sort compare (List.map snd mapping)
    then refuse "/discriminator/mapping" "does not map its branches one to one"
    else Ok ()
  in
  let variant (constructor, target) =
    let reference =
      { Decode.target; file; pointer = "/discriminator/mapping" }
    in
    let branch, _ = Decode.resolve spec.Spec.ids reference in
    let refuse_branch pointer message = refuse ~file:branch pointer message in
    let valid_name =
      constructor <> ""
      && (match constructor.[0] with 'A' .. 'Z' -> true | _ -> false)
      && String.for_all
           (function
             | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' -> true | _ -> false)
           constructor
    in
    match List.assoc_opt branch spec.schemas with
    | Some
        (Schema.Schema
           {
             type_ = Some [ Object ];
             properties = Some properties;
             required = Some required;
             additional_properties = None | Some (Boolean_schema true);
             _;
           })
      when valid_name && List.mem tag required
           &&
           match List.assoc_opt tag properties with
           | Some (Schema.Schema { enum = Some [ String_literal c ]; _ }) ->
               c = constructor
           | _ -> false ->
        let field (name, declared) =
          match declared with
          | Schema.Schema s -> (
              let others =
                List.filter
                  (fun k ->
                    not
                      (List.mem k
                         [ "type"; "minimum"; "description"; "examples" ]))
                  (Schema.keywords s)
              in
              let label = if name = "end" then "end_" else Text.snake name in
              let optional = not (List.mem name required) in
              match (others, s.type_, s.minimum) with
              | [], Some [ String ], None ->
                  Ok
                    {
                      name;
                      label;
                      reader = O.ident "string";
                      type_ = O.type_ "string";
                      writer = "json_string";
                      optional;
                    }
              | [], Some [ Integer ], least
                when Option.fold ~none:true ~some:Float.is_integer least ->
                  Ok
                    {
                      name;
                      label;
                      reader =
                        (match least with
                        | None -> O.ident "integer"
                        | Some n ->
                            O.apply
                              (O.ident "integer_at_least")
                              [ O.integer (Printf.sprintf "%.0f" n) ]);
                      type_ = O.type_ "Z.t";
                      writer = "json_integer";
                      optional;
                    }
              | _ ->
                  refuse_branch ("/properties/" ^ name)
                    "is neither a string nor an integer with at most a least \
                     value")
          | Schema.Boolean_schema _ ->
              refuse_branch ("/properties/" ^ name) "is no schema"
        in
        let* fields =
          List.fold_right
            (fun f rest ->
              let* f = field f in
              let* rest = rest in
              Ok (f :: rest))
            (List.filter (fun (n, _) -> n <> tag) properties)
            (Ok [])
        in
        Ok { constructor; fields; record = Text.snake constructor }
    | _ ->
        refuse_branch "" "is no open selector object tagged with its own name"
  in
  let* variants =
    List.fold_right
      (fun m rest ->
        let* v = variant m in
        let* rest = rest in
        Ok (v :: rest))
      mapping (Ok [])
  in
  Ok (tag, variants)

let fault =
  O.type_declaration "fault"
    ~manifest:(O.type_ "Schema_codec.fault")
    Required.Ocaml.fault

let files (tag, variants) =
  let types =
    List.map
      (fun v ->
        O.type_declaration v.record
          (Record
             (List.map
                (fun f ->
                  ( f.label,
                    if f.optional then O.type_ "option" ~args:[ f.type_ ]
                    else f.type_ ))
                v.fields)))
      variants
    @ [
        O.type_declaration "t"
          (Variant
             (List.map
                (fun v ->
                  O.constructor v.constructor ~args:[ O.type_ v.record ])
                variants));
        fault;
      ]
  in
  let read f = O.call (if f.optional then "optional" else "required") in
  let branch v =
    let reading =
      List.filter (fun f -> not f.optional) v.fields
      @ List.filter (fun f -> f.optional) v.fields
    in
    O.case
      (O.Pattern.string v.constructor)
      (List.fold_right
         (fun f body ->
           O.let_star (O.Pattern.var f.label)
             (read f [ O.ident "reader"; f.reader; O.string f.name ])
             body)
         reading
         (O.construct "Ok"
            ~arg:
              (O.construct v.constructor
                 ~arg:
                   (O.record
                      (List.map (fun f -> (f.label, O.ident f.label)) v.fields)))))
  in
  let json = O.type_ "Yojson.Safe.t" in
  let of_json =
    O.let_ "of_json"
      ~type_:
        (O.arrow json (O.type_ "result" ~args:[ O.type_ "t"; O.type_ "fault" ]))
      (O.function_
         [
           O.case
             (O.Pattern.variant "Assoc" ~arg:(O.Pattern.var "fields"))
             (O.let_in "reader"
                (O.call "start" [ O.ident "fields" ])
                (O.let_star (O.Pattern.var "tag")
                   (O.call "required"
                      [ O.ident "reader"; O.ident "string"; O.string tag ])
                   (O.match_ (O.ident "tag")
                      (List.map branch variants
                      @ [
                          O.case O.Pattern.any
                            (O.call "malformed" [ O.string tag ]);
                        ]))));
           O.case O.Pattern.any (O.call "malformed" [ O.string "" ]);
         ])
  in
  let encode v =
    let value = O.ident "value" in
    O.case
      (O.Pattern.construct v.constructor ~arg:(O.Pattern.var "value"))
      (O.call "write"
         [
           O.list
             (O.tuple
                [
                  O.string tag;
                  O.some (O.call "json_string" [ O.string v.constructor ]);
                ]
             :: List.map
                  (fun f ->
                    let field = O.field value f.label in
                    O.tuple
                      [
                        O.string f.name;
                        (if f.optional then
                           O.call "Option.map" [ O.ident f.writer; field ]
                         else O.some (O.call f.writer [ field ]));
                      ])
                  v.fields);
         ])
  in
  let to_json =
    O.let_ "to_json"
      ~type_:(O.arrow (O.type_ "t") json)
      (O.function_ (List.map encode variants))
  in
  let banner =
    Banner.ocaml ~from_:"Selector.json and its component branches" __FILE__
  in
  [
    O.implementation ~path:"ocaml/sdk/lib/selector.ml" ~banner
      ((O.open_ "Selector_codec" :: List.map O.type_item types)
      @ [ of_json; to_json ]);
  ]
