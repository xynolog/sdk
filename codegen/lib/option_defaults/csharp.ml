(* The option defaults as the C# SDK reads them
   (csharp/sdk/src/Xynolog/Generated/OptionDefaults.g.cs): in the static class
   Xynolog.Protocol.OptionDefaults a constant per row under its name in Pascal
   case, an integer a long as the SDK's types hold one, a value of an
   enumeration its member, and a value of a named schema a property read from
   its JSON by ProtocolTable, as the services' tables are. *)

module C = Csharp_syntax
module Sdk = Csharp_sdk

let path = Sdk.generated ^ "OptionDefaults.g.cs"

let member (e : Table.entry) =
  let name = Text.pascal e.name in
  C.Documented
    ( e.docs,
      match e.value with
      | Text s -> Sdk.constant "string" name (C.Str s)
      | Integer { value; _ } -> Sdk.constant "long" name (C.Int value)
      | Boolean b -> Sdk.constant "bool" name (C.Bool b)
      | Member { enum; value } ->
          Sdk.constant (Sdk.Models.types ^ enum) name
            (C.Member
               (C.Name (Sdk.Models.types ^ enum), Sdk.Models.enum_constant value))
      | Read { schema; json; _ } ->
          let type_ = C.T (Sdk.Models.types ^ schema) in
          C.Property
            {
              attributes = [];
              modifiers = [ Internal; Static ];
              type_;
              name;
              accessors = [ Get ];
              value =
                Some
                  (C.Call
                     ( Name "global::Xynolog.Protocol.ProtocolTable.Read",
                       [ type_ ],
                       [ Arg (Str (Yojson.Safe.to_string json)) ] ));
            } )

let file (t : Table.t) =
  let t = Table.written ~language:"C#" ~lacks:[] t in
  {
    Output.path;
    text =
      C.text
        {
          header =
            Banner.lines ~from_:("protocol/specs/src/" ^ Table.file) __FILE__;
          nullable = false;
          usings = [];
          namespace = "Xynolog.Protocol";
          decls = [ Sdk.static_class "OptionDefaults" (List.map member t) ];
        };
  }
