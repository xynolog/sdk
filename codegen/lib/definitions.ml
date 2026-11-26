(* The gateway's component schemas as the Rust and Swift types are generated
   from them: the document bundled (each file it names as a component, or that
   a directory of schemas holds, is a schema by its name, and any other file a
   [$ref] names is written in its place ([Schema_names]); a [$ref] has only a
   description beside it, which is what is said of it there),
   and a schema that may be null ([Null_form]) as the union of [Null] and what
   it is beside null, or, beside one [type], [Or_null]. A schema that
   states an [allOf] holds its
   parts, for the names a writer gives what they state, and what they merge
   to ([Normalize]), which describes it. *)

exception Refused of string

let refuse fmt = Printf.ksprintf (fun message -> raise (Refused message)) fmt

type types =
  | One of Schema.type_name
  | Or_null of Schema.type_name  (** [[T, "null"]] *)

type t =
  | Ref of { name : string; description : string option }
      (** A component schema, by its name, and what is said of it here. *)
  | Null  (** [{type: "null"}], a union's member that is null. *)
  | Bool of bool
  | Node of node

and node = {
  keys : string list;  (** The keywords it states, by their names. *)
  origin : origin option;
      (** The place within a file it is, when a [$ref] names that place
          ([Schema_names.referred_places]). *)
  title : string option;
  description : string option;
  type_ : types option;
  format : Schema.format option;
  enum : Schema.literal list option;
  properties : (string * t) list option;
  required : string list option;
  additional_properties : t option;
  max_properties : int option;
  minimum : float option;
  maximum : float option;
  items : t option;
  all_of : t list option;
  merged : t option;  (** What its [allOf] merges to, when it states one. *)
  any_of : t list option;
  one_of : t list option;
  discriminator : string option;  (** Its property's name. *)
  pattern : string option;
}

(* A place a [$ref] names, by its key ([Schema_names.place_key]): where it is
   stated, or written in the place of a [$ref] to it ([referred]). Each
   writer names it once, as it is where it is stated ([Typing]). *)
and origin = { key : string; referred : bool }

let node keys =
  {
    keys;
    origin = None;
    title = None;
    description = None;
    type_ = None;
    format = None;
    enum = None;
    properties = None;
    required = None;
    additional_properties = None;
    max_properties = None;
    minimum = None;
    maximum = None;
    items = None;
    all_of = None;
    merged = None;
    any_of = None;
    one_of = None;
    discriminator = None;
    pattern = None;
  }

(* A schema as what it means: one that states an [allOf], what its parts
   merge to. Whether it admits null is the schema's own: its merge is made
   from what it states beside its null. *)
let meant = function Node { merged = Some m; _ } -> m | s -> s

type definitions = {
  names : string list;
      (** Every schema a generation is rooted on ([Roots]), and every schema
          they reach, by its name. *)
  schema : string -> t;  (** A schema by its name; refused if there is none. *)
}

let stem file = Filename.remove_extension (Filename.basename file)

(* A file written in place that reaches itself would be written in place
   without end. *)
let in_place ~trail file =
  if List.mem file trail then
    refuse "%s reaches itself through the files written in its place" file;
  file :: trail

(* A schema a [$ref] names, as [named] names it or, when it names none, the
   schema written in its place from [schemas]. *)
type referent = Named of string | In_place of string * Schema.t

(* The schema [r] names: a whole file or a table record by its key, or a
   schema inside a file by its pointer. A pointer at no schema is refused. *)
let schema_at ~ids ~schemas (r : Decode.reference) =
  match Hashtbl.find_opt schemas (Table_records.key ids r) with
  | Some s -> Some s
  | None -> (
      match Decode.resolve ids r with
      | _, "" -> None
      | file, pointer -> (
          match
            Option.bind (Hashtbl.find_opt schemas file) (fun s ->
                Pointer.schema s pointer)
          with
          | Some s -> Some s
          | None -> refuse "$ref %s points into its file at no schema" r.target)
      )

let referent ~ids ~named ~schemas (r : Decode.reference) =
  let key = Table_records.key ids r in
  match named key with
  | Some name -> Some (Named name)
  | None -> Option.map (fun s -> In_place (key, s)) (schema_at ~ids ~schemas r)

let schema_of ~ids ~schemas (r : Decode.reference) =
  match schema_at ~ids ~schemas r with
  | Some s -> Ok s
  | None -> Error ("$ref " ^ r.target ^ " names no schema")

(* [s] with each [$ref] to a member of another schema ([/properties/<member>])
   written in its place, since a member is no schema of its own (S6); but a
   [$ref] to a record a table states ([recorded], by its key) names that
   record. Nothing may be said beside a reference written in its place, and
   a member that reaches itself so is refused. *)
let members_in_place ~ids ~schemas ~recorded s =
  let rec members trail = function
    | Schema.Boolean_schema _ as b -> b
    | Schema.Schema l -> (
        match l.ref_ with
        | None -> Schema.Schema (Schema.map (members trail) l)
        | Some r ->
            let key = Table_records.key ids r in
            let member =
              match String.split_on_char '/' (snd (Decode.resolve ids r)) with
              | [ ""; "properties"; _ ] -> not (List.mem key recorded)
              | _ -> false
            in
            if not member then Schema.Schema l
            else (
              (match Schema_names.said_of_reference l r with
              | Ok None -> ()
              | Ok (Some _) ->
                  refuse
                    "$ref %s is written in its place, so nothing can be said \
                     of it beside it"
                    r.target
              | Error message -> refuse "%s" message);
              match schema_at ~ids ~schemas r with
              | Some target -> members (in_place ~trail key) target
              | None -> refuse "$ref %s names no schema" r.target))
  in
  members [] s

(* A schema of [spec] as a writer that reads one whole writes it: each member
   of another schema it refers to written in its place ([members_in_place]),
   then each file it refers to that no generation names
   ([Schema_names.in_place]), which a member written in place may refer to,
   and each schema within it that closes what it composes read as the one
   object it means ([Normalize.closed_within]). *)
let whole (spec : Spec.t) =
  let ids = spec.ids in
  let schemas = Hashtbl.of_seq (List.to_seq spec.schemas) in
  let recorded =
    match Table_records.all spec with
    | Ok records -> List.map (fun (key, _, _) -> key) records
    | Error message -> refuse "%s" message
  in
  let files = Schema_names.in_place spec ~places:true in
  fun s ->
    match members_in_place ~ids ~schemas ~recorded s with
    | s ->
        Result.bind (files s)
          (Normalize.closed_within ids ~find:(schema_of ~ids ~schemas))
    | exception Refused message -> Error message

(* A schema read whole ([whole]), as a writer of types reads it
   ([Normalize.shape_only]). *)
let typed (spec : Spec.t) =
  let whole = whole spec in
  fun s -> Result.map Normalize.shape_only (whole s)

(* The client types each SDK writes by hand: SearchState and JobEvent, each
   held to its schema by a census in every SDK; PutBinaryRequest, whose file
   is bytes, which the Swift, Kotlin and Haskell writers state as text; and
   what the engines and content methods return, which waits on each SDK's
   methods returning what client/surface.json says they return; and
   ByteStream, which only ResourceRepresentationStream holds, as each SDK's
   own read-once stream. *)
let hand_written_client_types =
  [
    "SearchState";
    "JobEvent";
    "PutBinaryRequest";
    "EngineWithLimits";
    "EnginesWithLimits";
    "ResourceRepresentation";
    "ResourceRepresentationStream";
    "ByteStream";
  ]

(* The client types every SDK generates, by name: each file of
   protocol/specs/src/client/types but the hand-written ones, each of which
   must still be one. *)
let generated_client_types (spec : Spec.t) =
  let names =
    List.filter_map
      (fun (key, _) ->
        if String.starts_with ~prefix:Roots.client_types key then
          Some (Filename.remove_extension (Filename.basename key))
        else None)
      spec.schemas
  in
  List.iter
    (fun name ->
      if not (List.mem name names) then
        refuse "%s%s.json, which an SDK writes by hand, is gone"
          Roots.client_types name)
    hand_written_client_types;
  List.sort String.compare
    (List.filter (fun n -> not (List.mem n hand_written_client_types)) names)

let records spec =
  match Table_records.all spec with
  | Ok records -> records
  | Error message -> refuse "%s" message

(* The type each named map's keys are, where its schema's [propertyNames] is
   a whole schema of its own: LastEventIds is keyed by ResourceId. *)
let map_keys (spec : Spec.t) =
  let key_of name = function
    | Schema.Schema
        { property_names = Some (Schema.Schema { ref_ = Some r; _ }); _ } -> (
        match Decode.resolve spec.ids r with
        | file, "" -> Some (stem file)
        | _ ->
            refuse
              "%s names its members' names by %s, which is no schema's file"
              name r.target)
    | _ -> None
  in
  List.filter_map
    (fun (name, r) ->
      let file, _ = Decode.resolve spec.ids r in
      Option.map (fun s -> (name, s)) (List.assoc_opt file spec.schemas))
    (Roots.all spec)
  @ List.map (fun (_, name, s) -> (name, s)) (records spec)
  |> List.filter_map (fun (name, s) ->
      Option.map (fun key -> (name, key)) (key_of name s))

(* What a client roots of its own: each client type, and each record a
   table states ([Table_records]). *)
let client_roots (spec : Spec.t) =
  List.filter
    (String.starts_with ~prefix:Roots.client_types)
    (List.map fst spec.schemas)
  @ List.map (fun (key, _, _) -> key) (records spec)

(* Where the view is in what it reads: the files written in place that reach
   it ([in_place]), the key of the place it is within its file, when that is
   known, and whether it is within a schema written in the place of a
   [$ref]. *)
type context = { trail : string list; at : string option; within_ref : bool }

(* The key of the place [segments] (a JSON pointer's, unescaped) name below
   [at]. *)
let below at segments =
  let escape segment =
    String.concat "~1"
      (String.split_on_char '/'
         (String.concat "~0" (String.split_on_char '~' segment)))
  in
  Option.map
    (fun at ->
      String.concat "/"
        ((if String.contains at '#' then at else at ^ "#")
        :: List.map escape segments))
    at

(* The view of a schema, each [$ref] it holds resolved by [named] or written
   in place from [schemas], and each place within it that a [$ref] names
   ([referred]) marked as that place ([origin]). [at] is the key of the
   schema's own place, its file's when it is a whole file; a schema of no
   file is at none. *)
let view ~ids ~named ~schemas ~referred =
  let rec view s = Schema.para ~boolean:(fun b _ -> Bool b) ~schema:layer s
  and layer (l : (Schema.t * (context -> t)) Schema.layer) context =
    match Null_form.without_null fst l with
    | Error message -> refuse "%s" message
    | Ok None -> plain l context
    | Ok (Some beside) -> (
        (* What is beside null is no place of its own file. *)
        match plain beside { context with at = None } with
        | Node ({ type_ = Some (One t); _ } as n) ->
            Node { n with type_ = Some (Or_null t) }
        | other ->
            Node { (node [ "anyOf" ]) with any_of = Some [ Null; other ] })
  and plain l context =
    let s = Schema.map snd l in
    if Option.is_some s.unevaluated_properties then closed l context
    else
      match s.ref_ with
      | Some r -> (
          let description =
            match Schema_names.said_of_reference s r with
            | Ok d -> d
            | Error message -> refuse "%s" message
          in
          match referent ~ids ~named ~schemas r with
          | Some (Named name) -> Ref { name; description }
          | Some (In_place (key, target)) ->
              if Option.is_some description then
                refuse
                  "$ref %s is written in its place, so nothing can be said of \
                   it beside it"
                  r.target;
              view target
                {
                  trail = in_place ~trail:context.trail key;
                  at = Some key;
                  within_ref = true;
                }
          | None -> refuse "$ref %s names no schema" r.target)
      | None
        when Schema.keywords s = [ "type" ] && s.type_ = Some [ Schema.Null ] ->
          Null
      | None ->
          let sub segments f =
            f { context with at = below context.at segments }
          in
          let subs keyword =
            Option.map
              (List.mapi (fun i f -> sub [ keyword; string_of_int i ] f))
          in
          let keys = Schema.keywords s in
          let merged =
            Option.map
              (fun _ ->
                match
                  Normalize.normalize ids ~find:(schema_of ~ids ~schemas)
                    (Schema.Schema (Schema.map fst l))
                with
                | Ok m -> view (Schema.Schema m) { context with at = None }
                | Error message -> refuse "%s" message)
              s.all_of
          in
          let types =
            match s.type_ with
            | None -> None
            | Some [ t ] when t <> Schema.Null -> Some (One t)
            | Some _ ->
                refuse "a schema of several types the generator does not know"
          in
          let own =
            {
              keys;
              origin =
                Option.bind context.at (fun at ->
                    let key = Schema_names.place_key at in
                    if referred key then
                      Some { key; referred = context.within_ref }
                    else None);
              title = s.title;
              description =
                (match merged with
                | Some (Node m) -> m.description
                | _ -> s.description);
              type_ = types;
              format = s.format;
              enum = s.enum;
              properties =
                Option.map
                  (List.map (fun (k, v) -> (k, sub [ "properties"; k ] v)))
                  s.properties;
              required = s.required;
              additional_properties =
                Option.map
                  (sub [ "additionalProperties" ])
                  s.additional_properties;
              max_properties = s.max_properties;
              minimum = s.minimum;
              maximum = s.maximum;
              items = Option.map (sub [ "items" ]) s.items;
              all_of = subs "allOf" s.all_of;
              merged;
              any_of = subs "anyOf" s.any_of;
              one_of = subs "oneOf" s.one_of;
              discriminator =
                Option.map
                  (fun (d : Schema.discriminator) -> d.property_name)
                  s.discriminator;
              pattern = s.pattern;
            }
          in
          Node own
  (* A schema that closes what it composes, as the one object it means. *)
  and closed l context =
    match
      Normalize.closed ids ~find:(schema_of ~ids ~schemas) (Schema.map fst l)
    with
    | Ok closed -> view (Schema.Schema closed) { context with at = None }
    | Error message -> refuse "%s" message
  in
  fun ~at s -> view s { trail = []; at; within_ref = false }

(* Every [$ref] a schema holds, through the files written in its place. *)
let references ~ids ~named ~schemas =
  let rec references s = Schema.cata ~boolean:(fun _ _ -> []) ~schema:layer s
  and layer (s : (string list -> string list) Schema.layer) trail =
    match s.ref_ with
    | Some r -> (
        match referent ~ids ~named ~schemas r with
        | Some (Named _) -> [ Table_records.key ids r ]
        | Some (In_place (file, target)) ->
            references target (in_place ~trail file)
        | None -> [])
    | None -> List.concat_map (fun f -> f trail) (Schema.children s)
  in
  fun s -> references s []

let response_schemas (r : Openapi.response) =
  match r.content with
  | None -> []
  | Some content ->
      List.map (fun (_, (m : Openapi.media_type)) -> m.schema) content

let header_schemas (r : Openapi.response) =
  match r.headers with
  | None -> []
  | Some hs -> List.map (fun (_, (h : Openapi.header)) -> h.schema) hs

type bundle = {
  definitions : definitions;
  view : at:string option -> Schema.t -> t;
      (** Any other schema, at the key of its place when it has one
          ([Definitions.view]), each file it names as the bundle names it. *)
  bodies : string list;
      (** Every component schema a request or response body of the paths names.
      *)
  client : string list;
      (** Every client type ([client_roots]), and every schema only they reach,
          by its name: in neither [definitions.names] nor any other writer's
          output unless a writer roots them. *)
}

let bundle (spec : Spec.t) =
  let ids = spec.ids in
  let schemas = Hashtbl.create 1024 in
  List.iter
    (fun (file, s) -> Hashtbl.replace schemas file (Normalize.shape_only s))
    spec.schemas;
  List.iter
    (fun (key, _, s) -> Hashtbl.replace schemas key (Normalize.shape_only s))
    (records spec);
  let declared =
    List.map
      (fun (name, r) -> (fst (Decode.resolve spec.Spec.ids r), name))
      (Roots.all spec)
  in
  let named =
    match Schema_names.named spec with
    | Ok named -> named
    | Error message -> refuse "%s" message
  in
  (* Each schema a writer is handed, the files no generation names written in
     their places ([Schema_names.in_place]); a place a [$ref] names within
     one is the view's to mark ([Schema_names.referred_places]). *)
  let referred =
    match Schema_names.referred_places spec with
    | Ok referred -> referred
    | Error message -> refuse "%s" message
  in
  let in_place =
    let in_place = Schema_names.in_place spec ~places:false in
    fun s ->
      match in_place s with Ok s -> s | Error message -> refuse "%s" message
  in
  let response file =
    match List.assoc_opt file spec.responses with
    | Some r -> r
    | None ->
        refuse
          "the document names the response %s, which Protocol does not have"
          file
  in
  let item_responses (item : Openapi.path_item) =
    List.concat_map
      (fun (op : Openapi.operation) ->
        List.map
          (function
            | _, Openapi.Ref r ->
                response (fst (Decode.resolve spec.Spec.ids r))
            | _, Openapi.Inline r -> r)
          op.responses)
      (Spec.operations item)
  in
  let items =
    List.map
      (fun (_, r) ->
        let file = fst (Decode.resolve spec.Spec.ids r) in
        match List.assoc_opt file spec.path_items with
        | Some item -> item
        | None ->
            refuse
              "the document names the path item %s, which Protocol does not \
               have"
              file)
      spec.gateway.paths
  in
  let request_schemas (item : Openapi.path_item) =
    List.concat_map
      (fun (op : Openapi.operation) ->
        match op.request_body with
        | None -> []
        | Some body ->
            List.map
              (fun (_, (m : Openapi.media_type)) -> m.schema)
              body.content)
      (Spec.operations item)
  in
  let parameter_schemas (item : Openapi.path_item) =
    List.concat_map
      (fun (op : Openapi.operation) ->
        match op.parameters with
        | None -> []
        | Some ps -> List.map (fun (p : Openapi.parameter) -> p.schema) ps)
      (Spec.operations item)
  in
  let component_responses =
    match spec.gateway.components.responses with
    | None -> []
    | Some rs ->
        List.map
          (fun (_, r) -> response (fst (Decode.resolve spec.Spec.ids r)))
          rs
  in
  let refs = references ~ids ~named ~schemas in
  let body_schemas =
    List.concat_map
      (fun item ->
        request_schemas item
        @ List.concat_map response_schemas (item_responses item))
      items
  in
  (* Every schema the document reaches, by its file. *)
  let reached = Hashtbl.create 512 in
  let rec reach file =
    if not (Hashtbl.mem reached file) then (
      Hashtbl.replace reached file ();
      match Hashtbl.find_opt schemas file with
      | Some s -> List.iter reach (refs s)
      | None ->
          refuse
            "the document names the schema %s, which Protocol does not have"
            file)
  in
  List.iter (fun (file, _) -> reach file) declared;
  List.iter reach
    (List.concat_map refs
       (body_schemas
       @ List.concat_map parameter_schemas items
       @ List.concat_map
           (fun r -> response_schemas r @ header_schemas r)
           (component_responses @ List.concat_map item_responses items)
       @ List.concat_map header_schemas (List.concat_map item_responses items)));
  let gateway = Hashtbl.copy reached in
  List.iter reach (client_roots spec);
  let by_name = Hashtbl.create 512 in
  Hashtbl.iter
    (fun file () ->
      let name = Option.get (named file) in
      match Hashtbl.find_opt by_name name with
      | Some other when other <> file ->
          refuse "%s and %s are both the schema %s" other file name
      | _ -> Hashtbl.replace by_name name file)
    reached;
  let views = Hashtbl.create 512 in
  let schema name =
    match Hashtbl.find_opt views name with
    | Some v -> v
    | None -> (
        match Hashtbl.find_opt by_name name with
        | None -> refuse "the spec declares no schema %s" name
        | Some file ->
            let v =
              view ~ids ~named ~schemas ~referred ~at:(Some file)
                (in_place (Hashtbl.find schemas file))
            in
            Hashtbl.replace views name v;
            v)
  in
  let names_of keep =
    List.sort String.compare
      (Hashtbl.fold
         (fun n file acc -> if keep file then n :: acc else acc)
         by_name [])
  in
  let names = names_of (Hashtbl.mem gateway) in
  {
    definitions = { names; schema };
    view = (fun ~at s -> view ~ids ~named ~schemas ~referred ~at (in_place s));
    bodies =
      List.filter_map named (List.concat_map refs body_schemas)
      |> List.sort_uniq String.compare;
    client = names_of (fun file -> not (Hashtbl.mem gateway file));
  }

(* One schema file alone, as its own definitions: its [$ref]s are refused. *)
let alone ~ids ~name (s : Schema.t) =
  let v =
    view ~ids
      ~named:(fun file ->
        refuse "%s refers to %s, and is generated alone" name file)
      ~schemas:(Hashtbl.create 0)
      ~referred:(fun _ -> false)
      ~at:None s
  in
  {
    names = [ name ];
    schema =
      (fun n ->
        if n = name then v else refuse "the spec declares no schema %s" n);
  }

(* The schema that states each property of [name]'s schema [s], as
   [Inherited.owners] decides it: a schema's parts are its [allOf]'s members
   and then its own properties. *)
let owners definitions name s =
  let stated = function
    | Node { properties = Some ps; _ } -> Inherited.Stated (List.map fst ps)
    | _ -> Inherited.Stated []
  in
  let parts = function
    | Node { all_of = Some members; _ } as s ->
        List.map
          (function
            | Ref { name; _ } -> Inherited.Component name | m -> stated m)
          members
        @ [ stated s ]
    | s -> [ stated s ]
  in
  Inherited.owners ~parts:(fun n -> parts (definitions.schema n)) name (parts s)
