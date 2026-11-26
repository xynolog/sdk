open Xynolog
module O = OAuth
module Store = Sign_in_store

let issuer_url = "https://issuer.example/realm"
let endpoint = issuer_url ^ "/token"
let get = function Ok value -> value | Error _ -> failwith "OAuth error"
let json fields = Yojson.Safe.to_string (`Assoc fields)
let str value = `String value

let issuer () =
  O.discover ~issuer:issuer_url (fun (request : O.request) ->
      assert (request.meth = "GET");
      assert (request.url = issuer_url ^ "/.well-known/openid-configuration");
      ( 200,
        json
          [
            ("issuer", str issuer_url);
            ("authorization_endpoint", str (issuer_url ^ "/auth"));
            ("token_endpoint", str endpoint);
            ("device_authorization_endpoint", str (issuer_url ^ "/device"));
            ("revocation_endpoint", str (issuer_url ^ "/revoke"));
          ] ))
  |> get

let pkce () =
  let issuer = issuer () in
  let next = ref 0 in
  let random count =
    incr next;
    String.make count (Char.chr !next)
  in
  let redirect_uri = "http://localhost:4000/callback" in
  let redirect =
    O.begin_redirect issuer ~random
      {
        target =
          Models.decode Models.http_endpoint
            {|{"kind":"http","host":"localhost","port":4000,"protocol":"http"}|}
          |> Result.get_ok;
        redirect_uri;
        kb_id = None;
        expected_did = None;
        expected_name = None;
      }
  in
  let uri = Uri.of_string (O.url redirect) in
  let param key = Option.get (Uri.get_query_param uri key) in
  let callback state = redirect_uri ^ "?code=abc&state=" ^ state in
  let calls = ref 0 in
  let http (request : O.request) =
    incr calls;
    assert (request.url = endpoint);
    assert (List.assoc "client_id" request.form = "xynolog-browser");
    assert (
      List.assoc "code_verifier" request.form
      = "AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQE");
    (200, {|{"access_token":"access"}|})
  in
  let refused code = Error { O.code; status = None } in
  let finish callback = O.finish_redirect http redirect ~callback in
  assert (finish (callback "wrong") = refused Error_codes.Sign_in.State);
  assert (
    finish (redirect_uri ^ "?error=access_denied&state=" ^ param "state")
    = refused Error_codes.Sign_in.Denied);
  assert (
    finish (redirect_uri ^ "?error=server_error&state=" ^ param "state")
    = refused Error_codes.Sign_in.Exchange);
  assert (
    finish (redirect_uri ^ "?state=" ^ param "state")
    = refused Error_codes.Sign_in.Exchange);
  assert (!calls = 0);
  assert (
    (get (O.finish_redirect http redirect ~callback:(callback (param "state"))))
      .access_token = "access");
  assert (!calls = 1)

let token label =
  "header."
  ^ Base64.encode_exn ~pad:false ~alphabet:Base64.uri_safe_alphabet
      (json
         [
           ("iss", str issuer_url);
           ("email", str "test@example.org");
           ("jti", str label);
         ])
  ^ ".signature"

let token_response label =
  ( 200,
    json
      [
        ("access_token", str (token label));
        ("refresh_token", str ("refresh-" ^ label));
        ("expires_in", `Int 3600);
      ] )

let store () =
  Eio_main.run @@ fun env ->
  let directory = Filename.temp_file "xynolog-sign-in" "" in
  Unix.unlink directory;
  Unix.mkdir directory 0o700;
  Fun.protect
    ~finally:(fun () ->
      Array.iter
        (fun name -> Unix.unlink (Filename.concat directory name))
        (Sys.readdir directory);
      Unix.rmdir directory)
    (fun () ->
      let clock =
        Clock.make ~wall:(Eio.Stdenv.clock env)
          ~monotonic:(Eio.Stdenv.mono_clock env)
          ~jitter:(Random.State.make [| 1 |])
      in
      let store = Store.make ~clock ~directory in
      let issuer = issuer () in
      let key = "local:example.org" in
      let device =
        get
          (O.begin_device
             (fun _ ->
               ( 200,
                 {|{"device_code":"device","user_code":"USER","verification_uri":"https://issuer.example/verify","expires_in":30}|}
               ))
             issuer)
      in
      let path = Filename.concat directory "tokens.json" in
      Out_channel.with_open_gen [ Open_wronly; Open_creat; Open_excl ]
        0o600 path (fun file ->
          output_string file {|{"future":{"newField":true}}|});
      let save label =
        match O.poll_device (fun _ -> token_response label) issuer device with
        | Ok (O.Issued tokens) ->
            get (Store.save_device store ~key ~issuer tokens)
        | _ -> failwith "the poll issued no tokens"
      in
      save "first";
      assert ((Unix.stat path).st_perm = 0o600);
      assert (
        (Unix.stat (Filename.concat directory "tokens.lock")).st_perm = 0o600);
      assert (
        Store.renew store ~key
          ~http:(fun _ -> assert false)
          ~holding:(Some "old")
        = Session.Renewed (token "first"));
      assert (
        Store.renew store ~key
          ~holding:(Some (token "first"))
          ~http:(fun _ ->
            save "other-writer";
            token_response "discarded")
        = Session.Renewed (token "other-writer"));
      assert (
        Store.renew store ~key
          ~holding:(Some (token "other-writer"))
          ~http:(fun _ ->
            Store.remove store ~key;
            token_response "discarded")
        = Session.Refused);
      assert (Store.find store ~key = None);
      save "for-revocation";
      assert (
        Store.sign_out store ~key ~http:(fun request ->
            assert (Store.find store ~key = None);
            assert (List.assoc "token" request.O.form = "refresh-for-revocation");
            (500, ""))
        = Error { O.code = Error_codes.Sign_in.Exchange; status = Some 500 });
      assert (Store.find store ~key = None);
      assert (
        Yojson.Safe.from_file path
        = `Assoc [ ("future", `Assoc [ ("newField", `Bool true) ]) ]))

let field = Yojson.Safe.Util.member
let optional = function `String value -> Some value | _ -> None
let get_text name value = Option.get (optional (field name value))

(* The sign-in a device grant saves, held to sign-in-store/SignIn.json both
   ways: it is written with every member the schema states and no other, and
   one stored without a member is found exactly when the schema does not
   require it. A member the schema gains, or one the store adds, fails
   here. *)
let sign_in_census () =
  Eio_main.run @@ fun env ->
  let directory = Filename.temp_file "xynolog-sign-in" "" in
  Unix.unlink directory;
  Unix.mkdir directory 0o700;
  Fun.protect
    ~finally:(fun () ->
      Array.iter
        (fun name -> Unix.unlink (Filename.concat directory name))
        (Sys.readdir directory);
      Unix.rmdir directory)
    (fun () ->
      let clock =
        Clock.make ~wall:(Eio.Stdenv.clock env)
          ~monotonic:(Eio.Stdenv.mono_clock env)
          ~jitter:(Random.State.make [| 1 |])
      in
      let store = Store.make ~clock ~directory in
      let issuer = issuer () in
      let key = "local:example.org" in
      let device =
        get
          (O.begin_device
             (fun _ ->
               ( 200,
                 {|{"device_code":"device","user_code":"USER","verification_uri":"https://issuer.example/verify","expires_in":30}|}
               ))
             issuer)
      in
      (match O.poll_device (fun _ -> token_response "kept") issuer device with
      | Ok (O.Issued tokens) ->
          get (Store.save_device store ~key ~issuer tokens)
      | _ -> failwith "the poll issued no tokens");
      let path = Filename.concat directory "tokens.json" in
      let written =
        Yojson.Safe.Util.to_assoc (field key (Yojson.Safe.from_file path))
      in
      let schema = Protocol_cases.Sign_in_store_sign_in_schema.schema in
      let names value =
        List.sort compare (List.map fst (Yojson.Safe.Util.to_assoc value))
      in
      let members = names (field "properties" schema) in
      let required =
        List.map Yojson.Safe.Util.to_string
          (Yojson.Safe.Util.to_list (field "required" schema))
      in
      let found fields =
        Out_channel.with_open_gen [ Open_wronly; Open_trunc ] 0o600 path
          (fun file -> output_string file (json [ (key, `Assoc fields) ]));
        Store.find store ~key <> None
      in
      Alcotest.(check (list string))
        "a sign-in is written with the schema's members" members
        (names (`Assoc written));
      Alcotest.(check bool) "a sign-in is found as written" true (found written);
      List.iter
        (fun member ->
          Alcotest.(check bool)
            ("a sign-in without " ^ member ^ " is found only if not required")
            (not (List.mem member required))
            (found (List.remove_assoc member written)))
        members)

module Store_cases = Protocol_cases.Sign_in_store_cases
module Assertion_cases = Protocol_cases.Session_client_assertion_cases

(* Shared rows from sign-in-store/cases.json. *)
let paths () =
  List.iter
    (fun (row : Store_cases.cases_item) ->
      let platform =
        Option.get
          (Xynolog.Enums.System.of_string (Store_cases.system_value row.os))
      in
      let actual =
        Store.state_directory ~platform ~home:row.home
          ~xdg_state_home:row.xdg_state_home ~local_app_data:row.local_app_data
      in
      Alcotest.(check (option string)) row.why row.dir actual)
    Store_cases.table.cases

let renewals () =
  Eio_main.run @@ fun env ->
  let clock =
    Clock.make ~wall:(Eio.Stdenv.clock env)
      ~monotonic:(Eio.Stdenv.mono_clock env)
      ~jitter:(Random.State.make [| 1 |])
  in
  let run (row : Store_cases.renewals_item) =
    let dir = Filename.temp_file "xynolog-renewal" "" in
    Unix.unlink dir;
    Unix.mkdir dir 0o700;
    let file = Filename.concat dir "tokens.json" in
    Fun.protect
      ~finally:(fun () ->
        Array.iter
          (fun name -> Unix.unlink (Filename.concat dir name))
          (Sys.readdir dir);
        Unix.rmdir dir)
      (fun () ->
        let why = row.why in
        (* The store's file holding [entry], with the members the store
           writes beside a sign-in's tokens. *)
        let write (entry : Store_cases.kept option) =
          let entries =
            match entry with
            | None -> []
            | Some kept ->
                [
                  ( "local:test",
                    `Assoc
                      (Yojson.Safe.Util.to_assoc (Store_cases.kept_json kept)
                      @ [
                          ("issuer", str issuer_url);
                          ("tokenEndpoint", str endpoint);
                          ("obtainedAt", str "2026-01-01T00:00:00Z");
                          ( "expiresAt",
                            str
                              (if List.mem kept.token row.expired then
                                 "2000-01-01T00:00:00Z"
                               else "2099-01-01T00:00:00Z") );
                        ]) );
                ]
          in
          Out_channel.with_open_gen [ Open_wronly; Open_creat; Open_trunc ]
            0o600 file (fun stream -> output_string stream (json entries))
        in
        write (Some row.kept);
        let meanwhile (moment : Store_cases.when_) =
          match row.meanwhile with
          | Some { when_; theirs; _ } when when_ = moment -> write theirs
          | Some _ | None -> ()
        in
        meanwhile Before;
        let store = Store.make ~clock ~directory:dir in
        let spent = ref [] in
        let http (request : O.request) =
          spent := List.assoc "refresh_token" request.form :: !spent;
          meanwhile During;
          ( 200,
            json
              (("access_token", str row.issues.token)
              :: Option.to_list
                   (Option.map
                      (fun value -> ("refresh_token", str value))
                      row.issues.refresh_token)) )
        in
        let actual =
          match
            Store.renew store ~key:"local:test" ~http ~holding:row.holding
          with
          | Session.Renewed value -> Some value
          | Session.Refused -> None
          | Session.Unavailable -> failwith why
        in
        Alcotest.(check (option string)) why row.gives actual;
        Alcotest.(check (list string)) why (Option.to_list row.spends) !spent;
        let kept = field "local:test" (Yojson.Safe.from_file file) in
        let left =
          match kept with
          | `Null -> None
          | value ->
              Some
                (get_text "token" value, optional (field "refreshToken" value))
        in
        Alcotest.(check (option (pair string (option string))))
          why
          (Option.map
             (fun ({ token; refresh_token } : Store_cases.kept) ->
               (token, Some refresh_token))
             row.leaves)
          left)
  in
  List.iter run Store_cases.table.renewals

(* Shared rows from session/client-assertion-cases.json. *)
let rsa () =
  Eio_main.run @@ fun env ->
  Mirage_crypto_rng_unix.use_default ();
  let pem =
    In_channel.with_open_bin "../probes/peer-key.pem" In_channel.input_all
  in
  let key = Option.get (O.rsa_key_of_pem pem) in
  let public =
    X509.Private_key.public (get (X509.Private_key.decode_pem pem))
  in
  let vector = Assertion_cases.table in
  let thumbprint ({ e; n; _ } : Assertion_cases.jwk) = O.rsa_thumbprint ~e ~n in
  List.iter
    (fun (row : Assertion_cases.thumbprints_item) ->
      Alcotest.(check string) row.why row.thumbprint (thumbprint row.jwk))
    vector.thumbprints;
  List.iter
    (fun (row : Assertion_cases.cases_item) ->
      let token_endpoint = row.token_endpoint in
      let issuer =
        get
          (O.discover ~issuer:issuer_url (fun _ ->
               ( 200,
                 json
                   [
                     ("issuer", str issuer_url);
                     ("authorization_endpoint", str (issuer_url ^ "/auth"));
                     ("token_endpoint", str token_endpoint);
                   ] )))
      in
      let wall = Eio_mock.Clock.make () in
      Eio_mock.Clock.set_time wall (float row.issued_at);
      let clock =
        Clock.make ~wall
          ~monotonic:(Eio.Stdenv.mono_clock env)
          ~jitter:(Random.State.make [| 1 |])
      in
      let decode value =
        get (Base64.decode ~pad:false ~alphabet:Base64.uri_safe_alphabet value)
      in
      let http (request : O.request) =
        assert (request.url = token_endpoint);
        assert (List.map fst request.form = vector.form);
        assert (List.assoc "grant_type" request.form = vector.grant_type);
        assert (
          List.assoc "client_assertion_type" request.form
          = vector.assertion_type);
        (match
           String.split_on_char '.' (List.assoc "client_assertion" request.form)
         with
        | [ header; claims; signature ] ->
            let message = header ^ "." ^ claims in
            assert (
              Result.is_ok
                (X509.Public_key.verify `SHA256 ~scheme:`RSA_PKCS1
                   ~signature:(decode signature) public (`Message message)));
            let header = Yojson.Safe.from_string (decode header) in
            assert (get_text "alg" header = row.header.alg);
            assert (row.header.kid = thumbprint row.jwk);
            assert (String.length (get_text "kid" header) = 43);
            (* The assertion's claims, every one and no other. *)
            let sort json =
              List.sort compare (Yojson.Safe.Util.to_assoc json)
            in
            assert (
              sort (Yojson.Safe.from_string (decode claims))
              = sort (Assertion_cases.claims_json row.claims))
        | _ -> assert false);
        (200, {|{"access_token":"rsa-token"}|})
      in
      assert (
        (get
           (O.service_key http issuer ~clock
              ~jti:(fun () -> row.jti)
              ~client_id:row.client_id ~key))
          .access_token = "rsa-token"))
    vector.cases

(* A renewal the issuer answered with a status the refresh retry rule does not
   try again is refused, whatever its body; one it tries again, and one with
   no answer, is not. *)
let refusals () =
  let renewal answer =
    O.refresh_script
      (fun _ -> answer)
      ~token_endpoint:endpoint ~refresh_token:"kept"
  in
  let refused answer =
    match renewal answer with
    | Error error -> O.refresh_refused error
    | Ok _ -> failwith "the renewal was granted"
  in
  assert (refused (400, {|{"error":"invalid_grant"}|}));
  assert (refused (401, "not JSON"));
  assert (refused (200, "{}"));
  assert (not (refused (503, "")));
  assert (not (refused (429, {|{"error":"slow_down"}|})));
  assert (
    renewal (503, "")
    = Error { O.code = Error_codes.Sign_in.Exchange; status = Some 503 });
  assert (
    not
      (O.refresh_refused
         { O.code = Error_codes.Sign_in.Exchange; status = None }))

let revoke () =
  let http (request : O.request) =
    assert (request.url = issuer_url ^ "/revoke");
    assert (request.meth = "POST");
    assert (List.assoc "client_id" request.form = "xynolog-cli");
    assert (List.assoc "token_type_hint" request.form = "refresh_token");
    assert (List.assoc "token" request.form = "kept");
    (200, "")
  in
  assert (
    O.revoke_script http ~revocation_endpoint:(issuer_url ^ "/revoke")
      ~refresh_token:"kept"
    = Ok ())

let agent () =
  Eio_main.run @@ fun env ->
  Eio.Switch.run @@ fun sw ->
  let clock =
    Clock.make ~wall:(Eio.Stdenv.clock env)
      ~monotonic:(Eio.Stdenv.mono_clock env)
      ~jitter:(Random.State.make [| 3 |])
  in
  let did = "did:web:kb.example:agents:worker" in
  let grants = ref 0 in
  let http (request : O.request) =
    incr grants;
    assert (request.url = endpoint);
    assert (List.assoc "client_secret" request.form = "secret");
    match !grants with
    | 1 -> (200, {|{"access_token":"initial"}|})
    | 2 -> (503, {|{"error":"unavailable"}|})
    | _ -> (200, {|{"access_token":"replacement"}|})
  in
  let call ~sw:_ ~meth ~path ~headers ~body:_ ~progress:_ =
    assert (meth = "GET" && path = "/api/users/me");
    assert (List.assoc "authorization" headers = "Bearer initial");
    let identity =
      json
        [
          ("did", str did);
          ("domain", str "kb.example");
          ("email", `Null);
          ("name", `Null);
          ("image", `Null);
        ]
    in
    (200, [], Eio.Flow.string_source identity)
  in
  let agent =
    get
      (Agent.sign_in ~sw ~clock ~issuer:(issuer ()) ~http ~client_id:"worker"
         ~proof:(Agent.Secret "secret")
         ~key:(fun () -> "unique")
         ~call ())
  in
  assert (Identifiers.User_id.to_string (Agent.did agent) = did);
  let session = Agent.session agent in
  assert (Session.refresh_refused session ~refused:"initial" = None);
  assert (Session.credential session = Some "initial");
  assert (
    Session.refresh_refused session ~refused:"initial" = Some "replacement");
  Agent.close agent

(* A gateway that does not name the agent fails the sign-in at once: one grant,
   one request, whatever it answers. *)
let agent_named_once () =
  Eio_main.run @@ fun env ->
  Eio.Switch.run @@ fun sw ->
  let clock =
    Clock.make ~wall:(Eio.Stdenv.clock env)
      ~monotonic:(Eio.Stdenv.mono_clock env)
      ~jitter:(Random.State.make [| 3 |])
  in
  let sign_in answer =
    let grants = ref 0 and asks = ref 0 in
    let http (_ : O.request) =
      incr grants;
      (200, {|{"access_token":"initial"}|})
    in
    let call ~sw:_ ~meth:_ ~path ~headers:_ ~body:_ ~progress:_ =
      assert (path = "/api/users/me");
      incr asks;
      answer ()
    in
    let outcome =
      Agent.sign_in ~sw ~clock ~issuer:(issuer ()) ~http ~client_id:"worker"
        ~proof:(Agent.Secret "secret")
        ~key:(fun () -> "unique")
        ~call ()
    in
    assert (!grants = 1 && !asks = 1);
    match outcome with
    | Error (Agent.Gateway failure) -> failure
    | _ -> failwith "the sign-in did not fail at the gateway"
  in
  let answered status =
    sign_in (fun () -> (status, [], Eio.Flow.string_source {|{"error":"no"}|}))
  in
  let unready = answered 503 in
  assert (unready.code = Error_codes.Transport.Unavailable);
  assert (unready.status = Some 503);
  let refused = answered 401 in
  assert (refused.code = Error_codes.Transport.Unauthorized);
  assert ((answered 404).code = Error_codes.Transport.Not_found);
  let unreachable = sign_in (fun () -> raise End_of_file) in
  assert (unreachable.code = Error_codes.Transport.Unavailable);
  assert (unreachable.status = None)

let () =
  Alcotest.run "OCaml sign-in"
    [
      ( "OAuth",
        [
          Alcotest.test_case "redirect state and PKCE" `Quick pkce;
          Alcotest.test_case "RSA assertion and thumbprint" `Quick rsa;
          Alcotest.test_case "renewal refused by status" `Quick refusals;
          Alcotest.test_case "issuer revocation form" `Quick revoke;
          Alcotest.test_case "agent identity and renewal" `Quick agent;
          Alcotest.test_case "agent named once" `Quick agent_named_once;
        ] );
      ( "shared store",
        [
          Alcotest.test_case "state paths" `Quick paths;
          Alcotest.test_case "renewal interleavings" `Quick renewals;
        ] );
      ( "store",
        [
          Alcotest.test_case "permissions, concurrent update and sign-out"
            `Quick store;
          Alcotest.test_case "a sign-in is the schema's" `Quick sign_in_census;
        ] );
    ]
