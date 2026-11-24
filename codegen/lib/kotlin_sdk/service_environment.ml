(* Every environment variable a Xynolog service reads as the Kotlin SDK names
   it (kotlin/sdk/src/generated/kotlin/xynolog/services/ServiceEnvironmentVariable.kt,
   from protocol/specs/src/service-environment/variables.json): an object of a
   constant per variable, named as the variable is, with its effect. *)

module K = Kotlin_syntax
module T = Tables.Service_environment_variables

let from_ = "service-environment/variables.json"
let writer = __FILE__
let name = "ServiceEnvironmentVariable"

let declarations (t : T.t) =
  [
    K.class_
      ~about:
        (K.Doc
           "Every environment variable a Xynolog service reads, beside its \
            configuration document, each by its name.")
      ~annotations:[ K.annotation "Generated" ]
      ~visibility:K.Public
      ~members:
        (List.map
           (fun (v : T.variables_item) ->
             K.property ~about:(K.Doc v.effect_) ~visibility:K.Public
               ~const:true ~type_:(K.Type "String")
               ~value:(K.Same_line (K.Str v.name)) v.name)
           t.variables)
      K.Object name;
  ]
