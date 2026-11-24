(* What each component requires, as the Rust SDK holds it
   (rust/sdk/src/required.rs): a reference by [reference], a value of some
   kinds that states nothing else by [of], and any other shape a Shape whose
   parts it does not state are NONE's, its parts in the order the table
   states them. *)

module R = Rust_syntax

let path = "rust/sdk/src/generated/required.rs"
let some e = R.call "Some" [ e ]
let slice items = R.Ref_of (R.Array items)
let strings names = slice (List.map (fun n -> R.Str n) names)

let literal : Schema.literal -> R.expr = function
  | String_literal s -> R.call "Listed::Text" [ R.Str s ]
  | Int_literal n -> R.call "Listed::Number" [ R.Float (float_of_int n) ]
  | Bool_literal b -> R.call "Listed::Boolean" [ R.Bool b ]

let rec shape : Shape.shape -> R.expr = function
  | Ref name -> R.call "reference" [ R.Str name ]
  | Shape b -> (
      let part name write = Option.map (fun v -> (name, write v)) in
      let nonempty name write = function
        | [] -> None
        | items -> Some (name, write items)
      in
      let max = function Some m -> some (R.Int m) | None -> R.p "None" in
      let rec term : Shape.term -> R.expr = function
        | Step s ->
            R.call "Term::Step"
              [
                R.Struct
                  ( [ "Step" ],
                    [
                      ( "of",
                        slice
                          (List.map
                             (fun (lo, hi) -> R.Tuple [ R.Int lo; R.Int hi ])
                             s.of_) );
                      ("min", R.Int s.min);
                      ("max", max s.max);
                    ],
                    None );
              ]
        | Group g ->
            R.call "Term::Group"
              [
                R.Struct
                  ( [ "Group" ],
                    [
                      ( "either",
                        slice
                          (List.map
                             (fun terms -> slice (List.map term terms))
                             g.either) );
                      ("min", R.Int g.min);
                      ("max", max g.max);
                    ],
                    None );
              ]
      in
      let fields =
        List.filter_map Fun.id
          [
            part "kinds"
              (fun ks ->
                some
                  (slice
                     (List.map
                        (fun k ->
                          R.Path
                            [
                              "Kind";
                              String.capitalize_ascii (Shape.kind_name k);
                            ])
                        ks)))
              b.kinds;
            part "recognized" (fun names -> some (strings names)) b.recognized;
            part "enumeration"
              (fun vs -> some (slice (List.map literal vs)))
              b.enum;
            part "pattern"
              (fun terms -> some (slice (List.map term terms)))
              b.pattern;
            part "min_length" (fun n -> some (R.Int n)) b.min_length;
            part "max_length" (fun n -> some (R.Int n)) b.max_length;
            part "minimum" (fun n -> some (R.Float n)) b.minimum;
            part "maximum" (fun n -> some (R.Float n)) b.maximum;
            part "min_items" (fun n -> some (R.Int n)) b.min_items;
            part "max_items" (fun n -> some (R.Int n)) b.max_items;
            part "required" strings b.required;
            nonempty "members"
              (fun members ->
                slice
                  (List.map
                     (fun (name, s) -> R.Tuple [ R.Str name; shape s ])
                     members))
              b.members;
            part "closed" (fun names -> some (strings names)) b.closed;
            part "items" (fun s -> some (R.Ref_of (shape s))) b.items;
            part "values" (fun s -> some (R.Ref_of (shape s))) b.values;
            nonempty "one_of"
              (fun shapes -> slice (List.map shape shapes))
              b.one_of;
            part "discriminator"
              (fun (d : Shape.discriminator) ->
                some
                  (R.Struct
                     ( [ "Discriminator" ],
                       [
                         ("property", R.Str d.property);
                         ( "mapping",
                           slice
                             (List.map
                                (fun (v, i) -> R.Tuple [ R.Str v; R.Int i ])
                                d.mapping) );
                       ],
                       None )))
              b.discriminator;
            nonempty "all_of"
              (fun shapes -> slice (List.map shape shapes))
              b.all_of;
            nonempty "not_all"
              (fun sets -> slice (List.map strings sets))
              b.not_all;
            part "min_members" (fun n -> some (R.Int n)) b.min_members;
            part "names" (fun s -> some (R.Ref_of (shape s))) b.names;
          ]
      in
      match fields with
      | [ ("kinds", R.Call (_, [ kinds ])) ] -> R.call "of" [ kinds ]
      | _ -> R.Struct ([ "Shape" ], fields, Some (R.p "NONE")))

let file (shapes : (string * Shape.shape) list) =
  {
    Output.path;
    text =
      R.text
        ~header:
          (Banner.lines
             ~from_:"the component schemas of protocol/specs/src/openapi.json"
             __FILE__)
        [
          R.Const
            {
              doc = [];
              attrs = [];
              vis = Pub_crate;
              name = "SCHEMAS";
              ty =
                R.Ref (None, R.Slice (R.Tuple_of [ R.str_ty; R.named "Shape" ]));
              value =
                slice
                  (List.map
                     (fun (name, s) -> R.Tuple [ R.Str name; shape s ])
                     shapes);
            };
        ];
  }
