(* Generated from protocol/specs/src/smelter/messages.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type refusals_item = {
  name : string;
  operation : string;
  situation : string;
  message : string;
}

let refusals_item_json (r : refusals_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("operation", (fun s -> `String s) r.operation);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("message", (fun s -> `String s) r.message);
       ])

type log_level = Error | Warn | Info | Http | Debug

let log_level_value = function
  | (Error : log_level) -> "error"
  | (Warn : log_level) -> "warn"
  | (Info : log_level) -> "info"
  | (Http : log_level) -> "http"
  | (Debug : log_level) -> "debug"

let log_level_json v = `String (log_level_value v)

type logged_item = {
  name : string;
  level : log_level;
  situation : string;
  message : string;
  fields : (string * string) list;
  carries : string list;
}

let logged_item_json (r : logged_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("level", log_level_json r.level);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("message", (fun s -> `String s) r.message);
         Option.Some
           ( "fields",
             (fun l ->
               `Assoc (List.map (fun (k, v) -> (k, (fun s -> `String s) v)) l))
               r.fields );
         Option.Some
           ( "carries",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.carries );
       ])

type t = {
  comment : string;
  refusals : refusals_item list;
  logged : logged_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ( "refusals",
             (fun l -> `List (List.map refusals_item_json l)) r.refusals );
         Option.Some
           ("logged", (fun l -> `List (List.map logged_item_json l)) r.logged);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for the words of the Smelter's refusals and of the messages \
        it logs that a reader of its output relies on (SMELTER.md), word for \
        word. A text's `{name}` is filled as the row's `situation` says, and \
        nothing else in it varies. `refusals` is each refusal of an operation, \
        the `message` of its failure. `logged` is each message the Smelter \
        logs, at its `level`, with the facts named in `fields`, each of the \
        form given, and the facts named in `carries` beside them.";
     refusals =
       [
         ({
            name = "rebuild-incomplete";
            operation = "smelt:rebuild-anchors";
            situation =
              "A rebuild of anchored text that could not do every resource it \
               set out to (SMELTER.md \194\167 Rebuild): `{failed}` is how \
               many it could not do, and `{total}` how many it set out to do, \
               each in decimal digits.";
            message =
              "{failed} of {total} resources failed to re-anchor: see the \
               Smelter's log";
          }
           : refusals_item);
       ];
     logged =
       [
         ({
            name = "not-indexed";
            level = (Warn : log_level);
            situation =
              "A resource the Smelter decided not to index (SMELTER.md \
               \194\167 What it decides): `{resourceId}` is the resource, \
               `{reason}` the `reason` its `smelt:settled` carries, \
               `{mediaType}` the media type its bytes were read as, and \
               `{checksum}` the checksum of those bytes.";
            message = "Smelter did not index resource";
            fields =
              [
                ("resourceId", "{resourceId}");
                ("reason", "{reason}");
                ("contentType", "{mediaType}");
                ("contentChecksum", "{checksum}");
              ];
            carries = [];
          }
           : logged_item);
         ({
            name = "content-unread";
            level = (Warn : log_level);
            situation =
              "A resource whose bytes the Smelter could not read (SMELTER.md \
               \194\167 What it decides): `{resourceId}` is the resource. \
               `error` says why.";
            message = "Smelter could not read resource content";
            fields = [ ("resourceId", "{resourceId}") ];
            carries = [ "error" ];
          }
           : logged_item);
         ({
            name = "event-failed";
            level = (Error : log_level);
            situation =
              "An event the Smelter could not apply because its embedding \
               provider failed a request (SMELTER.md \194\167 The embedding \
               provider): `{resourceId}` is the event's resource, `{provider}` \
               the provider's `type` (EmbeddingConfig), `{model}` the model it \
               was asked for, and `{status}` the status it answered with. \
               `slice` is which request of the batch it was, and `error` says \
               why.";
            message = "Smelter failed to process event";
            fields =
              [
                ("resourceId", "{resourceId}");
                ("provider", "{provider}");
                ("model", "{model}");
                ("status", "{status}");
              ];
            carries = [ "slice"; "error" ];
          }
           : logged_item);
       ];
   }
    : t)
