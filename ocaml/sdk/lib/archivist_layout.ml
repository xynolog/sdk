(* Generated from protocol/specs/src/archivist/layout.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type tree = Root | State_home | Anchored_text_dir

let tree_value = function
  | (Root : tree) -> "root"
  | (State_home : tree) -> "stateHome"
  | (Anchored_text_dir : tree) -> "anchoredTextDir"

let tree_json v = `String (tree_value v)

type event_stream = { tree : tree; path : string }

let event_stream_json (r : event_stream) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("tree", tree_json r.tree);
         Option.Some ("path", (fun s -> `String s) r.path);
       ])

type system_stream = { tree : tree; path : string }

let system_stream_json (r : system_stream) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("tree", tree_json r.tree);
         Option.Some ("path", (fun s -> `String s) r.path);
       ])

type event_file = { name : string; digits : int; first : int; max_events : int }

let event_file_json (r : event_file) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("digits", (fun n -> `Int n) r.digits);
         Option.Some ("first", (fun n -> `Int n) r.first);
         Option.Some ("maxEvents", (fun n -> `Int n) r.max_events);
       ])

type view = { tree : tree; path : string; schema : Yojson.Safe.t }

let view_json (r : view) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("tree", tree_json r.tree);
         Option.Some ("path", (fun s -> `String s) r.path);
         Option.Some ("schema", Fun.id r.schema);
       ])

type files_item = { name : string; schema : Yojson.Safe.t }

let files_item_json (r : files_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("schema", Fun.id r.schema);
       ])

type system_projections = {
  tree : tree;
  path : string;
  files : files_item list;
}

let system_projections_json (r : system_projections) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("tree", tree_json r.tree);
         Option.Some ("path", (fun s -> `String s) r.path);
         Option.Some
           ("files", (fun l -> `List (List.map files_item_json l)) r.files);
       ])

type storage_uri_index = { tree : tree; path : string; schema : Yojson.Safe.t }

let storage_uri_index_json (r : storage_uri_index) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("tree", tree_json r.tree);
         Option.Some ("path", (fun s -> `String s) r.path);
         Option.Some ("schema", Fun.id r.schema);
       ])

type anchored_text_entry = {
  tree : tree;
  path : string;
  schema : Yojson.Safe.t;
}

let anchored_text_entry_json (r : anchored_text_entry) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("tree", tree_json r.tree);
         Option.Some ("path", (fun s -> `String s) r.path);
         Option.Some ("schema", Fun.id r.schema);
       ])

type anchored_text_stamp = { tree : tree; path : string }

let anchored_text_stamp_json (r : anchored_text_stamp) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("tree", tree_json r.tree);
         Option.Some ("path", (fun s -> `String s) r.path);
       ])

type t = {
  comment : string;
  event_stream : event_stream;
  system_stream : system_stream;
  event_file : event_file;
  stored_event : Yojson.Safe.t;
  view : view;
  system_projections : system_projections;
  storage_uri_index : storage_uri_index;
  anchored_text_entry : anchored_text_entry;
  anchored_text_stamp : anchored_text_stamp;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some ("eventStream", event_stream_json r.event_stream);
         Option.Some ("systemStream", system_stream_json r.system_stream);
         Option.Some ("eventFile", event_file_json r.event_file);
         Option.Some ("storedEvent", Fun.id r.stored_event);
         Option.Some ("view", view_json r.view);
         Option.Some
           ("systemProjections", system_projections_json r.system_projections);
         Option.Some
           ("storageUriIndex", storage_uri_index_json r.storage_uri_index);
         Option.Some
           ("anchoredTextEntry", anchored_text_entry_json r.anchored_text_entry);
         Option.Some
           ("anchoredTextStamp", anchored_text_stamp_json r.anchored_text_stamp);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for where the Archivist keeps the record on disk \
        (ARCHIVIST.md \194\167 The record on disk), as far as a reader of its \
        files needs it: each file's tree, `root` (the working tree), \
        `stateHome` (the state directory) or `anchoredTextDir` (the \
        anchored-text store), and its path in that tree. A path's \
        `{resourceId}` is the resource's id, `{uriHash}` the SHA-256 of a \
        storage URI's UTF-8 bytes in lowercase hex, `{contentChecksum}` a \
        content checksum, and its `{shard}` the two-level shard, `<ab>/<cd>`, \
        of the key the file is filed by (the resource id, the URI, or the \
        checksum), as archivist/shard-cases.json states the arithmetic. A \
        stream is a directory of event files, named by `eventFile`, numbered \
        from `first` in `digits` decimal digits, each holding at most \
        `maxEvents` events, the next event opening the next file; each line of \
        one is a stored event, compact JSON ended by a single newline, as \
        `storedEvent` names it. A resource's view is JSON indented by two \
        spaces, as `view.schema` names it, and so is each projection of what \
        the `__system__` stream adds up to, as its `schema` names it, and each \
        entry of the storage-uri index, as `storageUriIndex.schema` names it; \
        a projection file that is absent reads as empty. An anchored-text \
        entry is compact JSON, as `anchoredTextEntry.schema` names it. The \
        stamp its entries are taken under is the file `anchoredTextStamp`: the \
        stamp alone, as AnchoredTextStamp's `stamp` is, followed by a newline.";
     event_stream =
       ({ tree = (Root : tree); path = ".xynolog/events/{shard}/{resourceId}" }
         : event_stream);
     system_stream =
       ({ tree = (Root : tree); path = ".xynolog/events/__system__" }
         : system_stream);
     event_file =
       ({
          name = "events-{number}.jsonl";
          digits = 6;
          first = 1;
          max_events = 10000;
        }
         : event_file);
     stored_event =
       `Assoc
         [
           ( "$ref",
             `String "https://xynolog.org/protocol/StoredEventResponse.json" );
         ];
     view =
       ({
          tree = (State_home : tree);
          path = "resources/{shard}/{resourceId}.json";
          schema =
            `Assoc
              [
                ( "$ref",
                  `String "https://xynolog.org/protocol/ResourceView.json" );
              ];
        }
         : view);
     system_projections =
       ({
          tree = (State_home : tree);
          path = "projections/__system__";
          files =
            [
              ({
                 name = "entitytypes.json";
                 schema =
                   `Assoc
                     [
                       ( "$ref",
                         `String
                           "https://xynolog.org/protocol/EntityTypesProjection.json"
                       );
                     ];
               }
                : files_item);
              ({
                 name = "tagschemas.json";
                 schema =
                   `Assoc
                     [
                       ( "$ref",
                         `String
                           "https://xynolog.org/protocol/TagSchemasProjection.json"
                       );
                     ];
               }
                : files_item);
              ({
                 name = "profiles.json";
                 schema =
                   `Assoc
                     [
                       ( "$ref",
                         `String
                           "https://xynolog.org/protocol/ProfilesProjection.json"
                       );
                     ];
               }
                : files_item);
            ];
        }
         : system_projections);
     storage_uri_index =
       ({
          tree = (State_home : tree);
          path = "projections/storage-uri/{shard}/{uriHash}.json";
          schema =
            `Assoc
              [
                ( "$ref",
                  `String "https://xynolog.org/protocol/StorageUriEntry.json" );
              ];
        }
         : storage_uri_index);
     anchored_text_entry =
       ({
          tree = (Anchored_text_dir : tree);
          path = "{shard}/{contentChecksum}.json";
          schema =
            `Assoc
              [
                ( "$ref",
                  `String "https://xynolog.org/protocol/AnchoredTextEntry.json"
                );
              ];
        }
         : anchored_text_entry);
     anchored_text_stamp =
       ({ tree = (Anchored_text_dir : tree); path = "STAMP" }
         : anchored_text_stamp);
   }
    : t)
