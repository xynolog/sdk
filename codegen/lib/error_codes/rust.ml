(* The failure vocabularies as the Rust SDK reads them
   (rust/sdk/src/errors.rs): an enum per vocabulary whose [as_str] is the
   code, the bus code each of the wire's own codes becomes, in the wire's
   order, and the transport code each HTTP status becomes. A code's variant
   is its part after its last dot, in PascalCase. *)

module R = Rust_syntax

let path = "rust/sdk/src/generated/error_codes.rs"
let variant (c : Table.code) = Text.pascal (Table.segment c.code)
let static_str = R.static_str
let wire_type = R.named "crate::types::CommandErrorCode"

let wire_variant wire =
  R.Path [ "crate"; "types"; "CommandErrorCode"; Text.pascal wire ]

let some e = R.call "Some" [ e ]

let vocabulary ~name (v : Table.vocabulary) =
  let of_ c = R.Path [ name; variant c ] in
  [
    R.Enum
      {
        doc = [ v.docs ];
        attrs =
          [
            R.List
              ( [ "derive" ],
                List.map
                  (fun w ->
                    R.Word
                      (String.split_on_char ':' w |> List.filter (( <> ) "")))
                  [
                    "Debug";
                    "Clone";
                    "Copy";
                    "PartialEq";
                    "Eq";
                    "Hash";
                    "serde::Deserialize";
                    "serde::Serialize";
                  ] );
          ];
        vis = Pub;
        name;
        variants =
          List.map
            (fun (c : Table.code) ->
              R.variant ~doc:[ c.docs ]
                ~attrs:
                  [
                    R.List
                      ([ "serde" ], [ R.Name_value ("rename", R.Str c.code) ]);
                  ]
                (variant c))
            v.codes;
      };
    R.Blank;
    R.Impl
      {
        generics = [];
        trait_ = None;
        for_ = R.named name;
        items =
          [
            R.I_const
              {
                doc = [ "Every code of the vocabulary, in the table's order." ];
                vis = Pub;
                name = "ALL";
                ty = R.Array_of (R.named name, List.length v.codes);
                value = Some (R.Array (List.map of_ v.codes));
              };
            R.I_blank;
            R.I_fn
              (R.fn_
                 ~doc:[ "The code as every SDK reports it." ]
                 ~vis:Pub ~const:true "as_str" ~params:[ R.Self_value ]
                 ~ret:static_str
                 [
                   R.Tail
                     (R.Match
                        ( R.p "self",
                          List.map
                            (fun (c : Table.code) -> (of_ c, R.Str c.code))
                            v.codes ));
                 ]);
          ];
      };
    R.Blank;
  ]

let file (t : Table.t) =
  let bus c = R.Path [ "BusRequestErrorCode"; variant c ] in
  let transport c = R.Path [ "TransportErrorCode"; variant c ] in
  let names : Table.vocabulary -> string = fun v -> v.go_name in
  {
    Output.path;
    text =
      R.text
        ~header:
          (Banner.lines ~from_:"protocol/specs/src/errors/codes.json" __FILE__)
        (vocabulary ~name:"BusRequestErrorCode" t.bus
        @ [
            R.Impl
              {
                generics = [];
                trait_ = None;
                for_ = R.named "BusRequestErrorCode";
                items =
                  [
                    R.I_fn
                      (R.fn_
                         ~doc:
                           [
                             "The code a failure's own code \
                              (`CommandError.code`) becomes; one that states \
                              none is the table's `unrecognizedFailure`.";
                           ]
                         ~vis:Pub "of_wire"
                         ~params:
                           [
                             R.Param
                               ("code", R.named "Option" ~args:[ wire_type ]);
                           ]
                         ~ret:(R.named "BusRequestErrorCode")
                         [
                           R.Tail
                             (R.Match
                                ( R.p "code",
                                  List.map
                                    (fun wire ->
                                      ( some (wire_variant wire),
                                        bus (List.assoc wire t.wire) ))
                                    Table.wire_codes
                                  @ [ (R.p "None", bus t.unrecognized) ] ));
                         ]);
                    R.I_blank;
                    R.I_fn
                      (R.fn_
                         ~doc:
                           [
                             "The wire code a peer stated, when this code \
                              restates one: what a service answers its own \
                              caller with. A failure only this side knows \
                              states none.";
                           ]
                         ~vis:Pub ~const:true "wire" ~params:[ R.Self_value ]
                         ~ret:(R.named "Option" ~args:[ wire_type ])
                         [
                           R.Tail
                             (R.Match
                                ( R.p "self",
                                  List.map
                                    (fun (wire, code) ->
                                      (bus code, some (wire_variant wire)))
                                    t.wire
                                  @ [ (R.Wild, R.p "None") ] ));
                         ]);
                  ];
              };
            R.Blank;
          ]
        @ vocabulary ~name:"TransportErrorCode" t.transport
        @ [
            R.Impl
              {
                generics = [];
                trait_ = None;
                for_ = R.named "TransportErrorCode";
                items =
                  [
                    R.I_fn
                      (R.fn_
                         ~doc:[ "The code an HTTP status becomes." ]
                         ~vis:Pub ~const:true "of_status"
                         ~params:[ R.Param ("status", R.named "u16") ]
                         ~ret:(R.named "TransportErrorCode")
                         [
                           R.Tail
                             (R.Match
                                ( R.p "status",
                                  List.map
                                    (fun (status, code) ->
                                      (R.Int status, transport code))
                                    t.exact
                                  @ (match t.from with
                                    | Some (status, code) ->
                                        [
                                          ( R.Range_from (R.Int status),
                                            transport code );
                                        ]
                                    | None -> [])
                                  @ [ (R.Wild, transport t.unclassified) ] ));
                         ]);
                  ];
              };
            R.Blank;
          ]
        @ List.concat_map (fun v -> vocabulary ~name:(names v) v) t.others
        @ vocabulary ~name:(names t.control) t.control);
  }
