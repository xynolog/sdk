(* Every schema the Haskell SDK's models type, by name: the gateway's
   component schemas, and the schemas the SDK derives beside them. A
   component is named by its file. Beside them are the form a resource's
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

(* [schema] as the models compare and name it: a reference by what it names,
   rewritten by [rewrite] if that names it otherwise, and members in order of
   name. *)
let canonical ~rewrite : Schema.t -> Schema.t =
  Schema.cata
    ~boolean:(fun b -> Schema.Boolean_schema b)
    ~schema:(fun s ->
      Schema.Schema
        {
          s with
          ref_ =
            Option.map
              (fun r -> { Decode.target = rewrite r; file = ""; pointer = "" })
              s.ref_;
          properties =
            Option.map
              (List.sort (fun (a, _) (b, _) -> String.compare a b))
              s.properties;
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

let reference name =
  Schema.Schema
    {
      Schema.empty with
      ref_ = Some { Decode.target = name ^ ".json"; file = ""; pointer = "" };
    }

let with_property key schema (s : Schema.schema) =
  {
    s with
    properties =
      Some
        (List.map
           (fun (k, v) -> if k = key then (k, schema) else (k, v))
           (Option.value s.properties ~default:[])
        @
        if List.mem_assoc key (Option.value s.properties ~default:[]) then []
        else [ (key, schema) ]);
  }

let payload_types = "typescript/core/src/payload-types.ts"

let squeeze text =
  String.concat ""
    (List.map (String.make 1)
       (List.filter
          (fun c -> not (List.mem c [ ' '; '\n'; '\r'; '\t' ]))
          (List.of_seq (String.to_seq text))))

(* The roots ([Roots]), each the schema of the file its reference
   names, with each file it refers to that no generation names written in its
   place ([Schema_names.in_place]): as the models type it
   ([Normalize.shape_only]), and as the SDK validates a value against it, each
   place of several types the [anyOf] of each
   ([Normalize.several_types_throughout]). *)
let components (spec : Spec.t) =
  let in_place = Schema_names.in_place spec in
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
        | Some s ->
            let validated = Normalize.several_types_throughout s in
            let* typed = in_place (Normalize.shape_only validated) in
            let* validated = in_place validated in
            Ok (name, (typed, validated))
        | None -> Error ("no schema file " ^ file))
    (Roots.all spec)

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

let derive ~root (spec : Spec.t) ~adapters ~carrier ~http ~envelopes =
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
            Error (name ^ " states " ^ keyword ^ ", which what is derived from its shape drops"))
    | None -> Error (name ^ " schema missing")
  in
  let* () = shaped "ResourceUpload" in
  let* () = shaped "EngineEntry" in
  let component name =
    match List.assoc_opt name components with
    | Some s -> Ok s
    | None -> Error (name ^ " schema missing")
  in
  let normalize s =
    Normalize.normalize spec.Spec.ids
      ~find:(fun r ->
        match List.assoc_opt (referenced r) components with
        | Some s -> Ok s
        | None -> Error ("unknown schema reference: " ^ r.target))
      (canonical ~rewrite:unchanged s)
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
  let* () =
    if
      Marker.find
        "exporttypeEngineWithLimits=EngineEntry&{limits?:components['schemas']['InferenceLimits'];};"
        (squeeze (Marker.read ~root payload_types))
      = None
    then Error "EngineWithLimits changed: update its derived Haskell adapter"
    else Ok ()
  in
  let* engine = Result.bind (component "EngineEntry") normalize in
  let* () =
    if engine.properties = None then Error "EngineEntry properties missing"
    else Ok ()
  in
  let options =
    [
      ( "EngineWithLimits",
        Schema.Schema
          (with_property "limits" (reference "InferenceLimits") engine) );
    ]
  in
  let tables = spec.tables in
  (* A table's record, the schema it names when it names one by its [$id]. *)
  let held key s = Result.map snd (Table_records.stated spec (key, s)) in
  let* told_schema =
    held "session/cases.json#/told" tables.session_cases.told
  in
  let* told_title =
    match told_schema with
    | Schema { title = Some t; _ } -> Ok t
    | _ -> Error "session end reasons have no title"
  in
  let* pointed =
    List.fold_right
      (fun (n, s) pointed ->
        let* pointed = pointed in
        let* s = held n s in
        Ok ((n, s) :: pointed))
      (tables.client_registry.types @ tables.client_state_units.notices)
      (Ok [])
  in
  let told = (told_title, told_schema) in
  let adapter_names =
    List.map fst adapters @ List.map fst pointed @ [ fst told ]
  in
  let* () =
    if
      List.length (List.sort_uniq String.compare adapter_names)
      <> List.length adapter_names
    then Error "an SDK-owned adapter and a record of the spec share a name"
    else Ok ()
  in
  let* table_records = Table_records.all spec in
  let* records =
    match
      List.map
        (fun (n, s) ->
          (n, canonical ~rewrite:(titled spec.ids table_records) s))
        pointed
    with
    | records -> Ok (records @ [ told ])
    | exception Unresolved message -> Error message
  in
  let* pending =
    layer "pending authorization" tables.session_stored.pending_authorization
  in
  let* issuer = property "pending authorization" "issuer" pending in
  let* sign_in =
    Option.to_result ~none:"SignIn schema missing"
      (List.assoc_opt Roots.sign_in_entry spec.schemas)
  in
  let* stored_session =
    held "session/stored.json#/storedSession"
      tables.session_stored.stored_session
  in
  let stored =
    List.sort (fun (a, _) (b, _) -> String.compare a b) (adapters @ records)
    @ [
        ("SignIn", sign_in);
        ("StoredSession", stored_session);
        ("IssuerEndpoints", issuer);
        ( "PendingAuthorization",
          Schema.Schema
            (with_property "issuer" (reference "IssuerEndpoints") pending) );
      ]
  in
  let derived =
    [ ("ResourceUploadMetadata", metadata); ("TraceCarrier", carrier) ]
    @ stored @ options @ http @ envelopes
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
