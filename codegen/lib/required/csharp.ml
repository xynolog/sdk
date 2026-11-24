(* The table as the C# SDK holds it, Xynolog.Serialization's Required.Table:
   what each component schema requires, and what each payload type the bus
   registry makes requires beside them (Bus.Csharp), as one JSON text. *)

module C = Csharp_syntax

let path = "csharp/sdk/src/Xynolog/Generated/RequiredSchemas.g.cs"

(* The made payloads' shapes, each derived as a component's is; a payload
   named as a component is refused. *)
let made (derivation : Shape.t) (reg : Tables.Bus_registry.t) =
  List.map
    (fun payload ->
      let ( let* ) = Result.bind in
      let* name, _, schema = payload in
      let file = "bus/registry.json" in
      if List.mem_assoc name derivation.shapes then
        Error
          {
            Decode.file;
            pointer = "/channels";
            message =
              Printf.sprintf
                "makes the payload type %s, which a component schema is named"
                name;
          }
      else
        Result.map
          (fun shape -> (name, shape))
          (derivation.inline
             ~file:("components/schemas/" ^ name ^ ".json")
             ~pointer:"" schema))
    (Bus.Csharp.payloads reg)

let collect results =
  match
    List.filter_map (function Error e -> Some e | Ok _ -> None) results
  with
  | [] -> Ok (List.filter_map Result.to_option results)
  | errors -> Error errors

let text shapes =
  Yojson.Safe.to_string
    (`Assoc
       [
         ("$comment", `String Table.comment);
         ( "schemas",
           `Assoc
             (List.map
                (fun (name, shape) -> (name, Shape.to_json ~pairs:false shape))
                shapes) );
       ])

let file (derivation : Shape.t) (reg : Tables.Bus_registry.t) =
  Result.map
    (fun made ->
      {
        Output.path;
        text =
          C.text
            {
              header = Banner.lines ~from_:Table.authority __FILE__;
              nullable = false;
              usings = [];
              namespace = "Xynolog.Serialization";
              decls =
                [
                  C.Type
                    {
                      attributes = [];
                      modifiers = [ Internal; Static; Partial ];
                      kind = Class;
                      name = "Required";
                      params = None;
                      base = None;
                      body =
                        Some
                          ( Packed,
                            [
                              C.Field
                                {
                                  modifiers = [ Private; Const ];
                                  type_ = T "string";
                                  name = "Table";
                                  value =
                                    Some (Str (text (derivation.shapes @ made)));
                                };
                            ] );
                    };
                ];
            };
      })
    (collect (made derivation reg))
