(* The table as the Python SDK's reading of a reply reads it
   (python/sdk/src/xynolog/required.py): JSON text, one schema to a line, which
   the SDK parses as it imports the module. *)

module P = Python_syntax

let path = "python/sdk/src/xynolog/_required_table.py"

let text (shapes : (string * Shape.shape) list) =
  let count = List.length shapes in
  let line i (name, shape) =
    Yojson.Safe.to_string (`String name)
    ^ ":"
    ^ Yojson.Safe.to_string (Shape.to_json ~pairs:false shape)
    ^ if i < count - 1 then "," else ""
  in
  P.text
    {
      header = Banner.python_lines ~from_:Table.authority __FILE__;
      doc =
        As_is
          "What each component schema requires of a value, by its name, as \
           JSON: codegen/lib/required/shape.ml states the rules.";
      imports = [ [ P.From ("typing", [ "Final" ]) ] ];
      body =
        [
          P.assign "__all__"
            ~value:(P.List (P.items [ P.item (P.Str "SCHEMAS") ]));
          P.assign "SCHEMAS" ~annotation:(P.Name "Final")
            ~value:(P.Joined (("{" :: List.mapi line shapes) @ [ "}" ]));
        ];
    }

let file shapes = { Output.path; text = text shapes }
