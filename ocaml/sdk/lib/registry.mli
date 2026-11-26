type endpoint = [ `KbEndpoint ] Models.t
(** A registry of endpoints and verified identities over caller-owned storage.
*)

type knowledge_base = [ `KnowledgeBase ] Models.t

type storage = {
  read : string -> string option;
  write : string -> string -> unit;
  remove : string -> unit;
}

type session_factory_options = {
  kb : knowledge_base;
  storage : storage;
  signals : State_units.Session_signals.t;
}

type session_factory =
  session_factory_options ->
  ( State_units.Session.t * Records.Connection_identity.t,
    Client.session_error )
  result
(** Builds the knowledge base's session, and reads none of its errors: the
    registry reads them from the first thing the session said. The registry
    makes the [signals] it is handed for the session. *)

type xynolog_browser_config = {
  storage : storage;
  clock : Clock.t;
  fresh_id : unit -> string;
  factory : session_factory;
}

type xynolog_browser

type activation_error =
  | Unknown_kb  (** The registry holds no knowledge base of the id. *)
  | Unavailable of Client.session_error
      (** The factory could not build the session, for its reason. *)
  | Identity_conflict of string
  | Superseded

(** Why a connection's identity could not be verified: the knowledge base gave
    none, or its request could not be made. *)
type identity_unverifiable_error =
  | Kb_identity of Error_codes.Kb_identity.t
  | Transport of Error_codes.Transport.t

(** Why a sign-in was not recorded: the exchange's own code, the identity the
    knowledge base gave none of, or an id another knowledge base holds. *)
type sign_in_error =
  | Sign_in of Error_codes.Sign_in.t
  | Identity of Error_codes.Kb_identity.t
  | Id_conflict

val new_xynolog_browser :
  ?storage:Storage.t -> xynolog_browser_config -> xynolog_browser

val same_place : endpoint -> endpoint -> bool
val knowledge_bases : xynolog_browser -> knowledge_base list
val active_id : xynolog_browser -> string option
val active_client : xynolog_browser -> Client.t option

val record_sign_in :
  xynolog_browser ->
  Records.Signed_in.t ->
  (Records.Sign_in_outcome.t, sign_in_error) result

val describe_connection :
  Client.t ->
  (Records.Connection_identity.t, identity_unverifiable_error) result

val activate :
  xynolog_browser -> string -> (State_units.Session.t, activation_error) result
(** Builds the knowledge base's session and reads its errors until it ends: each
    of the session's own errors is said on [errors]; a refusal for lack of
    permission is said through its signals, with the failure's message as the
    detail; any other failure of its transport is said nowhere, and the registry
    renews no session. The session it ends closes its client first. A session
    the factory cannot build is said on [errors] as session.construct-failed,
    and the activation is [Unavailable] for the factory's reason. An activation
    that a later one, a sign-in, a sign-out or [close] overtakes is
    [Superseded], its session ended at once, and so is one begun after [close],
    which builds nothing. *)

val errors :
  xynolog_browser ->
  on_value:(Client.session_error -> unit) ->
  on_close:(unit -> unit) ->
  unit ->
  unit
(** Hear each own error of the sessions the registry activates, and each session
    its factory could not build. The first reader is first given the latest
    errorsKeptForFirstReaderCount (protocol/specs/src/client/timing.json) said
    before it came, in order; a later reader hears what is said from when it
    reads. [close] ends it. The returned function stops hearing. *)

val close : xynolog_browser -> unit
(** Ends the active session, its client first, so what the client's closing
    flush meets is said on [errors], and then ends [errors]. *)

val sign_out : xynolog_browser -> string -> unit
val session_status : xynolog_browser -> string -> Enums.Kb_session_status.t

val http_session_factory :
  (session_factory_options ->
  (State_units.Session.t, Client.session_error) result) ->
  session_factory

val sort_open_resources :
  Records.Open_resource.t list -> Records.Open_resource.t list

val apply_tab_checks :
  Records.Open_resource.t list ->
  (string * Records.Tab_check.t) list ->
  Records.Open_resource.t list

val knowledge_bases_key : string
val active_key : string
val open_resources_by_kb_key : string
val last_viewed_resource_by_kb_key : string
val session_key : string -> string
val kb_of_session_key : string -> string option
val stored_session : storage -> string -> Records.Stored_session.t option
val store_session : storage -> string -> Records.Stored_session.t -> unit
val clear_stored_session : storage -> string -> unit
val load_knowledge_bases : storage -> knowledge_base list
val save_knowledge_bases : storage -> knowledge_base list -> unit

val open_resources :
  xynolog_browser -> kb_id:string -> Records.Open_resource.t list

val set_open_resources :
  xynolog_browser -> kb_id:string -> Records.Open_resource.t list -> unit

val last_viewed : xynolog_browser -> kb_id:string -> string option
val set_last_viewed : xynolog_browser -> kb_id:string -> string option -> unit
val pending_authorization_key : string

type kept_sign_in = {
  held : unit -> Records.Stored_session.t option;
  keep : Records.Stored_session.t -> unit;
  forget : unit -> unit;
}

val kept_in : storage -> string -> kept_sign_in

val renew_kept :
  xynolog_browser ->
  http:Oauth.http ->
  string ->
  holding:string option ->
  Session.renewal
(** Renew the sign-in kept for a knowledge base, handed the token the renewal
    renews (protocol/specs/src/sign-in-store/README.md, Renewing it). *)

val forget_rejected : xynolog_browser -> string -> string -> unit
(** Forget the sign-in kept for a knowledge base while its access token is the
    one the gateway rejected. *)

val start_kept_session :
  xynolog_browser -> sw:Eio.Switch.t -> http:Oauth.http -> string -> Session.t
(** A session over the sign-in kept for a knowledge base: [renew_kept] renews it
    and [forget_rejected] is told each token the gateway rejects. *)

val begin_sign_in :
  xynolog_browser ->
  http:Oauth.http ->
  issuer:string ->
  random:(int -> string) ->
  redirect_uri:string ->
  target:[ `HttpEndpoint ] Models.t ->
  ?kb_id:string ->
  ?expected_did:string ->
  ?expected_name:string ->
  unit ->
  (string, Oauth.error) result

val complete_sign_in :
  xynolog_browser ->
  http:Oauth.http ->
  callback:string ->
  describe:
    (endpoint ->
    access:string ->
    ([ `KbDescription ] Models.t, Error_codes.Kb_identity.t) result) ->
  (Records.Sign_in_outcome.t, sign_in_error) result
(** Consumes the pending sign-in before exchanging the code. [describe] reads
    the verified knowledge-base description using the new credentials. *)
