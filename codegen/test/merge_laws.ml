(* The laws of the generator's allOf merge (Normalize.merge), by which it
   writes the Haskell SDK's types and the schemas it validates against.

   - An empty part is its identity, and a part merged with itself is that part.
   - It is associative, so the parts of an allOf may be merged in any grouping.
   - It is commutative where JSON Schema's allOf is: the order of the parts
     decides nothing but the keywords the merge lets the later part decide
     ([disputed]). Of those, title, description, $comment, default, examples
     and discriminator only describe a value. The rest are assertions JSON
     Schema applies from every part, which the merge takes from the later
     one: format, an allOf a part keeps, and additionalProperties and
     unevaluatedProperties when neither part closes the object. Two
     propertyNames, or two nots, are joined in the order of their parts.
     $schema, $id and $defs, which only a file's root states, are the later
     part's too.

   Each law holds up to what the merge's result means: a property two parts
   state differently is the allOf of both, so the properties are compared as
   the set of what each requires of its value, and, for commutativity,
   required and enum as sets. *)

open Xynolog_codegen
module Gen = QCheck2.Gen

let reference target = { Decode.target; file = ""; pointer = "" }

(* The references here name schemas by path, so they need no index of [$id]s. *)
let ids = Result.get_ok (Decode.ids [])
let text = Schema.Schema { Schema.empty with type_ = Some [ String ] }
let long = Schema.Schema { Schema.empty with min_length = Some 2 }

let named =
  Schema.Schema { Schema.empty with ref_ = Some (reference "Named.json") }

(* A keyword stated in nearly a third of parts. Parts that each state most
   keywords conflict on one nearly always, and a law that compares two
   refusals proves nothing; [merging] checks enough cases merge. *)
let stated values = Gen.option ~ratio:0.3 (Gen.oneof_list values)

(* A part, each keyword from values close enough that parts often state it
   alike, often otherwise, and often not at all. *)
let part : Schema.schema Gen.t =
  let open Gen in
  let* schema = stated [ () ] in
  let* id = stated [ Decode.base ^ "A.json"; Decode.base ^ "B.json" ] in
  let* ref_ = stated [ reference "A.json"; reference "B.json" ] in
  let* comment = stated [ "first"; "second" ] in
  let* title = stated [ "First"; "Second" ] in
  let* description = stated [ "One."; "Another." ] in
  let* type_ = stated [ [ Schema.String ]; [ Object ] ] in
  let* format = stated [ Schema.Uri; Date_time ] in
  let* enum =
    stated
      [
        [ Schema.String_literal "a"; String_literal "b" ];
        [ String_literal "b"; String_literal "c" ];
        [ String_literal "c" ];
      ]
  in
  let* const = stated [ Schema.String_literal "a"; Int_literal 1 ] in
  let* default = stated [ Schema.String_literal "a"; Bool_literal true ] in
  let* examples = stated [ [ `String "a" ]; [ `Int 1 ] ] in
  let* properties =
    stated [ [ ("p", text) ]; [ ("p", long); ("q", text) ]; [ ("q", named) ] ]
  in
  let* required = stated [ [ "p" ]; [ "q"; "p" ] ] in
  let* additional_properties =
    stated [ Schema.Boolean_schema false; Boolean_schema true; text; long ]
  in
  let* unevaluated_properties =
    stated [ Schema.Boolean_schema false; Boolean_schema true; text ]
  in
  let* property_names = stated [ text; long ] in
  let* min_properties = stated [ 0; 2 ] in
  let* max_properties = stated [ 1; 3 ] in
  let* items = stated [ text; long ] in
  let* min_items = stated [ 0; 2 ] in
  let* max_items = stated [ 1; 3 ] in
  let* unique_items = stated [ true; false ] in
  let* min_length = stated [ 0; 2 ] in
  let* max_length = stated [ 1; 3 ] in
  let* pattern = stated [ "^a$"; "^b$" ] in
  let* minimum = stated [ 0.; 1.5 ] in
  let* maximum = stated [ 2.; 3.5 ] in
  let* all_of = stated [ [ text ]; [ text; long ] ] in
  let* any_of = stated [ [ text ]; [ text; long ] ] in
  let* one_of = stated [ [ text ]; [ long; text ] ] in
  let* not_ = stated [ text; long ] in
  let* defs = stated [ [ ("D", text) ]; [ ("D", long) ] ] in
  let+ discriminator =
    stated
      [
        { Schema.property_name = "kind"; mapping = None };
        { property_name = "type"; mapping = Some [ ("a", "A.json") ] };
      ]
  in
  {
    Schema.schema;
    id;
    ref_;
    comment;
    title;
    description;
    type_;
    format;
    enum;
    const;
    default;
    examples;
    properties;
    required;
    additional_properties;
    unevaluated_properties;
    property_names;
    min_properties;
    max_properties;
    items;
    min_items;
    max_items;
    unique_items;
    min_length;
    max_length;
    pattern;
    minimum;
    maximum;
    all_of;
    any_of;
    one_of;
    not_;
    defs;
    discriminator;
  }

(* [later] without each keyword the merge takes from the later part where
   [earlier] states it otherwise: the keywords whose order decides the merge,
   though not JSON Schema's allOf. Every keyword is named, so one the model
   learns must be placed here. *)
let undisputed (earlier : Schema.schema)
    ({
       schema;
       id;
       ref_;
       comment;
       title;
       description;
       type_;
       format;
       enum;
       const;
       default;
       examples;
       properties;
       required;
       additional_properties;
       unevaluated_properties;
       property_names;
       min_properties;
       max_properties;
       items;
       min_items;
       max_items;
       unique_items;
       min_length;
       max_length;
       pattern;
       minimum;
       maximum;
       all_of;
       any_of;
       one_of;
       not_;
       defs;
       discriminator;
     } :
      Schema.schema) : Schema.schema =
  let disputed theirs ours =
    match (theirs, ours) with
    | Some theirs, Some own when theirs <> own -> None
    | _ -> ours
  in
  let closes = function
    | Some (Schema.Boolean_schema false) -> true
    | _ -> false
  in
  let open_ earlier later =
    if closes earlier || closes later then later else disputed earlier later
  in
  {
    schema = disputed earlier.schema schema;
    id = disputed earlier.id id;
    ref_;
    comment = disputed earlier.comment comment;
    title = disputed earlier.title title;
    description = disputed earlier.description description;
    type_;
    format = disputed earlier.format format;
    enum;
    const;
    default = disputed earlier.default default;
    examples = disputed earlier.examples examples;
    properties;
    required;
    additional_properties =
      open_ earlier.additional_properties additional_properties;
    unevaluated_properties =
      open_ earlier.unevaluated_properties unevaluated_properties;
    property_names = disputed earlier.property_names property_names;
    min_properties;
    max_properties;
    items;
    min_items;
    max_items;
    unique_items;
    min_length;
    max_length;
    pattern;
    minimum;
    maximum;
    all_of = disputed earlier.all_of all_of;
    any_of;
    one_of;
    not_ = disputed earlier.not_ not_;
    defs = disputed earlier.defs defs;
    discriminator = disputed earlier.discriminator discriminator;
  }

(* What a schema requires of a value: an allOf that states nothing else is
   what its parts require. *)
let rec conjuncts = function
  | Schema.Schema ({ all_of = Some parts; _ } as s)
    when { s with all_of = None } = Schema.empty ->
      List.concat_map conjuncts parts
  | s -> [ s ]

(* [s] as the laws compare it: its properties by name, each as the set of
   what it requires, and, unless [ordered], its required and enum as sets. *)
let meaning ~ordered (s : Schema.schema) =
  let set values = if ordered then values else List.sort_uniq compare values in
  ( {
      s with
      properties = None;
      required = Option.map set s.required;
      enum = Option.map set s.enum;
    },
    Option.map
      (fun properties ->
        List.sort compare
          (List.map
             (fun (key, property) ->
               (key, List.sort_uniq compare (conjuncts property)))
             properties))
      s.properties )

(* Two merges alike: both refused, or both the same schema. *)
let alike ~ordered left right =
  match (left, right) with
  | Ok l, Ok r -> meaning ~ordered l = meaning ~ordered r
  | Error _, Error _ -> true
  | Ok _, Error _ | Error _, Ok _ -> false

let ( let* ) = Result.bind
let count = 5000

let law name gen holds =
  QCheck_alcotest.to_alcotest (QCheck2.Test.make ~count ~name gen holds)

let laws =
  [
    law "the empty part is the identity" part (fun a ->
        Normalize.merge ids Schema.empty a = Ok a
        && Normalize.merge ids a Schema.empty = Ok a);
    law "a part merged with itself is that part" part (fun a ->
        alike ~ordered:true (Normalize.merge ids a a) (Ok a));
    law "associative" (Gen.triple part part part) (fun (a, b, c) ->
        alike ~ordered:true
          (let* ab = Normalize.merge ids a b in
           Normalize.merge ids ab c)
          (let* bc = Normalize.merge ids b c in
           Normalize.merge ids a bc));
    law "commutative but for the disputed keywords" (Gen.pair part part)
      (fun (a, b) ->
        let b = undisputed a b in
        alike ~ordered:false (Normalize.merge ids a b) (Normalize.merge ids b a));
  ]

(* More than a third of the cases the laws are checked on merge, rather than
   being refused on both sides. *)
let merging () =
  let rand = Random.State.make [| 0 |] in
  let merged =
    List.length
      (List.filter
         (fun (a, b, c) ->
           Result.is_ok
             (Result.bind (Normalize.merge ids a b) (fun ab ->
                  Normalize.merge ids ab c)))
         (Gen.generate ~rand ~n:count (Gen.triple part part part)))
  in
  Alcotest.(check bool)
    (Printf.sprintf "%d of %d triples merge" merged count)
    true
    (merged * 3 > count)

(* The keywords [undisputed] exempts do decide the merge by order: without
   the exemption, commutativity fails. *)
let disputed_decide () =
  let earlier = { Schema.empty with format = Some Uri }
  and later = { Schema.empty with format = Some Date_time } in
  Alcotest.(check bool)
    "format is the later part's" false
    (alike ~ordered:false
       (Normalize.merge ids earlier later)
       (Normalize.merge ids later earlier))

let () =
  Alcotest.run "merge_laws"
    [
      ("laws", laws);
      ("cases", [ Alcotest.test_case "a third merge" `Quick merging ]);
      ( "disputed",
        [ Alcotest.test_case "decide by order" `Quick disputed_decide ] );
    ]
