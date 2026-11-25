type request = { meth : string; url : string; form : (string * string) list }
type http = request -> int * string
type error = { code : Error_codes.Sign_in.t; status : int option }
type script
type browser
type service

type 'grant tokens = {
  access_token : string;
  refresh_token : string option;
  expires_in : int option;
}

type poll = Issued of script tokens | Pending | Slow_down

type device = {
  code : Records.Device_code.t;
  device_code : string;
  interval : int;
}

let ( let* ) = Result.bind

let member key = function
  | `Assoc fields -> List.assoc_opt key fields
  | _ -> None

let string key json =
  match member key json with
  | Some (`String value) when value <> "" -> Some value
  | _ -> None

let seconds key json =
  match member key json with
  | Some (`Int value) when value > 0 -> Some value
  | _ -> None

let failed ?status code = Error { code; status }

let required ?status code = function
  | Some value -> Ok value
  | None -> failed ?status code

let endpoint value =
  let uri = Uri.of_string value in
  let host = Uri.host uri in
  if Uri.userinfo uri <> None || Uri.fragment uri <> None || host = None then
    None
  else
    match Uri.scheme uri with
    | Some "https" -> Some value
    | Some "http"
      when List.mem host [ Some "localhost"; Some "127.0.0.1"; Some "::1" ] ->
        Some value
    | _ -> None

(* The issuer's answer to [request]: its status, and its body when that is
   JSON. *)
let answer http request =
  let status, body = http request in
  ( status,
    try Some (Yojson.Safe.from_string body) with Yojson.Json_error _ -> None )

(* The body of an answer that grants [request]. Any other answer fails as
   [code], with its status. *)
let exchange http ~code request =
  match answer http request with
  | status, Some json when status >= 200 && status < 300 -> Ok (status, json)
  | status, _ -> failed ~status code

let discover http ~issuer =
  let code = Error_codes.Sign_in.Discovery in
  let* issuer = required code (endpoint issuer) in
  let* () =
    if Uri.query (Uri.of_string issuer) = [] then Ok () else failed code
  in
  let base =
    if String.ends_with ~suffix:"/" issuer then
      String.sub issuer 0 (String.length issuer - 1)
    else issuer
  in
  let* status, json =
    exchange http ~code
      {
        meth = "GET";
        url = base ^ "/.well-known/openid-configuration";
        form = [];
      }
  in
  let get name = Option.bind (string name json) endpoint in
  if string "issuer" json <> Some issuer then failed ~status code
  else
    let* authorization = required ~status code (get "authorization_endpoint") in
    let* token = required ~status code (get "token_endpoint") in
    Ok
      {
        Records.Pending_authorization_issuer.issuer;
        authorization;
        token;
        device = get "device_authorization_endpoint";
        revocation = get "revocation_endpoint";
      }

let encoded bytes =
  Base64.encode_exn ~pad:false ~alphabet:Base64.uri_safe_alphabet bytes

let code_challenge verifier =
  Digestif.SHA256.(to_raw_string (digest_string verifier)) |> encoded

let url (pending : Records.Pending_authorization.t) =
  Uri.add_query_params'
    (Uri.of_string pending.issuer.authorization)
    [
      ("response_type", "code");
      ("client_id", Oauth_facts.browser);
      ("redirect_uri", pending.redirect_uri);
      ("scope", Oauth_facts.scope);
      ("state", pending.state);
      ("code_challenge", code_challenge pending.verifier);
      ("code_challenge_method", "S256");
    ]
  |> Uri.to_string

let begin_redirect issuer ~random
    (options : Records.Begin_authorization_options.t) =
  let draw () =
    let bytes = random 32 in
    if String.length bytes <> 32 then
      invalid_arg "OAuth random source returned the wrong number of bytes";
    encoded bytes
  in
  let verifier = draw () in
  let state = draw () in
  {
    Records.Pending_authorization.state;
    verifier;
    redirect_uri = options.redirect_uri;
    target = options.target;
    issuer;
    kb_id = options.kb_id;
    expected_did = options.expected_did;
    expected_name = options.expected_name;
  }

(* The tokens an answer of [status] grants. *)
let issued ~status json =
  let* access_token =
    required ~status Error_codes.Sign_in.Exchange (string "access_token" json)
  in
  Ok
    {
      access_token;
      refresh_token = string "refresh_token" json;
      expires_in = seconds "expires_in" json;
    }

let grant http ~token_endpoint form =
  let code = Error_codes.Sign_in.Exchange in
  let* url = required code (endpoint token_endpoint) in
  let* status, json = exchange http ~code { meth = "POST"; url; form } in
  issued ~status json

let finish_redirect http (pending : Records.Pending_authorization.t) ~callback =
  let callback = Uri.of_string callback in
  let param name =
    match
      List.filter_map
        (fun (key, values) -> if key = name then Some values else None)
        (Uri.query callback)
    with
    | [ [ value ] ] -> Some value
    | _ -> None
  in
  let address uri = Uri.with_query (Uri.with_fragment uri None) [] in
  match List.assoc_opt "error" (Uri.query callback) with
  | Some ("access_denied" :: _) -> failed Error_codes.Sign_in.Denied
  | Some _ -> failed Error_codes.Sign_in.Exchange
  | None -> (
      if
        param "state" <> Some pending.state
        || address callback <> address (Uri.of_string pending.redirect_uri)
      then failed Error_codes.Sign_in.State
      else
        match param "code" with
        | Some code when code <> "" ->
            grant http ~token_endpoint:pending.issuer.token
              [
                ("grant_type", "authorization_code");
                ("client_id", Oauth_facts.browser);
                ("code", code);
                ("redirect_uri", pending.redirect_uri);
                ("code_verifier", pending.verifier);
              ]
        | _ -> failed Error_codes.Sign_in.Exchange)

let begin_device http (issuer : Records.Pending_authorization_issuer.t) =
  let code = Error_codes.Sign_in.Exchange in
  let* url = required Error_codes.Sign_in.Discovery issuer.device in
  let* status, json =
    exchange http ~code
      {
        meth = "POST";
        url;
        form =
          [ ("client_id", Oauth_facts.script); ("scope", Oauth_facts.scope) ];
      }
  in
  let required value = required ~status code value in
  let* device_code = required (string "device_code" json) in
  let* user_code = required (string "user_code" json) in
  let* verification_uri =
    required (Option.bind (string "verification_uri" json) endpoint)
  in
  let* expires_in = required (seconds "expires_in" json) in
  Ok
    {
      code =
        {
          user_code;
          verification_uri;
          verification_uri_complete =
            Option.bind (string "verification_uri_complete" json) endpoint;
          expires_in;
        };
      device_code;
      interval =
        (match member "interval" json with
        | Some (`Int seconds) when seconds >= 0 -> seconds
        | _ -> Client_timing.device_poll_ms / 1000);
    }

let poll_device http (issuer : Records.Pending_authorization_issuer.t) device =
  let* url = required Error_codes.Sign_in.Exchange (endpoint issuer.token) in
  let form =
    [
      ("grant_type", "urn:ietf:params:oauth:grant-type:device_code");
      ("client_id", Oauth_facts.script);
      ("device_code", device.device_code);
    ]
  in
  match answer http { meth = "POST"; url; form } with
  | status, Some json when status >= 200 && status < 300 ->
      Result.map (fun tokens -> Issued tokens) (issued ~status json)
  | status, json -> (
      match Option.bind json (string "error") with
      | Some "authorization_pending" -> Ok Pending
      | Some "slow_down" -> Ok Slow_down
      | Some "access_denied" -> failed ~status Error_codes.Sign_in.Denied
      | Some "expired_token" -> failed ~status Error_codes.Sign_in.Expired
      | _ -> failed ~status Error_codes.Sign_in.Exchange)

let await_device ~clock http issuer device =
  let stamp () = Clock.monotonic_now clock in
  let after time milliseconds =
    Mtime.add_span time Mtime.Span.(milliseconds * ms)
    |> Option.value ~default:Mtime.max_stamp
  in
  let milliseconds seconds = min (max_int / 1000) seconds * 1000 in
  let expires = after (stamp ()) (milliseconds device.code.expires_in) in
  let rec wait interval =
    let due = after (stamp ()) interval in
    Clock.sleep_until clock
      (if Mtime.compare due expires < 0 then due else expires);
    if Mtime.compare (stamp ()) expires >= 0 then
      failed Error_codes.Sign_in.Expired
    else
      match poll_device http issuer device with
      | Ok Pending -> wait interval
      | Ok Slow_down ->
          let step = Client_timing.device_slow_down_ms in
          wait (min (max_int - step) interval + step)
      | Ok (Issued tokens) -> Ok tokens
      | Error error -> Error error
  in
  wait (max Client_timing.device_poll_floor_ms (milliseconds device.interval))

let refresh_refused { code; status } =
  code = Error_codes.Sign_in.Exchange
  && Option.fold ~none:false
       ~some:(fun status -> not (Retry.retryable Retry.Refresh ~status ()))
       status

let refresh_kept http ~token_endpoint ~client_id ~refresh_token =
  grant http ~token_endpoint
    [
      ("grant_type", "refresh_token");
      ("client_id", client_id);
      ("refresh_token", refresh_token);
    ]

let refresh_script http ~token_endpoint ~refresh_token =
  refresh_kept http ~token_endpoint ~client_id:Oauth_facts.script ~refresh_token

let service_secret http (issuer : Records.Pending_authorization_issuer.t)
    ~client_id ~client_secret =
  grant http ~token_endpoint:issuer.token
    (Gateway_http.client_secret_form ~client_id ~client_secret)

type rsa_key = X509.Private_key.t

let rsa_key_of_pem pem =
  let trimmed = String.trim pem in
  if
    not
      (String.starts_with ~prefix:"-----BEGIN PRIVATE KEY-----" trimmed
      && String.ends_with ~suffix:"-----END PRIVATE KEY-----" trimmed)
  then None
  else
    match X509.Private_key.decode_pem trimmed with
    | Ok (`RSA _ as key) -> Some key
    | _ -> None

let unsigned z =
  let little = Z.to_bits z in
  let length = ref (String.length little) in
  while !length > 0 && little.[!length - 1] = '\000' do
    decr length
  done;
  String.init !length (fun index -> little.[!length - index - 1]) |> encoded

let rsa_thumbprint ~e ~n =
  Yojson.Safe.to_string
    (`Assoc [ ("e", `String e); ("kty", `String "RSA"); ("n", `String n) ])
  |> Digestif.SHA256.digest_string |> Digestif.SHA256.to_raw_string |> encoded

let assertion_claims ~client_id ~token_endpoint ~issued_at ~jti =
  `Assoc
    [
      ("iss", `String client_id);
      ("sub", `String client_id);
      ("aud", `String token_endpoint);
      ("jti", `String jti);
      ("iat", `Int issued_at);
      ("exp", `Int (issued_at + Assertion_facts.lifetime_seconds));
    ]

let service_key http (issuer : Records.Pending_authorization_issuer.t) ~clock
    ~jti ~client_id ~key =
  match X509.Private_key.public key with
  | `RSA public -> (
      let kid = rsa_thumbprint ~e:(unsigned public.e) ~n:(unsigned public.n) in
      let header = `Assoc [ ("alg", `String "RS256"); ("kid", `String kid) ] in
      let issued_at = int_of_float (floor (Clock.wall_now clock)) in
      let claims =
        assertion_claims ~client_id ~token_endpoint:issuer.token ~issued_at
          ~jti:(jti ())
      in
      let jwt_segment json = encoded (Yojson.Safe.to_string json) in
      let message = jwt_segment header ^ "." ^ jwt_segment claims in
      match
        X509.Private_key.sign `SHA256 ~scheme:`RSA_PKCS1 key (`Message message)
      with
      | Error (`Msg why) -> invalid_arg ("The RSA key cannot sign: " ^ why)
      | Ok signature ->
          grant http ~token_endpoint:issuer.token
            [
              ("grant_type", Assertion_facts.grant_type);
              ("client_assertion_type", Assertion_facts.assertion_type);
              ("client_assertion", message ^ "." ^ encoded signature);
            ])
  | _ -> invalid_arg "A key rsa_key_of_pem read is not an RSA key"

let revoke_script http ~revocation_endpoint ~refresh_token =
  let* url =
    required Error_codes.Sign_in.Exchange (endpoint revocation_endpoint)
  in
  let status, _ =
    http
      {
        meth = "POST";
        url;
        form =
          [
            ("client_id", Oauth_facts.script);
            ("token_type_hint", "refresh_token");
            ("token", refresh_token);
          ];
      }
  in
  if status = 200 then Ok () else failed ~status Error_codes.Sign_in.Exchange
