(* Generated from protocol/specs/src/session/client-assertion-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type jwk = { kty : string; n : string; e : string }

let jwk_json (r : jwk) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("kty", (fun s -> `String s) r.kty);
         Option.Some ("n", (fun s -> `String s) r.n);
         Option.Some ("e", (fun s -> `String s) r.e);
       ])

type thumbprints_item = { why : string; jwk : jwk; thumbprint : string }

let thumbprints_item_json (r : thumbprints_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("jwk", jwk_json r.jwk);
         Option.Some ("thumbprint", (fun s -> `String s) r.thumbprint);
       ])

type header = { alg : string; kid : string }

let header_json (r : header) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("alg", (fun s -> `String s) r.alg);
         Option.Some ("kid", (fun s -> `String s) r.kid);
       ])

type claims = {
  iss : string;
  sub : string;
  aud : string;
  jti : string;
  iat : int;
  exp : int;
}

let claims_json (r : claims) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("iss", (fun s -> `String s) r.iss);
         Option.Some ("sub", (fun s -> `String s) r.sub);
         Option.Some ("aud", (fun s -> `String s) r.aud);
         Option.Some ("jti", (fun s -> `String s) r.jti);
         Option.Some ("iat", (fun n -> `Int n) r.iat);
         Option.Some ("exp", (fun n -> `Int n) r.exp);
       ])

type cases_item = {
  why : string;
  jwk : jwk;
  client_id : string;
  token_endpoint : string;
  issued_at : int;
  jti : string;
  header : header;
  claims : claims;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("jwk", jwk_json r.jwk);
         Option.Some ("clientId", (fun s -> `String s) r.client_id);
         Option.Some ("tokenEndpoint", (fun s -> `String s) r.token_endpoint);
         Option.Some ("issuedAt", (fun n -> `Int n) r.issued_at);
         Option.Some ("jti", (fun s -> `String s) r.jti);
         Option.Some ("header", header_json r.header);
         Option.Some ("claims", claims_json r.claims);
       ])

type t = {
  comment : string;
  form : string list;
  grant_type : string;
  assertion_type : string;
  lifetime_seconds : int;
  thumbprints : thumbprints_item list;
  cases : cases_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("form", (fun l -> `List (List.map (fun s -> `String s) l)) r.form);
         Option.Some ("grantType", (fun s -> `String s) r.grant_type);
         Option.Some ("assertionType", (fun s -> `String s) r.assertion_type);
         Option.Some ("lifetimeSeconds", (fun n -> `Int n) r.lifetime_seconds);
         Option.Some
           ( "thumbprints",
             (fun l -> `List (List.map thumbprints_item_json l)) r.thumbprints
           );
         Option.Some
           ("cases", (fun l -> `List (List.map cases_item_json l)) r.cases);
       ])

let table : t =
  ({
     comment =
       "How a service account proves itself with a key instead of a secret: \
        OpenID Connect's private_key_jwt, the client assertion of RFC 7523 \
        \194\1672.2. The account holds an RSA private key; its issuer holds \
        the public half, registered on the account's client. For each \
        client-credentials grant the account signs a fresh JWT with RS256: its \
        header names the key by its JWK thumbprint (RFC 7638: the SHA-256 of \
        the key's required members `e`, `kty` and `n`, in that order, with no \
        whitespace, base64url without padding), and its claims are `iss` and \
        `sub` the client id, `aud` the issuer's token endpoint, `jti` a value \
        never sent twice, `iat` when it is made and `exp` `lifetimeSeconds` \
        after. The grant posts the form's fields and no others: the client id \
        is the assertion's `sub`, and no secret is sent. A JSON object here is \
        compared as JSON, member order aside. Every implementation that signs \
        such an assertion runs every case.";
     form = [ "grant_type"; "client_assertion_type"; "client_assertion" ];
     grant_type = "client_credentials";
     assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer";
     lifetime_seconds = 60;
     thumbprints =
       [
         ({
            why = "RFC 7638 \194\1673.1's own example key and thumbprint";
            jwk =
              ({
                 kty = "RSA";
                 n =
                   "0vx7agoebGcQSuuPiLJXZptN9nndrQmbXEps2aiAFbWhM78LhWx4cbbfAAtVT86zwu1RK7aPFFxuhDR1L6tSoc_BJECPebWKRXjBZCiFV4n3oknjhMstn64tZ_2W-5JsGY4Hc5n9yBXArwl93lqt7_RN5w6Cf0h4QyQ5v-65YGjQR0_FDW2QvzqY368QQMicAtaSqzs8KJZgnYb9c7d0zgdAZHzu6qMQvRL5hajrn1n91CbOpbISD08qNLyrdkt-bFTWhAI4vMQFh6WeZu0fM4lFd2NcRwr3XPksINHaQ-G_xBniIqbw0Ls1jF44-csFCur-kEgU8awapJzKnqDKgw";
                 e = "AQAB";
               }
                : jwk);
            thumbprint = "NzbLsXh8uDCcd-6MNwXF4W_7noWXFZAfHkxZsRGC9Xs";
          }
           : thumbprints_item);
       ];
     cases =
       [
         ({
            why =
              "a worker's assertion at a launcher-run Keycloak, its key RFC \
               7638's example";
            jwk =
              ({
                 kty = "RSA";
                 n =
                   "0vx7agoebGcQSuuPiLJXZptN9nndrQmbXEps2aiAFbWhM78LhWx4cbbfAAtVT86zwu1RK7aPFFxuhDR1L6tSoc_BJECPebWKRXjBZCiFV4n3oknjhMstn64tZ_2W-5JsGY4Hc5n9yBXArwl93lqt7_RN5w6Cf0h4QyQ5v-65YGjQR0_FDW2QvzqY368QQMicAtaSqzs8KJZgnYb9c7d0zgdAZHzu6qMQvRL5hajrn1n91CbOpbISD08qNLyrdkt-bFTWhAI4vMQFh6WeZu0fM4lFd2NcRwr3XPksINHaQ-G_xBniIqbw0Ls1jF44-csFCur-kEgU8awapJzKnqDKgw";
                 e = "AQAB";
               }
                : jwk);
            client_id = "xynolog-worker-alice-laptop";
            token_endpoint =
              "http://localhost:8080/realms/xynolog/protocol/openid-connect/token";
            issued_at = 1798761600;
            jti = "6f1d3c2a9b8e4f70a5d2c1b0e9f8a7d6";
            header =
              ({
                 alg = "RS256";
                 kid = "NzbLsXh8uDCcd-6MNwXF4W_7noWXFZAfHkxZsRGC9Xs";
               }
                : header);
            claims =
              ({
                 iss = "xynolog-worker-alice-laptop";
                 sub = "xynolog-worker-alice-laptop";
                 aud =
                   "http://localhost:8080/realms/xynolog/protocol/openid-connect/token";
                 jti = "6f1d3c2a9b8e4f70a5d2c1b0e9f8a7d6";
                 iat = 1798761600;
                 exp = 1798761660;
               }
                : claims);
          }
           : cases_item);
       ];
   }
    : t)
