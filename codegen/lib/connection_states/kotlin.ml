(* The moves of a client's stream as the Kotlin SDK reads them
   (xynolog.transport, in ConnectionStateMoves.kt): each ConnectionState with
   the states it moves to. *)

module K = Kotlin_syntax

let state s =
  K.Member (K.Name "ConnectionState", Kotlin_sdk.Names.variant_of s)

let file (t : Table.t) =
  Kotlin_sdk.table ~from_:Table.file __FILE__ ~package:"xynolog.transport"
    ~name:"ConnectionStateMoves"
    ~imports:[ Kotlin_sdk.Types.types_package ^ ".ConnectionState" ]
    [
      K.property
        ~about:
          (K.Doc
             "Each state of a client's stream, with the states it moves to \
              and no other.")
        ~visibility:K.Internal
        ~type_:
          (K.Generic
             ( "Map",
               [ K.Type "ConnectionState"; K.Generic ("Set", [ K.Type "ConnectionState" ]) ] ))
        ~value:
          (K.Same_line
             (K.call ~layout:K.Lines (K.Name "mapOf")
                (List.map
                   (fun (s, moves) ->
                     K.Binary
                       ( state s,
                         K.To,
                         K.call (K.Name "setOf") (List.map state moves) ))
                   t)))
        "CONNECTION_STATE_MOVES";
    ]
