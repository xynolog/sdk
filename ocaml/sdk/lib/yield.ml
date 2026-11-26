include Namespace_methods.Yield

let delegate follower ?stall_ms ~params ~on_report ~on_failure ~on_close () =
  Delegation.start follower ~verb:Enums.Job_type.Yield ?stall_ms
    ~params:(Yojson.Safe.from_string (Models.encode params))
    ~on_report ~on_failure ~on_close ()

let resource client request ~on_progress =
  Upload.make (fun () ->
      Client_core.content (fun () ->
          Http_wire.put (Client_core.http client) request ~on_progress))

let create_from_token client ~token ~name ~content ?archive_original () =
  let module B = Bus_registry in
  let request = Yojson.Safe.to_string (`Assoc [ ("token", `String token) ]) in
  match B.decode B.Channels.yield_clone_resource_requested request with
  | Error _ ->
      Error
        (Client_core.Refused
           (Http_wire.Transport Error_codes.Transport.Bad_request))
  | Ok payload ->
      Result.bind (from_token client payload) (fun reply ->
          let open Yojson.Safe.Util in
          let descriptor =
            Yojson.Safe.from_string (B.encode reply)
            |> member "response" |> member "sourceResource"
          in
          let media =
            let representation =
              match member "representations" descriptor with
              | `List (first :: _) -> first
              | `Assoc _ as first -> first
              | _ -> `Null
            in
            match representation with
            | `Assoc _ -> (
                match member "mediaType" representation with
                | `String value ->
                    String.split_on_char ';' value
                    |> List.hd |> String.trim |> String.lowercase_ascii
                | _ -> "")
            | _ -> ""
          in
          let format = Media_types.clone_format media in
          let request : Records.Put_binary_request.t =
            {
              name;
              file = content;
              format;
              storage_uri =
                "file://" ^ Media_types.storage_file_name ~name ~format;
              language = None;
              entity_types = None;
              source_annotation_id = None;
              source_resource_id = None;
              generation_prompt = None;
              generator = None;
              job_id = None;
              is_draft = None;
              clone_token = Some token;
              archive_original;
            }
          in
          Upload.await (resource client request ~on_progress:ignore))
