(* The stored group: what a registry of knowledge bases keeps in a
   SessionStorage (protocol/specs/src/session/stored.json). A registry in one
   SDK finds what one in another wrote, over one
   storage, only if both say these alike: the key each thing is kept under,
   the prefixes of the keys made per knowledge base, and the queries a client
   keeps (those client/refresh.json marks persisted), with the key of one per
   nothing and the version of what keeps them. The records kept, the stored
   session, an open resource, a pending sign-in and where each stream was,
   are xynolog.types'.

   A fixed key is a constant's name ending in Key, stated once, and begins
   with no prefix. It is a constant of client/surface.json's registry module
   or of its redirectSignIn module, and each SDK names it as that constant:
   by the name surface.json gives it there, else by its member in the SDK's
   own case. The keys made per knowledge base are its prefixes', each named
   by its member in the SDK's own case. *)

module T = Tables.Session_stored
module S = Tables.Client_surface

let file = "session/stored.json"

type kept = { query : string; keyed_by : string option; value : string }

(* What keeps what is under a fixed key: the registry, or a sign-in by a page
   redirect. Each SDK keeps the two's keys where it keeps the two. *)
type kept_by = Registry | Redirect_sign_in

type key = {
  row : T.keys_item;
  kept_by : kept_by;
  named : (string * string) list;
      (** Each SDK that names the key's constant otherwise than by its member,
          with that name. *)
}

type t = {
  table : T.t;
  keys : key list;
  version : int;  (** The cache document's version. *)
  version_description : string;
  kept : kept list;
}

(* The name [sdk] gives a key's constant: surface.json's, else its member in
   the SDK's own case. *)
let name ~sdk ~cased (k : key) =
  match List.assoc_opt sdk k.named with
  | Some name -> name
  | None -> cased k.row.member

let go_name = name ~sdk:"go" ~cased:String.capitalize_ascii
let typescript_name = name ~sdk:"typescript" ~cased:Text.upper_snake
let python_name = name ~sdk:"python" ~cased:Text.upper_snake
let rust_name = name ~sdk:"rust" ~cased:Text.upper_snake
let kotlin_name = name ~sdk:"kotlin" ~cased:Text.upper_snake
let swift_name = name ~sdk:"swift" ~cased:Fun.id
let csharp_name = name ~sdk:"csharp" ~cased:String.capitalize_ascii
let haskell_name = name ~sdk:"haskell" ~cased:Fun.id
let kept_by by t = List.filter (fun k -> k.kept_by = by) t.keys

let prefixes (table : T.t) =
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
  ]

let derive (spec : Spec.t) ~(refresh : Cache_refresh.Table.t) =
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
    (prefixes table);
  if table.whole_key.docs = "" then refuse "/wholeKey/docs" "is empty";
  let keys =
    List.concat
      (List.mapi
         (fun i (k : T.keys_item) ->
           let at = Printf.sprintf "/keys/%d/member" i in
           match
             List.concat_map
               (fun (m : S.modules_item) ->
                 List.filter_map
                   (function
                     | S.Constant { member; named; _ } when member = k.member ->
                         Some (m.module_, named)
                     | S.Constant _ | S.Type _ | S.Function _ | S.Reader _ ->
                         None)
                   m.members)
               spec.tables.client_surface.modules
           with
           | [ ("registry", named) ] ->
               [
                 {
                   row = k;
                   kept_by = Registry;
                   named = Option.value named ~default:[];
                 };
               ]
           | [ ("redirectSignIn", named) ] ->
               [
                 {
                   row = k;
                   kept_by = Redirect_sign_in;
                   named = Option.value named ~default:[];
                 };
               ]
           | [ (module_, _) ] ->
               refuse at
                 (Printf.sprintf
                    "is %s, a constant of client/surface.json's %s module, not \
                     of its registry module or its redirectSignIn module"
                    k.member module_);
               []
           | [] ->
               refuse at
                 (Printf.sprintf
                    "is %s, which client/surface.json lists no constant of"
                    k.member);
               []
           | _ :: _ :: _ ->
               refuse at
                 (Printf.sprintf
                    "is %s, which client/surface.json lists a constant of more \
                     than once"
                    k.member);
               [])
         table.keys)
  in
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
  | [] -> Ok { table; keys; version; version_description; kept }
  | errors -> Error errors

let python t =
  let module P = Python_syntax in
  let table = t.table in
  let constant ~about name value =
    P.assign ~about:[ Prose about ] name ~annotation:(P.Name "Final") ~value
  in
  let constants =
    List.map (fun k -> (python_name k, k.row.key, k.row.docs)) t.keys
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
    @ [ "KeptQuery"; "WholeKey" ]
  in
  let kept_as k =
    "Keyed by "
    ^ (match k.keyed_by with None -> "WHOLE_KEY alone" | Some key -> key)
    ^ "; its value is " ^ k.value ^ "."
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
               And which queries the sessions it makes keep there. The keys \
               made of\n\
               these prefixes are `xynolog.storage_keys`'s; where each stream \
               was is\n\
               `xynolog.types.LastEventIds`.\n";
          imports = [ [ P.From ("typing", [ "Final"; "Literal" ]) ] ];
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
            @ List.map
                (fun (member, prefix, docs) ->
                  constant ~about:docs (Text.upper_snake member) (P.Str prefix))
                (prefixes table)
            @ [
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
let haskell_keys t =
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
              (fun k ->
                H.value (haskell_name k) (T_name "Text") (Str k.row.key))
              t.keys
            @ List.map
                (fun (member, prefix, _) ->
                  H.value member (T_name "Text") (Str prefix))
                (prefixes t.table);
        };
  }

(* Go keeps the registry's keys, and the prefix of a session's, in package
   registry (go/registry/stored_gen.go); a pending sign-in's key, the other
   prefixes and the whole key in package xynolog (go/stored_gen.go), beside
   what makes their keys. A key is exported, a prefix and the whole key not. *)
let go t =
  let module G = Go_syntax in
  let table = t.table in
  let constant name docs value =
    G.Const (G.spec ~doc:(G.prose (name ^ ": " ^ docs)) name (G.Quoted value))
  in
  let key k = constant (go_name k) k.row.docs k.row.key in
  let written path package decls =
    {
      Output.path;
      text =
        G.text
          {
            header =
              G.verbatim
                ("Code generated from protocol/specs/src/" ^ file
               ^ "; DO NOT EDIT.\n\nRegenerate: make generate ("
               ^ Banner.writer __FILE__ ^ ")");
            package;
            imports = [];
            decls;
          };
    }
  in
  [
    written "go/registry/stored_gen.go" "registry"
      (List.map key (kept_by Registry t)
      @ [
          constant "sessionKeyPrefix" table.session_key_prefix.docs
            table.session_key_prefix.prefix;
        ]);
    written "go/stored_gen.go" "xynolog"
      (List.map key (kept_by Redirect_sign_in t)
      @ [
          constant "lastEventIdKeyPrefix" table.last_event_id_key_prefix.docs
            table.last_event_id_key_prefix.prefix;
          constant "cacheKeyPrefix" table.cache_key_prefix.docs
            table.cache_key_prefix.prefix;
          constant "wholeKey" table.whole_key.docs table.whole_key.key;
        ]);
  ]

(* TypeScript keeps every key, the prefixes and the whole key in
   @xynolog/core (typescript/core/src/stored.ts), for the SDK to make its
   keys of. *)
let typescript t =
  let module S = Typescript_syntax in
  let table = t.table in
  let constant name docs value = S.const name ~about:[ Doc docs ] (Str value) in
  {
    Output.path = "typescript/core/src/stored.ts";
    text =
      S.text
        {
          banner =
            Banner.typescript_lines
              ~authority:[ "protocol/specs/src/" ^ file ]
              __FILE__;
          body =
            List.map
              (fun k -> constant (typescript_name k) k.row.docs k.row.key)
              t.keys
            @ List.map
                (fun (member, prefix, docs) ->
                  constant (Text.upper_snake member) docs prefix)
                (prefixes table)
            @ [ constant "WHOLE_KEY" table.whole_key.docs table.whole_key.key ];
        };
  }

(* Rust keeps the registry's keys in the session module of the SDK's crate
   (rust/sdk/src/generated/stored.rs), with the prefixes, which only the
   session module reads, and the whole key, which the crate's browse
   namespace writes; a pending sign-in's key in the HTTP transport's oauth
   module (rust/http-transport/src/generated/stored.rs). *)
let rust t =
  let module R = Rust_syntax in
  let table = t.table in
  let constant ~vis name docs value =
    R.Const
      {
        doc = [ docs ];
        attrs = [];
        vis;
        name;
        ty = R.str_ty;
        value = R.Str value;
      }
  in
  let key k = constant ~vis:Pub (rust_name k) k.row.docs k.row.key in
  let written path items =
    {
      Output.path;
      text =
        R.text
          ~header:(Banner.lines ~from_:("protocol/specs/src/" ^ file) __FILE__)
          items;
    }
  in
  [
    written "rust/sdk/src/generated/stored.rs"
      (List.map key (kept_by Registry t)
      @ List.map
          (fun (member, prefix, docs) ->
            constant ~vis:Private (Text.upper_snake member) docs prefix)
          (prefixes table)
      @ [
          constant ~vis:Pub_crate "WHOLE_KEY" table.whole_key.docs
            table.whole_key.key;
        ]);
    written "rust/http-transport/src/generated/stored.rs"
      (List.map key (kept_by Redirect_sign_in t));
  ]

(* Kotlin keeps every key, the prefixes and the whole key in package
   xynolog.registry; a key is public, a prefix and the whole key internal. *)
let kotlin t =
  let module K = Kotlin_syntax in
  let table = t.table in
  let constant ~visibility name docs value =
    K.property ~about:(K.Block docs)
      ~annotations:[ K.annotation "Generated" ]
      ~visibility ~const:true ~type_:(K.Type "String")
      ~value:(K.Same_line (K.Str value)) name
  in
  Kotlin_sdk.table ~from_:file __FILE__ ~package:"xynolog.registry"
    ~name:"StoredKeys" ~imports:[ "xynolog.Generated" ]
    (List.map
       (fun k ->
         constant ~visibility:K.Public (kotlin_name k) k.row.docs k.row.key)
       t.keys
    @ List.map
        (fun (member, prefix, docs) ->
          constant ~visibility:K.Internal (Text.upper_snake member) docs prefix)
        (prefixes table)
    @ [
        constant ~visibility:K.Internal "WHOLE_KEY" table.whole_key.docs
          table.whole_key.key;
      ])

(* Swift keeps every key and the prefixes in the module Xynolog; a key is
   public, a prefix internal. Its whole key is the kept queries'
   (Swift_sdk.Table_decls). *)
let swift t =
  let module W = Swift_syntax in
  let constant modifiers (i, (name, docs, value)) =
    ( (if i = 0 then W.Blank else W.Line),
      {
        W.doc = Text.wrapped ~lead:"/// " ~width:100 docs;
        modifiers;
        body =
          W.Property
            { var = false; name; type_ = None; value = Some (W.String value) };
      } )
  in
  let keys =
    List.map
      (fun k -> ([ "public" ], (swift_name k, k.row.docs, k.row.key)))
      t.keys
    @ List.map
        (fun (member, prefix, docs) -> ([], (member, docs, prefix)))
        (prefixes t.table)
  in
  {
    Output.path = "swift/sdk/Sources/Xynolog/Generated/StoredKeys.swift";
    text =
      W.print
        {
          W.banner = Banner.lines ~from_:("protocol/specs/src/" ^ file) __FILE__;
          imports = [ { W.module_ = "Foundation"; testable = false } ];
          decls =
            List.mapi
              (fun i (modifiers, constant_) ->
                constant modifiers (i, constant_))
              keys;
        };
  }

(* C# keeps the registry's keys, the prefixes and the whole key in
   RegistryStorage (Generated/StoredKeys.g.cs), and a pending sign-in's key in
   RedirectSignIn (Generated/RedirectSignInKeys.g.cs), of each of which the
   file is part. A key is public, a prefix private and the whole key
   internal. *)
let csharp t =
  let module C = Csharp_syntax in
  let table = t.table in
  let constant modifiers name value =
    C.Field
      {
        modifiers = modifiers @ [ C.Const ];
        type_ = C.T "string";
        name;
        value = Some (C.Str value);
      }
  in
  let key k =
    C.Documented (k.row.docs, constant [ C.Public ] (csharp_name k) k.row.key)
  in
  let written path namespace class_ members =
    {
      Output.path = "csharp/sdk/src/Xynolog/Generated/" ^ path;
      text =
        C.text
          {
            header = Banner.lines ~from_:("protocol/specs/src/" ^ file) __FILE__;
            nullable = false;
            usings = [];
            namespace;
            decls =
              [
                C.Type
                  {
                    attributes = [];
                    modifiers = [ Public; Static; Partial ];
                    kind = Class;
                    name = class_;
                    params = None;
                    base = None;
                    body = Some (Spaced, members);
                  };
              ];
          };
    }
  in
  [
    written "StoredKeys.g.cs" "Xynolog.Registry" "RegistryStorage"
      (List.map key (kept_by Registry t)
      @ List.map
          (fun (member, prefix, _) ->
            constant [ C.Private ] (String.capitalize_ascii member) prefix)
          (prefixes table)
      @ [ constant [ C.Internal ] "WholeKey" table.whole_key.key ]);
    written "RedirectSignInKeys.g.cs" "Xynolog.Authorization" "RedirectSignIn"
      (List.map key (kept_by Redirect_sign_in t));
  ]

(* The stored table of [spec], with the queries client/refresh.json marks
   persisted. *)
let of_spec (spec : Spec.t) =
  let ( let* ) = Result.bind in
  let* context = Cache_refresh.context spec in
  let* refresh =
    Cache_refresh.Table.derive context spec.tables.client_refresh
  in
  derive spec ~refresh

let files ~root:_ (spec : Spec.t) =
  let ( let* ) = Result.bind in
  let* t = of_spec spec in
  Ok
    ([ python t; haskell t; haskell_keys t; typescript t; kotlin t; swift t ]
    @ go t @ rust t @ csharp t)
