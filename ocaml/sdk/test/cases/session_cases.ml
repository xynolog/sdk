(* Generated from protocol/specs/src/session/cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type claims = { iat : int option; exp : int option }

let claims_json (r : claims) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.map (fun v -> ("iat", (fun n -> `Int n) v)) r.iat;
         Option.map (fun v -> ("exp", (fun n -> `Int n) v)) r.exp;
       ])

type refresh_schedule_item = {
  why : string;
  claims : claims option;
  token : string option;
  now : int;
  delay : int option;
}

let refresh_schedule_item_json (r : refresh_schedule_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.map (fun v -> ("claims", claims_json v)) r.claims;
         Option.map (fun v -> ("token", (fun s -> `String s) v)) r.token;
         Option.Some ("now", (fun n -> `Int n) r.now);
         Option.Some
           ( "delay",
             (function
               | Option.None -> `Null | Option.Some v -> (fun n -> `Int n) v)
               r.delay );
       ])

type token_expiry_item = { why : string; token : string; exp : int option }

let token_expiry_item_json (r : token_expiry_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("token", (fun s -> `String s) r.token);
         Option.Some
           ( "exp",
             (function
               | Option.None -> `Null | Option.Some v -> (fun n -> `Int n) v)
               r.exp );
       ])

type stored = Unexpired | Expired | None

let stored_value = function
  | (Unexpired : stored) -> "unexpired"
  | (Expired : stored) -> "expired"
  | (None : stored) -> "none"

let stored_json v = `String (stored_value v)

type gateway_item = Accepts | Refuses | Unreachable

let gateway_item_value = function
  | (Accepts : gateway_item) -> "accepts"
  | (Refuses : gateway_item) -> "refuses"
  | (Unreachable : gateway_item) -> "unreachable"

let gateway_item_json v = `String (gateway_item_value v)

type issuer_item = Renews | Refuses | Unreachable

let issuer_item_value = function
  | (Renews : issuer_item) -> "renews"
  | (Refuses : issuer_item) -> "refuses"
  | (Unreachable : issuer_item) -> "unreachable"

let issuer_item_json v = `String (issuer_item_value v)

type ends = Signed_in | Signed_out | Unconfirmed

let ends_value = function
  | (Signed_in : ends) -> "signed-in"
  | (Signed_out : ends) -> "signed-out"
  | (Unconfirmed : ends) -> "unconfirmed"

let ends_json v = `String (ends_value v)

type session_end_reason = Expired | Refused

let session_end_reason_value = function
  | (Expired : session_end_reason) -> "expired"
  | (Refused : session_end_reason) -> "refused"

let session_end_reason_json v = `String (session_end_reason_value v)

type then_ = { asks : int; renewals : int; ends : ends }

let then__json (r : then_) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("asks", (fun n -> `Int n) r.asks);
         Option.Some ("renewals", (fun n -> `Int n) r.renewals);
         Option.Some ("ends", ends_json r.ends);
       ])

type startup_item = {
  why : string;
  stored : stored;
  gateway : gateway_item list;
  issuer : issuer_item list;
  asks : int;
  renewals : int;
  ends : ends;
  told : session_end_reason option;
  error : string option;
  kept : bool;
  then_ : then_ option;
}

let startup_item_json (r : startup_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("stored", stored_json r.stored);
         Option.Some
           ("gateway", (fun l -> `List (List.map gateway_item_json l)) r.gateway);
         Option.Some
           ("issuer", (fun l -> `List (List.map issuer_item_json l)) r.issuer);
         Option.Some ("asks", (fun n -> `Int n) r.asks);
         Option.Some ("renewals", (fun n -> `Int n) r.renewals);
         Option.Some ("ends", ends_json r.ends);
         Option.Some
           ( "told",
             (function
               | Option.None -> `Null
               | Option.Some v -> session_end_reason_json v)
               r.told );
         Option.Some
           ( "error",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.error );
         Option.Some ("kept", (fun b -> `Bool b) r.kept);
         Option.map (fun v -> ("then", then__json v)) r.then_;
       ])

type refused = Held | Replaced

let refused_value = function
  | (Held : refused) -> "held"
  | (Replaced : refused) -> "replaced"

let refused_json v = `String (refused_value v)

type item_then = { asks : int; renewals : int; ends : ends }

let item_then_json (r : item_then) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("asks", (fun n -> `Int n) r.asks);
         Option.Some ("renewals", (fun n -> `Int n) r.renewals);
         Option.Some ("ends", ends_json r.ends);
       ])

type refusal_item = {
  why : string;
  refused : refused;
  issuer : issuer_item list;
  gateway : gateway_item list;
  asks : int;
  renewals : int;
  given : bool;
  ends : ends;
  told : session_end_reason option;
  error : string option;
  kept : bool;
  then_ : item_then option;
}

let refusal_item_json (r : refusal_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("refused", refused_json r.refused);
         Option.Some
           ("issuer", (fun l -> `List (List.map issuer_item_json l)) r.issuer);
         Option.Some
           ("gateway", (fun l -> `List (List.map gateway_item_json l)) r.gateway);
         Option.Some ("asks", (fun n -> `Int n) r.asks);
         Option.Some ("renewals", (fun n -> `Int n) r.renewals);
         Option.Some ("given", (fun b -> `Bool b) r.given);
         Option.Some ("ends", ends_json r.ends);
         Option.Some
           ( "told",
             (function
               | Option.None -> `Null
               | Option.Some v -> session_end_reason_json v)
               r.told );
         Option.Some
           ( "error",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.error );
         Option.Some ("kept", (fun b -> `Bool b) r.kept);
         Option.map (fun v -> ("then", item_then_json v)) r.then_;
       ])

type t = {
  comment : string;
  told : Yojson.Safe.t;
  refresh_schedule : refresh_schedule_item list;
  token_expiry : token_expiry_item list;
  startup : startup_item list;
  refusal : refusal_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some ("told", Fun.id r.told);
         Option.Some
           ( "refreshSchedule",
             (fun l -> `List (List.map refresh_schedule_item_json l))
               r.refresh_schedule );
         Option.Some
           ( "tokenExpiry",
             (fun l -> `List (List.map token_expiry_item_json l)) r.token_expiry
           );
         Option.Some
           ("startup", (fun l -> `List (List.map startup_item_json l)) r.startup);
         Option.Some
           ("refusal", (fun l -> `List (List.map refusal_item_json l)) r.refusal);
       ])

let table : t =
  ({
     comment =
       "How a client holds a session, as every SDK must compute it. \
        `refreshSchedule`: how long to wait before renewing an access token, \
        from its own claims. The margin before expiry is half the token's \
        lifetime (`exp - iat`, or the time remaining when there is no `iat`), \
        capped at 300 seconds; the wait is never under 10 seconds; a token \
        with no readable `exp` schedules nothing (`delay` null). A wait is for \
        the token it was counted from: when it runs out, whatever renews on \
        this schedule, a session or an agent, renews that token only while it \
        is still the one held. A token renewed some other way meanwhile has a \
        wait of its own, so a wait that ran out for a token since replaced \
        renews nothing. Times are in seconds; a row gives the token's \
        `claims`, which a runner puts in any JWT, or a literal `token`. \
        `tokenExpiry`: reading `exp` out of a token. A JWT's segments are \
        base64url without padding, and its payload is UTF-8, so a reader that \
        assumes plain base64 or ASCII fails for the accounts whose names \
        produce `-`, `_` or a multi-byte character. What a session says, it \
        says once on its errors stream (specs/src/client/surface.json, the \
        session unit's `errors`); it takes no callback for it. `startup`: what \
        a session does with the credential it finds stored, when it starts. It \
        asks the gateway who the token is. A token the gateway refuses is \
        renewed at the issuer once and asked about once more; a token the \
        issuer has just issued and the gateway refuses is final, because \
        renewing again cannot change the answer, and the session ends as \
        `session.credential-refused`. So a session asks at most twice and \
        renews at most once, whatever the gateway and the issuer answer. A \
        stored token that has expired is renewed before anyone is asked, and \
        only the issuer's refusal forgets it, with nothing said, because there \
        was no session to end. A renewal that got no answer keeps it: the \
        session starts with no token and says why as `session.auth-failed`. \
        Whenever a session renews, at its start, on its schedule or when the \
        gateway refuses its token, only the issuer's refusal ends it and \
        forgets what is stored. Every renewal is handed the token it renews, \
        so that what keeps the sign-in can tell a renewal another writer has \
        made already from one it must make: the token the session holds, \
        expired or not, the token found stored at the start though it has \
        expired, and, once a renewal that got no answer has left the session \
        none, the token that renewal was for. A session hands none only when \
        it has held none. So in every row each renewal is handed the token the \
        row stored, and a runner fails a renewal handed any other. A renewal \
        that got no answer leaves it no usable token and keeps what is stored: \
        it says why as `session.refresh-exhausted` (at the start, \
        `session.auth-failed`), and tells `onAuthFailed` nothing, because the \
        session is not over. It renews again when a request is refused, and on \
        its own on the reconnect backoff of specs/src/client/timing.json: each \
        wait is the equal jitter of its step (half the step, and a random \
        share of the other half), the step `reconnectMs` doubling to \
        `maxReconnectMs`, until a renewal is made or refused, a token arrives \
        some other way, or the session ends. Such a renewal asks nobody, but \
        one that is made while nobody has said who the session's token is asks \
        the gateway once, as the start would have, and keeps the answer. A row \
        scripts both: `stored` is the access token found (`unexpired`, \
        `expired`, or `none`), `gateway` what the gateway answers each time it \
        is asked (`accepts`, `refuses`: its credential refused, a 401 or a 429 \
        whose `code` is `refusal-rate` (contract/TRANSPORT-CONTRACT.md \
        \194\167 A refused credential), which every SDK reports as \
        `unauthorized`, `unreachable`: no usable answer) and `issuer` what the \
        issuer answers each renewal (`renews`, `refuses`: an answer the \
        `refresh` rule of specs/src/retry/rules.json does not try again, which \
        every SDK reports as the sign-in code `exchange` with the issuer's \
        status, `unreachable`: no answer, or only answers that rule tries \
        again, until the retry budget was spent); the last answer of each \
        repeats, so a runner must fail a session that asks more than `asks` \
        times or renews more than `renewals`. `ends` is `signed-in` (a token, \
        and who the gateway last said it is), `signed-out` (neither) or \
        `unconfirmed` (a token, and nobody to say who it is). A session that \
        ends `signed-out` and keeps nothing asks neither of them anything \
        afterwards, however long it is held. A row that ends `signed-out` and \
        kept what is stored states `then`: the `asks`, `renewals` and `ends` \
        it comes to once it has renewed once more on its own. That renewal \
        falls due by `reconnectMs` at the latest, and a second no sooner than \
        half as long again, so a runner holds the session for six fifths of \
        `reconnectMs`, never for exactly the longest a jittered wait can be; \
        the issuer's answers go on as `issuer` scripts them. `told` is the \
        reason a session gives `onAuthFailed` when it ends, one of the values \
        of the table's own `told`, and `error` the code reported, each null \
        when there is none. The table's `told` names that vocabulary's schema, \
        session/SessionEndReason.json, each SDK's `SessionEndReason`: every \
        row tells one of its values or nothing, and every value is told by \
        some row. A reason is not a sentence: what a person reads is the \
        host's to say, in their language; `kept` is whether a session is still \
        stored. `refusal`: what a session that is already running does when \
        the gateway refuses a token, which is when its transport asks it to \
        `refresh` and tells it the token refused. `refused` is which token \
        that was: `held`, the token the session holds, or `replaced`, one it \
        held before it was given the token it holds, which a refusal that \
        arrives after the session renewed names. A refusal of a token the \
        session has replaced was answered already: the token it holds is \
        given, and nothing is renewed or asked, so a refusal that arrives late \
        costs no second renewal. A refusal of the token it holds follows the \
        rule `startup` has: the token is renewed once and the gateway is asked \
        who the new one is, and its answer is who is signed in, and a token \
        the issuer has just issued and the gateway refuses ends the session as \
        `session.credential-refused`. So one refusal costs at most one renewal \
        and one ask. Refusals met while a renewal is under way wait on that \
        one renewal. A close, a session's or an agent's, gives each refusal \
        waiting on it no token at once, as when the issuer gives none, and the \
        closed session takes nothing that renewal brings: the token is not \
        made its own, and nothing is asked or ended on it. An agent's renewal \
        ends at the close. A kept sign-in's runs to its end, and the token \
        pair it brings is written where the sign-in is kept, as any renewal's \
        is, because an issuer that rotates refresh tokens has spent the old \
        one once it answers; a close that can be waited on returns once that \
        renewal has ended. Once closed, a refusal is given no token, whatever \
        token it refused, and the issuer is not asked. A row's session started \
        signed in, on a stored token the gateway accepted; `issuer` is what \
        the issuer answers the renewal and `gateway` what the gateway answers \
        when asked who the renewed token is, each as in `startup`. `asks` and \
        `renewals` count from the refusal on, and `given` is whether `refresh` \
        gives a token, which is then the token the session holds. A gateway \
        that cannot be asked refuses nothing: the renewed token is given, and \
        nothing is said. A renewal the session makes on its own schedule \
        follows no refusal, and asks nobody. Every runner runs all four parts, \
        `refreshSchedule`, `tokenExpiry`, `startup` and `refusal`, and fails \
        on a difference.";
     told =
       `Assoc
         [
           ("$ref", `String "https://xynolog.org/protocol/SessionEndReason.json");
         ];
     refresh_schedule =
       [
         ({
            why =
              "an hour-long token just issued is renewed 300 seconds before it \
               expires: the margin's ceiling";
            claims =
              Some ({ iat = Some 1800000000; exp = Some 1800003600 } : claims);
            token = None;
            now = 1800000000;
            delay = Some 3300;
          }
           : refresh_schedule_item);
         ({
            why =
              "a five-minute token is renewed at half its life, not at once: a \
               fixed 300-second margin equals this lifetime and schedules a \
               renewal for the moment of issue, forever";
            claims =
              Some ({ iat = Some 1800000000; exp = Some 1800000300 } : claims);
            token = None;
            now = 1800000000;
            delay = Some 150;
          }
           : refresh_schedule_item);
         ({
            why = "a one-minute token is renewed at half its life";
            claims =
              Some ({ iat = Some 1800000000; exp = Some 1800000060 } : claims);
            token = None;
            now = 1800000000;
            delay = Some 30;
          }
           : refresh_schedule_item);
         ({
            why =
              "a ten-minute token sits where half its life equals the ceiling";
            claims =
              Some ({ iat = Some 1800000000; exp = Some 1800000600 } : claims);
            token = None;
            now = 1800000000;
            delay = Some 300;
          }
           : refresh_schedule_item);
         ({
            why =
              "the margin comes from the lifetime the issuer chose, not from \
               what remains of it";
            claims =
              Some ({ iat = Some 1800000000; exp = Some 1800003600 } : claims);
            token = None;
            now = 1800001800;
            delay = Some 1500;
          }
           : refresh_schedule_item);
         ({
            why = "a token past its renewal point waits the floor, never zero";
            claims =
              Some ({ iat = Some 1800000000; exp = Some 1800003600 } : claims);
            token = None;
            now = 1800003500;
            delay = Some 10;
          }
           : refresh_schedule_item);
         ({
            why =
              "an expired token waits the floor: one attempt per interval, not \
               a loop";
            claims =
              Some ({ iat = Some 1800000000; exp = Some 1800003600 } : claims);
            token = None;
            now = 1800003650;
            delay = Some 10;
          }
           : refresh_schedule_item);
         ({
            why =
              "a token shorter than twice the floor waits the floor, though \
               that is past its half-life";
            claims =
              Some ({ iat = Some 1800000000; exp = Some 1800000012 } : claims);
            token = None;
            now = 1800000000;
            delay = Some 10;
          }
           : refresh_schedule_item);
         ({
            why =
              "with no iat the lifetime is what remains, and half of it is \
               still bounded";
            claims = Some ({ iat = None; exp = Some 1800000100 } : claims);
            token = None;
            now = 1800000000;
            delay = Some 50;
          }
           : refresh_schedule_item);
         ({
            why = "with no iat and a long time remaining the ceiling applies";
            claims = Some ({ iat = None; exp = Some 1800003600 } : claims);
            token = None;
            now = 1800000000;
            delay = Some 3300;
          }
           : refresh_schedule_item);
         ({
            why = "a token with no exp schedules nothing";
            claims = Some ({ iat = Some 1800000000; exp = None } : claims);
            token = None;
            now = 1800000000;
            delay = None;
          }
           : refresh_schedule_item);
         ({
            why = "a token that is not a JWT schedules nothing";
            claims = None;
            token = Some "not-a-jwt";
            now = 1800000000;
            delay = None;
          }
           : refresh_schedule_item);
       ];
     token_expiry =
       [
         ({
            why =
              "an ASCII payload, whose length is not a multiple of four: JWTs \
               omit the padding";
            token =
              "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhbGljZSIsImV4cCI6MTkwMDAwMDAwMH0.c2lnbmF0dXJl";
            exp = Some 1900000000;
          }
           : token_expiry_item);
         ({
            why =
              "a payload whose base64url spelling contains `_`: the name is \
               Zo\195\171 Faur\195\169";
            token =
              "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiWm_DqyBGYXVyw6kiLCJleHAiOjE5MDAwMDAwMDB9.c2lnbmF0dXJl";
            exp = Some 1900000000;
          }
           : token_expiry_item);
         ({
            why =
              "a payload whose base64url spelling contains `-`: the name is \
               O\226\128\153Connor, with a typographic apostrophe";
            token =
              "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiT-KAmUNvbm5vciIsImV4cCI6MTkwMDAwMDAwMH0.c2lnbmF0dXJl";
            exp = Some 1900000000;
          }
           : token_expiry_item);
         ({
            why = "a payload with no exp";
            token =
              "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhbGljZSJ9.c2lnbmF0dXJl";
            exp = None;
          }
           : token_expiry_item);
         ({
            why = "two segments are not a JWT";
            token =
              "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE5MDAwMDAwMDB9";
            exp = None;
          }
           : token_expiry_item);
         ({
            why = "a payload that is not base64url";
            token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.!!!.c2lnbmF0dXJl";
            exp = None;
          }
           : token_expiry_item);
         ({
            why = "a payload that is not JSON";
            token =
              "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.bm90IGpzb24.c2lnbmF0dXJl";
            exp = None;
          }
           : token_expiry_item);
       ];
     startup =
       [
         ({
            why = "nothing stored: nobody is asked, and nothing is said";
            stored = (None : stored);
            gateway = [ (Accepts : gateway_item) ];
            issuer = [ (Renews : issuer_item) ];
            asks = 0;
            renewals = 0;
            ends = (Signed_out : ends);
            told = None;
            error = None;
            kept = false;
            then_ = None;
          }
           : startup_item);
         ({
            why = "a stored token the gateway accepts is the session's";
            stored = (Unexpired : stored);
            gateway = [ (Accepts : gateway_item) ];
            issuer = [ (Renews : issuer_item) ];
            asks = 1;
            renewals = 0;
            ends = (Signed_in : ends);
            told = None;
            error = None;
            kept = true;
            then_ = None;
          }
           : startup_item);
         ({
            why =
              "a token the gateway refuses is renewed once and asked about \
               again";
            stored = (Unexpired : stored);
            gateway = [ (Refuses : gateway_item); (Accepts : gateway_item) ];
            issuer = [ (Renews : issuer_item) ];
            asks = 2;
            renewals = 1;
            ends = (Signed_in : ends);
            told = None;
            error = None;
            kept = true;
            then_ = None;
          }
           : startup_item);
         ({
            why =
              "a token the gateway refuses and the issuer will not renew: the \
               session has expired";
            stored = (Unexpired : stored);
            gateway = [ (Refuses : gateway_item) ];
            issuer = [ (Refuses : issuer_item) ];
            asks = 1;
            renewals = 1;
            ends = (Signed_out : ends);
            told = Some (Expired : session_end_reason);
            error = Some "session.refresh-exhausted";
            kept = false;
            then_ = None;
          }
           : startup_item);
         ({
            why =
              "the gateway refuses every token the issuer goes on issuing: \
               asked twice, renewed once, and over";
            stored = (Unexpired : stored);
            gateway = [ (Refuses : gateway_item) ];
            issuer = [ (Renews : issuer_item) ];
            asks = 2;
            renewals = 1;
            ends = (Signed_out : ends);
            told = Some (Refused : session_end_reason);
            error = Some "session.credential-refused";
            kept = false;
            then_ = None;
          }
           : startup_item);
         ({
            why =
              "a stored token that has expired is renewed before anyone is \
               asked";
            stored = (Expired : stored);
            gateway = [ (Accepts : gateway_item) ];
            issuer = [ (Renews : issuer_item) ];
            asks = 1;
            renewals = 1;
            ends = (Signed_in : ends);
            told = None;
            error = None;
            kept = true;
            then_ = None;
          }
           : startup_item);
         ({
            why =
              "an expired token the issuer will not renew is forgotten, and \
               nothing is said: there was no session to end";
            stored = (Expired : stored);
            gateway = [ (Accepts : gateway_item) ];
            issuer = [ (Refuses : issuer_item) ];
            asks = 0;
            renewals = 1;
            ends = (Signed_out : ends);
            told = None;
            error = None;
            kept = false;
            then_ = None;
          }
           : startup_item);
         ({
            why =
              "an expired token whose renewal got no answer is kept: the \
               session starts with no token, says why, and renews it when a \
               request is refused";
            stored = (Expired : stored);
            gateway = [ (Accepts : gateway_item) ];
            issuer = [ (Unreachable : issuer_item) ];
            asks = 0;
            renewals = 1;
            ends = (Signed_out : ends);
            told = None;
            error = Some "session.auth-failed";
            kept = true;
            then_ =
              Some
                ({ asks = 0; renewals = 2; ends = (Signed_out : ends) } : then_);
          }
           : startup_item);
         ({
            why =
              "an expired token whose renewal got no answer, renewed on the \
               backoff: nobody has said who it is, so the gateway is asked \
               once";
            stored = (Expired : stored);
            gateway = [ (Accepts : gateway_item) ];
            issuer = [ (Unreachable : issuer_item); (Renews : issuer_item) ];
            asks = 0;
            renewals = 1;
            ends = (Signed_out : ends);
            told = None;
            error = Some "session.auth-failed";
            kept = true;
            then_ =
              Some
                ({ asks = 1; renewals = 2; ends = (Signed_in : ends) } : then_);
          }
           : startup_item);
         ({
            why =
              "an expired token is renewed and the gateway refuses the new \
               one: it was just issued, so it is not renewed again";
            stored = (Expired : stored);
            gateway = [ (Refuses : gateway_item) ];
            issuer = [ (Renews : issuer_item) ];
            asks = 1;
            renewals = 1;
            ends = (Signed_out : ends);
            told = Some (Refused : session_end_reason);
            error = Some "session.credential-refused";
            kept = false;
            then_ = None;
          }
           : startup_item);
         ({
            why =
              "a gateway that cannot be asked refuses nothing: the token is \
               kept, and the failure is said";
            stored = (Unexpired : stored);
            gateway = [ (Unreachable : gateway_item) ];
            issuer = [ (Renews : issuer_item) ];
            asks = 1;
            renewals = 0;
            ends = (Unconfirmed : ends);
            told = None;
            error = Some "session.auth-failed";
            kept = true;
            then_ = None;
          }
           : startup_item);
         ({
            why =
              "a token the gateway refuses, whose renewal got no answer: the \
               session holds no token, keeps what is stored, and says why";
            stored = (Unexpired : stored);
            gateway = [ (Refuses : gateway_item) ];
            issuer = [ (Unreachable : issuer_item) ];
            asks = 1;
            renewals = 1;
            ends = (Signed_out : ends);
            told = None;
            error = Some "session.refresh-exhausted";
            kept = true;
            then_ =
              Some
                ({ asks = 1; renewals = 2; ends = (Signed_out : ends) } : then_);
          }
           : startup_item);
         ({
            why =
              "the renewed token could not be asked about: it is kept, and the \
               failure is said";
            stored = (Unexpired : stored);
            gateway = [ (Refuses : gateway_item); (Unreachable : gateway_item) ];
            issuer = [ (Renews : issuer_item) ];
            asks = 2;
            renewals = 1;
            ends = (Unconfirmed : ends);
            told = None;
            error = Some "session.auth-failed";
            kept = true;
            then_ = None;
          }
           : startup_item);
       ];
     refusal =
       [
         ({
            why =
              "the gateway accepts the renewed token: the session goes on as \
               whoever the gateway says it is, and the request can be made \
               again";
            refused = (Held : refused);
            issuer = [ (Renews : issuer_item) ];
            gateway = [ (Accepts : gateway_item) ];
            asks = 1;
            renewals = 1;
            given = true;
            ends = (Signed_in : ends);
            told = None;
            error = None;
            kept = true;
            then_ = None;
          }
           : refusal_item);
         ({
            why =
              "the gateway refuses the renewed token too: it was just issued, \
               so the session is over";
            refused = (Held : refused);
            issuer = [ (Renews : issuer_item) ];
            gateway = [ (Refuses : gateway_item) ];
            asks = 1;
            renewals = 1;
            given = false;
            ends = (Signed_out : ends);
            told = Some (Refused : session_end_reason);
            error = Some "session.credential-refused";
            kept = false;
            then_ = None;
          }
           : refusal_item);
         ({
            why =
              "the issuer will not renew: the session has expired, and nobody \
               is asked";
            refused = (Held : refused);
            issuer = [ (Refuses : issuer_item) ];
            gateway = [ (Accepts : gateway_item) ];
            asks = 0;
            renewals = 1;
            given = false;
            ends = (Signed_out : ends);
            told = Some (Expired : session_end_reason);
            error = Some "session.refresh-exhausted";
            kept = false;
            then_ = None;
          }
           : refusal_item);
         ({
            why =
              "the renewal got no answer: the session holds no token, keeps \
               what is stored, and says why; the next refusal renews again";
            refused = (Held : refused);
            issuer = [ (Unreachable : issuer_item) ];
            gateway = [ (Accepts : gateway_item) ];
            asks = 0;
            renewals = 1;
            given = false;
            ends = (Signed_out : ends);
            told = None;
            error = Some "session.refresh-exhausted";
            kept = true;
            then_ =
              Some
                ({ asks = 0; renewals = 2; ends = (Signed_out : ends) }
                  : item_then);
          }
           : refusal_item);
         ({
            why =
              "the renewal got no answer, and is made on the backoff: the \
               gateway has said who the session is, so nobody is asked";
            refused = (Held : refused);
            issuer = [ (Unreachable : issuer_item); (Renews : issuer_item) ];
            gateway = [ (Accepts : gateway_item) ];
            asks = 0;
            renewals = 1;
            given = false;
            ends = (Signed_out : ends);
            told = None;
            error = Some "session.refresh-exhausted";
            kept = true;
            then_ =
              Some
                ({ asks = 0; renewals = 2; ends = (Signed_in : ends) }
                  : item_then);
          }
           : refusal_item);
         ({
            why =
              "a gateway that cannot be asked refuses nothing: the renewed \
               token is given, and nothing is said";
            refused = (Held : refused);
            issuer = [ (Renews : issuer_item) ];
            gateway = [ (Unreachable : gateway_item) ];
            asks = 1;
            renewals = 1;
            given = true;
            ends = (Signed_in : ends);
            told = None;
            error = None;
            kept = true;
            then_ = None;
          }
           : refusal_item);
         ({
            why =
              "the gateway refused a token the session has already replaced, a \
               refusal that arrives after the session renewed: the token the \
               session holds is given, and nothing is renewed or asked";
            refused = (Replaced : refused);
            issuer = [ (Renews : issuer_item) ];
            gateway = [ (Accepts : gateway_item) ];
            asks = 0;
            renewals = 0;
            given = true;
            ends = (Signed_in : ends);
            told = None;
            error = None;
            kept = true;
            then_ = None;
          }
           : refusal_item);
       ];
   }
    : t)
