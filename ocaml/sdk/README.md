# Xynolog OCaml SDK

[![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=ocaml-sdk)](https://app.codecov.io/gh/xynolog/sdk/components)

Build an Eio application, script, or worker that talks to a Xynolog knowledge base. The SDK includes typed bus operations, sign-in, delegation, and live queries.

## Install

```sh
opam install xynolog
```

Add `xynolog` to your application's Dune `libraries` stanza. Below 1.0 the minor is the break, so take releases up to the next minor in your opam file's `depends`:

```opam
"xynolog" {>= "<version>" & < "<next minor>"}
```

Here `<version>` is a release's, and `<next minor>` is the first release of the minor after it. The [builder guide](https://github.com/xynolog/docs/blob/main/builder/OCAML.md) shows how the client fits into an application.

## A first program

This connects to a knowledge base with an access token you already hold and prints the knowledge base's description of itself. Give it the gateway's URL and the token as its two arguments. [Sign in and connect](#sign-in-and-connect) is how a program comes to hold a token, and what `Client.connect` is handed.

```ocaml
open Xynolog

let () =
  let gateway = Uri.of_string Sys.argv.(1) and token = Sys.argv.(2) in
  Eio_main.run @@ fun env ->
  Eio.Switch.run @@ fun sw ->
  let http = Cohttp_eio.Client.make ~https:None (Eio.Stdenv.net env) in
  let call ~sw ~meth ~path ~headers ~body ~progress:_ =
    let response, body =
      Cohttp_eio.Client.call http ~sw
        ~headers:(Cohttp.Header.of_list headers)
        ~body:(Cohttp_eio.Body.of_string body)
        (Cohttp.Code.method_of_string meth)
        (Uri.with_path gateway path)
    in
    ( Cohttp.Code.code_of_status (Cohttp.Response.status response),
      Cohttp.Header.to_list (Cohttp.Response.headers response),
      (body :> Eio.Flow.source_ty Eio.Resource.t) )
  in
  let key () =
    let bytes = Cstruct.create 16 in
    Eio.Flow.read_exact (Eio.Stdenv.secure_random env) bytes;
    Cstruct.to_hex_string bytes
  in
  let clock =
    Clock.make
      ~monotonic:(Eio.Stdenv.mono_clock env)
      ~wall:(Eio.Stdenv.clock env)
      ~jitter:(Random.State.make_self_init ())
  in
  let session =
    Session.start ~sw ~clock ~initial_token:(Some token)
      ~renew:(fun ~holding:_ -> Session.Refused)
      ()
  in
  let client =
    Client.connect ~sw ~clock ~session ~client_id:(key ()) ~key ~call
      ~global:Bus_registry.bridged_channels ~on_event:ignore ()
  in
  let request =
    Result.get_ok
      (Bus_registry.decode Bus_registry.Channels.browse_kb_requested "{}")
  in
  (match Client.Browse.kb client request with
  | Ok description -> print_endline (Bus_registry.encode description)
  | Error (Client.Http { message; _ } | Client.Refused message) ->
      prerr_endline message
  | Error (Client.Transport _) -> prerr_endline "The bus gave no reply");
  Client.close client;
  Session.close session
```

Its Dune `libraries` are `xynolog eio_main cohttp-eio uri cstruct`. The session renews nothing, so the client holds the token until the gateway refuses it. The adapter speaks plain HTTP: TLS is the adapter's, and for an `https` gateway the application gives `Cohttp_eio.Client.make` its `~https`.

## Sign in and connect

- **Script.** Discover the issuer with `OAuth.discover`, obtain the user code with `OAuth.begin_device`, then call `OAuth.await_device` with the application's clock. To reuse the launcher's sign-in on Linux or macOS, open the launcher directory with `Sign_in_store.make` and select the stack with `Sign_in_store.session`.
- **Interactive application.** Use `Registry.begin_sign_in` to store the pending PKCE exchange and get the authorization URL. After the redirect, use `Registry.complete_sign_in` to consume the callback and verify the knowledge base. Supply a `Storage.t` with an atomic update when multiple application contexts share the store.
- **Agent.** Use `Agent.sign_in` with a client secret or RSA key. For RSA assertions, initialize Mirage's secure random generator and supply a fresh assertion ID. Use `Service_token` when you need the issuer bearer or authorization header independently of a client.

Pass the credential session, Eio switch, clock, and gateway HTTP adapter to `Client.connect`, with the channels its bus subscribes to as `~global`: `Bus_registry.bridged_channels` for a full client. The application owns the HTTP adapter, the client, and the lifetime of its Eio switch. The [sign-in guide](https://github.com/xynolog/docs/blob/main/builder/SIGN-IN.md) describes the grants.

`Client.errors` says each failure of the client's transport, from its first request on. `State_units.Session.errors` says the session's own errors and what its client says, in the order met. The first reader of each is first given the latest said before it came. A registry's factory builds each knowledge base's session and reads none of its errors. `Registry.activate` reads them from the first thing the session said: `Registry.errors` says the session's own errors, and a refusal for lack of permission goes to the signals the factory was handed. A session the factory cannot build is said on `Registry.errors` as `session.construct-failed`. `Registry.close` closes the active session's client and then ends the session and `Registry.errors`, so what the client's closing flush meets is said first; an activation after it builds nothing. `Error_codes` names each code of the bus request, transport, job and session vocabularies of `protocol/specs/src/errors/codes.json`, from which it is generated.

## Eight verbs

The client's eight verb namespaces are `Client.Yield`, `Client.Mark`, `Client.Bind` and `Client.Frame` for writes, `Client.Browse`, `Client.Match` and `Client.Gather` for reads, and `Client.Beckon` for attention. `Client.Job`, `Client.Auth` and `Client.System` hold the rest of the [client surface](https://github.com/xynolog/protocol/blob/main/specs/src/client/surface.json). A request's payload is decoded against its channel with `Bus_registry.decode`, as the first program's is.

## Live queries

Get a query from `Client.Browse`, `Client.Match`, or `Client.Gather`. Use `Client.fresh` for a fresh answer, or `Client.observe` for state updates until you release the observation. The [checked example](examples/builder.ml) reads and watches a resource.

For a durable cache, pass a `Storage_persister` to `Client.connect`. Give it a key scoped to the knowledge base and signed-in principal. The client debounces cache writes and advances a stored replay cursor only when the matching scoped cache values can be saved with it. A write the storage refuses stays owed, and the client says it on `Client.errors` as `session.save-refused`.

## Delegate work

Use `Client.Mark.delegate` or `Client.Yield.delegate` with `Client.delegation client`. The client already connects the follower to its subscription. Supply validated parameters and callbacks for reports, terminal failures, and closure. The returned function releases the follower.

## Run a worker

Use `Client.Job.claim` and `Claims.next` to take a job, then use `Worker` to start it, report progress, checkpoint, and settle it. Include `Worker.channels` in the client's subscription and add `Worker.commit_channels` for annotation commits. `Claims.refused` and `Claims.stalled` say each claim refused and each held job that stalls: the first reader of each is first given the latest said before it came, in order, and a reader who comes after `Claims.stop` hears only the end.

Working on the SDK itself? See [CONTRIBUTING.md](https://github.com/xynolog/sdk/blob/main/CONTRIBUTING.md).
