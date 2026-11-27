(* The option defaults as the TypeScript SDK reads them
   (typescript/sdk/src/option-defaults.ts): a constant per row under its name
   in upper case, a value of a named schema typed as that schema. *)

module T = Typescript_syntax

let path = "typescript/sdk/src/option-defaults.ts"

let constant (e : Table.entry) =
  let about = [ T.Doc e.docs ] and name = Text.upper_snake e.name in
  match e.value with
  | Text s -> T.const ~about name (T.Str s)
  | Integer { value; _ } -> T.const ~about name (T.Int value)
  | Boolean b -> T.const ~about name (T.Bool b)
  | Member { value; _ } -> T.const ~about name (T.Str value)
  | Read { schema; json } ->
      T.const ~about ~annotation:(T.T_name schema) name (T.Json_rows json)

let file (t : Table.t) =
  let t = Table.written ~language:"TypeScript" ~lacks:[] t in
  let schemas =
    List.sort_uniq String.compare
      (List.filter_map
         (fun (e : Table.entry) ->
           match e.value with Read { schema; _ } -> Some schema | _ -> None)
         t)
  in
  {
    Output.path;
    text =
      T.text
        {
          banner =
            Banner.typescript_lines
              ~authority:[ "protocol/specs/src/" ^ Table.file ]
              __FILE__;
          body =
            (match schemas with
              | [] -> []
              | names -> [ T.import ~type_only:true names "@xynolog/core" ])
            @ List.map constant t;
        };
  }
