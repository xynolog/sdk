(* The table as the TypeScript SDK's reply checks read it
   (typescript/core/src/required.ts). It is typed by the schemas the
   typescript-types group writes (src/types.ts), so one it leaves out, or a
   name that is no schema, fails to compile. *)

module T = Typescript_syntax

let path = "typescript/core/src/required-schemas.ts"

let text (shapes : (string * Shape.shape) list) =
  T.text
    {
      banner =
        Banner.typescript_lines ~authority:[ Table.authority ]
          ~notes:[ "The rules:   codegen/lib/required/shape.ml" ]
          __FILE__;
      body =
        [
          T.Adjacent
            [
              T.import ~type_only:true [ "Shape" ] "./required";
              T.import ~type_only:true [ "components"; "records" ] "./types";
            ];
          T.const "REQUIRED_SCHEMAS"
            ~about:
              [
                Doc
                  "What each schema and each table record requires of a value, \
                   by its name.";
              ]
            ~annotation:
              (T_mapped
                 {
                   layout = Inline;
                   readonly = true;
                   key = "Name";
                   in_ =
                     T_union
                       [
                         T_keyof
                           (T_index (T_name "components", T_str "schemas"));
                         T_keyof (T_name "records");
                       ];
                   value = T_name "Shape";
                 })
            (T.rows
               (List.map
                  (fun (name, shape) ->
                    T.entry (Quoted name)
                      (Json (Shape.to_json ~pairs:false shape)))
                  shapes));
        ];
    }

let file shapes = { Output.path; text = text shapes }
