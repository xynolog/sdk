(* Generated from protocol/specs/src/gateway/messages.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type messages_item = {
  name : string;
  status : int;
  code : string option;
  situation : string;
  error : string;
  hint : string option;
}

let messages_item_json (r : messages_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("status", (fun n -> `Int n) r.status);
         Option.map (fun v -> ("code", (fun s -> `String s) v)) r.code;
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("error", (fun s -> `String s) r.error);
         Option.map (fun v -> ("hint", (fun s -> `String s) v)) r.hint;
       ])

type failures_item = {
  name : string;
  code : string;
  situation : string;
  message : string;
}

let failures_item_json (r : failures_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("code", (fun s -> `String s) r.code);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("message", (fun s -> `String s) r.message);
       ])

type challenges = { no_credential : string; refused : string }

let challenges_json (r : challenges) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("noCredential", (fun s -> `String s) r.no_credential);
         Option.Some ("refused", (fun s -> `String s) r.refused);
       ])

type t = {
  comment : string;
  messages : messages_item list;
  failures : failures_item list;
  challenges : challenges;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ( "messages",
             (fun l -> `List (List.map messages_item_json l)) r.messages );
         Option.Some
           ( "failures",
             (fun l -> `List (List.map failures_item_json l)) r.failures );
         Option.Some ("challenges", challenges_json r.challenges);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for the words of the gateway's own refusals \
        (TRANSPORT-HTTP.md \194\167 Errors): for each situation it refuses a \
        request in itself, the status, the ErrorResponse's (or LimitRefusal's) \
        `error`, and its `code` and `hint` where it carries them, word for \
        word. A refusal the gateway relays from the Archivist carries the \
        Archivist's words, not these, and a refusal of one of these situations \
        carries no other text. A text's `{name}` is filled as the row's \
        `situation` says. What the gateway logs of a refusal is its own: a \
        refused token is told only that it was refused, and its log says why. \
        `failures` is each failure frame the gateway delivers itself on the \
        stream of the client whose request it answers, in place of an answer \
        nobody can give. `challenges` is the `WWW-Authenticate` of each 401, \
        in the form the Unauthorized response states; a 429 that replaces a \
        401 carries none.";
     messages =
       [
         ({
            name = "no-credential";
            status = 401;
            code = None;
            situation =
              "A protected operation, asked with no credential: no \
               `Authorization` header, a scheme that is not `Bearer`, a \
               `Bearer` with no token, or a media token anywhere it is not \
               accepted.";
            error = "Unauthorized";
            hint =
              Some
                "Authentication required: send an `Authorization: Bearer \
                 <token>` header. A raw browser navigation to a protected \
                 resource is unauthenticated.";
          }
           : messages_item);
         ({
            name = "refused-token";
            status = 401;
            code = None;
            situation = "A bearer token the gateway does not accept.";
            error = "Invalid token";
            hint = None;
          }
           : messages_item);
         ({
            name = "refused-media-token";
            status = 401;
            code = None;
            situation =
              "A media token `GET /api/resources/{id}` does not accept: \
               expired, of another knowledge base, of another resource, or not \
               one.";
            error = "Invalid media token";
            hint = None;
          }
           : messages_item);
         ({
            name = "refusal-rate";
            status = 429;
            code = Some "refusal-rate";
            situation =
              "Any of the 401s above, once the refusals its holder has had \
               have used their allowance.";
            error =
              "The credential was refused, and its holder's refused requests \
               have used their allowance";
            hint = None;
          }
           : messages_item);
         ({
            name = "not-json";
            status = 400;
            code = None;
            situation =
              "An operation whose body is JSON, given one that is not.";
            error = "The body is not JSON";
            hint = None;
          }
           : messages_item);
         ({
            name = "no-idempotency-key";
            status = 400;
            code = None;
            situation =
              "An operation that requires an `Idempotency-Key`, asked without \
               one.";
            error = "The request carries no Idempotency-Key";
            hint = None;
          }
           : messages_item);
         ({
            name = "idempotency-key-not-text";
            status = 400;
            code = None;
            situation =
              "An `Idempotency-Key` with a character that is not visible ASCII.";
            error =
              "The Idempotency-Key is not text: only visible ASCII characters";
            hint = None;
          }
           : messages_item);
         ({
            name = "idempotency-key-length";
            status = 400;
            code = None;
            situation =
              "An `Idempotency-Key` shorter or longer than its parameter \
               allows: `{minLength}` and `{maxLength}` are its schema's.";
            error =
              "The Idempotency-Key must be {minLength} to {maxLength} \
               characters";
            hint = None;
          }
           : messages_item);
         ({
            name = "unknown-channel";
            status = 400;
            code = None;
            situation =
              "An emit on a channel the bus registry does not register: \
               `{channel}` is the one it named.";
            error = "Unknown channel: {channel}";
            hint = None;
          }
           : messages_item);
         ({
            name = "invalid-payload";
            status = 400;
            code = None;
            situation =
              "An emit whose payload its channel's schema refuses: `{channel}` \
               is the channel, and `{problems}` each refusal, as `<the \
               member's JSON Pointer, or root>: <the refusal>`, joined by `; \
               `.";
            error = "Invalid payload for {channel}: {problems}";
            hint = None;
          }
           : messages_item);
         ({
            name = "correlation-without-client";
            status = 400;
            code = None;
            situation =
              "An emit that carries a `correlationId` and no `clientId`: \
               `{channel}` is its channel.";
            error =
              "clientId is required to emit {channel} with a correlationId";
            hint = None;
          }
           : messages_item);
         ({
            name = "no-subscription";
            status = 400;
            code = None;
            situation =
              "A subscription with no global channel and no scoped entry.";
            error = "At least one global channel or scoped entry is required";
            hint = None;
          }
           : messages_item);
         ({
            name = "duplicate-scope";
            status = 400;
            code = None;
            situation =
              "A subscription whose `scoped` names one scope twice: `{scope}` \
               is that scope.";
            error = "duplicate scope \"{scope}\" in matrix";
            hint = None;
          }
           : messages_item);
         ({
            name = "not-found";
            status = 404;
            code = None;
            situation =
              "A path the gateway does not serve, or a method a path it serves \
               does not take.";
            error = "Not found";
            hint = None;
          }
           : messages_item);
         ({
            name = "resource-not-found";
            status = 404;
            code = None;
            situation =
              "A resource the knowledge base does not hold: an `{id}` that is \
               no ResourceId, one the Archivist holds no view of, or one whose \
               bytes the Archivist answers it does not hold the resource of.";
            error = "Resource not found";
            hint = None;
          }
           : messages_item);
         ({
            name = "representation-not-found";
            status = 404;
            code = None;
            situation =
              "A resource the knowledge base holds, whose bytes the Archivist \
               answers it does not hold.";
            error = "Resource representation not found";
            hint = None;
          }
           : messages_item);
         ({
            name = "correlation-claimed";
            status = 409;
            code = None;
            situation =
              "An emit whose `correlationId` another client has claimed: \
               `{correlationId}` is it.";
            error = "correlationId {correlationId} is already claimed";
            hint = None;
          }
           : messages_item);
         ({
            name = "too-large";
            status = 413;
            code = None;
            situation =
              "A body larger than its operation's `maxBodyBytes`, which \
               `{maxBodyBytes}` is.";
            error =
              "The body is larger than {maxBodyBytes} bytes, this operation's \
               maxBodyBytes";
            hint = None;
          }
           : messages_item);
         ({
            name = "idempotency-key-reused";
            status = 422;
            code = Some "unprocessable";
            situation =
              "An emit sent again under its `Idempotency-Key` with another \
               body.";
            error = "This Idempotency-Key was first sent with another body";
            hint = None;
          }
           : messages_item);
         ({
            name = "emit-rate";
            status = 429;
            code = Some "emit-rate";
            situation = "An emit past its principal's emit-rate bucket.";
            error = "This principal's emits have used its bucket";
            hint = None;
          }
           : messages_item);
         ({
            name = "unanswered-requests";
            status = 429;
            code = Some "unanswered-requests";
            situation =
              "A request on the bus past its client's unanswered requests: \
               `{max}` is the most it may hold.";
            error =
              "client has {max} unanswered requests; retry when one settles";
            hint = None;
          }
           : messages_item);
         ({
            name = "streams";
            status = 429;
            code = Some "streams";
            situation =
              "A subscription past the streams its principal may hold.";
            error = "This principal holds as many streams as it may";
            hint = None;
          }
           : messages_item);
         ({
            name = "internal";
            status = 500;
            code = None;
            situation = "A fault of the gateway's own; its log says what.";
            error = "Internal server error";
            hint = None;
          }
           : messages_item);
         ({
            name = "content-store-unavailable";
            status = 503;
            code = None;
            situation =
              "A read or an upload the Archivist did not answer as its API \
               states: it could not be reached, it did not answer in time, it \
               refused the gateway, or it answered what its API does not; or \
               the gateway could not get its own service token to ask it with.";
            error = "Content store unavailable";
            hint = None;
          }
           : messages_item);
         ({
            name = "plane-unavailable";
            status = 503;
            code = None;
            situation =
              "An emit, or anything that reads or writes a table the replicas \
               share, while the signal plane's broker is not connected.";
            error =
              "The signal plane is unavailable: its broker is not connected";
            hint = None;
          }
           : messages_item);
         ({
            name = "capacity";
            status = 503;
            code = Some "capacity";
            situation =
              "A subscription past the queued bytes the gateway can hold.";
            error = "The gateway holds as many queued bytes as it can";
            hint = None;
          }
           : messages_item);
       ];
     failures =
       [
         ({
            name = "peer-unavailable";
            code = "peer-unavailable";
            situation =
              "A request on the bus that no subscriber answers: `{channel}` is \
               the request's channel. Its payload carries no stamp.";
            message =
              "No subscriber for {channel}: the service that answers it is not \
               connected";
          }
           : failures_item);
       ];
     challenges =
       ({
          no_credential =
            "Bearer \
             resource_metadata=\"{origin}/.well-known/oauth-protected-resource\"";
          refused =
            "Bearer error=\"invalid_token\", \
             resource_metadata=\"{origin}/.well-known/oauth-protected-resource\"";
        }
         : challenges);
   }
    : t)
