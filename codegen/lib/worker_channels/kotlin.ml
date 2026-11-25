(* The worker's channels as the Kotlin SDK names them (xynolog.jobs, in
   WorkerChannels.kt): a list of channel names per constant, under its name
   in upper case. *)

module K = Kotlin_syntax

let file (constants : Table.t list) =
  Kotlin_sdk.table
    ~from_:(Table.file ^ " and bus/registry.json")
    __FILE__ ~package:"xynolog.jobs" ~name:"WorkerChannels" ~imports:[]
    (List.map
       (fun (c : Table.t) ->
         K.property
           ~about:(K.Doc (Table.doc c))
           ~visibility:K.Public
           ~type_:(K.Generic ("List", [ K.Type "String" ]))
           ~value:
             (K.Same_line
                (K.call ~layout:K.Lines (K.Name "listOf")
                   (List.map (fun n -> K.Str n) c.channels)))
           (Text.upper_snake c.member))
       constants)
