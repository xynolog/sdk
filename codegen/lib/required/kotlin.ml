(* What each component requires of a value, as the Kotlin SDK reads it
   (xynolog.bus): each shape by its component's name, as its own JSON, since
   one string of the whole table would be past what a class file's constant
   holds. *)

module K = Kotlin_syntax

let file (shapes : (string * Shape.shape) list) =
  if shapes = [] then
    Kotlin_sdk.Names.refuse "the table of what each schema requires holds none";
  Kotlin_sdk.data_file
    ~banner:(Banner.lines ~from_:Table.authority __FILE__)
    ~package:"xynolog.bus" ~name:"RequiredTable" ~imports:[]
    [
      K.property
        ~about:
          (K.Doc
             "What each component schema requires of a value, by its name, as \
              JSON: the rules are codegen/lib/required/shape.ml's.")
        ~visibility:K.Internal
        ~type_:(K.Generic ("Map", [ K.Type "String"; K.Type "String" ]))
        ~value:
          (K.Same_line
             (K.call ~layout:K.Lines (K.Name "mapOf")
                (List.map
                   (fun (name, shape) ->
                     K.Binary
                       ( K.Str name,
                         K.To,
                         K.Str
                           (Yojson.Safe.to_string
                              (Shape.to_json ~pairs:false shape)) ))
                   shapes)))
        "REQUIRED_SCHEMAS";
    ]
