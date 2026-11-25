(* Protocol's spec as the generators read it: each schema file's schema
   without the [$schema] and [$id] that identify the file. A generator reads
   what a schema admits, and which file a reference names is [Spec.t]'s
   [ids] to say; so no generator sees identification, and none merges one
   schema's [$id] into another ([Normalize]). *)

let shape : Schema.t -> Schema.t = function
  | Schema.Schema s -> Schema.Schema { s with schema = None; id = None }
  | Boolean_schema _ as b -> b

(* Each member of an object in [schema], written in [file], that the object
   does not require and that may be null ([Null_form]). Absent and null
   would be two things for it, which Go's and Python's types cannot tell
   apart, so every SDK reads a member as absent or a value, and the spec
   states none such. *)
let optional_nullable file schema =
  let ( / ) pointer token = pointer ^ "/" ^ Decode.escape token in
  let rec walk pointer = function
    | Schema.Boolean_schema _ -> []
    | Schema.Schema (l : Schema.schema) ->
        let required = Option.value ~default:[] l.required in
        let member (name, property) =
          let at = pointer / "properties" / name in
          let refused =
            match property with
            | Schema.Schema p when not (List.mem name required) -> (
                match Null_form.without_null Fun.id p with
                | Ok (Some _) ->
                    [
                      {
                        Decode.file;
                        pointer = at;
                        message =
                          "a member that is optional may not be null: absent \
                           and null would be two things for it";
                      };
                    ]
                | Ok None | Error _ -> [])
            | Schema.Schema _ | Boolean_schema _ -> []
          in
          refused @ walk at property
        in
        let one key = Option.fold ~none:[] ~some:(walk (pointer / key)) in
        let each key =
          Option.fold ~none:[] ~some:(fun schemas ->
              List.concat
                (List.mapi
                   (fun i s -> walk (pointer / key / string_of_int i) s)
                   schemas))
        in
        let named key =
          Option.fold ~none:[] ~some:(fun schemas ->
              List.concat_map
                (fun (name, s) -> walk (pointer / key / name) s)
                schemas)
        in
        List.concat
          [
            List.concat_map member (Option.value ~default:[] l.properties);
            one "additionalProperties" l.additional_properties;
            one "unevaluatedProperties" l.unevaluated_properties;
            one "propertyNames" l.property_names;
            one "items" l.items;
            each "allOf" l.all_of;
            each "anyOf" l.any_of;
            each "oneOf" l.one_of;
            one "not" l.not_;
            named "$defs" l.defs;
          ]
  in
  walk "" schema

let load specs =
  match Spec.load specs with
  | Error _ as refused -> refused
  | Ok spec -> (
      let schemas = List.map (fun (file, s) -> (file, shape s)) spec.schemas in
      match
        List.concat_map (fun (file, s) -> optional_nullable file s) schemas
      with
      | [] -> Ok { spec with schemas }
      | refused -> Error refused)
