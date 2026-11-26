(* Every schema the Haskell SDK's models type, by name: the gateway's
   component schemas, each carried table's own ([Carried_tables]), and the
   schemas the SDK derives beside them. A component is named by its file. Beside them are the form a resource's
   upload states its metadata in (ResourceUpload without its file), the trace
   carrier, the records of the client registry, of the state units' notices
   and of how a session ends, the stored sign-in, session and resources, an
   engine with its limits, what an HTTP operation states in place, and each bus
   envelope. None may take a component's name. *)

let ( let* ) = Result.bind

module Named = Map.Make (String)

let each f xs =
  Result.map List.rev
    (List.fold_left
       (fun found x ->
         let* found = found in
         let* y = f x in
         Ok (y :: found))
       (Ok []) xs)

exception Unresolved of string

(* [schema] as the models name it: a reference by what it names, rewritten by
   [rewrite] if that names it otherwise. A reference to a place within a file
   that [rewrite] leaves as it is keeps where the place is, which the models
   name once ([Schema_names.referred_places]). *)
let canonical ~rewrite : Schema.t -> Schema.t =
  Schema.cata
    ~boolean:(fun b -> Schema.Boolean_schema b)
    ~schema:(fun s ->
      Schema.Schema
        {
          s with
          ref_ =
            Option.map
              (fun (r : Decode.reference) ->
                let target = rewrite r in
                if r.pointer <> "" && target = r.target then r
                else { Decode.target; file = ""; pointer = "" })
              s.ref_;
          examples = Option.map (List.map Yojson.Safe.sort) s.examples;
        })

let stem file = Filename.remove_extension (Filename.basename file)
let unchanged (r : Decode.reference) = r.target

(* A reference names the schema of its file's base name. *)
let referenced (r : Decode.reference) = stem r.target

let layer name = function
  | Schema.Schema s -> Ok s
  | Boolean_schema _ -> Error (name ^ " is no schema object")

let property name key (s : Schema.schema) =
  match Option.bind s.properties (List.assoc_opt key) with
  | Some p -> Ok p
  | None -> Error (name ^ " has no property " ^ key)

let without_properties keys (s : Schema.schema) =
  {
    s with
    properties =
      Option.map
        (List.filter (fun (k, _) -> not (List.mem k keys)))
        s.properties;
  }

(* The roots ([Roots]), each the schema of the file its reference
   names, with each file it refers to that no generation names written in its
   place ([Schema_names.in_place]): as the models type it
   ([Normalize.shape_only]), and as the SDK validates a value against it, each
   place of several types the [anyOf] of each
   ([Normalize.several_types_throughout]). *)
let components (spec : Spec.t) =
  let typed_in_place = Schema_names.in_place spec ~places:false in
  let in_place = Schema_names.in_place spec ~places:true in
  let rooted name s =
    let validated = Normalize.several_types_throughout s in
    let* typed = typed_in_place (Normalize.shape_only validated) in
    let* validated = in_place validated in
    Ok (name, (typed, validated))
  in
  let* roots =
    each
      (fun (name, (r : Decode.reference)) ->
        let file, fragment = Decode.resolve spec.Spec.ids r in
        if
          fragment <> ""
          || Filename.extension file <> ".json"
          || stem file <> name
        then
          Error
            ("OpenAPI schema reference needs an explicit Haskell naming rule: "
           ^ name)
        else
          match List.assoc_opt file spec.schemas with
          | Some s -> rooted name s
          | None -> Error ("no schema file " ^ file))
      (Roots.all spec)
  in
  let* tables = Carried_tables.schemas spec in
  let* tables = each (fun (name, s) -> rooted name s) tables in
  Ok (roots @ tables)

(* A table's record that a reference into the table names is named by its
   title. *)
let titled ids records (r : Decode.reference) =
  if snd (Decode.resolve ids r) = "" then r.target
  else
    let key = Table_records.key ids r in
    match List.find_opt (fun (k, _, _) -> k = key) records with
    | Some (_, title, _) -> title ^ ".json"
    | None ->
        raise (Unresolved ("reference into a table not read: " ^ r.target))

let derive (spec : Spec.t) ~adapters ~carrier ~http ~envelopes =
  let* roots = components spec in
  let components = List.map (fun (name, (typed, _)) -> (name, typed)) roots in
  (* What is derived from a root's shape is validated as that shape: a root
     whose shape drops what its validator reads ([Normalize.dropped]) is
     refused. *)
  let shaped name =
    match List.assoc_opt name roots with
    | Some (_, validated) -> (
        match Normalize.dropped validated with
        | [] -> Ok ()
        | keyword :: _ ->
            Error
              (name ^ " states " ^ keyword
             ^ ", which what is derived from its shape drops"))
    | None -> Error (name ^ " schema missing")
  in
  let* () = shaped "ResourceUpload" in
  let component name =
    match List.assoc_opt name components with
    | Some s -> Ok s
    | None -> Error (name ^ " schema missing")
  in
  let* upload =
    Result.bind (component "ResourceUpload") (layer "ResourceUpload")
  in
  let* _ = property "ResourceUpload" "file" upload in
  let* required =
    Option.to_result ~none:"ResourceUpload has no required list" upload.required
  in
  let metadata =
    Schema.Schema
      {
        (without_properties [ "file" ] upload) with
        required = Some (List.filter (( <> ) "file") required);
      }
  in
  let* table_records = Table_records.all spec in
  let* records =
    match
      List.map
        (fun (_, title, s) ->
          (title, canonical ~rewrite:(titled spec.ids table_records) s))
        table_records
    with
    | records -> Ok records
    | exception Unresolved message -> Error message
  in
  let adapter_names = List.map fst adapters @ List.map fst records in
  let* () =
    if
      List.length (List.sort_uniq String.compare adapter_names)
      <> List.length adapter_names
    then Error "an SDK-owned adapter and a record of the spec share a name"
    else Ok ()
  in
  let* sign_in =
    Option.to_result ~none:"SignIn schema missing"
      (List.assoc_opt Roots.sign_in_entry spec.schemas)
  in
  let stored =
    List.sort (fun (a, _) (b, _) -> String.compare a b) (adapters @ records)
    @ [ ("SignIn", sign_in) ]
  in
  let derived =
    [ ("ResourceUploadMetadata", metadata); ("TraceCarrier", carrier) ]
    @ stored @ http @ envelopes
  in
  let* () =
    match List.find_opt (fun (n, _) -> List.mem_assoc n components) derived with
    | Some (n, _) -> Error ("adapter schema name is owned by OpenAPI: " ^ n)
    | None -> Ok ()
  in
  let all = components @ derived in
  let names = List.map fst all in
  let* () =
    if List.length (List.sort_uniq String.compare names) <> List.length names
    then Error "two schemas the models type share a name"
    else Ok ()
  in
  let canonical_each =
    List.map (fun (n, s) -> (n, canonical ~rewrite:unchanged s))
  in
  Ok
    ( List.sort (fun (a, _) (b, _) -> String.compare a b) (canonical_each all),
      canonical_each
        (List.map (fun (name, (_, validated)) -> (name, validated)) roots) )
