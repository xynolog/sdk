(* Each kind of id as a C# value of its own, in Xynolog.Identifiers: text
   no code can make but through Parse or TryParse, which hold it to the
   kind's rule. .NET reads [\s] with NEL and without the BOM, where the
   spec's patterns are ECMAScript's, which read it the other way about; so
   [\S] admits NEL, and a rule that reads it refuses a BOM. *)

module C = Csharp_syntax

let directory = "csharp/sdk/src/Xynolog/Generated/Identifiers"
let regex name = "global::System.Text.RegularExpressions." ^ name

(* [text] with each [from] replaced by [by]. *)
let replaced ~from ~by text =
  let n = String.length from in
  let b = Buffer.create (String.length text) in
  let rec go i =
    if i > String.length text - n then
      Buffer.add_string b (String.sub text i (String.length text - i))
    else if String.sub text i n = from then (
      Buffer.add_string b by;
      go (i + n))
    else (
      Buffer.add_char b text.[i];
      go (i + 1))
  in
  go 0;
  Buffer.contents b

let reads_white_space (kind : Table.kind) =
  replaced ~from:"\\S" ~by:"" kind.whole <> kind.whole

(* Whether [text] is an id of [kind]. *)
let admits (kind : Table.kind) =
  let matches =
    C.Call
      ( Name (regex "Regex.IsMatch"),
        [],
        [
          Arg (Name "text");
          Arg
            (Str
               ("\\A"
               ^ replaced ~from:"\\S" ~by:"(?:\\S|\\u0085)" kind.whole
               ^ "\\z"));
          Arg (Name (regex "RegexOptions.CultureInvariant"));
        ] )
  in
  let checked = C.Binary (Is_not_null (Name "text"), And, matches) in
  if reads_white_space kind then
    C.Binary
      ( checked,
        And,
        C.Binary
          ( C.Call (Member (Name "text", "IndexOf"), [], [ Arg (Char 0xFEFF) ]),
            Lt,
            Int 0 ) )
  else checked

let refused name = C.Str ("The value is not a " ^ name ^ ".")

let value_type (kind : Table.kind) =
  let name = kind.name in
  let t = C.T name in
  let text = C.T "string" in
  C.Type
    {
      attributes = [ Csharp_converter.attribute name ];
      modifiers = [ Public; Readonly ];
      kind = Record_struct;
      name;
      params = None;
      base = None;
      body =
        Some
          ( Spaced,
            [
              C.Field
                {
                  modifiers = [ Private; Readonly ];
                  type_ = Nullable text;
                  name = "value";
                  value = None;
                };
              C.Constructor
                {
                  modifiers = [ Private ];
                  name;
                  params = [ { by = `Value; type_ = text; name = "value" } ];
                  body = Arrow (Assign (Member (This, "value"), Name "value"));
                };
              C.Expression_property
                {
                  attributes = [];
                  modifiers = [ Public ];
                  type_ = text;
                  name = "Value";
                  value =
                    Coalesce
                      ( Name "value",
                        Throw
                          (New
                             {
                               type_ =
                                 Some
                                   (T "global::System.InvalidOperationException");
                               args =
                                 Some
                                   [
                                     Arg
                                       (Str
                                          ("An uninitialized " ^ name
                                         ^ " has no value."));
                                   ];
                               init = None;
                             }) );
                };
              C.Method
                {
                  modifiers = [ Public; Static ];
                  returns = t;
                  name = "Parse";
                  params = [ { by = `Value; type_ = text; name = "text" } ];
                  body =
                    Arrow
                      (Conditional_lines
                         ( Call
                             ( Name "TryParse",
                               [],
                               [ Arg (Name "text"); Out_var "parsed" ] ),
                           Name "parsed",
                           Throw
                             (New
                                {
                                  type_ =
                                    Some (T "global::System.FormatException");
                                  args = Some [ Arg (refused name) ];
                                  init = None;
                                }) ));
                };
              C.Method
                {
                  modifiers = [ Public; Static ];
                  returns = T "bool";
                  name = "TryParse";
                  params =
                    [
                      { by = `Value; type_ = Nullable text; name = "text" };
                      { by = `Out; type_ = t; name = "parsed" };
                    ];
                  body =
                    Block
                      [
                        If
                          ( admits kind,
                            [
                              Set
                                ( Name "parsed",
                                  New
                                    {
                                      type_ = Some t;
                                      args = Some [ Arg (Name "text") ];
                                      init = None;
                                    } );
                              Return (Bool true);
                            ] );
                        Set (Name "parsed", Default);
                        Return (Bool false);
                      ];
                };
              C.Method
                {
                  modifiers = [ Public; Override ];
                  returns = text;
                  name = "ToString";
                  params = [];
                  body = Arrow (Name "Value");
                };
            ] );
    }

let json = Csharp_converter.json

let converter (kind : Table.kind) =
  let name = kind.name in
  let parsed : C.expr =
    Call
      ( Name (name ^ ".TryParse"),
        [],
        [
          Arg (Call (Member (Name "reader", "GetString"), [], []));
          Out_var "parsed";
        ] )
  in
  let refusal : C.stmt =
    Throw_stmt
      (New
         {
           type_ = Some (T (json "JsonException"));
           args = Some [ Arg (refused name) ];
           init = None;
         })
  in
  let writes method_ : C.stmt list =
    [
      Try
        ( [
            Do
              (Call
                 ( Member (Name "writer", method_),
                   [],
                   [ Arg (Member (Name "value", "Value")) ] ));
          ],
          ( T "global::System.InvalidOperationException",
            "error",
            [
              Throw_stmt
                (New
                   {
                     type_ = Some (T (json "JsonException"));
                     args =
                       Some
                         [
                           Arg (Member (Name "error", "Message"));
                           Arg (Name "error");
                         ];
                     init = None;
                   });
            ] ) );
    ]
  in
  Csharp_converter.converter name
    ~read:
      [
        If
          ( Binary
              ( Binary
                  ( Member (Name "reader", "TokenType"),
                    Eq,
                    Name (json "JsonTokenType.String") ),
                And,
                parsed ),
            [ Return (Name "parsed") ] );
        refusal;
      ]
    ~write:(writes "WriteStringValue")
    ~read_key:[ If (parsed, [ Return (Name "parsed") ]); refusal ]
    ~write_key:(writes "WritePropertyName")

let files kinds =
  List.map
    (fun (kind : Table.kind) ->
      {
        Output.path = directory ^ "/" ^ kind.name ^ ".g.cs";
        text =
          C.text
            {
              header =
                Banner.lines
                  ~from_:
                    ("protocol/specs/src/components/schemas/" ^ kind.name
                   ^ ".json")
                  __FILE__;
              nullable = true;
              usings = [];
              namespace = "Xynolog.Identifiers";
              decls = [ value_type kind; converter kind ];
            };
      })
    kinds
