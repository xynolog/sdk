type identity_unverifiable_error = string

let code_challenge = Oauth.code_challenge
let pending_authorization_key = Registry.pending_authorization_key

let begin_authorization ~issuer ~random options =
  Oauth.begin_redirect issuer ~random options

let complete_authorization = Oauth.finish_redirect
let describe_connection = Registry.describe_connection
let url = Oauth.url

let keep storage pending =
  Storage.set storage pending_authorization_key
    (Yojson.Safe.to_string (Records.Pending_authorization.to_json pending))

let take storage =
  let held = ref None in
  Storage.update storage pending_authorization_key (fun stored ->
      held := stored;
      None);
  Option.bind !held (fun source ->
      let open Option.Syntax in
      let* _ = Strict_json.parse source |> Result.to_option in
      Records.Pending_authorization.of_json (Yojson.Safe.from_string source)
      |> Result.to_option)
