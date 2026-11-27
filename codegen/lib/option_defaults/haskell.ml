(* The option defaults as the Haskell SDK reads them
   (generated/Xynolog/Internal/Generated/OptionDefaults.hs): a value per row
   under its name, an integer an Integer as the SDK's models hold one, and a
   value of an enumeration its constructor. *)

module H = Haskell_syntax

let name = "Xynolog.Internal.Generated.OptionDefaults"

(* What the SDK takes in place of these, which states no default. *)
let lacks =
  [
    ( "keptSignInSessionFromKeptValidate",
      "fromKeptSession takes the validation as SessionOptions' \
       sessionValidate, which the caller supplies" );
    ( "testingCreateTestSessionKb",
      "TestSessionOptions' session options, which hold the knowledge base, are \
       a field every caller states" );
  ]

let constant (e : Table.entry) =
  let type_, body =
    match e.value with
    | Text s -> ("Text", H.Str s)
    | Integer { value; _ } -> ("Integer", H.Int value)
    | Boolean b -> ("Bool", H.Name (if b then "True" else "False"))
    | Member { enum; value } -> (enum, H.Name (enum ^ Naming.variant value))
    | Read { schema; _ } ->
        Definitions.refuse
          "%s: Haskell writes no value of %s, which %s holds; name the row in \
           lacks with why"
          Table.file schema e.name
  in
  H.value ~about:[ e.docs ] e.name (H.T_name type_) body

let file (t : Table.t) =
  let t = Table.written ~language:"Haskell" ~lacks t in
  let enums =
    List.sort_uniq String.compare
      (List.filter_map
         (fun (e : Table.entry) ->
           match e.value with Member { enum; _ } -> Some enum | _ -> None)
         t)
  in
  H.file ~under:"generated"
    {
      H.banner =
        Banner.lines ~from_:("protocol/specs/src/" ^ Table.file) __FILE__;
      extensions = [ "OverloadedStrings" ];
      name;
      imports =
        [
          H.import "Data.Text" ~items:[ Plain "Text" ];
          H.import "Xynolog.Types" ~items:(List.map (fun n -> H.All n) enums);
        ];
      body = List.map constant t;
    }
