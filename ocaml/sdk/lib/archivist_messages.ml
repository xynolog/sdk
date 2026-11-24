(* Generated from protocol/specs/src/archivist/messages.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type boot_item = { name : string; situation : string; refusal : string }

let boot_item_json (r : boot_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("refusal", (fun s -> `String s) r.refusal);
       ])

type unsent_item = { name : string; situation : string; message : string }

let unsent_item_json (r : unsent_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("message", (fun s -> `String s) r.message);
       ])

type command_error_code =
  | Peer_unavailable
  | Not_found
  | Unauthorized
  | None_pending

let command_error_code_value = function
  | (Peer_unavailable : command_error_code) -> "peer-unavailable"
  | (Not_found : command_error_code) -> "not-found"
  | (Unauthorized : command_error_code) -> "unauthorized"
  | (None_pending : command_error_code) -> "none-pending"

let command_error_code_json v = `String (command_error_code_value v)

type refusals_item = {
  name : string;
  operations : string list;
  code : command_error_code option;
  situation : string;
  message : string;
}

let refusals_item_json (r : refusals_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some
           ( "operations",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.operations );
         Option.map (fun v -> ("code", command_error_code_json v)) r.code;
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("message", (fun s -> `String s) r.message);
       ])

type unauthorized = {
  status : int;
  error : string;
  presented : string;
  absent : string;
}

let unauthorized_json (r : unauthorized) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("status", (fun n -> `Int n) r.status);
         Option.Some ("error", (fun s -> `String s) r.error);
         Option.Some ("presented", (fun s -> `String s) r.presented);
         Option.Some ("absent", (fun s -> `String s) r.absent);
       ])

type method_ = G_e_t | P_u_t | P_o_s_t

let method__value = function
  | (G_e_t : method_) -> "GET"
  | (P_u_t : method_) -> "PUT"
  | (P_o_s_t : method_) -> "POST"

let method__json v = `String (method__value v)

type http_item = {
  name : string;
  method_ : method_;
  route : string;
  status : int;
  code : string option;
  situation : string;
  error : string;
}

let http_item_json (r : http_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("method", method__json r.method_);
         Option.Some ("route", (fun s -> `String s) r.route);
         Option.Some ("status", (fun n -> `Int n) r.status);
         Option.map (fun v -> ("code", (fun s -> `String s) v)) r.code;
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("error", (fun s -> `String s) r.error);
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
       ])

type t = {
  comment : string;
  boot : boot_item list;
  unsent : unsent_item list;
  refusals : refusals_item list;
  unauthorized : unauthorized;
  http : http_item list;
  logged : logged_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("boot", (fun l -> `List (List.map boot_item_json l)) r.boot);
         Option.Some
           ("unsent", (fun l -> `List (List.map unsent_item_json l)) r.unsent);
         Option.Some
           ( "refusals",
             (fun l -> `List (List.map refusals_item_json l)) r.refusals );
         Option.Some ("unauthorized", unauthorized_json r.unauthorized);
         Option.Some
           ("http", (fun l -> `List (List.map http_item_json l)) r.http);
         Option.Some
           ("logged", (fun l -> `List (List.map logged_item_json l)) r.logged);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for the words of the Archivist's own refusals and of the \
        messages it logs that a reader of its output relies on (ARCHIVIST.md), \
        word for word. A text's `{name}` is filled as the row's `situation` \
        says, and nothing else in it varies. `boot` is each refusal to start \
        of the Archivist's own, beside the document and account refusals of \
        service-environment/boot-refusals.json: written in that table's \
        `line`, once, to stderr, before it exits with that table's `exitCode`; \
        unlike those, these name what the Archivist was pointed at, the \
        gateway and the working tree. `unsent` is the failure a reply that \
        cannot be sent is answered with instead, on the operation's failure \
        channel. `refusals` is each refusal of an operation, the `message` of \
        its failure, and its `code` where it carries one; `{channel}` is the \
        operation's request channel. `unauthorized` is the refusal of every \
        route of the HTTP surface but `/health`. `http` is each other error a \
        route answers with: its status and the body's `error`, and its `code` \
        where the body carries one. `logged` is each message the Archivist \
        logs, at its `level`, with the fields named in `fields`, each of the \
        form given.";
     boot =
       [
         ({
            name = "no-project-file";
            situation =
              "The working tree commits no `.xynolog/config.yaml`, so it \
               declares no `site.domain` (step 3).";
            refusal =
              "The knowledge base commits no .xynolog/config.yaml, so declares \
               no site.domain: it is the identity this knowledge base acts \
               under, and the audience it accepts tokens for";
          }
           : boot_item);
         ({
            name = "not-a-checkout";
            situation =
              "The project file says `git.sync` is true, and git cannot be run \
               in the root or says it is not inside a work tree (step 6): \
               `{root}` is the document's `root`, and `{why}` git's or the \
               system's reason, which varies.";
            refusal =
              "The knowledge base's project file says git.sync is true, and \
               {root} is not a git checkout ({why}). Make it one (git init), \
               or set git.sync to false.";
          }
           : boot_item);
         ({
            name = "gateway-silent";
            situation =
              "The gateway does not answer its protected-resource metadata \
               (step 5): `{gateway}` is the document's `gatewayUrl`, and \
               `{reason}` why, which varies.";
            refusal =
              "The gateway at {gateway} did not say which knowledge base it \
               serves (/.well-known/oauth-protected-resource): {reason}";
          }
           : boot_item);
         ({
            name = "gateway-elsewhere";
            situation =
              "The gateway serves another knowledge base than the tree (step \
               5): `{gateway}` is the document's `gatewayUrl`, `{served}` the \
               `resource` its metadata names, `{root}` the document's `root`, \
               `{tree}` the tree's audience (`https://<domain>`, each `:` \
               written `/`), and `{did}` the tree's DID.";
            refusal =
              "The gateway at {gateway} serves {served}, and the tree at \
               {root} is {tree} ({did})";
          }
           : boot_item);
       ];
     unsent =
       [
         ({
            name = "too-large";
            situation =
              "A reply whose JSON is larger than a bus message may be: \
               `{bytes}` is its size in bytes, and `{maxBodyBytes}` `POST \
               /bus/emit`'s `x-xynolog-limits.maxBodyBytes` in the gateway's \
               API.";
            message =
              "The answer could not be sent: it is {bytes} bytes, and a bus \
               message may be {maxBodyBytes}";
          }
           : unsent_item);
         ({
            name = "not-sent";
            situation =
              "Any other reply that cannot be sent, once the transport gives \
               up: `{why}` is why, which varies.";
            message = "The answer could not be sent: {why}";
          }
           : unsent_item);
       ];
     refusals =
       [
         ({
            name = "uncited-worker";
            operations = [ "yield:create"; "mark:commit" ];
            code = None;
            situation =
              "A sender holding the worker role whose command cites no `jobId`.";
            message =
              "{channel} refused: a worker-role emitter must cite the job it \
               fulfils in `jobId`";
          }
           : refusals_item);
         ({
            name = "unassigned-job";
            operations = [ "yield:create"; "mark:commit" ];
            code = None;
            situation =
              "A command citing a job that the log of the resource it is \
               checked against holds no `job:assigned` of, and that did not \
               make the resource: `{jobId}` is the cited job, and \
               `{resourceId}` that resource.";
            message =
              "{channel} refused: cites job {jobId}, but the log of \
               {resourceId} holds no assignment of it, and the job did not \
               make it";
          }
           : refusals_item);
         ({
            name = "not-the-holder";
            operations = [ "yield:create"; "mark:commit" ];
            code = None;
            situation =
              "A command citing a job whose recorded holder is not its sender: \
               `{jobId}` is the cited job, `{holder}` the assignment's \
               `holder` or the sender of the `yield:created` the job made, and \
               `{writer}` the command's sender.";
            message =
              "{channel} refused: job {jobId}'s recorded holder is {holder}, \
               not the writer {writer}";
          }
           : refusals_item);
         ({
            name = "sourceless-create";
            operations = [ "yield:create" ];
            code = None;
            situation =
              "A `yield:create` that cites a job and names no \
               `generatedFrom.resourceId`.";
            message =
              "yield:create refused: a create citing a job must name the \
               source resource its job was assigned on \
               (generatedFrom.resourceId)";
          }
           : refusals_item);
         ({
            name = "multi-agent-create";
            operations = [ "yield:create" ];
            code = None;
            situation = "A `yield:create` whose `generator` is a list.";
            message =
              "yield:create refused: a multi-agent generator is not supported; \
               derivation binds one generator to the executor";
          }
           : refusals_item);
         ({
            name = "generator-not-executor";
            operations = [ "yield:create"; "mark:commit" ];
            code = None;
            situation =
              "A supplied generator that is not the command's sender: \
               `{generator}` is the generator's `@id`, and `{executor}` the \
               sender.";
            message =
              "{channel} refused: generator {generator} is not the executor \
               {executor}";
          }
           : refusals_item);
         ({
            name = "executor-not-software";
            operations = [ "yield:create"; "mark:commit" ];
            code = None;
            situation =
              "A supplied generator from a sender that is not software: \
               `{executor}` is the sender.";
            message =
              "{channel} refused: a generator was supplied, but the executor \
               {executor} is not software";
          }
           : refusals_item);
         ({
            name = "annotation-with-creator";
            operations = [ "mark:commit" ];
            code = None;
            situation =
              "An annotation that arrives with a `creator`: `{annotationId}` \
               is its `id`.";
            message =
              "{channel} refused: `creator` on annotation {annotationId} is \
               derived by the knowledge base, never sent";
          }
           : refusals_item);
         ({
            name = "multi-agent-annotation";
            operations = [ "mark:commit" ];
            code = None;
            situation =
              "An annotation whose `generator` is a list: `{annotationId}` is \
               its `id`.";
            message =
              "{channel} refused: annotation {annotationId} carries a \
               multi-agent generator; derivation binds one generator to the \
               executor";
          }
           : refusals_item);
         ({
            name = "not-annotatable";
            operations = [ "mark:create-request" ];
            code = None;
            situation =
              "A target whose resource's content cannot be annotated: \
               `{mediaType}` is its media type.";
            message = "\"{mediaType}\" cannot be annotated";
          }
           : refusals_item);
         ({
            name = "storage-uri-scheme";
            operations =
              [
                "yield:create";
                "yield:clone-persist";
                "yield:update";
                "yield:clone-create";
                "mark:archive";
                "mark:unarchive";
              ];
            code = None;
            situation =
              "A storage URI that does not begin `file://`: `{uri}` is the URI.";
            message = "Invalid storage URI (must start with file://): {uri}";
          }
           : refusals_item);
         ({
            name = "storage-uri-outside";
            operations =
              [
                "yield:create";
                "yield:clone-persist";
                "yield:update";
                "yield:clone-create";
                "mark:archive";
                "mark:unarchive";
              ];
            code = None;
            situation =
              "A storage URI naming a place outside the working tree: `{uri}` \
               is the URI.";
            message =
              "Invalid storage URI (must name a file inside the working tree): \
               {uri}";
          }
           : refusals_item);
         ({
            name = "checksum-mismatch";
            operations =
              [
                "yield:create";
                "yield:clone-persist";
                "yield:update";
                "yield:clone-create";
              ];
            code = None;
            situation =
              "Content registered whose file is not the checksum expected: \
               `{uri}` is the URI, `{expected}` the first 8 characters of the \
               checksum expected, and `{actual}` the first 8 of the file's.";
            message =
              "Checksum mismatch for {uri}: expected {expected}... but got \
               {actual}...\n\
               The file on disk differs from the recorded checksum. Has it \
               been modified since staging?";
          }
           : refusals_item);
         ({
            name = "unarchive-without-file";
            operations = [ "mark:unarchive" ];
            code = None;
            situation =
              "A `mark:unarchive` naming a storage URI with no file at it: \
               `{uri}` is the URI.";
            message = "Cannot unarchive: file not found at {uri}";
          }
           : refusals_item);
         ({
            name = "entity-type-not-registered";
            operations = [ "mark:update-entity-types" ];
            code = None;
            situation =
              "Types to add that are not in the vocabulary: `{types}` is each \
               that is not, in the order the command names them, joined by `, \
               `.";
            message = "Entity type not registered: {types}";
          }
           : refusals_item);
         ({
            name = "resource-not-found";
            operations = [ "browse:resource-requested" ];
            code = Some (Not_found : command_error_code);
            situation = "A resource with no events.";
            message = "Resource not found";
          }
           : refusals_item);
         ({
            name = "annotation-not-found";
            operations =
              [
                "browse:annotation-requested";
                "browse:annotation-history-requested";
              ];
            code = None;
            situation = "An annotation the resource's view does not hold.";
            message = "Annotation not found";
          }
           : refusals_item);
         ({
            name = "path-escapes";
            operations = [ "browse:directory-requested" ];
            code = None;
            situation = "A path outside the working tree.";
            message = "path escapes project root";
          }
           : refusals_item);
         ({
            name = "path-not-found";
            operations = [ "browse:directory-requested" ];
            code = None;
            situation = "A path of the working tree that is not there.";
            message = "path not found";
          }
           : refusals_item);
         ({
            name = "clone-source-not-found";
            operations = [ "yield:clone-token-requested" ];
            code = None;
            situation = "A token asked for a resource with no view.";
            message = "Resource not found";
          }
           : refusals_item);
         ({
            name = "clone-content-not-found";
            operations = [ "yield:clone-token-requested" ];
            code = None;
            situation =
              "A token asked for a resource whose content is not in the \
               working tree.";
            message = "Resource content not found";
          }
           : refusals_item);
         ({
            name = "invalid-token";
            operations =
              [ "yield:clone-resource-requested"; "yield:clone-create" ];
            code = None;
            situation =
              "A token the Archivist did not issue, or has forgotten or spent.";
            message = "Invalid or expired token";
          }
           : refusals_item);
         ({
            name = "token-expired";
            operations =
              [ "yield:clone-resource-requested"; "yield:clone-create" ];
            code = None;
            situation = "A token issued more than fifteen minutes before.";
            message = "Token expired";
          }
           : refusals_item);
         ({
            name = "token-source-not-found";
            operations =
              [ "yield:clone-resource-requested"; "yield:clone-create" ];
            code = None;
            situation = "A token whose resource is no longer held.";
            message = "Source resource not found";
          }
           : refusals_item);
       ];
     unauthorized =
       ({
          status = 401;
          error = "unauthorized";
          presented = "Bearer error=\"invalid_token\"";
          absent = "Bearer";
        }
         : unauthorized);
     http =
       [
         ({
            name = "stream-listing-failed";
            method_ = (G_e_t : method_);
            route = "/events";
            status = 500;
            code = None;
            situation = "A listing of the log's streams that failed.";
            error = "stream listing failed";
          }
           : http_item);
         ({
            name = "events-bad-request";
            method_ = (G_e_t : method_);
            route = "/events/{resourceId}";
            status = 400;
            code = None;
            situation =
              "A `fromSequence` that is not an integer of at least 1 in \
               decimal digits, or an id that is not one.";
            error =
              "resourceId path segment and integer fromSequence >= 1 are \
               required";
          }
           : http_item);
         ({
            name = "event-read-failed";
            method_ = (G_e_t : method_);
            route = "/events/{resourceId}";
            status = 500;
            code = None;
            situation = "A read of the stream that failed.";
            error = "event read failed";
          }
           : http_item);
         ({
            name = "content-read-failed";
            method_ = (G_e_t : method_);
            route = "/resources/{id}/content";
            status = 500;
            code = None;
            situation = "A file missing from the working tree.";
            error = "content read failed";
          }
           : http_item);
         ({
            name = "content-no-resource";
            method_ = (G_e_t : method_);
            route = "/resources/{id}/content";
            status = 404;
            code = Some "resource";
            situation = "No view of the resource: `{id}` is the path's id.";
            error = "Resource not found: {id}";
          }
           : http_item);
         ({
            name = "content-no-representation";
            method_ = (G_e_t : method_);
            route = "/resources/{id}/content";
            status = 404;
            code = Some "representation";
            situation = "A view with no storage URI: `{id}` is the path's id.";
            error = "Resource representation not found: no storageUri for {id}";
          }
           : http_item);
         ({
            name = "jsonld-not-found";
            method_ = (G_e_t : method_);
            route = "/resources/{id}/jsonld";
            status = 404;
            code = None;
            situation = "A resource with no events.";
            error = "Resource not found";
          }
           : http_item);
         ({
            name = "annotations-not-found";
            method_ = (G_e_t : method_);
            route = "/resources/{id}/annotations";
            status = 404;
            code = None;
            situation = "No view of the resource, or an id that is not one.";
            error = "Resource not found";
          }
           : http_item);
         ({
            name = "anchored-text-read-failed";
            method_ = (G_e_t : method_);
            route = "/resources/{id}/anchored-text";
            status = 500;
            code = None;
            situation = "A read of the store that failed.";
            error = "anchored-text read failed";
          }
           : http_item);
         ({
            name = "anchored-text-not-a-write";
            method_ = (P_u_t : method_);
            route = "/resources/{id}/anchored-text";
            status = 400;
            code = None;
            situation =
              "A body that is not an AnchoredTextWrite: `{why}` is why, which \
               varies.";
            error = "The body is no AnchoredTextWrite: {why}";
          }
           : http_item);
         ({
            name = "anchored-text-write-not-found";
            method_ = (P_u_t : method_);
            route = "/resources/{id}/anchored-text";
            status = 404;
            code = None;
            situation = "No view of the resource, or an id that is not one.";
            error = "Resource not found";
          }
           : http_item);
         ({
            name = "anchored-text-stored-not-found";
            method_ = (G_e_t : method_);
            route = "/resources/{id}/anchored-text/stored";
            status = 404;
            code = None;
            situation = "No view of the resource, or an id that is not one.";
            error = "Resource not found";
          }
           : http_item);
         ({
            name = "anchored-text-no-entry";
            method_ = (G_e_t : method_);
            route = "/resources/{id}/anchored-text/stored";
            status = 404;
            code = None;
            situation =
              "No entry stored for the resource's content under the stamp \
               stated.";
            error = "No entry is stored for this content";
          }
           : http_item);
         ({
            name = "upload-unattributed";
            method_ = (P_o_s_t : method_);
            route = "/resources";
            status = 400;
            code = None;
            situation = "An upload without `Xynolog-Principal`.";
            error =
              "Xynolog-Principal is required: the record attributes every \
               resource to someone";
          }
           : http_item);
         ({
            name = "upload-not-multipart";
            method_ = (P_o_s_t : method_);
            route = "/resources";
            status = 400;
            code = None;
            situation = "A body that is not `multipart/form-data`.";
            error = "The body is not multipart/form-data";
          }
           : http_item);
         ({
            name = "upload-unsupported-media";
            method_ = (P_o_s_t : method_);
            route = "/resources";
            status = 400;
            code = None;
            situation =
              "A `format` whose media type is not one Xynolog knows: `{type}` \
               is the media type.";
            error = "Unsupported media type: {type}";
          }
           : http_item);
         ({
            name = "upload-key-reused";
            method_ = (P_o_s_t : method_);
            route = "/resources";
            status = 422;
            code = None;
            situation =
              "An `Idempotency-Key` whose resource was recorded from other \
               fields or other bytes, a copy's key sent with no clone token, \
               or a new resource's sent with one.";
            error =
              "This Idempotency-Key names a resource recorded from other \
               fields or other bytes";
          }
           : http_item);
         ({
            name = "upload-refused";
            method_ = (P_o_s_t : method_);
            route = "/resources";
            status = 500;
            code = None;
            situation =
              "A record that is refused: `{refusal}` is the refusal's message, \
               as `refusals` states it for `yield:create`, or \
               `yield:clone-create` with a clone token.";
            error = "{refusal}";
          }
           : http_item);
       ];
     logged =
       [
         ({
            name = "not-an-event";
            level = (Warn : log_level);
            situation =
              "A line of the log that is not an event, found when the views \
               are rebuilt: `{path}` is its event file's path, and `{line}` \
               its line number, counted from 1.";
            message = "The event log holds something that is not an event";
            fields = [ ("what", "{path} line {line} is not an event") ];
          }
           : logged_item);
         ({
            name = "generated-not-linked";
            level = (Warn : log_level);
            situation =
              "A generated resource recorded, whose link from the annotation \
               it was generated for could not be recorded.";
            message = "A generated resource was not linked from its annotation";
            fields = [];
          }
           : logged_item);
         ({
            name = "completion-of-another-verb";
            level = (Warn : log_level);
            situation =
              "A `job:complete` whose `jobType` is not the one the stream \
               records for the job, which is not recorded.";
            message = "job:complete of another verb than the job's";
            fields = [];
          }
           : logged_item);
       ];
   }
    : t)
