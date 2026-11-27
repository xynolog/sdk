(* The vocabularies of codes as the Haskell SDK reads them
   (haskell/sdk/src/Xynolog/ErrorCodes.hs): a type per vocabulary, its
   constructors the vocabulary's name and then each code's after its first
   dot, in words begun upper case ([bus.not-found] of busRequest is
   [BusRequestNotFound]); each code's wire spelling and the code a spelling
   reads as; and, for a vocabulary read from HTTP statuses, the code each
   status reads as. The round trip of each, by the vocabulary's name, is a
   test's (test/Xynolog/Internal/Generated/ErrorRoundTrip.hs). Discovery's
   absent reasons are a vocabulary as well, and written the same way. *)

module H = Haskell_syntax

(* [text]'s runs of letters and digits, each begun upper case. *)
let words text =
  String.concat ""
    (List.map String.capitalize_ascii
       (List.filter (( <> ) "")
          (String.split_on_char '\x00'
             (String.map
                (function
                  | ('a' .. 'z' | 'A' .. 'Z' | '0' .. '9') as c -> c
                  | _ -> '\x00')
                text))))

let code_constructor family code =
  words family
  ^ words
      (match String.index_opt code '.' with
      | Some i -> String.sub code (i + 1) (String.length code - i - 1)
      | None -> code)

(* The statuses a vocabulary's codes are read from: each exact status and
   its code, in the table's order; the status at or above which every one is
   read as a code; and the code any other is read as. *)
type statuses = {
  exact : (int * string) list;
  from : (int * string) option;
  unclassified : string;
}

type family = {
  member : string;
  codes : string list;
  statuses : statuses option;
}

let type_of member = words member ^ "Code"
let type_name f = type_of f.member

(* The bus vocabulary's type, and the constructor of each of its codes. *)
let bus_type = type_of Table.bus_member
let bus_constructor = code_constructor Table.bus_member
let function_name f = f.member ^ "Code"

let declarations f =
  let typ = type_name f and function_ = function_name f in
  let constructor = code_constructor f.member in
  let parse = "parse" ^ typ in
  [
    H.data typ
      (List.map (fun c -> H.constructor (constructor c)) f.codes)
      ~deriving:[ "Eq"; "Ord"; "Show"; "Enum"; "Bounded" ];
    Value
      {
        about = [];
        name = function_;
        type_ = T_fun (T_name typ, T_name "Text");
        clauses =
          List.map
            (fun c ->
              { H.patterns = [ Constructor (constructor c, []) ]; body = Str c })
            f.codes;
      };
    Value
      {
        about = [];
        name = parse;
        type_ = T_fun (T_name "Text", T_apply ("Maybe", [ T_name typ ]));
        clauses =
          [
            {
              patterns = [ Var "value" ];
              body =
                Case
                  ( Name "value",
                    List.map
                      (fun c ->
                        ( H.Literal c,
                          H.Apply (Name "Just", [ Name (constructor c) ]) ))
                      f.codes
                    @ [ (Otherwise, Name "Nothing") ] );
            };
          ];
      };
    H.instance "ToJSON" (T_name typ)
      [ H.method_ "toJSON" (Compose (Name "String", Name function_)) ];
    H.instance "FromJSON" (T_name typ)
      [
        H.method_ "parseJSON"
          (Apply
             ( Name "withText",
               [
                 Str typ;
                 Lambda
                   ( "value",
                     Apply
                       ( Name "maybe",
                         [
                           Apply (Name "fail", [ Str "unknown error code" ]);
                           Name "pure";
                           Apply (Name parse, [ Name "value" ]);
                         ] ) );
               ] ));
      ];
  ]
  @
  match f.statuses with
  | None -> []
  | Some s ->
      let is op n = H.Infix (Name "status", [ (op, Int n) ]) in
      let guards =
        List.map (fun (n, c) -> (is "==" n, c)) s.exact
        @ List.map (fun (n, c) -> (is ">=" n, c)) (Option.to_list s.from)
      in
      [
        Value
          {
            about = [];
            name = function_ ^ "FromStatus";
            type_ = T_fun (T_name "Int", T_name typ);
            clauses =
              [
                {
                  patterns = [ Var "status" ];
                  body =
                    List.fold_right
                      (fun (test, c) otherwise ->
                        H.If (test, Name (constructor c), otherwise))
                      guards
                      (Name (constructor s.unclassified));
                };
              ];
          };
      ]

(* The module of [families] and the test that round-trips each, by its
   name. *)
let modules ?(beside = []) ~from_ ~module_name ~test_name families =
  let families =
    List.sort (fun a b -> String.compare a.member b.member) families
  in
  let banner = Banner.lines ~from_ __FILE__ in
  let path name =
    "haskell/sdk/" ^ String.map (function '.' -> '/' | c -> c) name ^ ".hs"
  in
  let test_module = "Xynolog.Internal.Generated." ^ test_name in
  [
    {
      Output.path = path ("src." ^ module_name);
      text =
        H.text
          {
            banner;
            extensions = [ "OverloadedStrings" ];
            name = module_name;
            imports =
              [
                H.import "Data.Aeson"
                  ~items:
                    [
                      All "FromJSON";
                      All "ToJSON";
                      All "Value";
                      Plain "withText";
                    ];
                H.import "Data.Text" ~items:[ Plain "Text" ];
              ];
            body = List.concat_map declarations families @ beside;
          };
    };
    {
      Output.path = path ("test." ^ test_module);
      text =
        H.text
          {
            banner;
            extensions = [ "OverloadedStrings" ];
            name = test_module;
            imports =
              [
                H.import "Data.Aeson"
                  ~items:[ Plain "Value"; Plain "parseJSON"; Plain "toJSON" ];
                H.import "Data.Aeson.Types" ~items:[ Plain "parseEither" ];
                H.import "Data.Text" ~items:[ Plain "Text" ];
                H.import module_name;
              ];
            body =
              [
                Value
                  {
                    about = [];
                    name = "roundTripError";
                    type_ =
                      T_fun
                        ( T_name "Text",
                          T_fun
                            ( T_name "Value",
                              T_apply
                                ("Either", [ T_name "String"; T_name "Value" ])
                            ) );
                    clauses =
                      [
                        {
                          patterns = [ Var "family"; Var "value" ];
                          body =
                            Case
                              ( Name "family",
                                List.map
                                  (fun f ->
                                    ( H.Literal f.member,
                                      H.Infix
                                        ( Name "toJSON",
                                          [
                                            ( "<$>",
                                              Typed
                                                ( Apply
                                                    ( Name "parseEither",
                                                      [
                                                        Name "parseJSON";
                                                        Name "value";
                                                      ] ),
                                                  T_apply
                                                    ( "Either",
                                                      [
                                                        T_name "String";
                                                        T_name (type_name f);
                                                      ] ) ) );
                                          ] ) ))
                                  families
                                @ [
                                    ( Otherwise,
                                      Apply
                                        ( Name "Left",
                                          [ Str "unknown error-code family" ] )
                                    );
                                  ] );
                        };
                      ];
                  };
              ];
          };
    };
  ]

(* The JSON-RPC codes the control API answers with, a value each, and the
   one each control code is answered under, with whether it is retryable. *)
let control_answers (t : Table.t) =
  let rpc_value r = "controlRpc" ^ Table.rpc_pascal r in
  let typ = type_of t.control.member in
  let answering ~about ~returns name value =
    H.Value
      {
        about = [ about ];
        name;
        type_ = T_fun (T_name typ, T_name returns);
        clauses =
          List.map
            (fun (a : Table.answered) ->
              {
                H.patterns =
                  [
                    Constructor
                      (code_constructor t.control.member a.control_code.code, []);
                  ];
                body = value a;
              })
            t.answered;
      }
  in
  List.map
    (fun (r : Tables.Control_rpc_codes.codes_item) ->
      H.value ~about:[ r.docs ] (rpc_value r) (T_name "Int") (Int r.number))
    t.rpc_codes
  @ [
      answering
        ~about:
          "The JSON-RPC code of control/rpc-codes.json an answer carries a \
           control code under." ~returns:"Int" "controlRpc" (fun a ->
          H.Name (rpc_value a.rpc));
      answering
        ~about:
          "Whether the same request can succeed sent again unchanged, once \
           something outside it changes: what ErrorData's retryable says of \
           the code." ~returns:"Bool" "controlRetryable" (fun a ->
          H.Name (if a.retryable then "True" else "False"));
    ]

let files (t : Table.t) =
  let codes (v : Table.vocabulary) =
    List.map (fun (c : Table.code) -> c.code) v.codes
  in
  let plain (v : Table.vocabulary) =
    { member = v.member; codes = codes v; statuses = None }
  in
  let code (c : Table.code) = c.code in
  let transport (c : Table.code) =
    H.Name (code_constructor t.transport.member c.code)
  in
  modules
    ~beside:
      ([
         H.value
           ~about:
             [
               "Each gateway refusal of a limit that is a transport code too: \
                its status, its LimitRefusal code, and the transport code it \
                is.";
             ]
           "limitRefusalTransportCodes"
           (T_list
              (T_tuple
                 [
                   T_name "Int";
                   T_name "Text";
                   T_name (type_of t.transport.member);
                 ]))
           (List
              (List.map
                 (fun (status, limit, c) ->
                   H.Tuple [ Int status; Str limit; transport c ])
                 t.limit_refusals));
       ]
      @ control_answers t)
    ~from_:("protocol/specs/src/" ^ Table.file)
    ~module_name:"Xynolog.ErrorCodes" ~test_name:"ErrorRoundTrip"
    ((plain t.bus :: plain t.control :: List.map plain t.others)
    @ [
        {
          (plain t.transport) with
          statuses =
            Some
              {
                exact = List.map (fun (n, c) -> (n, code c)) t.exact;
                from = Option.map (fun (n, c) -> (n, code c)) t.from;
                unclassified = code t.unclassified;
              };
        };
      ])
