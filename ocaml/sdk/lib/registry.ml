module J = Yojson.Safe.Util

type endpoint = [ `KbEndpoint ] Models.t
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
  (State_units.Session.t * Records.Connection_identity.t, string) result

type xynolog_browser_config = {
  storage : storage;
  clock : Clock.t;
  fresh_id : unit -> string;
  factory : session_factory;
}

type connection = {
  session : State_units.Session.t;
  signals : State_units.Session_signals.t;
}

type xynolog_browser = {
  config : xynolog_browser_config;
  lock : Eio.Mutex.t;
  atomic_storage : Storage.t option;
  said : Client.session_error Kept_for_first_reader.t;
  mutable connected : connection option;
  mutable generation : unit ref;
  mutable closed : bool;
}

type activation_error =
  | Unavailable of string
  | Identity_conflict of string
  | Superseded

let knowledge_bases_key = Registry_facts.knowledge_bases_key
let active_key = Registry_facts.active_key
let open_resources_by_kb_key = Registry_facts.open_resources_by_kb_key

let last_viewed_resource_by_kb_key =
  Registry_facts.last_viewed_resource_by_kb_key

let session_key id = Registry_facts.session_prefix ^ id

let kb_of_session_key key =
  let n = String.length Registry_facts.session_prefix in
  if
    String.starts_with ~prefix:Registry_facts.session_prefix key
    && String.length key > n
  then Some (String.sub key n (String.length key - n))
  else None

let text value = `String value
let json = Yojson.Safe.to_string
let object_ = function `Assoc fields -> fields | _ -> []

let optional name fields =
  match List.assoc_opt name fields with
  | Some (`String value) -> Some value
  | _ -> None

let member name value =
  List.assoc_opt name (object_ value) |> Option.value ~default:`Null

let parse text =
  match Strict_json.parse text with
  | Ok _ -> Some (Yojson.Safe.from_string text)
  | Error _ -> None

let decode_session source =
  Option.bind (parse source) (fun body ->
      Result.to_option (Records.Stored_session.of_json body))

let encode_session session = json (Records.Stored_session.to_json session)

let stored_session (storage : storage) id =
  Option.bind (storage.read (session_key id)) decode_session

let store_session (storage : storage) id session =
  storage.write (session_key id) (encode_session session)

let clear_stored_session (storage : storage) id =
  storage.remove (session_key id)

let load_knowledge_bases (storage : storage) =
  match Option.bind (storage.read knowledge_bases_key) parse with
  | Some (`List values) ->
      List.filter_map
        (fun value ->
          Result.to_option (Models.decode Models.knowledge_base (json value)))
        values
  | _ -> []

let save_knowledge_bases (storage : storage) values =
  storage.write knowledge_bases_key
    ("[" ^ String.concat "," (List.map Models.encode values) ^ "]")

let same_place a b =
  match (Records.Kb_endpoint.of_model a, Records.Kb_endpoint.of_model b) with
  | HttpEndpoint a, HttpEndpoint b ->
      a.protocol = b.protocol
      && String.lowercase_ascii a.host = String.lowercase_ascii b.host
      && a.port = b.port
  | LocalEndpoint a, LocalEndpoint b -> a.kb_id = b.kb_id
  | _ -> false

let sort_open_resources tabs =
  List.stable_sort
    (fun (a : Records.Open_resource.t) (b : Records.Open_resource.t) ->
      compare (a.order, a.opened_at) (b.order, b.opened_at))
    tabs

let apply_tab_checks tabs checks =
  List.filter_map
    (fun (tab : Records.Open_resource.t) ->
      match List.assoc_opt tab.id checks with
      | Some Records.Tab_check.Gone -> None
      | Some (Ready { name; media_type }) -> Some { tab with name; media_type }
      | _ -> Some tab)
    tabs

let new_xynolog_browser ?storage config =
  let config =
    match storage with
    | None -> config
    | Some store ->
        {
          config with
          storage =
            {
              read = Storage.get store;
              write = Storage.set store;
              remove = Storage.delete store;
            };
        }
  in
  {
    config;
    atomic_storage = storage;
    lock = Eio.Mutex.create ();
    said = Kept_for_first_reader.make ();
    connected = None;
    generation = ref ();
    closed = false;
  }

let knowledge_bases browser = load_knowledge_bases browser.config.storage
let active_id browser = browser.config.storage.read active_key
let locked browser f = Eio.Mutex.use_rw ~protect:false browser.lock f
let errors browser = Kept_for_first_reader.read browser.said

let active_client browser =
  Option.map
    (fun { session; _ } -> State_units.Session.client session)
    browser.connected

(* The registry is the one reader of a session's errors, from the first thing
   it said, until it ends. *)
let read browser { session; signals } =
  let _release =
    State_units.Session.errors session
      ~on_value:(function
        | Client.Own error -> Kept_for_first_reader.say browser.said error
        | Client.Transport_failure { code; message; _ }
          when code = Error_codes.Transport.forbidden ->
            State_units.Session_signals.notify_permission_denied signals
              ~detail:(Some message)
        | Client.Transport_failure _ -> ())
      ~on_close:ignore
  in
  ()

(* The client closes first, so what its closing flush meets is said before the
   session's errors end. *)
let finish { session; signals } =
  Fun.protect
    ~finally:(fun () ->
      State_units.Session.dispose session;
      State_units.Session_signals.dispose signals)
    (fun () -> Client.close (State_units.Session.client session))

let disconnect browser =
  let connected = browser.connected in
  browser.connected <- None;
  Option.iter finish connected

let close browser =
  locked browser (fun () ->
      browser.closed <- true;
      browser.generation <- ref ();
      disconnect browser);
  Kept_for_first_reader.close browser.said

let id kb = (Records.Knowledge_base.of_model kb).id
let did kb = (Records.Knowledge_base.of_model kb).did

let endpoint kb =
  Result.get_ok
    (Records.Kb_endpoint.to_model (Records.Knowledge_base.of_model kb).endpoint)

let describe_connection client =
  match Bus_registry.decode Bus_registry.Channels.browse_kb_requested "{}" with
  | Error _ -> Error Error_codes.Transport.bad_request
  | Ok payload -> (
      match Client.Browse.kb client payload with
      | Error _ -> Error Error_codes.Kb_identity.unreachable
      | Ok reply -> (
          let response =
            Bus_registry.encode reply |> Yojson.Safe.from_string
            |> member "response"
          in
          match Models.decode Models.kb_description (json response) with
          | Error _ -> Error Error_codes.Kb_identity.not_reported
          | Ok description -> (
              let domain =
                (Records.Kb_description.of_model description).domain
              in
              match
                Identifiers.User_id.of_string
                  (Identity.knowledge_base_did domain)
              with
              | Ok did when domain <> "" ->
                  Ok { Records.Connection_identity.did; description }
              | Ok _ | Error _ -> Error Error_codes.Kb_identity.not_reported)))

let with_identity ~id ~endpoint (identity : Records.Connection_identity.t) =
  let info = Records.Kb_description.of_model identity.description in
  let source =
    `Assoc
      [
        ("id", text id);
        ("label", text info.name);
        ("did", text (Identifiers.User_id.to_string identity.did));
        ("endpoint", Yojson.Safe.from_string (Models.encode endpoint));
      ]
  in
  Result.get_ok (Models.decode Models.knowledge_base (json source))

let record_sign_in browser (signed : Records.Signed_in.t) =
  let info = Records.Kb_description.of_model signed.description in
  match
    Identifiers.User_id.of_string (Identity.knowledge_base_did info.domain)
  with
  | Ok _ when info.domain = "" -> Error Error_codes.Kb_identity.not_reported
  | Error _ -> Error Error_codes.Kb_identity.not_reported
  | Ok reported ->
      let identity =
        {
          Records.Connection_identity.did = reported;
          description = signed.description;
        }
      in
      locked browser (fun () ->
          let values = knowledge_bases browser in
          let verified =
            List.filter
              (fun kb ->
                same_place (endpoint kb) signed.endpoint
                && did kb = Identifiers.User_id.to_string identity.did)
              values
          in
          let prior =
            match
              List.find_opt (fun kb -> Some (id kb) = signed.kb_id) verified
            with
            | Some _ as match_ -> match_
            | None -> List.nth_opt verified 0
          in
          let key =
            match prior with
            | Some kb -> id kb
            | None -> browser.config.fresh_id ()
          in
          if prior = None && List.exists (fun kb -> id kb = key) values then
            Error "kb.id-conflict"
          else
            let kb = with_identity ~id:key ~endpoint:signed.endpoint identity in
            let values =
              match prior with
              | None -> values @ [ kb ]
              | Some _ ->
                  List.map
                    (fun prior -> if id prior = key then kb else prior)
                    values
            in
            let storage = browser.config.storage in
            store_session storage key signed.session;
            save_knowledge_bases storage values;
            storage.write active_key key;
            browser.generation <- ref ();
            disconnect browser;
            let expected =
              Option.map
                (fun did ->
                  { Records.Expected.did; name = signed.expected_name })
                signed.expected_did
            in
            Ok { Records.Sign_in_outcome.kb; expected })

let activate browser key =
  let begun =
    locked browser (fun () ->
        if browser.closed then None
        else
          let generation = ref () in
          browser.generation <- generation;
          Some (generation, active_id browser))
  in
  match begun with
  | None -> Error Superseded
  | Some (generation, before) -> (
      match List.find_opt (fun kb -> id kb = key) (knowledge_bases browser) with
      | None -> Error (Unavailable "kb.not-found")
      | Some kb -> (
          let storage = browser.config.storage in
          let signals = State_units.Session_signals.make () in
          match browser.config.factory { kb; storage; signals } with
          | Error code ->
              State_units.Session_signals.dispose signals;
              if not (locked browser (fun () -> browser.closed)) then
                Kept_for_first_reader.say browser.said
                  {
                    Client.code = Error_codes.Session.construct_failed;
                    message =
                      "Could not construct the knowledge base's session: "
                      ^ code;
                  };
              Error (Unavailable code)
          | Ok (session, identity) ->
              let connection = { session; signals } in
              read browser connection;
              locked browser (fun () ->
                  let reported = Identifiers.User_id.to_string identity.did in
                  if reported <> did kb then (
                    finish connection;
                    Error (Identity_conflict reported))
                  else if
                    browser.generation != generation
                    || active_id browser <> before
                    || not
                         (List.exists
                            (fun current ->
                              id current = key
                              && did current = did kb
                              && same_place (endpoint current) (endpoint kb))
                            (knowledge_bases browser))
                  then (
                    finish connection;
                    Error Superseded)
                  else (
                    disconnect browser;
                    browser.connected <- Some connection;
                    storage.write active_key key;
                    Ok session))))

let session_status browser key =
  match stored_session browser.config.storage key with
  | None -> Enums.Kb_session_status.Signed_out
  | Some session -> (
      match Session.token_expiry session.access with
      | Some expiry when expiry <= Clock.wall_now browser.config.clock ->
          Expired
      | _ -> Authenticated)

let sign_out browser key =
  locked browser (fun () ->
      let storage = browser.config.storage in
      browser.generation <- ref ();
      clear_stored_session storage key;
      if active_id browser = Some key then (
        storage.remove active_key;
        disconnect browser))

let http_session_factory connect options =
  match connect options with
  | Error _ as failure -> failure
  | Ok session -> (
      let client = State_units.Session.client session in
      match describe_connection client with
      | Ok identity -> Ok (session, identity)
      | Error code ->
          Fun.protect
            ~finally:(fun () -> State_units.Session.dispose session)
            (fun () -> Client.close client);
          Error code)

let by_kb browser key =
  let storage = browser.config.storage in
  match storage.read key with
  | None -> []
  | Some value -> (
      match parse value with
      | Some (`Assoc fields) -> fields
      | _ -> invalid_arg "invalid registry state document")

let open_resources browser ~kb_id =
  match List.assoc_opt kb_id (by_kb browser open_resources_by_kb_key) with
  | Some (`List tabs) ->
      List.filter_map
        (fun tab ->
          Result.to_option
            (Models.decode Models.open_resource (Yojson.Safe.to_string tab))
          |> Option.map Records.Open_resource.of_model)
        tabs
      |> sort_open_resources
  | _ -> []

let set_by_kb browser key kb_id value =
  let prior = List.remove_assoc kb_id (by_kb browser key) in
  let fields =
    Option.fold ~none:prior ~some:(fun value -> (kb_id, value) :: prior) value
  in
  browser.config.storage.write key (json (`Assoc fields))

let set_open_resources browser ~kb_id tabs =
  let encode tab =
    Yojson.Safe.from_string
      (Yojson.Raw.to_string (Records.Open_resource.to_json tab))
  in
  locked browser (fun () ->
      set_by_kb browser open_resources_by_kb_key kb_id
        (Some (`List (List.map encode tabs))))

let last_viewed browser ~kb_id =
  optional kb_id (by_kb browser last_viewed_resource_by_kb_key)

let set_last_viewed browser ~kb_id resource =
  locked browser (fun () ->
      set_by_kb browser last_viewed_resource_by_kb_key kb_id
        (Option.map text resource))

let pending_authorization_key = Registry_facts.pending_authorization_key

type kept_sign_in = {
  held : unit -> Records.Stored_session.t option;
  keep : Records.Stored_session.t -> unit;
  forget : unit -> unit;
}

let kept_in storage id =
  {
    held = (fun () -> stored_session storage id);
    keep = store_session storage id;
    forget = (fun () -> clear_stored_session storage id);
  }

let change_kept browser id change =
  locked browser (fun () ->
      let key = session_key id in
      match browser.atomic_storage with
      | Some store ->
          let result = ref None in
          Storage.update store key (fun raw ->
              let current = Option.bind raw decode_session in
              let next, value = change current in
              result := Some value;
              if next = current then raw else Option.map encode_session next);
          Option.get !result
      | None ->
          let storage = browser.config.storage in
          let current = stored_session storage id in
          let next, value = change current in
          (if next <> current then
             match next with
             | None -> clear_stored_session storage id
             | Some next -> store_session storage id next);
          value)

let renew_kept browser ~http id ~holding =
  match stored_session browser.config.storage id with
  | None -> Session.Refused
  | Some before
    when Kept_renewal.renewed_elsewhere
           ~now:(Clock.wall_now browser.config.clock)
           ~holding
           ~expiry:(Tokens.token_expiry before.access)
           before.access ->
      Session.Renewed before.access
  | Some before ->
      (* An issuer that rotates refresh tokens spends the old one when it
         answers: the exchange and the write of what it brought run to their
         end, whoever stops waiting. *)
      Eio.Cancel.protect (fun () ->
          let issued =
            Oauth.refresh_kept http ~token_endpoint:before.token_endpoint
              ~client_id:before.client_id ~refresh_token:before.refresh
          in
          change_kept browser id (function
            | None -> (None, Session.Refused)
            | Some current when current <> before ->
                (Some current, Session.Renewed current.access)
            | Some current -> (
                match issued with
                | Ok tokens ->
                    let next =
                      {
                        before with
                        access = tokens.access_token;
                        refresh =
                          Option.value tokens.refresh_token
                            ~default:before.refresh;
                      }
                    in
                    (Some next, Session.Renewed next.access)
                | Error failure when Oauth.refresh_refused failure ->
                    (None, Session.Refused)
                | Error _ -> (Some current, Session.Unavailable))))

let forget_rejected browser id token =
  change_kept browser id (function
    | Some current when current.access = token -> (None, ())
    | current -> (current, ()))

let start_kept_session browser ~sw ~http id =
  Session.start ~keep_on_unavailable:true
    ~on_rejected:(forget_rejected browser id)
    ~sw ~clock:browser.config.clock
    ~initial_token:
      (Option.map
         (fun (session : Records.Stored_session.t) -> session.access)
         (stored_session browser.config.storage id))
    ~renew:(renew_kept browser ~http id)
    ()

let begin_sign_in browser ~http ~issuer ~random ~redirect_uri ~target ?kb_id
    ?expected_did ?expected_name () =
  Result.map
    (fun issuer ->
      let pending =
        Oauth.begin_redirect issuer ~random
          {
            Records.Begin_authorization_options.target;
            redirect_uri;
            kb_id;
            expected_did;
            expected_name;
          }
      in
      locked browser (fun () ->
          browser.config.storage.write pending_authorization_key
            (json (Records.Pending_authorization.to_json pending)));
      Oauth.url pending)
    (Oauth.discover http ~issuer)

let complete_sign_in browser ~http ~callback ~describe =
  let pending =
    locked browser (fun () ->
        let storage = browser.config.storage in
        let value =
          match browser.atomic_storage with
          | Some store ->
              let taken = ref None in
              Storage.update store pending_authorization_key (fun value ->
                  taken := value;
                  None);
              !taken
          | None ->
              let value = storage.read pending_authorization_key in
              storage.remove pending_authorization_key;
              value
        in
        Option.bind value (fun source ->
            Option.bind (parse source) (fun body ->
                Result.to_option (Records.Pending_authorization.of_json body))))
  in
  let ( let* ) = Result.bind in
  let* pending =
    match pending with
    | Some pending -> Ok pending
    | None -> Error Error_codes.Sign_in.no_pending
  in
  let* endpoint =
    Models.decode Models.kb_endpoint (Models.encode pending.target)
    |> Result.map_error (fun _ -> Error_codes.Sign_in.no_pending)
  in
  let* tokens =
    Oauth.finish_redirect http pending ~callback
    |> Result.map_error (fun (error : Oauth.error) -> error.code)
  in
  let* refresh =
    match tokens.refresh_token with
    | Some value -> Ok value
    | None -> Error Error_codes.Sign_in.exchange
  in
  let* description = describe endpoint ~access:tokens.access_token in
  record_sign_in browser
    {
      Records.Signed_in.endpoint;
      description;
      session =
        {
          Records.Stored_session.access = tokens.access_token;
          refresh;
          client_id = Oauth_facts.browser;
          token_endpoint = pending.issuer.token;
          revocation_endpoint = pending.issuer.revocation;
          person_key = None;
        };
      kb_id = pending.kb_id;
      expected_did = pending.expected_did;
      expected_name = pending.expected_name;
    }
