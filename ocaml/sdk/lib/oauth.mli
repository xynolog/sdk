(** OAuth exchanges over a caller-owned HTTPS adapter. The adapter encodes
    [form] as application/x-www-form-urlencoded and refuses redirects. *)

type request = { meth : string; url : string; form : (string * string) list }
type http = request -> int * string

type error = { code : string; status : int option }
(** Why an exchange gave nothing: [code] is a member of {!Error_codes.Sign_in},
    and [status] the HTTP status the issuer answered with, [None] when there was
    no answer to read. *)

type script
type browser
type service

type 'grant tokens = private {
  access_token : string;
  refresh_token : string option;
  expires_in : int option;
}

type poll =
  | Issued of script tokens
  | Pending
  | Slow_down
      (** What one poll of a device grant brought: its tokens, or the issuer's
          word to ask again, after a longer wait for [Slow_down]. *)

type device = {
  code : Records.Device_code.t;
  device_code : string;
  interval : int;
}
(** A device grant under way: what the person is shown, and what the polls send
    and wait by. *)

val discover :
  http ->
  issuer:string ->
  (Records.Pending_authorization_issuer.t, error) result

val code_challenge : string -> string

val begin_redirect :
  Records.Pending_authorization_issuer.t ->
  random:(int -> string) ->
  Records.Begin_authorization_options.t ->
  Records.Pending_authorization.t
(** [random] must return cryptographically secure bytes. *)

val url : Records.Pending_authorization.t -> string

val finish_redirect :
  http ->
  Records.Pending_authorization.t ->
  callback:string ->
  (browser tokens, error) result

val begin_device :
  http -> Records.Pending_authorization_issuer.t -> (device, error) result

val poll_device :
  http ->
  Records.Pending_authorization_issuer.t ->
  device ->
  (poll, error) result
(** One poll. Wait at least [device.interval] seconds between polls and back off
    on [Slow_down]. *)

val await_device :
  clock:Clock.t ->
  http ->
  Records.Pending_authorization_issuer.t ->
  device ->
  (script tokens, error) result
(** Poll using the caller's clock, starting the expiry window when called. *)

val refresh_refused : error -> bool
(** Whether a renewal failed because the issuer refused it: an answer the
    refresh retry rule does not try again. No answer, and one the rule tries
    again, is no refusal. *)

val refresh_kept :
  http ->
  token_endpoint:string ->
  client_id:string ->
  refresh_token:string ->
  (browser tokens, error) result

val refresh_script :
  http ->
  token_endpoint:string ->
  refresh_token:string ->
  (script tokens, error) result

val service_secret :
  http ->
  Records.Pending_authorization_issuer.t ->
  client_id:string ->
  client_secret:string ->
  (service tokens, error) result

type rsa_key

val rsa_key_of_pem : string -> rsa_key option
(** Reads an unencrypted RSA PKCS#8 PEM key. *)

val rsa_thumbprint : e:string -> n:string -> string

val service_key :
  http ->
  Records.Pending_authorization_issuer.t ->
  clock:Clock.t ->
  jti:(unit -> string) ->
  client_id:string ->
  key:rsa_key ->
  (service tokens, error) result
(** [jti] must supply a fresh unique identifier on every invocation. The host
    initializes Mirage's secure random generator for RSA blinding. Raises
    [Invalid_argument] when [key] cannot sign an RS256 assertion, which is no
    failure of the issuer's. *)

val revoke_script :
  http ->
  revocation_endpoint:string ->
  refresh_token:string ->
  (unit, error) result
