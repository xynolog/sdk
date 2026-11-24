(* Generated from protocol/specs/src/gateway/media-token.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type header = { alg : string; typ : string }

let header_json (r : header) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("alg", (fun s -> `String s) r.alg);
         Option.Some ("typ", (fun s -> `String s) r.typ);
       ])

type claims = { purpose : string; iss : string; sub : string }

let claims_json (r : claims) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("purpose", (fun s -> `String s) r.purpose);
         Option.Some ("iss", (fun s -> `String s) r.iss);
         Option.Some ("sub", (fun s -> `String s) r.sub);
       ])

type t = {
  comment : string;
  header : header;
  claims : claims;
  lifetime_seconds : int;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some ("header", header_json r.header);
         Option.Some ("claims", claims_json r.claims);
         Option.Some ("lifetimeSeconds", (fun n -> `Int n) r.lifetime_seconds);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for the media token (the `mediaToken` scheme of the \
        gateway's document): what `POST /api/tokens/media` answers, and the \
        one credential `GET /api/resources/{id}` takes in its `token` query \
        parameter. It is a JSON Web Token with `header`, signed by HS256 with \
        the first key of the gateway's `JWT_SECRET` ring, which signs nothing \
        else; it is accepted under any key of the ring. Its claims are \
        `claims`, with `{domain}` the domain the gateway's document names and \
        `{resourceId}` the resource it was asked for, and `iat`, the second it \
        was minted, and `exp`, `lifetimeSeconds` later. The gateway accepts \
        one with no leeway on `exp`, whose `purpose`, `iss` and `sub` are \
        these, and `sub` the resource the path names; anything else is refused \
        (gateway/messages.json, `refused-media-token`), and anywhere else a \
        media token is no credential.";
     header = ({ alg = "HS256"; typ = "JWT" } : header);
     claims =
       ({ purpose = "media"; iss = "{domain}"; sub = "{resourceId}" } : claims);
     lifetime_seconds = 300;
   }
    : t)
