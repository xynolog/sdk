(* Generated from protocol/specs/src/bus/log-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type cases_item = {
  why : string;
  channel : string option;
  payload : (string * Yojson.Safe.t) list;
  shown : (string * Yojson.Safe.t) list;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.map (fun v -> ("channel", (fun s -> `String s) v)) r.channel;
         Option.Some
           ( "payload",
             (fun l -> `Assoc (List.map (fun (k, v) -> (k, Fun.id v)) l))
               r.payload );
         Option.Some
           ( "shown",
             (fun l -> `Assoc (List.map (fun (k, v) -> (k, Fun.id v)) l))
               r.shown );
       ])

type t = { comment : string; names : string list; cases : cases_item list }

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("names", (fun l -> `List (List.map (fun s -> `String s) l)) r.names);
         Option.Some
           ("cases", (fun l -> `List (List.map cases_item_json l)) r.cases);
       ])

let table : t =
  ({
     comment =
       "What a bus log shows of a payload, as every bus log must show it. With \
        XYNOLOG_BUS_LOG set, a Xynolog SDK or service writes one line for each \
        frame it sends or receives, and the last thing on a line is the \
        frame's payload. No line holds a credential. THE RULE reads a name and \
        no channel: the value of a member whose whole name is one of `names`, \
        letter for letter and in the same case, is shown as the text \
        `[withheld]`, wherever in a payload the member is (in the payload \
        itself, in an object within it at any depth, in an object inside an \
        array) and whatever its value is (text, a number, null, an object, an \
        array: the whole value is replaced, and nothing within it is read). \
        THE NAMES are the ones a credential goes by. The registry's payloads \
        declare one credential, the token a resource is cloned by, and name it \
        `token` (`yield:clone-resource-requested` and `yield:clone-create`, \
        which a client sends, and the `response` of \
        `yield:clone-token-generated`, which it receives). But some payloads \
        take any member (an agent's `parameters`, a job's `params` and its \
        `result`, a graph's `metadata`, what a description of a resource or of \
        a representation adds), and a credential put in one is withheld under \
        the name it has elsewhere: `cloneToken`, an upload's name for the \
        token a resource is cloned by; `accessToken` and `refreshToken`, a \
        sign-in's two tokens, and `access_token` and `refresh_token`, as an \
        issuer names them; `apiKey`, an inference provider's key as a \
        knowledge base's configuration names it, and `api_key`, as a Python \
        program does; `clientSecret` and `client_secret`, a service's secret \
        at its issuer, as a program and as the grant that spends it name it; \
        `secret` and `password`; and the header a credential is sent under, \
        which is `authorization` and `Authorization` (two spellings of one \
        header) and, for a provider's key, `x-api-key` and `x-goog-api-key`. A \
        name that only contains one of them is another name, and is shown: a \
        count of a model's tokens (`maxTokens`), a plural (`tokens`), another \
        case (`Token`), the member that names the environment variable a \
        credential is read from (`apiKeyEnv`, `passwordEnv`), an endpoint \
        (`tokenEndpoint`). Everything else is shown as it is: every other \
        member, an array's items in their order, a value that happens to be \
        one of the names. A frame's payload is an object, and so is every \
        case's. A log that can be given a payload that is not one reads an \
        array by the same rule and shows anything else as it is, and holds \
        that in its own tests. A case is a `payload` and what is `shown` of \
        it. How a log writes what it shows (as JSON, as a console's rendering \
        of an object) is its own, so a runner compares values and never text. \
        Every name has a case of its own, and no case withholds under a name \
        that is not listed. A case that is a channel's own payload names the \
        `channel`, and its `payload` is one the registry's schema for that \
        channel admits. Every bus log runs it, in whatever language it is \
        written. A runner that has the registry's payload types holds each \
        case that names a channel to that channel's payload type, the cases to \
        `names`, and `names` to the members the registry's payloads declare. \
        Add a name and its case here before changing an implementation.";
     names =
       [
         "token";
         "cloneToken";
         "accessToken";
         "access_token";
         "refreshToken";
         "refresh_token";
         "apiKey";
         "api_key";
         "clientSecret";
         "client_secret";
         "secret";
         "password";
         "authorization";
         "Authorization";
         "x-api-key";
         "x-goog-api-key";
       ];
     cases =
       [
         ({
            why =
              "yield:clone-resource-requested, as a client sends it: the \
               request is its token";
            channel = Some "yield:clone-resource-requested";
            payload = [ ("token", `String "clone-token-of-the-request") ];
            shown = [ ("token", `String "[withheld]") ];
          }
           : cases_item);
         ({
            why =
              "yield:clone-create, as the gateway has it: the token is \
               withheld, and what it rides with is shown, the gateway's stamp \
               included";
            channel = Some "yield:clone-create";
            payload =
              [
                ("_userId", `String "did:web:example.org:users:alice");
                ("token", `String "clone-token-of-the-command");
                ("name", `String "A clone");
                ("storageUri", `String "file://clones/a-clone.md");
                ( "contentChecksum",
                  `String
                    "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
                );
                ("byteSize", `Int 4);
                ("format", `String "text/markdown");
              ];
            shown =
              [
                ("_userId", `String "did:web:example.org:users:alice");
                ("token", `String "[withheld]");
                ("name", `String "A clone");
                ("storageUri", `String "file://clones/a-clone.md");
                ( "contentChecksum",
                  `String
                    "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
                );
                ("byteSize", `Int 4);
                ("format", `String "text/markdown");
              ];
          }
           : cases_item);
         ({
            why =
              "yield:clone-token-generated, as a client receives it: the token \
               is a member of the reply's response";
            channel = Some "yield:clone-token-generated";
            payload =
              [
                ( "response",
                  `Assoc
                    [
                      ("token", `String "clone-token-of-the-reply");
                      ("expiresAt", `String "2026-10-11T00:00:00.000Z");
                      ( "resource",
                        `Assoc
                          [
                            ("@context", `String "https://schema.org/");
                            ("@id", `String "res-1");
                            ("name", `String "A resource");
                            ("representations", `List []);
                          ] );
                    ] );
              ];
            shown =
              [
                ( "response",
                  `Assoc
                    [
                      ("token", `String "[withheld]");
                      ("expiresAt", `String "2026-10-11T00:00:00.000Z");
                      ( "resource",
                        `Assoc
                          [
                            ("@context", `String "https://schema.org/");
                            ("@id", `String "res-1");
                            ("name", `String "A resource");
                            ("representations", `List []);
                          ] );
                    ] );
              ];
          }
           : cases_item);
         ({
            why =
              "a token deep in a payload is withheld, and the members beside \
               it at each depth are shown";
            channel = None;
            payload =
              [
                ( "result",
                  `Assoc
                    [
                      ("kind", `String "clone");
                      ( "made",
                        `Assoc
                          [
                            ("by", `String "a worker");
                            ( "with",
                              `Assoc
                                [
                                  ("token", `String "deep-clone-token");
                                  ("uses", `Int 1);
                                ] );
                          ] );
                    ] );
              ];
            shown =
              [
                ( "result",
                  `Assoc
                    [
                      ("kind", `String "clone");
                      ( "made",
                        `Assoc
                          [
                            ("by", `String "a worker");
                            ( "with",
                              `Assoc
                                [
                                  ("token", `String "[withheld]");
                                  ("uses", `Int 1);
                                ] );
                          ] );
                    ] );
              ];
          }
           : cases_item);
         ({
            why =
              "a token in an object inside an array is withheld, in each \
               object that has one, and the array keeps its order";
            channel = None;
            payload =
              [
                ( "clones",
                  `List
                    [
                      `Assoc
                        [
                          ("token", `String "first-clone-token");
                          ("name", `String "first");
                        ];
                      `Assoc [ ("name", `String "second") ];
                      `Assoc
                        [
                          ("token", `String "third-clone-token");
                          ("name", `String "third");
                        ];
                    ] );
              ];
            shown =
              [
                ( "clones",
                  `List
                    [
                      `Assoc
                        [
                          ("token", `String "[withheld]");
                          ("name", `String "first");
                        ];
                      `Assoc [ ("name", `String "second") ];
                      `Assoc
                        [
                          ("token", `String "[withheld]");
                          ("name", `String "third");
                        ];
                    ] );
              ];
          }
           : cases_item);
         ({
            why = "an array inside an array is read too";
            channel = None;
            payload =
              [
                ( "rows",
                  `List
                    [
                      `List
                        [
                          `Assoc [ ("token", `String "row-clone-token") ];
                          `String "kept";
                        ];
                      `List [];
                    ] );
              ];
            shown =
              [
                ( "rows",
                  `List
                    [
                      `List
                        [
                          `Assoc [ ("token", `String "[withheld]") ];
                          `String "kept";
                        ];
                      `List [];
                    ] );
              ];
          }
           : cases_item);
         ({
            why =
              "a token that is a number is withheld, and is shown as the same \
               text";
            channel = None;
            payload = [ ("token", `Int 8675309) ];
            shown = [ ("token", `String "[withheld]") ];
          }
           : cases_item);
         ({
            why =
              "a token that is null is withheld: the name decides, not the \
               value";
            channel = None;
            payload = [ ("token", `Null); ("name", `String "A clone") ];
            shown =
              [ ("token", `String "[withheld]"); ("name", `String "A clone") ];
          }
           : cases_item);
         ({
            why = "a token that is true or false is withheld";
            channel = None;
            payload =
              [
                ("asked", `Assoc [ ("token", `Bool true) ]);
                ("answered", `Assoc [ ("token", `Bool false) ]);
              ];
            shown =
              [
                ("asked", `Assoc [ ("token", `String "[withheld]") ]);
                ("answered", `Assoc [ ("token", `String "[withheld]") ]);
              ];
          }
           : cases_item);
         ({
            why = "a token that is the empty text is withheld";
            channel = None;
            payload = [ ("token", `String "") ];
            shown = [ ("token", `String "[withheld]") ];
          }
           : cases_item);
         ({
            why =
              "a token that is an object is withheld whole: nothing within it \
               is read or shown";
            channel = None;
            payload =
              [
                ( "token",
                  `Assoc
                    [
                      ("value", `String "clone-token-in-an-object");
                      ("token", `String "clone-token-within-it");
                      ("expiresAt", `String "2026-10-11T00:00:00.000Z");
                    ] );
              ];
            shown = [ ("token", `String "[withheld]") ];
          }
           : cases_item);
         ({
            why = "a token that is an array is withheld whole";
            channel = None;
            payload =
              [
                ( "token",
                  `List
                    [
                      `String "clone-token-in-an-array";
                      `Assoc [ ("token", `String "clone-token-within-it") ];
                    ] );
              ];
            shown = [ ("token", `String "[withheld]") ];
          }
           : cases_item);
         ({
            why =
              "a name that only contains the word is another name, and is \
               shown: the counts of a model's tokens the protocol carries, a \
               plural, another case";
            channel = None;
            payload =
              [
                ("params", `Assoc [ ("maxTokens", `Int 4096) ]);
                ( "limits",
                  `Assoc
                    [
                      ("contextTokens", `Int 200000);
                      ("maxOutputTokens", `Int 8192);
                    ] );
                ( "tokens",
                  `List
                    [
                      `String "shown";
                      `String "as";
                      `String "they";
                      `String "are";
                    ] );
                ("Token", `String "shown as it is");
              ];
            shown =
              [
                ("params", `Assoc [ ("maxTokens", `Int 4096) ]);
                ( "limits",
                  `Assoc
                    [
                      ("contextTokens", `Int 200000);
                      ("maxOutputTokens", `Int 8192);
                    ] );
                ( "tokens",
                  `List
                    [
                      `String "shown";
                      `String "as";
                      `String "they";
                      `String "are";
                    ] );
                ("Token", `String "shown as it is");
              ];
          }
           : cases_item);
         ({
            why =
              "a value that is the word, or the text a token is shown as, is \
               no member of the name";
            channel = None;
            payload =
              [
                ("kind", `String "token");
                ("words", `List [ `String "token"; `String "[withheld]" ]);
              ];
            shown =
              [
                ("kind", `String "token");
                ("words", `List [ `String "token"; `String "[withheld]" ]);
              ];
          }
           : cases_item);
         ({
            why =
              "a payload with no token is shown as it is: text of any script, \
               numbers, null, and what is empty";
            channel = None;
            payload =
              [
                ("annotationId", `String "ann-1");
                ( "said",
                  `String
                    "two\n\
                     lines, na\195\175ve, \230\151\165\230\156\172\232\170\158"
                );
                ( "counted",
                  `List
                    [
                      `Int 1;
                      `Float 2.5;
                      `Int (-3);
                      `Assoc [ ("left", `Null); ("right", `Bool true) ];
                    ] );
                ( "nothing",
                  `Assoc [ ("members", `Assoc []); ("items", `List []) ] );
              ];
            shown =
              [
                ("annotationId", `String "ann-1");
                ( "said",
                  `String
                    "two\n\
                     lines, na\195\175ve, \230\151\165\230\156\172\232\170\158"
                );
                ( "counted",
                  `List
                    [
                      `Int 1;
                      `Float 2.5;
                      `Int (-3);
                      `Assoc [ ("left", `Null); ("right", `Bool true) ];
                    ] );
                ( "nothing",
                  `Assoc [ ("members", `Assoc []); ("items", `List []) ] );
              ];
          }
           : cases_item);
         ({
            why = "the empty payload is shown as it is";
            channel = None;
            payload = [];
            shown = [];
          }
           : cases_item);
         ({
            why =
              "cloneToken, which is what an upload names the token a resource \
               is cloned by";
            channel = None;
            payload =
              [
                ( "params",
                  `Assoc
                    [
                      ("cloneToken", `String "clone-token-of-an-upload");
                      ("archiveOriginal", `Bool true);
                    ] );
              ];
            shown =
              [
                ( "params",
                  `Assoc
                    [
                      ("cloneToken", `String "[withheld]");
                      ("archiveOriginal", `Bool true);
                    ] );
              ];
          }
           : cases_item);
         ({
            why =
              "accessToken, a sign-in's access token as a program's record of \
               it names it";
            channel = None;
            payload =
              [
                ( "result",
                  `Assoc
                    [
                      ("accessToken", `String "access-token-in-a-record");
                      ("expiresAt", `String "2026-10-11T00:00:00.000Z");
                    ] );
              ];
            shown =
              [
                ( "result",
                  `Assoc
                    [
                      ("accessToken", `String "[withheld]");
                      ("expiresAt", `String "2026-10-11T00:00:00.000Z");
                    ] );
              ];
          }
           : cases_item);
         ({
            why =
              "access_token, the same as an issuer's reply names it: what says \
               its kind and how long it lasts is shown";
            channel = None;
            payload =
              [
                ( "result",
                  `Assoc
                    [
                      ("access_token", `String "access-token-in-a-reply");
                      ("token_type", `String "Bearer");
                      ("expires_in", `Int 300);
                    ] );
              ];
            shown =
              [
                ( "result",
                  `Assoc
                    [
                      ("access_token", `String "[withheld]");
                      ("token_type", `String "Bearer");
                      ("expires_in", `Int 300);
                    ] );
              ];
          }
           : cases_item);
         ({
            why =
              "refreshToken, a sign-in's refresh token as the sign-in store \
               names it";
            channel = None;
            payload =
              [
                ( "metadata",
                  `Assoc
                    [
                      ("refreshToken", `String "refresh-token-in-a-store");
                      ("issuer", `String "https://issuer.example/realms/kb");
                    ] );
              ];
            shown =
              [
                ( "metadata",
                  `Assoc
                    [
                      ("refreshToken", `String "[withheld]");
                      ("issuer", `String "https://issuer.example/realms/kb");
                    ] );
              ];
          }
           : cases_item);
         ({
            why =
              "refresh_token, the same as an issuer and a refresh grant name \
               it: the grant's kind, whose value is the name, is shown";
            channel = None;
            payload =
              [
                ( "params",
                  `Assoc
                    [
                      ("grant_type", `String "refresh_token");
                      ("refresh_token", `String "refresh-token-in-a-grant");
                    ] );
              ];
            shown =
              [
                ( "params",
                  `Assoc
                    [
                      ("grant_type", `String "refresh_token");
                      ("refresh_token", `String "[withheld]");
                    ] );
              ];
          }
           : cases_item);
         ({
            why =
              "apiKey, an inference provider's key as a knowledge base's \
               configuration names it, among an agent's parameters";
            channel = None;
            payload =
              [
                ( "generator",
                  `Assoc
                    [
                      ("@type", `String "Software");
                      ("name", `String "A model");
                      ( "parameters",
                        `Assoc
                          [
                            ("temperature", `Float 0.2);
                            ("apiKey", `String "provider-key-in-a-configuration");
                          ] );
                    ] );
              ];
            shown =
              [
                ( "generator",
                  `Assoc
                    [
                      ("@type", `String "Software");
                      ("name", `String "A model");
                      ( "parameters",
                        `Assoc
                          [
                            ("temperature", `Float 0.2);
                            ("apiKey", `String "[withheld]");
                          ] );
                    ] );
              ];
          }
           : cases_item);
         ({
            why = "api_key, the same as a Python program names it";
            channel = None;
            payload =
              [
                ( "params",
                  `Assoc
                    [
                      ("provider", `String "anthropic");
                      ("base_url", `String "https://api.example");
                      ("api_key", `String "provider-key-in-a-program");
                    ] );
              ];
            shown =
              [
                ( "params",
                  `Assoc
                    [
                      ("provider", `String "anthropic");
                      ("base_url", `String "https://api.example");
                      ("api_key", `String "[withheld]");
                    ] );
              ];
          }
           : cases_item);
         ({
            why =
              "clientSecret, a service's secret at its issuer as a program's \
               record of it names it";
            channel = None;
            payload =
              [
                ( "params",
                  `Assoc
                    [
                      ("issuer", `String "https://issuer.example/realms/kb");
                      ("clientId", `String "xynolog-worker");
                      ("clientSecret", `String "client-secret-in-a-record");
                    ] );
              ];
            shown =
              [
                ( "params",
                  `Assoc
                    [
                      ("issuer", `String "https://issuer.example/realms/kb");
                      ("clientId", `String "xynolog-worker");
                      ("clientSecret", `String "[withheld]");
                    ] );
              ];
          }
           : cases_item);
         ({
            why = "client_secret, the same as the grant that spends it names it";
            channel = None;
            payload =
              [
                ( "params",
                  `Assoc
                    [
                      ("grant_type", `String "client_credentials");
                      ("client_id", `String "xynolog-worker");
                      ("client_secret", `String "client-secret-in-a-grant");
                    ] );
              ];
            shown =
              [
                ( "params",
                  `Assoc
                    [
                      ("grant_type", `String "client_credentials");
                      ("client_id", `String "xynolog-worker");
                      ("client_secret", `String "[withheld]");
                    ] );
              ];
          }
           : cases_item);
         ({
            why =
              "secret: a member of that name holds one, whatever it is the \
               secret of";
            channel = None;
            payload =
              [
                ( "metadata",
                  `Assoc
                    [
                      ("client", `String "xynolog-worker");
                      ("secret", `String "a-secret");
                    ] );
              ];
            shown =
              [
                ( "metadata",
                  `Assoc
                    [
                      ("client", `String "xynolog-worker");
                      ("secret", `String "[withheld]");
                    ] );
              ];
          }
           : cases_item);
         ({
            why = "password: a member of that name holds one, whatever it opens";
            channel = None;
            payload =
              [
                ( "params",
                  `Assoc
                    [
                      ("user", `String "xynolog");
                      ("password", `String "a-password");
                    ] );
              ];
            shown =
              [
                ( "params",
                  `Assoc
                    [
                      ("user", `String "xynolog");
                      ("password", `String "[withheld]");
                    ] );
              ];
          }
           : cases_item);
         ({
            why =
              "authorization, the header a credential is sent under, among the \
               headers of a request a result repeats";
            channel = None;
            payload =
              [
                ( "result",
                  `Assoc
                    [
                      ( "headers",
                        `Assoc
                          [
                            ( "authorization",
                              `String "Bearer a-token-in-a-header" );
                            ("content-type", `String "application/json");
                          ] );
                    ] );
              ];
            shown =
              [
                ( "result",
                  `Assoc
                    [
                      ( "headers",
                        `Assoc
                          [
                            ("authorization", `String "[withheld]");
                            ("content-type", `String "application/json");
                          ] );
                    ] );
              ];
          }
           : cases_item);
         ({
            why = "Authorization, the same header in its other spelling";
            channel = None;
            payload =
              [
                ( "result",
                  `Assoc
                    [
                      ( "headers",
                        `Assoc
                          [
                            ( "Authorization",
                              `String "Bearer another-token-in-a-header" );
                            ("Content-Type", `String "application/json");
                          ] );
                    ] );
              ];
            shown =
              [
                ( "result",
                  `Assoc
                    [
                      ( "headers",
                        `Assoc
                          [
                            ("Authorization", `String "[withheld]");
                            ("Content-Type", `String "application/json");
                          ] );
                    ] );
              ];
          }
           : cases_item);
         ({
            why =
              "x-api-key, the header one inference provider takes its key under";
            channel = None;
            payload =
              [
                ( "result",
                  `Assoc
                    [
                      ( "headers",
                        `Assoc
                          [
                            ("x-api-key", `String "provider-key-in-a-header");
                            ("anthropic-version", `String "2023-06-01");
                          ] );
                    ] );
              ];
            shown =
              [
                ( "result",
                  `Assoc
                    [
                      ( "headers",
                        `Assoc
                          [
                            ("x-api-key", `String "[withheld]");
                            ("anthropic-version", `String "2023-06-01");
                          ] );
                    ] );
              ];
          }
           : cases_item);
         ({
            why = "x-goog-api-key, the header another takes its key under";
            channel = None;
            payload =
              [
                ( "result",
                  `Assoc
                    [
                      ( "headers",
                        `Assoc
                          [
                            ( "x-goog-api-key",
                              `String "another-provider-key-in-a-header" );
                            ("x-goog-api-client", `String "a-client/1.0");
                          ] );
                    ] );
              ];
            shown =
              [
                ( "result",
                  `Assoc
                    [
                      ( "headers",
                        `Assoc
                          [
                            ("x-goog-api-key", `String "[withheld]");
                            ("x-goog-api-client", `String "a-client/1.0");
                          ] );
                    ] );
              ];
          }
           : cases_item);
         ({
            why =
              "a name that only contains one of the names is another name, and \
               is shown: the member that names the environment variable a \
               credential is read from, an issuer's endpoint, who a request is \
               authenticated as, and where authorization is had";
            channel = None;
            payload =
              [
                ( "engines",
                  `List
                    [
                      `Assoc
                        [
                          ("baseUrl", `String "https://api.example");
                          ("apiKeyEnv", `String "PROVIDER_API_KEY");
                        ];
                    ] );
                ("broker", `Assoc [ ("passwordEnv", `String "BROKER_PASSWORD") ]);
                ( "signIn",
                  `Assoc
                    [
                      ( "tokenEndpoint",
                        `String "https://issuer.example/realms/kb/token" );
                    ] );
                ( "status",
                  `Assoc
                    [
                      ( "authenticatedAs",
                        `String "did:web:example.org:users:alice" );
                      ( "authorization_servers",
                        `List [ `String "https://issuer.example/realms/kb" ] );
                    ] );
              ];
            shown =
              [
                ( "engines",
                  `List
                    [
                      `Assoc
                        [
                          ("baseUrl", `String "https://api.example");
                          ("apiKeyEnv", `String "PROVIDER_API_KEY");
                        ];
                    ] );
                ("broker", `Assoc [ ("passwordEnv", `String "BROKER_PASSWORD") ]);
                ( "signIn",
                  `Assoc
                    [
                      ( "tokenEndpoint",
                        `String "https://issuer.example/realms/kb/token" );
                    ] );
                ( "status",
                  `Assoc
                    [
                      ( "authenticatedAs",
                        `String "did:web:example.org:users:alice" );
                      ( "authorization_servers",
                        `List [ `String "https://issuer.example/realms/kb" ] );
                    ] );
              ];
          }
           : cases_item);
       ];
   }
    : t)
