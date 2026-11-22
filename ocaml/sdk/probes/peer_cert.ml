(* peer_cert.exe: a self-signed certificate for localhost and its RSA key, as
   peer-cert.pem and peer-key.pem, valid for two days: the peer the TLS probes
   and the sign-in test trust. It is its own authority (CA), so a probe trusts
   it as an anchor. *)

let get = function Ok v -> v | Error (`Msg m) -> failwith m

let () =
  Mirage_crypto_rng_unix.use_default ();
  let key = X509.Private_key.generate ~bits:2048 `RSA in
  let localhost =
    X509.Distinguished_name.
      [ Relative_distinguished_name.singleton (CN (Common_name.v "localhost")) ]
  in
  let extensions =
    X509.Extension.(
      singleton Subject_alt_name
        (false, X509.General_name.(singleton DNS [ "localhost" ]))
      |> add Basic_constraints (true, (true, None)))
  in
  let valid_from = Ptime_clock.now () in
  let valid_until =
    Option.get (Ptime.add_span valid_from (Ptime.Span.of_int_s (2 * 86_400)))
  in
  let request = get (X509.Signing_request.create localhost key) in
  let certificate =
    match
      X509.Signing_request.sign request ~valid_from ~valid_until ~extensions key
        localhost
    with
    | Ok c -> c
    | Error e ->
        failwith (Format.asprintf "%a" X509.Validation.pp_signature_error e)
  in
  Out_channel.with_open_bin "peer-cert.pem" (fun out ->
      Out_channel.output_string out (X509.Certificate.encode_pem certificate));
  Out_channel.with_open_bin "peer-key.pem" (fun out ->
      Out_channel.output_string out (X509.Private_key.encode_pem key))
