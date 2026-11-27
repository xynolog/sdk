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

let text (t : Table.t) =
  let vocabularies = Table.vocabularies t in
  let exported =
    List.sort compare
      (List.concat_map
         (fun (v : Table.vocabulary) -> [ v.name; codes_constant v ])
         vocabularies
      @ [ "bus_request_code_for_wire_code"; "transport_error_code_for_status" ]
      )
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
        [
          [ P.From ("typing", [ "Final"; "Literal"; "assert_never" ]) ];
          [ P.From ("xynolog.types", [ "CommandErrorCode" ]) ];
        ];
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
                    ( "code",
                      P.Binary (P.Name "CommandErrorCode", P.Or, P.Name "None")
                    );
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
          ]
        @ List.concat_map union (t.others @ [ t.control ]);
    }

let file t = { Output.path; text = text t }
