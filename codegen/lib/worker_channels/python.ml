(* The worker's channels as the Python SDK names them
   (python/sdk/src/xynolog/_worker_channels.py, which xynolog.claims
   exports): a tuple of channel names per constant, under its name in upper
   case. *)

module P = Python_syntax

let path = "python/sdk/src/xynolog/_worker_channels.py"
let name (c : Table.t) = Text.upper_snake c.member

let file (constants : Table.t list) =
  {
    Output.path;
    text =
      P.text
        {
          header =
            Banner.python_lines
              ~from_:
                ("protocol/specs/src/" ^ Table.file ^ " and bus/registry.json")
              __FILE__;
          doc =
            As_is
              "The channels a worker's stream names, as client/surface.json's \
               constants state them.\n";
          imports = [ [ P.From ("typing", [ "Final" ]) ] ];
          body =
            P.assign "__all__"
              ~value:
                (P.List
                   (P.items ~magic:true
                      (List.map
                         (fun n -> P.item (P.Str n))
                         (List.sort compare (List.map name constants)))))
            :: List.map
                 (fun (c : Table.t) ->
                   P.assign
                     ~about:[ Prose (Table.doc c) ]
                     ~annotation:
                       (P.sub "Final"
                          [
                            P.item
                              (P.sub "tuple"
                                 [ P.item (P.Name "str"); P.item P.Ellipsis ]);
                          ])
                     ~value:(P.strings ~magic:true c.channels)
                     (name c))
                 constants;
        };
  }
