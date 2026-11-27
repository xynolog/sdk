(* The states of a client's stream and their moves as the Python SDK reads
   them (python/sdk/src/xynolog/_connection_states.py, which
   xynolog.transport reads): each state with the states it may become. *)

module P = Python_syntax

let path = "python/sdk/src/xynolog/_connection_states.py"

let file (t : Table.t) =
  {
    Output.path;
    text =
      P.text
        {
          header = Banner.python_lines ~from_:Table.from_ __FILE__;
          doc = As_is "The states each state of a client's stream may become.";
          imports =
            [
              [
                P.From ("collections.abc", [ "Mapping" ]);
                P.From ("typing", [ "Final" ]);
              ];
              [ P.From ("xynolog.types", [ "ConnectionState" ]) ];
            ];
          body =
            [
              P.assign "__all__"
                ~value:
                  (P.List
                     (P.items ~magic:true
                        [ P.item (P.Str "CONNECTION_STATE_MAY_BECOME") ]));
              P.assign
                ~about:[ Line "The states each state may be followed by." ]
                ~annotation:
                  (P.sub "Final"
                     [
                       P.item
                         (P.sub "Mapping"
                            [
                              P.item (P.Name "ConnectionState");
                              P.item
                                (P.sub "frozenset"
                                   [ P.item (P.Name "ConnectionState") ]);
                            ]);
                     ])
                ~value:
                  (P.Dict
                     (P.items ~magic:true
                        (List.map
                           (fun (s, moves) ->
                             P.entry (P.Str s)
                               (P.call "frozenset"
                                  (match moves with
                                  | [] -> []
                                  | moves ->
                                      [
                                        P.item
                                          (P.Set
                                             (P.items
                                                (List.map
                                                   (fun m -> P.item (P.Str m))
                                                   moves)));
                                      ])))
                           t)))
                "CONNECTION_STATE_MAY_BECOME";
            ];
        };
  }
