(* The worker's channels as the Swift SDK names them
   (swift/sdk/Sources/Xynolog/Generated/WorkerChannels.swift): an array of
   channel names per constant, under its own name. *)

module S = Swift_syntax

let path = "swift/sdk/Sources/Xynolog/Generated/WorkerChannels.swift"

let file (constants : Table.t list) =
  {
    Output.path;
    text =
      S.print
        {
          banner =
            Banner.lines
              ~from_:
                ("protocol/specs/src/" ^ Table.file ^ " and bus/registry.json")
              __FILE__;
          imports = [ { S.module_ = "Foundation"; testable = false } ];
          decls =
            List.map
              (fun (c : Table.t) ->
                ( S.Blank,
                  {
                    S.doc = [ Table.doc c ];
                    modifiers = [ "public" ];
                    body =
                      S.Property
                        {
                          var = false;
                          name = c.member;
                          type_ = Some (S.Array_of (S.Named "String"));
                          value =
                            Some
                              (S.Array
                                 ( S.Lines,
                                   List.map (fun n -> S.String n) c.channels ));
                        };
                  } ))
              constants;
        };
  }
