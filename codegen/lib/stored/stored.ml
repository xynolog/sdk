(* The stored group: what a registry of knowledge bases keeps in a
   SessionStorage (protocol/specs/src/session/stored.json), for the Python
   SDK. A registry in one SDK finds what one in another wrote, over one
   storage, only if both say these alike: the key each thing is kept under,
   the prefixes of the keys made per knowledge base, the stream's places, and
   the queries a client keeps (those client/refresh.json marks persisted),
   with the key of one per nothing and the version of what keeps them. The
   stored session's and an open resource's shapes are xynolog.types'.

   A fixed key is a constant's name ending in Key, stated once, and begins
   with no prefix. The stream's places are named by a kind of id, each a
   component. *)

module T = Tables.Session_stored

let file = "session/stored.json"

type kept = { query : string; keyed_by : string option; value : string }

(* A type an embedded schema names, and what it says of it. *)
type named = { title : string; description : string }

type t = {
  table : T.t;
  places : named;  (** lastEventIds' type. *)
  version : int;  (** The cache document's version. *)
  version_description : string;
  scope : string;
  place : string;
  kinds : string list;
  kept : kept list;
}

let derive (spec : Spec.t) ~kinds ~(refresh : Cache_refresh.Table.t) =
  let table = spec.tables.session_stored in
  let refusals = ref [] in
  let refuse pointer message =
    refusals := { Decode.file; pointer; message } :: !refusals
  in
  if table.keys = [] then refuse "/keys" "states none";
  List.iteri
    (fun i (k : T.keys_item) ->
      let at = Printf.sprintf "/keys/%d" i in
      if
        not
          (String.ends_with ~suffix:"Key" k.member
          && Sign_in.Flat.is_property_name k.member)
      then
        refuse (at ^ "/member")
          (Printf.sprintf "is %S, not a constant's name ending in Key" k.member);
      if k.key = "" then refuse (at ^ "/key") "is empty";
      if k.docs = "" then refuse (at ^ "/docs") "is empty";
      match
        List.find_index (fun (o : T.keys_item) -> o.key = k.key) table.keys
      with
      | Some j when j < i ->
          refuse (at ^ "/key")
            (Printf.sprintf "is %s, which /keys/%d states already" k.key j)
      | _ -> ())
    table.keys;
  List.iter
    (fun (member, prefix, docs) ->
      if prefix = "" then refuse ("/" ^ member ^ "/prefix") "is empty";
      if docs = "" then refuse ("/" ^ member ^ "/docs") "is empty";
      List.iter
        (fun (k : T.keys_item) ->
          if prefix <> "" && String.starts_with ~prefix k.key then
            refuse
              ("/" ^ member ^ "/prefix")
              (Printf.sprintf
                 "is %S, which the fixed key %s begins with, so it would read \
                  as one of its keys"
                 prefix k.key))
        table.keys)
    [
      ( "sessionKeyPrefix",
        table.session_key_prefix.prefix,
        table.session_key_prefix.docs );
      ( "lastEventIdKeyPrefix",
        table.last_event_id_key_prefix.prefix,
        table.last_event_id_key_prefix.docs );
      ( "cacheKeyPrefix",
        table.cache_key_prefix.prefix,
        table.cache_key_prefix.docs );
    ];
  (* The component a reference to one names. *)
  let component at : Decode.reference option -> string = function
    | Some r -> (
        match Decode.names spec.ids r with
        | Some (file, "")
          when Filename.dirname file = "components/schemas"
               && List.mem_assoc file spec.schemas ->
            Filename.remove_extension (Filename.basename file)
        | _ ->
            refuse at
              (Printf.sprintf "is %S, not a reference to a component" r.target);
            "")
    | None ->
        refuse at "states no reference to a component";
        ""
  in
  (* The embedded schemas, read through Schema: a property the group reads
     and the schema lacks is refused, and read on as one that states
     nothing. *)
  let layer : Schema.t -> Schema.schema = function
    | Schema s -> s
    | Boolean_schema _ -> Schema.empty
  in
  let said = function Some text -> text <> "" | None -> false in
  let named_type (s : Schema.schema) =
    match s.title with Some t -> Sign_in.Flat.is_type_name t | None -> false
  in
  let referred : Schema.t option -> Decode.reference option = function
    | Some (Schema { ref_ = Some r; _ }) -> Some r
    | _ -> None
  in
  let l = layer table.last_event_ids in
  let at_last = "/lastEventIds" in
  if l.type_ <> Some [ Object ] then refuse (at_last ^ "/type") "is not object";
  if not (named_type l) then refuse (at_last ^ "/title") "names no type";
  if not (said l.description) then refuse (at_last ^ "/description") "is empty";
  let scope =
    component (at_last ^ "/propertyNames/$ref") (referred l.property_names)
  in
  if scope <> "" && not (List.mem scope kinds) then
    refuse
      (at_last ^ "/propertyNames/$ref")
      (Printf.sprintf "names its members by %s, which is no kind of id" scope);
  let place =
    component
      (at_last ^ "/additionalProperties/$ref")
      (referred l.additional_properties)
  in
  if table.whole_key.docs = "" then refuse "/wholeKey/docs" "is empty";
  (* A cache document is a version and its entries, each a key, a value and a
     whole-number stamp; Haskell's reads it as no more than that. Its schema
     is JSON here, for prefixItems is no keyword Schema reads. *)
  let d pointer = Decode.at_pointer pointer table.cache_document in
  let is pointer (json : Yojson.Safe.t) = d pointer = Some json in
  (match d "/properties/version/description" with
  | Some (`String text) when text <> "" -> ()
  | _ -> refuse "/cacheDocument/properties/version/description" "is empty");
  if not (is "/type" (`String "object")) then
    refuse "/cacheDocument/type" "is not object";
  if not (is "/required" (`List [ `String "version"; `String "entries" ])) then
    refuse "/cacheDocument/required"
      "is not the version, then the entries, which is all a cache document is";
  if not (is "/properties/entries/type" (`String "array")) then
    refuse "/cacheDocument/properties/entries/type" "is not array";
  let at_entry = "/cacheDocument/properties/entries/items" in
  let entry = "/properties/entries/items" in
  if not (is (entry ^ "/type") (`String "array")) then
    refuse (at_entry ^ "/type") "is not array";
  if not (is (entry ^ "/minItems") (`Int 3) && is (entry ^ "/maxItems") (`Int 3))
  then refuse at_entry "is not exactly three items: a key, a value and a stamp";
  (match d (entry ^ "/prefixItems") with
  | Some (`List [ key; value; stamp ]) ->
      let has member (json : Yojson.Safe.t) =
        match json with
        | `Assoc members -> List.assoc_opt member members
        | _ -> None
      in
      List.iteri
        (fun i item ->
          if has "type" item <> None || has "minimum" item <> None then
            refuse
              (Printf.sprintf "%s/prefixItems/%d" at_entry i)
              "states a type, but an entry's key and value are any JSON")
        [ key; value ];
      if
        has "type" stamp <> Some (`String "integer")
        || has "minimum" stamp <> Some (`Int 0)
      then
        refuse
          (at_entry ^ "/prefixItems/2")
          "is not a whole number of at least 0"
  | _ -> refuse (at_entry ^ "/prefixItems") "is not a key, a value and a stamp");
  let kept =
    List.filter_map
      (fun (q : Cache_refresh.Table.query) ->
        if not q.persisted then None
        else
          let members =
            match q.value.members with
            | [] -> q.value.component
            | members ->
                q.value.component ^ "'s `" ^ String.concat "." members ^ "`"
          in
          Some
            {
              query = q.name;
              keyed_by =
                (match q.per with
                | Some Resource -> Some "ResourceId"
                | Some Annotation -> Some "AnnotationId"
                | Some Filters | None -> None);
              value = members;
            })
      refresh.queries
  in
  if kept = [] then
    refuse ""
      (Cache_refresh.Table.file
     ^ " marks no query persisted, so a client keeps none");
  let named (s : Schema.schema) =
    {
      title = Option.value ~default:"" s.title;
      description = Option.value ~default:"" s.description;
    }
  in
  let version =
    match d "/properties/version/const" with
    | Some (`Int version) -> version
    | _ ->
        refuse "/cacheDocument/properties/version/const"
          "is no whole number, which a cache document's version is";
        0
  in
  let version_description =
    match d "/properties/version/description" with
    | Some (`String text) -> text
    | _ -> ""
  in
  match List.rev !refusals with
  | [] ->
      Ok
        {
          table;
          places = named l;
          version;
          version_description;
          scope;
          place;
          kinds;
          kept;
        }
  | errors -> Error errors

let python t =
  let module P = Python_syntax in
  let table = t.table in
  let constant ~about name value =
    P.assign ~about:[ Prose about ] name ~annotation:(P.Name "Final") ~value
  in
  let named = [ t.scope; t.place ] in
  let identifiers =
    List.sort_uniq compare (List.filter (fun n -> List.mem n t.kinds) named)
  in
  let components =
    List.sort_uniq compare
      (List.filter (fun n -> not (List.mem n t.kinds)) named)
  in
  let constants =
    List.map
      (fun (k : T.keys_item) -> (Text.upper_snake k.member, k.key, k.docs))
      table.keys
  in
  let exported =
    List.sort compare
      (List.map (fun (n, _, _) -> n) constants
      @ [
          "CACHE_DOCUMENT_VERSION";
          "CACHE_KEY_PREFIX";
          "KEPT_QUERIES";
          "LAST_EVENT_ID_KEY_PREFIX";
          "SESSION_KEY_PREFIX";
          "WHOLE_KEY";
        ])
    @ List.sort compare [ t.places.title; "KeptQuery"; "WholeKey" ]
  in
  let kept_as k =
    "Keyed by "
    ^ (match k.keyed_by with None -> "WHOLE_KEY alone" | Some key -> key)
    ^ "; its value is " ^ k.value ^ "."
  in
  let from what = function
    | [] -> []
    | names -> [ P.From ("xynolog." ^ what, names) ]
  in
  let whole = P.Str table.whole_key.key in
  {
    Output.path = "python/sdk/src/xynolog/stored.py";
    text =
      P.text
        {
          header =
            Banner.python_lines ~from_:("protocol/specs/src/" ^ file) __FILE__;
          doc =
            As_is
              "What a registry of knowledge bases keeps in a `SessionStorage` \
               (`protocol/specs/src/session/stored.json`):\n\
               the key each thing it keeps is kept under.\n\
               And what the sessions it makes keep there: which queries, and \
               the stream's\n\
               places. The keys made of these prefixes are \
               `xynolog.storage_keys`'s.\n";
          imports =
            [
              [ P.From ("typing", [ "Final"; "Literal" ]) ];
              from "identifiers" identifiers @ from "types" components;
            ];
          body =
            P.assign "__all__"
              ~value:
                (P.List
                   (P.items ~magic:true
                      (List.map (fun n -> P.item (P.Str n)) exported)))
            :: List.map
                 (fun (name, key, docs) ->
                   constant ~about:docs name (P.Str key))
                 constants
            @ [
                constant ~about:table.session_key_prefix.docs
                  "SESSION_KEY_PREFIX" (P.Str table.session_key_prefix.prefix);
                constant ~about:table.last_event_id_key_prefix.docs
                  "LAST_EVENT_ID_KEY_PREFIX"
                  (P.Str table.last_event_id_key_prefix.prefix);
                P.alias
                  ~about:[ Prose t.places.description ]
                  t.places.title
                  (P.sub "dict"
                     [ P.item (P.Name t.scope); P.item (P.Name t.place) ]);
                constant ~about:table.cache_key_prefix.docs "CACHE_KEY_PREFIX"
                  (P.Str table.cache_key_prefix.prefix);
                P.alias
                  ~about:
                    [
                      Prose
                        "The queries a client keeps across a restart, each by \
                         its name in protocol/specs/src/client/refresh.json, \
                         and each as one document under its \
                         `xynolog.storage_keys.cache_key`.";
                    ]
                  "KeptQuery"
                  (P.sub ~magic:true "Literal"
                     (List.map
                        (fun k ->
                          P.element ~about:[ Prose (kept_as k) ] (P.Str k.query))
                        t.kept));
                P.assign "KEPT_QUERIES"
                  ~annotation:
                    (P.sub "Final"
                       [
                         P.item
                           (P.sub "tuple"
                              [ P.item (P.Name "KeptQuery"); P.item P.Ellipsis ]);
                       ])
                  ~value:
                    (P.strings ~magic:true (List.map (fun k -> k.query) t.kept));
                P.Adjacent
                  [
                    P.alias
                      ~about:[ Prose table.whole_key.docs ]
                      "WholeKey"
                      (P.sub "Literal" [ P.item whole ]);
                    P.assign "WHOLE_KEY"
                      ~annotation:(P.sub "Final" [ P.item (P.Name "WholeKey") ])
                      ~value:whole;
                  ];
                constant ~about:t.version_description "CACHE_DOCUMENT_VERSION"
                  (P.Int t.version);
              ];
        };
  }

(* Haskell's kept queries, the key a whole query keeps its one entry under,
   and the version of a cache document. What reads and writes them is the
   SDK's own (haskell/sdk/internal/Xynolog/Internal/CacheDocument.hs). *)
let haskell t =
  let module H = Haskell_syntax in
  let constructor (k : kept) = String.capitalize_ascii k.query in
  {
    Output.path =
      "haskell/sdk/generated/Xynolog/Internal/Generated/CachePersistence.hs";
    text =
      H.text
        {
          banner =
            Banner.lines
              ~from_:(file ^ " and " ^ Cache_refresh.Table.file)
              __FILE__;
          extensions = [ "OverloadedStrings" ];
          name = "Xynolog.Internal.Generated.CachePersistence";
          imports = [ H.import "Data.Text" ~items:[ Plain "Text" ] ];
          body =
            [
              H.data "KeptQuery"
                ~about:
                  [
                    "The queries a client keeps across a restart, by their \
                     names in client/refresh.json.";
                  ]
                (List.map (fun k -> H.constructor (constructor k)) t.kept)
                ~deriving:[ "Eq"; "Ord"; "Show"; "Enum"; "Bounded" ];
              Value
                {
                  about = [];
                  name = "keptQueryName";
                  type_ = T_fun (T_name "KeptQuery", T_name "Text");
                  clauses =
                    List.map
                      (fun k ->
                        {
                          H.patterns = [ Constructor (constructor k, []) ];
                          body = Str k.query;
                        })
                      t.kept;
                };
              H.value "wholeKey" (T_name "Text")
                ~about:[ t.table.whole_key.docs ] (Str t.table.whole_key.key);
              H.value "cacheDocumentVersion" (T_name "Integer")
                ~about:[ t.version_description ] (Int t.version);
            ];
        };
  }

(* The keys a Haskell client keeps its registry under, by their members'
   names, and the prefixes of the keys it keeps per session
   (generated/.../Stored.hs). *)
let haskell_keys (table : T.t) =
  let module H = Haskell_syntax in
  {
    Output.path = "haskell/sdk/generated/Xynolog/Internal/Generated/Stored.hs";
    text =
      H.text
        {
          banner = Banner.lines ~from_:file __FILE__;
          extensions = [ "OverloadedStrings" ];
          name = "Xynolog.Internal.Generated.Stored";
          imports = [ H.import "Data.Text" ~items:[ Plain "Text" ] ];
          body =
            List.map
              (fun (k : T.keys_item) ->
                H.value k.member (T_name "Text") (Str k.key))
              table.keys
            @ List.map
                (fun (name, prefix) ->
                  H.value name (T_name "Text") (Str prefix))
                [
                  ("sessionKeyPrefix", table.session_key_prefix.prefix);
                  ("lastEventIdKeyPrefix", table.last_event_id_key_prefix.prefix);
                  ("cacheKeyPrefix", table.cache_key_prefix.prefix);
                ];
        };
  }

let files ~root:_ (spec : Spec.t) =
  let ( let* ) = Result.bind in
  let* kinds = Identifiers.Table.derive spec in
  let* context = Cache_refresh.context spec in
  let* refresh =
    Cache_refresh.Table.derive context spec.tables.client_refresh
  in
  let* t =
    derive spec
      ~kinds:(List.map (fun (k : Identifiers.Table.kind) -> k.name) kinds)
      ~refresh
  in
  Ok [ python t; haskell t; haskell_keys t.table ]
