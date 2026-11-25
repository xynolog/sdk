(* The Swift SDK's test bridge (swift/sdk/Tests/XynologTests/Generated/
   TestBridge.swift): a round trip through each model by its schema's name,
   each identifier kind's checked and unchecked parse by its name, and a
   model of every way a property can be stated or absent, which the fidelity
   tests read. It is test dispatch only, and never ships in Xynolog. *)

module S = Swift_syntax
module D = Definitions
module M = Models

let name = M.name
let member = M.member
let call = M.call
let arg = M.arg
let labelled = M.labelled
let json_value = M.json_value
let string_type = M.string_type

let fixture =
  {|{"type":"object","properties":{"requiredValue":{"type":"string"},"requiredNullable":{"type":["string","null"]},"optionalValue":{"type":"string"}},"required":["requiredValue","requiredNullable"],"additionalProperties":true}|}

let fixture_declaration () =
  let schema =
    match
      Decode.run ~file:"FidelityFixture"
        (Yojson.Safe.from_string fixture)
        Schema.decode
    with
    | Ok (schema, _) -> schema
    | Error error -> D.refuse "%s" (Decode.error_to_string error)
  in
  let models =
    M.create
      (D.alone
         ~ids:(Result.get_ok (Decode.ids []))
         ~name:"FidelityFixture" schema)
      ~identifiers:[] ~keys:[]
  in
  M.generate models;
  M.declarations models

let decls ~names ~identifiers =
  let encoder = call (name "JSONEncoder") []
  and decoder = call (name "JSONDecoder") [] in
  let round_trip =
    M.decl [ "private" ]
      (S.Func
         {
           name = "roundTrip";
           generics = [ { name = "Value"; conforms = S.Named "Codable" } ];
           params =
             [
               {
                 label = Some "_";
                 name = "type";
                 type_ = S.Metatype (S.Named "Value");
                 default = None;
               };
               {
                 label = Some "_";
                 name = "input";
                 type_ = json_value;
                 default = None;
               };
             ];
           throws = true;
           result = Some json_value;
           body =
             M.line_block
               [
                 S.Let
                   {
                     var = false;
                     name = "data";
                     type_ = None;
                     value =
                       S.Try (call (member encoder "encode") [ name "input" ]);
                   };
                 S.Let
                   {
                     var = false;
                     name = "value";
                     type_ = None;
                     value =
                       S.Try
                         (labelled (member decoder "decode")
                            [
                              { label = None; value = name "type" };
                              arg "from" (name "data");
                            ]);
                   };
                 S.Return
                   (Some
                      (S.Try
                         (labelled (member decoder "decode")
                            [
                              { label = None; value = M.type_self json_value };
                              arg "from"
                                (call (member encoder "encode")
                                   [ name "value" ]);
                            ])));
               ];
         })
  in
  let round_trip_model =
    M.decl []
      (S.Func
         {
           name = "roundTripModel";
           generics = [];
           params =
             [
               {
                 label = Some "_";
                 name = "name";
                 type_ = string_type;
                 default = None;
               };
               {
                 label = Some "_";
                 name = "value";
                 type_ = json_value;
                 default = None;
               };
             ];
           throws = true;
           result = Some json_value;
           body =
             M.line_block
               [
                 S.Switch
                   {
                     subject = name "name";
                     layout = S.Lines;
                     cases =
                       List.map
                         (fun n ->
                           {
                             S.patterns = [ S.String n ];
                             body =
                               [
                                 S.Return
                                   (Some
                                      (S.Try
                                         (call (name "roundTrip")
                                            [
                                              M.type_self (S.Named n);
                                              name "value";
                                            ])));
                               ];
                           })
                         names
                       @ [
                           {
                             S.patterns = [];
                             body =
                               [
                                 S.Throw
                                   (call
                                      (member (name "BridgeFailure")
                                         "unknownSchema")
                                      [ name "name" ]);
                               ];
                           };
                         ];
                   };
               ];
         })
  in
  let bridge_failure =
    M.decl []
      (S.Enum
         {
           name = "BridgeFailure";
           inherits = [ S.Named "Error" ];
           layout = S.Inline;
           members =
             [
               M.decl []
                 (S.Case
                    {
                      name = "unknownSchema";
                      value = S.Associated [ string_type ];
                    });
             ];
         })
  in
  let parse ~throws result =
    S.Function
      {
        sendable = true;
        params = [ string_type ];
        async_ = false;
        throws;
        result;
      }
  in
  let closure e =
    S.Closure { params = []; layout = S.Inline; body = [ S.Expr e ] }
  in
  let first = name "$0" in
  let identifier_kinds =
    M.decl []
      (S.Property
         {
           var = false;
           name = "identifierKinds";
           type_ =
             Some
               (M.dictionary_of
                  (S.Tuple_of
                     [
                       parse ~throws:true string_type;
                       parse ~throws:false (S.Optional string_type);
                     ]));
           value =
             Some
               (S.Dictionary
                  ( S.Lines,
                    List.map
                      (fun n ->
                        ( S.String n,
                          S.Tuple
                            [
                              closure
                                (S.Try
                                   (member (call (name n) [ first ]) "value"));
                              closure
                                (member
                                   (S.Chained
                                      (call (member (name n) "parse") [ first ]))
                                   "value");
                            ] ))
                      identifiers ));
         })
  in
  [
    (S.Blank, round_trip);
    (S.Line, round_trip_model);
    (S.Line, bridge_failure);
    (S.Line, identifier_kinds);
  ]
  @ List.map (fun d -> (S.Blank, d)) (fixture_declaration ())
