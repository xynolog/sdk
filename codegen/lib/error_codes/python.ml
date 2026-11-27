(* The vocabularies as the Python SDK reads them (python/sdk/src/xynolog):
   each a [Literal] union, so a [match] over one that ends in [assert_never]
   is checked to name every code, and a tuple of the same codes to iterate. *)

module P = Python_syntax

let path = "python/sdk/src/xynolog/error_codes.py"

(* The tuple of a vocabulary's codes. *)
let codes_constant (v : Table.vocabulary) = Text.upper_snake v.name ^ "S"

let union (v : Table.vocabulary) =
  [
    P.alias ~about:[ Prose v.docs ] v.name
      (P.sub ~magic:true "Literal"
         (List.map
            (fun (c : Table.code) ->
              P.element ~about:[ Prose c.docs ] (P.Str c.code))
            v.codes));
    P.assign (codes_constant v)
      ~annotation:
        (P.sub "Final"
           [
             P.item
               (P.sub "tuple" [ P.item (P.Name v.name); P.item P.Ellipsis ]);
           ])
      ~value:
        (P.strings ~magic:true
           (List.map (fun (c : Table.code) -> c.code) v.codes));
  ]

let returning pairs =
  List.map (fun (case, result) -> (case, [ P.Return result ])) pairs

let rpc_constant r = "CONTROL_RPC_" ^ Text.upper_snake (Table.rpc_pascal r)

(* A function of a control code that returns what [value] says of it, a case
   for each code. *)
let answering (t : Table.t) ~doc ~returns name value =
  P.Def
    {
      name;
      params = [ ("code", P.Name t.control.name) ];
      returns = P.Name returns;
      doc = Some (As_is doc);
      body =
        [
          P.Match
            ( P.Name "code",
              returning
                (List.map
                   (fun (a : Table.answered) ->
                     (P.Str a.control_code.code, value a))
                   t.answered)
              @ [
                  ( P.Name "_",
                    [ P.Do (P.call "assert_never" [ P.item (P.Name "code") ]) ]
                  );
                ] );
        ];
    }

(* The JSON-RPC codes the control API answers with, a constant each, and the
   one each control code is answered under, with whether it is retryable. *)
let control_answers (t : Table.t) =
  List.map
    (fun (r : Tables.Control_rpc_codes.codes_item) ->
      P.assign (rpc_constant r) ~annotation:(P.Name "Final")
        ~value:(P.Int r.number) ~doc:(Wrapped r.docs))
    t.rpc_codes
  @ [
      answering t ~returns:"int" "control_rpc_code"
        ~doc:
          "The JSON-RPC code of control/rpc-codes.json an answer carries a \
           control code under." (fun a -> P.Name (rpc_constant a.rpc));
      answering t ~returns:"bool" "control_code_retryable"
        ~doc:
          "Whether the same request can succeed sent again unchanged, once \
           something outside it changes: what `ErrorData.retryable` says of \
           the code." (fun a ->
          P.Name (if a.retryable then "True" else "False"));
    ]

let text (t : Table.t) =
  let vocabularies = Table.vocabularies t in
  let exported =
    List.sort compare
      (List.concat_map
         (fun (v : Table.vocabulary) -> [ v.name; codes_constant v ])
         vocabularies
      @ [
          "LIMIT_REFUSAL_TRANSPORT_CODES";
          "bus_request_code_for_wire_code";
          "transport_error_code_for_status";
          "control_rpc_code";
          "control_code_retryable";
        ]
      @ List.map rpc_constant t.rpc_codes)
  in
  let str (c : Table.code) = P.Str c.code in
  P.text
    {
      header =
        Banner.python_lines ~from_:"protocol/specs/src/errors/codes.json"
          __FILE__;
      doc =
        As_is
          "The codes a Xynolog client reports a failure under.\n\n\
           Each vocabulary is a closed set: a `Literal` union, so a `match` \
           over one that\n\
           ends in `assert_never` is checked to name every code, and a tuple \
           of the same\n\
           codes to iterate.\n";
      imports =
        [ [ P.From ("typing", [ "Final"; "Literal"; "assert_never" ]) ] ];
      body =
        [
          P.assign "__all__"
            ~value:
              (P.List
                 (P.items ~magic:true
                    (List.map (fun n -> P.item (P.Str n)) exported)));
        ]
        @ union t.bus
        @ [
            P.Def
              {
                name = "bus_request_code_for_wire_code";
                params =
                  [
                    (* CommandError.code's enumeration, every member of which
                       the table restates: xynolog.types names this module's
                       vocabularies, so this module reads nothing of it. *)
                    ( "code",
                      P.Binary
                        ( P.sub "Literal"
                            (List.map
                               (fun (wire, _) -> P.item (P.Str wire))
                               t.wire),
                          P.Or,
                          P.Name "None" ) );
                  ];
                returns = P.Name t.bus.name;
                doc =
                  Some
                    (As_is
                       "The bus code a failure's own code \
                        (`CommandError.code`) becomes.\n\n\
                        A failure that states none is the unrecognized \
                        failure, and so is one\n\
                        whose code the wire does not list, which is read as \
                        stating none.\n");
                body =
                  [
                    P.Match
                      ( P.Name "code",
                        returning
                          (List.map
                             (fun (wire, (c : Table.code)) ->
                               (P.Str wire, str c))
                             t.wire
                          @ [ (P.Name "None", str t.unrecognized) ])
                        @ [
                            ( P.Name "_",
                              [
                                P.Do
                                  (P.call "assert_never"
                                     [ P.item (P.Name "code") ]);
                              ] );
                          ] );
                  ];
              };
          ]
        @ union t.transport
        @ [
            P.Def
              {
                name = "transport_error_code_for_status";
                params = [ ("status", P.Name "int") ];
                returns = P.Name t.transport.name;
                doc = Some (As_is "The transport code an HTTP status becomes.");
                body =
                  P.Match
                    ( P.Name "status",
                      returning
                        (List.map
                           (fun (status, (c : Table.code)) ->
                             (P.Int status, str c))
                           t.exact)
                      @ [ (P.Name "_", [ P.Pass ]) ] )
                  :: List.map
                       (fun (status, (c : Table.code)) ->
                         P.If
                           ( P.Binary (P.Name "status", P.Ge, P.Int status),
                             [ P.Return (str c) ] ))
                       (Option.to_list t.from)
                  @ [ P.Return (str t.unclassified) ];
              };
            P.assign "LIMIT_REFUSAL_TRANSPORT_CODES"
              ~annotation:
                (P.sub "Final"
                   [
                     P.item
                       (P.sub "tuple"
                          [
                            P.item
                              (P.sub "tuple"
                                 [
                                   P.item (P.Name "int");
                                   P.item (P.Name "str");
                                   P.item (P.Name t.transport.name);
                                 ]);
                            P.item P.Ellipsis;
                          ]);
                   ])
              ~value:
                (P.tuple ~magic:true
                   (List.map
                      (fun (status, limit, c) ->
                        P.item
                          (P.tuple
                             [
                               P.item (P.Int status);
                               P.item (P.Str limit);
                               P.item (str c);
                             ]))
                      t.limit_refusals))
              ~doc:
                (As_is
                   "Each gateway refusal of a limit that is a transport code \
                    too: its status, its `LimitRefusal` code, and the \
                    transport code it is.");
          ]
        @ List.concat_map union (t.others @ [ t.control ])
        @ control_answers t;
    }

let file t = { Output.path; text = text t }
