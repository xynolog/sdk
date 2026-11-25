(* A Haskell held job's members that are its record's
   (generated/Xynolog/Internal/Generated/HeldJob.hs): for each record, a
   class of what holds one, and a function per field of the record as the
   models declare it, reading it from what holds it, saying what the schema
   says of it. *)

module H = Haskell_syntax
module T = Typing
module Table = Held_job.Table

let ( let* ) = Result.bind
let name = "Xynolog.Internal.Generated.HeldJob"

(* The Haskell SDK's type of a handed. *)
let held = function "heldJob" -> Some "HeldJob" | _ -> None

(* The fields of the record [record] the models declare. *)
let fields (models : H.module_ list) record =
  match
    List.find_map
      (fun (m : H.module_) ->
        List.find_map
          (function
            | H.Record { name; fields; _ } when name = record -> Some fields
            | _ -> None)
          m.body)
      models
  with
  | Some fields -> Ok fields
  | None -> Error (record ^ ": the Haskell SDK models no record of it")

let each f xs =
  List.fold_right
    (fun x found ->
      let* found = found in
      let* y = f x in
      Ok (y :: found))
    xs (Ok [])

let decls (models : Models.t) (t : Table.t) =
  let* () =
    match held t.handed with
    | Some _ -> Ok ()
    | None -> Error (Table.refusal ~sdk:"Haskell" t)
  in
  let class_ = "Has" ^ t.record and holder = "held" in
  let read = Models.lower t.record in
  let* said =
    match (models.typing.find t.record).form with
    | T.Record { members; _ } ->
        Ok
          (List.map
             (fun (m : T.member) ->
               ( Models.field t.record m.wire,
                 (m.wire, Option.to_list m.description) ))
             members)
    | _ -> Error (t.record ^ " is no record")
  in
  let* fields = fields models.modules t.record in
  let* accessors =
    each
      (fun (field, type_) ->
        match List.assoc_opt field said with
        | Some (wire, about) ->
            Ok
              (H.value ~about
                 (String.uncapitalize_ascii (Text.pascal wire))
                 (H.T_constrained
                    ([ (class_, holder) ], H.T_fun (T_name holder, type_)))
                 (H.Compose (Name field, Name read)))
        | None ->
            Error
              (t.record ^ ": the Haskell SDK's field " ^ field
             ^ " is none of its members"))
      fields
  in
  Ok
    (H.Class
       {
         about = [ "What holds the " ^ t.record ^ " a claim hands it." ];
         name = class_;
         param = holder;
         methods = [ (read, H.T_fun (T_name holder, T_name t.record)) ];
       }
    :: accessors)

let module_ ~banner (spec : Spec.t) (models : Models.t) =
  let records = Table.all spec in
  let* body = each (decls models) records in
  let body = List.concat body in
  let used = H.uses body in
  let modelled =
    List.concat_map
      (fun (m : H.module_) ->
        List.filter_map
          (function H.All n | H.Plain n -> Some n | _ -> None)
          (List.concat_map H.exports m.body))
      models.modules
  in
  let record t = List.exists (fun (r : Table.t) -> r.record = t) records in
  let from_types =
    List.filter_map
      (fun t ->
        if record t then Some (H.All t)
        else if List.mem t modelled then Some (H.Plain t)
        else None)
      used.types
  in
  Ok
    {
      H.banner;
      extensions = [];
      name;
      imports =
        (if List.mem "Text" used.types then
           [ H.import "Data.Text" ~items:[ Plain "Text" ] ]
         else [])
        @ (if List.exists (String.starts_with ~prefix:"KM.") used.types then
             [ H.import "Data.Aeson.KeyMap" ~qualified:"KM" ]
           else [])
        @ [ H.import "Xynolog.Types" ~items:from_types ];
      body;
    }
