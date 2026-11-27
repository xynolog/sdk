(* The option defaults as the OCaml SDK reads them
   (ocaml/sdk/lib/option_defaults.ml): a value per row under its name in snake
   case. The SDK's namespaces take a request's payload whole, so a value of an
   enumeration is the text the payload carries; the gather state unit's
   optional arguments default to these, and so do the payloads the surface
   test builds for a case that leaves an option out. *)

module O = Ocaml_syntax

let banner = Banner.ocaml ~from_:("protocol/specs/src/" ^ Table.file) __FILE__
let name (e : Table.entry) = Text.snake e.name

(* What the SDK has in place of these, which states no default. *)
let lacks =
  [
    ( "keptSignInSessionFromKeptValidate",
      "the SDK opens a kept session with Registry.start_kept_session, which \
       takes no validate" );
    ( "testingCreateTestSessionKb",
      "test_session_options' kb is a field every caller states" );
  ]

let value (e : Table.entry) =
  match e.value with
  | Text s | Member { value = s; _ } -> (O.type_ "string", O.string s)
  | Integer { value; _ } -> (O.type_ "int", O.int value)
  | Boolean b -> (O.type_ "bool", O.bool b)
  | Read { schema; _ } ->
      Definitions.refuse
        "%s: OCaml writes no value of %s, which %s holds; name the row in \
         lacks with why"
        Table.file schema e.name

let files (t : Table.t) =
  let t = Table.written ~language:"OCaml" ~lacks t in
  [
    O.implementation ~path:"ocaml/sdk/lib/option_defaults.ml" ~banner
      (List.map (fun e -> O.let_ (name e) (snd (value e))) t);
    O.interface ~path:"ocaml/sdk/lib/option_defaults.mli" ~banner
      (List.map (fun e -> O.val_ (name e) (fst (value e))) t);
  ]
