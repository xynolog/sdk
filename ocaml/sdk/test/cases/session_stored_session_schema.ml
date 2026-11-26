(* Generated from protocol/specs/src/session/StoredSession.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

let schema : Yojson.Safe.t =
  `Assoc
    [
      ("$schema", `String "https://json-schema.org/draft/2020-12/schema");
      ("$id", `String "https://xynolog.org/protocol/StoredSession.json");
      ("title", `String "StoredSession");
      ("type", `String "object");
      ( "description",
        `String
          "What is kept of a sign-in: the tokens an issuer issued, the client \
           they were issued to, and the issuer's endpoints a renewal and a \
           sign-out need, learned once at sign-in so no session asks again. \
           TOKENS, never a password. A stored value that lacks a member it \
           requires is no session." );
      ( "properties",
        `Assoc
          [
            ( "access",
              `Assoc
                [
                  ( "$ref",
                    `String "https://xynolog.org/protocol/AccessToken.json" );
                  ( "description",
                    `String
                      "The access token: short-lived, sent as a Bearer token."
                  );
                ] );
            ( "refresh",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String
                      "The refresh token: what renews the access token at the \
                       issuer without another sign-in." );
                ] );
            ( "clientId",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String
                      "The client the tokens were issued to, which a renewal \
                       and a revocation name." );
                ] );
            ( "tokenEndpoint",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String
                      "The issuer's token endpoint, where the refresh grant is \
                       made." );
                ] );
            ( "revocationEndpoint",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String
                      "The issuer's revocation endpoint (RFC 7009), where a \
                       sign-out tells it to forget the refresh token. Absent \
                       when the issuer has none." );
                ] );
            ( "personKey",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String
                      "Who the gateway said the sign-in's person is, as the \
                       key their caches and stream position are kept under \
                       (`lastEventIdKeyPrefix`), never the did itself. Written \
                       once the gateway names the person, on the sign-in whose \
                       token it was asked about; a renewal keeps it, a new \
                       sign-in starts without it, and forgetting the sign-in, \
                       however it is forgotten, reads it first to delete what \
                       is kept under it. Absent for a sign-in whose gateway \
                       has not yet named its person." );
                ] );
          ] );
      ( "required",
        `List
          [
            `String "access";
            `String "refresh";
            `String "clientId";
            `String "tokenEndpoint";
          ] );
    ]
