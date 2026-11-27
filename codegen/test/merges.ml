(* The generator's allOf merge on the cases each keyword's rule decides, and
   [Normalize.everywhere], which writes the schemas the Haskell SDK validates
   against with no allOf left in them. *)

open Xynolog_codegen

let reference name =
  { Decode.target = "./" ^ name ^ ".json"; file = ""; pointer = "" }

(* The references here name schemas by path, so they need no index of [$id]s. *)
let ids = Result.get_ok (Decode.ids [])
let layer fields = Schema.Schema fields
let text_layer = { Schema.empty with type_ = Some [ String ] }
let text = layer text_layer
let named name = layer { Schema.empty with ref_ = Some (reference name) }
let all_of parts = layer { Schema.empty with all_of = Some parts }

let named_by (r : Decode.reference) =
  Filename.remove_extension (Filename.basename r.target)

let find definitions name =
  match List.assoc_opt name definitions with
  | Some s -> Ok s
  | None -> Error ("unknown schema reference: " ^ name)

let find_referenced definitions r = find definitions (named_by r)

let merge ?(definitions = [ ("Text", text) ]) left right =
  Normalize.normalize ids
    ~find:(find_referenced definitions)
    (all_of [ left; right ])

let outcome =
  Alcotest.result
    (Alcotest.testable
       (fun f s ->
         Format.pp_print_string f
           (Yojson.Safe.to_string (Schema.runtime (Schema s))))
       ( = ))
    Alcotest.string

let merged label left right expected =
  Alcotest.check outcome label (Ok expected) (merge (layer left) (layer right))

let refused label left right =
  Alcotest.(check bool)
    label true
    (Result.is_error (merge (layer left) (layer right)))

let keywords () =
  Alcotest.check outcome "a reference merged with what it names is that"
    (Ok text_layer)
    (merge (named "Text") text);
  let bounds =
    [
      ("minimum", (fun n -> { Schema.empty with minimum = Some n }), 2.);
      ("maximum", (fun n -> { Schema.empty with maximum = Some n }), 1.);
    ]
  in
  List.iter
    (fun (label, bound, expected) ->
      merged label (bound 1.) (bound 2.) (bound expected))
    bounds;
  let counts =
    [
      ("minLength", (fun n -> { Schema.empty with min_length = Some n }), 2);
      ("maxLength", (fun n -> { Schema.empty with max_length = Some n }), 1);
      ("minItems", (fun n -> { Schema.empty with min_items = Some n }), 2);
      ("maxItems", (fun n -> { Schema.empty with max_items = Some n }), 1);
      ( "maxProperties",
        (fun n -> { Schema.empty with max_properties = Some n }),
        1 );
    ]
  in
  List.iter
    (fun (label, bound, expected) ->
      merged label (bound 1) (bound 2) (bound expected))
    counts;
  let enum values =
    {
      Schema.empty with
      enum = Some (List.map (fun v -> Schema.String_literal v) values);
    }
  in
  merged "an enum is what both admit"
    (enum [ "a"; "b" ])
    (enum [ "b"; "c" ])
    (enum [ "b" ]);
  refused "an enum both admit nothing of" (enum [ "a" ]) (enum [ "b" ]);
  let closed b =
    { Schema.empty with additional_properties = Some (Schema.Boolean_schema b) }
  in
  merged "a closed object stays closed" (closed false) (closed true)
    (closed false);
  let unique b = { Schema.empty with unique_items = Some b } in
  merged "unique items stay unique" (unique true) (unique false) (unique true);
  let required names = { Schema.empty with required = Some names } in
  merged "required is each part's, once" (required [ "a" ])
    (required [ "b"; "a" ])
    (required [ "a"; "b" ]);
  let stating properties = { Schema.empty with properties = Some properties } in
  let long = layer { Schema.empty with min_length = Some 2 } in
  merged
    "properties keep the order the parts state them in, one two parts state \
     differently the allOf of both in the first's place"
    (stating [ ("b", text); ("a", text) ])
    (stating [ ("c", text); ("b", long) ])
    (stating [ ("b", all_of [ text; long ]); ("a", text); ("c", text) ]);
  let written_in file target =
    layer
      {
        Schema.empty with
        ref_ = Some { Decode.target; file; pointer = "/properties/a" };
      }
  in
  merged "a property two files refer to one schema for is the first's reference"
    (stating [ ("a", written_in "one/Left.json" "../Text.json") ])
    (stating [ ("a", written_in "Right.json" "./Text.json") ])
    (stating [ ("a", written_in "one/Left.json" "../Text.json") ]);
  refused "types that differ" text_layer
    { Schema.empty with type_ = Some [ Boolean ] };
  let agreeing =
    [
      ("pattern", fun v -> { Schema.empty with pattern = Some v });
      ("oneOf", fun v -> { Schema.empty with one_of = Some [ named v ] });
      ("anyOf", fun v -> { Schema.empty with any_of = Some [ named v ] });
      ("items", fun v -> { Schema.empty with items = Some (named v) });
    ]
  in
  List.iter
    (fun (label, stated) ->
      merged (label ^ " stated alike") (stated "a") (stated "a") (stated "a");
      refused (label ^ " stated otherwise") (stated "a") (stated "b"))
    agreeing;
  Alcotest.(check bool)
    "a schema that is a part of itself" true
    (Result.is_error
       (Normalize.normalize ids
          ~find:(find_referenced [ ("Cycle", all_of [ named "Cycle" ]) ])
          (all_of [ named "Cycle" ])))

(* [schema], named among [definitions], as [Normalize.everywhere] writes it. *)
let everywhere ?(definitions = [ ("Text", text) ]) schema =
  Normalize.everywhere ids ~referenced:named_by
    ~find:(find (("Subject", schema) :: definitions))
    "Subject"

let object_ properties =
  layer
    { Schema.empty with type_ = Some [ Object ]; properties = Some properties }

let schema =
  Alcotest.testable
    (fun f s ->
      Format.pp_print_string f (Yojson.Safe.to_string (Schema.runtime s)))
    ( = )

let written = Alcotest.result schema Alcotest.string

let everywhere_cases () =
  let long = layer { Schema.empty with min_length = Some 2 } in
  Alcotest.check written "a property two parts state differently is merged too"
    (Ok (object_ [ ("a", layer { text_layer with min_length = Some 2 }) ]))
    (everywhere
       (all_of
          [
            object_ [ ("a", text) ];
            layer { Schema.empty with properties = Some [ ("a", long) ] };
          ]));
  Alcotest.check written "an allOf below the top is merged"
    (Ok (object_ [ ("a", text) ]))
    (everywhere (object_ [ ("a", all_of [ named "Text" ]) ]));
  Alcotest.check written "a reference outside an allOf stays one"
    (Ok (object_ [ ("a", named "Text") ]))
    (everywhere (object_ [ ("a", named "Text") ]));
  let node = object_ [ ("child", all_of [ named "Node" ]) ] in
  Alcotest.(check bool)
    "a schema an allOf expands within itself" true
    (Result.is_error (everywhere ~definitions:[ ("Node", node) ] node));
  let tree =
    object_
      [ ("children", layer { Schema.empty with items = Some (named "Tree") }) ]
  in
  Alcotest.check written "a schema that refers to itself outside an allOf"
    (Ok tree)
    (everywhere ~definitions:[ ("Tree", tree) ] tree);
  let thing = object_ [ ("b", text) ] in
  Alcotest.check written "each schema an allOf expands is merged as well"
    (Ok
       (object_
          [ ("b", text); ("a", layer { text_layer with min_length = Some 2 }) ]))
    (everywhere
       ~definitions:
         [
           ("Text", text);
           ("Thing", thing);
           ("Wrapped", all_of [ named "Thing" ]);
         ]
       (all_of
          [ named "Wrapped"; object_ [ ("a", all_of [ named "Text"; long ]) ] ]))

(* A schema that closes what its [$ref] and its [allOf] compose, as
   [Normalize.closed] reads it. *)
let closed_cases () =
  let members = object_ [ ("a", text) ] in
  let closing parts =
    {
      Schema.empty with
      ref_ = Some (reference "Members");
      all_of = Some parts;
      unevaluated_properties = Some (Schema.Boolean_schema false);
      defs = Some [ ("Members", members) ];
    }
  in
  let closed s =
    Normalize.closed ids ~find:(find_referenced [ ("Members", members) ]) s
  in
  Alcotest.check outcome
    "what it composes, closed by additionalProperties, without its $defs"
    (Ok
       {
         Schema.empty with
         type_ = Some [ Object ];
         properties = Some [ ("a", text); ("b", text) ];
         additional_properties = Some (Schema.Boolean_schema false);
       })
    (closed (closing [ object_ [ ("b", text) ] ]));
  Alcotest.(check bool)
    "a composition that is no one object is refused" true
    (Result.is_error
       (closed (closing [ layer { Schema.empty with one_of = Some [ text ] } ])));
  Alcotest.(check bool)
    "a schema closed twice is refused" true
    (Result.is_error
       (closed
          {
            (closing []) with
            additional_properties = Some (Schema.Boolean_schema false);
          }));
  Alcotest.check written
    "each branch of a union that closes what it composes, as its one object"
    (Ok
       (layer
          {
            Schema.empty with
            one_of =
              Some
                [
                  layer
                    {
                      Schema.empty with
                      type_ = Some [ Object ];
                      properties = Some [ ("a", text); ("b", text) ];
                      additional_properties = Some (Schema.Boolean_schema false);
                    };
                  text;
                ];
          }))
    (Normalize.closed_within ids
       ~find:(find_referenced [ ("Members", members) ])
       (layer
          {
            Schema.empty with
            one_of = Some [ layer (closing [ object_ [ ("b", text) ] ]); text ];
          }))

(* [Normalize.shape_only] keeps a map's keys where a schema of their own
   names them, which is their type, and drops a bound on them, which only a
   validator reads; [Normalize.dropped] names only what it drops. *)
let shape_cases () =
  let map_keyed keys =
    layer
      {
        Schema.empty with
        type_ = Some [ Object ];
        property_names = Some keys;
        additional_properties = Some text;
      }
  in
  let by_name = map_keyed (named "Key") in
  let bounded =
    map_keyed (layer { text_layer with pattern = Some "^[a-z]+$" })
  in
  let shape =
    Alcotest.testable
      (fun f s ->
        Format.pp_print_string f (Yojson.Safe.to_string (Schema.runtime s)))
      ( = )
  in
  Alcotest.check shape "keys named by a schema of their own are kept" by_name
    (Normalize.shape_only by_name);
  Alcotest.check shape "keys a bound states are dropped"
    (layer
       {
         Schema.empty with
         type_ = Some [ Object ];
         additional_properties = Some text;
       })
    (Normalize.shape_only bounded);
  Alcotest.(check (list string))
    "only the bound is dropped" []
    (Normalize.dropped by_name);
  Alcotest.(check (list string))
    "the bound is named" [ "propertyNames" ]
    (Normalize.dropped bounded)

let () =
  Alcotest.run "merges"
    [
      ( "each keyword",
        [ Alcotest.test_case "merged by its rule" `Quick keywords ] );
      ( "everywhere",
        [ Alcotest.test_case "no allOf is left" `Quick everywhere_cases ] );
      ( "closed",
        [
          Alcotest.test_case "unevaluatedProperties closes one object" `Quick
            closed_cases;
        ] );
      ( "shape only",
        [
          Alcotest.test_case "a map's keys are kept where they are a type"
            `Quick shape_cases;
        ] );
    ]
