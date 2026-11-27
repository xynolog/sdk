(* The option defaults as the Kotlin SDK reads them: in xynolog.OptionDefaults
   a constant per row, [gatherResourceDepth] as [GATHER_RESOURCE_DEPTH], an
   integer a Long as the SDK's types hold one, a value of an enumeration its
   entry, and a value of a named schema read from its JSON by the type's
   serializer. *)

module K = Kotlin_syntax

let types = Kotlin_sdk.Types.types_package

let member (e : Table.entry) =
  let name = Kotlin_sdk.Names.camel_constant e.name and about = K.Doc e.docs in
  let const type_ value =
    K.property ~about ~const:true ~type_:(K.Type type_)
      ~value:(K.Same_line value) name
  in
  match e.value with
  | Text s -> const "String" (K.Str s)
  | Integer { value; _ } -> const "Long" (K.Int value)
  | Boolean b -> const "Boolean" (K.Bool b)
  | Member { enum; value } ->
      K.property ~about ~type_:(K.Type enum)
        ~value:
          (K.Same_line
             (K.Member (K.Name enum, Kotlin_sdk.Names.variant_of value)))
        name
  | Read { schema; json; _ } ->
      K.property ~about ~type_:(K.Type schema)
        ~value:
          (K.Below
             (K.call ~layout:K.Lines
                (K.Member (K.Name "wireJson", "decodeFromString"))
                [
                  K.call (K.Name (schema ^ ".serializer")) [];
                  K.Str (Yojson.Safe.to_string json);
                ]))
        name

let file (t : Table.t) =
  let t = Table.written ~language:"Kotlin" ~lacks:[] t in
  let named =
    List.sort_uniq String.compare
      (List.filter_map
         (fun (e : Table.entry) ->
           match e.value with
           | Member { enum; _ } -> Some enum
           | Read { schema; _ } -> Some schema
           | Text _ | Integer _ | Boolean _ -> None)
         t)
  in
  let reads =
    List.exists
      (fun (e : Table.entry) ->
        match e.value with Read _ -> true | _ -> false)
      t
  in
  Kotlin_sdk.table ~from_:Table.file __FILE__ ~package:"xynolog"
    ~name:"OptionDefaults"
    ~imports:
      (List.map (fun n -> types ^ "." ^ n) named
      @ if reads then [ types ^ ".wireJson" ] else [])
    [
      K.class_
        ~about:
          (K.Doc
             ("What a public option of the client is when its caller leaves it \
               out, where the client decides it (protocol/specs/src/"
            ^ Table.file ^ ")."))
        ~visibility:K.Internal ~members:(List.map member t) K.Object
        "OptionDefaults";
    ]
