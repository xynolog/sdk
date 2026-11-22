(* Generated from protocol/specs/src/session/registry-errors-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type while_ = Opening | Active

let while__value = function
  | (Opening : while_) -> "opening"
  | (Active : while_) -> "active"

let while__json v = `String (while__value v)

type own = { own : string }

let own_json (r : own) =
  `Assoc
    (List.filter_map Fun.id [ Option.Some ("own", (fun s -> `String s) r.own) ])

type transport = { transport : string; message : string }

let transport_json (r : transport) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("transport", (fun s -> `String s) r.transport);
         Option.Some ("message", (fun s -> `String s) r.message);
       ])

type said_item = Own of own | Transport of transport

let said_item_json = function
  | (Own v : said_item) -> own_json v
  | (Transport v : said_item) -> transport_json v

type cases_item = {
  why : string;
  while_ : while_;
  said : said_item list;
  registry_errors : string list;
  permission_denied : string option;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("while", while__json r.while_);
         Option.Some
           ("said", (fun l -> `List (List.map said_item_json l)) r.said);
         Option.Some
           ( "registryErrors",
             (fun l -> `List (List.map (fun s -> `String s) l))
               r.registry_errors );
         Option.map
           (fun v -> ("permissionDenied", (fun s -> `String s) v))
           r.permission_denied;
       ])

type closing_item = { why : string; owed : bool; registry_errors : string list }

let closing_item_json (r : closing_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("owed", (fun b -> `Bool b) r.owed);
         Option.Some
           ( "registryErrors",
             (fun l -> `List (List.map (fun s -> `String s) l))
               r.registry_errors );
       ])

type t = {
  comment : string;
  cases : cases_item list;
  closing : closing_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("cases", (fun l -> `List (List.map cases_item_json l)) r.cases);
         Option.Some
           ("closing", (fun l -> `List (List.map closing_item_json l)) r.closing);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for how a registry of knowledge bases reads the errors of \
        each session it activates (client/surface.json's registry module): it \
        is their one reader, from the first thing the session said, and a \
        factory reads none of them. Every SDK runs every case against its own \
        registry, over a factory that builds a scripted session and reads none \
        of its errors, and fails on a difference. READING A CASE. `said` is \
        what the active knowledge base's session says on its errors, in order: \
        `{\"own\": code}` one of the session's own errors, by its code in \
        errors/codes.json's session group; `{\"transport\": code, \"message\": \
        text}` a failure of its transport, by its code in errors/codes.json's \
        transport group, with that message. `while` is when the session says \
        them: `opening`, as the factory builds it, before the registry has \
        read anything; `active`, once the session is active. Every case's last \
        `said` has an effect a runner can wait for: one of the session's own \
        errors, said on the registry's errors; or a refusal for lack of \
        permission, said through the session's signals. A runner waits for \
        that effect, and then holds the case: the registry reads the session's \
        errors in order, so by then it has read everything before. \
        `registryErrors` is the codes said on the registry's errors up to \
        then, in order. A registry renews no session: a refusal for want of a \
        valid token is renewed by the transport that met it, which knows the \
        token it sent (contract/TRANSPORT-CONTRACT.md \194\167 A refused \
        credential), so a runner fails if the registry renews the session in \
        any case. `permissionDenied` is the detail said through the session's \
        signals as a refusal for lack of permission; when it is absent, no \
        such refusal is said through them. A refusal for want of a valid \
        token, and a failure of the transport for any other reason, the \
        registry does nothing with. `closing` holds what a registry's close \
        reads: the registry closes while its active session's client does or \
        does not owe a save (`owed`) to a storage that refuses every write the \
        client makes, and `registryErrors` is every code the registry says \
        from its close until its errors end, in order: what the session's \
        closing flush meets is said before they end. A save owed is one still \
        waiting out its debounce as the close begins, never yet tried: the \
        close makes it once, so its refusal is said once. The close waits for \
        that write without limit: a storage's write returns or throws \
        (contract/CACHE-SEMANTICS.md, B17).";
     cases =
       [
         ({
            why =
              "a session's own error said while its factory builds it, before \
               the registry has read anything, is said on the registry's \
               errors";
            while_ = (Opening : while_);
            said = [ (Own ({ own = "session.keep-failed" } : own) : said_item) ];
            registry_errors = [ "session.keep-failed" ];
            permission_denied = None;
          }
           : cases_item);
         ({
            why =
              "a failure of a session's transport said while its factory \
               builds it, before the registry has read anything, is read as \
               any other: a refusal for lack of permission is said through the \
               session's signals";
            while_ = (Opening : while_);
            said =
              [
                (Transport
                   ({ transport = "forbidden"; message = "not yours to open" }
                     : transport)
                  : said_item);
              ];
            registry_errors = [];
            permission_denied = Some "not yours to open";
          }
           : cases_item);
         ({
            why =
              "each of an active session's own errors is said on the \
               registry's errors, in the order the session said them";
            while_ = (Active : while_);
            said =
              [
                (Own ({ own = "session.save-refused" } : own) : said_item);
                (Own ({ own = "session.keep-failed" } : own) : said_item);
              ];
            registry_errors = [ "session.save-refused"; "session.keep-failed" ];
            permission_denied = None;
          }
           : cases_item);
         ({
            why =
              "a refusal for want of a valid token is its transport's to \
               renew: the registry renews nothing for it, and says it neither \
               on its errors nor through a signal: once a refusal for lack of \
               permission read after it is said, nothing else has been";
            while_ = (Active : while_);
            said =
              [
                (Transport
                   ({
                      transport = "unauthorized";
                      message = "the gateway refuses the token";
                    }
                     : transport)
                  : said_item);
                (Transport
                   ({
                      transport = "forbidden";
                      message = "read after the refusal";
                    }
                     : transport)
                  : said_item);
              ];
            registry_errors = [];
            permission_denied = Some "read after the refusal";
          }
           : cases_item);
         ({
            why =
              "a refusal for lack of permission is said through the session's \
               signals, with the failure's message as its detail, and is \
               neither said on the registry's errors nor renews the session";
            while_ = (Active : while_);
            said =
              [
                (Transport
                   ({ transport = "forbidden"; message = "not yours to read" }
                     : transport)
                  : said_item);
              ];
            registry_errors = [];
            permission_denied = Some "not yours to read";
          }
           : cases_item);
         ({
            why =
              "a failure of the transport for any other reason is not said on \
               the registry's errors, renews nothing and is said through no \
               signal: once a refusal for lack of permission read after them \
               is said, nothing else has been";
            while_ = (Active : while_);
            said =
              [
                (Transport
                   ({
                      transport = "unavailable";
                      message = "the gateway cannot be reached";
                    }
                     : transport)
                  : said_item);
                (Transport
                   ({ transport = "not-found"; message = "no such resource" }
                     : transport)
                  : said_item);
                (Transport
                   ({ transport = "error"; message = "the gateway failed" }
                     : transport)
                  : said_item);
                (Transport
                   ({
                      transport = "forbidden";
                      message = "read after the others";
                    }
                     : transport)
                  : said_item);
              ];
            registry_errors = [];
            permission_denied = Some "read after the others";
          }
           : cases_item);
         ({
            why =
              "a session says its own errors and its transport's failures on \
               one stream, in the order it met them: once the own error said \
               after a refusal for lack of permission is said on the \
               registry's errors, that refusal has been said through the \
               session's signals, and the own error before it on the \
               registry's errors. A client that cannot keep keeps nothing \
               more, so its refused save comes first";
            while_ = (Active : while_);
            said =
              [
                (Own ({ own = "session.save-refused" } : own) : said_item);
                (Transport
                   ({
                      transport = "forbidden";
                      message = "between two of its own";
                    }
                     : transport)
                  : said_item);
                (Own ({ own = "session.keep-failed" } : own) : said_item);
              ];
            registry_errors = [ "session.save-refused"; "session.keep-failed" ];
            permission_denied = Some "between two of its own";
          }
           : cases_item);
       ];
     closing =
       [
         ({
            why =
              "a registry's close reads its active session's errors to their \
               end: the save its client owes, still waiting out its debounce, \
               which the storage refuses as the client's closing flush makes \
               it once, is said on the registry's errors once before they end";
            owed = true;
            registry_errors = [ "session.save-refused" ];
          }
           : closing_item);
         ({
            why =
              "a registry whose active session's client owes nothing says \
               nothing as it closes, and its errors end";
            owed = false;
            registry_errors = [];
          }
           : closing_item);
       ];
   }
    : t)
