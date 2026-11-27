(* The option defaults as the Swift SDK reads them
   (swift/sdk/Sources/Xynolog/Generated/OptionDefaults.swift): in the enum
   OptionDefaults a constant per row under its name, a value of an
   enumeration its case. They are public, as a public function's default
   argument must be. *)

module S = Swift_syntax

let path = "swift/sdk/Sources/Xynolog/Generated/OptionDefaults.swift"

(* The SDK's TestSessionOptions takes the knowledge base as a parameter every
   caller states. *)
let lacks =
  [
    ( "testingCreateTestSessionKb",
      "TestSessionOptions' kb is a parameter every caller states" );
  ]

let constant (e : Table.entry) =
  let type_, value =
    match e.value with
    | Text s -> ("String", S.String s)
    | Integer { value; _ } -> ("Int", S.Int value)
    | Boolean b -> ("Bool", S.Bool b)
    | Member { enum; value } ->
        (enum, S.Implicit_member (Swift_sdk.Models.enum_case value))
    | Read { schema; _ } ->
        Definitions.refuse
          "%s: Swift writes no value of %s, which %s holds; name the row in \
           lacks with why"
          Table.file schema e.name
  in
  {
    S.doc = [ e.docs ];
    modifiers = [ "public"; "static" ];
    body =
      S.Property
        {
          var = false;
          name = e.name;
          type_ = Some (S.Named type_);
          value = Some value;
        };
  }

let file (t : Table.t) =
  let t = Table.written ~language:"Swift" ~lacks t in
  {
    Output.path;
    text =
      S.print
        {
          banner =
            Banner.lines ~from_:("protocol/specs/src/" ^ Table.file) __FILE__;
          imports = [ { S.module_ = "Foundation"; testable = false } ];
          decls =
            [
              ( S.Blank,
                {
                  S.doc =
                    [
                      "What a public option of the client is when its caller \
                       leaves it out, where the client decides it.";
                    ];
                  modifiers = [ "public" ];
                  body =
                    S.Enum
                      {
                        name = "OptionDefaults";
                        inherits = [];
                        layout = S.Lines;
                        members = List.map constant t;
                      };
                } );
            ];
        };
  }
