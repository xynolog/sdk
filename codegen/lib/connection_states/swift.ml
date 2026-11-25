(* The moves of a client's stream as the Swift SDK reads them
   (swift/sdk/Sources/Xynolog/Generated/ConnectionStateMoves.swift): each
   ConnectionState with the states it moves to. *)

module S = Swift_syntax

let path = "swift/sdk/Sources/Xynolog/Generated/ConnectionStateMoves.swift"
let state s = S.Implicit_member (Swift_sdk.Models.enum_case s)

let file (t : Table.t) =
  {
    Output.path;
    text =
      S.print
        {
          banner = Banner.lines ~from_:Table.from_ __FILE__;
          imports = [ { S.module_ = "Foundation"; testable = false } ];
          decls =
            [
              ( S.Blank,
                {
                  S.doc =
                    [
                      "Each state of a client's stream, with the states it \
                       moves to and no other.";
                    ];
                  modifiers = [];
                  body =
                    S.Property
                      {
                        var = false;
                        name = "connectionStateMoves";
                        type_ =
                          Some
                            (S.Dictionary_of
                               ( S.Named "ConnectionState",
                                 S.Array_of (S.Named "ConnectionState") ));
                        value =
                          Some
                            (S.Dictionary
                               ( S.Lines,
                                 List.map
                                   (fun (s, moves) ->
                                     ( state s,
                                       S.Array (S.Inline, List.map state moves)
                                     ))
                                   t ));
                      };
                } );
            ];
        };
  }
