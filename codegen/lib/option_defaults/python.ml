(* The option defaults as the Python SDK reads them
   (python/sdk/src/xynolog/_option_defaults.py): a constant per row under its
   name in upper case, a value of an enumeration typed as it, and a value of a
   named schema read from its JSON by the schema's model. *)

module P = Python_syntax

let path = "python/sdk/src/xynolog/_option_defaults.py"
let final t = P.sub "Final" [ P.item (P.Name t) ]

let constant (e : Table.entry) =
  let annotation, value =
    match e.value with
    | Text s -> (P.Name "Final", P.Str s)
    | Integer { value; _ } -> (P.Name "Final", P.Int value)
    | Boolean b -> (P.Name "Final", P.Name (if b then "True" else "False"))
    | Member { enum; value } -> (final enum, P.Str value)
    | Read { schema; json } ->
        ( P.Name "Final",
          P.call
            (schema ^ ".model_validate_json")
            [ P.item (P.Str (Yojson.Safe.to_string json)) ] )
  in
  P.assign ~annotation ~value ~doc:(P.Wrapped e.docs) (Text.upper_snake e.name)

let file (t : Table.t) =
  let t = Table.written ~language:"Python" ~lacks:[] t in
  let types =
    List.sort_uniq String.compare
      (List.filter_map
         (fun (e : Table.entry) ->
           match e.value with
           | Member { enum; _ } -> Some enum
           | Read { schema; _ } -> Some schema
           | Text _ | Integer _ | Boolean _ -> None)
         t)
  in
  {
    Output.path;
    text =
      P.text
        {
          header =
            Banner.python_lines
              ~from_:("protocol/specs/src/" ^ Table.file)
              __FILE__;
          doc =
            As_is
              "What a public option of the client is when its caller leaves it \
               out, where the client decides it.";
          imports =
            [
              [ P.From ("typing", [ "Final" ]) ];
              [ P.From ("xynolog.types", types) ];
            ];
          body =
            P.assign "__all__"
              ~value:
                (P.List
                   (P.items ~magic:true
                      (List.map
                         (fun (e : Table.entry) ->
                           P.item (P.Str (Text.upper_snake e.name)))
                         t)))
            :: List.map constant t;
        };
  }
