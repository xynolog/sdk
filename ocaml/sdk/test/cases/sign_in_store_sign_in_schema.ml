(* Generated from protocol/specs/src/sign-in-store/SignIn.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

let schema : Yojson.Safe.t =
  `Assoc
    [
      ("$schema", `String "https://json-schema.org/draft/2020-12/schema");
      ("$id", `String "https://xynolog.org/protocol/SignIn.json");
      ("title", `String "SignIn");
      ("type", `String "object");
      ( "description",
        `String
          "One sign-in to a running stack's knowledge base, as the sign-in \
           store keeps it: the tokens an issuer issued to the script client, \
           and what a renewal and a sign-out need of that issuer, learned once \
           at sign-in. TOKENS, never a password. An entry of \
           <stateDir>/tokens.json (see README.md)." );
      ( "properties",
        `Assoc
          [
            ( "token",
              `Assoc
                [
                  ( "$ref",
                    `String "https://xynolog.org/protocol/AccessToken.json" );
                  ( "description",
                    `String
                      "The access token: short-lived, sent as a Bearer token."
                  );
                ] );
            ( "refreshToken",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String
                      "The refresh token: long-lived, and what renews the \
                       access token at the issuer without another sign-in. An \
                       entry with none cannot be renewed." );
                ] );
            ( "email",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String
                      "Who signed in: the address the access token named when \
                       the sign-in was made, which is the one the gateway \
                       answers for it. For display. Absent when the token \
                       named none. A writer that renews an entry keeps it as \
                       it was." );
                ] );
            ( "obtainedAt",
              `Assoc
                [
                  ("type", `String "string");
                  ("format", `String "date-time");
                  ( "description",
                    `String
                      "When the access token was issued to this machine, RFC \
                       3339 in UTC." );
                ] );
            ( "expiresAt",
              `Assoc
                [
                  ("type", `String "string");
                  ("format", `String "date-time");
                  ( "description",
                    `String
                      "When the access token stops working, RFC 3339 in UTC, \
                       so a reader can renew before sending a token it knows \
                       is dead. Absent when the issuer named no lifetime: the \
                       gateway's refusal is then the signal." );
                ] );
            ( "issuer",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String
                      "The issuer the sign-in came from: the one the access \
                       token named when the sign-in was made. A writer that \
                       renews an entry keeps it." );
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
          ] );
      ( "required",
        `List
          [
            `String "token";
            `String "obtainedAt";
            `String "issuer";
            `String "tokenEndpoint";
          ] );
    ]
