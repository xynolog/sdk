(* The option defaults as the Go SDK reads them: an unexported constant per
   row under its name, in package xynolog (go/option_defaults_gen.go), and a
   row of the testing kit's in package xynologtest
   (go/xynologtest/option_defaults_gen.go), which the kit reads. A value of
   an enumeration is package api's constant of it, and a value of a named
   schema the JSON it is, which the kit reads as package api's type of it. *)

module G = Go_syntax

let validate = "keptSignInSessionFromKeptValidate"

(* Go's SessionFromKeptConfig takes the default as its zero value:
   SkipAskingWhoTokenIs left false asks who the token is. That holds only
   while the table's default is to ask. *)
let lacks =
  [
    ( validate,
      "SessionFromKeptConfig.SkipAskingWhoTokenIs states it as its zero value"
    );
  ]

let header =
  G.verbatim
    ("Code generated from protocol/specs/src/" ^ Table.file
   ^ "; DO NOT EDIT.\n\nRegenerate: make generate (" ^ Banner.writer __FILE__
   ^ ")")

let constant (e : Table.entry) =
  let doc =
    G.prose
      (Printf.sprintf "%s is %s" e.name (String.uncapitalize_ascii e.docs))
  in
  G.Const
    (G.spec ~doc e.name
       (match e.value with
       | Text s -> G.Quoted s
       | Integer { value; _ } -> G.Int value
       | Boolean b -> G.Name (string_of_bool b)
       | Member { enum; value } -> G.Name ("api." ^ enum ^ Naming.variant value)
       | Read { json; _ } -> G.Quoted (Yojson.Safe.to_string json)))

let uses_api =
  List.exists (fun (e : Table.entry) ->
      match e.value with Member _ -> true | _ -> false)

let file ~path ~package entries =
  {
    Output.path;
    text =
      G.text
        {
          header;
          package;
          imports =
            (if uses_api entries then [ [ "github.com/xynolog/sdk/go/api" ] ]
             else []);
          decls = List.map constant entries;
        };
  }

let files (t : Table.t) =
  (match Table.value_named validate t with
  | Boolean true -> ()
  | _ ->
      Definitions.refuse
        "%s: %s is no longer true, and Go states it as a zero value that asks"
        Table.file validate);
  let t = Table.written ~language:"Go" ~lacks t in
  let kit, sdk = List.partition (fun e -> Table.owner e = "testing") t in
  [
    file ~path:"go/option_defaults_gen.go" ~package:"xynolog" sdk;
    file ~path:"go/xynologtest/option_defaults_gen.go" ~package:"xynologtest"
      kit;
  ]
