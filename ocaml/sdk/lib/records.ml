(* Generated from OpenAPI object components and discriminator mappings, and the records of Protocol's tables. Do not edit.
   Regenerate: make generate (codegen/lib/ocaml_sdk/records.ml) *)

open Record_reader

module Pending_authorization_issuer = struct
  type t = {
    issuer : string;
    authorization : string;
    token : string;
    device : string option;
    revocation : string option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* issuer = required string "issuer" members in
        let* authorization = required string "authorization" members in
        let* token = required string "token" members in
        let* device = optional string "device" members in
        let* revocation = optional string "revocation" members in
        Ok { issuer; authorization; token; device; revocation }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("issuer", Some (json_string value.issuer));
          ("authorization", Some (json_string value.authorization));
          ("token", Some (json_string value.token));
          ("device", Option.map json_string value.device);
          ("revocation", Option.map json_string value.revocation);
        ]
end

module Connection_identity = struct
  type t = {
    did : Identifiers.User_id.t;
    description : [ `KbDescription ] Models.t;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* did =
          required (identifier Identifiers.User_id.of_string) "did" members
        in
        let* description =
          required (model Models.kb_description) "description" members
        in
        Ok { did; description }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("did", Some ((json_id Identifiers.User_id.to_string) value.did));
          ("description", Some (json_model value.description));
        ]
end

module Expected = struct
  type t = { did : string; name : string option }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* did = required string "did" members in
        let* name = optional string "name" members in
        Ok { did; name }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("did", Some (json_string value.did));
          ("name", Option.map json_string value.name);
        ]
end

module Kb_read_verdict = struct
  type t =
    | Recorded
    | Conflict of { observed_did : string; observed_name : string }
    | NoVerdict

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members -> (
        let* tag = required string "kind" members in
        match tag with
        | "recorded" -> Ok Recorded
        | "conflict" ->
            let* observed_did = required string "observedDid" members in
            let* observed_name = required string "observedName" members in
            Ok (Conflict { observed_did; observed_name })
        | "no-verdict" -> Ok NoVerdict
        | _ -> malformed "kind")
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    function
    | Recorded -> write [ ("kind", Some (json_string "recorded")) ]
    | Conflict value ->
        write
          [
            ("kind", Some (json_string "conflict"));
            ("observedDid", Some (json_string value.observed_did));
            ("observedName", Some (json_string value.observed_name));
          ]
    | NoVerdict -> write [ ("kind", Some (json_string "no-verdict")) ]
end

module Tab_check = struct
  type t =
    | Gone
    | Ready of { name : string; media_type : string option }
    | Unknown

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members -> (
        let* tag = required string "verdict" members in
        match tag with
        | "gone" -> Ok Gone
        | "ready" ->
            let* name = required string "name" members in
            let* media_type = optional string "mediaType" members in
            Ok (Ready { name; media_type })
        | "unknown" -> Ok Unknown
        | _ -> malformed "verdict")
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    function
    | Gone -> write [ ("verdict", Some (json_string "gone")) ]
    | Ready value ->
        write
          [
            ("verdict", Some (json_string "ready"));
            ("name", Some (json_string value.name));
            ("mediaType", Option.map json_string value.media_type);
          ]
    | Unknown -> write [ ("verdict", Some (json_string "unknown")) ]
end

module Stored_session = struct
  type t = {
    access : string;
    refresh : string;
    client_id : string;
    token_endpoint : string;
    revocation_endpoint : string option;
    person_key : string option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* access = required string "access" members in
        let* refresh = required string "refresh" members in
        let* client_id = required string "clientId" members in
        let* token_endpoint = required string "tokenEndpoint" members in
        let* revocation_endpoint =
          optional string "revocationEndpoint" members
        in
        let* person_key = optional string "personKey" members in
        Ok
          {
            access;
            refresh;
            client_id;
            token_endpoint;
            revocation_endpoint;
            person_key;
          }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("access", Some (json_string value.access));
          ("refresh", Some (json_string value.refresh));
          ("clientId", Some (json_string value.client_id));
          ("tokenEndpoint", Some (json_string value.token_endpoint));
          ( "revocationEndpoint",
            Option.map json_string value.revocation_endpoint );
          ("personKey", Option.map json_string value.person_key);
        ]
end

module Last_event_ids = struct
  type t = (string * string) list

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function `Assoc members -> map string members | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    json_map json_string
end

module Begin_authorization_options = struct
  type t = {
    target : [ `HttpEndpoint ] Models.t;
    redirect_uri : string;
    kb_id : string option;
    expected_did : string option;
    expected_name : string option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* target = required (model Models.http_endpoint) "target" members in
        let* redirect_uri = required string "redirectUri" members in
        let* kb_id = optional string "kbId" members in
        let* expected_did = optional string "expectedDid" members in
        let* expected_name = optional string "expectedName" members in
        Ok { target; redirect_uri; kb_id; expected_did; expected_name }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("target", Some (json_model value.target));
          ("redirectUri", Some (json_string value.redirect_uri));
          ("kbId", Option.map json_string value.kb_id);
          ("expectedDid", Option.map json_string value.expected_did);
          ("expectedName", Option.map json_string value.expected_name);
        ]
end

module Claim_options = struct
  type t = {
    accepts : [ `JobFilter ] Models.t list;
    job_claim_timeout_ms : int option;
    held_job_stall_ms : int option;
    held_job_stall_check_ms : int option;
    mark_commit_timeout_ms : int option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* accepts =
          required (list (model Models.job_filter)) "accepts" members
        in
        let* job_claim_timeout_ms = optional int "jobClaimTimeoutMs" members in
        let* held_job_stall_ms = optional int "heldJobStallMs" members in
        let* held_job_stall_check_ms =
          optional int "heldJobStallCheckMs" members
        in
        let* mark_commit_timeout_ms =
          optional int "markCommitTimeoutMs" members
        in
        Ok
          {
            accepts;
            job_claim_timeout_ms;
            held_job_stall_ms;
            held_job_stall_check_ms;
            mark_commit_timeout_ms;
          }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("accepts", Some ((json_list json_model) value.accepts));
          ("jobClaimTimeoutMs", Option.map json_int value.job_claim_timeout_ms);
          ("heldJobStallMs", Option.map json_int value.held_job_stall_ms);
          ( "heldJobStallCheckMs",
            Option.map json_int value.held_job_stall_check_ms );
          ( "markCommitTimeoutMs",
            Option.map json_int value.mark_commit_timeout_ms );
        ]
end

module Claim_refusal = struct
  type t = { code : Error_codes.Bus_request.t option; message : string }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* code =
          required
            (nullable (enum Error_codes.Bus_request.of_code))
            "code" members
        in
        let* message = required string "message" members in
        Ok { code; message }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ( "code",
            Some
              (json_nullable
                 (json_enum Error_codes.Bus_request.code)
                 value.code) );
          ("message", Some (json_string value.message));
        ]
end

module Create_from_token_options = struct
  type t = {
    token : string;
    name : string;
    content : string;
    archive_original : bool option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* token = required string "token" members in
        let* name = required string "name" members in
        let* content = required string "content" members in
        let* archive_original = optional bool "archiveOriginal" members in
        Ok { token; name; content; archive_original }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("token", Some (json_string value.token));
          ("name", Some (json_string value.name));
          ("content", Some (json_string value.content));
          ("archiveOriginal", Option.map json_bool value.archive_original);
        ]
end

module Device_code = struct
  type t = {
    user_code : string;
    verification_uri : string;
    verification_uri_complete : string option;
    expires_in : int;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* user_code = required string "userCode" members in
        let* verification_uri = required string "verificationUri" members in
        let* verification_uri_complete =
          optional string "verificationUriComplete" members
        in
        let* expires_in = required int "expiresIn" members in
        Ok
          { user_code; verification_uri; verification_uri_complete; expires_in }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("userCode", Some (json_string value.user_code));
          ("verificationUri", Some (json_string value.verification_uri));
          ( "verificationUriComplete",
            Option.map json_string value.verification_uri_complete );
          ("expiresIn", Some (json_int value.expires_in));
        ]
end

module Discovery_absent = struct
  type t = {
    reason : Enums.Discovery_absent_reason.t;
    diagnostic : string option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* () = required (fixed "absent") "kind" members in
        let* reason =
          required
            (enum Enums.Discovery_absent_reason.of_string)
            "reason" members
        in
        let* diagnostic = optional string "diagnostic" members in
        Ok { reason; diagnostic }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("kind", Some (json_string "absent"));
          ( "reason",
            Some
              ((json_enum Enums.Discovery_absent_reason.to_string) value.reason)
          );
          ("diagnostic", Option.map json_string value.diagnostic);
        ]
end

module Discovery_managed = struct
  type t = { kbs : [ `DiscoveredKB ] Models.t list }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* () = required (fixed "managed") "kind" members in
        let* kbs = required (list (model Models.discovered_kb)) "kbs" members in
        Ok { kbs }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("kind", Some (json_string "managed"));
          ("kbs", Some ((json_list json_model) value.kbs));
        ]
end

module Discovery_unchanged = struct
  type t = unit

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* () = required (fixed "unchanged") "kind" members in
        Ok ()
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun () -> write [ ("kind", Some (json_string "unchanged")) ]
end

module Fault = struct
  type t = { member : string; reason : Enums.Frame_refusal_reason.t }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* member = required string "member" members in
        let* reason =
          required (enum Enums.Frame_refusal_reason.of_string) "reason" members
        in
        Ok { member; reason }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("member", Some (json_string value.member));
          ( "reason",
            Some ((json_enum Enums.Frame_refusal_reason.to_string) value.reason)
          );
        ]
end

module Frame_refusal = struct
  type t = {
    channel : string;
    member : string;
    reason : Enums.Frame_refusal_reason.t;
    payload : Yojson.Safe.t option;
    scope : Identifiers.Resource_id.t option;
    correlation_id : string option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* channel = required string "channel" members in
        let* member = required string "member" members in
        let* reason =
          required (enum Enums.Frame_refusal_reason.of_string) "reason" members
        in
        let* payload = optional any "payload" members in
        let* scope =
          optional
            (identifier Identifiers.Resource_id.of_string)
            "scope" members
        in
        let* correlation_id = optional string "correlationId" members in
        Ok { channel; member; reason; payload; scope; correlation_id }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("channel", Some (json_string value.channel));
          ("member", Some (json_string value.member));
          ( "reason",
            Some ((json_enum Enums.Frame_refusal_reason.to_string) value.reason)
          );
          ("payload", Option.map json_any value.payload);
          ( "scope",
            Option.map (json_id Identifiers.Resource_id.to_string) value.scope
          );
          ("correlationId", Option.map json_string value.correlation_id);
        ]
end

module Gather_resource_options = struct
  type t = {
    depth : int option;
    max_resources : int option;
    include_content : bool option;
    include_summary : bool option;
    exclude_entity_types : string list option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* depth = optional int "depth" members in
        let* max_resources = optional int "maxResources" members in
        let* include_content = optional bool "includeContent" members in
        let* include_summary = optional bool "includeSummary" members in
        let* exclude_entity_types =
          optional (list string) "excludeEntityTypes" members
        in
        Ok
          {
            depth;
            max_resources;
            include_content;
            include_summary;
            exclude_entity_types;
          }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("depth", Option.map json_int value.depth);
          ("maxResources", Option.map json_int value.max_resources);
          ("includeContent", Option.map json_bool value.include_content);
          ("includeSummary", Option.map json_bool value.include_summary);
          ( "excludeEntityTypes",
            Option.map (json_list json_string) value.exclude_entity_types );
        ]
end

module Held_job_record = struct
  type t = {
    job_id : Identifiers.Job_id.t;
    job_type : Enums.Job_type.t;
    resource_id : Identifiers.Resource_id.t;
    params : [ `JobParams ] Models.t;
    completed_units : string list;
    unit_cursors : (string * [ `UnitCursor ] Models.t) list;
    retry_count : int;
    max_retries : int;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* job_id =
          required (identifier Identifiers.Job_id.of_string) "jobId" members
        in
        let* job_type =
          required (enum Enums.Job_type.of_string) "jobType" members
        in
        let* resource_id =
          required
            (identifier Identifiers.Resource_id.of_string)
            "resourceId" members
        in
        let* params = required (model Models.job_params) "params" members in
        let* completed_units =
          required (list string) "completedUnits" members
        in
        let* unit_cursors =
          required (assoc (model Models.unit_cursor)) "unitCursors" members
        in
        let* retry_count = required int "retryCount" members in
        let* max_retries = required int "maxRetries" members in
        Ok
          {
            job_id;
            job_type;
            resource_id;
            params;
            completed_units;
            unit_cursors;
            retry_count;
            max_retries;
          }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("jobId", Some ((json_id Identifiers.Job_id.to_string) value.job_id));
          ("jobType", Some ((json_enum Enums.Job_type.to_string) value.job_type));
          ( "resourceId",
            Some ((json_id Identifiers.Resource_id.to_string) value.resource_id)
          );
          ("params", Some (json_model value.params));
          ( "completedUnits",
            Some ((json_list json_string) value.completed_units) );
          ("unitCursors", Some ((json_map json_model) value.unit_cursors));
          ("retryCount", Some (json_int value.retry_count));
          ("maxRetries", Some (json_int value.max_retries));
        ]
end

module Held_job_stall = struct
  type t = {
    job_id : Identifiers.Job_id.t;
    job_type : Enums.Job_type.t;
    held_since : string;
    last_activity_at : string;
    silent_for_ms : int;
    threshold_ms : int;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* job_id =
          required (identifier Identifiers.Job_id.of_string) "jobId" members
        in
        let* job_type =
          required (enum Enums.Job_type.of_string) "jobType" members
        in
        let* held_since = required string "heldSince" members in
        let* last_activity_at = required string "lastActivityAt" members in
        let* silent_for_ms = required int "silentForMs" members in
        let* threshold_ms = required int "thresholdMs" members in
        Ok
          {
            job_id;
            job_type;
            held_since;
            last_activity_at;
            silent_for_ms;
            threshold_ms;
          }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("jobId", Some ((json_id Identifiers.Job_id.to_string) value.job_id));
          ("jobType", Some ((json_enum Enums.Job_type.to_string) value.job_type));
          ("heldSince", Some (json_string value.held_since));
          ("lastActivityAt", Some (json_string value.last_activity_at));
          ("silentForMs", Some (json_int value.silent_for_ms));
          ("thresholdMs", Some (json_int value.threshold_ms));
        ]
end

module Issued_tokens = struct
  type t = { access : string; refresh : string }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* access = required string "access" members in
        let* refresh = required string "refresh" members in
        Ok { access; refresh }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("access", Some (json_string value.access));
          ("refresh", Some (json_string value.refresh));
        ]
end

module Job_checkpoint = struct
  type t = {
    completed_units : string list;
    unit_cursors : (string * [ `UnitCursor ] Models.t) list option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* completed_units =
          required (list string) "completedUnits" members
        in
        let* unit_cursors =
          optional (assoc (model Models.unit_cursor)) "unitCursors" members
        in
        Ok { completed_units; unit_cursors }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ( "completedUnits",
            Some ((json_list json_string) value.completed_units) );
          ("unitCursors", Option.map (json_map json_model) value.unit_cursors);
        ]
end

module Job_failure = struct
  type t = {
    completed_units : string list option;
    unit_cursors : (string * [ `UnitCursor ] Models.t) list option;
    failure_class : Enums.Failure_class.t option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* completed_units =
          optional (list string) "completedUnits" members
        in
        let* unit_cursors =
          optional (assoc (model Models.unit_cursor)) "unitCursors" members
        in
        let* failure_class =
          optional (enum Enums.Failure_class.of_string) "failureClass" members
        in
        Ok { completed_units; unit_cursors; failure_class }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ( "completedUnits",
            Option.map (json_list json_string) value.completed_units );
          ("unitCursors", Option.map (json_map json_model) value.unit_cursors);
          ( "failureClass",
            Option.map
              (json_enum Enums.Failure_class.to_string)
              value.failure_class );
        ]
end

module Job_poll_options = struct
  type t = { every_ms : int option; within_ms : int option }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* every_ms = optional int "everyMs" members in
        let* within_ms = optional int "withinMs" members in
        Ok { every_ms; within_ms }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("everyMs", Option.map json_int value.every_ms);
          ("withinMs", Option.map json_int value.within_ms);
        ]
end

module Job_reached = struct
  type t = {
    completed_units : string list option;
    unit_cursors : (string * [ `UnitCursor ] Models.t) list option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* completed_units =
          optional (list string) "completedUnits" members
        in
        let* unit_cursors =
          optional (assoc (model Models.unit_cursor)) "unitCursors" members
        in
        Ok { completed_units; unit_cursors }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ( "completedUnits",
            Option.map (json_list json_string) value.completed_units );
          ("unitCursors", Option.map (json_map json_model) value.unit_cursors);
        ]
end

module Kb_identity_conflict = struct
  type t = { expected_did : string; observed_did : string }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* expected_did = required string "expectedDid" members in
        let* observed_did = required string "observedDid" members in
        Ok { expected_did; observed_did }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("expectedDid", Some (json_string value.expected_did));
          ("observedDid", Some (json_string value.observed_did));
        ]
end

module Match_search_options = struct
  type t = { limit : int option; use_semantic_scoring : bool option }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* limit = optional int "limit" members in
        let* use_semantic_scoring =
          optional bool "useSemanticScoring" members
        in
        Ok { limit; use_semantic_scoring }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("limit", Option.map json_int value.limit);
          ("useSemanticScoring", Option.map json_bool value.use_semantic_scoring);
        ]
end

module Pdf_coordinate = struct
  type t = { page : int; x : float; y : float; width : float; height : float }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* page = required int "page" members in
        let* x = required float "x" members in
        let* y = required float "y" members in
        let* width = required float "width" members in
        let* height = required float "height" members in
        Ok { page; x; y; width; height }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("page", Some (json_int value.page));
          ("x", Some (json_float value.x));
          ("y", Some (json_float value.y));
          ("width", Some (json_float value.width));
          ("height", Some (json_float value.height));
        ]
end

module Pending_annotation = struct
  type t = {
    selector : [ `AnnotationSelector ] Models.t;
    motivation : Enums.Motivation.t;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* selector =
          required (model Models.annotation_selector) "selector" members
        in
        let* motivation =
          required (enum Enums.Motivation.of_string) "motivation" members
        in
        Ok { selector; motivation }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("selector", Some (json_model value.selector));
          ( "motivation",
            Some ((json_enum Enums.Motivation.to_string) value.motivation) );
        ]
end

module Permission_denied = struct
  type t = { detail : string option }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* detail = required (nullable string) "detail" members in
        Ok { detail }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write [ ("detail", Some (json_nullable json_string value.detail)) ]
end

module Quoted_text = struct
  type t = { exact : string; prefix : string option; suffix : string option }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* exact = required string "exact" members in
        let* prefix = optional string "prefix" members in
        let* suffix = optional string "suffix" members in
        Ok { exact; prefix; suffix }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("exact", Some (json_string value.exact));
          ("prefix", Option.map json_string value.prefix);
          ("suffix", Option.map json_string value.suffix);
        ]
end

module Reconciled_span = struct
  type t =
    | UniqueMatch of {
        start : int;
        end_ : int;
        exact : string;
        prefix : string option;
        suffix : string option;
      }
    | ContextRecovered of {
        start : int;
        end_ : int;
        exact : string;
        prefix : string option;
        suffix : string option;
      }
    | FirstOfMany of {
        start : int;
        end_ : int;
        exact : string;
        prefix : string option;
        suffix : string option;
      }
    | FuzzyMatch of {
        start : int;
        end_ : int;
        exact : string;
        prefix : string option;
        suffix : string option;
        match_quality : Enums.Match_quality.t;
      }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members -> (
        let* tag = required string "anchorMethod" members in
        match tag with
        | "unique-match" ->
            let* start = required int "start" members in
            let* end_ = required int "end" members in
            let* exact = required string "exact" members in
            let* prefix = optional string "prefix" members in
            let* suffix = optional string "suffix" members in
            Ok (UniqueMatch { start; end_; exact; prefix; suffix })
        | "context-recovered" ->
            let* start = required int "start" members in
            let* end_ = required int "end" members in
            let* exact = required string "exact" members in
            let* prefix = optional string "prefix" members in
            let* suffix = optional string "suffix" members in
            Ok (ContextRecovered { start; end_; exact; prefix; suffix })
        | "first-of-many" ->
            let* start = required int "start" members in
            let* end_ = required int "end" members in
            let* exact = required string "exact" members in
            let* prefix = optional string "prefix" members in
            let* suffix = optional string "suffix" members in
            Ok (FirstOfMany { start; end_; exact; prefix; suffix })
        | "fuzzy-match" ->
            let* start = required int "start" members in
            let* end_ = required int "end" members in
            let* exact = required string "exact" members in
            let* prefix = optional string "prefix" members in
            let* suffix = optional string "suffix" members in
            let* match_quality =
              required
                (enum Enums.Match_quality.of_string)
                "matchQuality" members
            in
            Ok
              (FuzzyMatch { start; end_; exact; prefix; suffix; match_quality })
        | _ -> malformed "anchorMethod")
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    function
    | UniqueMatch value ->
        write
          [
            ("anchorMethod", Some (json_string "unique-match"));
            ("start", Some (json_int value.start));
            ("end", Some (json_int value.end_));
            ("exact", Some (json_string value.exact));
            ("prefix", Option.map json_string value.prefix);
            ("suffix", Option.map json_string value.suffix);
          ]
    | ContextRecovered value ->
        write
          [
            ("anchorMethod", Some (json_string "context-recovered"));
            ("start", Some (json_int value.start));
            ("end", Some (json_int value.end_));
            ("exact", Some (json_string value.exact));
            ("prefix", Option.map json_string value.prefix);
            ("suffix", Option.map json_string value.suffix);
          ]
    | FirstOfMany value ->
        write
          [
            ("anchorMethod", Some (json_string "first-of-many"));
            ("start", Some (json_int value.start));
            ("end", Some (json_int value.end_));
            ("exact", Some (json_string value.exact));
            ("prefix", Option.map json_string value.prefix);
            ("suffix", Option.map json_string value.suffix);
          ]
    | FuzzyMatch value ->
        write
          [
            ("anchorMethod", Some (json_string "fuzzy-match"));
            ("start", Some (json_int value.start));
            ("end", Some (json_int value.end_));
            ("exact", Some (json_string value.exact));
            ("prefix", Option.map json_string value.prefix);
            ("suffix", Option.map json_string value.suffix);
            ( "matchQuality",
              Some
                ((json_enum Enums.Match_quality.to_string) value.match_quality)
            );
          ]
end

module Resource_search_filters = struct
  type t = {
    archived : bool option;
    entity_type : string option;
    offset : int option;
    limit : int option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* archived = optional bool "archived" members in
        let* entity_type = optional string "entityType" members in
        let* offset = optional int "offset" members in
        let* limit = optional int "limit" members in
        Ok { archived; entity_type; offset; limit }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("archived", Option.map json_bool value.archived);
          ("entityType", Option.map json_string value.entity_type);
          ("offset", Option.map json_int value.offset);
          ("limit", Option.map json_int value.limit);
        ]
end

module Session_ended = struct
  type t = { reason : Enums.Session_end_reason.t }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* reason =
          required (enum Enums.Session_end_reason.of_string) "reason" members
        in
        Ok { reason }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ( "reason",
            Some ((json_enum Enums.Session_end_reason.to_string) value.reason)
          );
        ]
end

module Text_span = struct
  type t = {
    start : int;
    end_ : int;
    exact : string;
    prefix : string option;
    suffix : string option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* start = required int "start" members in
        let* end_ = required int "end" members in
        let* exact = required string "exact" members in
        let* prefix = optional string "prefix" members in
        let* suffix = optional string "suffix" members in
        Ok { start; end_; exact; prefix; suffix }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("start", Some (json_int value.start));
          ("end", Some (json_int value.end_));
          ("exact", Some (json_string value.exact));
          ("prefix", Option.map json_string value.prefix);
          ("suffix", Option.map json_string value.suffix);
        ]
end

module Trace_carrier = struct
  type t = { traceparent : string; tracestate : string option }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* traceparent = required string "traceparent" members in
        let* tracestate = optional string "tracestate" members in
        Ok { traceparent; tracestate }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("traceparent", Some (json_string value.traceparent));
          ("tracestate", Option.map json_string value.tracestate);
        ]
end

module Upload_progress = struct
  type t =
    | Started of { total_bytes : int option }
    | Progress of { bytes_uploaded : int; total_bytes : int option }
    | Finished of { resource_id : Identifiers.Resource_id.t }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members -> (
        let* tag = required string "phase" members in
        match tag with
        | "started" ->
            let* total_bytes = optional int "totalBytes" members in
            Ok (Started { total_bytes })
        | "progress" ->
            let* bytes_uploaded = required int "bytesUploaded" members in
            let* total_bytes = optional int "totalBytes" members in
            Ok (Progress { bytes_uploaded; total_bytes })
        | "finished" ->
            let* resource_id =
              required
                (identifier Identifiers.Resource_id.of_string)
                "resourceId" members
            in
            Ok (Finished { resource_id })
        | _ -> malformed "phase")
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    function
    | Started value ->
        write
          [
            ("phase", Some (json_string "started"));
            ("totalBytes", Option.map json_int value.total_bytes);
          ]
    | Progress value ->
        write
          [
            ("phase", Some (json_string "progress"));
            ("bytesUploaded", Some (json_int value.bytes_uploaded));
            ("totalBytes", Option.map json_int value.total_bytes);
          ]
    | Finished value ->
        write
          [
            ("phase", Some (json_string "finished"));
            ( "resourceId",
              Some
                ((json_id Identifiers.Resource_id.to_string) value.resource_id)
            );
          ]
end

module Worker_vitals = struct
  type t = {
    last_queued_event_at : string option;
    last_claim_at : string option;
    last_finished_at : string option;
    last_activity_at : string option;
    active_job : [ `WorkerActiveJob ] Models.t option;
    jobs_completed : int;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* last_queued_event_at =
          required (nullable string) "lastQueuedEventAt" members
        in
        let* last_claim_at = required (nullable string) "lastClaimAt" members in
        let* last_finished_at =
          required (nullable string) "lastFinishedAt" members
        in
        let* last_activity_at =
          required (nullable string) "lastActivityAt" members
        in
        let* active_job =
          required
            (nullable (model Models.worker_active_job))
            "activeJob" members
        in
        let* jobs_completed = required int "jobsCompleted" members in
        Ok
          {
            last_queued_event_at;
            last_claim_at;
            last_finished_at;
            last_activity_at;
            active_job;
            jobs_completed;
          }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ( "lastQueuedEventAt",
            Some (json_nullable json_string value.last_queued_event_at) );
          ("lastClaimAt", Some (json_nullable json_string value.last_claim_at));
          ( "lastFinishedAt",
            Some (json_nullable json_string value.last_finished_at) );
          ( "lastActivityAt",
            Some (json_nullable json_string value.last_activity_at) );
          ("activeJob", Some (json_nullable json_model value.active_job));
          ("jobsCompleted", Some (json_int value.jobs_completed));
        ]
end

module Signed_in = struct
  type t = {
    endpoint : [ `KbEndpoint ] Models.t;
    description : [ `KbDescription ] Models.t;
    session : Stored_session.t;
    kb_id : string option;
    expected_did : string option;
    expected_name : string option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* endpoint =
          required (model Models.kb_endpoint) "endpoint" members
        in
        let* description =
          required (model Models.kb_description) "description" members
        in
        let* session =
          required (record Stored_session.of_json) "session" members
        in
        let* kb_id = optional string "kbId" members in
        let* expected_did = optional string "expectedDid" members in
        let* expected_name = optional string "expectedName" members in
        Ok
          { endpoint; description; session; kb_id; expected_did; expected_name }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("endpoint", Some (json_model value.endpoint));
          ("description", Some (json_model value.description));
          ("session", Some (Stored_session.to_json value.session));
          ("kbId", Option.map json_string value.kb_id);
          ("expectedDid", Option.map json_string value.expected_did);
          ("expectedName", Option.map json_string value.expected_name);
        ]
end

module Sign_in_outcome = struct
  type t = { kb : [ `KnowledgeBase ] Models.t; expected : Expected.t option }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* kb = required (model Models.knowledge_base) "kb" members in
        let* expected = optional (record Expected.of_json) "expected" members in
        Ok { kb; expected }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("kb", Some (json_model value.kb));
          ("expected", Option.map Expected.to_json value.expected);
        ]
end

module Pending_authorization = struct
  type t = {
    state : string;
    verifier : string;
    redirect_uri : string;
    target : [ `HttpEndpoint ] Models.t;
    issuer : Pending_authorization_issuer.t;
    kb_id : string option;
    expected_did : string option;
    expected_name : string option;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* state = required string "state" members in
        let* verifier = required string "verifier" members in
        let* redirect_uri = required string "redirectUri" members in
        let* target = required (model Models.http_endpoint) "target" members in
        let* issuer =
          required
            (record Pending_authorization_issuer.of_json)
            "issuer" members
        in
        let* kb_id = optional string "kbId" members in
        let* expected_did = optional string "expectedDid" members in
        let* expected_name = optional string "expectedName" members in
        Ok
          {
            state;
            verifier;
            redirect_uri;
            target;
            issuer;
            kb_id;
            expected_did;
            expected_name;
          }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("state", Some (json_string value.state));
          ("verifier", Some (json_string value.verifier));
          ("redirectUri", Some (json_string value.redirect_uri));
          ("target", Some (json_model value.target));
          ("issuer", Some (Pending_authorization_issuer.to_json value.issuer));
          ("kbId", Option.map json_string value.kb_id);
          ("expectedDid", Option.map json_string value.expected_did);
          ("expectedName", Option.map json_string value.expected_name);
        ]
end

module Discovery_read = struct
  type t =
    | Absent of Discovery_absent.t
    | Managed of Discovery_managed.t
    | Unchanged

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members -> (
        let* tag = required string "kind" members in
        match tag with
        | "absent" ->
            Result.map
              (fun value -> Absent value)
              (Discovery_absent.of_json (`Assoc members))
        | "managed" ->
            Result.map
              (fun value -> Managed value)
              (Discovery_managed.of_json (`Assoc members))
        | "unchanged" ->
            Result.map
              (fun () -> Unchanged)
              (Discovery_unchanged.of_json (`Assoc members))
        | _ -> malformed "kind")
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    function
    | Absent value -> Discovery_absent.to_json value
    | Managed value -> Discovery_managed.to_json value
    | Unchanged -> Discovery_unchanged.to_json ()
end

module Discovery_state = struct
  type t = Absent of Discovery_absent.t | Managed of Discovery_managed.t

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members -> (
        let* tag = required string "kind" members in
        match tag with
        | "absent" ->
            Result.map
              (fun value -> Absent value)
              (Discovery_absent.of_json (`Assoc members))
        | "managed" ->
            Result.map
              (fun value -> Managed value)
              (Discovery_managed.of_json (`Assoc members))
        | _ -> malformed "kind")
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    function
    | Absent value -> Discovery_absent.to_json value
    | Managed value -> Discovery_managed.to_json value
end

module Discovery_diff = struct
  type t = {
    state : Discovery_state.t;
    added : [ `DiscoveredKB ] Models.t list;
    updated : [ `DiscoveredKB ] Models.t list;
    removed : [ `DiscoveredKB ] Models.t list;
    duplicated : string list;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* state =
          required (record Discovery_state.of_json) "state" members
        in
        let* added =
          required (list (model Models.discovered_kb)) "added" members
        in
        let* updated =
          required (list (model Models.discovered_kb)) "updated" members
        in
        let* removed =
          required (list (model Models.discovered_kb)) "removed" members
        in
        let* duplicated = required (list string) "duplicated" members in
        Ok { state; added; updated; removed; duplicated }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("state", Some (Discovery_state.to_json value.state));
          ("added", Some ((json_list json_model) value.added));
          ("updated", Some ((json_list json_model) value.updated));
          ("removed", Some ((json_list json_model) value.removed));
          ("duplicated", Some ((json_list json_string) value.duplicated));
        ]
end

module Agent_organization = struct
  module Field_type = struct
    type t = Organization

    let to_string = function Organization -> "Organization"
    let of_string = function "Organization" -> Some Organization | _ -> None
  end

  type t = {
    field_type : Field_type.t;
    field_id : string option;
    name : string;
    homepage : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_type = required reader (enum Field_type.of_string) "@type";
        field_id = maybe reader string "@id";
        name = required reader string "name";
        homepage = maybe reader string "homepage";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AgentOrganization ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write_open
      [
        ("@type", Some ((json_enum Field_type.to_string) value.field_type));
        ("@id", Option.map json_string value.field_id);
        ("name", Some (json_string value.name));
        ("homepage", Option.map json_string value.homepage);
      ]
      value.extra

  let to_model value =
    Models.decode Models.agent_organization
      (Yojson.Raw.to_string (to_json value))
end

module Agent_person = struct
  module Field_type = struct
    type t = Person

    let to_string = function Person -> "Person"
    let of_string = function "Person" -> Some Person | _ -> None
  end

  type t = {
    field_type : Field_type.t;
    field_id : string option;
    name : string option;
    nickname : string option;
    email : string option;
    email_sha1 : string option;
    homepage : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_type = required reader (enum Field_type.of_string) "@type";
        field_id = maybe reader string "@id";
        name = maybe reader string "name";
        nickname = maybe reader string "nickname";
        email = maybe reader string "email";
        email_sha1 = maybe reader string "email_sha1";
        homepage = maybe reader string "homepage";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AgentPerson ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write_open
      [
        ("@type", Some ((json_enum Field_type.to_string) value.field_type));
        ("@id", Option.map json_string value.field_id);
        ("name", Option.map json_string value.name);
        ("nickname", Option.map json_string value.nickname);
        ("email", Option.map json_string value.email);
        ("email_sha1", Option.map json_string value.email_sha1);
        ("homepage", Option.map json_string value.homepage);
      ]
      value.extra

  let to_model value =
    Models.decode Models.agent_person (Yojson.Raw.to_string (to_json value))
end

module Agent_software = struct
  module Field_type = struct
    type t = Software

    let to_string = function Software -> "Software"
    let of_string = function "Software" -> Some Software | _ -> None
  end

  type t = {
    field_type : Field_type.t;
    field_id : string option;
    name : string option;
    provider : string option;
    model : string option;
    parameters : (string * Yojson.Raw.t) list option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_type = required reader (enum Field_type.of_string) "@type";
        field_id = maybe reader string "@id";
        name = maybe reader string "name";
        provider = maybe reader string "provider";
        model = maybe reader string "model";
        parameters = maybe reader (map raw) "parameters";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AgentSoftware ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write_open
      [
        ("@type", Some ((json_enum Field_type.to_string) value.field_type));
        ("@id", Option.map json_string value.field_id);
        ("name", Option.map json_string value.name);
        ("provider", Option.map json_string value.provider);
        ("model", Option.map json_string value.model);
        ("parameters", Option.map (json_map json_raw) value.parameters);
      ]
      value.extra

  let to_model value =
    Models.decode Models.agent_software (Yojson.Raw.to_string (to_json value))
end

module Annotation_removed_payload = struct
  type t = { annotation_id : string }

  let project fields =
    let reader = start fields in
    { annotation_id = required reader string "annotationId" }

  let of_model (model : [ `AnnotationRemovedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("annotationId", Some (json_string value.annotation_id)) ]

  let to_model value =
    Models.decode Models.annotation_removed_payload
      (Yojson.Raw.to_string (to_json value))
end

module Beckon_focus_event = struct
  type t = { annotation_id : string option; resource_id : string }

  let project fields =
    let reader = start fields in
    {
      annotation_id = maybe reader string "annotationId";
      resource_id = required reader string "resourceId";
    }

  let of_model (model : [ `BeckonFocusEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Option.map json_string value.annotation_id);
        ("resourceId", Some (json_string value.resource_id));
      ]

  let to_model value =
    Models.decode Models.beckon_focus_event
      (Yojson.Raw.to_string (to_json value))
end

module Beckon_hover_event = struct
  type t = { annotation_id : string option }

  let project fields =
    let reader = start fields in
    { annotation_id = required reader (nullable string) "annotationId" }

  let of_model (model : [ `BeckonHoverEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Some ((json_nullable json_string) value.annotation_id));
      ]

  let to_model value =
    Models.decode Models.beckon_hover_event
      (Yojson.Raw.to_string (to_json value))
end

module Beckon_sparkle_event = struct
  type t = { annotation_id : string }

  let project fields =
    let reader = start fields in
    { annotation_id = required reader string "annotationId" }

  let of_model (model : [ `BeckonSparkleEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("annotationId", Some (json_string value.annotation_id)) ]

  let to_model value =
    Models.decode Models.beckon_sparkle_event
      (Yojson.Raw.to_string (to_json value))
end

module Bind_initiate_command = struct
  type t = {
    annotation_id : string;
    resource_id : string;
    default_title : string;
    entity_types : string list;
  }

  let project fields =
    let reader = start fields in
    {
      annotation_id = required reader string "annotationId";
      resource_id = required reader string "resourceId";
      default_title = required reader string "defaultTitle";
      entity_types = required reader (list string) "entityTypes";
    }

  let of_model (model : [ `BindInitiateCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Some (json_string value.annotation_id));
        ("resourceId", Some (json_string value.resource_id));
        ("defaultTitle", Some (json_string value.default_title));
        ("entityTypes", Some ((json_list json_string) value.entity_types));
      ]

  let to_model value =
    Models.decode Models.bind_initiate_command
      (Yojson.Raw.to_string (to_json value))
end

module Browse_profiles_request = struct
  type t = { dids : string list }

  let project fields =
    let reader = start fields in
    { dids = required reader (list string) "dids" }

  let of_model (model : [ `BrowseProfilesRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("dids", Some ((json_list json_string) value.dids)) ]

  let to_model value =
    Models.decode Models.browse_profiles_request
      (Yojson.Raw.to_string (to_json value))
end

module Browse_annotation_history_request = struct
  type t = { resource_id : string; annotation_id : string }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      annotation_id = required reader string "annotationId";
    }

  let of_model (model : [ `BrowseAnnotationHistoryRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("annotationId", Some (json_string value.annotation_id));
      ]

  let to_model value =
    Models.decode Models.browse_annotation_history_request
      (Yojson.Raw.to_string (to_json value))
end

module Browse_annotation_request = struct
  type t = { resource_id : string; annotation_id : string }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      annotation_id = required reader string "annotationId";
    }

  let of_model (model : [ `BrowseAnnotationRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("annotationId", Some (json_string value.annotation_id));
      ]

  let to_model value =
    Models.decode Models.browse_annotation_request
      (Yojson.Raw.to_string (to_json value))
end

module Anchor_rect = struct
  type t = {
    x : float;
    y : float;
    width : float;
    height : float;
    top : float;
    right : float;
    bottom : float;
    left : float;
  }

  let project fields =
    let reader = start fields in
    {
      x = required reader float "x";
      y = required reader float "y";
      width = required reader float "width";
      height = required reader float "height";
      top = required reader float "top";
      right = required reader float "right";
      bottom = required reader float "bottom";
      left = required reader float "left";
    }

  let of_model (model : [ `AnchorRect ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("x", Some (json_float value.x));
        ("y", Some (json_float value.y));
        ("width", Some (json_float value.width));
        ("height", Some (json_float value.height));
        ("top", Some (json_float value.top));
        ("right", Some (json_float value.right));
        ("bottom", Some (json_float value.bottom));
        ("left", Some (json_float value.left));
      ]

  let to_model value =
    Models.decode Models.anchor_rect (Yojson.Raw.to_string (to_json value))
end

module Browse_directory_request = struct
  module Sort = struct
    type t = Name | Mtime | AnnotationCount

    let to_string = function
      | Name -> "name"
      | Mtime -> "mtime"
      | AnnotationCount -> "annotationCount"

    let of_string = function
      | "name" -> Some Name
      | "mtime" -> Some Mtime
      | "annotationCount" -> Some AnnotationCount
      | _ -> None
  end

  type t = { path : string; sort : Sort.t option }

  let project fields =
    let reader = start fields in
    {
      path = required reader string "path";
      sort = maybe reader (enum Sort.of_string) "sort";
    }

  let of_model (model : [ `BrowseDirectoryRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("path", Some (json_string value.path));
        ("sort", Option.map (json_enum Sort.to_string) value.sort);
      ]

  let to_model value =
    Models.decode Models.browse_directory_request
      (Yojson.Raw.to_string (to_json value))
end

module Browse_entity_type_clicked_event = struct
  type t = { entity_type : string }

  let project fields =
    let reader = start fields in
    { entity_type = required reader string "entityType" }

  let of_model (model : [ `BrowseEntityTypeClickedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("entityType", Some (json_string value.entity_type)) ]

  let to_model value =
    Models.decode Models.browse_entity_type_clicked_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_events_request = struct
  type t = {
    resource_id : string;
    type_ : string option;
    user_id : string option;
    limit : int option;
  }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      type_ = maybe reader string "type";
      user_id = maybe reader string "userId";
      limit = maybe reader int "limit";
    }

  let of_model (model : [ `BrowseEventsRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("type", Option.map json_string value.type_);
        ("userId", Option.map json_string value.user_id);
        ("limit", Option.map json_int value.limit);
      ]

  let to_model value =
    Models.decode Models.browse_events_request
      (Yojson.Raw.to_string (to_json value))
end

module Browse_external_navigate_event = struct
  type t = { url : string; resource_id : string option }

  let project fields =
    let reader = start fields in
    {
      url = required reader string "url";
      resource_id = maybe reader string "resourceId";
    }

  let of_model (model : [ `BrowseExternalNavigateEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("url", Some (json_string value.url));
        ("resourceId", Option.map json_string value.resource_id);
      ]

  let to_model value =
    Models.decode Models.browse_external_navigate_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_link_clicked_event = struct
  type t = { href : string; label : string option }

  let project fields =
    let reader = start fields in
    {
      href = required reader string "href";
      label = maybe reader string "label";
    }

  let of_model (model : [ `BrowseLinkClickedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("href", Some (json_string value.href));
        ("label", Option.map json_string value.label);
      ]

  let to_model value =
    Models.decode Models.browse_link_clicked_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_panel_open_event = struct
  type t = {
    panel : string;
    scroll_to_annotation_id : string option;
    motivation : Enums.Motivation.t option;
  }

  let project fields =
    let reader = start fields in
    {
      panel = required reader string "panel";
      scroll_to_annotation_id = maybe reader string "scrollToAnnotationId";
      motivation = maybe reader (enum Enums.Motivation.of_string) "motivation";
    }

  let of_model (model : [ `BrowsePanelOpenEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("panel", Some (json_string value.panel));
        ( "scrollToAnnotationId",
          Option.map json_string value.scroll_to_annotation_id );
        ( "motivation",
          Option.map (json_enum Enums.Motivation.to_string) value.motivation );
      ]

  let to_model value =
    Models.decode Models.browse_panel_open_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_panel_toggle_event = struct
  type t = { panel : string }

  let project fields =
    let reader = start fields in
    { panel = required reader string "panel" }

  let of_model (model : [ `BrowsePanelToggleEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) = write [ ("panel", Some (json_string value.panel)) ]

  let to_model value =
    Models.decode Models.browse_panel_toggle_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resource_open_event = struct
  type t = { resource_id : string }

  let project fields =
    let reader = start fields in
    { resource_id = required reader string "resourceId" }

  let of_model (model : [ `BrowseResourceOpenEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ]

  let to_model value =
    Models.decode Models.browse_resource_open_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resource_viewed_event = struct
  type t = { resource_id : string }

  let project fields =
    let reader = start fields in
    { resource_id = required reader string "resourceId" }

  let of_model (model : [ `BrowseResourceViewedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ]

  let to_model value =
    Models.decode Models.browse_resource_viewed_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resource_close_event = struct
  type t = { resource_id : string }

  let project fields =
    let reader = start fields in
    { resource_id = required reader string "resourceId" }

  let of_model (model : [ `BrowseResourceCloseEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ]

  let to_model value =
    Models.decode Models.browse_resource_close_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resource_reorder_event = struct
  type t = { old_index : int; new_index : int }

  let project fields =
    let reader = start fields in
    {
      old_index = required reader int "oldIndex";
      new_index = required reader int "newIndex";
    }

  let of_model (model : [ `BrowseResourceReorderEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("oldIndex", Some (json_int value.old_index));
        ("newIndex", Some (json_int value.new_index));
      ]

  let to_model value =
    Models.decode Models.browse_resource_reorder_event
      (Yojson.Raw.to_string (to_json value))
end

module Pdf_text_item = struct
  type t = {
    start : int;
    end_ : int;
    page : int;
    x : float;
    y : float;
    width : float;
    height : float;
  }

  let project fields =
    let reader = start fields in
    {
      start = required reader int "start";
      end_ = required reader int "end";
      page = required reader int "page";
      x = required reader float "x";
      y = required reader float "y";
      width = required reader float "width";
      height = required reader float "height";
    }

  let of_model (model : [ `PdfTextItem ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("start", Some (json_int value.start));
        ("end", Some (json_int value.end_));
        ("page", Some (json_int value.page));
        ("x", Some (json_float value.x));
        ("y", Some (json_float value.y));
        ("width", Some (json_float value.width));
        ("height", Some (json_float value.height));
      ]

  let to_model value =
    Models.decode Models.pdf_text_item (Yojson.Raw.to_string (to_json value))
end

module Anchored_text_absent = struct
  module Kind = struct
    type t = Not_yet | No_map | Unknown

    let to_string = function
      | Not_yet -> "not-yet"
      | No_map -> "no-map"
      | Unknown -> "unknown"

    let of_string = function
      | "not-yet" -> Some Not_yet
      | "no-map" -> Some No_map
      | "unknown" -> Some Unknown
      | _ -> None
  end

  type t = { kind : Kind.t }

  let project fields =
    let reader = start fields in
    { kind = required reader (enum Kind.of_string) "kind" }

  let of_model (model : [ `AnchoredTextAbsent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("kind", Some ((json_enum Kind.to_string) value.kind)) ]

  let to_model value =
    Models.decode Models.anchored_text_absent
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resource_request = struct
  type t = { resource_id : string }

  let project fields =
    let reader = start fields in
    { resource_id = required reader string "resourceId" }

  let of_model (model : [ `BrowseResourceRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ]

  let to_model value =
    Models.decode Models.browse_resource_request
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resources_request = struct
  type t = {
    archived : bool option;
    entity_type : string option;
    offset : int option;
    limit : int option;
  }

  let project fields =
    let reader = start fields in
    {
      archived = maybe reader bool "archived";
      entity_type = maybe reader string "entityType";
      offset = maybe reader int "offset";
      limit = maybe reader int "limit";
    }

  let of_model (model : [ `BrowseResourcesRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("archived", Option.map json_bool value.archived);
        ("entityType", Option.map json_string value.entity_type);
        ("offset", Option.map json_int value.offset);
        ("limit", Option.map json_int value.limit);
      ]

  let to_model value =
    Models.decode Models.browse_resources_request
      (Yojson.Raw.to_string (to_json value))
end

module Browse_router_push_event = struct
  type t = { path : string; reason : string option }

  let project fields =
    let reader = start fields in
    {
      path = required reader string "path";
      reason = maybe reader string "reason";
    }

  let of_model (model : [ `BrowseRouterPushEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("path", Some (json_string value.path));
        ("reason", Option.map json_string value.reason);
      ]

  let to_model value =
    Models.decode Models.browse_router_push_event
      (Yojson.Raw.to_string (to_json value))
end

module Bus_emit_accepted = struct
  type t = { subscribers : int option }

  let project fields =
    let reader = start fields in
    { subscribers = maybe reader int "subscribers" }

  let of_model (model : [ `BusEmitAccepted ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("subscribers", Option.map json_int value.subscribers) ]

  let to_model value =
    Models.decode Models.bus_emit_accepted
      (Yojson.Raw.to_string (to_json value))
end

module Bus_emit_request = struct
  type t = {
    channel : string;
    payload : (string * Yojson.Raw.t) list;
    scope : string option;
    client_id : string option;
    correlation_id : string option;
  }

  let project fields =
    let reader = start fields in
    {
      channel = required reader string "channel";
      payload = required reader (map raw) "payload";
      scope = maybe reader string "scope";
      client_id = maybe reader string "clientId";
      correlation_id = maybe reader string "correlationId";
    }

  let of_model (model : [ `BusEmitRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("channel", Some (json_string value.channel));
        ("payload", Some ((json_map json_raw) value.payload));
        ("scope", Option.map json_string value.scope);
        ("clientId", Option.map json_string value.client_id);
        ("correlationId", Option.map json_string value.correlation_id);
      ]

  let to_model value =
    Models.decode Models.bus_emit_request (Yojson.Raw.to_string (to_json value))
end

module Command_error = struct
  module Code = struct
    type t = Peer_unavailable | Not_found | Unauthorized | None_pending

    let to_string = function
      | Peer_unavailable -> "peer-unavailable"
      | Not_found -> "not-found"
      | Unauthorized -> "unauthorized"
      | None_pending -> "none-pending"

    let of_string = function
      | "peer-unavailable" -> Some Peer_unavailable
      | "not-found" -> Some Not_found
      | "unauthorized" -> Some Unauthorized
      | "none-pending" -> Some None_pending
      | _ -> None
  end

  type t = { code : Code.t option; message : string; details : string option }

  let project fields =
    let reader = start fields in
    {
      code = maybe reader (enum Code.of_string) "code";
      message = required reader string "message";
      details = maybe reader string "details";
    }

  let of_model (model : [ `CommandError ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Option.map (json_enum Code.to_string) value.code);
        ("message", Some (json_string value.message));
        ("details", Option.map json_string value.details);
      ]

  let to_model value =
    Models.decode Models.command_error (Yojson.Raw.to_string (to_json value))
end

module Create_resource_response = struct
  type t = { resource_id : string }

  let project fields =
    let reader = start fields in
    { resource_id = required reader string "resourceId" }

  let of_model (model : [ `CreateResourceResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ]

  let to_model value =
    Models.decode Models.create_resource_response
      (Yojson.Raw.to_string (to_json value))
end

module Dir_entry = struct
  module Type_ = struct
    type t = Dir

    let to_string = function Dir -> "dir"
    let of_string = function "dir" -> Some Dir | _ -> None
  end

  type t = { type_ : Type_.t; name : string; path : string; mtime : string }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      name = required reader string "name";
      path = required reader string "path";
      mtime = required reader string "mtime";
    }

  let of_model (model : [ `DirEntry ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("name", Some (json_string value.name));
        ("path", Some (json_string value.path));
        ("mtime", Some (json_string value.mtime));
      ]

  let to_model value =
    Models.decode Models.dir_entry (Yojson.Raw.to_string (to_json value))
end

module Discovered_kb = struct
  type t = {
    host : string;
    port : int;
    placement : Enums.Kb_placement.t;
    repo : string option;
    did : string;
    site_name : string option;
    managed_by : string;
  }

  let project fields =
    let reader = start fields in
    {
      host = required reader string "host";
      port = required reader int "port";
      placement =
        required reader (enum Enums.Kb_placement.of_string) "placement";
      repo = maybe reader string "repo";
      did = required reader string "did";
      site_name = maybe reader string "siteName";
      managed_by = required reader string "managedBy";
    }

  let of_model (model : [ `DiscoveredKB ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("host", Some (json_string value.host));
        ("port", Some (json_int value.port));
        ( "placement",
          Some ((json_enum Enums.Kb_placement.to_string) value.placement) );
        ("repo", Option.map json_string value.repo);
        ("did", Some (json_string value.did));
        ("siteName", Option.map json_string value.site_name);
        ("managedBy", Some (json_string value.managed_by));
      ]

  let to_model value =
    Models.decode Models.discovered_kb (Yojson.Raw.to_string (to_json value))
end

module Entity_tag_changed_payload = struct
  type t = { entity_type : string }

  let project fields =
    let reader = start fields in
    { entity_type = required reader string "entityType" }

  let of_model (model : [ `EntityTagChangedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("entityType", Some (json_string value.entity_type)) ]

  let to_model value =
    Models.decode Models.entity_tag_changed_payload
      (Yojson.Raw.to_string (to_json value))
end

module Entity_type_added_payload = struct
  type t = { entity_type : string }

  let project fields =
    let reader = start fields in
    { entity_type = required reader string "entityType" }

  let of_model (model : [ `EntityTypeAddedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("entityType", Some (json_string value.entity_type)) ]

  let to_model value =
    Models.decode Models.entity_type_added_payload
      (Yojson.Raw.to_string (to_json value))
end

module Error_response = struct
  type t = {
    error : string;
    code : string option;
    hint : string option;
    details : Yojson.Raw.t Types.presence;
  }

  let project fields =
    let reader = start fields in
    {
      error = required reader string "error";
      code = maybe reader string "code";
      hint = maybe reader string "hint";
      details = optional reader raw "details";
    }

  let of_model (model : [ `ErrorResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("error", Some (json_string value.error));
        ("code", Option.map json_string value.code);
        ("hint", Option.map json_string value.hint);
        ("details", present json_raw value.details);
      ]

  let to_model value =
    Models.decode Models.error_response (Yojson.Raw.to_string (to_json value))
end

module Event_metadata = struct
  type t = { sequence_number : int }

  let project fields =
    let reader = start fields in
    { sequence_number = required reader int "sequenceNumber" }

  let of_model (model : [ `EventMetadata ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("sequenceNumber", Some (json_int value.sequence_number)) ]

  let to_model value =
    Models.decode Models.event_metadata (Yojson.Raw.to_string (to_json value))
end

module Ocr_confidence = struct
  type t = { mean : float; low_confidence_words : int; total_words : int }

  let project fields =
    let reader = start fields in
    {
      mean = required reader float "mean";
      low_confidence_words = required reader int "lowConfidenceWords";
      total_words = required reader int "totalWords";
    }

  let of_model (model : [ `OcrConfidence ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("mean", Some (json_float value.mean));
        ("lowConfidenceWords", Some (json_int value.low_confidence_words));
        ("totalWords", Some (json_int value.total_words));
      ]

  let to_model value =
    Models.decode Models.ocr_confidence (Yojson.Raw.to_string (to_json value))
end

module Extraction_declined = struct
  module Kind = struct
    type t = Declined

    let to_string = function Declined -> "declined"
    let of_string = function "declined" -> Some Declined | _ -> None
  end

  type t = { kind : Kind.t; declined : Enums.Extraction_declined_reason.t }

  let project fields =
    let reader = start fields in
    {
      kind = required reader (enum Kind.of_string) "kind";
      declined =
        required reader
          (enum Enums.Extraction_declined_reason.of_string)
          "declined";
    }

  let of_model (model : [ `ExtractionDeclined ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ( "declined",
          Some
            ((json_enum Enums.Extraction_declined_reason.to_string)
               value.declined) );
      ]

  let to_model value =
    Models.decode Models.extraction_declined
      (Yojson.Raw.to_string (to_json value))
end

module File_entry = struct
  module Type_ = struct
    type t = File

    let to_string = function File -> "file"
    let of_string = function "file" -> Some File | _ -> None
  end

  type t = {
    type_ : Type_.t;
    name : string;
    path : string;
    size : int;
    mtime : string;
    tracked : bool;
    resource_id : string option;
    entity_types : string list option;
    annotation_count : int option;
    creator : string option;
  }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      name = required reader string "name";
      path = required reader string "path";
      size = required reader int "size";
      mtime = required reader string "mtime";
      tracked = required reader bool "tracked";
      resource_id = maybe reader string "resourceId";
      entity_types = maybe reader (list string) "entityTypes";
      annotation_count = maybe reader int "annotationCount";
      creator = maybe reader string "creator";
    }

  let of_model (model : [ `FileEntry ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("name", Some (json_string value.name));
        ("path", Some (json_string value.path));
        ("size", Some (json_int value.size));
        ("mtime", Some (json_string value.mtime));
        ("tracked", Some (json_bool value.tracked));
        ("resourceId", Option.map json_string value.resource_id);
        ("entityTypes", Option.map (json_list json_string) value.entity_types);
        ("annotationCount", Option.map json_int value.annotation_count);
        ("creator", Option.map json_string value.creator);
      ]

  let to_model value =
    Models.decode Models.file_entry (Yojson.Raw.to_string (to_json value))
end

module Fragment_selector = struct
  module Type_ = struct
    type t = FragmentSelector

    let to_string = function FragmentSelector -> "FragmentSelector"

    let of_string = function
      | "FragmentSelector" -> Some FragmentSelector
      | _ -> None
  end

  type t = { type_ : Type_.t; value : string; conforms_to : string option }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      value = required reader string "value";
      conforms_to = maybe reader string "conformsTo";
    }

  let of_model (model : [ `FragmentSelector ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("value", Some (json_string value.value));
        ("conformsTo", Option.map json_string value.conforms_to);
      ]

  let to_model value =
    Models.decode Models.fragment_selector
      (Yojson.Raw.to_string (to_json value))
end

module Frame_add_entity_type_command = struct
  type t = { tag : string; field_user_id : string option }

  let project fields =
    let reader = start fields in
    {
      tag = required reader string "tag";
      field_user_id = maybe reader string "_userId";
    }

  let of_model (model : [ `FrameAddEntityTypeCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("tag", Some (json_string value.tag));
        ("_userId", Option.map json_string value.field_user_id);
      ]

  let to_model value =
    Models.decode Models.frame_add_entity_type_command
      (Yojson.Raw.to_string (to_json value))
end

module Gather_annotation_options = struct
  type t = {
    include_source_context : bool option;
    include_target_context : bool option;
    context_window : int option;
  }

  let project fields =
    let reader = start fields in
    {
      include_source_context = maybe reader bool "includeSourceContext";
      include_target_context = maybe reader bool "includeTargetContext";
      context_window = maybe reader int "contextWindow";
    }

  let of_model (model : [ `GatherAnnotationOptions ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "includeSourceContext",
          Option.map json_bool value.include_source_context );
        ( "includeTargetContext",
          Option.map json_bool value.include_target_context );
        ("contextWindow", Option.map json_int value.context_window);
      ]

  let to_model value =
    Models.decode Models.gather_annotation_options
      (Yojson.Raw.to_string (to_json value))
end

module Gather_resource_request_options = struct
  type t = {
    depth : int;
    max_resources : int;
    include_content : bool;
    include_summary : bool;
    exclude_entity_types : string list option;
  }

  let project fields =
    let reader = start fields in
    {
      depth = required reader int "depth";
      max_resources = required reader int "maxResources";
      include_content = required reader bool "includeContent";
      include_summary = required reader bool "includeSummary";
      exclude_entity_types = maybe reader (list string) "excludeEntityTypes";
    }

  let of_model (model : [ `GatherResourceRequestOptions ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("depth", Some (json_int value.depth));
        ("maxResources", Some (json_int value.max_resources));
        ("includeContent", Some (json_bool value.include_content));
        ("includeSummary", Some (json_bool value.include_summary));
        ( "excludeEntityTypes",
          Option.map (json_list json_string) value.exclude_entity_types );
      ]

  let to_model value =
    Models.decode Models.gather_resource_request_options
      (Yojson.Raw.to_string (to_json value))
end

module Gather_summary_request = struct
  type t = { annotation_id : string; resource_id : string }

  let project fields =
    let reader = start fields in
    {
      annotation_id = required reader string "annotationId";
      resource_id = required reader string "resourceId";
    }

  let of_model (model : [ `GatherSummaryRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Some (json_string value.annotation_id));
        ("resourceId", Some (json_string value.resource_id));
      ]

  let to_model value =
    Models.decode Models.gather_summary_request
      (Yojson.Raw.to_string (to_json value))
end

module Gather_referenced_by_request = struct
  type t = { resource_id : string; motivation : Enums.Motivation.t option }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      motivation = maybe reader (enum Enums.Motivation.of_string) "motivation";
    }

  let of_model (model : [ `GatherReferencedByRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ( "motivation",
          Option.map (json_enum Enums.Motivation.to_string) value.motivation );
      ]

  let to_model value =
    Models.decode Models.gather_referenced_by_request
      (Yojson.Raw.to_string (to_json value))
end

module Get_entity_types_response = struct
  type t = { entity_types : string list }

  let project fields =
    let reader = start fields in
    { entity_types = required reader (list string) "entityTypes" }

  let of_model (model : [ `GetEntityTypesResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("entityTypes", Some ((json_list json_string) value.entity_types)) ]

  let to_model value =
    Models.decode Models.get_entity_types_response
      (Yojson.Raw.to_string (to_json value))
end

module Health_response = struct
  type t = {
    status : string;
    message : string;
    version : string;
    timestamp : string;
  }

  let project fields =
    let reader = start fields in
    {
      status = required reader string "status";
      message = required reader string "message";
      version = required reader string "version";
      timestamp = required reader string "timestamp";
    }

  let of_model (model : [ `HealthResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some (json_string value.status));
        ("message", Some (json_string value.message));
        ("version", Some (json_string value.version));
        ("timestamp", Some (json_string value.timestamp));
      ]

  let to_model value =
    Models.decode Models.health_response (Yojson.Raw.to_string (to_json value))
end

module Inference_limits = struct
  type t = {
    context_tokens : float;
    max_output_tokens : float;
    accepts_temperature : bool option;
  }

  let project fields =
    let reader = start fields in
    {
      context_tokens = required reader float "contextTokens";
      max_output_tokens = required reader float "maxOutputTokens";
      accepts_temperature = maybe reader bool "acceptsTemperature";
    }

  let of_model (model : [ `InferenceLimits ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("contextTokens", Some (json_float value.context_tokens));
        ("maxOutputTokens", Some (json_float value.max_output_tokens));
        ("acceptsTemperature", Option.map json_bool value.accepts_temperature);
      ]

  let to_model value =
    Models.decode Models.inference_limits (Yojson.Raw.to_string (to_json value))
end

module Graph_resource_node = struct
  module Type_ = struct
    type t = Resource

    let to_string = function Resource -> "resource"
    let of_string = function "resource" -> Some Resource | _ -> None
  end

  type t = {
    id : string;
    type_ : Type_.t;
    label : string;
    entity_types : string list option;
    metadata : (string * Yojson.Raw.t) list option;
  }

  let project fields =
    let reader = start fields in
    {
      id = required reader string "id";
      type_ = required reader (enum Type_.of_string) "type";
      label = required reader string "label";
      entity_types = maybe reader (list string) "entityTypes";
      metadata = maybe reader (map raw) "metadata";
    }

  let of_model (model : [ `GraphResourceNode ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("label", Some (json_string value.label));
        ("entityTypes", Option.map (json_list json_string) value.entity_types);
        ("metadata", Option.map (json_map json_raw) value.metadata);
      ]

  let to_model value =
    Models.decode Models.graph_resource_node
      (Yojson.Raw.to_string (to_json value))
end

module Job_cancel_request = struct
  type t = { job_id : string }

  let project fields =
    let reader = start fields in
    { job_id = required reader string "jobId" }

  let of_model (model : [ `JobCancelRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) = write [ ("jobId", Some (json_string value.job_id)) ]

  let to_model value =
    Models.decode Models.job_cancel_request
      (Yojson.Raw.to_string (to_json value))
end

module Job_completed_payload = struct
  type t = {
    job_id : string;
    job_type : Enums.Job_type.t;
    attempt : int option;
    annotation_id : string option;
    total_steps : int option;
    found_count : int option;
    result_resource_id : string option;
    annotation_uri : string option;
    result : (string * Yojson.Raw.t) list option;
    durability : Enums.Durability_evidence.t option;
  }

  let project fields =
    let reader = start fields in
    {
      job_id = required reader string "jobId";
      job_type = required reader (enum Enums.Job_type.of_string) "jobType";
      attempt = maybe reader int "attempt";
      annotation_id = maybe reader string "annotationId";
      total_steps = maybe reader int "totalSteps";
      found_count = maybe reader int "foundCount";
      result_resource_id = maybe reader string "resultResourceId";
      annotation_uri = maybe reader string "annotationUri";
      result = maybe reader (map raw) "result";
      durability =
        maybe reader (enum Enums.Durability_evidence.of_string) "durability";
    }

  let of_model (model : [ `JobCompletedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("jobId", Some (json_string value.job_id));
        ("jobType", Some ((json_enum Enums.Job_type.to_string) value.job_type));
        ("attempt", Option.map json_int value.attempt);
        ("annotationId", Option.map json_string value.annotation_id);
        ("totalSteps", Option.map json_int value.total_steps);
        ("foundCount", Option.map json_int value.found_count);
        ("resultResourceId", Option.map json_string value.result_resource_id);
        ("annotationUri", Option.map json_string value.annotation_uri);
        ("result", Option.map (json_map json_raw) value.result);
        ( "durability",
          Option.map
            (json_enum Enums.Durability_evidence.to_string)
            value.durability );
      ]

  let to_model value =
    Models.decode Models.job_completed_payload
      (Yojson.Raw.to_string (to_json value))
end

module Job_created_result_response = struct
  type t = { job_id : string }

  let project fields =
    let reader = start fields in
    { job_id = required reader string "jobId" }

  let of_model (model : [ `JobCreatedResultResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) = write [ ("jobId", Some (json_string value.job_id)) ]

  let to_model value =
    Models.decode Models.job_created_result_response
      (Yojson.Raw.to_string (to_json value))
end

module Unit_cursor = struct
  type t = { next : int; size : int; found : int; emitted : int; errors : int }

  let project fields =
    let reader = start fields in
    {
      next = required reader int "next";
      size = required reader int "size";
      found = required reader int "found";
      emitted = required reader int "emitted";
      errors = required reader int "errors";
    }

  let of_model (model : [ `UnitCursor ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("next", Some (json_int value.next));
        ("size", Some (json_int value.size));
        ("found", Some (json_int value.found));
        ("emitted", Some (json_int value.emitted));
        ("errors", Some (json_int value.errors));
      ]

  let to_model value =
    Models.decode Models.unit_cursor (Yojson.Raw.to_string (to_json value))
end

module Job_declined = struct
  module Reason = struct
    type t = No_text_layer | Encrypted | Corrupt | Too_large | Empty

    let to_string = function
      | No_text_layer -> "no-text-layer"
      | Encrypted -> "encrypted"
      | Corrupt -> "corrupt"
      | Too_large -> "too-large"
      | Empty -> "empty"

    let of_string = function
      | "no-text-layer" -> Some No_text_layer
      | "encrypted" -> Some Encrypted
      | "corrupt" -> Some Corrupt
      | "too-large" -> Some Too_large
      | "empty" -> Some Empty
      | _ -> None
  end

  type t = { declined : bool; reason : Reason.t }

  let project fields =
    let reader = start fields in
    {
      declined = required reader bool "declined";
      reason = required reader (enum Reason.of_string) "reason";
    }

  let of_model (model : [ `JobDeclined ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("declined", Some (json_bool value.declined));
        ("reason", Some ((json_enum Reason.to_string) value.reason));
      ]

  let to_model value =
    Models.decode Models.job_declined (Yojson.Raw.to_string (to_json value))
end

module Job_failed_payload = struct
  type t = {
    job_id : string;
    job_type : Enums.Job_type.t;
    attempt : int option;
    annotation_id : string option;
    error : string;
    failure_class : Enums.Failure_class.t option;
    will_retry : bool option;
    durability : Enums.Durability_evidence.t option;
  }

  let project fields =
    let reader = start fields in
    {
      job_id = required reader string "jobId";
      job_type = required reader (enum Enums.Job_type.of_string) "jobType";
      attempt = maybe reader int "attempt";
      annotation_id = maybe reader string "annotationId";
      error = required reader string "error";
      failure_class =
        maybe reader (enum Enums.Failure_class.of_string) "failureClass";
      will_retry = maybe reader bool "willRetry";
      durability =
        maybe reader (enum Enums.Durability_evidence.of_string) "durability";
    }

  let of_model (model : [ `JobFailedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("jobId", Some (json_string value.job_id));
        ("jobType", Some ((json_enum Enums.Job_type.to_string) value.job_type));
        ("attempt", Option.map json_int value.attempt);
        ("annotationId", Option.map json_string value.annotation_id);
        ("error", Some (json_string value.error));
        ( "failureClass",
          Option.map
            (json_enum Enums.Failure_class.to_string)
            value.failure_class );
        ("willRetry", Option.map json_bool value.will_retry);
        ( "durability",
          Option.map
            (json_enum Enums.Durability_evidence.to_string)
            value.durability );
      ]

  let to_model value =
    Models.decode Models.job_failed_payload
      (Yojson.Raw.to_string (to_json value))
end

module Yield_job_done = struct
  type t = { resource_id : string; resource_name : string; truncated : bool }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      resource_name = required reader string "resourceName";
      truncated = required reader bool "truncated";
    }

  let of_model (model : [ `YieldJobDone ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("resourceName", Some (json_string value.resource_name));
        ("truncated", Some (json_bool value.truncated));
      ]

  let to_model value =
    Models.decode Models.yield_job_done (Yojson.Raw.to_string (to_json value))
end

module Job_progress_analyzing = struct
  module Code = struct
    type t = Analyzing

    let to_string = function Analyzing -> "analyzing"
    let of_string = function "analyzing" -> Some Analyzing | _ -> None
  end

  type t = { code : Code.t }

  let project fields =
    let reader = start fields in
    { code = required reader (enum Code.of_string) "code" }

  let of_model (model : [ `JobProgressAnalyzing ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("code", Some ((json_enum Code.to_string) value.code)) ]

  let to_model value =
    Models.decode Models.job_progress_analyzing
      (Yojson.Raw.to_string (to_json value))
end

module Job_progress_analyzing_tags = struct
  module Code = struct
    type t = Analyzing_tags

    let to_string = function Analyzing_tags -> "analyzing-tags"

    let of_string = function
      | "analyzing-tags" -> Some Analyzing_tags
      | _ -> None
  end

  type t = { code : Code.t }

  let project fields =
    let reader = start fields in
    { code = required reader (enum Code.of_string) "code" }

  let of_model (model : [ `JobProgressAnalyzingTags ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("code", Some ((json_enum Code.to_string) value.code)) ]

  let to_model value =
    Models.decode Models.job_progress_analyzing_tags
      (Yojson.Raw.to_string (to_json value))
end

module Job_progress_complete_created = struct
  module Code = struct
    type t = Complete_created

    let to_string = function Complete_created -> "complete-created"

    let of_string = function
      | "complete-created" -> Some Complete_created
      | _ -> None
  end

  type t = { code : Code.t; count : int; motivation : Enums.Motivation.t }

  let project fields =
    let reader = start fields in
    {
      code = required reader (enum Code.of_string) "code";
      count = required reader int "count";
      motivation =
        required reader (enum Enums.Motivation.of_string) "motivation";
    }

  let of_model (model : [ `JobProgressCompleteCreated ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Some ((json_enum Code.to_string) value.code));
        ("count", Some (json_int value.count));
        ( "motivation",
          Some ((json_enum Enums.Motivation.to_string) value.motivation) );
      ]

  let to_model value =
    Models.decode Models.job_progress_complete_created
      (Yojson.Raw.to_string (to_json value))
end

module Job_progress_complete_generated = struct
  module Code = struct
    type t = Complete_generated

    let to_string = function Complete_generated -> "complete-generated"

    let of_string = function
      | "complete-generated" -> Some Complete_generated
      | _ -> None
  end

  type t = { code : Code.t; truncated : bool }

  let project fields =
    let reader = start fields in
    {
      code = required reader (enum Code.of_string) "code";
      truncated = required reader bool "truncated";
    }

  let of_model (model : [ `JobProgressCompleteGenerated ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Some ((json_enum Code.to_string) value.code));
        ("truncated", Some (json_bool value.truncated));
      ]

  let to_model value =
    Models.decode Models.job_progress_complete_generated
      (Yojson.Raw.to_string (to_json value))
end

module Job_progress_creating_annotations = struct
  module Code = struct
    type t = Creating_annotations

    let to_string = function Creating_annotations -> "creating-annotations"

    let of_string = function
      | "creating-annotations" -> Some Creating_annotations
      | _ -> None
  end

  type t = { code : Code.t; count : int }

  let project fields =
    let reader = start fields in
    {
      code = required reader (enum Code.of_string) "code";
      count = required reader int "count";
    }

  let of_model (model : [ `JobProgressCreatingAnnotations ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Some ((json_enum Code.to_string) value.code));
        ("count", Some (json_int value.count));
      ]

  let to_model value =
    Models.decode Models.job_progress_creating_annotations
      (Yojson.Raw.to_string (to_json value))
end

module Job_progress_creating_resource = struct
  module Code = struct
    type t = Creating_resource

    let to_string = function Creating_resource -> "creating-resource"

    let of_string = function
      | "creating-resource" -> Some Creating_resource
      | _ -> None
  end

  type t = { code : Code.t }

  let project fields =
    let reader = start fields in
    { code = required reader (enum Code.of_string) "code" }

  let of_model (model : [ `JobProgressCreatingResource ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("code", Some ((json_enum Code.to_string) value.code)) ]

  let to_model value =
    Models.decode Models.job_progress_creating_resource
      (Yojson.Raw.to_string (to_json value))
end

module Job_progress_creating_tag_annotations = struct
  module Code = struct
    type t = Creating_tag_annotations

    let to_string = function
      | Creating_tag_annotations -> "creating-tag-annotations"

    let of_string = function
      | "creating-tag-annotations" -> Some Creating_tag_annotations
      | _ -> None
  end

  type t = { code : Code.t; count : int }

  let project fields =
    let reader = start fields in
    {
      code = required reader (enum Code.of_string) "code";
      count = required reader int "count";
    }

  let of_model (model : [ `JobProgressCreatingTagAnnotations ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Some ((json_enum Code.to_string) value.code));
        ("count", Some (json_int value.count));
      ]

  let to_model value =
    Models.decode Models.job_progress_creating_tag_annotations
      (Yojson.Raw.to_string (to_json value))
end

module Job_progress_detecting_entities = struct
  module Code = struct
    type t = Detecting_entities

    let to_string = function Detecting_entities -> "detecting-entities"

    let of_string = function
      | "detecting-entities" -> Some Detecting_entities
      | _ -> None
  end

  type t = { code : Code.t; entity_type : string }

  let project fields =
    let reader = start fields in
    {
      code = required reader (enum Code.of_string) "code";
      entity_type = required reader string "entityType";
    }

  let of_model (model : [ `JobProgressDetectingEntities ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Some ((json_enum Code.to_string) value.code));
        ("entityType", Some (json_string value.entity_type));
      ]

  let to_model value =
    Models.decode Models.job_progress_detecting_entities
      (Yojson.Raw.to_string (to_json value))
end

module Job_progress_generating_resource = struct
  module Code = struct
    type t = Generating_resource

    let to_string = function Generating_resource -> "generating-resource"

    let of_string = function
      | "generating-resource" -> Some Generating_resource
      | _ -> None
  end

  type t = { code : Code.t }

  let project fields =
    let reader = start fields in
    { code = required reader (enum Code.of_string) "code" }

  let of_model (model : [ `JobProgressGeneratingResource ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("code", Some ((json_enum Code.to_string) value.code)) ]

  let to_model value =
    Models.decode Models.job_progress_generating_resource
      (Yojson.Raw.to_string (to_json value))
end

module Job_progress_loading = struct
  module Code = struct
    type t = Loading

    let to_string = function Loading -> "loading"
    let of_string = function "loading" -> Some Loading | _ -> None
  end

  type t = { code : Code.t }

  let project fields =
    let reader = start fields in
    { code = required reader (enum Code.of_string) "code" }

  let of_model (model : [ `JobProgressLoading ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("code", Some ((json_enum Code.to_string) value.code)) ]

  let to_model value =
    Models.decode Models.job_progress_loading
      (Yojson.Raw.to_string (to_json value))
end

module Mark_job_done = struct
  type t = {
    found : int;
    persisted : int;
    errors : int option;
    by_category : (string * int) list option;
    under_reported_pieces : int option;
    unchecked_pieces : int option;
  }

  let project fields =
    let reader = start fields in
    {
      found = required reader int "found";
      persisted = required reader int "persisted";
      errors = maybe reader int "errors";
      by_category = maybe reader (map int) "byCategory";
      under_reported_pieces = maybe reader int "underReportedPieces";
      unchecked_pieces = maybe reader int "uncheckedPieces";
    }

  let of_model (model : [ `MarkJobDone ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("found", Some (json_int value.found));
        ("persisted", Some (json_int value.persisted));
        ("errors", Option.map json_int value.errors);
        ("byCategory", Option.map (json_map json_int) value.by_category);
        ("underReportedPieces", Option.map json_int value.under_reported_pieces);
        ("uncheckedPieces", Option.map json_int value.unchecked_pieces);
      ]

  let to_model value =
    Models.decode Models.mark_job_done (Yojson.Raw.to_string (to_json value))
end

module Job_start_command = struct
  type t = {
    field_user_id : string option;
    resource_id : string;
    job_id : string;
    job_type : Enums.Job_type.t;
    annotation_id : string option;
    attempt : int option;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      resource_id = required reader string "resourceId";
      job_id = required reader string "jobId";
      job_type = required reader (enum Enums.Job_type.of_string) "jobType";
      annotation_id = maybe reader string "annotationId";
      attempt = maybe reader int "attempt";
    }

  let of_model (model : [ `JobStartCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("resourceId", Some (json_string value.resource_id));
        ("jobId", Some (json_string value.job_id));
        ("jobType", Some ((json_enum Enums.Job_type.to_string) value.job_type));
        ("annotationId", Option.map json_string value.annotation_id);
        ("attempt", Option.map json_int value.attempt);
      ]

  let to_model value =
    Models.decode Models.job_start_command
      (Yojson.Raw.to_string (to_json value))
end

module Job_assign_command = struct
  type t = {
    field_user_id : string option;
    job_id : string;
    job_type : Enums.Job_type.t;
    resource_id : string;
    holder : string;
    requester : string;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      job_id = required reader string "jobId";
      job_type = required reader (enum Enums.Job_type.of_string) "jobType";
      resource_id = required reader string "resourceId";
      holder = required reader string "holder";
      requester = required reader string "requester";
    }

  let of_model (model : [ `JobAssignCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("jobId", Some (json_string value.job_id));
        ("jobType", Some ((json_enum Enums.Job_type.to_string) value.job_type));
        ("resourceId", Some (json_string value.resource_id));
        ("holder", Some (json_string value.holder));
        ("requester", Some (json_string value.requester));
      ]

  let to_model value =
    Models.decode Models.job_assign_command
      (Yojson.Raw.to_string (to_json value))
end

module Job_started_payload = struct
  type t = {
    job_id : string;
    job_type : Enums.Job_type.t;
    annotation_id : string option;
    total_steps : int option;
  }

  let project fields =
    let reader = start fields in
    {
      job_id = required reader string "jobId";
      job_type = required reader (enum Enums.Job_type.of_string) "jobType";
      annotation_id = maybe reader string "annotationId";
      total_steps = maybe reader int "totalSteps";
    }

  let of_model (model : [ `JobStartedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("jobId", Some (json_string value.job_id));
        ("jobType", Some ((json_enum Enums.Job_type.to_string) value.job_type));
        ("annotationId", Option.map json_string value.annotation_id);
        ("totalSteps", Option.map json_int value.total_steps);
      ]

  let to_model value =
    Models.decode Models.job_started_payload
      (Yojson.Raw.to_string (to_json value))
end

module Job_assigned_payload = struct
  type t = {
    job_id : string;
    job_type : Enums.Job_type.t;
    resource_id : string;
    holder : string;
    requester : string;
  }

  let project fields =
    let reader = start fields in
    {
      job_id = required reader string "jobId";
      job_type = required reader (enum Enums.Job_type.of_string) "jobType";
      resource_id = required reader string "resourceId";
      holder = required reader string "holder";
      requester = required reader string "requester";
    }

  let of_model (model : [ `JobAssignedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("jobId", Some (json_string value.job_id));
        ("jobType", Some ((json_enum Enums.Job_type.to_string) value.job_type));
        ("resourceId", Some (json_string value.resource_id));
        ("holder", Some (json_string value.holder));
        ("requester", Some (json_string value.requester));
      ]

  let to_model value =
    Models.decode Models.job_assigned_payload
      (Yojson.Raw.to_string (to_json value))
end

module Principal_profile_command = struct
  type t = { field_user_id : string option; name : string }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      name = required reader string "name";
    }

  let of_model (model : [ `PrincipalProfileCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("name", Some (json_string value.name));
      ]

  let to_model value =
    Models.decode Models.principal_profile_command
      (Yojson.Raw.to_string (to_json value))
end

module Principal_profiled_payload = struct
  type t = { name : string }

  let project fields =
    let reader = start fields in
    { name = required reader string "name" }

  let of_model (model : [ `PrincipalProfiledPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) = write [ ("name", Some (json_string value.name)) ]

  let to_model value =
    Models.decode Models.principal_profiled_payload
      (Yojson.Raw.to_string (to_json value))
end

module Job_status_request = struct
  type t = { job_id : string }

  let project fields =
    let reader = start fields in
    { job_id = required reader string "jobId" }

  let of_model (model : [ `JobStatusRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) = write [ ("jobId", Some (json_string value.job_id)) ]

  let to_model value =
    Models.decode Models.job_status_request
      (Yojson.Raw.to_string (to_json value))
end

module Kb_description = struct
  type t = { name : string; domain : string; git_branch : string option }

  let project fields =
    let reader = start fields in
    {
      name = required reader string "name";
      domain = required reader string "domain";
      git_branch = maybe reader string "gitBranch";
    }

  let of_model (model : [ `KbDescription ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("domain", Some (json_string value.domain));
        ("gitBranch", Option.map json_string value.git_branch);
      ]

  let to_model value =
    Models.decode Models.kb_description (Yojson.Raw.to_string (to_json value))
end

module Http_endpoint = struct
  module Kind = struct
    type t = Http

    let to_string = function Http -> "http"
    let of_string = function "http" -> Some Http | _ -> None
  end

  module Protocol = struct
    type t = Http | Https

    let to_string = function Http -> "http" | Https -> "https"

    let of_string = function
      | "http" -> Some Http
      | "https" -> Some Https
      | _ -> None
  end

  type t = { kind : Kind.t; host : string; port : int; protocol : Protocol.t }

  let project fields =
    let reader = start fields in
    {
      kind = required reader (enum Kind.of_string) "kind";
      host = required reader string "host";
      port = required reader int "port";
      protocol = required reader (enum Protocol.of_string) "protocol";
    }

  let of_model (model : [ `HttpEndpoint ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("host", Some (json_string value.host));
        ("port", Some (json_int value.port));
        ("protocol", Some ((json_enum Protocol.to_string) value.protocol));
      ]

  let to_model value =
    Models.decode Models.http_endpoint (Yojson.Raw.to_string (to_json value))
end

module Kb_read = struct
  type t = { at : string; git_branch : string option }

  let project fields =
    let reader = start fields in
    {
      at = required reader string "at";
      git_branch = maybe reader string "gitBranch";
    }

  let of_model (model : [ `KbRead ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("at", Some (json_string value.at));
        ("gitBranch", Option.map json_string value.git_branch);
      ]

  let to_model value =
    Models.decode Models.kb_read (Yojson.Raw.to_string (to_json value))
end

module Local_endpoint = struct
  module Kind = struct
    type t = Local

    let to_string = function Local -> "local"
    let of_string = function "local" -> Some Local | _ -> None
  end

  type t = { kind : Kind.t; kb_id : string }

  let project fields =
    let reader = start fields in
    {
      kind = required reader (enum Kind.of_string) "kind";
      kb_id = required reader string "kbId";
    }

  let of_model (model : [ `LocalEndpoint ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("kbId", Some (json_string value.kb_id));
      ]

  let to_model value =
    Models.decode Models.local_endpoint (Yojson.Raw.to_string (to_json value))
end

module Mark_archive_command = struct
  type t = {
    field_user_id : string option;
    resource_id : string;
    storage_uri : string option;
    keep_file : bool option;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      resource_id = required reader string "resourceId";
      storage_uri = maybe reader string "storageUri";
      keep_file = maybe reader bool "keepFile";
    }

  let of_model (model : [ `MarkArchiveCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("resourceId", Some (json_string value.resource_id));
        ("storageUri", Option.map json_string value.storage_uri);
        ("keepFile", Option.map json_bool value.keep_file);
      ]

  let to_model value =
    Models.decode Models.mark_archive_command
      (Yojson.Raw.to_string (to_json value))
end

module Mark_create_ok_response = struct
  type t = { annotation_id : string }

  let project fields =
    let reader = start fields in
    { annotation_id = required reader string "annotationId" }

  let of_model (model : [ `MarkCreateOkResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("annotationId", Some (json_string value.annotation_id)) ]

  let to_model value =
    Models.decode Models.mark_create_ok_response
      (Yojson.Raw.to_string (to_json value))
end

module Mark_delete_command = struct
  type t = {
    field_user_id : string option;
    annotation_id : string;
    resource_id : string option;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      annotation_id = required reader string "annotationId";
      resource_id = maybe reader string "resourceId";
    }

  let of_model (model : [ `MarkDeleteCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("annotationId", Some (json_string value.annotation_id));
        ("resourceId", Option.map json_string value.resource_id);
      ]

  let to_model value =
    Models.decode Models.mark_delete_command
      (Yojson.Raw.to_string (to_json value))
end

module Mark_unarchive_command = struct
  type t = {
    field_user_id : string option;
    resource_id : string;
    storage_uri : string option;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      resource_id = required reader string "resourceId";
      storage_uri = maybe reader string "storageUri";
    }

  let of_model (model : [ `MarkUnarchiveCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("resourceId", Some (json_string value.resource_id));
        ("storageUri", Option.map json_string value.storage_uri);
      ]

  let to_model value =
    Models.decode Models.mark_unarchive_command
      (Yojson.Raw.to_string (to_json value))
end

module Mark_update_entity_types_command = struct
  type t = {
    resource_id : string;
    field_user_id : string option;
    current_entity_types : string list;
    updated_entity_types : string list;
  }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      field_user_id = maybe reader string "_userId";
      current_entity_types = required reader (list string) "currentEntityTypes";
      updated_entity_types = required reader (list string) "updatedEntityTypes";
    }

  let of_model (model : [ `MarkUpdateEntityTypesCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("_userId", Option.map json_string value.field_user_id);
        ( "currentEntityTypes",
          Some ((json_list json_string) value.current_entity_types) );
        ( "updatedEntityTypes",
          Some ((json_list json_string) value.updated_entity_types) );
      ]

  let to_model value =
    Models.decode Models.mark_update_entity_types_command
      (Yojson.Raw.to_string (to_json value))
end

module Match_search_failed = struct
  module Code = struct
    type t = Peer_unavailable | Not_found | Unauthorized | None_pending

    let to_string = function
      | Peer_unavailable -> "peer-unavailable"
      | Not_found -> "not-found"
      | Unauthorized -> "unauthorized"
      | None_pending -> "none-pending"

    let of_string = function
      | "peer-unavailable" -> Some Peer_unavailable
      | "not-found" -> Some Not_found
      | "unauthorized" -> Some Unauthorized
      | "none-pending" -> Some None_pending
      | _ -> None
  end

  type t = {
    code : Code.t option;
    message : string;
    details : string option;
    reference_id : string;
  }

  let project fields =
    let reader = start fields in
    {
      code = maybe reader (enum Code.of_string) "code";
      message = required reader string "message";
      details = maybe reader string "details";
      reference_id = required reader string "referenceId";
    }

  let of_model (model : [ `MatchSearchFailed ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Option.map (json_enum Code.to_string) value.code);
        ("message", Some (json_string value.message));
        ("details", Option.map json_string value.details);
        ("referenceId", Some (json_string value.reference_id));
      ]

  let to_model value =
    Models.decode Models.match_search_failed
      (Yojson.Raw.to_string (to_json value))
end

module Match_resources_request = struct
  type t = {
    search : string;
    archived : bool option;
    entity_type : string option;
    offset : int option;
    limit : int option;
  }

  let project fields =
    let reader = start fields in
    {
      search = required reader string "search";
      archived = maybe reader bool "archived";
      entity_type = maybe reader string "entityType";
      offset = maybe reader int "offset";
      limit = maybe reader int "limit";
    }

  let of_model (model : [ `MatchResourcesRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("search", Some (json_string value.search));
        ("archived", Option.map json_bool value.archived);
        ("entityType", Option.map json_string value.entity_type);
        ("offset", Option.map json_int value.offset);
        ("limit", Option.map json_int value.limit);
      ]

  let to_model value =
    Models.decode Models.match_resources_request
      (Yojson.Raw.to_string (to_json value))
end

module Media_token_request = struct
  type t = { resource_id : string }

  let project fields =
    let reader = start fields in
    { resource_id = required reader string "resourceId" }

  let of_model (model : [ `MediaTokenRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ]

  let to_model value =
    Models.decode Models.media_token_request
      (Yojson.Raw.to_string (to_json value))
end

module Media_token_response = struct
  type t = { token : string }

  let project fields =
    let reader = start fields in
    { token = required reader string "token" }

  let of_model (model : [ `MediaTokenResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) = write [ ("token", Some (json_string value.token)) ]

  let to_model value =
    Models.decode Models.media_token_response
      (Yojson.Raw.to_string (to_json value))
end

module Protected_resource_metadata = struct
  module Bearer_methods_supported = struct
    type t = Header

    let to_string = function Header -> "header"
    let of_string = function "header" -> Some Header | _ -> None
  end

  type t = {
    resource : string;
    authorization_servers : string list;
    bearer_methods_supported : Bearer_methods_supported.t list;
    resource_name : string option;
  }

  let project fields =
    let reader = start fields in
    {
      resource = required reader string "resource";
      authorization_servers =
        required reader (list string) "authorization_servers";
      bearer_methods_supported =
        required reader
          (list (enum Bearer_methods_supported.of_string))
          "bearer_methods_supported";
      resource_name = maybe reader string "resource_name";
    }

  let of_model (model : [ `ProtectedResourceMetadata ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resource", Some (json_string value.resource));
        ( "authorization_servers",
          Some ((json_list json_string) value.authorization_servers) );
        ( "bearer_methods_supported",
          Some
            ((json_list (json_enum Bearer_methods_supported.to_string))
               value.bearer_methods_supported) );
        ("resource_name", Option.map json_string value.resource_name);
      ]

  let to_model value =
    Models.decode Models.protected_resource_metadata
      (Yojson.Raw.to_string (to_json value))
end

module Representation_removed_payload = struct
  type t = { checksum : string }

  let project fields =
    let reader = start fields in
    { checksum = required reader string "checksum" }

  let of_model (model : [ `RepresentationRemovedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("checksum", Some (json_string value.checksum)) ]

  let to_model value =
    Models.decode Models.representation_removed_payload
      (Yojson.Raw.to_string (to_json value))
end

module Resource_archived_payload = struct
  type t = { reason : string option }

  let project fields =
    let reader = start fields in
    { reason = maybe reader string "reason" }

  let of_model (model : [ `ResourceArchivedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("reason", Option.map json_string value.reason) ]

  let to_model value =
    Models.decode Models.resource_archived_payload
      (Yojson.Raw.to_string (to_json value))
end

module Resource_moved_payload = struct
  type t = { from_uri : string; to_uri : string }

  let project fields =
    let reader = start fields in
    {
      from_uri = required reader string "fromUri";
      to_uri = required reader string "toUri";
    }

  let of_model (model : [ `ResourceMovedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("fromUri", Some (json_string value.from_uri));
        ("toUri", Some (json_string value.to_uri));
      ]

  let to_model value =
    Models.decode Models.resource_moved_payload
      (Yojson.Raw.to_string (to_json value))
end

module Resource_updated_payload = struct
  type t = { content_checksum : string; content_byte_size : int option }

  let project fields =
    let reader = start fields in
    {
      content_checksum = required reader string "contentChecksum";
      content_byte_size = maybe reader int "contentByteSize";
    }

  let of_model (model : [ `ResourceUpdatedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("contentChecksum", Some (json_string value.content_checksum));
        ("contentByteSize", Option.map json_int value.content_byte_size);
      ]

  let to_model value =
    Models.decode Models.resource_updated_payload
      (Yojson.Raw.to_string (to_json value))
end

module Semantic_match = struct
  type t = {
    text : string;
    resource_id : string;
    resource_name : string;
    annotation_id : string option;
    score : float;
    entity_types : string list option;
    machine_read : bool option;
  }

  let project fields =
    let reader = start fields in
    {
      text = required reader string "text";
      resource_id = required reader string "resourceId";
      resource_name = required reader string "resourceName";
      annotation_id = maybe reader string "annotationId";
      score = required reader float "score";
      entity_types = maybe reader (list string) "entityTypes";
      machine_read = maybe reader bool "machineRead";
    }

  let of_model (model : [ `SemanticMatch ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("text", Some (json_string value.text));
        ("resourceId", Some (json_string value.resource_id));
        ("resourceName", Some (json_string value.resource_name));
        ("annotationId", Option.map json_string value.annotation_id);
        ("score", Some (json_float value.score));
        ("entityTypes", Option.map (json_list json_string) value.entity_types);
        ("machineRead", Option.map json_bool value.machine_read);
      ]

  let to_model value =
    Models.decode Models.semantic_match (Yojson.Raw.to_string (to_json value))
end

module Session_joined_event = struct
  type t = { participant : string; connection_id : string }

  let project fields =
    let reader = start fields in
    {
      participant = required reader string "participant";
      connection_id = required reader string "connectionId";
    }

  let of_model (model : [ `SessionJoinedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("participant", Some (json_string value.participant));
        ("connectionId", Some (json_string value.connection_id));
      ]

  let to_model value =
    Models.decode Models.session_joined_event
      (Yojson.Raw.to_string (to_json value))
end

module Session_left_event = struct
  type t = { participant : string; connection_id : string }

  let project fields =
    let reader = start fields in
    {
      participant = required reader string "participant";
      connection_id = required reader string "connectionId";
    }

  let of_model (model : [ `SessionLeftEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("participant", Some (json_string value.participant));
        ("connectionId", Some (json_string value.connection_id));
      ]

  let to_model value =
    Models.decode Models.session_left_event
      (Yojson.Raw.to_string (to_json value))
end

module Settings_hover_delay_changed_event = struct
  type t = { hover_delay_ms : int }

  let project fields =
    let reader = start fields in
    { hover_delay_ms = required reader int "hoverDelayMs" }

  let of_model (model : [ `SettingsHoverDelayChangedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("hoverDelayMs", Some (json_int value.hover_delay_ms)) ]

  let to_model value =
    Models.decode Models.settings_hover_delay_changed_event
      (Yojson.Raw.to_string (to_json value))
end

module Settings_locale_changed_event = struct
  type t = { locale : string }

  let project fields =
    let reader = start fields in
    { locale = required reader string "locale" }

  let of_model (model : [ `SettingsLocaleChangedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("locale", Some (json_string value.locale)) ]

  let to_model value =
    Models.decode Models.settings_locale_changed_event
      (Yojson.Raw.to_string (to_json value))
end

module Settings_theme_changed_event = struct
  module Theme = struct
    type t = Light | Dark | System

    let to_string = function
      | Light -> "light"
      | Dark -> "dark"
      | System -> "system"

    let of_string = function
      | "light" -> Some Light
      | "dark" -> Some Dark
      | "system" -> Some System
      | _ -> None
  end

  type t = { theme : Theme.t }

  let project fields =
    let reader = start fields in
    { theme = required reader (enum Theme.of_string) "theme" }

  let of_model (model : [ `SettingsThemeChangedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("theme", Some ((json_enum Theme.to_string) value.theme)) ]

  let to_model value =
    Models.decode Models.settings_theme_changed_event
      (Yojson.Raw.to_string (to_json value))
end

module Specific_resource = struct
  module Type_ = struct
    type t = SpecificResource

    let to_string = function SpecificResource -> "SpecificResource"

    let of_string = function
      | "SpecificResource" -> Some SpecificResource
      | _ -> None
  end

  type t = {
    type_ : Type_.t;
    source : string;
    purpose : Enums.Body_purpose.t option;
  }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      source = required reader string "source";
      purpose = maybe reader (enum Enums.Body_purpose.of_string) "purpose";
    }

  let of_model (model : [ `SpecificResource ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("source", Some (json_string value.source));
        ( "purpose",
          Option.map (json_enum Enums.Body_purpose.to_string) value.purpose );
      ]

  let to_model value =
    Models.decode Models.specific_resource
      (Yojson.Raw.to_string (to_json value))
end

module Svg_selector = struct
  module Type_ = struct
    type t = SvgSelector

    let to_string = function SvgSelector -> "SvgSelector"
    let of_string = function "SvgSelector" -> Some SvgSelector | _ -> None
  end

  type t = { type_ : Type_.t; value : string }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      value = required reader string "value";
    }

  let of_model (model : [ `SvgSelector ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("value", Some (json_string value.value));
      ]

  let to_model value =
    Models.decode Models.svg_selector (Yojson.Raw.to_string (to_json value))
end

module Tag_category = struct
  type t = { name : string; description : string; examples : string list }

  let project fields =
    let reader = start fields in
    {
      name = required reader string "name";
      description = required reader string "description";
      examples = required reader (list string) "examples";
    }

  let of_model (model : [ `TagCategory ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("description", Some (json_string value.description));
        ("examples", Some ((json_list json_string) value.examples));
      ]

  let to_model value =
    Models.decode Models.tag_category (Yojson.Raw.to_string (to_json value))
end

module Text_position_selector = struct
  module Type_ = struct
    type t = TextPositionSelector

    let to_string = function TextPositionSelector -> "TextPositionSelector"

    let of_string = function
      | "TextPositionSelector" -> Some TextPositionSelector
      | _ -> None
  end

  type t = { type_ : Type_.t; start : int; end_ : int }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      start = required reader int "start";
      end_ = required reader int "end";
    }

  let of_model (model : [ `TextPositionSelector ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("start", Some (json_int value.start));
        ("end", Some (json_int value.end_));
      ]

  let to_model value =
    Models.decode Models.text_position_selector
      (Yojson.Raw.to_string (to_json value))
end

module Text_quote_selector = struct
  module Type_ = struct
    type t = TextQuoteSelector

    let to_string = function TextQuoteSelector -> "TextQuoteSelector"

    let of_string = function
      | "TextQuoteSelector" -> Some TextQuoteSelector
      | _ -> None
  end

  type t = {
    type_ : Type_.t;
    exact : string;
    prefix : string option;
    suffix : string option;
  }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      exact = required reader string "exact";
      prefix = maybe reader string "prefix";
      suffix = maybe reader string "suffix";
    }

  let of_model (model : [ `TextQuoteSelector ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("exact", Some (json_string value.exact));
        ("prefix", Option.map json_string value.prefix);
        ("suffix", Option.map json_string value.suffix);
      ]

  let to_model value =
    Models.decode Models.text_quote_selector
      (Yojson.Raw.to_string (to_json value))
end

module Textual_body = struct
  module Type_ = struct
    type t = TextualBody

    let to_string = function TextualBody -> "TextualBody"
    let of_string = function "TextualBody" -> Some TextualBody | _ -> None
  end

  type t = {
    type_ : Type_.t;
    value : string;
    purpose : Enums.Body_purpose.t option;
    format : string option;
    language : string option;
  }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      value = required reader string "value";
      purpose = maybe reader (enum Enums.Body_purpose.of_string) "purpose";
      format = maybe reader string "format";
      language = maybe reader string "language";
    }

  let of_model (model : [ `TextualBody ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("value", Some (json_string value.value));
        ( "purpose",
          Option.map (json_enum Enums.Body_purpose.to_string) value.purpose );
        ("format", Option.map json_string value.format);
        ("language", Option.map json_string value.language);
      ]

  let to_model value =
    Models.decode Models.textual_body (Yojson.Raw.to_string (to_json value))
end

module User_response = struct
  type t = {
    did : string;
    email : string option;
    name : string option;
    image : string option;
    domain : string;
  }

  let project fields =
    let reader = start fields in
    {
      did = required reader string "did";
      email = required reader (nullable string) "email";
      name = required reader (nullable string) "name";
      image = required reader (nullable string) "image";
      domain = required reader string "domain";
    }

  let of_model (model : [ `UserResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("did", Some (json_string value.did));
        ("email", Some ((json_nullable json_string) value.email));
        ("name", Some ((json_nullable json_string) value.name));
        ("image", Some ((json_nullable json_string) value.image));
        ("domain", Some (json_string value.domain));
      ]

  let to_model value =
    Models.decode Models.user_response (Yojson.Raw.to_string (to_json value))
end

module Smelt_rebuild_anchors_command = struct
  type t = { resource_id : string option; field_user_id : string option }

  let project fields =
    let reader = start fields in
    {
      resource_id = maybe reader string "resourceId";
      field_user_id = maybe reader string "_userId";
    }

  let of_model (model : [ `SmeltRebuildAnchorsCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Option.map json_string value.resource_id);
        ("_userId", Option.map json_string value.field_user_id);
      ]

  let to_model value =
    Models.decode Models.smelt_rebuild_anchors_command
      (Yojson.Raw.to_string (to_json value))
end

module Weave_rebuild_command = struct
  type t = { resource_id : string option; field_user_id : string option }

  let project fields =
    let reader = start fields in
    {
      resource_id = maybe reader string "resourceId";
      field_user_id = maybe reader string "_userId";
    }

  let of_model (model : [ `WeaveRebuildCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Option.map json_string value.resource_id);
        ("_userId", Option.map json_string value.field_user_id);
      ]

  let to_model value =
    Models.decode Models.weave_rebuild_command
      (Yojson.Raw.to_string (to_json value))
end

module Yield_clone_create_command = struct
  type t = {
    field_user_id : string option;
    token : string;
    name : string;
    storage_uri : string;
    content_checksum : string;
    byte_size : int;
    format : string;
    archive_original : bool option;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      token = required reader string "token";
      name = required reader string "name";
      storage_uri = required reader string "storageUri";
      content_checksum = required reader string "contentChecksum";
      byte_size = required reader int "byteSize";
      format = required reader string "format";
      archive_original = maybe reader bool "archiveOriginal";
    }

  let of_model (model : [ `YieldCloneCreateCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("token", Some (json_string value.token));
        ("name", Some (json_string value.name));
        ("storageUri", Some (json_string value.storage_uri));
        ("contentChecksum", Some (json_string value.content_checksum));
        ("byteSize", Some (json_int value.byte_size));
        ("format", Some (json_string value.format));
        ("archiveOriginal", Option.map json_bool value.archive_original);
      ]

  let to_model value =
    Models.decode Models.yield_clone_create_command
      (Yojson.Raw.to_string (to_json value))
end

module Yield_clone_resource_request = struct
  type t = { token : string }

  let project fields =
    let reader = start fields in
    { token = required reader string "token" }

  let of_model (model : [ `YieldCloneResourceRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) = write [ ("token", Some (json_string value.token)) ]

  let to_model value =
    Models.decode Models.yield_clone_resource_request
      (Yojson.Raw.to_string (to_json value))
end

module Yield_clone_token_request = struct
  type t = { resource_id : string }

  let project fields =
    let reader = start fields in
    { resource_id = required reader string "resourceId" }

  let of_model (model : [ `YieldCloneTokenRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ]

  let to_model value =
    Models.decode Models.yield_clone_token_request
      (Yojson.Raw.to_string (to_json value))
end

module Yield_clone_persist_command = struct
  type t = {
    field_user_id : string option;
    name : string;
    storage_uri : string;
    content_checksum : string;
    byte_size : int;
    format : string;
    language : string option;
    entity_types : string list option;
    parent_resource_id : string;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      name = required reader string "name";
      storage_uri = required reader string "storageUri";
      content_checksum = required reader string "contentChecksum";
      byte_size = required reader int "byteSize";
      format = required reader string "format";
      language = maybe reader string "language";
      entity_types = maybe reader (list string) "entityTypes";
      parent_resource_id = required reader string "parentResourceId";
    }

  let of_model (model : [ `YieldClonePersistCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("name", Some (json_string value.name));
        ("storageUri", Some (json_string value.storage_uri));
        ("contentChecksum", Some (json_string value.content_checksum));
        ("byteSize", Some (json_int value.byte_size));
        ("format", Some (json_string value.format));
        ("language", Option.map json_string value.language);
        ("entityTypes", Option.map (json_list json_string) value.entity_types);
        ("parentResourceId", Some (json_string value.parent_resource_id));
      ]

  let to_model value =
    Models.decode Models.yield_clone_persist_command
      (Yojson.Raw.to_string (to_json value))
end

module Yield_update_command = struct
  type t = {
    field_user_id : string option;
    resource_id : string;
    storage_uri : string;
    content_checksum : string;
    byte_size : int;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      resource_id = required reader string "resourceId";
      storage_uri = required reader string "storageUri";
      content_checksum = required reader string "contentChecksum";
      byte_size = required reader int "byteSize";
    }

  let of_model (model : [ `YieldUpdateCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("resourceId", Some (json_string value.resource_id));
        ("storageUri", Some (json_string value.storage_uri));
        ("contentChecksum", Some (json_string value.content_checksum));
        ("byteSize", Some (json_int value.byte_size));
      ]

  let to_model value =
    Models.decode Models.yield_update_command
      (Yojson.Raw.to_string (to_json value))
end

module Yielded_resource = struct
  type t = { resource_id : string }

  let project fields =
    let reader = start fields in
    { resource_id = required reader string "resourceId" }

  let of_model (model : [ `YieldedResource ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ]

  let to_model value =
    Models.decode Models.yielded_resource (Yojson.Raw.to_string (to_json value))
end

module Bus_frame = struct
  type t = {
    channel : string;
    correlation_id : string option;
    payload : (string * Yojson.Raw.t) list;
    scope : string option;
  }

  let project fields =
    let reader = start fields in
    {
      channel = required reader string "channel";
      correlation_id = maybe reader string "correlationId";
      payload = required reader (map raw) "payload";
      scope = maybe reader string "scope";
    }

  let of_model (model : [ `BusFrame ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("channel", Some (json_string value.channel));
        ("correlationId", Option.map json_string value.correlation_id);
        ("payload", Some ((json_map json_raw) value.payload));
        ("scope", Option.map json_string value.scope);
      ]

  let to_model value =
    Models.decode Models.bus_frame (Yojson.Raw.to_string (to_json value))
end

module Bus_ping_message = struct
  module Event = struct
    type t = Ping

    let to_string = function Ping -> "ping"
    let of_string = function "ping" -> Some Ping | _ -> None
  end

  type t = { event : Event.t; data : string }

  let project fields =
    let reader = start fields in
    {
      event = required reader (enum Event.of_string) "event";
      data = required reader string "data";
    }

  let of_model (model : [ `BusPingMessage ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("event", Some ((json_enum Event.to_string) value.event));
        ("data", Some (json_string value.data));
      ]

  let to_model value =
    Models.decode Models.bus_ping_message (Yojson.Raw.to_string (to_json value))
end

module Bus_resume_gap = struct
  module Reason = struct
    type t =
      | Unparseable_last_event_id
      | Scope_mismatch
      | Retention_exceeded
      | Query_error

    let to_string = function
      | Unparseable_last_event_id -> "unparseable-last-event-id"
      | Scope_mismatch -> "scope-mismatch"
      | Retention_exceeded -> "retention-exceeded"
      | Query_error -> "query-error"

    let of_string = function
      | "unparseable-last-event-id" -> Some Unparseable_last_event_id
      | "scope-mismatch" -> Some Scope_mismatch
      | "retention-exceeded" -> Some Retention_exceeded
      | "query-error" -> Some Query_error
      | _ -> None
  end

  type t = { scope : string; last_seen_id : string; reason : Reason.t }

  let project fields =
    let reader = start fields in
    {
      scope = required reader string "scope";
      last_seen_id = required reader string "lastSeenId";
      reason = required reader (enum Reason.of_string) "reason";
    }

  let of_model (model : [ `BusResumeGap ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("scope", Some (json_string value.scope));
        ("lastSeenId", Some (json_string value.last_seen_id));
        ("reason", Some ((json_enum Reason.to_string) value.reason));
      ]

  let to_model value =
    Models.decode Models.bus_resume_gap (Yojson.Raw.to_string (to_json value))
end

module Kb_identity = struct
  type t = { name : string; domain : string }

  let project fields =
    let reader = start fields in
    {
      name = required reader string "name";
      domain = required reader string "domain";
    }

  let of_model (model : [ `KbIdentity ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("domain", Some (json_string value.domain));
      ]

  let to_model value =
    Models.decode Models.kb_identity (Yojson.Raw.to_string (to_json value))
end

module Resource_upload = struct
  type t = {
    name : string;
    file : string;
    format : string;
    storage_uri : string;
    language : string option;
    entity_types : string option;
    source_annotation_id : string option;
    source_resource_id : string option;
    generation_prompt : string option;
    generator : string option;
    job_id : string option;
    is_draft : string option;
    clone_token : string option;
    archive_original : string option;
  }

  let project fields =
    let reader = start fields in
    {
      name = required reader string "name";
      file = required reader string "file";
      format = required reader string "format";
      storage_uri = required reader string "storageUri";
      language = maybe reader string "language";
      entity_types = maybe reader string "entityTypes";
      source_annotation_id = maybe reader string "sourceAnnotationId";
      source_resource_id = maybe reader string "sourceResourceId";
      generation_prompt = maybe reader string "generationPrompt";
      generator = maybe reader string "generator";
      job_id = maybe reader string "jobId";
      is_draft = maybe reader string "isDraft";
      clone_token = maybe reader string "cloneToken";
      archive_original = maybe reader string "archiveOriginal";
    }

  let of_model (model : [ `ResourceUpload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("file", Some (json_string value.file));
        ("format", Some (json_string value.format));
        ("storageUri", Some (json_string value.storage_uri));
        ("language", Option.map json_string value.language);
        ("entityTypes", Option.map json_string value.entity_types);
        ("sourceAnnotationId", Option.map json_string value.source_annotation_id);
        ("sourceResourceId", Option.map json_string value.source_resource_id);
        ("generationPrompt", Option.map json_string value.generation_prompt);
        ("generator", Option.map json_string value.generator);
        ("jobId", Option.map json_string value.job_id);
        ("isDraft", Option.map json_string value.is_draft);
        ("cloneToken", Option.map json_string value.clone_token);
        ("archiveOriginal", Option.map json_string value.archive_original);
      ]

  let to_model value =
    Models.decode Models.resource_upload (Yojson.Raw.to_string (to_json value))
end

module Limit_refusal = struct
  module Code = struct
    type t =
      | Streams
      | Emit_rate
      | Unanswered_requests
      | Capacity
      | Refusal_rate

    let to_string = function
      | Streams -> "streams"
      | Emit_rate -> "emit-rate"
      | Unanswered_requests -> "unanswered-requests"
      | Capacity -> "capacity"
      | Refusal_rate -> "refusal-rate"

    let of_string = function
      | "streams" -> Some Streams
      | "emit-rate" -> Some Emit_rate
      | "unanswered-requests" -> Some Unanswered_requests
      | "capacity" -> Some Capacity
      | "refusal-rate" -> Some Refusal_rate
      | _ -> None
  end

  type t = {
    error : string;
    code : Code.t;
    hint : string option;
    details : Yojson.Raw.t Types.presence;
  }

  let project fields =
    let reader = start fields in
    {
      error = required reader string "error";
      code = required reader (enum Code.of_string) "code";
      hint = maybe reader string "hint";
      details = optional reader raw "details";
    }

  let of_model (model : [ `LimitRefusal ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("error", Some (json_string value.error));
        ("code", Some ((json_enum Code.to_string) value.code));
        ("hint", Option.map json_string value.hint);
        ("details", present json_raw value.details);
      ]

  let to_model value =
    Models.decode Models.limit_refusal (Yojson.Raw.to_string (to_json value))
end

module Highlighting_job_params = struct
  module Motivation = struct
    type t = Highlighting

    let to_string = function Highlighting -> "highlighting"
    let of_string = function "highlighting" -> Some Highlighting | _ -> None
  end

  type t = {
    motivation : Motivation.t;
    instructions : string option;
    density : float option;
    source_language : string option;
  }

  let project fields =
    let reader = start fields in
    {
      motivation = required reader (enum Motivation.of_string) "motivation";
      instructions = maybe reader string "instructions";
      density = maybe reader float "density";
      source_language = maybe reader string "sourceLanguage";
    }

  let of_model (model : [ `HighlightingJobParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("motivation", Some ((json_enum Motivation.to_string) value.motivation));
        ("instructions", Option.map json_string value.instructions);
        ("density", Option.map json_float value.density);
        ("sourceLanguage", Option.map json_string value.source_language);
      ]

  let to_model value =
    Models.decode Models.highlighting_job_params
      (Yojson.Raw.to_string (to_json value))
end

module Commenting_job_params = struct
  module Motivation = struct
    type t = Commenting

    let to_string = function Commenting -> "commenting"
    let of_string = function "commenting" -> Some Commenting | _ -> None
  end

  module Tone = struct
    type t = Scholarly | Explanatory | Conversational | Technical

    let to_string = function
      | Scholarly -> "scholarly"
      | Explanatory -> "explanatory"
      | Conversational -> "conversational"
      | Technical -> "technical"

    let of_string = function
      | "scholarly" -> Some Scholarly
      | "explanatory" -> Some Explanatory
      | "conversational" -> Some Conversational
      | "technical" -> Some Technical
      | _ -> None
  end

  type t = {
    motivation : Motivation.t;
    instructions : string option;
    tone : Tone.t option;
    density : float option;
    language : string option;
    source_language : string option;
  }

  let project fields =
    let reader = start fields in
    {
      motivation = required reader (enum Motivation.of_string) "motivation";
      instructions = maybe reader string "instructions";
      tone = maybe reader (enum Tone.of_string) "tone";
      density = maybe reader float "density";
      language = maybe reader string "language";
      source_language = maybe reader string "sourceLanguage";
    }

  let of_model (model : [ `CommentingJobParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("motivation", Some ((json_enum Motivation.to_string) value.motivation));
        ("instructions", Option.map json_string value.instructions);
        ("tone", Option.map (json_enum Tone.to_string) value.tone);
        ("density", Option.map json_float value.density);
        ("language", Option.map json_string value.language);
        ("sourceLanguage", Option.map json_string value.source_language);
      ]

  let to_model value =
    Models.decode Models.commenting_job_params
      (Yojson.Raw.to_string (to_json value))
end

module Assessing_job_params = struct
  module Motivation = struct
    type t = Assessing

    let to_string = function Assessing -> "assessing"
    let of_string = function "assessing" -> Some Assessing | _ -> None
  end

  module Tone = struct
    type t = Analytical | Critical | Balanced | Constructive

    let to_string = function
      | Analytical -> "analytical"
      | Critical -> "critical"
      | Balanced -> "balanced"
      | Constructive -> "constructive"

    let of_string = function
      | "analytical" -> Some Analytical
      | "critical" -> Some Critical
      | "balanced" -> Some Balanced
      | "constructive" -> Some Constructive
      | _ -> None
  end

  type t = {
    motivation : Motivation.t;
    instructions : string option;
    tone : Tone.t option;
    density : float option;
    language : string option;
    source_language : string option;
  }

  let project fields =
    let reader = start fields in
    {
      motivation = required reader (enum Motivation.of_string) "motivation";
      instructions = maybe reader string "instructions";
      tone = maybe reader (enum Tone.of_string) "tone";
      density = maybe reader float "density";
      language = maybe reader string "language";
      source_language = maybe reader string "sourceLanguage";
    }

  let of_model (model : [ `AssessingJobParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("motivation", Some ((json_enum Motivation.to_string) value.motivation));
        ("instructions", Option.map json_string value.instructions);
        ("tone", Option.map (json_enum Tone.to_string) value.tone);
        ("density", Option.map json_float value.density);
        ("language", Option.map json_string value.language);
        ("sourceLanguage", Option.map json_string value.source_language);
      ]

  let to_model value =
    Models.decode Models.assessing_job_params
      (Yojson.Raw.to_string (to_json value))
end

module Linking_job_params = struct
  module Motivation = struct
    type t = Linking

    let to_string = function Linking -> "linking"
    let of_string = function "linking" -> Some Linking | _ -> None
  end

  type t = {
    motivation : Motivation.t;
    entity_types : string list;
    include_descriptive_references : bool option;
    language : string option;
    source_language : string option;
  }

  let project fields =
    let reader = start fields in
    {
      motivation = required reader (enum Motivation.of_string) "motivation";
      entity_types = required reader (list string) "entityTypes";
      include_descriptive_references =
        maybe reader bool "includeDescriptiveReferences";
      language = maybe reader string "language";
      source_language = maybe reader string "sourceLanguage";
    }

  let of_model (model : [ `LinkingJobParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("motivation", Some ((json_enum Motivation.to_string) value.motivation));
        ("entityTypes", Some ((json_list json_string) value.entity_types));
        ( "includeDescriptiveReferences",
          Option.map json_bool value.include_descriptive_references );
        ("language", Option.map json_string value.language);
        ("sourceLanguage", Option.map json_string value.source_language);
      ]

  let to_model value =
    Models.decode Models.linking_job_params
      (Yojson.Raw.to_string (to_json value))
end

module Tagging_job_params = struct
  module Motivation = struct
    type t = Tagging

    let to_string = function Tagging -> "tagging"
    let of_string = function "tagging" -> Some Tagging | _ -> None
  end

  type t = {
    motivation : Motivation.t;
    schema_id : string;
    categories : string list;
    language : string option;
    source_language : string option;
  }

  let project fields =
    let reader = start fields in
    {
      motivation = required reader (enum Motivation.of_string) "motivation";
      schema_id = required reader string "schemaId";
      categories = required reader (list string) "categories";
      language = maybe reader string "language";
      source_language = maybe reader string "sourceLanguage";
    }

  let of_model (model : [ `TaggingJobParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("motivation", Some ((json_enum Motivation.to_string) value.motivation));
        ("schemaId", Some (json_string value.schema_id));
        ("categories", Some ((json_list json_string) value.categories));
        ("language", Option.map json_string value.language);
        ("sourceLanguage", Option.map json_string value.source_language);
      ]

  let to_model value =
    Models.decode Models.tagging_job_params
      (Yojson.Raw.to_string (to_json value))
end

module Generation_job_request = struct
  type t = {
    title : string;
    storage_uri : string;
    prompt : string option;
    entity_types : string list option;
    language : string option;
    source_language : string option;
    temperature : float option;
    max_tokens : float option;
    output_media_type : Enums.Supported_media_type.t option;
    task : string option;
    structure : string option;
    cite : bool option;
  }

  let project fields =
    let reader = start fields in
    {
      title = required reader string "title";
      storage_uri = required reader string "storageUri";
      prompt = maybe reader string "prompt";
      entity_types = maybe reader (list string) "entityTypes";
      language = maybe reader string "language";
      source_language = maybe reader string "sourceLanguage";
      temperature = maybe reader float "temperature";
      max_tokens = maybe reader float "maxTokens";
      output_media_type =
        maybe reader
          (enum Enums.Supported_media_type.of_string)
          "outputMediaType";
      task = maybe reader string "task";
      structure = maybe reader string "structure";
      cite = maybe reader bool "cite";
    }

  let of_model (model : [ `GenerationJobRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("title", Some (json_string value.title));
        ("storageUri", Some (json_string value.storage_uri));
        ("prompt", Option.map json_string value.prompt);
        ("entityTypes", Option.map (json_list json_string) value.entity_types);
        ("language", Option.map json_string value.language);
        ("sourceLanguage", Option.map json_string value.source_language);
        ("temperature", Option.map json_float value.temperature);
        ("maxTokens", Option.map json_float value.max_tokens);
        ( "outputMediaType",
          Option.map
            (json_enum Enums.Supported_media_type.to_string)
            value.output_media_type );
        ("task", Option.map json_string value.task);
        ("structure", Option.map json_string value.structure);
        ("cite", Option.map json_bool value.cite);
      ]

  let to_model value =
    Models.decode Models.generation_job_request
      (Yojson.Raw.to_string (to_json value))
end

module Yield_job_filter = struct
  module Job_type = struct
    type t = Yield

    let to_string = function Yield -> "yield"
    let of_string = function "yield" -> Some Yield | _ -> None
  end

  type t = { job_type : Job_type.t }

  let project fields =
    let reader = start fields in
    { job_type = required reader (enum Job_type.of_string) "jobType" }

  let of_model (model : [ `YieldJobFilter ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("jobType", Some ((json_enum Job_type.to_string) value.job_type)) ]

  let to_model value =
    Models.decode Models.yield_job_filter (Yojson.Raw.to_string (to_json value))
end

module Service_identity = struct
  type t = { issuer : string }

  let project fields =
    let reader = start fields in
    { issuer = required reader string "issuer" }

  let of_model (model : [ `ServiceIdentity ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("issuer", Some (json_string value.issuer)) ]

  let to_model value =
    Models.decode Models.service_identity (Yojson.Raw.to_string (to_json value))
end

module Service_address = struct
  type t = { host : string; port : int }

  let project fields =
    let reader = start fields in
    { host = required reader string "host"; port = required reader int "port" }

  let of_model (model : [ `ServiceAddress ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("host", Some (json_string value.host));
        ("port", Some (json_int value.port));
      ]

  let to_model value =
    Models.decode Models.service_address (Yojson.Raw.to_string (to_json value))
end

module Entity_types_projection = struct
  type t = { entity_types : string list }

  let project fields =
    let reader = start fields in
    { entity_types = required reader (list string) "entityTypes" }

  let of_model (model : [ `EntityTypesProjection ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("entityTypes", Some ((json_list json_string) value.entity_types)) ]

  let to_model value =
    Models.decode Models.entity_types_projection
      (Yojson.Raw.to_string (to_json value))
end

module Profile = struct
  type t = { name : string; since : string }

  let project fields =
    let reader = start fields in
    {
      name = required reader string "name";
      since = required reader string "since";
    }

  let of_model (model : [ `Profile ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("since", Some (json_string value.since));
      ]

  let to_model value =
    Models.decode Models.profile (Yojson.Raw.to_string (to_json value))
end

module Storage_uri_entry = struct
  type t = { uri : string; resource_id : string }

  let project fields =
    let reader = start fields in
    {
      uri = required reader string "uri";
      resource_id = required reader string "resourceId";
    }

  let of_model (model : [ `StorageUriEntry ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("uri", Some (json_string value.uri));
        ("resourceId", Some (json_string value.resource_id));
      ]

  let to_model value =
    Models.decode Models.storage_uri_entry
      (Yojson.Raw.to_string (to_json value))
end

module Engine = struct
  type t = { provider : Enums.Inference_provider.t; model : string }

  let project fields =
    let reader = start fields in
    {
      provider =
        required reader (enum Enums.Inference_provider.of_string) "provider";
      model = required reader string "model";
    }

  let of_model (model : [ `Engine ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "provider",
          Some ((json_enum Enums.Inference_provider.to_string) value.provider)
        );
        ("model", Some (json_string value.model));
      ]

  let to_model value =
    Models.decode Models.engine (Yojson.Raw.to_string (to_json value))
end

module Gather_failed = struct
  module Code = struct
    type t = Peer_unavailable | Not_found | Unauthorized | None_pending

    let to_string = function
      | Peer_unavailable -> "peer-unavailable"
      | Not_found -> "not-found"
      | Unauthorized -> "unauthorized"
      | None_pending -> "none-pending"

    let of_string = function
      | "peer-unavailable" -> Some Peer_unavailable
      | "not-found" -> Some Not_found
      | "unauthorized" -> Some Unauthorized
      | "none-pending" -> Some None_pending
      | _ -> None
  end

  type t = {
    code : Code.t option;
    message : string;
    details : string option;
    annotation_id : string;
  }

  let project fields =
    let reader = start fields in
    {
      code = maybe reader (enum Code.of_string) "code";
      message = required reader string "message";
      details = maybe reader string "details";
      annotation_id = required reader string "annotationId";
    }

  let of_model (model : [ `GatherFailed ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Option.map (json_enum Code.to_string) value.code);
        ("message", Some (json_string value.message));
        ("details", Option.map json_string value.details);
        ("annotationId", Some (json_string value.annotation_id));
      ]

  let to_model value =
    Models.decode Models.gather_failed (Yojson.Raw.to_string (to_json value))
end

module Gather_resource_failed = struct
  module Code = struct
    type t = Peer_unavailable | Not_found | Unauthorized | None_pending

    let to_string = function
      | Peer_unavailable -> "peer-unavailable"
      | Not_found -> "not-found"
      | Unauthorized -> "unauthorized"
      | None_pending -> "none-pending"

    let of_string = function
      | "peer-unavailable" -> Some Peer_unavailable
      | "not-found" -> Some Not_found
      | "unauthorized" -> Some Unauthorized
      | "none-pending" -> Some None_pending
      | _ -> None
  end

  type t = {
    code : Code.t option;
    message : string;
    details : string option;
    resource_id : string;
  }

  let project fields =
    let reader = start fields in
    {
      code = maybe reader (enum Code.of_string) "code";
      message = required reader string "message";
      details = maybe reader string "details";
      resource_id = required reader string "resourceId";
    }

  let of_model (model : [ `GatherResourceFailed ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Option.map (json_enum Code.to_string) value.code);
        ("message", Some (json_string value.message));
        ("details", Option.map json_string value.details);
        ("resourceId", Some (json_string value.resource_id));
      ]

  let to_model value =
    Models.decode Models.gather_resource_failed
      (Yojson.Raw.to_string (to_json value))
end

module Browse_directory_failed = struct
  module Code = struct
    type t = Peer_unavailable | Not_found | Unauthorized | None_pending

    let to_string = function
      | Peer_unavailable -> "peer-unavailable"
      | Not_found -> "not-found"
      | Unauthorized -> "unauthorized"
      | None_pending -> "none-pending"

    let of_string = function
      | "peer-unavailable" -> Some Peer_unavailable
      | "not-found" -> Some Not_found
      | "unauthorized" -> Some Unauthorized
      | "none-pending" -> Some None_pending
      | _ -> None
  end

  type t = {
    code : Code.t option;
    message : string;
    details : string option;
    path : string;
  }

  let project fields =
    let reader = start fields in
    {
      code = maybe reader (enum Code.of_string) "code";
      message = required reader string "message";
      details = maybe reader string "details";
      path = required reader string "path";
    }

  let of_model (model : [ `BrowseDirectoryFailed ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Option.map (json_enum Code.to_string) value.code);
        ("message", Some (json_string value.message));
        ("details", Option.map json_string value.details);
        ("path", Some (json_string value.path));
      ]

  let to_model value =
    Models.decode Models.browse_directory_failed
      (Yojson.Raw.to_string (to_json value))
end

module Mark_delegate_timeout_event = struct
  type t = { resource_id : string; motivation : Enums.Motivation.t }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      motivation =
        required reader (enum Enums.Motivation.of_string) "motivation";
    }

  let of_model (model : [ `MarkDelegateTimeoutEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ( "motivation",
          Some ((json_enum Enums.Motivation.to_string) value.motivation) );
      ]

  let to_model value =
    Models.decode Models.mark_delegate_timeout_event
      (Yojson.Raw.to_string (to_json value))
end

module Resource_error_event = struct
  type t = { resource_id : string; message : string }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      message = required reader string "message";
    }

  let of_model (model : [ `ResourceErrorEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("message", Some (json_string value.message));
      ]

  let to_model value =
    Models.decode Models.resource_error_event
      (Yojson.Raw.to_string (to_json value))
end

module Job_cancel_result = struct
  type t = { cancelled : bool }

  let project fields =
    let reader = start fields in
    { cancelled = required reader bool "cancelled" }

  let of_model (model : [ `JobCancelResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("cancelled", Some (json_bool value.cancelled)) ]

  let to_model value =
    Models.decode Models.job_cancel_result
      (Yojson.Raw.to_string (to_json value))
end

module Weave_applied = struct
  type t = { resource_id : string; sequence_number : int }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      sequence_number = required reader int "sequenceNumber";
    }

  let of_model (model : [ `WeaveApplied ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("sequenceNumber", Some (json_int value.sequence_number));
      ]

  let to_model value =
    Models.decode Models.weave_applied (Yojson.Raw.to_string (to_json value))
end

module Smelt_settled = struct
  module Outcome = struct
    type t = Indexed | Skipped

    let to_string = function Indexed -> "indexed" | Skipped -> "skipped"

    let of_string = function
      | "indexed" -> Some Indexed
      | "skipped" -> Some Skipped
      | _ -> None
  end

  module Reason = struct
    type t =
      | No_extractor
      | Empty
      | No_text_layer
      | Encrypted
      | Corrupt
      | Too_large

    let to_string = function
      | No_extractor -> "no-extractor"
      | Empty -> "empty"
      | No_text_layer -> "no-text-layer"
      | Encrypted -> "encrypted"
      | Corrupt -> "corrupt"
      | Too_large -> "too-large"

    let of_string = function
      | "no-extractor" -> Some No_extractor
      | "empty" -> Some Empty
      | "no-text-layer" -> Some No_text_layer
      | "encrypted" -> Some Encrypted
      | "corrupt" -> Some Corrupt
      | "too-large" -> Some Too_large
      | _ -> None
  end

  type t = {
    resource_id : string;
    content_checksum : string;
    outcome : Outcome.t;
    reason : Reason.t option;
  }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      content_checksum = required reader string "contentChecksum";
      outcome = required reader (enum Outcome.of_string) "outcome";
      reason = maybe reader (enum Reason.of_string) "reason";
    }

  let of_model (model : [ `SmeltSettled ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("contentChecksum", Some (json_string value.content_checksum));
        ("outcome", Some ((json_enum Outcome.to_string) value.outcome));
        ("reason", Option.map (json_enum Reason.to_string) value.reason);
      ]

  let to_model value =
    Models.decode Models.smelt_settled (Yojson.Raw.to_string (to_json value))
end

module Anchored_text_declined_entry = struct
  type t = {
    v : int;
    stamp : string;
    declined : Enums.Extraction_declined_reason.t;
  }

  let project fields =
    let reader = start fields in
    {
      v = required reader int "v";
      stamp = required reader string "stamp";
      declined =
        required reader
          (enum Enums.Extraction_declined_reason.of_string)
          "declined";
    }

  let of_model (model : [ `AnchoredTextDeclinedEntry ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("v", Some (json_int value.v));
        ("stamp", Some (json_string value.stamp));
        ( "declined",
          Some
            ((json_enum Enums.Extraction_declined_reason.to_string)
               value.declined) );
      ]

  let to_model value =
    Models.decode Models.anchored_text_declined_entry
      (Yojson.Raw.to_string (to_json value))
end

module Anchored_text_entries = struct
  type t = { checksums : string list }

  let project fields =
    let reader = start fields in
    { checksums = required reader (list string) "checksums" }

  let of_model (model : [ `AnchoredTextEntries ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("checksums", Some ((json_list json_string) value.checksums)) ]

  let to_model value =
    Models.decode Models.anchored_text_entries
      (Yojson.Raw.to_string (to_json value))
end

module Anchored_text_stamp = struct
  type t = { stamp : string }

  let project fields =
    let reader = start fields in
    { stamp = required reader string "stamp" }

  let of_model (model : [ `AnchoredTextStamp ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) = write [ ("stamp", Some (json_string value.stamp)) ]

  let to_model value =
    Models.decode Models.anchored_text_stamp
      (Yojson.Raw.to_string (to_json value))
end

module Archivist_health = struct
  module Status = struct
    type t = Ok

    let to_string = function Ok -> "ok"
    let of_string = function "ok" -> Some Ok | _ -> None
  end

  module Actors = struct
    type t = Stower | Browser | CloneTokenManager

    let to_string = function
      | Stower -> "stower"
      | Browser -> "browser"
      | CloneTokenManager -> "cloneTokenManager"

    let of_string = function
      | "stower" -> Some Stower
      | "browser" -> Some Browser
      | "cloneTokenManager" -> Some CloneTokenManager
      | _ -> None
  end

  type t = { status : Status.t; actors : Actors.t list }

  let project fields =
    let reader = start fields in
    {
      status = required reader (enum Status.of_string) "status";
      actors = required reader (list (enum Actors.of_string)) "actors";
    }

  let of_model (model : [ `ArchivistHealth ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("actors", Some ((json_list (json_enum Actors.to_string)) value.actors));
      ]

  let to_model value =
    Models.decode Models.archivist_health (Yojson.Raw.to_string (to_json value))
end

module Archivist_stream = struct
  type t = { resource_id : string; last_sequence : int }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      last_sequence = required reader int "lastSequence";
    }

  let of_model (model : [ `ArchivistStream ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("lastSequence", Some (json_int value.last_sequence));
      ]

  let to_model value =
    Models.decode Models.archivist_stream (Yojson.Raw.to_string (to_json value))
end

module Representation_not_found = struct
  module Code = struct
    type t = Resource | Representation

    let to_string = function
      | Resource -> "resource"
      | Representation -> "representation"

    let of_string = function
      | "resource" -> Some Resource
      | "representation" -> Some Representation
      | _ -> None
  end

  type t = {
    error : string;
    code : Code.t;
    hint : string option;
    details : Yojson.Raw.t Types.presence;
  }

  let project fields =
    let reader = start fields in
    {
      error = required reader string "error";
      code = required reader (enum Code.of_string) "code";
      hint = maybe reader string "hint";
      details = optional reader raw "details";
    }

  let of_model (model : [ `RepresentationNotFound ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("error", Some (json_string value.error));
        ("code", Some ((json_enum Code.to_string) value.code));
        ("hint", Option.map json_string value.hint);
        ("details", present json_raw value.details);
      ]

  let to_model value =
    Models.decode Models.representation_not_found
      (Yojson.Raw.to_string (to_json value))
end

module Retry_budget = struct
  type t = { attempts : int; initial_delay_ms : int; max_delay_ms : int }

  let project fields =
    let reader = start fields in
    {
      attempts = required reader int "attempts";
      initial_delay_ms = required reader int "initialDelayMs";
      max_delay_ms = required reader int "maxDelayMs";
    }

  let of_model (model : [ `RetryBudget ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("attempts", Some (json_int value.attempts));
        ("initialDelayMs", Some (json_int value.initial_delay_ms));
        ("maxDelayMs", Some (json_int value.max_delay_ms));
      ]

  let to_model value =
    Models.decode Models.retry_budget (Yojson.Raw.to_string (to_json value))
end

module Conformance_bus_fetch = struct
  type t = {
    fetch : string;
    payload : Yojson.Raw.t Types.presence;
    as_ : string;
  }

  let project fields =
    let reader = start fields in
    {
      fetch = required reader string "fetch";
      payload = optional reader raw "payload";
      as_ = required reader string "as";
    }

  let of_model (model : [ `ConformanceBusFetch ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("fetch", Some (json_string value.fetch));
        ("payload", present json_raw value.payload);
        ("as", Some (json_string value.as_));
      ]

  let to_model value =
    Models.decode Models.conformance_bus_fetch
      (Yojson.Raw.to_string (to_json value))
end

module Conformance_failure = struct
  type t = {
    code : string option;
    status : int option;
    failure_class : Enums.Failure_class.t option;
    detail : string;
  }

  let project fields =
    let reader = start fields in
    {
      code = maybe reader string "code";
      status = maybe reader int "status";
      failure_class =
        maybe reader (enum Enums.Failure_class.of_string) "failureClass";
      detail = required reader string "detail";
    }

  let of_model (model : [ `ConformanceFailure ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Option.map json_string value.code);
        ("status", Option.map json_int value.status);
        ( "failureClass",
          Option.map
            (json_enum Enums.Failure_class.to_string)
            value.failure_class );
        ("detail", Some (json_string value.detail));
      ]

  let to_model value =
    Models.decode Models.conformance_failure
      (Yojson.Raw.to_string (to_json value))
end

module Conformance_http_fetch = struct
  type t = { fetch : string; params : Yojson.Raw.t Types.presence }

  let project fields =
    let reader = start fields in
    {
      fetch = required reader string "fetch";
      params = optional reader raw "params";
    }

  let of_model (model : [ `ConformanceHttpFetch ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("fetch", Some (json_string value.fetch));
        ("params", present json_raw value.params);
      ]

  let to_model value =
    Models.decode Models.conformance_http_fetch
      (Yojson.Raw.to_string (to_json value))
end

module About_params = struct
  type t = { api_version : Enums.Api_version.t }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
    }

  let of_model (model : [ `AboutParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
      ]

  let to_model value =
    Models.decode Models.about_params (Yojson.Raw.to_string (to_json value))
end

module Auth_login_result = struct
  type t = { key : string; who : string; issuer : string }

  let project fields =
    let reader = start fields in
    {
      key = required reader string "key";
      who = required reader string "who";
      issuer = required reader string "issuer";
    }

  let of_model (model : [ `AuthLoginResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("key", Some (json_string value.key));
        ("who", Some (json_string value.who));
        ("issuer", Some (json_string value.issuer));
      ]

  let to_model value =
    Models.decode Models.auth_login_result
      (Yojson.Raw.to_string (to_json value))
end

module Auth_logout_result = struct
  type t = { key : string option; was_signed_in : bool; revoked : bool }

  let project fields =
    let reader = start fields in
    {
      key = maybe reader string "key";
      was_signed_in = required reader bool "wasSignedIn";
      revoked = required reader bool "revoked";
    }

  let of_model (model : [ `AuthLogoutResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("key", Option.map json_string value.key);
        ("wasSignedIn", Some (json_bool value.was_signed_in));
        ("revoked", Some (json_bool value.revoked));
      ]

  let to_model value =
    Models.decode Models.auth_logout_result
      (Yojson.Raw.to_string (to_json value))
end

module Field_fault = struct
  type t = { field : string; message : string }

  let project fields =
    let reader = start fields in
    {
      field = required reader string "field";
      message = required reader string "message";
    }

  let of_model (model : [ `FieldFault ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("field", Some (json_string value.field));
        ("message", Some (json_string value.message));
      ]

  let to_model value =
    Models.decode Models.field_fault (Yojson.Raw.to_string (to_json value))
end

module Identity_user = struct
  type t = { email : string; identity : string; enabled : bool }

  let project fields =
    let reader = start fields in
    {
      email = required reader string "email";
      identity = required reader string "identity";
      enabled = required reader bool "enabled";
    }

  let of_model (model : [ `IdentityUser ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("email", Some (json_string value.email));
        ("identity", Some (json_string value.identity));
        ("enabled", Some (json_bool value.enabled));
      ]

  let to_model value =
    Models.decode Models.identity_user (Yojson.Raw.to_string (to_json value))
end

module Identity_useradd_result = struct
  type t = {
    email : string;
    identity : string;
    created : bool;
    generated_password : string option;
  }

  let project fields =
    let reader = start fields in
    {
      email = required reader string "email";
      identity = required reader string "identity";
      created = required reader bool "created";
      generated_password = maybe reader string "generatedPassword";
    }

  let of_model (model : [ `IdentityUseraddResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("email", Some (json_string value.email));
        ("identity", Some (json_string value.identity));
        ("created", Some (json_bool value.created));
        ("generatedPassword", Option.map json_string value.generated_password);
      ]

  let to_model value =
    Models.decode Models.identity_useradd_result
      (Yojson.Raw.to_string (to_json value))
end

module Local_target = struct
  module Kind = struct
    type t = Local

    let to_string = function Local -> "local"
    let of_string = function "local" -> Some Local | _ -> None
  end

  type t = { kind : Kind.t; root : string }

  let project fields =
    let reader = start fields in
    {
      kind = required reader (enum Kind.of_string) "kind";
      root = required reader string "root";
    }

  let of_model (model : [ `LocalTarget ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("root", Some (json_string value.root));
      ]

  let to_model value =
    Models.decode Models.local_target (Yojson.Raw.to_string (to_json value))
end

module Logs_follow_result = struct
  type t = { services : string list }

  let project fields =
    let reader = start fields in
    { services = required reader (list string) "services" }

  let of_model (model : [ `LogsFollowResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("services", Some ((json_list json_string) value.services)) ]

  let to_model value =
    Models.decode Models.logs_follow_result
      (Yojson.Raw.to_string (to_json value))
end

module Root = struct
  module Current = struct
    type t = Cwd | Xynolog_root

    let to_string = function Cwd -> "cwd" | Xynolog_root -> "xynolog-root"

    let of_string = function
      | "cwd" -> Some Cwd
      | "xynolog-root" -> Some Xynolog_root
      | _ -> None
  end

  type t = {
    placement : Enums.Kb_placement.t;
    path : string option;
    present : bool option;
    current : Current.t option;
    registered : bool;
    running : bool;
    last_used : string option;
    did : string option;
    site_name : string option;
    identity_error : string option;
    config : string option;
    configs : string list option;
    repo : string option;
    codespace : string option;
    codespace_state : string option;
    forward_port : int option;
    forwarded : bool option;
    reachable : bool option;
  }

  let project fields =
    let reader = start fields in
    {
      placement =
        required reader (enum Enums.Kb_placement.of_string) "placement";
      path = maybe reader string "path";
      present = maybe reader bool "present";
      current = maybe reader (enum Current.of_string) "current";
      registered = required reader bool "registered";
      running = required reader bool "running";
      last_used = maybe reader string "lastUsed";
      did = maybe reader string "did";
      site_name = maybe reader string "siteName";
      identity_error = maybe reader string "identityError";
      config = maybe reader string "config";
      configs = maybe reader (list string) "configs";
      repo = maybe reader string "repo";
      codespace = maybe reader string "codespace";
      codespace_state = maybe reader string "codespaceState";
      forward_port = maybe reader int "forwardPort";
      forwarded = maybe reader bool "forwarded";
      reachable = maybe reader bool "reachable";
    }

  let of_model (model : [ `Root ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "placement",
          Some ((json_enum Enums.Kb_placement.to_string) value.placement) );
        ("path", Option.map json_string value.path);
        ("present", Option.map json_bool value.present);
        ("current", Option.map (json_enum Current.to_string) value.current);
        ("registered", Some (json_bool value.registered));
        ("running", Some (json_bool value.running));
        ("lastUsed", Option.map json_string value.last_used);
        ("did", Option.map json_string value.did);
        ("siteName", Option.map json_string value.site_name);
        ("identityError", Option.map json_string value.identity_error);
        ("config", Option.map json_string value.config);
        ("configs", Option.map (json_list json_string) value.configs);
        ("repo", Option.map json_string value.repo);
        ("codespace", Option.map json_string value.codespace);
        ("codespaceState", Option.map json_string value.codespace_state);
        ("forwardPort", Option.map json_int value.forward_port);
        ("forwarded", Option.map json_bool value.forwarded);
        ("reachable", Option.map json_bool value.reachable);
      ]

  let to_model value =
    Models.decode Models.root (Yojson.Raw.to_string (to_json value))
end

module Roots_forget_params = struct
  type t = { api_version : Enums.Api_version.t; root : string }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      root = required reader string "root";
    }

  let of_model (model : [ `RootsForgetParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("root", Some (json_string value.root));
      ]

  let to_model value =
    Models.decode Models.roots_forget_params
      (Yojson.Raw.to_string (to_json value))
end

module Roots_forget_result = struct
  type t = {
    path : string;
    directory_missing : bool;
    persistent_state : string option;
  }

  let project fields =
    let reader = start fields in
    {
      path = required reader string "path";
      directory_missing = required reader bool "directoryMissing";
      persistent_state = maybe reader string "persistentState";
    }

  let of_model (model : [ `RootsForgetResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("path", Some (json_string value.path));
        ("directoryMissing", Some (json_bool value.directory_missing));
        ("persistentState", Option.map json_string value.persistent_state);
      ]

  let to_model value =
    Models.decode Models.roots_forget_result
      (Yojson.Raw.to_string (to_json value))
end

module Roots_init_params = struct
  module Inference = struct
    type t = Anthropic | Ollama

    let to_string = function Anthropic -> "anthropic" | Ollama -> "ollama"

    let of_string = function
      | "anthropic" -> Some Anthropic
      | "ollama" -> Some Ollama
      | _ -> None
  end

  type t = {
    api_version : Enums.Api_version.t;
    path : string;
    domain : string;
    name : string option;
    site_name : string option;
    inference : Inference.t option;
    model : string option;
    model_light : string option;
    embedding : string option;
    config_name : string option;
    anthropic_endpoint : string option;
    ollama_base : string option;
    ollama_registry : string option;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      path = required reader string "path";
      domain = required reader string "domain";
      name = maybe reader string "name";
      site_name = maybe reader string "siteName";
      inference = maybe reader (enum Inference.of_string) "inference";
      model = maybe reader string "model";
      model_light = maybe reader string "modelLight";
      embedding = maybe reader string "embedding";
      config_name = maybe reader string "configName";
      anthropic_endpoint = maybe reader string "anthropicEndpoint";
      ollama_base = maybe reader string "ollamaBase";
      ollama_registry = maybe reader string "ollamaRegistry";
    }

  let of_model (model : [ `RootsInitParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("path", Some (json_string value.path));
        ("domain", Some (json_string value.domain));
        ("name", Option.map json_string value.name);
        ("siteName", Option.map json_string value.site_name);
        ("inference", Option.map (json_enum Inference.to_string) value.inference);
        ("model", Option.map json_string value.model);
        ("modelLight", Option.map json_string value.model_light);
        ("embedding", Option.map json_string value.embedding);
        ("configName", Option.map json_string value.config_name);
        ("anthropicEndpoint", Option.map json_string value.anthropic_endpoint);
        ("ollamaBase", Option.map json_string value.ollama_base);
        ("ollamaRegistry", Option.map json_string value.ollama_registry);
      ]

  let to_model value =
    Models.decode Models.roots_init_params
      (Yojson.Raw.to_string (to_json value))
end

module Roots_init_result = struct
  type t = { path : string }

  let project fields =
    let reader = start fields in
    { path = required reader string "path" }

  let of_model (model : [ `RootsInitResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) = write [ ("path", Some (json_string value.path)) ]

  let to_model value =
    Models.decode Models.roots_init_result
      (Yojson.Raw.to_string (to_json value))
end

module Roots_list_params = struct
  type t = { api_version : Enums.Api_version.t }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
    }

  let of_model (model : [ `RootsListParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
      ]

  let to_model value =
    Models.decode Models.roots_list_params
      (Yojson.Raw.to_string (to_json value))
end

module Runtime_state = struct
  type t = { name : Enums.Runtime.t; found : bool }

  let project fields =
    let reader = start fields in
    {
      name = required reader (enum Enums.Runtime.of_string) "name";
      found = required reader bool "found";
    }

  let of_model (model : [ `RuntimeState ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some ((json_enum Enums.Runtime.to_string) value.name));
        ("found", Some (json_bool value.found));
      ]

  let to_model value =
    Models.decode Models.runtime_state (Yojson.Raw.to_string (to_json value))
end

module Service_host_params = struct
  type t = {
    api_version : Enums.Api_version.t;
    runtime : Enums.Runtime.t option;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
    }

  let of_model (model : [ `ServiceHostParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
      ]

  let to_model value =
    Models.decode Models.service_host_params
      (Yojson.Raw.to_string (to_json value))
end

module Service_host_result = struct
  type t = { runtime : Enums.Runtime.t; address : string }

  let project fields =
    let reader = start fields in
    {
      runtime = required reader (enum Enums.Runtime.of_string) "runtime";
      address = required reader string "address";
    }

  let of_model (model : [ `ServiceHostResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("runtime", Some ((json_enum Enums.Runtime.to_string) value.runtime));
        ("address", Some (json_string value.address));
      ]

  let to_model value =
    Models.decode Models.service_host_result
      (Yojson.Raw.to_string (to_json value))
end

module Service_run_result = struct
  type t = { instance : string; exit_code : int; ran_ms : int }

  let project fields =
    let reader = start fields in
    {
      instance = required reader string "instance";
      exit_code = required reader int "exitCode";
      ran_ms = required reader int "ranMs";
    }

  let of_model (model : [ `ServiceRunResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("instance", Some (json_string value.instance));
        ("exitCode", Some (json_int value.exit_code));
        ("ranMs", Some (json_int value.ran_ms));
      ]

  let to_model value =
    Models.decode Models.service_run_result
      (Yojson.Raw.to_string (to_json value))
end

module Service_signal_result = struct
  type t = { delivered : bool }

  let project fields =
    let reader = start fields in
    { delivered = required reader bool "delivered" }

  let of_model (model : [ `ServiceSignalResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("delivered", Some (json_bool value.delivered)) ]

  let to_model value =
    Models.decode Models.service_signal_result
      (Yojson.Raw.to_string (to_json value))
end

module Service_status = struct
  module State = struct
    type t =
      | Running
      | Stopped
      | Reachable
      | Unreachable
      | Absent
      | Not_configured

    let to_string = function
      | Running -> "running"
      | Stopped -> "stopped"
      | Reachable -> "reachable"
      | Unreachable -> "unreachable"
      | Absent -> "absent"
      | Not_configured -> "not-configured"

    let of_string = function
      | "running" -> Some Running
      | "stopped" -> Some Stopped
      | "reachable" -> Some Reachable
      | "unreachable" -> Some Unreachable
      | "absent" -> Some Absent
      | "not-configured" -> Some Not_configured
      | _ -> None
  end

  type t = {
    role : string;
    group : Enums.Service_group.t;
    product : string option;
    runs_on : string option;
    state : State.t;
    container_state : string option;
    healthy : bool;
    counted : bool;
    probe : string option;
    page : string option;
    realm : string option;
    serves : string list option;
  }

  let project fields =
    let reader = start fields in
    {
      role = required reader string "role";
      group = required reader (enum Enums.Service_group.of_string) "group";
      product = maybe reader string "product";
      runs_on = maybe reader string "runsOn";
      state = required reader (enum State.of_string) "state";
      container_state = maybe reader string "containerState";
      healthy = required reader bool "healthy";
      counted = required reader bool "counted";
      probe = maybe reader string "probe";
      page = maybe reader string "page";
      realm = maybe reader string "realm";
      serves = maybe reader (list string) "serves";
    }

  let of_model (model : [ `ServiceStatus ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("role", Some (json_string value.role));
        ("group", Some ((json_enum Enums.Service_group.to_string) value.group));
        ("product", Option.map json_string value.product);
        ("runsOn", Option.map json_string value.runs_on);
        ("state", Some ((json_enum State.to_string) value.state));
        ("containerState", Option.map json_string value.container_state);
        ("healthy", Some (json_bool value.healthy));
        ("counted", Some (json_bool value.counted));
        ("probe", Option.map json_string value.probe);
        ("page", Option.map json_string value.page);
        ("realm", Option.map json_string value.realm);
        ("serves", Option.map (json_list json_string) value.serves);
      ]

  let to_model value =
    Models.decode Models.service_status (Yojson.Raw.to_string (to_json value))
end

module Session = struct
  module State = struct
    type t = Valid | Expired | Unverified | None

    let to_string = function
      | Valid -> "valid"
      | Expired -> "expired"
      | Unverified -> "unverified"
      | None -> "none"

    let of_string = function
      | "valid" -> Some Valid
      | "expired" -> Some Expired
      | "unverified" -> Some Unverified
      | "none" -> Some None
      | _ -> None
  end

  type t = { state : State.t; email : string option }

  let project fields =
    let reader = start fields in
    {
      state = required reader (enum State.of_string) "state";
      email = maybe reader string "email";
    }

  let of_model (model : [ `Session ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("state", Some ((json_enum State.to_string) value.state));
        ("email", Option.map json_string value.email);
      ]

  let to_model value =
    Models.decode Models.session (Yojson.Raw.to_string (to_json value))
end

module Setting_line = struct
  type t = { value : string; source : string }

  let project fields =
    let reader = start fields in
    {
      value = required reader string "value";
      source = required reader string "source";
    }

  let of_model (model : [ `SettingLine ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("value", Some (json_string value.value));
        ("source", Some (json_string value.source));
      ]

  let to_model value =
    Models.decode Models.setting_line (Yojson.Raw.to_string (to_json value))
end

module Settings_get_params = struct
  type t = {
    api_version : Enums.Api_version.t;
    name : string;
    default : bool option;
    root : string option;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      name = required reader string "name";
      default = maybe reader bool "default";
      root = maybe reader string "root";
    }

  let of_model (model : [ `SettingsGetParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("name", Some (json_string value.name));
        ("default", Option.map json_bool value.default);
        ("root", Option.map json_string value.root);
      ]

  let to_model value =
    Models.decode Models.settings_get_params
      (Yojson.Raw.to_string (to_json value))
end

module Settings_list_params = struct
  type t = { api_version : Enums.Api_version.t; root : string option }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      root = maybe reader string "root";
    }

  let of_model (model : [ `SettingsListParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("root", Option.map json_string value.root);
      ]

  let to_model value =
    Models.decode Models.settings_list_params
      (Yojson.Raw.to_string (to_json value))
end

module Settings_path_params = struct
  module Document = struct
    type t = Browser | Worker | Issuer | Vectors

    let to_string = function
      | Browser -> "browser"
      | Worker -> "worker"
      | Issuer -> "issuer"
      | Vectors -> "vectors"

    let of_string = function
      | "browser" -> Some Browser
      | "worker" -> Some Worker
      | "issuer" -> Some Issuer
      | "vectors" -> Some Vectors
      | _ -> None
  end

  type t = { api_version : Enums.Api_version.t; document : Document.t }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      document = required reader (enum Document.of_string) "document";
    }

  let of_model (model : [ `SettingsPathParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("document", Some ((json_enum Document.to_string) value.document));
      ]

  let to_model value =
    Models.decode Models.settings_path_params
      (Yojson.Raw.to_string (to_json value))
end

module Settings_path_result = struct
  type t = { path : string }

  let project fields =
    let reader = start fields in
    { path = required reader string "path" }

  let of_model (model : [ `SettingsPathResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) = write [ ("path", Some (json_string value.path)) ]

  let to_model value =
    Models.decode Models.settings_path_result
      (Yojson.Raw.to_string (to_json value))
end

module Settings_set_params = struct
  type t = {
    api_version : Enums.Api_version.t;
    name : string;
    default : bool option;
    root : string option;
    value : string;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      name = required reader string "name";
      default = maybe reader bool "default";
      root = maybe reader string "root";
      value = required reader string "value";
    }

  let of_model (model : [ `SettingsSetParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("name", Some (json_string value.name));
        ("default", Option.map json_bool value.default);
        ("root", Option.map json_string value.root);
        ("value", Some (json_string value.value));
      ]

  let to_model value =
    Models.decode Models.settings_set_params
      (Yojson.Raw.to_string (to_json value))
end

module Settings_unset_params = struct
  type t = {
    api_version : Enums.Api_version.t;
    name : string;
    default : bool option;
    root : string option;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      name = required reader string "name";
      default = maybe reader bool "default";
      root = maybe reader string "root";
    }

  let of_model (model : [ `SettingsUnsetParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("name", Some (json_string value.name));
        ("default", Option.map json_bool value.default);
        ("root", Option.map json_string value.root);
      ]

  let to_model value =
    Models.decode Models.settings_unset_params
      (Yojson.Raw.to_string (to_json value))
end

module Target = struct
  type t = {
    kind : Enums.Kb_placement.t;
    root : string option;
    repo : string option;
  }

  let project fields =
    let reader = start fields in
    {
      kind = required reader (enum Enums.Kb_placement.of_string) "kind";
      root = maybe reader string "root";
      repo = maybe reader string "repo";
    }

  let of_model (model : [ `Target ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kind", Some ((json_enum Enums.Kb_placement.to_string) value.kind));
        ("root", Option.map json_string value.root);
        ("repo", Option.map json_string value.repo);
      ]

  let to_model value =
    Models.decode Models.target (Yojson.Raw.to_string (to_json value))
end

module Dispatcher_health = struct
  module Status = struct
    type t = Ok

    let to_string = function Ok -> "ok"
    let of_string = function "ok" -> Some Ok | _ -> None
  end

  module Queue = struct
    type t = Jetstream

    let to_string = function Jetstream -> "jetstream"
    let of_string = function "jetstream" -> Some Jetstream | _ -> None
  end

  type t = { status : Status.t; queue : Queue.t }

  let project fields =
    let reader = start fields in
    {
      status = required reader (enum Status.of_string) "status";
      queue = required reader (enum Queue.of_string) "queue";
    }

  let of_model (model : [ `DispatcherHealth ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("queue", Some ((json_enum Queue.to_string) value.queue));
      ]

  let to_model value =
    Models.decode Models.dispatcher_health
      (Yojson.Raw.to_string (to_json value))
end

module Ollama_embedding_config = struct
  module Type_ = struct
    type t = Ollama

    let to_string = function Ollama -> "ollama"
    let of_string = function "ollama" -> Some Ollama | _ -> None
  end

  type t = { type_ : Type_.t; model : string; base_url : string }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      model = required reader string "model";
      base_url = required reader string "baseUrl";
    }

  let of_model (model : [ `OllamaEmbeddingConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("model", Some (json_string value.model));
        ("baseUrl", Some (json_string value.base_url));
      ]

  let to_model value =
    Models.decode Models.ollama_embedding_config
      (Yojson.Raw.to_string (to_json value))
end

module Voyage_embedding_config = struct
  module Type_ = struct
    type t = Voyage

    let to_string = function Voyage -> "voyage"
    let of_string = function "voyage" -> Some Voyage | _ -> None
  end

  type t = {
    type_ : Type_.t;
    model : string;
    endpoint : string;
    api_key_env : string;
  }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      model = required reader string "model";
      endpoint = required reader string "endpoint";
      api_key_env = required reader string "apiKeyEnv";
    }

  let of_model (model : [ `VoyageEmbeddingConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("model", Some (json_string value.model));
        ("endpoint", Some (json_string value.endpoint));
        ("apiKeyEnv", Some (json_string value.api_key_env));
      ]

  let to_model value =
    Models.decode Models.voyage_embedding_config
      (Yojson.Raw.to_string (to_json value))
end

module Follower_following = struct
  module Sweep = struct
    type t = Pending | Running | Done | Due

    let to_string = function
      | Pending -> "pending"
      | Running -> "running"
      | Done -> "done"
      | Due -> "due"

    let of_string = function
      | "pending" -> Some Pending
      | "running" -> Some Running
      | "done" -> Some Done
      | "due" -> Some Due
      | _ -> None
  end

  type t = { sweep : Sweep.t; stopped : int; refused : int; stream_drops : int }

  let project fields =
    let reader = start fields in
    {
      sweep = required reader (enum Sweep.of_string) "sweep";
      stopped = required reader int "stopped";
      refused = required reader int "refused";
      stream_drops = required reader int "streamDrops";
    }

  let of_model (model : [ `FollowerFollowing ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("sweep", Some ((json_enum Sweep.to_string) value.sweep));
        ("stopped", Some (json_int value.stopped));
        ("refused", Some (json_int value.refused));
        ("streamDrops", Some (json_int value.stream_drops));
      ]

  let to_model value =
    Models.decode Models.follower_following
      (Yojson.Raw.to_string (to_json value))
end

module Janus_graph_config = struct
  module Type_ = struct
    type t = Janusgraph

    let to_string = function Janusgraph -> "janusgraph"
    let of_string = function "janusgraph" -> Some Janusgraph | _ -> None
  end

  type t = { type_ : Type_.t; host : string; port : int }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      host = required reader string "host";
      port = required reader int "port";
    }

  let of_model (model : [ `JanusGraphConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("host", Some (json_string value.host));
        ("port", Some (json_int value.port));
      ]

  let to_model value =
    Models.decode Models.janus_graph_config
      (Yojson.Raw.to_string (to_json value))
end

module Memory_graph_config = struct
  module Type_ = struct
    type t = Memory

    let to_string = function Memory -> "memory"
    let of_string = function "memory" -> Some Memory | _ -> None
  end

  type t = { type_ : Type_.t }

  let project fields =
    let reader = start fields in
    { type_ = required reader (enum Type_.of_string) "type" }

  let of_model (model : [ `MemoryGraphConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("type", Some ((json_enum Type_.to_string) value.type_)) ]

  let to_model value =
    Models.decode Models.memory_graph_config
      (Yojson.Raw.to_string (to_json value))
end

module Neo4j_graph_config = struct
  module Type_ = struct
    type t = Neo4j

    let to_string = function Neo4j -> "neo4j"
    let of_string = function "neo4j" -> Some Neo4j | _ -> None
  end

  type t = {
    type_ : Type_.t;
    uri : string;
    username : string;
    password_env : string;
    database : string;
  }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      uri = required reader string "uri";
      username = required reader string "username";
      password_env = required reader string "passwordEnv";
      database = required reader string "database";
    }

  let of_model (model : [ `Neo4jGraphConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("uri", Some (json_string value.uri));
        ("username", Some (json_string value.username));
        ("passwordEnv", Some (json_string value.password_env));
        ("database", Some (json_string value.database));
      ]

  let to_model value =
    Models.decode Models.neo4j_graph_config
      (Yojson.Raw.to_string (to_json value))
end

module Neptune_graph_config = struct
  module Type_ = struct
    type t = Neptune

    let to_string = function Neptune -> "neptune"
    let of_string = function "neptune" -> Some Neptune | _ -> None
  end

  type t = { type_ : Type_.t; endpoint : string; port : int }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      endpoint = required reader string "endpoint";
      port = required reader int "port";
    }

  let of_model (model : [ `NeptuneGraphConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("endpoint", Some (json_string value.endpoint));
        ("port", Some (json_int value.port));
      ]

  let to_model value =
    Models.decode Models.neptune_graph_config
      (Yojson.Raw.to_string (to_json value))
end

module Librarian_health = struct
  module Status = struct
    type t = Ok

    let to_string = function Ok -> "ok"
    let of_string = function "ok" -> Some Ok | _ -> None
  end

  module Actors = struct
    type t = Matcher | Gatherer

    let to_string = function Matcher -> "matcher" | Gatherer -> "gatherer"

    let of_string = function
      | "matcher" -> Some Matcher
      | "gatherer" -> Some Gatherer
      | _ -> None
  end

  type t = { status : Status.t; kb : string; actors : Actors.t list }

  let project fields =
    let reader = start fields in
    {
      status = required reader (enum Status.of_string) "status";
      kb = required reader string "kb";
      actors = required reader (list (enum Actors.of_string)) "actors";
    }

  let of_model (model : [ `LibrarianHealth ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("kb", Some (json_string value.kb));
        ("actors", Some ((json_list (json_enum Actors.to_string)) value.actors));
      ]

  let to_model value =
    Models.decode Models.librarian_health (Yojson.Raw.to_string (to_json value))
end

module Librarian_prompt_score = struct
  type t = { candidate : float; score : float }

  let project fields =
    let reader = start fields in
    {
      candidate = required reader float "candidate";
      score = required reader float "score";
    }

  let of_model (model : [ `LibrarianPromptScore ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("candidate", Some (json_float value.candidate));
        ("score", Some (json_float value.score));
      ]

  let to_model value =
    Models.decode Models.librarian_prompt_score
      (Yojson.Raw.to_string (to_json value))
end

module Client_secret_form = struct
  module Grant_type = struct
    type t = Grant_type

    let to_string = function Grant_type -> "client_credentials"

    let of_string = function
      | "client_credentials" -> Some Grant_type
      | _ -> None
  end

  type t = {
    grant_type : Grant_type.t;
    client_id : string;
    client_secret : string;
  }

  let project fields =
    let reader = start fields in
    {
      grant_type = required reader (enum Grant_type.of_string) "grant_type";
      client_id = required reader string "client_id";
      client_secret = required reader string "client_secret";
    }

  let of_model (model : [ `ClientSecretForm ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("grant_type", Some ((json_enum Grant_type.to_string) value.grant_type));
        ("client_id", Some (json_string value.client_id));
        ("client_secret", Some (json_string value.client_secret));
      ]

  let to_model value =
    Models.decode Models.client_secret_form
      (Yojson.Raw.to_string (to_json value))
end

module Open_resource = struct
  type t = {
    id : string;
    name : string;
    opened_at : int;
    order : int;
    media_type : string option;
    storage_uri : string option;
  }

  let project fields =
    let reader = start fields in
    {
      id = required reader string "id";
      name = required reader string "name";
      opened_at = required reader int "openedAt";
      order = required reader int "order";
      media_type = maybe reader string "mediaType";
      storage_uri = maybe reader string "storageUri";
    }

  let of_model (model : [ `OpenResource ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("name", Some (json_string value.name));
        ("openedAt", Some (json_int value.opened_at));
        ("order", Some (json_int value.order));
        ("mediaType", Option.map json_string value.media_type);
        ("storageUri", Option.map json_string value.storage_uri);
      ]

  let to_model value =
    Models.decode Models.open_resource (Yojson.Raw.to_string (to_json value))
end

module Smelter_chunking = struct
  type t = { chunk_size : int; overlap : int }

  let project fields =
    let reader = start fields in
    {
      chunk_size = required reader int "chunkSize";
      overlap = required reader int "overlap";
    }

  let of_model (model : [ `SmelterChunking ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("chunkSize", Some (json_int value.chunk_size));
        ("overlap", Some (json_int value.overlap));
      ]

  let to_model value =
    Models.decode Models.smelter_chunking (Yojson.Raw.to_string (to_json value))
end

module Smelter_reconcile_summary = struct
  type t = {
    resources_embedded : int;
    resources_skipped : (string * int) list;
    resources_unavailable : int;
    resources_failed : int;
    resources_restamped : int;
    resources_reanchored : int;
    resource_vectors_deleted : int;
    annotations_embedded : int;
    annotations_restamped : int;
    annotation_vectors_deleted : int;
    resources_eligible : int;
    resources_indexed : int;
  }

  let project fields =
    let reader = start fields in
    {
      resources_embedded = required reader int "resourcesEmbedded";
      resources_skipped = required reader (map int) "resourcesSkipped";
      resources_unavailable = required reader int "resourcesUnavailable";
      resources_failed = required reader int "resourcesFailed";
      resources_restamped = required reader int "resourcesRestamped";
      resources_reanchored = required reader int "resourcesReanchored";
      resource_vectors_deleted = required reader int "resourceVectorsDeleted";
      annotations_embedded = required reader int "annotationsEmbedded";
      annotations_restamped = required reader int "annotationsRestamped";
      annotation_vectors_deleted =
        required reader int "annotationVectorsDeleted";
      resources_eligible = required reader int "resourcesEligible";
      resources_indexed = required reader int "resourcesIndexed";
    }

  let of_model (model : [ `SmelterReconcileSummary ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourcesEmbedded", Some (json_int value.resources_embedded));
        ("resourcesSkipped", Some ((json_map json_int) value.resources_skipped));
        ("resourcesUnavailable", Some (json_int value.resources_unavailable));
        ("resourcesFailed", Some (json_int value.resources_failed));
        ("resourcesRestamped", Some (json_int value.resources_restamped));
        ("resourcesReanchored", Some (json_int value.resources_reanchored));
        ( "resourceVectorsDeleted",
          Some (json_int value.resource_vectors_deleted) );
        ("annotationsEmbedded", Some (json_int value.annotations_embedded));
        ("annotationsRestamped", Some (json_int value.annotations_restamped));
        ( "annotationVectorsDeleted",
          Some (json_int value.annotation_vectors_deleted) );
        ("resourcesEligible", Some (json_int value.resources_eligible));
        ("resourcesIndexed", Some (json_int value.resources_indexed));
      ]

  let to_model value =
    Models.decode Models.smelter_reconcile_summary
      (Yojson.Raw.to_string (to_json value))
end

module Host_port = struct
  type t = { host : string; port : int }

  let project fields =
    let reader = start fields in
    { host = required reader string "host"; port = required reader int "port" }

  let of_model (model : [ `HostPort ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("host", Some (json_string value.host));
        ("port", Some (json_int value.port));
      ]

  let to_model value =
    Models.decode Models.host_port (Yojson.Raw.to_string (to_json value))
end

module Metadata = struct
  type t = {
    name : string;
    namespace : string option;
    labels : (string * string) list option;
    annotations : (string * string) list option;
  }

  let project fields =
    let reader = start fields in
    {
      name = required reader string "name";
      namespace = maybe reader string "namespace";
      labels = maybe reader (map string) "labels";
      annotations = maybe reader (map string) "annotations";
    }

  let of_model (model : [ `Metadata ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("namespace", Option.map json_string value.namespace);
        ("labels", Option.map (json_map json_string) value.labels);
        ("annotations", Option.map (json_map json_string) value.annotations);
      ]

  let to_model value =
    Models.decode Models.metadata (Yojson.Raw.to_string (to_json value))
end

module Secret_ref = struct
  type t = { from_env : string }

  let project fields =
    let reader = start fields in
    { from_env = required reader string "fromEnv" }

  let of_model (model : [ `SecretRef ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("fromEnv", Some (json_string value.from_env)) ]

  let to_model value =
    Models.decode Models.secret_ref (Yojson.Raw.to_string (to_json value))
end

module Memory_vectors_config = struct
  module Type_ = struct
    type t = Memory

    let to_string = function Memory -> "memory"
    let of_string = function "memory" -> Some Memory | _ -> None
  end

  type t = { type_ : Type_.t }

  let project fields =
    let reader = start fields in
    { type_ = required reader (enum Type_.of_string) "type" }

  let of_model (model : [ `MemoryVectorsConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("type", Some ((json_enum Type_.to_string) value.type_)) ]

  let to_model value =
    Models.decode Models.memory_vectors_config
      (Yojson.Raw.to_string (to_json value))
end

module Qdrant_vectors_config = struct
  module Type_ = struct
    type t = Qdrant

    let to_string = function Qdrant -> "qdrant"
    let of_string = function "qdrant" -> Some Qdrant | _ -> None
  end

  type t = { type_ : Type_.t; host : string; port : int; token_env : string }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      host = required reader string "host";
      port = required reader int "port";
      token_env = required reader string "tokenEnv";
    }

  let of_model (model : [ `QdrantVectorsConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("host", Some (json_string value.host));
        ("port", Some (json_int value.port));
        ("tokenEnv", Some (json_string value.token_env));
      ]

  let to_model value =
    Models.decode Models.qdrant_vectors_config
      (Yojson.Raw.to_string (to_json value))
end

module Worker_active_job = struct
  type t = { job_id : string; type_ : Enums.Job_type.t; since : string }

  let project fields =
    let reader = start fields in
    {
      job_id = required reader string "jobId";
      type_ = required reader (enum Enums.Job_type.of_string) "type";
      since = required reader string "since";
    }

  let of_model (model : [ `WorkerActiveJob ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("jobId", Some (json_string value.job_id));
        ("type", Some ((json_enum Enums.Job_type.to_string) value.type_));
        ("since", Some (json_string value.since));
      ]

  let to_model value =
    Models.decode Models.worker_active_job
      (Yojson.Raw.to_string (to_json value))
end

module Mark_job_filter_params = struct
  type t = { motivation : Enums.Motivation.t }

  let project fields =
    let reader = start fields in
    {
      motivation =
        required reader (enum Enums.Motivation.of_string) "motivation";
    }

  let to_json (value : t) =
    write
      [
        ( "motivation",
          Some ((json_enum Enums.Motivation.to_string) value.motivation) );
      ]
end

module Resource_descriptor_context_item = struct
  type t = Text of string | Object of (string * Yojson.Raw.t) list

  let members =
    [
      [
        {
          kind = Text_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> Text (string value)
    | 1 -> Object ((map raw) value)
    | _ -> assert false

  let to_json = function
    | Text value -> json_string value
    | Object value -> (json_map json_raw) value
end

module One_or_more_strings = struct
  type t = Text of string | List of string list

  let members =
    [
      [
        {
          kind = Text_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = List_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> Text (string value)
    | 1 -> List ((list string) value)
    | _ -> assert false

  let of_model (model : [ `OneOrMoreStrings ] Models.t) =
    read (Models.json model)

  let to_json = function
    | Text value -> json_string value
    | List value -> (json_list json_string) value

  let to_model value =
    Models.decode Models.one_or_more_strings
      (Yojson.Raw.to_string (to_json value))
end

module Resource_descriptor_identifier_object = struct
  type t = {
    field_id : string option;
    value : string option;
    scheme : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_id = maybe reader string "@id";
        value = maybe reader string "value";
        scheme = maybe reader string "scheme";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let to_json (value : t) =
    write_open
      [
        ("@id", Option.map json_string value.field_id);
        ("value", Option.map json_string value.value);
        ("scheme", Option.map json_string value.scheme);
      ]
      value.extra
end

module Resource_descriptor_was_derived_from = struct
  type t = ResourceId of string | List of string list

  let members =
    [
      [
        {
          kind = Text_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = List_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> ResourceId (string value)
    | 1 -> List ((list string) value)
    | _ -> assert false

  let to_json = function
    | ResourceId value -> json_string value
    | List value -> (json_list json_string) value
end

module One_or_more_uris = struct
  type t = Text of string | List of string list

  let members =
    [
      [
        {
          kind = Text_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = List_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> Text (string value)
    | 1 -> List ((list string) value)
    | _ -> assert false

  let of_model (model : [ `OneOrMoreUris ] Models.t) = read (Models.json model)

  let to_json = function
    | Text value -> json_string value
    | List value -> (json_list json_string) value

  let to_model value =
    Models.decode Models.one_or_more_uris (Yojson.Raw.to_string (to_json value))
end

module Bus_subscribe_request_scoped_item = struct
  type t = {
    scope : string;
    channels : string list;
    last_event_id : string option;
  }

  let project fields =
    let reader = start fields in
    {
      scope = required reader string "scope";
      channels = required reader (list string) "channels";
      last_event_id = maybe reader string "lastEventId";
    }

  let to_json (value : t) =
    write
      [
        ("scope", Some (json_string value.scope));
        ("channels", Some ((json_list json_string) value.channels));
        ("lastEventId", Option.map json_string value.last_event_id);
      ]
end

module Contextual_summary_response_relevant_fields = struct
  type t = {
    resource_id : string;
    resource_name : string;
    entity_types : string list;
  }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      resource_name = required reader string "resourceName";
      entity_types = required reader (list string) "entityTypes";
    }

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("resourceName", Some (json_string value.resource_name));
        ("entityTypes", Some ((json_list json_string) value.entity_types));
      ]
end

module Contextual_summary_response_context = struct
  type t = { before : string option; selected : string; after : string option }

  let project fields =
    let reader = start fields in
    {
      before = maybe reader string "before";
      selected = required reader string "selected";
      after = maybe reader string "after";
    }

  let to_json (value : t) =
    write
      [
        ("before", Option.map json_string value.before);
        ("selected", Some (json_string value.selected));
        ("after", Option.map json_string value.after);
      ]
end

module Gathered_context_focus_annotation_selected = struct
  type t = { before : string option; text : string; after : string option }

  let project fields =
    let reader = start fields in
    {
      before = maybe reader string "before";
      text = required reader string "text";
      after = maybe reader string "after";
    }

  let to_json (value : t) =
    write
      [
        ("before", Option.map json_string value.before);
        ("text", Some (json_string value.text));
        ("after", Option.map json_string value.after);
      ]
end

module Gathered_context_focus_annotation_target_context = struct
  type t = { content : string; summary : string option }

  let project fields =
    let reader = start fields in
    {
      content = required reader string "content";
      summary = maybe reader string "summary";
    }

  let to_json (value : t) =
    write
      [
        ("content", Some (json_string value.content));
        ("summary", Option.map json_string value.summary);
      ]
end

module Gathered_context_focus_resource_content = struct
  type t = { main : string option; related : (string * string) list option }

  let project fields =
    let reader = start fields in
    {
      main = maybe reader string "main";
      related = maybe reader (map string) "related";
    }

  let to_json (value : t) =
    write
      [
        ("main", Option.map json_string value.main);
        ("related", Option.map (json_map json_string) value.related);
      ]
end

module Knowledge_graph_edges_item = struct
  type t = {
    source : string;
    target : string;
    type_ : string;
    bidirectional : bool option;
    metadata : (string * Yojson.Raw.t) list option;
  }

  let project fields =
    let reader = start fields in
    {
      source = required reader string "source";
      target = required reader string "target";
      type_ = required reader string "type";
      bidirectional = maybe reader bool "bidirectional";
      metadata = maybe reader (map raw) "metadata";
    }

  let to_json (value : t) =
    write
      [
        ("source", Some (json_string value.source));
        ("target", Some (json_string value.target));
        ("type", Some (json_string value.type_));
        ("bidirectional", Option.map json_bool value.bidirectional);
        ("metadata", Option.map (json_map json_raw) value.metadata);
      ]
end

module Gathered_context_metadata = struct
  type t = {
    resource_type : string option;
    language : string option;
    entity_types : string list option;
    entity_type_frequencies : (string * int) list option;
  }

  let project fields =
    let reader = start fields in
    {
      resource_type = maybe reader string "resourceType";
      language = maybe reader string "language";
      entity_types = maybe reader (list string) "entityTypes";
      entity_type_frequencies = maybe reader (map int) "entityTypeFrequencies";
    }

  let to_json (value : t) =
    write
      [
        ("resourceType", Option.map json_string value.resource_type);
        ("language", Option.map json_string value.language);
        ("entityTypes", Option.map (json_list json_string) value.entity_types);
        ( "entityTypeFrequencies",
          Option.map (json_map json_int) value.entity_type_frequencies );
      ]
end

module Get_referenced_by_response_referenced_by_item_target_selector = struct
  type t = { exact : string }

  let project fields =
    let reader = start fields in
    { exact = required reader string "exact" }

  let to_json (value : t) = write [ ("exact", Some (json_string value.exact)) ]
end

module Job_progress_current = struct
  module Kind = struct
    type t = Entity_type | Category

    let to_string = function
      | Entity_type -> "entity-type"
      | Category -> "category"

    let of_string = function
      | "entity-type" -> Some Entity_type
      | "category" -> Some Category
      | _ -> None
  end

  type t = { kind : Kind.t; value : string }

  let project fields =
    let reader = start fields in
    {
      kind = required reader (enum Kind.of_string) "kind";
      value = required reader string "value";
    }

  let to_json (value : t) =
    write
      [
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("value", Some (json_string value.value));
      ]
end

module Job_progress_completed_items_item_under_reported = struct
  type t = { pieces : int; found : int; counted : int }

  let project fields =
    let reader = start fields in
    {
      pieces = required reader int "pieces";
      found = required reader int "found";
      counted = required reader int "counted";
    }

  let to_json (value : t) =
    write
      [
        ("pieces", Some (json_int value.pieces));
        ("found", Some (json_int value.found));
        ("counted", Some (json_int value.counted));
      ]
end

module Job_progress_request_params_item = struct
  module Label = struct
    type t = Entity_types | Instructions | Tone | Density

    let to_string = function
      | Entity_types -> "entity-types"
      | Instructions -> "instructions"
      | Tone -> "tone"
      | Density -> "density"

    let of_string = function
      | "entity-types" -> Some Entity_types
      | "instructions" -> Some Instructions
      | "tone" -> Some Tone
      | "density" -> Some Density
      | _ -> None
  end

  type t = { label : Label.t; value : string }

  let project fields =
    let reader = start fields in
    {
      label = required reader (enum Label.of_string) "label";
      value = required reader string "value";
    }

  let to_json (value : t) =
    write
      [
        ("label", Some ((json_enum Label.to_string) value.label));
        ("value", Some (json_string value.value));
      ]
end

module Mark_commit_ok_response = struct
  type t = { persisted : int; annotation_ids : string list }

  let project fields =
    let reader = start fields in
    {
      persisted = required reader int "persisted";
      annotation_ids = required reader (list string) "annotationIds";
    }

  let to_json (value : t) =
    write
      [
        ("persisted", Some (json_int value.persisted));
        ("annotationIds", Some ((json_list json_string) value.annotation_ids));
      ]
end

module Mark_delete_ok_response = struct
  type t = { annotation_id : string }

  let project fields =
    let reader = start fields in
    { annotation_id = required reader string "annotationId" }

  let to_json (value : t) =
    write [ ("annotationId", Some (json_string value.annotation_id)) ]
end

module Resource_created_payload_generated_from = struct
  type t = { resource_id : string; annotation_id : string option }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      annotation_id = maybe reader string "annotationId";
    }

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("annotationId", Option.map json_string value.annotation_id);
      ]
end

module Status_response_features = struct
  type t = { semantic_content : string; collaboration : string }

  let project fields =
    let reader = start fields in
    {
      semantic_content = required reader string "semanticContent";
      collaboration = required reader string "collaboration";
    }

  let to_json (value : t) =
    write
      [
        ("semanticContent", Some (json_string value.semantic_content));
        ("collaboration", Some (json_string value.collaboration));
      ]
end

module Yield_create_command_generated_from = struct
  type t = { resource_id : string option; annotation_id : string option }

  let project fields =
    let reader = start fields in
    {
      resource_id = maybe reader string "resourceId";
      annotation_id = maybe reader string "annotationId";
    }

  let to_json (value : t) =
    write
      [
        ("resourceId", Option.map json_string value.resource_id);
        ("annotationId", Option.map json_string value.annotation_id);
      ]
end

module Anchored_text_extracted_entry_lines_item = struct
  type t = { p : int; y : float; h : float; words : float list list }

  let project fields =
    let reader = start fields in
    {
      p = required reader int "p";
      y = required reader float "y";
      h = required reader float "h";
      words = required reader (list (list float)) "words";
    }

  let to_json (value : t) =
    write
      [
        ("p", Some (json_int value.p));
        ("y", Some (json_float value.y));
        ("h", Some (json_float value.h));
        ("words", Some ((json_list (json_list json_float)) value.words));
      ]
end

module Archivist_config_staging = struct
  type t = { flush_ms : int; max_wait_ms : int }

  let project fields =
    let reader = start fields in
    {
      flush_ms = required reader int "flushMs";
      max_wait_ms = required reader int "maxWaitMs";
    }

  let to_json (value : t) =
    write
      [
        ("flushMs", Some (json_int value.flush_ms));
        ("maxWaitMs", Some (json_int value.max_wait_ms));
      ]
end

module Conformance_step_let = struct
  type t = { let_ : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    { let_ = required reader (map raw) "let" }

  let to_json (value : t) =
    write [ ("let", Some ((json_map json_raw) value.let_)) ]
end

module Conformance_step_driver = struct
  type t = {
    driver : string;
    with_ : (string * Yojson.Raw.t) list option;
    returns : Yojson.Raw.t Types.presence;
    fails : Yojson.Raw.t Types.presence;
    as_ : string option;
  }

  let project fields =
    let reader = start fields in
    {
      driver = required reader string "driver";
      with_ = maybe reader (map raw) "with";
      returns = optional reader raw "returns";
      fails = optional reader raw "fails";
      as_ = maybe reader string "as";
    }

  let to_json (value : t) =
    write
      [
        ("driver", Some (json_string value.driver));
        ("with", Option.map (json_map json_raw) value.with_);
        ("returns", present json_raw value.returns);
        ("fails", present json_raw value.fails);
        ("as", Option.map json_string value.as_);
      ]
end

module Conformance_step_abandon = struct
  type t = { abandon : string }

  let project fields =
    let reader = start fields in
    { abandon = required reader string "abandon" }

  let to_json (value : t) =
    write [ ("abandon", Some (json_string value.abandon)) ]
end

module Conformance_step_settles = struct
  type t = {
    settles : string;
    returns : Yojson.Raw.t Types.presence;
    fails : Yojson.Raw.t Types.presence;
    abandoned : bool option;
  }

  let project fields =
    let reader = start fields in
    {
      settles = required reader string "settles";
      returns = optional reader raw "returns";
      fails = optional reader raw "fails";
      abandoned = maybe reader bool "abandoned";
    }

  let to_json (value : t) =
    write
      [
        ("settles", Some (json_string value.settles));
        ("returns", present json_raw value.returns);
        ("fails", present json_raw value.fails);
        ("abandoned", Option.map json_bool value.abandoned);
      ]
end

module Conformance_step_wire = struct
  module At = struct
    type t = Arrival | Answer | Live

    let to_string = function
      | Arrival -> "arrival"
      | Answer -> "answer"
      | Live -> "live"

    let of_string = function
      | "arrival" -> Some Arrival
      | "answer" -> Some Answer
      | "live" -> Some Live
      | _ -> None
  end

  type t = {
    wire : string;
    at : At.t option;
    status : int option;
    params : Yojson.Raw.t Types.presence;
    body : Yojson.Raw.t Types.presence;
    token : Yojson.Raw.t Types.presence;
    headers : (string * Yojson.Raw.t) list option;
    answer : Yojson.Raw.t Types.presence;
    as_ : string option;
    follows : string option;
    waited : string option;
  }

  let project fields =
    let reader = start fields in
    {
      wire = required reader string "wire";
      at = maybe reader (enum At.of_string) "at";
      status = maybe reader int "status";
      params = optional reader raw "params";
      body = optional reader raw "body";
      token = optional reader raw "token";
      headers = maybe reader (map raw) "headers";
      answer = optional reader raw "answer";
      as_ = maybe reader string "as";
      follows = maybe reader string "follows";
      waited = maybe reader string "waited";
    }

  let to_json (value : t) =
    write
      [
        ("wire", Some (json_string value.wire));
        ("at", Option.map (json_enum At.to_string) value.at);
        ("status", Option.map json_int value.status);
        ("params", present json_raw value.params);
        ("body", present json_raw value.body);
        ("token", present json_raw value.token);
        ("headers", Option.map (json_map json_raw) value.headers);
        ("answer", present json_raw value.answer);
        ("as", Option.map json_string value.as_);
        ("follows", Option.map json_string value.follows);
        ("waited", Option.map json_string value.waited);
      ]
end

module Conformance_step_carried = struct
  type t = { carried : string; is : Yojson.Raw.t }

  let project fields =
    let reader = start fields in
    {
      carried = required reader string "carried";
      is = required reader raw "is";
    }

  let to_json (value : t) =
    write
      [
        ("carried", Some (json_string value.carried));
        ("is", Some (json_raw value.is));
      ]
end

module Conformance_step_closed = struct
  type t = { closed : string }

  let project fields =
    let reader = start fields in
    { closed = required reader string "closed" }

  let to_json (value : t) =
    write [ ("closed", Some (json_string value.closed)) ]
end

module Conformance_step_progress = struct
  type t = { progress : string }

  let project fields =
    let reader = start fields in
    { progress = required reader string "progress" }

  let to_json (value : t) =
    write [ ("progress", Some (json_string value.progress)) ]
end

module Conformance_step_state = struct
  type t = { state : Enums.Connection_state.t }

  let project fields =
    let reader = start fields in
    { state = required reader (enum Enums.Connection_state.of_string) "state" }

  let to_json (value : t) =
    write
      [
        ( "state",
          Some ((json_enum Enums.Connection_state.to_string) value.state) );
      ]
end

module Conformance_step_stays = struct
  type t = { stays : Enums.Connection_state.t }

  let project fields =
    let reader = start fields in
    { stays = required reader (enum Enums.Connection_state.of_string) "stays" }

  let to_json (value : t) =
    write
      [
        ( "stays",
          Some ((json_enum Enums.Connection_state.to_string) value.stays) );
      ]
end

module Conformance_step_frame = struct
  type t = { frame : string; is : Yojson.Raw.t }

  let project fields =
    let reader = start fields in
    { frame = required reader string "frame"; is = required reader raw "is" }

  let to_json (value : t) =
    write
      [
        ("frame", Some (json_string value.frame));
        ("is", Some (json_raw value.is));
      ]
end

module Conformance_step_frames = struct
  type t = { frames : string; count : int }

  let project fields =
    let reader = start fields in
    {
      frames = required reader string "frames";
      count = required reader int "count";
    }

  let to_json (value : t) =
    write
      [
        ("frames", Some (json_string value.frames));
        ("count", Some (json_int value.count));
      ]
end

module Conformance_step_error = struct
  type t = { error : Yojson.Raw.t }

  let project fields =
    let reader = start fields in
    { error = required reader raw "error" }

  let to_json (value : t) = write [ ("error", Some (json_raw value.error)) ]
end

module Conformance_step_backend = struct
  module Backend = struct
    type t =
      | Listen
      | Emit
      | Record
      | Content
      | Description
      | Annotations
      | Anchored_text
      | Uploaded
      | Refuse
      | Unanswered
      | Answer_lost
      | Hold
      | Release
      | Rechunk
      | Carry
      | Cut
      | Down
      | Up
      | Archivist

    let to_string = function
      | Listen -> "listen"
      | Emit -> "emit"
      | Record -> "record"
      | Content -> "content"
      | Description -> "description"
      | Annotations -> "annotations"
      | Anchored_text -> "anchored-text"
      | Uploaded -> "uploaded"
      | Refuse -> "refuse"
      | Unanswered -> "unanswered"
      | Answer_lost -> "answer-lost"
      | Hold -> "hold"
      | Release -> "release"
      | Rechunk -> "rechunk"
      | Carry -> "carry"
      | Cut -> "cut"
      | Down -> "down"
      | Up -> "up"
      | Archivist -> "archivist"

    let of_string = function
      | "listen" -> Some Listen
      | "emit" -> Some Emit
      | "record" -> Some Record
      | "content" -> Some Content
      | "description" -> Some Description
      | "annotations" -> Some Annotations
      | "anchored-text" -> Some Anchored_text
      | "uploaded" -> Some Uploaded
      | "refuse" -> Some Refuse
      | "unanswered" -> Some Unanswered
      | "answer-lost" -> Some Answer_lost
      | "hold" -> Some Hold
      | "release" -> Some Release
      | "rechunk" -> Some Rechunk
      | "carry" -> Some Carry
      | "cut" -> Some Cut
      | "down" -> Some Down
      | "up" -> Some Up
      | "archivist" -> Some Archivist
      | _ -> None
  end

  type t = { backend : Backend.t; with_ : (string * Yojson.Raw.t) list option }

  let project fields =
    let reader = start fields in
    {
      backend = required reader (enum Backend.of_string) "backend";
      with_ = maybe reader (map raw) "with";
    }

  let to_json (value : t) =
    write
      [
        ("backend", Some ((json_enum Backend.to_string) value.backend));
        ("with", Option.map (json_map json_raw) value.with_);
      ]
end

module Conformance_step_quiet = struct
  type t = { quiet : int }

  let project fields =
    let reader = start fields in
    { quiet = required reader int "quiet" }

  let to_json (value : t) = write [ ("quiet", Some (json_int value.quiet)) ]
end

module Conformance_step_observe_observe = struct
  type t = {
    query : string;
    resource : Yojson.Raw.t Types.presence;
    annotation : Yojson.Raw.t Types.presence;
    search : Yojson.Raw.t Types.presence;
    filters : Yojson.Raw.t Types.presence;
  }

  let project fields =
    let reader = start fields in
    {
      query = required reader string "query";
      resource = optional reader raw "resource";
      annotation = optional reader raw "annotation";
      search = optional reader raw "search";
      filters = optional reader raw "filters";
    }

  let to_json (value : t) =
    write
      [
        ("query", Some (json_string value.query));
        ("resource", present json_raw value.resource);
        ("annotation", present json_raw value.annotation);
        ("search", present json_raw value.search);
        ("filters", present json_raw value.filters);
      ]
end

module Conformance_step_leave = struct
  type t = { leave : string }

  let project fields =
    let reader = start fields in
    { leave = required reader string "leave" }

  let to_json (value : t) = write [ ("leave", Some (json_string value.leave)) ]
end

module Conformance_step_reaches = struct
  type t = { reaches : string; state : Yojson.Raw.t }

  let project fields =
    let reader = start fields in
    {
      reaches = required reader string "reaches";
      state = required reader raw "state";
    }

  let to_json (value : t) =
    write
      [
        ("reaches", Some (json_string value.reaches));
        ("state", Some (json_raw value.state));
      ]
end

module Conformance_step_holds = struct
  type t = { holds : string; state : Yojson.Raw.t }

  let project fields =
    let reader = start fields in
    {
      holds = required reader string "holds";
      state = required reader raw "state";
    }

  let to_json (value : t) =
    write
      [
        ("holds", Some (json_string value.holds));
        ("state", Some (json_raw value.state));
      ]
end

module Conformance_step_completes = struct
  type t = { completes : string }

  let project fields =
    let reader = start fields in
    { completes = required reader string "completes" }

  let to_json (value : t) =
    write [ ("completes", Some (json_string value.completes)) ]
end

module Conformance_step_scopes = struct
  type t = { scopes : Yojson.Raw.t list }

  let project fields =
    let reader = start fields in
    { scopes = required reader (list raw) "scopes" }

  let to_json (value : t) =
    write [ ("scopes", Some ((json_list json_raw) value.scopes)) ]
end

module Conformance_step_claimed = struct
  type t = { claimed : Yojson.Raw.t }

  let project fields =
    let reader = start fields in
    { claimed = required reader raw "claimed" }

  let to_json (value : t) = write [ ("claimed", Some (json_raw value.claimed)) ]
end

module Conformance_step_refused = struct
  type t = { refused : Yojson.Raw.t }

  let project fields =
    let reader = start fields in
    { refused = required reader raw "refused" }

  let to_json (value : t) = write [ ("refused", Some (json_raw value.refused)) ]
end

module Conformance_step_signalled = struct
  type t = { signalled : Yojson.Raw.t }

  let project fields =
    let reader = start fields in
    { signalled = required reader raw "signalled" }

  let to_json (value : t) =
    write [ ("signalled", Some (json_raw value.signalled)) ]
end

module Conformance_step_stalled = struct
  type t = { stalled : Yojson.Raw.t }

  let project fields =
    let reader = start fields in
    { stalled = required reader raw "stalled" }

  let to_json (value : t) = write [ ("stalled", Some (json_raw value.stalled)) ]
end

module Conformance_implementations_sdks_value_live = struct
  module Tier = struct
    type t = Fleet | Parity

    let to_string = function Fleet -> "fleet" | Parity -> "parity"

    let of_string = function
      | "fleet" -> Some Fleet
      | "parity" -> Some Parity
      | _ -> None
  end

  type t = { command : string list; tier : Tier.t }

  let project fields =
    let reader = start fields in
    {
      command = required reader (list string) "command";
      tier = required reader (enum Tier.of_string) "tier";
    }

  let to_json (value : t) =
    write
      [
        ("command", Some ((json_list json_string) value.command));
        ("tier", Some ((json_enum Tier.to_string) value.tier));
      ]
end

module Request_id = struct
  type t = Text of string | Integer of int

  let members =
    [
      [
        {
          kind = Text_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Integer_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> Text (string value)
    | 1 -> Integer (int value)
    | _ -> assert false

  let of_model (model : [ `RequestId ] Models.t) = read (Models.json model)

  let to_json = function
    | Text value -> json_string value
    | Integer value -> json_int value

  let to_model value =
    Models.decode Models.request_id (Yojson.Raw.to_string (to_json value))
end

module Workload_status_ledger = struct
  type t = { claims : int; capacity : int }

  let project fields =
    let reader = start fields in
    {
      claims = required reader int "claims";
      capacity = required reader int "capacity";
    }

  let to_json (value : t) =
    write
      [
        ("claims", Some (json_int value.claims));
        ("capacity", Some (json_int value.capacity));
      ]
end

module Workload_status_queue = struct
  type t = {
    pending : int;
    running : int;
    completed : int option;
    failed : int option;
  }

  let project fields =
    let reader = start fields in
    {
      pending = required reader int "pending";
      running = required reader int "running";
      completed = maybe reader int "completed";
      failed = maybe reader int "failed";
    }

  let to_json (value : t) =
    write
      [
        ("pending", Some (json_int value.pending));
        ("running", Some (json_int value.running));
        ("completed", Option.map json_int value.completed);
        ("failed", Option.map json_int value.failed);
      ]
end

module Dispatcher_config_queue = struct
  type t = {
    servers : string;
    user_env : string option;
    password_env : string option;
  }

  let project fields =
    let reader = start fields in
    {
      servers = required reader string "servers";
      user_env = maybe reader string "userEnv";
      password_env = maybe reader string "passwordEnv";
    }

  let to_json (value : t) =
    write
      [
        ("servers", Some (json_string value.servers));
        ("userEnv", Option.map json_string value.user_env);
        ("passwordEnv", Option.map json_string value.password_env);
      ]
end

module Dispatcher_config_timing = struct
  type t = {
    tick_ms : int;
    stale_running_ms : int;
    ack_wait_ms : int;
    retention_ms : int;
    retention_sweep_ms : int;
    progress_write_interval_ms : int;
    boot_deadline_ms : int;
  }

  let project fields =
    let reader = start fields in
    {
      tick_ms = required reader int "tickMs";
      stale_running_ms = required reader int "staleRunningMs";
      ack_wait_ms = required reader int "ackWaitMs";
      retention_ms = required reader int "retentionMs";
      retention_sweep_ms = required reader int "retentionSweepMs";
      progress_write_interval_ms = required reader int "progressWriteIntervalMs";
      boot_deadline_ms = required reader int "bootDeadlineMs";
    }

  let to_json (value : t) =
    write
      [
        ("tickMs", Some (json_int value.tick_ms));
        ("staleRunningMs", Some (json_int value.stale_running_ms));
        ("ackWaitMs", Some (json_int value.ack_wait_ms));
        ("retentionMs", Some (json_int value.retention_ms));
        ("retentionSweepMs", Some (json_int value.retention_sweep_ms));
        ( "progressWriteIntervalMs",
          Some (json_int value.progress_write_interval_ms) );
        ("bootDeadlineMs", Some (json_int value.boot_deadline_ms));
      ]
end

module Gateway_config_identity = struct
  type t = { issuer : string; subject_claim : string }

  let project fields =
    let reader = start fields in
    {
      issuer = required reader string "issuer";
      subject_claim = required reader string "subjectClaim";
    }

  let to_json (value : t) =
    write
      [
        ("issuer", Some (json_string value.issuer));
        ("subjectClaim", Some (json_string value.subject_claim));
      ]
end

module Gateway_config_signal = struct
  module Type_ = struct
    type t = In_process | Nats

    let to_string = function In_process -> "in-process" | Nats -> "nats"

    let of_string = function
      | "in-process" -> Some In_process
      | "nats" -> Some Nats
      | _ -> None
  end

  type t = {
    type_ : Type_.t;
    servers : string option;
    user_env : string option;
    password_env : string option;
  }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader (enum Type_.of_string) "type";
      servers = maybe reader string "servers";
      user_env = maybe reader string "userEnv";
      password_env = maybe reader string "passwordEnv";
    }

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("servers", Option.map json_string value.servers);
        ("userEnv", Option.map json_string value.user_env);
        ("passwordEnv", Option.map json_string value.password_env);
      ]
end

module Gateway_config_capacity = struct
  type t = { queued_bytes : int; connections : int }

  let project fields =
    let reader = start fields in
    {
      queued_bytes = required reader int "queuedBytes";
      connections = required reader int "connections";
    }

  let to_json (value : t) =
    write
      [
        ("queuedBytes", Some (json_int value.queued_bytes));
        ("connections", Some (json_int value.connections));
      ]
end

module Project_config_project = struct
  type t = { name : string; version : string option }

  let project fields =
    let reader = start fields in
    {
      name = required reader string "name";
      version = maybe reader string "version";
    }

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("version", Option.map json_string value.version);
      ]
end

module Project_config_git = struct
  type t = { sync : bool }

  let project fields =
    let reader = start fields in
    { sync = required reader bool "sync" }

  let to_json (value : t) = write [ ("sync", Some (json_bool value.sync)) ]
end

module Project_config_site = struct
  type t = { domain : string; site_name : string }

  let project fields =
    let reader = start fields in
    {
      domain = required reader string "domain";
      site_name = required reader string "siteName";
    }

  let to_json (value : t) =
    write
      [
        ("domain", Some (json_string value.domain));
        ("siteName", Some (json_string value.site_name));
      ]
end

module Librarian_config_gather = struct
  type t = { settle_timeout_ms : int }

  let project fields =
    let reader = start fields in
    { settle_timeout_ms = required reader int "settleTimeoutMs" }

  let to_json (value : t) =
    write [ ("settleTimeoutMs", Some (json_int value.settle_timeout_ms)) ]
end

module Librarian_config_search = struct
  type t = { semantic_floor : float }

  let project fields =
    let reader = start fields in
    { semantic_floor = required reader float "semanticFloor" }

  let to_json (value : t) =
    write [ ("semanticFloor", Some (json_float value.semantic_floor)) ]
end

module Smelter_health_index_stamp_embedding = struct
  type t = { type_ : string; model : string }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader string "type";
      model = required reader string "model";
    }

  let to_json (value : t) =
    write
      [
        ("type", Some (json_string value.type_));
        ("model", Some (json_string value.model));
      ]
end

module Resources_limits = struct
  type t = { memory : string }

  let project fields =
    let reader = start fields in
    { memory = required reader string "memory" }

  let to_json (value : t) =
    write [ ("memory", Some (json_string value.memory)) ]
end

module Knowledge_index_spec_embedding_chunking = struct
  type t = { chunk_size : int; overlap : int }

  let project fields =
    let reader = start fields in
    {
      chunk_size = required reader int "chunkSize";
      overlap = required reader int "overlap";
    }

  let to_json (value : t) =
    write
      [
        ("chunkSize", Some (json_int value.chunk_size));
        ("overlap", Some (json_int value.overlap));
      ]
end

module Knowledge_index_spec_librarian_gather = struct
  type t = { settle_timeout_ms : int }

  let project fields =
    let reader = start fields in
    { settle_timeout_ms = required reader int "settleTimeoutMs" }

  let to_json (value : t) =
    write [ ("settleTimeoutMs", Some (json_int value.settle_timeout_ms)) ]
end

module Knowledge_index_spec_librarian_search = struct
  type t = { semantic_floor : float }

  let project fields =
    let reader = start fields in
    { semantic_floor = required reader float "semanticFloor" }

  let to_json (value : t) =
    write [ ("semanticFloor", Some (json_float value.semantic_floor)) ]
end

module Stack_knowledge_base_spec_messaging_jobs = struct
  type t = { type_ : string }

  let project fields =
    let reader = start fields in
    { type_ = required reader string "type" }

  let to_json (value : t) = write [ ("type", Some (json_string value.type_)) ]
end

module Stack_knowledge_base_spec_messaging_signal = struct
  type t = { type_ : string }

  let project fields =
    let reader = start fields in
    { type_ = required reader string "type" }

  let to_json (value : t) = write [ ("type", Some (json_string value.type_)) ]
end

module Stack_knowledge_base_spec_issuer_shared = struct
  type t = { access_token_lifespan : int }

  let project fields =
    let reader = start fields in
    { access_token_lifespan = required reader int "accessTokenLifespan" }

  let to_json (value : t) =
    write
      [ ("accessTokenLifespan", Some (json_int value.access_token_lifespan)) ]
end

module Stack_knowledge_base_spec_issuer_external = struct
  type t = { type_ : string; url : string }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader string "type";
      url = required reader string "url";
    }

  let to_json (value : t) =
    write
      [
        ("type", Some (json_string value.type_));
        ("url", Some (json_string value.url));
      ]
end

module Weaver_health_reconcile_summary = struct
  type t = {
    resources_checked : int;
    divergent : int;
    healed : int;
    heal_failures : int;
    orphaned : int;
  }

  let project fields =
    let reader = start fields in
    {
      resources_checked = required reader int "resourcesChecked";
      divergent = required reader int "divergent";
      healed = required reader int "healed";
      heal_failures = required reader int "healFailures";
      orphaned = required reader int "orphaned";
    }

  let to_json (value : t) =
    write
      [
        ("resourcesChecked", Some (json_int value.resources_checked));
        ("divergent", Some (json_int value.divergent));
        ("healed", Some (json_int value.healed));
        ("healFailures", Some (json_int value.heal_failures));
        ("orphaned", Some (json_int value.orphaned));
      ]
end

module Worker_knowledge_base_config_identity = struct
  type t = { issuer : string; client_id : string }

  let project fields =
    let reader = start fields in
    {
      issuer = required reader string "issuer";
      client_id = required reader string "clientId";
    }

  let to_json (value : t) =
    write
      [
        ("issuer", Some (json_string value.issuer));
        ("clientId", Some (json_string value.client_id));
      ]
end

module Conformance_driver_line_ready = struct
  type t = { ready : bool }

  let project fields =
    let reader = start fields in
    { ready = required reader bool "ready" }

  let to_json (value : t) = write [ ("ready", Some (json_bool value.ready)) ]
end

module Conformance_driver_line_ok = struct
  type t = { id : int; ok : Yojson.Raw.t }

  let project fields =
    let reader = start fields in
    { id = required reader int "id"; ok = required reader raw "ok" }

  let to_json (value : t) =
    write [ ("id", Some (json_int value.id)); ("ok", Some (json_raw value.ok)) ]
end

module Conformance_driver_line_abandoned = struct
  type t = { id : int; abandoned : bool }

  let project fields =
    let reader = start fields in
    {
      id = required reader int "id";
      abandoned = required reader bool "abandoned";
    }

  let to_json (value : t) =
    write
      [
        ("id", Some (json_int value.id));
        ("abandoned", Some (json_bool value.abandoned));
      ]
end

module Conformance_driver_line_unsupported = struct
  type t = { id : int; unsupported : bool }

  let project fields =
    let reader = start fields in
    {
      id = required reader int "id";
      unsupported = required reader bool "unsupported";
    }

  let to_json (value : t) =
    write
      [
        ("id", Some (json_int value.id));
        ("unsupported", Some (json_bool value.unsupported));
      ]
end

module Conformance_driver_line_misuse = struct
  type t = { id : int; misuse : string }

  let project fields =
    let reader = start fields in
    { id = required reader int "id"; misuse = required reader string "misuse" }

  let to_json (value : t) =
    write
      [
        ("id", Some (json_int value.id));
        ("misuse", Some (json_string value.misuse));
      ]
end

module Conformance_driver_line_state = struct
  type t = { state : string }

  let project fields =
    let reader = start fields in
    { state = required reader string "state" }

  let to_json (value : t) = write [ ("state", Some (json_string value.state)) ]
end

module Conformance_driver_line_frame_frame = struct
  type t = {
    channel : string;
    payload : Yojson.Raw.t Types.presence;
    correlation_id : string option;
    scope : string option;
  }

  let project fields =
    let reader = start fields in
    {
      channel = required reader string "channel";
      payload = optional reader raw "payload";
      correlation_id = maybe reader string "correlationId";
      scope = maybe reader string "scope";
    }

  let to_json (value : t) =
    write
      [
        ("channel", Some (json_string value.channel));
        ("payload", present json_raw value.payload);
        ("correlationId", Option.map json_string value.correlation_id);
        ("scope", Option.map json_string value.scope);
      ]
end

module Conformance_driver_line_progress_progress = struct
  type t = { upload : int; bytes_uploaded : int; total_bytes : int option }

  let project fields =
    let reader = start fields in
    {
      upload = required reader int "upload";
      bytes_uploaded = required reader int "bytesUploaded";
      total_bytes = maybe reader int "totalBytes";
    }

  let to_json (value : t) =
    write
      [
        ("upload", Some (json_int value.upload));
        ("bytesUploaded", Some (json_int value.bytes_uploaded));
        ("totalBytes", Option.map json_int value.total_bytes);
      ]
end

module Conformance_driver_line_emission_emission_state_pending = struct
  module Status = struct
    type t = Pending

    let to_string = function Pending -> "pending"
    let of_string = function "pending" -> Some Pending | _ -> None
  end

  type t = { status : Status.t }

  let project fields =
    let reader = start fields in
    { status = required reader (enum Status.of_string) "status" }

  let to_json (value : t) =
    write [ ("status", Some ((json_enum Status.to_string) value.status)) ]
end

module Conformance_driver_line_emission_emission_state_ready = struct
  module Status = struct
    type t = Ready

    let to_string = function Ready -> "ready"
    let of_string = function "ready" -> Some Ready | _ -> None
  end

  type t = { status : Status.t; value : Yojson.Raw.t }

  let project fields =
    let reader = start fields in
    {
      status = required reader (enum Status.of_string) "status";
      value = required reader raw "value";
    }

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("value", Some (json_raw value.value));
      ]
end

module Conformance_driver_line_completed = struct
  type t = { completed : string }

  let project fields =
    let reader = start fields in
    { completed = required reader string "completed" }

  let to_json (value : t) =
    write [ ("completed", Some (json_string value.completed)) ]
end

module Conformance_driver_line_claimed = struct
  type t = { claimed : Held_job_record.t }

  let project fields =
    let reader = start fields in
    { claimed = required reader (tabled Held_job_record.of_json) "claimed" }

  let to_json (value : t) =
    write
      [
        ("claimed", Some ((json_tabled Held_job_record.to_json) value.claimed));
      ]
end

module Conformance_driver_line_signalled = struct
  type t = { signalled : string }

  let project fields =
    let reader = start fields in
    { signalled = required reader string "signalled" }

  let to_json (value : t) =
    write [ ("signalled", Some (json_string value.signalled)) ]
end

module Conformance_driver_line_stalled = struct
  type t = { stalled : string }

  let project fields =
    let reader = start fields in
    { stalled = required reader string "stalled" }

  let to_json (value : t) =
    write [ ("stalled", Some (json_string value.stalled)) ]
end

module Browse_click_event = struct
  type t = { annotation_id : string; anchor_rect : Anchor_rect.t option }

  let project fields =
    let reader = start fields in
    {
      annotation_id = required reader string "annotationId";
      anchor_rect = maybe reader (record Anchor_rect.project) "anchorRect";
    }

  let of_model (model : [ `BrowseClickEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Some (json_string value.annotation_id));
        ("anchorRect", Option.map Anchor_rect.to_json value.anchor_rect);
      ]

  let to_model value =
    Models.decode Models.browse_click_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_entity_types_result = struct
  type t = { response : Get_entity_types_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader (record Get_entity_types_response.project) "response";
    }

  let of_model (model : [ `BrowseEntityTypesResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Get_entity_types_response.to_json value.response)) ]

  let to_model value =
    Models.decode Models.browse_entity_types_result
      (Yojson.Raw.to_string (to_json value))
end

module Browse_kb_result = struct
  type t = { response : Kb_description.t }

  let project fields =
    let reader = start fields in
    { response = required reader (record Kb_description.project) "response" }

  let of_model (model : [ `BrowseKbResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("response", Some (Kb_description.to_json value.response)) ]

  let to_model value =
    Models.decode Models.browse_kb_result (Yojson.Raw.to_string (to_json value))
end

module Anchored_text = struct
  type t = { text : string; items : Pdf_text_item.t list }

  let project fields =
    let reader = start fields in
    {
      text = required reader string "text";
      items = required reader (list (record Pdf_text_item.project)) "items";
    }

  let of_model (model : [ `AnchoredText ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("text", Some (json_string value.text));
        ("items", Some ((json_list Pdf_text_item.to_json) value.items));
      ]

  let to_model value =
    Models.decode Models.anchored_text (Yojson.Raw.to_string (to_json value))
end

module Bus_subscribe_request = struct
  type t = {
    global : string list option;
    pending_replies : string list option;
    scoped : Bus_subscribe_request_scoped_item.t list option;
    client_id : string;
  }

  let project fields =
    let reader = start fields in
    {
      global = maybe reader (list string) "global";
      pending_replies = maybe reader (list string) "pendingReplies";
      scoped =
        maybe reader
          (list (record Bus_subscribe_request_scoped_item.project))
          "scoped";
      client_id = required reader string "clientId";
    }

  let of_model (model : [ `BusSubscribeRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("global", Option.map (json_list json_string) value.global);
        ( "pendingReplies",
          Option.map (json_list json_string) value.pending_replies );
        ( "scoped",
          Option.map
            (json_list Bus_subscribe_request_scoped_item.to_json)
            value.scoped );
        ("clientId", Some (json_string value.client_id));
      ]

  let to_model value =
    Models.decode Models.bus_subscribe_request
      (Yojson.Raw.to_string (to_json value))
end

module Contextual_summary_response = struct
  type t = {
    summary : string;
    relevant_fields : Contextual_summary_response_relevant_fields.t;
    context : Contextual_summary_response_context.t;
  }

  let project fields =
    let reader = start fields in
    {
      summary = required reader string "summary";
      relevant_fields =
        required reader
          (record Contextual_summary_response_relevant_fields.project)
          "relevantFields";
      context =
        required reader
          (record Contextual_summary_response_context.project)
          "context";
    }

  let of_model (model : [ `ContextualSummaryResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("summary", Some (json_string value.summary));
        ( "relevantFields",
          Some
            (Contextual_summary_response_relevant_fields.to_json
               value.relevant_fields) );
        ( "context",
          Some (Contextual_summary_response_context.to_json value.context) );
      ]

  let to_model value =
    Models.decode Models.contextual_summary_response
      (Yojson.Raw.to_string (to_json value))
end

module Discovery_document = struct
  type t = { version : int; kbs : Discovered_kb.t list }

  let project fields =
    let reader = start fields in
    {
      version = required reader int "version";
      kbs = required reader (list (record Discovered_kb.project)) "kbs";
    }

  let of_model (model : [ `DiscoveryDocument ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("version", Some (json_int value.version));
        ("kbs", Some ((json_list Discovered_kb.to_json) value.kbs));
      ]

  let to_model value =
    Models.decode Models.discovery_document
      (Yojson.Raw.to_string (to_json value))
end

module Extracted_text = struct
  module Kind = struct
    type t = Extracted

    let to_string = function Extracted -> "extracted"
    let of_string = function "extracted" -> Some Extracted | _ -> None
  end

  type t = {
    text : string;
    items : Pdf_text_item.t list;
    kind : Kind.t;
    method_ : Enums.Extraction_method.t;
    pdf_class : Enums.Pdf_class.t option;
    ocr_confidence : Ocr_confidence.t option;
    unread_pages : int list option;
  }

  let project fields =
    let reader = start fields in
    {
      text = required reader string "text";
      items = required reader (list (record Pdf_text_item.project)) "items";
      kind = required reader (enum Kind.of_string) "kind";
      method_ =
        required reader (enum Enums.Extraction_method.of_string) "method";
      pdf_class = maybe reader (enum Enums.Pdf_class.of_string) "pdfClass";
      ocr_confidence =
        maybe reader (record Ocr_confidence.project) "ocrConfidence";
      unread_pages = maybe reader (list int) "unreadPages";
    }

  let of_model (model : [ `ExtractedText ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("text", Some (json_string value.text));
        ("items", Some ((json_list Pdf_text_item.to_json) value.items));
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ( "method",
          Some ((json_enum Enums.Extraction_method.to_string) value.method_) );
        ( "pdfClass",
          Option.map (json_enum Enums.Pdf_class.to_string) value.pdf_class );
        ("ocrConfidence", Option.map Ocr_confidence.to_json value.ocr_confidence);
        ("unreadPages", Option.map (json_list json_int) value.unread_pages);
      ]

  let to_model value =
    Models.decode Models.extracted_text (Yojson.Raw.to_string (to_json value))
end

module Gather_annotation_request = struct
  type t = {
    annotation_id : string;
    resource_id : string;
    options : Gather_annotation_options.t option;
  }

  let project fields =
    let reader = start fields in
    {
      annotation_id = required reader string "annotationId";
      resource_id = required reader string "resourceId";
      options =
        maybe reader (record Gather_annotation_options.project) "options";
    }

  let of_model (model : [ `GatherAnnotationRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Some (json_string value.annotation_id));
        ("resourceId", Some (json_string value.resource_id));
        ("options", Option.map Gather_annotation_options.to_json value.options);
      ]

  let to_model value =
    Models.decode Models.gather_annotation_request
      (Yojson.Raw.to_string (to_json value))
end

module Gather_resource_request = struct
  type t = { resource_id : string; options : Gather_resource_request_options.t }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      options =
        required reader
          (record Gather_resource_request_options.project)
          "options";
    }

  let of_model (model : [ `GatherResourceRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("options", Some (Gather_resource_request_options.to_json value.options));
      ]

  let to_model value =
    Models.decode Models.gather_resource_request
      (Yojson.Raw.to_string (to_json value))
end

module Engine_limits = struct
  type t = { engine : Engine.t; limits : Inference_limits.t }

  let project fields =
    let reader = start fields in
    {
      engine = required reader (record Engine.project) "engine";
      limits = required reader (record Inference_limits.project) "limits";
    }

  let of_model (model : [ `EngineLimits ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("engine", Some (Engine.to_json value.engine));
        ("limits", Some (Inference_limits.to_json value.limits));
      ]

  let to_model value =
    Models.decode Models.engine_limits (Yojson.Raw.to_string (to_json value))
end

module Job_cancel_command = struct
  type t = {
    field_user_id : string option;
    resource_id : string;
    job_id : string;
    job_type : Enums.Job_type.t;
    annotation_id : string option;
    completed_units : string list option;
    unit_cursors : (string * Unit_cursor.t) list option;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      resource_id = required reader string "resourceId";
      job_id = required reader string "jobId";
      job_type = required reader (enum Enums.Job_type.of_string) "jobType";
      annotation_id = maybe reader string "annotationId";
      completed_units = maybe reader (list string) "completedUnits";
      unit_cursors =
        maybe reader (map (record Unit_cursor.project)) "unitCursors";
    }

  let of_model (model : [ `JobCancelCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("resourceId", Some (json_string value.resource_id));
        ("jobId", Some (json_string value.job_id));
        ("jobType", Some ((json_enum Enums.Job_type.to_string) value.job_type));
        ("annotationId", Option.map json_string value.annotation_id);
        ( "completedUnits",
          Option.map (json_list json_string) value.completed_units );
        ( "unitCursors",
          Option.map (json_map Unit_cursor.to_json) value.unit_cursors );
      ]

  let to_model value =
    Models.decode Models.job_cancel_command
      (Yojson.Raw.to_string (to_json value))
end

module Job_created_result = struct
  type t = { response : Job_created_result_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader (record Job_created_result_response.project) "response";
    }

  let of_model (model : [ `JobCreatedResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("response", Some (Job_created_result_response.to_json value.response));
      ]

  let to_model value =
    Models.decode Models.job_created_result
      (Yojson.Raw.to_string (to_json value))
end

module Job_fail_command = struct
  type t = {
    field_user_id : string option;
    resource_id : string;
    job_id : string;
    job_type : Enums.Job_type.t;
    attempt : int option;
    annotation_id : string option;
    error : string;
    completed_units : string list option;
    unit_cursors : (string * Unit_cursor.t) list option;
    failure_class : Enums.Failure_class.t option;
    will_retry : bool option;
    durability : Enums.Durability_evidence.t option;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      resource_id = required reader string "resourceId";
      job_id = required reader string "jobId";
      job_type = required reader (enum Enums.Job_type.of_string) "jobType";
      attempt = maybe reader int "attempt";
      annotation_id = maybe reader string "annotationId";
      error = required reader string "error";
      completed_units = maybe reader (list string) "completedUnits";
      unit_cursors =
        maybe reader (map (record Unit_cursor.project)) "unitCursors";
      failure_class =
        maybe reader (enum Enums.Failure_class.of_string) "failureClass";
      will_retry = maybe reader bool "willRetry";
      durability =
        maybe reader (enum Enums.Durability_evidence.of_string) "durability";
    }

  let of_model (model : [ `JobFailCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("resourceId", Some (json_string value.resource_id));
        ("jobId", Some (json_string value.job_id));
        ("jobType", Some ((json_enum Enums.Job_type.to_string) value.job_type));
        ("attempt", Option.map json_int value.attempt);
        ("annotationId", Option.map json_string value.annotation_id);
        ("error", Some (json_string value.error));
        ( "completedUnits",
          Option.map (json_list json_string) value.completed_units );
        ( "unitCursors",
          Option.map (json_map Unit_cursor.to_json) value.unit_cursors );
        ( "failureClass",
          Option.map
            (json_enum Enums.Failure_class.to_string)
            value.failure_class );
        ("willRetry", Option.map json_bool value.will_retry);
        ( "durability",
          Option.map
            (json_enum Enums.Durability_evidence.to_string)
            value.durability );
      ]

  let to_model value =
    Models.decode Models.job_fail_command (Yojson.Raw.to_string (to_json value))
end

module Job_checkpoint_command = struct
  type t = {
    field_user_id : string option;
    job_id : string;
    completed_units : string list;
    unit_cursors : (string * Unit_cursor.t) list option;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      job_id = required reader string "jobId";
      completed_units = required reader (list string) "completedUnits";
      unit_cursors =
        maybe reader (map (record Unit_cursor.project)) "unitCursors";
    }

  let of_model (model : [ `JobCheckpointCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("jobId", Some (json_string value.job_id));
        ("completedUnits", Some ((json_list json_string) value.completed_units));
        ( "unitCursors",
          Option.map (json_map Unit_cursor.to_json) value.unit_cursors );
      ]

  let to_model value =
    Models.decode Models.job_checkpoint_command
      (Yojson.Raw.to_string (to_json value))
end

module Mark_create_ok = struct
  type t = { response : Mark_create_ok_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader (record Mark_create_ok_response.project) "response";
    }

  let of_model (model : [ `MarkCreateOk ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Mark_create_ok_response.to_json value.response)) ]

  let to_model value =
    Models.decode Models.mark_create_ok (Yojson.Raw.to_string (to_json value))
end

module Mark_commit_ok = struct
  type t = { response : Mark_commit_ok_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader (record Mark_commit_ok_response.project) "response";
    }

  let of_model (model : [ `MarkCommitOk ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Mark_commit_ok_response.to_json value.response)) ]

  let to_model value =
    Models.decode Models.mark_commit_ok (Yojson.Raw.to_string (to_json value))
end

module Mark_delete_ok = struct
  type t = { response : Mark_delete_ok_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader (record Mark_delete_ok_response.project) "response";
    }

  let of_model (model : [ `MarkDeleteOk ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Mark_delete_ok_response.to_json value.response)) ]

  let to_model value =
    Models.decode Models.mark_delete_ok (Yojson.Raw.to_string (to_json value))
end

module Representation = struct
  module Rel = struct
    type t = Original | Thumbnail | Preview | Optimized | Derived | Other

    let to_string = function
      | Original -> "original"
      | Thumbnail -> "thumbnail"
      | Preview -> "preview"
      | Optimized -> "optimized"
      | Derived -> "derived"
      | Other -> "other"

    let of_string = function
      | "original" -> Some Original
      | "thumbnail" -> Some Thumbnail
      | "preview" -> Some Preview
      | "optimized" -> Some Optimized
      | "derived" -> Some Derived
      | "other" -> Some Other
      | _ -> None
  end

  type t = {
    field_id : string option;
    field_type : One_or_more_strings.t option;
    media_type : string;
    storage_uri : string option;
    filename : string option;
    byte_size : int option;
    checksum : string option;
    encoding : string option;
    language : string option;
    width : int option;
    height : int option;
    duration : float option;
    created : string option;
    modified : string option;
    conforms_to : One_or_more_uris.t option;
    tags : string list option;
    rel : Rel.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_id = maybe reader string "@id";
        field_type = maybe reader One_or_more_strings.read "@type";
        media_type = required reader string "mediaType";
        storage_uri = maybe reader string "storageUri";
        filename = maybe reader string "filename";
        byte_size = maybe reader int "byteSize";
        checksum = maybe reader string "checksum";
        encoding = maybe reader string "encoding";
        language = maybe reader string "language";
        width = maybe reader int "width";
        height = maybe reader int "height";
        duration = maybe reader float "duration";
        created = maybe reader string "created";
        modified = maybe reader string "modified";
        conforms_to = maybe reader One_or_more_uris.read "conformsTo";
        tags = maybe reader (list string) "tags";
        rel = maybe reader (enum Rel.of_string) "rel";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Representation ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write_open
      [
        ("@id", Option.map json_string value.field_id);
        ("@type", Option.map One_or_more_strings.to_json value.field_type);
        ("mediaType", Some (json_string value.media_type));
        ("storageUri", Option.map json_string value.storage_uri);
        ("filename", Option.map json_string value.filename);
        ("byteSize", Option.map json_int value.byte_size);
        ("checksum", Option.map json_string value.checksum);
        ("encoding", Option.map json_string value.encoding);
        ("language", Option.map json_string value.language);
        ("width", Option.map json_int value.width);
        ("height", Option.map json_int value.height);
        ("duration", Option.map json_float value.duration);
        ("created", Option.map json_string value.created);
        ("modified", Option.map json_string value.modified);
        ("conformsTo", Option.map One_or_more_uris.to_json value.conforms_to);
        ("tags", Option.map (json_list json_string) value.tags);
        ("rel", Option.map (json_enum Rel.to_string) value.rel);
      ]
      value.extra

  let to_model value =
    Models.decode Models.representation (Yojson.Raw.to_string (to_json value))
end

module Status_response = struct
  type t = {
    status : string;
    version : string;
    features : Status_response_features.t;
    message : string;
    authenticated_as : string option;
  }

  let project fields =
    let reader = start fields in
    {
      status = required reader string "status";
      version = required reader string "version";
      features =
        required reader (record Status_response_features.project) "features";
      message = required reader string "message";
      authenticated_as = maybe reader string "authenticatedAs";
    }

  let of_model (model : [ `StatusResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some (json_string value.status));
        ("version", Some (json_string value.version));
        ("features", Some (Status_response_features.to_json value.features));
        ("message", Some (json_string value.message));
        ("authenticatedAs", Option.map json_string value.authenticated_as);
      ]

  let to_model value =
    Models.decode Models.status_response (Yojson.Raw.to_string (to_json value))
end

module Stored_event_response = struct
  type t = {
    id : string;
    type_ : string;
    timestamp : string;
    user_id : string;
    resource_id : string option;
    version : int;
    payload : (string * Yojson.Raw.t) list;
    metadata : Event_metadata.t;
  }

  let project fields =
    let reader = start fields in
    {
      id = required reader string "id";
      type_ = required reader string "type";
      timestamp = required reader string "timestamp";
      user_id = required reader string "userId";
      resource_id = maybe reader string "resourceId";
      version = required reader int "version";
      payload = required reader (map raw) "payload";
      metadata = required reader (record Event_metadata.project) "metadata";
    }

  let of_model (model : [ `StoredEventResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("type", Some (json_string value.type_));
        ("timestamp", Some (json_string value.timestamp));
        ("userId", Some (json_string value.user_id));
        ("resourceId", Option.map json_string value.resource_id);
        ("version", Some (json_int value.version));
        ("payload", Some ((json_map json_raw) value.payload));
        ("metadata", Some (Event_metadata.to_json value.metadata));
      ]

  let to_model value =
    Models.decode Models.stored_event_response
      (Yojson.Raw.to_string (to_json value))
end

module Tag_schema = struct
  type t = {
    id : string;
    name : string;
    description : string;
    domain : string;
    tags : Tag_category.t list;
  }

  let project fields =
    let reader = start fields in
    {
      id = required reader string "id";
      name = required reader string "name";
      description = required reader string "description";
      domain = required reader string "domain";
      tags = required reader (list (record Tag_category.project)) "tags";
    }

  let of_model (model : [ `TagSchema ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("name", Some (json_string value.name));
        ("description", Some (json_string value.description));
        ("domain", Some (json_string value.domain));
        ("tags", Some ((json_list Tag_category.to_json) value.tags));
      ]

  let to_model value =
    Models.decode Models.tag_schema (Yojson.Raw.to_string (to_json value))
end

module Yield_clone_created = struct
  type t = { response : Yielded_resource.t }

  let project fields =
    let reader = start fields in
    { response = required reader (record Yielded_resource.project) "response" }

  let of_model (model : [ `YieldCloneCreated ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("response", Some (Yielded_resource.to_json value.response)) ]

  let to_model value =
    Models.decode Models.yield_clone_created
      (Yojson.Raw.to_string (to_json value))
end

module Yield_create_ok = struct
  type t = { response : Yielded_resource.t }

  let project fields =
    let reader = start fields in
    { response = required reader (record Yielded_resource.project) "response" }

  let of_model (model : [ `YieldCreateOk ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("response", Some (Yielded_resource.to_json value.response)) ]

  let to_model value =
    Models.decode Models.yield_create_ok (Yojson.Raw.to_string (to_json value))
end

module Yield_clone_persist_ok = struct
  type t = { response : Yielded_resource.t }

  let project fields =
    let reader = start fields in
    { response = required reader (record Yielded_resource.project) "response" }

  let of_model (model : [ `YieldClonePersistOk ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("response", Some (Yielded_resource.to_json value.response)) ]

  let to_model value =
    Models.decode Models.yield_clone_persist_ok
      (Yojson.Raw.to_string (to_json value))
end

module Yield_update_ok = struct
  type t = { response : Yielded_resource.t }

  let project fields =
    let reader = start fields in
    { response = required reader (record Yielded_resource.project) "response" }

  let of_model (model : [ `YieldUpdateOk ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("response", Some (Yielded_resource.to_json value.response)) ]

  let to_model value =
    Models.decode Models.yield_update_ok (Yojson.Raw.to_string (to_json value))
end

module Bus_event_message = struct
  module Event = struct
    type t = Bus_event

    let to_string = function Bus_event -> "bus-event"
    let of_string = function "bus-event" -> Some Bus_event | _ -> None
  end

  type t = { event : Event.t; id : string; data : Bus_frame.t }

  let project fields =
    let reader = start fields in
    {
      event = required reader (enum Event.of_string) "event";
      id = required reader string "id";
      data = required reader (record Bus_frame.project) "data";
    }

  let of_model (model : [ `BusEventMessage ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("event", Some ((json_enum Event.to_string) value.event));
        ("id", Some (json_string value.id));
        ("data", Some (Bus_frame.to_json value.data));
      ]

  let to_model value =
    Models.decode Models.bus_event_message
      (Yojson.Raw.to_string (to_json value))
end

module Job_metadata = struct
  type t = {
    id : string;
    type_ : Enums.Job_type.t;
    user_id : string;
    created : string;
    retry_count : int;
    max_retries : int;
    completed_units : string list option;
    unit_cursors : (string * Unit_cursor.t) list option;
  }

  let project fields =
    let reader = start fields in
    {
      id = required reader string "id";
      type_ = required reader (enum Enums.Job_type.of_string) "type";
      user_id = required reader string "userId";
      created = required reader string "created";
      retry_count = required reader int "retryCount";
      max_retries = required reader int "maxRetries";
      completed_units = maybe reader (list string) "completedUnits";
      unit_cursors =
        maybe reader (map (record Unit_cursor.project)) "unitCursors";
    }

  let of_model (model : [ `JobMetadata ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("type", Some ((json_enum Enums.Job_type.to_string) value.type_));
        ("userId", Some (json_string value.user_id));
        ("created", Some (json_string value.created));
        ("retryCount", Some (json_int value.retry_count));
        ("maxRetries", Some (json_int value.max_retries));
        ( "completedUnits",
          Option.map (json_list json_string) value.completed_units );
        ( "unitCursors",
          Option.map (json_map Unit_cursor.to_json) value.unit_cursors );
      ]

  let to_model value =
    Models.decode Models.job_metadata (Yojson.Raw.to_string (to_json value))
end

module Yield_job_queued_event = struct
  module Job_type = struct
    type t = Yield

    let to_string = function Yield -> "yield"
    let of_string = function "yield" -> Some Yield | _ -> None
  end

  type t = {
    job_id : string;
    job_type : Job_type.t;
    resource_id : string;
    user_id : string;
    params : Generation_job_request.t;
  }

  let project fields =
    let reader = start fields in
    {
      job_id = required reader string "jobId";
      job_type = required reader (enum Job_type.of_string) "jobType";
      resource_id = required reader string "resourceId";
      user_id = required reader string "userId";
      params = required reader (record Generation_job_request.project) "params";
    }

  let of_model (model : [ `YieldJobQueuedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("jobId", Some (json_string value.job_id));
        ("jobType", Some ((json_enum Job_type.to_string) value.job_type));
        ("resourceId", Some (json_string value.resource_id));
        ("userId", Some (json_string value.user_id));
        ("params", Some (Generation_job_request.to_json value.params));
      ]

  let to_model value =
    Models.decode Models.yield_job_queued_event
      (Yojson.Raw.to_string (to_json value))
end

module Mark_job_filter = struct
  module Job_type = struct
    type t = Mark

    let to_string = function Mark -> "mark"
    let of_string = function "mark" -> Some Mark | _ -> None
  end

  type t = { job_type : Job_type.t; params : Mark_job_filter_params.t }

  let project fields =
    let reader = start fields in
    {
      job_type = required reader (enum Job_type.of_string) "jobType";
      params = required reader (record Mark_job_filter_params.project) "params";
    }

  let of_model (model : [ `MarkJobFilter ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("jobType", Some ((json_enum Job_type.to_string) value.job_type));
        ("params", Some (Mark_job_filter_params.to_json value.params));
      ]

  let to_model value =
    Models.decode Models.mark_job_filter (Yojson.Raw.to_string (to_json value))
end

module Profiles_projection = struct
  type t = { profiles : (string * Profile.t) list }

  let project fields =
    let reader = start fields in
    { profiles = required reader (map (record Profile.project)) "profiles" }

  let of_model (model : [ `ProfilesProjection ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("profiles", Some ((json_map Profile.to_json) value.profiles)) ]

  let to_model value =
    Models.decode Models.profiles_projection
      (Yojson.Raw.to_string (to_json value))
end

module Anchored_text_extracted_entry = struct
  type t = {
    v : int;
    stamp : string;
    text : string;
    lines : Anchored_text_extracted_entry_lines_item.t list;
    method_ : Enums.Extraction_method.t;
    pdf_class : Enums.Pdf_class.t option;
    ocr_confidence : Ocr_confidence.t option;
    unread_pages : int list option;
  }

  let project fields =
    let reader = start fields in
    {
      v = required reader int "v";
      stamp = required reader string "stamp";
      text = required reader string "text";
      lines =
        required reader
          (list (record Anchored_text_extracted_entry_lines_item.project))
          "lines";
      method_ =
        required reader (enum Enums.Extraction_method.of_string) "method";
      pdf_class = maybe reader (enum Enums.Pdf_class.of_string) "pdfClass";
      ocr_confidence =
        maybe reader (record Ocr_confidence.project) "ocrConfidence";
      unread_pages = maybe reader (list int) "unreadPages";
    }

  let of_model (model : [ `AnchoredTextExtractedEntry ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("v", Some (json_int value.v));
        ("stamp", Some (json_string value.stamp));
        ("text", Some (json_string value.text));
        ( "lines",
          Some
            ((json_list Anchored_text_extracted_entry_lines_item.to_json)
               value.lines) );
        ( "method",
          Some ((json_enum Enums.Extraction_method.to_string) value.method_) );
        ( "pdfClass",
          Option.map (json_enum Enums.Pdf_class.to_string) value.pdf_class );
        ("ocrConfidence", Option.map Ocr_confidence.to_json value.ocr_confidence);
        ("unreadPages", Option.map (json_list json_int) value.unread_pages);
      ]

  let to_model value =
    Models.decode Models.anchored_text_extracted_entry
      (Yojson.Raw.to_string (to_json value))
end

module Archivist_streams_response = struct
  type t = { streams : Archivist_stream.t list }

  let project fields =
    let reader = start fields in
    {
      streams =
        required reader (list (record Archivist_stream.project)) "streams";
    }

  let of_model (model : [ `ArchivistStreamsResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("streams", Some ((json_list Archivist_stream.to_json) value.streams)) ]

  let to_model value =
    Models.decode Models.archivist_streams_response
      (Yojson.Raw.to_string (to_json value))
end

module About_result = struct
  type t = {
    version : string option;
    development : bool;
    commit : string option;
    built : string option;
    api_versions : string list;
    image_registry : string;
    runtimes : Runtime_state.t list;
  }

  let project fields =
    let reader = start fields in
    {
      version = maybe reader string "version";
      development = required reader bool "development";
      commit = maybe reader string "commit";
      built = maybe reader string "built";
      api_versions = required reader (list string) "apiVersions";
      image_registry = required reader string "imageRegistry";
      runtimes =
        required reader (list (record Runtime_state.project)) "runtimes";
    }

  let of_model (model : [ `AboutResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("version", Option.map json_string value.version);
        ("development", Some (json_bool value.development));
        ("commit", Option.map json_string value.commit);
        ("built", Option.map json_string value.built);
        ("apiVersions", Some ((json_list json_string) value.api_versions));
        ("imageRegistry", Some (json_string value.image_registry));
        ("runtimes", Some ((json_list Runtime_state.to_json) value.runtimes));
      ]

  let to_model value =
    Models.decode Models.about_result (Yojson.Raw.to_string (to_json value))
end

module Auth_login_params = struct
  type t = {
    api_version : Enums.Api_version.t;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      target = maybe reader (record Target.project) "target";
      runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
    }

  let of_model (model : [ `AuthLoginParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("target", Option.map Target.to_json value.target);
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
      ]

  let to_model value =
    Models.decode Models.auth_login_params
      (Yojson.Raw.to_string (to_json value))
end

module Auth_logout_params = struct
  type t = {
    api_version : Enums.Api_version.t;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      target = maybe reader (record Target.project) "target";
      runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
    }

  let of_model (model : [ `AuthLogoutParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("target", Option.map Target.to_json value.target);
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
      ]

  let to_model value =
    Models.decode Models.auth_logout_params
      (Yojson.Raw.to_string (to_json value))
end

module Cancelled = struct
  type t = { request_id : Request_id.t; reason : string option }

  let project fields =
    let reader = start fields in
    {
      request_id = required reader Request_id.read "requestId";
      reason = maybe reader string "reason";
    }

  let of_model (model : [ `Cancelled ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("requestId", Some (Request_id.to_json value.request_id));
        ("reason", Option.map json_string value.reason);
      ]

  let to_model value =
    Models.decode Models.cancelled (Yojson.Raw.to_string (to_json value))
end

module Error_data = struct
  type t = {
    code : string;
    retryable : bool;
    fields : Field_fault.t list option;
    choices : Target.t list option;
    supported : string list option;
    may_still_run : bool option;
  }

  let project fields =
    let reader = start fields in
    {
      code = required reader string "code";
      retryable = required reader bool "retryable";
      fields = maybe reader (list (record Field_fault.project)) "fields";
      choices = maybe reader (list (record Target.project)) "choices";
      supported = maybe reader (list string) "supported";
      may_still_run = maybe reader bool "mayStillRun";
    }

  let of_model (model : [ `ErrorData ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Some (json_string value.code));
        ("retryable", Some (json_bool value.retryable));
        ("fields", Option.map (json_list Field_fault.to_json) value.fields);
        ("choices", Option.map (json_list Target.to_json) value.choices);
        ("supported", Option.map (json_list json_string) value.supported);
        ("mayStillRun", Option.map json_bool value.may_still_run);
      ]

  let to_model value =
    Models.decode Models.error_data (Yojson.Raw.to_string (to_json value))
end

module Identity_useradd_params = struct
  type t = {
    api_version : Enums.Api_version.t;
    target : Local_target.t;
    email : string;
    password : string option;
    generate_password : bool;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      target = required reader (record Local_target.project) "target";
      email = required reader string "email";
      password = maybe reader string "password";
      generate_password = required reader bool "generatePassword";
    }

  let of_model (model : [ `IdentityUseraddParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("target", Some (Local_target.to_json value.target));
        ("email", Some (json_string value.email));
        ("password", Option.map json_string value.password);
        ("generatePassword", Some (json_bool value.generate_password));
      ]

  let to_model value =
    Models.decode Models.identity_useradd_params
      (Yojson.Raw.to_string (to_json value))
end

module Identity_users_list_params = struct
  type t = { api_version : Enums.Api_version.t; target : Local_target.t }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      target = required reader (record Local_target.project) "target";
    }

  let of_model (model : [ `IdentityUsersListParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("target", Some (Local_target.to_json value.target));
      ]

  let to_model value =
    Models.decode Models.identity_users_list_params
      (Yojson.Raw.to_string (to_json value))
end

module Identity_users_list_result = struct
  type t = { users : Identity_user.t list }

  let project fields =
    let reader = start fields in
    { users = required reader (list (record Identity_user.project)) "users" }

  let of_model (model : [ `IdentityUsersListResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("users", Some ((json_list Identity_user.to_json) value.users)) ]

  let to_model value =
    Models.decode Models.identity_users_list_result
      (Yojson.Raw.to_string (to_json value))
end

module Log_record = struct
  type t = {
    request_id : Request_id.t;
    service : string;
    stream : Enums.Output_stream.t;
    line : string;
    received_at : string;
  }

  let project fields =
    let reader = start fields in
    {
      request_id = required reader Request_id.read "requestId";
      service = required reader string "service";
      stream = required reader (enum Enums.Output_stream.of_string) "stream";
      line = required reader string "line";
      received_at = required reader string "receivedAt";
    }

  let of_model (model : [ `LogRecord ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("requestId", Some (Request_id.to_json value.request_id));
        ("service", Some (json_string value.service));
        ("stream", Some ((json_enum Enums.Output_stream.to_string) value.stream));
        ("line", Some (json_string value.line));
        ("receivedAt", Some (json_string value.received_at));
      ]

  let to_model value =
    Models.decode Models.log_record (Yojson.Raw.to_string (to_json value))
end

module Logs_follow_params = struct
  type t = {
    api_version : Enums.Api_version.t;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
    service : string option;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      target = maybe reader (record Target.project) "target";
      runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
      service = maybe reader string "service";
    }

  let of_model (model : [ `LogsFollowParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("target", Option.map Target.to_json value.target);
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
        ("service", Option.map json_string value.service);
      ]

  let to_model value =
    Models.decode Models.logs_follow_params
      (Yojson.Raw.to_string (to_json value))
end

module Progress = struct
  module Kind = struct
    type t =
      | Log
      | Note
      | Ok
      | Warn
      | Fail
      | Banner
      | Section
      | Stamp
      | Command
      | Output

    let to_string = function
      | Log -> "log"
      | Note -> "note"
      | Ok -> "ok"
      | Warn -> "warn"
      | Fail -> "fail"
      | Banner -> "banner"
      | Section -> "section"
      | Stamp -> "stamp"
      | Command -> "command"
      | Output -> "output"

    let of_string = function
      | "log" -> Some Log
      | "note" -> Some Note
      | "ok" -> Some Ok
      | "warn" -> Some Warn
      | "fail" -> Some Fail
      | "banner" -> Some Banner
      | "section" -> Some Section
      | "stamp" -> Some Stamp
      | "command" -> Some Command
      | "output" -> Some Output
      | _ -> None
  end

  type t = { request_id : Request_id.t; kind : Kind.t; text : string }

  let project fields =
    let reader = start fields in
    {
      request_id = required reader Request_id.read "requestId";
      kind = required reader (enum Kind.of_string) "kind";
      text = required reader string "text";
    }

  let of_model (model : [ `Progress ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("requestId", Some (Request_id.to_json value.request_id));
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("text", Some (json_string value.text));
      ]

  let to_model value =
    Models.decode Models.progress (Yojson.Raw.to_string (to_json value))
end

module Roots_list_result = struct
  type t = { roots : Root.t list; warnings : string list option }

  let project fields =
    let reader = start fields in
    {
      roots = required reader (list (record Root.project)) "roots";
      warnings = maybe reader (list string) "warnings";
    }

  let of_model (model : [ `RootsListResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("roots", Some ((json_list Root.to_json) value.roots));
        ("warnings", Option.map (json_list json_string) value.warnings);
      ]

  let to_model value =
    Models.decode Models.roots_list_result
      (Yojson.Raw.to_string (to_json value))
end

module Service_output = struct
  type t = {
    request_id : Request_id.t;
    instance : string;
    stream : Enums.Output_stream.t;
    line : string;
  }

  let project fields =
    let reader = start fields in
    {
      request_id = required reader Request_id.read "requestId";
      instance = required reader string "instance";
      stream = required reader (enum Enums.Output_stream.of_string) "stream";
      line = required reader string "line";
    }

  let of_model (model : [ `ServiceOutput ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("requestId", Some (Request_id.to_json value.request_id));
        ("instance", Some (json_string value.instance));
        ("stream", Some ((json_enum Enums.Output_stream.to_string) value.stream));
        ("line", Some (json_string value.line));
      ]

  let to_model value =
    Models.decode Models.service_output (Yojson.Raw.to_string (to_json value))
end

module Service_run_params = struct
  type t = {
    api_version : Enums.Api_version.t;
    target : Local_target.t;
    runtime : Enums.Runtime.t option;
    service : Enums.Run_service.t;
    instance : string;
    document : string option;
    args : string list option;
    environment : (string * string) list;
    mounts : string list;
    path_first : string list;
    ports : int list;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      target = required reader (record Local_target.project) "target";
      runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
      service = required reader (enum Enums.Run_service.of_string) "service";
      instance = required reader string "instance";
      document = maybe reader string "document";
      args = maybe reader (list string) "args";
      environment = required reader (map string) "environment";
      mounts = required reader (list string) "mounts";
      path_first = required reader (list string) "pathFirst";
      ports = required reader (list int) "ports";
    }

  let of_model (model : [ `ServiceRunParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("target", Some (Local_target.to_json value.target));
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
        ("service", Some ((json_enum Enums.Run_service.to_string) value.service));
        ("instance", Some (json_string value.instance));
        ("document", Option.map json_string value.document);
        ("args", Option.map (json_list json_string) value.args);
        ("environment", Some ((json_map json_string) value.environment));
        ("mounts", Some ((json_list json_string) value.mounts));
        ("pathFirst", Some ((json_list json_string) value.path_first));
        ("ports", Some ((json_list json_int) value.ports));
      ]

  let to_model value =
    Models.decode Models.service_run_params
      (Yojson.Raw.to_string (to_json value))
end

module Service_signal_params = struct
  module Signal = struct
    type t = Term | Kill

    let to_string = function Term -> "term" | Kill -> "kill"

    let of_string = function
      | "term" -> Some Term
      | "kill" -> Some Kill
      | _ -> None
  end

  type t = {
    api_version : Enums.Api_version.t;
    target : Local_target.t;
    runtime : Enums.Runtime.t option;
    instance : string;
    signal : Signal.t;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      target = required reader (record Local_target.project) "target";
      runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
      instance = required reader string "instance";
      signal = required reader (enum Signal.of_string) "signal";
    }

  let of_model (model : [ `ServiceSignalParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("target", Some (Local_target.to_json value.target));
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
        ("instance", Some (json_string value.instance));
        ("signal", Some ((json_enum Signal.to_string) value.signal));
      ]

  let to_model value =
    Models.decode Models.service_signal_params
      (Yojson.Raw.to_string (to_json value))
end

module Service_started = struct
  type t = {
    request_id : Request_id.t;
    instance : string;
    container : string;
    document_path : string option;
    address : string;
  }

  let project fields =
    let reader = start fields in
    {
      request_id = required reader Request_id.read "requestId";
      instance = required reader string "instance";
      container = required reader string "container";
      document_path = maybe reader string "documentPath";
      address = required reader string "address";
    }

  let of_model (model : [ `ServiceStarted ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("requestId", Some (Request_id.to_json value.request_id));
        ("instance", Some (json_string value.instance));
        ("container", Some (json_string value.container));
        ("documentPath", Option.map json_string value.document_path);
        ("address", Some (json_string value.address));
      ]

  let to_model value =
    Models.decode Models.service_started (Yojson.Raw.to_string (to_json value))
end

module Setting = struct
  module Applies_to = struct
    type t = Machine | Knowledge_base

    let to_string = function
      | Machine -> "machine"
      | Knowledge_base -> "knowledge-base"

    let of_string = function
      | "machine" -> Some Machine
      | "knowledge-base" -> Some Knowledge_base
      | _ -> None
  end

  type t = {
    name : string;
    default : bool;
    applies_to : Applies_to.t;
    values : Setting_line.t list;
    settable : bool;
    changed_by : string option;
  }

  let project fields =
    let reader = start fields in
    {
      name = required reader string "name";
      default = required reader bool "default";
      applies_to = required reader (enum Applies_to.of_string) "appliesTo";
      values = required reader (list (record Setting_line.project)) "values";
      settable = required reader bool "settable";
      changed_by = maybe reader string "changedBy";
    }

  let of_model (model : [ `Setting ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("default", Some (json_bool value.default));
        ("appliesTo", Some ((json_enum Applies_to.to_string) value.applies_to));
        ("values", Some ((json_list Setting_line.to_json) value.values));
        ("settable", Some (json_bool value.settable));
        ("changedBy", Option.map json_string value.changed_by);
      ]

  let to_model value =
    Models.decode Models.setting (Yojson.Raw.to_string (to_json value))
end

module Stack_start_params = struct
  module Ollama_cache = struct
    type t = Host | Volume

    let to_string = function Host -> "host" | Volume -> "volume"

    let of_string = function
      | "host" -> Some Host
      | "volume" -> Some Volume
      | _ -> None
  end

  type t = {
    api_version : Enums.Api_version.t;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
    config : string option;
    service : string option;
    group : Enums.Service_group.t option;
    codespace_name : string option;
    machine : string option;
    idle_timeout : string option;
    retention_period : string option;
    observe : bool option;
    ollama_cache : Ollama_cache.t option;
    dry_run : bool option;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      target = maybe reader (record Target.project) "target";
      runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
      config = maybe reader string "config";
      service = maybe reader string "service";
      group = maybe reader (enum Enums.Service_group.of_string) "group";
      codespace_name = maybe reader string "codespaceName";
      machine = maybe reader string "machine";
      idle_timeout = maybe reader string "idleTimeout";
      retention_period = maybe reader string "retentionPeriod";
      observe = maybe reader bool "observe";
      ollama_cache = maybe reader (enum Ollama_cache.of_string) "ollamaCache";
      dry_run = maybe reader bool "dryRun";
    }

  let of_model (model : [ `StackStartParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("target", Option.map Target.to_json value.target);
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
        ("config", Option.map json_string value.config);
        ("service", Option.map json_string value.service);
        ( "group",
          Option.map (json_enum Enums.Service_group.to_string) value.group );
        ("codespaceName", Option.map json_string value.codespace_name);
        ("machine", Option.map json_string value.machine);
        ("idleTimeout", Option.map json_string value.idle_timeout);
        ("retentionPeriod", Option.map json_string value.retention_period);
        ("observe", Option.map json_bool value.observe);
        ( "ollamaCache",
          Option.map (json_enum Ollama_cache.to_string) value.ollama_cache );
        ("dryRun", Option.map json_bool value.dry_run);
      ]

  let to_model value =
    Models.decode Models.stack_start_params
      (Yojson.Raw.to_string (to_json value))
end

module Stack_stop_params = struct
  type t = {
    api_version : Enums.Api_version.t;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
    service : string option;
    group : Enums.Service_group.t option;
    delete : bool option;
    delete_confirmed : bool option;
    dry_run : bool option;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      target = maybe reader (record Target.project) "target";
      runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
      service = maybe reader string "service";
      group = maybe reader (enum Enums.Service_group.of_string) "group";
      delete = maybe reader bool "delete";
      delete_confirmed = maybe reader bool "deleteConfirmed";
      dry_run = maybe reader bool "dryRun";
    }

  let of_model (model : [ `StackStopParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("target", Option.map Target.to_json value.target);
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
        ("service", Option.map json_string value.service);
        ( "group",
          Option.map (json_enum Enums.Service_group.to_string) value.group );
        ("delete", Option.map json_bool value.delete);
        ("deleteConfirmed", Option.map json_bool value.delete_confirmed);
        ("dryRun", Option.map json_bool value.dry_run);
      ]

  let to_model value =
    Models.decode Models.stack_stop_params
      (Yojson.Raw.to_string (to_json value))
end

module Status_snapshot_params = struct
  type t = {
    api_version : Enums.Api_version.t;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Api_version.of_string) "apiVersion";
      target = maybe reader (record Target.project) "target";
      runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
    }

  let of_model (model : [ `StatusSnapshotParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Api_version.to_string) value.api_version) );
        ("target", Option.map Target.to_json value.target);
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
      ]

  let to_model value =
    Models.decode Models.status_snapshot_params
      (Yojson.Raw.to_string (to_json value))
end

module User_action = struct
  type t = {
    request_id : Request_id.t;
    verification_uri : string;
    verification_uri_complete : string option;
    user_code : string;
    expires_in_seconds : int;
  }

  let project fields =
    let reader = start fields in
    {
      request_id = required reader Request_id.read "requestId";
      verification_uri = required reader string "verificationUri";
      verification_uri_complete = maybe reader string "verificationUriComplete";
      user_code = required reader string "userCode";
      expires_in_seconds = required reader int "expiresInSeconds";
    }

  let of_model (model : [ `UserAction ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("requestId", Some (Request_id.to_json value.request_id));
        ("verificationUri", Some (json_string value.verification_uri));
        ( "verificationUriComplete",
          Option.map json_string value.verification_uri_complete );
        ("userCode", Some (json_string value.user_code));
        ("expiresInSeconds", Some (json_int value.expires_in_seconds));
      ]

  let to_model value =
    Models.decode Models.user_action (Yojson.Raw.to_string (to_json value))
end

module Workload_status = struct
  type t = {
    ledger : Workload_status_ledger.t option;
    queue : Workload_status_queue.t option;
  }

  let project fields =
    let reader = start fields in
    {
      ledger = maybe reader (record Workload_status_ledger.project) "ledger";
      queue = maybe reader (record Workload_status_queue.project) "queue";
    }

  let of_model (model : [ `WorkloadStatus ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("ledger", Option.map Workload_status_ledger.to_json value.ledger);
        ("queue", Option.map Workload_status_queue.to_json value.queue);
      ]

  let to_model value =
    Models.decode Models.workload_status (Yojson.Raw.to_string (to_json value))
end

module Dispatcher_config = struct
  type t = {
    kb : Kb_identity.t;
    gateway_url : string;
    identity : Service_identity.t;
    queue : Dispatcher_config_queue.t;
    port : int;
    timing : Dispatcher_config_timing.t;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
  }

  let project fields =
    let reader = start fields in
    {
      kb = required reader (record Kb_identity.project) "kb";
      gateway_url = required reader string "gatewayUrl";
      identity = required reader (record Service_identity.project) "identity";
      queue = required reader (record Dispatcher_config_queue.project) "queue";
      port = required reader int "port";
      timing =
        required reader (record Dispatcher_config_timing.project) "timing";
      log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
      log_format = required reader (enum Enums.Log_format.of_string) "logFormat";
    }

  let of_model (model : [ `DispatcherConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kb", Some (Kb_identity.to_json value.kb));
        ("gatewayUrl", Some (json_string value.gateway_url));
        ("identity", Some (Service_identity.to_json value.identity));
        ("queue", Some (Dispatcher_config_queue.to_json value.queue));
        ("port", Some (json_int value.port));
        ("timing", Some (Dispatcher_config_timing.to_json value.timing));
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ( "logFormat",
          Some ((json_enum Enums.Log_format.to_string) value.log_format) );
      ]

  let to_model value =
    Models.decode Models.dispatcher_config
      (Yojson.Raw.to_string (to_json value))
end

module Gateway_config = struct
  type t = {
    kb : Kb_identity.t;
    port : int;
    public_url : string;
    identity : Gateway_config_identity.t;
    archivist : Service_address.t;
    signal : Gateway_config_signal.t;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
    capacity : Gateway_config_capacity.t;
  }

  let project fields =
    let reader = start fields in
    {
      kb = required reader (record Kb_identity.project) "kb";
      port = required reader int "port";
      public_url = required reader string "publicUrl";
      identity =
        required reader (record Gateway_config_identity.project) "identity";
      archivist = required reader (record Service_address.project) "archivist";
      signal = required reader (record Gateway_config_signal.project) "signal";
      log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
      log_format = required reader (enum Enums.Log_format.of_string) "logFormat";
      capacity =
        required reader (record Gateway_config_capacity.project) "capacity";
    }

  let of_model (model : [ `GatewayConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kb", Some (Kb_identity.to_json value.kb));
        ("port", Some (json_int value.port));
        ("publicUrl", Some (json_string value.public_url));
        ("identity", Some (Gateway_config_identity.to_json value.identity));
        ("archivist", Some (Service_address.to_json value.archivist));
        ("signal", Some (Gateway_config_signal.to_json value.signal));
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ( "logFormat",
          Some ((json_enum Enums.Log_format.to_string) value.log_format) );
        ("capacity", Some (Gateway_config_capacity.to_json value.capacity));
      ]

  let to_model value =
    Models.decode Models.gateway_config (Yojson.Raw.to_string (to_json value))
end

module Project_config = struct
  type t = {
    project : Project_config_project.t;
    git : Project_config_git.t;
    site : Project_config_site.t;
  }

  let project fields =
    let reader = start fields in
    {
      project =
        required reader (record Project_config_project.project) "project";
      git = required reader (record Project_config_git.project) "git";
      site = required reader (record Project_config_site.project) "site";
    }

  let of_model (model : [ `ProjectConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("project", Some (Project_config_project.to_json value.project));
        ("git", Some (Project_config_git.to_json value.git));
        ("site", Some (Project_config_site.to_json value.site));
      ]

  let to_model value =
    Models.decode Models.project_config (Yojson.Raw.to_string (to_json value))
end

module Librarian_engine_config = struct
  type t = { engine : Engine.t; base_url : string; api_key_env : string option }

  let project fields =
    let reader = start fields in
    {
      engine = required reader (record Engine.project) "engine";
      base_url = required reader string "baseUrl";
      api_key_env = maybe reader string "apiKeyEnv";
    }

  let of_model (model : [ `LibrarianEngineConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("engine", Some (Engine.to_json value.engine));
        ("baseUrl", Some (json_string value.base_url));
        ("apiKeyEnv", Option.map json_string value.api_key_env);
      ]

  let to_model value =
    Models.decode Models.librarian_engine_config
      (Yojson.Raw.to_string (to_json value))
end

module Provider = struct
  type t = { base_url : string option; api_key : Secret_ref.t option }

  let project fields =
    let reader = start fields in
    {
      base_url = maybe reader string "baseURL";
      api_key = maybe reader (record Secret_ref.project) "apiKey";
    }

  let of_model (model : [ `Provider ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("baseURL", Option.map json_string value.base_url);
        ("apiKey", Option.map Secret_ref.to_json value.api_key);
      ]

  let to_model value =
    Models.decode Models.provider (Yojson.Raw.to_string (to_json value))
end

module Resources = struct
  type t = { limits : Resources_limits.t }

  let project fields =
    let reader = start fields in
    { limits = required reader (record Resources_limits.project) "limits" }

  let of_model (model : [ `Resources ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("limits", Some (Resources_limits.to_json value.limits)) ]

  let to_model value =
    Models.decode Models.resources (Yojson.Raw.to_string (to_json value))
end

module Selector = struct
  type t =
    | TextPositionSelector of Text_position_selector.t
    | TextQuoteSelector of Text_quote_selector.t
    | SvgSelector of Svg_selector.t
    | FragmentSelector of Fragment_selector.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "type"; "start"; "end" ];
          allowed = None;
          fixed = [ ("type", [ Text_value "TextPositionSelector" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "type"; "exact" ];
          allowed = None;
          fixed = [ ("type", [ Text_value "TextQuoteSelector" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "type"; "value" ];
          allowed = None;
          fixed = [ ("type", [ Text_value "SvgSelector" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "type"; "value" ];
          allowed = None;
          fixed = [ ("type", [ Text_value "FragmentSelector" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> TextPositionSelector ((record Text_position_selector.project) value)
    | 1 -> TextQuoteSelector ((record Text_quote_selector.project) value)
    | 2 -> SvgSelector ((record Svg_selector.project) value)
    | 3 -> FragmentSelector ((record Fragment_selector.project) value)
    | _ -> assert false

  let of_model (model : [ `Selector ] Models.t) = read (Models.json model)

  let to_json = function
    | TextPositionSelector value -> Text_position_selector.to_json value
    | TextQuoteSelector value -> Text_quote_selector.to_json value
    | SvgSelector value -> Svg_selector.to_json value
    | FragmentSelector value -> Fragment_selector.to_json value

  let to_model value =
    Models.decode Models.selector (Yojson.Raw.to_string (to_json value))
end

module Annotation_body = struct
  type t =
    | TextualBody of Textual_body.t
    | SpecificResource of Specific_resource.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "type"; "value" ];
          allowed = None;
          fixed =
            [
              ("type", [ Text_value "TextualBody" ]);
              ( "purpose",
                [
                  Text_value "assessing";
                  Text_value "bookmarking";
                  Text_value "classifying";
                  Text_value "commenting";
                  Text_value "describing";
                  Text_value "editing";
                  Text_value "highlighting";
                  Text_value "identifying";
                  Text_value "linking";
                  Text_value "moderating";
                  Text_value "questioning";
                  Text_value "replying";
                  Text_value "tagging";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "type"; "source" ];
          allowed = None;
          fixed =
            [
              ("type", [ Text_value "SpecificResource" ]);
              ( "purpose",
                [
                  Text_value "assessing";
                  Text_value "bookmarking";
                  Text_value "classifying";
                  Text_value "commenting";
                  Text_value "describing";
                  Text_value "editing";
                  Text_value "highlighting";
                  Text_value "identifying";
                  Text_value "linking";
                  Text_value "moderating";
                  Text_value "questioning";
                  Text_value "replying";
                  Text_value "tagging";
                ] );
            ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> TextualBody ((record Textual_body.project) value)
    | 1 -> SpecificResource ((record Specific_resource.project) value)
    | _ -> assert false

  let of_model (model : [ `AnnotationBody ] Models.t) = read (Models.json model)

  let to_json = function
    | TextualBody value -> Textual_body.to_json value
    | SpecificResource value -> Specific_resource.to_json value

  let to_model value =
    Models.decode Models.annotation_body (Yojson.Raw.to_string (to_json value))
end

module Agent = struct
  type t =
    | AgentPerson of Agent_person.t
    | AgentOrganization of Agent_organization.t
    | AgentSoftware of Agent_software.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "@type" ];
          allowed = None;
          fixed = [ ("@type", [ Text_value "Person" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "@type"; "name" ];
          allowed = None;
          fixed = [ ("@type", [ Text_value "Organization" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "@type" ];
          allowed = None;
          fixed = [ ("@type", [ Text_value "Software" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> AgentPerson ((record Agent_person.project) value)
    | 1 -> AgentOrganization ((record Agent_organization.project) value)
    | 2 -> AgentSoftware ((record Agent_software.project) value)
    | _ -> assert false

  let of_model (model : [ `Agent ] Models.t) = read (Models.json model)

  let to_json = function
    | AgentPerson value -> Agent_person.to_json value
    | AgentOrganization value -> Agent_organization.to_json value
    | AgentSoftware value -> Agent_software.to_json value

  let to_model value =
    Models.decode Models.agent (Yojson.Raw.to_string (to_json value))
end

module Browse_profiles_result_response = struct
  type t = { profiles : (string * Profile.t) list }

  let project fields =
    let reader = start fields in
    { profiles = required reader (map (record Profile.project)) "profiles" }

  let to_json (value : t) =
    write [ ("profiles", Some ((json_map Profile.to_json) value.profiles)) ]
end

module Resource_descriptor_context = struct
  type t =
    | Text of string
    | Object of (string * Yojson.Raw.t) list
    | List of Resource_descriptor_context_item.t list

  let members =
    [
      [
        {
          kind = Text_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = List_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> Text (string value)
    | 1 -> Object ((map raw) value)
    | 2 -> List ((list Resource_descriptor_context_item.read) value)
    | _ -> assert false

  let to_json = function
    | Text value -> json_string value
    | Object value -> (json_map json_raw) value
    | List value -> (json_list Resource_descriptor_context_item.to_json) value
end

module Resource_descriptor_identifier = struct
  type t =
    | Text of string
    | List of string list
    | Object of Resource_descriptor_identifier_object.t

  let members =
    [
      [
        {
          kind = Text_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = List_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> Text (string value)
    | 1 -> List ((list string) value)
    | 2 -> Object ((record Resource_descriptor_identifier_object.project) value)
    | _ -> assert false

  let to_json = function
    | Text value -> json_string value
    | List value -> (json_list json_string) value
    | Object value -> Resource_descriptor_identifier_object.to_json value
end

module Directory_entry = struct
  type t = FileEntry of File_entry.t | DirEntry of Dir_entry.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "type"; "name"; "path"; "size"; "mtime"; "tracked" ];
          allowed =
            Some
              [
                "type";
                "name";
                "path";
                "size";
                "mtime";
                "tracked";
                "resourceId";
                "entityTypes";
                "annotationCount";
                "creator";
              ];
          fixed = [ ("type", [ Text_value "file" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "type"; "name"; "path"; "mtime" ];
          allowed = Some [ "type"; "name"; "path"; "mtime" ];
          fixed = [ ("type", [ Text_value "dir" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> FileEntry ((record File_entry.project) value)
    | 1 -> DirEntry ((record Dir_entry.project) value)
    | _ -> assert false

  let of_model (model : [ `DirectoryEntry ] Models.t) = read (Models.json model)

  let to_json = function
    | FileEntry value -> File_entry.to_json value
    | DirEntry value -> Dir_entry.to_json value

  let to_model value =
    Models.decode Models.directory_entry (Yojson.Raw.to_string (to_json value))
end

module Gathered_context_semantic_context = struct
  type t = {
    similar : Semantic_match.t list;
    excluded_entity_types : string list option;
  }

  let project fields =
    let reader = start fields in
    {
      similar = required reader (list (record Semantic_match.project)) "similar";
      excluded_entity_types = maybe reader (list string) "excludedEntityTypes";
    }

  let to_json (value : t) =
    write
      [
        ("similar", Some ((json_list Semantic_match.to_json) value.similar));
        ( "excludedEntityTypes",
          Option.map (json_list json_string) value.excluded_entity_types );
      ]
end

module Get_referenced_by_response_referenced_by_item_target = struct
  type t = {
    source : string;
    selector : Get_referenced_by_response_referenced_by_item_target_selector.t;
  }

  let project fields =
    let reader = start fields in
    {
      source = required reader string "source";
      selector =
        required reader
          (record
             Get_referenced_by_response_referenced_by_item_target_selector
             .project)
          "selector";
    }

  let to_json (value : t) =
    write
      [
        ("source", Some (json_string value.source));
        ( "selector",
          Some
            (Get_referenced_by_response_referenced_by_item_target_selector
             .to_json value.selector) );
      ]
end

module Job_progress_message = struct
  type t =
    | JobProgressLoading of Job_progress_loading.t
    | JobProgressAnalyzing of Job_progress_analyzing.t
    | JobProgressAnalyzingTags of Job_progress_analyzing_tags.t
    | JobProgressGeneratingResource of Job_progress_generating_resource.t
    | JobProgressCreatingResource of Job_progress_creating_resource.t
    | JobProgressCompleteGenerated of Job_progress_complete_generated.t
    | JobProgressDetectingEntities of Job_progress_detecting_entities.t
    | JobProgressCreatingAnnotations of Job_progress_creating_annotations.t
    | JobProgressCreatingTagAnnotations of
        Job_progress_creating_tag_annotations.t
    | JobProgressCompleteCreated of Job_progress_complete_created.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "code" ];
          allowed = None;
          fixed = [ ("code", [ Text_value "loading" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "code" ];
          allowed = None;
          fixed = [ ("code", [ Text_value "analyzing" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "code" ];
          allowed = None;
          fixed = [ ("code", [ Text_value "analyzing-tags" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "code" ];
          allowed = None;
          fixed = [ ("code", [ Text_value "generating-resource" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "code" ];
          allowed = None;
          fixed = [ ("code", [ Text_value "creating-resource" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "code"; "truncated" ];
          allowed = None;
          fixed = [ ("code", [ Text_value "complete-generated" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "code"; "entityType" ];
          allowed = None;
          fixed = [ ("code", [ Text_value "detecting-entities" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "code"; "count" ];
          allowed = None;
          fixed = [ ("code", [ Text_value "creating-annotations" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "code"; "count" ];
          allowed = None;
          fixed = [ ("code", [ Text_value "creating-tag-annotations" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "code"; "count"; "motivation" ];
          allowed = None;
          fixed =
            [
              ("code", [ Text_value "complete-created" ]);
              ( "motivation",
                [
                  Text_value "assessing";
                  Text_value "commenting";
                  Text_value "highlighting";
                  Text_value "linking";
                  Text_value "tagging";
                ] );
            ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> JobProgressLoading ((record Job_progress_loading.project) value)
    | 1 -> JobProgressAnalyzing ((record Job_progress_analyzing.project) value)
    | 2 ->
        JobProgressAnalyzingTags
          ((record Job_progress_analyzing_tags.project) value)
    | 3 ->
        JobProgressGeneratingResource
          ((record Job_progress_generating_resource.project) value)
    | 4 ->
        JobProgressCreatingResource
          ((record Job_progress_creating_resource.project) value)
    | 5 ->
        JobProgressCompleteGenerated
          ((record Job_progress_complete_generated.project) value)
    | 6 ->
        JobProgressDetectingEntities
          ((record Job_progress_detecting_entities.project) value)
    | 7 ->
        JobProgressCreatingAnnotations
          ((record Job_progress_creating_annotations.project) value)
    | 8 ->
        JobProgressCreatingTagAnnotations
          ((record Job_progress_creating_tag_annotations.project) value)
    | 9 ->
        JobProgressCompleteCreated
          ((record Job_progress_complete_created.project) value)
    | _ -> assert false

  let of_model (model : [ `JobProgressMessage ] Models.t) =
    read (Models.json model)

  let to_json = function
    | JobProgressLoading value -> Job_progress_loading.to_json value
    | JobProgressAnalyzing value -> Job_progress_analyzing.to_json value
    | JobProgressAnalyzingTags value ->
        Job_progress_analyzing_tags.to_json value
    | JobProgressGeneratingResource value ->
        Job_progress_generating_resource.to_json value
    | JobProgressCreatingResource value ->
        Job_progress_creating_resource.to_json value
    | JobProgressCompleteGenerated value ->
        Job_progress_complete_generated.to_json value
    | JobProgressDetectingEntities value ->
        Job_progress_detecting_entities.to_json value
    | JobProgressCreatingAnnotations value ->
        Job_progress_creating_annotations.to_json value
    | JobProgressCreatingTagAnnotations value ->
        Job_progress_creating_tag_annotations.to_json value
    | JobProgressCompleteCreated value ->
        Job_progress_complete_created.to_json value

  let to_model value =
    Models.decode Models.job_progress_message
      (Yojson.Raw.to_string (to_json value))
end

module Job_progress_completed_items_item = struct
  type t = {
    value : string;
    found_count : int;
    persisted_count : int option;
    under_reported : Job_progress_completed_items_item_under_reported.t option;
  }

  let project fields =
    let reader = start fields in
    {
      value = required reader string "value";
      found_count = required reader int "foundCount";
      persisted_count = maybe reader int "persistedCount";
      under_reported =
        maybe reader
          (record Job_progress_completed_items_item_under_reported.project)
          "underReported";
    }

  let to_json (value : t) =
    write
      [
        ("value", Some (json_string value.value));
        ("foundCount", Some (json_int value.found_count));
        ("persistedCount", Option.map json_int value.persisted_count);
        ( "underReported",
          Option.map Job_progress_completed_items_item_under_reported.to_json
            value.under_reported );
      ]
end

module Job_result = struct
  type t =
    | MarkJobDone of Mark_job_done.t
    | YieldJobDone of Yield_job_done.t
    | JobDeclined of Job_declined.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "found"; "persisted" ];
          allowed =
            Some
              [
                "found";
                "persisted";
                "errors";
                "byCategory";
                "underReportedPieces";
                "uncheckedPieces";
              ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "resourceId"; "resourceName"; "truncated" ];
          allowed = Some [ "resourceId"; "resourceName"; "truncated" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "declined"; "reason" ];
          allowed = Some [ "declined"; "reason" ];
          fixed =
            [
              ("declined", [ Boolean_value true ]);
              ( "reason",
                [
                  Text_value "no-text-layer";
                  Text_value "encrypted";
                  Text_value "corrupt";
                  Text_value "too-large";
                  Text_value "empty";
                ] );
            ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> MarkJobDone ((record Mark_job_done.project) value)
    | 1 -> YieldJobDone ((record Yield_job_done.project) value)
    | 2 -> JobDeclined ((record Job_declined.project) value)
    | _ -> assert false

  let of_model (model : [ `JobResult ] Models.t) = read (Models.json model)

  let to_json = function
    | MarkJobDone value -> Mark_job_done.to_json value
    | YieldJobDone value -> Yield_job_done.to_json value
    | JobDeclined value -> Job_declined.to_json value

  let to_model value =
    Models.decode Models.job_result (Yojson.Raw.to_string (to_json value))
end

module Kb_endpoint = struct
  type t = HttpEndpoint of Http_endpoint.t | LocalEndpoint of Local_endpoint.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "kind"; "host"; "port"; "protocol" ];
          allowed = None;
          fixed =
            [
              ("kind", [ Text_value "http" ]);
              ("protocol", [ Text_value "http"; Text_value "https" ]);
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "kind"; "kbId" ];
          allowed = None;
          fixed = [ ("kind", [ Text_value "local" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> HttpEndpoint ((record Http_endpoint.project) value)
    | 1 -> LocalEndpoint ((record Local_endpoint.project) value)
    | _ -> assert false

  let of_model (model : [ `KbEndpoint ] Models.t) = read (Models.json model)

  let to_json = function
    | HttpEndpoint value -> Http_endpoint.to_json value
    | LocalEndpoint value -> Local_endpoint.to_json value

  let to_model value =
    Models.decode Models.kb_endpoint (Yojson.Raw.to_string (to_json value))
end

module Mark_job_params = struct
  type t =
    | HighlightingJobParams of Highlighting_job_params.t
    | CommentingJobParams of Commenting_job_params.t
    | AssessingJobParams of Assessing_job_params.t
    | LinkingJobParams of Linking_job_params.t
    | TaggingJobParams of Tagging_job_params.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "motivation" ];
          allowed =
            Some [ "motivation"; "instructions"; "density"; "sourceLanguage" ];
          fixed = [ ("motivation", [ Text_value "highlighting" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "motivation" ];
          allowed =
            Some
              [
                "motivation";
                "instructions";
                "tone";
                "density";
                "language";
                "sourceLanguage";
              ];
          fixed =
            [
              ("motivation", [ Text_value "commenting" ]);
              ( "tone",
                [
                  Text_value "scholarly";
                  Text_value "explanatory";
                  Text_value "conversational";
                  Text_value "technical";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "motivation" ];
          allowed =
            Some
              [
                "motivation";
                "instructions";
                "tone";
                "density";
                "language";
                "sourceLanguage";
              ];
          fixed =
            [
              ("motivation", [ Text_value "assessing" ]);
              ( "tone",
                [
                  Text_value "analytical";
                  Text_value "critical";
                  Text_value "balanced";
                  Text_value "constructive";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "motivation"; "entityTypes" ];
          allowed =
            Some
              [
                "motivation";
                "entityTypes";
                "includeDescriptiveReferences";
                "language";
                "sourceLanguage";
              ];
          fixed = [ ("motivation", [ Text_value "linking" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "motivation"; "schemaId"; "categories" ];
          allowed =
            Some
              [
                "motivation";
                "schemaId";
                "categories";
                "language";
                "sourceLanguage";
              ];
          fixed = [ ("motivation", [ Text_value "tagging" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 ->
        HighlightingJobParams ((record Highlighting_job_params.project) value)
    | 1 -> CommentingJobParams ((record Commenting_job_params.project) value)
    | 2 -> AssessingJobParams ((record Assessing_job_params.project) value)
    | 3 -> LinkingJobParams ((record Linking_job_params.project) value)
    | 4 -> TaggingJobParams ((record Tagging_job_params.project) value)
    | _ -> assert false

  let of_model (model : [ `MarkJobParams ] Models.t) = read (Models.json model)

  let to_json = function
    | HighlightingJobParams value -> Highlighting_job_params.to_json value
    | CommentingJobParams value -> Commenting_job_params.to_json value
    | AssessingJobParams value -> Assessing_job_params.to_json value
    | LinkingJobParams value -> Linking_job_params.to_json value
    | TaggingJobParams value -> Tagging_job_params.to_json value

  let to_model value =
    Models.decode Models.mark_job_params (Yojson.Raw.to_string (to_json value))
end

module Mark_job_result = struct
  type t = MarkJobDone of Mark_job_done.t | JobDeclined of Job_declined.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "found"; "persisted" ];
          allowed =
            Some
              [
                "found";
                "persisted";
                "errors";
                "byCategory";
                "underReportedPieces";
                "uncheckedPieces";
              ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "declined"; "reason" ];
          allowed = Some [ "declined"; "reason" ];
          fixed =
            [
              ("declined", [ Boolean_value true ]);
              ( "reason",
                [
                  Text_value "no-text-layer";
                  Text_value "encrypted";
                  Text_value "corrupt";
                  Text_value "too-large";
                  Text_value "empty";
                ] );
            ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> MarkJobDone ((record Mark_job_done.project) value)
    | 1 -> JobDeclined ((record Job_declined.project) value)
    | _ -> assert false

  let of_model (model : [ `MarkJobResult ] Models.t) = read (Models.json model)

  let to_json = function
    | MarkJobDone value -> Mark_job_done.to_json value
    | JobDeclined value -> Job_declined.to_json value

  let to_model value =
    Models.decode Models.mark_job_result (Yojson.Raw.to_string (to_json value))
end

module Yield_job_result = struct
  type t = YieldJobDone of Yield_job_done.t | JobDeclined of Job_declined.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "resourceId"; "resourceName"; "truncated" ];
          allowed = Some [ "resourceId"; "resourceName"; "truncated" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "declined"; "reason" ];
          allowed = Some [ "declined"; "reason" ];
          fixed =
            [
              ("declined", [ Boolean_value true ]);
              ( "reason",
                [
                  Text_value "no-text-layer";
                  Text_value "encrypted";
                  Text_value "corrupt";
                  Text_value "too-large";
                  Text_value "empty";
                ] );
            ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> YieldJobDone ((record Yield_job_done.project) value)
    | 1 -> JobDeclined ((record Job_declined.project) value)
    | _ -> assert false

  let of_model (model : [ `YieldJobResult ] Models.t) = read (Models.json model)

  let to_json = function
    | YieldJobDone value -> Yield_job_done.to_json value
    | JobDeclined value -> Job_declined.to_json value

  let to_model value =
    Models.decode Models.yield_job_result (Yojson.Raw.to_string (to_json value))
end

module Archivist_engines_jobs_mark = struct
  type t = {
    highlighting : Engine.t option;
    commenting : Engine.t option;
    assessing : Engine.t option;
    linking : Engine.t option;
    tagging : Engine.t option;
  }

  let project fields =
    let reader = start fields in
    {
      highlighting = maybe reader (record Engine.project) "highlighting";
      commenting = maybe reader (record Engine.project) "commenting";
      assessing = maybe reader (record Engine.project) "assessing";
      linking = maybe reader (record Engine.project) "linking";
      tagging = maybe reader (record Engine.project) "tagging";
    }

  let to_json (value : t) =
    write
      [
        ("highlighting", Option.map Engine.to_json value.highlighting);
        ("commenting", Option.map Engine.to_json value.commenting);
        ("assessing", Option.map Engine.to_json value.assessing);
        ("linking", Option.map Engine.to_json value.linking);
        ("tagging", Option.map Engine.to_json value.tagging);
      ]
end

module Archivist_engines_actors = struct
  type t = { gatherer : Engine.t option; matcher : Engine.t option }

  let project fields =
    let reader = start fields in
    {
      gatherer = maybe reader (record Engine.project) "gatherer";
      matcher = maybe reader (record Engine.project) "matcher";
    }

  let to_json (value : t) =
    write
      [
        ("gatherer", Option.map Engine.to_json value.gatherer);
        ("matcher", Option.map Engine.to_json value.matcher);
      ]
end

module Conformance_step_observe = struct
  type t = { observe : Conformance_step_observe_observe.t; as_ : string }

  let project fields =
    let reader = start fields in
    {
      observe =
        required reader
          (record Conformance_step_observe_observe.project)
          "observe";
      as_ = required reader string "as";
    }

  let to_json (value : t) =
    write
      [
        ( "observe",
          Some (Conformance_step_observe_observe.to_json value.observe) );
        ("as", Some (json_string value.as_));
      ]
end

module Conformance_step_fetches_fetches_item = struct
  type t =
    | ConformanceBusFetch of Conformance_bus_fetch.t
    | ConformanceHttpFetch of Conformance_http_fetch.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "fetch"; "as" ];
          allowed = Some [ "fetch"; "payload"; "as" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "fetch" ];
          allowed = Some [ "fetch"; "params" ];
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> ConformanceBusFetch ((record Conformance_bus_fetch.project) value)
    | 1 -> ConformanceHttpFetch ((record Conformance_http_fetch.project) value)
    | _ -> assert false

  let to_json = function
    | ConformanceBusFetch value -> Conformance_bus_fetch.to_json value
    | ConformanceHttpFetch value -> Conformance_http_fetch.to_json value
end

module Conformance_implementations_sdks_value = struct
  type t = {
    wire : string list option;
    live : Conformance_implementations_sdks_value_live.t option;
    worker : string list option;
    exempt : (string * string) list option;
  }

  let project fields =
    let reader = start fields in
    {
      wire = maybe reader (list string) "wire";
      live =
        maybe reader
          (record Conformance_implementations_sdks_value_live.project)
          "live";
      worker = maybe reader (list string) "worker";
      exempt = maybe reader (map string) "exempt";
    }

  let to_json (value : t) =
    write
      [
        ("wire", Option.map (json_list json_string) value.wire);
        ( "live",
          Option.map Conformance_implementations_sdks_value_live.to_json
            value.live );
        ("worker", Option.map (json_list json_string) value.worker);
        ("exempt", Option.map (json_map json_string) value.exempt);
      ]
end

module Graph_config = struct
  type t =
    | Neo4jGraphConfig of Neo4j_graph_config.t
    | JanusGraphConfig of Janus_graph_config.t
    | NeptuneGraphConfig of Neptune_graph_config.t
    | MemoryGraphConfig of Memory_graph_config.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "type"; "uri"; "username"; "passwordEnv"; "database" ];
          allowed =
            Some [ "type"; "uri"; "username"; "passwordEnv"; "database" ];
          fixed = [ ("type", [ Text_value "neo4j" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "type"; "host"; "port" ];
          allowed = Some [ "type"; "host"; "port" ];
          fixed = [ ("type", [ Text_value "janusgraph" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "type"; "endpoint"; "port" ];
          allowed = Some [ "type"; "endpoint"; "port" ];
          fixed = [ ("type", [ Text_value "neptune" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "type" ];
          allowed = Some [ "type" ];
          fixed = [ ("type", [ Text_value "memory" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> Neo4jGraphConfig ((record Neo4j_graph_config.project) value)
    | 1 -> JanusGraphConfig ((record Janus_graph_config.project) value)
    | 2 -> NeptuneGraphConfig ((record Neptune_graph_config.project) value)
    | 3 -> MemoryGraphConfig ((record Memory_graph_config.project) value)
    | _ -> assert false

  let of_model (model : [ `GraphConfig ] Models.t) = read (Models.json model)

  let to_json = function
    | Neo4jGraphConfig value -> Neo4j_graph_config.to_json value
    | JanusGraphConfig value -> Janus_graph_config.to_json value
    | NeptuneGraphConfig value -> Neptune_graph_config.to_json value
    | MemoryGraphConfig value -> Memory_graph_config.to_json value

  let to_model value =
    Models.decode Models.graph_config (Yojson.Raw.to_string (to_json value))
end

module Vectors_config = struct
  type t =
    | QdrantVectorsConfig of Qdrant_vectors_config.t
    | MemoryVectorsConfig of Memory_vectors_config.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "type"; "host"; "port"; "tokenEnv" ];
          allowed = Some [ "type"; "host"; "port"; "tokenEnv" ];
          fixed = [ ("type", [ Text_value "qdrant" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "type" ];
          allowed = Some [ "type" ];
          fixed = [ ("type", [ Text_value "memory" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> QdrantVectorsConfig ((record Qdrant_vectors_config.project) value)
    | 1 -> MemoryVectorsConfig ((record Memory_vectors_config.project) value)
    | _ -> assert false

  let of_model (model : [ `VectorsConfig ] Models.t) = read (Models.json model)

  let to_json = function
    | QdrantVectorsConfig value -> Qdrant_vectors_config.to_json value
    | MemoryVectorsConfig value -> Memory_vectors_config.to_json value

  let to_model value =
    Models.decode Models.vectors_config (Yojson.Raw.to_string (to_json value))
end

module Embedding_config = struct
  type t =
    | OllamaEmbeddingConfig of Ollama_embedding_config.t
    | VoyageEmbeddingConfig of Voyage_embedding_config.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "type"; "model"; "baseUrl" ];
          allowed = Some [ "type"; "model"; "baseUrl" ];
          fixed = [ ("type", [ Text_value "ollama" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "type"; "model"; "endpoint"; "apiKeyEnv" ];
          allowed = Some [ "type"; "model"; "endpoint"; "apiKeyEnv" ];
          fixed = [ ("type", [ Text_value "voyage" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 ->
        OllamaEmbeddingConfig ((record Ollama_embedding_config.project) value)
    | 1 ->
        VoyageEmbeddingConfig ((record Voyage_embedding_config.project) value)
    | _ -> assert false

  let of_model (model : [ `EmbeddingConfig ] Models.t) =
    read (Models.json model)

  let to_json = function
    | OllamaEmbeddingConfig value -> Ollama_embedding_config.to_json value
    | VoyageEmbeddingConfig value -> Voyage_embedding_config.to_json value

  let to_model value =
    Models.decode Models.embedding_config (Yojson.Raw.to_string (to_json value))
end

module Smelter_health_reconcile = struct
  module Phase = struct
    type t = Pending | Running | Done | Failed

    let to_string = function
      | Pending -> "pending"
      | Running -> "running"
      | Done -> "done"
      | Failed -> "failed"

    let of_string = function
      | "pending" -> Some Pending
      | "running" -> Some Running
      | "done" -> Some Done
      | "failed" -> Some Failed
      | _ -> None
  end

  type t = {
    phase : Phase.t;
    summary : Smelter_reconcile_summary.t option;
    error : string option;
  }

  let project fields =
    let reader = start fields in
    {
      phase = required reader (enum Phase.of_string) "phase";
      summary =
        maybe reader (record Smelter_reconcile_summary.project) "summary";
      error = maybe reader string "error";
    }

  let to_json (value : t) =
    write
      [
        ("phase", Some ((json_enum Phase.to_string) value.phase));
        ("summary", Option.map Smelter_reconcile_summary.to_json value.summary);
        ("error", Option.map json_string value.error);
      ]
end

module Smelter_health_index_stamp = struct
  type t = {
    embedding : Smelter_health_index_stamp_embedding.t;
    chunking : Smelter_chunking.t;
  }

  let project fields =
    let reader = start fields in
    {
      embedding =
        required reader
          (record Smelter_health_index_stamp_embedding.project)
          "embedding";
      chunking = required reader (record Smelter_chunking.project) "chunking";
    }

  let to_json (value : t) =
    write
      [
        ( "embedding",
          Some (Smelter_health_index_stamp_embedding.to_json value.embedding) );
        ("chunking", Some (Smelter_chunking.to_json value.chunking));
      ]
end

module Issuer_spec_database_external = struct
  type t = { host : string; port : int; password : Secret_ref.t }

  let project fields =
    let reader = start fields in
    {
      host = required reader string "host";
      port = required reader int "port";
      password = required reader (record Secret_ref.project) "password";
    }

  let to_json (value : t) =
    write
      [
        ("host", Some (json_string value.host));
        ("port", Some (json_int value.port));
        ("password", Some (Secret_ref.to_json value.password));
      ]
end

module Knowledge_index_spec_graph_external = struct
  type t = { uri : string; password : Secret_ref.t }

  let project fields =
    let reader = start fields in
    {
      uri = required reader string "uri";
      password = required reader (record Secret_ref.project) "password";
    }

  let to_json (value : t) =
    write
      [
        ("uri", Some (json_string value.uri));
        ("password", Some (Secret_ref.to_json value.password));
      ]
end

module Knowledge_index_spec_vectors_external = struct
  type t = {
    host : string;
    port : int;
    smelter_token : Secret_ref.t;
    librarian_token : Secret_ref.t;
  }

  let project fields =
    let reader = start fields in
    {
      host = required reader string "host";
      port = required reader int "port";
      smelter_token = required reader (record Secret_ref.project) "smelterToken";
      librarian_token =
        required reader (record Secret_ref.project) "librarianToken";
    }

  let to_json (value : t) =
    write
      [
        ("host", Some (json_string value.host));
        ("port", Some (json_int value.port));
        ("smelterToken", Some (Secret_ref.to_json value.smelter_token));
        ("librarianToken", Some (Secret_ref.to_json value.librarian_token));
      ]
end

module Knowledge_index_spec_embedding = struct
  type t = {
    type_ : string;
    model : string;
    chunking : Knowledge_index_spec_embedding_chunking.t;
    endpoint : string option;
    api_key : Secret_ref.t option;
  }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader string "type";
      model = required reader string "model";
      chunking =
        required reader
          (record Knowledge_index_spec_embedding_chunking.project)
          "chunking";
      endpoint = maybe reader string "endpoint";
      api_key = maybe reader (record Secret_ref.project) "apiKey";
    }

  let to_json (value : t) =
    write
      [
        ("type", Some (json_string value.type_));
        ("model", Some (json_string value.model));
        ( "chunking",
          Some (Knowledge_index_spec_embedding_chunking.to_json value.chunking)
        );
        ("endpoint", Option.map json_string value.endpoint);
        ("apiKey", Option.map Secret_ref.to_json value.api_key);
      ]
end

module Stack_knowledge_base_spec_messaging_external = struct
  type t = { servers : string; user : Secret_ref.t; password : Secret_ref.t }

  let project fields =
    let reader = start fields in
    {
      servers = required reader string "servers";
      user = required reader (record Secret_ref.project) "user";
      password = required reader (record Secret_ref.project) "password";
    }

  let to_json (value : t) =
    write
      [
        ("servers", Some (json_string value.servers));
        ("user", Some (Secret_ref.to_json value.user));
        ("password", Some (Secret_ref.to_json value.password));
      ]
end

module Stack_knowledge_base_spec_issuer = struct
  type t = {
    shared : Stack_knowledge_base_spec_issuer_shared.t option;
    external_ : Stack_knowledge_base_spec_issuer_external.t option;
    subject_claim : string;
  }

  let project fields =
    let reader = start fields in
    {
      shared =
        maybe reader
          (record Stack_knowledge_base_spec_issuer_shared.project)
          "shared";
      external_ =
        maybe reader
          (record Stack_knowledge_base_spec_issuer_external.project)
          "external";
      subject_claim = required reader string "subjectClaim";
    }

  let to_json (value : t) =
    write
      [
        ( "shared",
          Option.map Stack_knowledge_base_spec_issuer_shared.to_json
            value.shared );
        ( "external",
          Option.map Stack_knowledge_base_spec_issuer_external.to_json
            value.external_ );
        ("subjectClaim", Some (json_string value.subject_claim));
      ]
end

module Weaver_health_reconcile = struct
  module Phase = struct
    type t = Pending | Running | Done | Failed

    let to_string = function
      | Pending -> "pending"
      | Running -> "running"
      | Done -> "done"
      | Failed -> "failed"

    let of_string = function
      | "pending" -> Some Pending
      | "running" -> Some Running
      | "done" -> Some Done
      | "failed" -> Some Failed
      | _ -> None
  end

  type t = {
    phase : Phase.t;
    summary : Weaver_health_reconcile_summary.t option;
    error : string option;
  }

  let project fields =
    let reader = start fields in
    {
      phase = required reader (enum Phase.of_string) "phase";
      summary =
        maybe reader (record Weaver_health_reconcile_summary.project) "summary";
      error = maybe reader string "error";
    }

  let to_json (value : t) =
    write
      [
        ("phase", Some ((json_enum Phase.to_string) value.phase));
        ( "summary",
          Option.map Weaver_health_reconcile_summary.to_json value.summary );
        ("error", Option.map json_string value.error);
      ]
end

module Conformance_driver_line_failed = struct
  type t = { id : int; error : Conformance_failure.t }

  let project fields =
    let reader = start fields in
    {
      id = required reader int "id";
      error = required reader (record Conformance_failure.project) "error";
    }

  let to_json (value : t) =
    write
      [
        ("id", Some (json_int value.id));
        ("error", Some (Conformance_failure.to_json value.error));
      ]
end

module Conformance_driver_line_frame = struct
  type t = { frame : Conformance_driver_line_frame_frame.t }

  let project fields =
    let reader = start fields in
    {
      frame =
        required reader
          (record Conformance_driver_line_frame_frame.project)
          "frame";
    }

  let to_json (value : t) =
    write
      [
        ("frame", Some (Conformance_driver_line_frame_frame.to_json value.frame));
      ]
end

module Conformance_driver_line_error_stream = struct
  type t = { error : Conformance_failure.t }

  let project fields =
    let reader = start fields in
    { error = required reader (record Conformance_failure.project) "error" }

  let to_json (value : t) =
    write [ ("error", Some (Conformance_failure.to_json value.error)) ]
end

module Conformance_driver_line_progress = struct
  type t = { progress : Conformance_driver_line_progress_progress.t }

  let project fields =
    let reader = start fields in
    {
      progress =
        required reader
          (record Conformance_driver_line_progress_progress.project)
          "progress";
    }

  let to_json (value : t) =
    write
      [
        ( "progress",
          Some
            (Conformance_driver_line_progress_progress.to_json value.progress)
        );
      ]
end

module Conformance_driver_line_emission_emission_state_failed = struct
  module Status = struct
    type t = Failed

    let to_string = function Failed -> "failed"
    let of_string = function "failed" -> Some Failed | _ -> None
  end

  type t = { status : Status.t; error : Conformance_failure.t }

  let project fields =
    let reader = start fields in
    {
      status = required reader (enum Status.of_string) "status";
      error = required reader (record Conformance_failure.project) "error";
    }

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("error", Some (Conformance_failure.to_json value.error));
      ]
end

module Conformance_driver_line_refused = struct
  type t = { refused : Conformance_failure.t }

  let project fields =
    let reader = start fields in
    { refused = required reader (record Conformance_failure.project) "refused" }

  let to_json (value : t) =
    write [ ("refused", Some (Conformance_failure.to_json value.refused)) ]
end

module Attributed_event = struct
  type t = {
    id : string;
    type_ : string;
    timestamp : string;
    user_id : string;
    resource_id : string option;
    version : int;
    payload : (string * Yojson.Raw.t) list;
    metadata : Event_metadata.t;
    agent : Agent.t;
  }

  let project fields =
    let reader = start fields in
    {
      id = required reader string "id";
      type_ = required reader string "type";
      timestamp = required reader string "timestamp";
      user_id = required reader string "userId";
      resource_id = maybe reader string "resourceId";
      version = required reader int "version";
      payload = required reader (map raw) "payload";
      metadata = required reader (record Event_metadata.project) "metadata";
      agent = required reader Agent.read "agent";
    }

  let of_model (model : [ `AttributedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("type", Some (json_string value.type_));
        ("timestamp", Some (json_string value.timestamp));
        ("userId", Some (json_string value.user_id));
        ("resourceId", Option.map json_string value.resource_id);
        ("version", Some (json_int value.version));
        ("payload", Some ((json_map json_raw) value.payload));
        ("metadata", Some (Event_metadata.to_json value.metadata));
        ("agent", Some (Agent.to_json value.agent));
      ]

  let to_model value =
    Models.decode Models.attributed_event (Yojson.Raw.to_string (to_json value))
end

module Bind_body_operation = struct
  module Op = struct
    type t = Add | Remove | Replace

    let to_string = function
      | Add -> "add"
      | Remove -> "remove"
      | Replace -> "replace"

    let of_string = function
      | "add" -> Some Add
      | "remove" -> Some Remove
      | "replace" -> Some Replace
      | _ -> None
  end

  type t = {
    op : Op.t;
    item : Annotation_body.t option;
    old_item : Annotation_body.t option;
    new_item : Annotation_body.t option;
  }

  let project fields =
    let reader = start fields in
    {
      op = required reader (enum Op.of_string) "op";
      item = maybe reader Annotation_body.read "item";
      old_item = maybe reader Annotation_body.read "oldItem";
      new_item = maybe reader Annotation_body.read "newItem";
    }

  let of_model (model : [ `BindBodyOperation ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("op", Some ((json_enum Op.to_string) value.op));
        ("item", Option.map Annotation_body.to_json value.item);
        ("oldItem", Option.map Annotation_body.to_json value.old_item);
        ("newItem", Option.map Annotation_body.to_json value.new_item);
      ]

  let to_model value =
    Models.decode Models.bind_body_operation
      (Yojson.Raw.to_string (to_json value))
end

module Body_operation_add = struct
  module Op = struct
    type t = Add

    let to_string = function Add -> "add"
    let of_string = function "add" -> Some Add | _ -> None
  end

  type t = { op : Op.t; item : Annotation_body.t }

  let project fields =
    let reader = start fields in
    {
      op = required reader (enum Op.of_string) "op";
      item = required reader Annotation_body.read "item";
    }

  let of_model (model : [ `BodyOperationAdd ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("op", Some ((json_enum Op.to_string) value.op));
        ("item", Some (Annotation_body.to_json value.item));
      ]

  let to_model value =
    Models.decode Models.body_operation_add
      (Yojson.Raw.to_string (to_json value))
end

module Body_operation_remove = struct
  module Op = struct
    type t = Remove

    let to_string = function Remove -> "remove"
    let of_string = function "remove" -> Some Remove | _ -> None
  end

  type t = { op : Op.t; item : Annotation_body.t }

  let project fields =
    let reader = start fields in
    {
      op = required reader (enum Op.of_string) "op";
      item = required reader Annotation_body.read "item";
    }

  let of_model (model : [ `BodyOperationRemove ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("op", Some ((json_enum Op.to_string) value.op));
        ("item", Some (Annotation_body.to_json value.item));
      ]

  let to_model value =
    Models.decode Models.body_operation_remove
      (Yojson.Raw.to_string (to_json value))
end

module Body_operation_replace = struct
  module Op = struct
    type t = Replace

    let to_string = function Replace -> "replace"
    let of_string = function "replace" -> Some Replace | _ -> None
  end

  type t = {
    op : Op.t;
    old_item : Annotation_body.t;
    new_item : Annotation_body.t;
  }

  let project fields =
    let reader = start fields in
    {
      op = required reader (enum Op.of_string) "op";
      old_item = required reader Annotation_body.read "oldItem";
      new_item = required reader Annotation_body.read "newItem";
    }

  let of_model (model : [ `BodyOperationReplace ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("op", Some ((json_enum Op.to_string) value.op));
        ("oldItem", Some (Annotation_body.to_json value.old_item));
        ("newItem", Some (Annotation_body.to_json value.new_item));
      ]

  let to_model value =
    Models.decode Models.body_operation_replace
      (Yojson.Raw.to_string (to_json value))
end

module Browse_profiles_result = struct
  type t = { response : Browse_profiles_result_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader
          (record Browse_profiles_result_response.project)
          "response";
    }

  let of_model (model : [ `BrowseProfilesResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "response",
          Some (Browse_profiles_result_response.to_json value.response) );
      ]

  let to_model value =
    Models.decode Models.browse_profiles_result
      (Yojson.Raw.to_string (to_json value))
end

module Browse_directory_result_response = struct
  type t = { path : string; entries : Directory_entry.t list }

  let project fields =
    let reader = start fields in
    {
      path = required reader string "path";
      entries = required reader (list Directory_entry.read) "entries";
    }

  let of_model (model : [ `BrowseDirectoryResultResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("path", Some (json_string value.path));
        ("entries", Some ((json_list Directory_entry.to_json) value.entries));
      ]

  let to_model value =
    Models.decode Models.browse_directory_result_response
      (Yojson.Raw.to_string (to_json value))
end

module Browse_files_response = struct
  type t = { path : string; entries : Directory_entry.t list }

  let project fields =
    let reader = start fields in
    {
      path = required reader string "path";
      entries = required reader (list Directory_entry.read) "entries";
    }

  let of_model (model : [ `BrowseFilesResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("path", Some (json_string value.path));
        ("entries", Some ((json_list Directory_entry.to_json) value.entries));
      ]

  let to_model value =
    Models.decode Models.browse_files_response
      (Yojson.Raw.to_string (to_json value))
end

module Frame_add_tag_schema_command = struct
  type t = { schema : Tag_schema.t; field_user_id : string option }

  let project fields =
    let reader = start fields in
    {
      schema = required reader (record Tag_schema.project) "schema";
      field_user_id = maybe reader string "_userId";
    }

  let of_model (model : [ `FrameAddTagSchemaCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("schema", Some (Tag_schema.to_json value.schema));
        ("_userId", Option.map json_string value.field_user_id);
      ]

  let to_model value =
    Models.decode Models.frame_add_tag_schema_command
      (Yojson.Raw.to_string (to_json value))
end

module Get_referenced_by_response_referenced_by_item = struct
  type t = {
    id : string;
    resource_name : string option;
    target : Get_referenced_by_response_referenced_by_item_target.t;
  }

  let project fields =
    let reader = start fields in
    {
      id = required reader string "id";
      resource_name = maybe reader string "resourceName";
      target =
        required reader
          (record Get_referenced_by_response_referenced_by_item_target.project)
          "target";
    }

  let of_model (model : [ `GetReferencedByResponseReferencedByItem ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("resourceName", Option.map json_string value.resource_name);
        ( "target",
          Some
            (Get_referenced_by_response_referenced_by_item_target.to_json
               value.target) );
      ]

  let to_model value =
    Models.decode Models.get_referenced_by_response_referenced_by_item
      (Yojson.Raw.to_string (to_json value))
end

module Get_tag_schemas_response = struct
  type t = { tag_schemas : Tag_schema.t list }

  let project fields =
    let reader = start fields in
    {
      tag_schemas =
        required reader (list (record Tag_schema.project)) "tagSchemas";
    }

  let of_model (model : [ `GetTagSchemasResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("tagSchemas", Some ((json_list Tag_schema.to_json) value.tag_schemas));
      ]

  let to_model value =
    Models.decode Models.get_tag_schemas_response
      (Yojson.Raw.to_string (to_json value))
end

module Job_progress = struct
  type t = {
    percentage : float;
    message : Job_progress_message.t option;
    annotation_id : string option;
    current : Job_progress_current.t option;
    processed : int option;
    total : int option;
    entities_found : int option;
    entities_expected : int option;
    entities_emitted : int option;
    completed_items : Job_progress_completed_items_item.t list option;
    request_params : Job_progress_request_params_item.t list option;
  }

  let project fields =
    let reader = start fields in
    {
      percentage = required reader float "percentage";
      message = maybe reader Job_progress_message.read "message";
      annotation_id = maybe reader string "annotationId";
      current = maybe reader (record Job_progress_current.project) "current";
      processed = maybe reader int "processed";
      total = maybe reader int "total";
      entities_found = maybe reader int "entitiesFound";
      entities_expected = maybe reader int "entitiesExpected";
      entities_emitted = maybe reader int "entitiesEmitted";
      completed_items =
        maybe reader
          (list (record Job_progress_completed_items_item.project))
          "completedItems";
      request_params =
        maybe reader
          (list (record Job_progress_request_params_item.project))
          "requestParams";
    }

  let of_model (model : [ `JobProgress ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("percentage", Some (json_float value.percentage));
        ("message", Option.map Job_progress_message.to_json value.message);
        ("annotationId", Option.map json_string value.annotation_id);
        ("current", Option.map Job_progress_current.to_json value.current);
        ("processed", Option.map json_int value.processed);
        ("total", Option.map json_int value.total);
        ("entitiesFound", Option.map json_int value.entities_found);
        ("entitiesExpected", Option.map json_int value.entities_expected);
        ("entitiesEmitted", Option.map json_int value.entities_emitted);
        ( "completedItems",
          Option.map
            (json_list Job_progress_completed_items_item.to_json)
            value.completed_items );
        ( "requestParams",
          Option.map
            (json_list Job_progress_request_params_item.to_json)
            value.request_params );
      ]

  let to_model value =
    Models.decode Models.job_progress (Yojson.Raw.to_string (to_json value))
end

module Kb_target = struct
  type t = { id : string; label : string; endpoint : Kb_endpoint.t }

  let project fields =
    let reader = start fields in
    {
      id = required reader string "id";
      label = required reader string "label";
      endpoint = required reader Kb_endpoint.read "endpoint";
    }

  let of_model (model : [ `KbTarget ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("label", Some (json_string value.label));
        ("endpoint", Some (Kb_endpoint.to_json value.endpoint));
      ]

  let to_model value =
    Models.decode Models.kb_target (Yojson.Raw.to_string (to_json value))
end

module Knowledge_base = struct
  type t = {
    id : string;
    label : string;
    endpoint : Kb_endpoint.t;
    did : string;
    last_read : Kb_read.t option;
  }

  let project fields =
    let reader = start fields in
    {
      id = required reader string "id";
      label = required reader string "label";
      endpoint = required reader Kb_endpoint.read "endpoint";
      did = required reader string "did";
      last_read = maybe reader (record Kb_read.project) "lastRead";
    }

  let of_model (model : [ `KnowledgeBase ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("label", Some (json_string value.label));
        ("endpoint", Some (Kb_endpoint.to_json value.endpoint));
        ("did", Some (json_string value.did));
        ("lastRead", Option.map Kb_read.to_json value.last_read);
      ]

  let to_model value =
    Models.decode Models.knowledge_base (Yojson.Raw.to_string (to_json value))
end

module New_knowledge_base = struct
  type t = {
    label : string;
    endpoint : Kb_endpoint.t;
    did : string;
    last_read : Kb_read.t option;
  }

  let project fields =
    let reader = start fields in
    {
      label = required reader string "label";
      endpoint = required reader Kb_endpoint.read "endpoint";
      did = required reader string "did";
      last_read = maybe reader (record Kb_read.project) "lastRead";
    }

  let of_model (model : [ `NewKnowledgeBase ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("label", Some (json_string value.label));
        ("endpoint", Some (Kb_endpoint.to_json value.endpoint));
        ("did", Some (json_string value.did));
        ("lastRead", Option.map Kb_read.to_json value.last_read);
      ]

  let to_model value =
    Models.decode Models.new_knowledge_base
      (Yojson.Raw.to_string (to_json value))
end

module Representation_added_payload = struct
  type t = { representation : Representation.t }

  let project fields =
    let reader = start fields in
    {
      representation =
        required reader (record Representation.project) "representation";
    }

  let of_model (model : [ `RepresentationAddedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("representation", Some (Representation.to_json value.representation)) ]

  let to_model value =
    Models.decode Models.representation_added_payload
      (Yojson.Raw.to_string (to_json value))
end

module Tag_schema_added_payload = struct
  type t = { schema : Tag_schema.t }

  let project fields =
    let reader = start fields in
    { schema = required reader (record Tag_schema.project) "schema" }

  let of_model (model : [ `TagSchemaAddedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("schema", Some (Tag_schema.to_json value.schema)) ]

  let to_model value =
    Models.decode Models.tag_schema_added_payload
      (Yojson.Raw.to_string (to_json value))
end

module Job_params = struct
  type t = {
    resource_id : string;
    schema : Tag_schema.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        schema = maybe reader (record Tag_schema.project) "schema";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write_open
      [
        ("resourceId", Some (json_string value.resource_id));
        ("schema", Option.map Tag_schema.to_json value.schema);
      ]
      value.extra

  let to_model value =
    Models.decode Models.job_params (Yojson.Raw.to_string (to_json value))
end

module Mark_job_create_command = struct
  module Job_type = struct
    type t = Mark

    let to_string = function Mark -> "mark"
    let of_string = function "mark" -> Some Mark | _ -> None
  end

  type t = {
    field_user_id : string option;
    field_roles : string list option;
    job_type : Job_type.t;
    resource_id : string;
    params : Mark_job_params.t;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      field_roles = maybe reader (list string) "_roles";
      job_type = required reader (enum Job_type.of_string) "jobType";
      resource_id = required reader string "resourceId";
      params = required reader Mark_job_params.read "params";
    }

  let of_model (model : [ `MarkJobCreateCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("_roles", Option.map (json_list json_string) value.field_roles);
        ("jobType", Some ((json_enum Job_type.to_string) value.job_type));
        ("resourceId", Some (json_string value.resource_id));
        ("params", Some (Mark_job_params.to_json value.params));
      ]

  let to_model value =
    Models.decode Models.mark_job_create_command
      (Yojson.Raw.to_string (to_json value))
end

module Mark_job_queued_event = struct
  module Job_type = struct
    type t = Mark

    let to_string = function Mark -> "mark"
    let of_string = function "mark" -> Some Mark | _ -> None
  end

  type t = {
    job_id : string;
    job_type : Job_type.t;
    resource_id : string;
    user_id : string;
    params : Mark_job_params.t;
  }

  let project fields =
    let reader = start fields in
    {
      job_id = required reader string "jobId";
      job_type = required reader (enum Job_type.of_string) "jobType";
      resource_id = required reader string "resourceId";
      user_id = required reader string "userId";
      params = required reader Mark_job_params.read "params";
    }

  let of_model (model : [ `MarkJobQueuedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("jobId", Some (json_string value.job_id));
        ("jobType", Some ((json_enum Job_type.to_string) value.job_type));
        ("resourceId", Some (json_string value.resource_id));
        ("userId", Some (json_string value.user_id));
        ("params", Some (Mark_job_params.to_json value.params));
      ]

  let to_model value =
    Models.decode Models.mark_job_queued_event
      (Yojson.Raw.to_string (to_json value))
end

module Mark_job_complete_command = struct
  module Job_type = struct
    type t = Mark

    let to_string = function Mark -> "mark"
    let of_string = function "mark" -> Some Mark | _ -> None
  end

  type t = {
    field_user_id : string option;
    resource_id : string;
    job_id : string;
    job_type : Job_type.t;
    attempt : int option;
    result : Mark_job_result.t option;
    durability : Enums.Durability_evidence.t option;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      resource_id = required reader string "resourceId";
      job_id = required reader string "jobId";
      job_type = required reader (enum Job_type.of_string) "jobType";
      attempt = maybe reader int "attempt";
      result = maybe reader Mark_job_result.read "result";
      durability =
        maybe reader (enum Enums.Durability_evidence.of_string) "durability";
    }

  let of_model (model : [ `MarkJobCompleteCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("resourceId", Some (json_string value.resource_id));
        ("jobId", Some (json_string value.job_id));
        ("jobType", Some ((json_enum Job_type.to_string) value.job_type));
        ("attempt", Option.map json_int value.attempt);
        ("result", Option.map Mark_job_result.to_json value.result);
        ( "durability",
          Option.map
            (json_enum Enums.Durability_evidence.to_string)
            value.durability );
      ]

  let to_model value =
    Models.decode Models.mark_job_complete_command
      (Yojson.Raw.to_string (to_json value))
end

module Yield_job_complete_command = struct
  module Job_type = struct
    type t = Yield

    let to_string = function Yield -> "yield"
    let of_string = function "yield" -> Some Yield | _ -> None
  end

  type t = {
    field_user_id : string option;
    resource_id : string;
    job_id : string;
    job_type : Job_type.t;
    attempt : int option;
    annotation_id : string option;
    result : Yield_job_result.t option;
    durability : Enums.Durability_evidence.t option;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      resource_id = required reader string "resourceId";
      job_id = required reader string "jobId";
      job_type = required reader (enum Job_type.of_string) "jobType";
      attempt = maybe reader int "attempt";
      annotation_id = maybe reader string "annotationId";
      result = maybe reader Yield_job_result.read "result";
      durability =
        maybe reader (enum Enums.Durability_evidence.of_string) "durability";
    }

  let of_model (model : [ `YieldJobCompleteCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("resourceId", Some (json_string value.resource_id));
        ("jobId", Some (json_string value.job_id));
        ("jobType", Some ((json_enum Job_type.to_string) value.job_type));
        ("attempt", Option.map json_int value.attempt);
        ("annotationId", Option.map json_string value.annotation_id);
        ("result", Option.map Yield_job_result.to_json value.result);
        ( "durability",
          Option.map
            (json_enum Enums.Durability_evidence.to_string)
            value.durability );
      ]

  let to_model value =
    Models.decode Models.yield_job_complete_command
      (Yojson.Raw.to_string (to_json value))
end

module Tag_schemas_projection = struct
  type t = { tag_schemas : Tag_schema.t list }

  let project fields =
    let reader = start fields in
    {
      tag_schemas =
        required reader (list (record Tag_schema.project)) "tagSchemas";
    }

  let of_model (model : [ `TagSchemasProjection ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("tagSchemas", Some ((json_list Tag_schema.to_json) value.tag_schemas));
      ]

  let to_model value =
    Models.decode Models.tag_schemas_projection
      (Yojson.Raw.to_string (to_json value))
end

module Archivist_events_response = struct
  type t = { events : Stored_event_response.t list; last_sequence : int }

  let project fields =
    let reader = start fields in
    {
      events =
        required reader (list (record Stored_event_response.project)) "events";
      last_sequence = required reader int "lastSequence";
    }

  let of_model (model : [ `ArchivistEventsResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("events", Some ((json_list Stored_event_response.to_json) value.events));
        ("lastSequence", Some (json_int value.last_sequence));
      ]

  let to_model value =
    Models.decode Models.archivist_events_response
      (Yojson.Raw.to_string (to_json value))
end

module Conformance_implementations = struct
  type t = {
    launcher : string list;
    target : Local_target.t;
    sdks : (string * Conformance_implementations_sdks_value.t) list;
    model_catalogue : string option;
  }

  let project fields =
    let reader = start fields in
    {
      launcher = required reader (list string) "launcher";
      target = required reader (record Local_target.project) "target";
      sdks =
        required reader
          (map (record Conformance_implementations_sdks_value.project))
          "sdks";
      model_catalogue = maybe reader string "modelCatalogue";
    }

  let of_model (model : [ `ConformanceImplementations ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("launcher", Some ((json_list json_string) value.launcher));
        ("target", Some (Local_target.to_json value.target));
        ( "sdks",
          Some
            ((json_map Conformance_implementations_sdks_value.to_json)
               value.sdks) );
        ("modelCatalogue", Option.map json_string value.model_catalogue);
      ]

  let to_model value =
    Models.decode Models.conformance_implementations
      (Yojson.Raw.to_string (to_json value))
end

module Knowledge_base_status = struct
  type t = {
    name : string;
    key : string;
    recorded : bool;
    placement : Enums.Kb_placement.t;
    root : string option;
    repo : string option;
    did : string option;
    site_name : string option;
    identity_error : string option;
    kb : Discovered_kb.t option;
    runtime : Enums.Runtime.t option;
    gateway : string option;
    secret_store : string option;
    lan : string option;
    starting : bool;
    session : Session.t option;
    healthy : bool;
    services : Service_status.t list;
    workload : Workload_status.t option;
  }

  let project fields =
    let reader = start fields in
    {
      name = required reader string "name";
      key = required reader string "key";
      recorded = required reader bool "recorded";
      placement =
        required reader (enum Enums.Kb_placement.of_string) "placement";
      root = maybe reader string "root";
      repo = maybe reader string "repo";
      did = maybe reader string "did";
      site_name = maybe reader string "siteName";
      identity_error = maybe reader string "identityError";
      kb = maybe reader (record Discovered_kb.project) "kb";
      runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
      gateway = maybe reader string "gateway";
      secret_store = maybe reader string "secretStore";
      lan = maybe reader string "lan";
      starting = required reader bool "starting";
      session = maybe reader (record Session.project) "session";
      healthy = required reader bool "healthy";
      services =
        required reader (list (record Service_status.project)) "services";
      workload = maybe reader (record Workload_status.project) "workload";
    }

  let of_model (model : [ `KnowledgeBaseStatus ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("key", Some (json_string value.key));
        ("recorded", Some (json_bool value.recorded));
        ( "placement",
          Some ((json_enum Enums.Kb_placement.to_string) value.placement) );
        ("root", Option.map json_string value.root);
        ("repo", Option.map json_string value.repo);
        ("did", Option.map json_string value.did);
        ("siteName", Option.map json_string value.site_name);
        ("identityError", Option.map json_string value.identity_error);
        ("kb", Option.map Discovered_kb.to_json value.kb);
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
        ("gateway", Option.map json_string value.gateway);
        ("secretStore", Option.map json_string value.secret_store);
        ("lan", Option.map json_string value.lan);
        ("starting", Some (json_bool value.starting));
        ("session", Option.map Session.to_json value.session);
        ("healthy", Some (json_bool value.healthy));
        ("services", Some ((json_list Service_status.to_json) value.services));
        ("workload", Option.map Workload_status.to_json value.workload);
      ]

  let to_model value =
    Models.decode Models.knowledge_base_status
      (Yojson.Raw.to_string (to_json value))
end

module Settings_list_result = struct
  type t = {
    root : string option;
    unresolved : string option;
    settings : Setting.t list;
  }

  let project fields =
    let reader = start fields in
    {
      root = maybe reader string "root";
      unresolved = maybe reader string "unresolved";
      settings = required reader (list (record Setting.project)) "settings";
    }

  let of_model (model : [ `SettingsListResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("root", Option.map json_string value.root);
        ("unresolved", Option.map json_string value.unresolved);
        ("settings", Some ((json_list Setting.to_json) value.settings));
      ]

  let to_model value =
    Models.decode Models.settings_list_result
      (Yojson.Raw.to_string (to_json value))
end

module Librarian_config = struct
  type t = {
    kb : Kb_identity.t;
    gateway_url : string;
    identity : Service_identity.t;
    archivist : Service_address.t;
    graph : Graph_config.t;
    vectors : Vectors_config.t;
    embedding : Embedding_config.t;
    matcher : Librarian_engine_config.t;
    gatherer : Librarian_engine_config.t;
    model_catalogue : string;
    gather : Librarian_config_gather.t;
    search : Librarian_config_search.t;
    port : int;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
  }

  let project fields =
    let reader = start fields in
    {
      kb = required reader (record Kb_identity.project) "kb";
      gateway_url = required reader string "gatewayUrl";
      identity = required reader (record Service_identity.project) "identity";
      archivist = required reader (record Service_address.project) "archivist";
      graph = required reader Graph_config.read "graph";
      vectors = required reader Vectors_config.read "vectors";
      embedding = required reader Embedding_config.read "embedding";
      matcher =
        required reader (record Librarian_engine_config.project) "matcher";
      gatherer =
        required reader (record Librarian_engine_config.project) "gatherer";
      model_catalogue = required reader string "modelCatalogue";
      gather = required reader (record Librarian_config_gather.project) "gather";
      search = required reader (record Librarian_config_search.project) "search";
      port = required reader int "port";
      log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
      log_format = required reader (enum Enums.Log_format.of_string) "logFormat";
    }

  let of_model (model : [ `LibrarianConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kb", Some (Kb_identity.to_json value.kb));
        ("gatewayUrl", Some (json_string value.gateway_url));
        ("identity", Some (Service_identity.to_json value.identity));
        ("archivist", Some (Service_address.to_json value.archivist));
        ("graph", Some (Graph_config.to_json value.graph));
        ("vectors", Some (Vectors_config.to_json value.vectors));
        ("embedding", Some (Embedding_config.to_json value.embedding));
        ("matcher", Some (Librarian_engine_config.to_json value.matcher));
        ("gatherer", Some (Librarian_engine_config.to_json value.gatherer));
        ("modelCatalogue", Some (json_string value.model_catalogue));
        ("gather", Some (Librarian_config_gather.to_json value.gather));
        ("search", Some (Librarian_config_search.to_json value.search));
        ("port", Some (json_int value.port));
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ( "logFormat",
          Some ((json_enum Enums.Log_format.to_string) value.log_format) );
      ]

  let to_model value =
    Models.decode Models.librarian_config (Yojson.Raw.to_string (to_json value))
end

module Smelter_config = struct
  type t = {
    kb : Kb_identity.t;
    gateway_url : string;
    identity : Service_identity.t;
    archivist : Service_address.t;
    embedding : Embedding_config.t;
    vectors : Vectors_config.t;
    chunking : Smelter_chunking.t;
    pdfs_at_once : int;
    cursors_path : string;
    port : int;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
  }

  let project fields =
    let reader = start fields in
    {
      kb = required reader (record Kb_identity.project) "kb";
      gateway_url = required reader string "gatewayUrl";
      identity = required reader (record Service_identity.project) "identity";
      archivist = required reader (record Service_address.project) "archivist";
      embedding = required reader Embedding_config.read "embedding";
      vectors = required reader Vectors_config.read "vectors";
      chunking = required reader (record Smelter_chunking.project) "chunking";
      pdfs_at_once = required reader int "pdfsAtOnce";
      cursors_path = required reader string "cursorsPath";
      port = required reader int "port";
      log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
      log_format = required reader (enum Enums.Log_format.of_string) "logFormat";
    }

  let of_model (model : [ `SmelterConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kb", Some (Kb_identity.to_json value.kb));
        ("gatewayUrl", Some (json_string value.gateway_url));
        ("identity", Some (Service_identity.to_json value.identity));
        ("archivist", Some (Service_address.to_json value.archivist));
        ("embedding", Some (Embedding_config.to_json value.embedding));
        ("vectors", Some (Vectors_config.to_json value.vectors));
        ("chunking", Some (Smelter_chunking.to_json value.chunking));
        ("pdfsAtOnce", Some (json_int value.pdfs_at_once));
        ("cursorsPath", Some (json_string value.cursors_path));
        ("port", Some (json_int value.port));
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ( "logFormat",
          Some ((json_enum Enums.Log_format.to_string) value.log_format) );
      ]

  let to_model value =
    Models.decode Models.smelter_config (Yojson.Raw.to_string (to_json value))
end

module Weaver_config = struct
  type t = {
    kb : Kb_identity.t;
    gateway_url : string;
    identity : Service_identity.t;
    archivist : Service_address.t;
    graph : Graph_config.t;
    cursors_path : string;
    port : int;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
  }

  let project fields =
    let reader = start fields in
    {
      kb = required reader (record Kb_identity.project) "kb";
      gateway_url = required reader string "gatewayUrl";
      identity = required reader (record Service_identity.project) "identity";
      archivist = required reader (record Service_address.project) "archivist";
      graph = required reader Graph_config.read "graph";
      cursors_path = required reader string "cursorsPath";
      port = required reader int "port";
      log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
      log_format = required reader (enum Enums.Log_format.of_string) "logFormat";
    }

  let of_model (model : [ `WeaverConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kb", Some (Kb_identity.to_json value.kb));
        ("gatewayUrl", Some (json_string value.gateway_url));
        ("identity", Some (Service_identity.to_json value.identity));
        ("archivist", Some (Service_address.to_json value.archivist));
        ("graph", Some (Graph_config.to_json value.graph));
        ("cursorsPath", Some (json_string value.cursors_path));
        ("port", Some (json_int value.port));
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ( "logFormat",
          Some ((json_enum Enums.Log_format.to_string) value.log_format) );
      ]

  let to_model value =
    Models.decode Models.weaver_config (Yojson.Raw.to_string (to_json value))
end

module Weaver_health = struct
  module Status = struct
    type t = Ok

    let to_string = function Ok -> "ok"
    let of_string = function "ok" -> Some Ok | _ -> None
  end

  type t = {
    status : Status.t;
    kb : string;
    following : Follower_following.t;
    reconcile : Weaver_health_reconcile.t;
  }

  let project fields =
    let reader = start fields in
    {
      status = required reader (enum Status.of_string) "status";
      kb = required reader string "kb";
      following =
        required reader (record Follower_following.project) "following";
      reconcile =
        required reader (record Weaver_health_reconcile.project) "reconcile";
    }

  let of_model (model : [ `WeaverHealth ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("kb", Some (json_string value.kb));
        ("following", Some (Follower_following.to_json value.following));
        ("reconcile", Some (Weaver_health_reconcile.to_json value.reconcile));
      ]

  let to_model value =
    Models.decode Models.weaver_health (Yojson.Raw.to_string (to_json value))
end

module Annotation_selector = struct
  type t = Selector of Selector.t | List of Selector.t list

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "type"; "start"; "end" ];
          allowed = None;
          fixed = [ ("type", [ Text_value "TextPositionSelector" ]) ];
          values = None;
        };
        {
          kind = Object_kind;
          required = [ "type"; "exact" ];
          allowed = None;
          fixed = [ ("type", [ Text_value "TextQuoteSelector" ]) ];
          values = None;
        };
        {
          kind = Object_kind;
          required = [ "type"; "value" ];
          allowed = None;
          fixed = [ ("type", [ Text_value "SvgSelector" ]) ];
          values = None;
        };
        {
          kind = Object_kind;
          required = [ "type"; "value" ];
          allowed = None;
          fixed = [ ("type", [ Text_value "FragmentSelector" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = List_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> Selector (Selector.read value)
    | 1 -> List ((list Selector.read) value)
    | _ -> assert false

  let of_model (model : [ `AnnotationSelector ] Models.t) =
    read (Models.json model)

  let to_json = function
    | Selector value -> Selector.to_json value
    | List value -> (json_list Selector.to_json) value

  let to_model value =
    Models.decode Models.annotation_selector
      (Yojson.Raw.to_string (to_json value))
end

module Annotation_bodies = struct
  type t =
    | AnnotationBody of Annotation_body.t
    | List of Annotation_body.t list

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "type"; "value" ];
          allowed = None;
          fixed =
            [
              ("type", [ Text_value "TextualBody" ]);
              ( "purpose",
                [
                  Text_value "assessing";
                  Text_value "bookmarking";
                  Text_value "classifying";
                  Text_value "commenting";
                  Text_value "describing";
                  Text_value "editing";
                  Text_value "highlighting";
                  Text_value "identifying";
                  Text_value "linking";
                  Text_value "moderating";
                  Text_value "questioning";
                  Text_value "replying";
                  Text_value "tagging";
                ] );
            ];
          values = None;
        };
        {
          kind = Object_kind;
          required = [ "type"; "source" ];
          allowed = None;
          fixed =
            [
              ("type", [ Text_value "SpecificResource" ]);
              ( "purpose",
                [
                  Text_value "assessing";
                  Text_value "bookmarking";
                  Text_value "classifying";
                  Text_value "commenting";
                  Text_value "describing";
                  Text_value "editing";
                  Text_value "highlighting";
                  Text_value "identifying";
                  Text_value "linking";
                  Text_value "moderating";
                  Text_value "questioning";
                  Text_value "replying";
                  Text_value "tagging";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = List_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> AnnotationBody (Annotation_body.read value)
    | 1 -> List ((list Annotation_body.read) value)
    | _ -> assert false

  let of_model (model : [ `AnnotationBodies ] Models.t) =
    read (Models.json model)

  let to_json = function
    | AnnotationBody value -> Annotation_body.to_json value
    | List value -> (json_list Annotation_body.to_json) value

  let to_model value =
    Models.decode Models.annotation_bodies
      (Yojson.Raw.to_string (to_json value))
end

module One_or_more_agents = struct
  type t = Agent of Agent.t | List of Agent.t list

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "@type" ];
          allowed = None;
          fixed = [ ("@type", [ Text_value "Person" ]) ];
          values = None;
        };
        {
          kind = Object_kind;
          required = [ "@type"; "name" ];
          allowed = None;
          fixed = [ ("@type", [ Text_value "Organization" ]) ];
          values = None;
        };
        {
          kind = Object_kind;
          required = [ "@type" ];
          allowed = None;
          fixed = [ ("@type", [ Text_value "Software" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = List_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> Agent (Agent.read value)
    | 1 -> List ((list Agent.read) value)
    | _ -> assert false

  let of_model (model : [ `OneOrMoreAgents ] Models.t) =
    read (Models.json model)

  let to_json = function
    | Agent value -> Agent.to_json value
    | List value -> (json_list Agent.to_json) value

  let to_model value =
    Models.decode Models.one_or_more_agents
      (Yojson.Raw.to_string (to_json value))
end

module Job_filter = struct
  type t =
    | MarkJobFilter of Mark_job_filter.t
    | YieldJobFilter of Yield_job_filter.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "jobType"; "params" ];
          allowed = Some [ "jobType"; "params" ];
          fixed = [ ("jobType", [ Text_value "mark" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "jobType" ];
          allowed = Some [ "jobType" ];
          fixed = [ ("jobType", [ Text_value "yield" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> MarkJobFilter ((record Mark_job_filter.project) value)
    | 1 -> YieldJobFilter ((record Yield_job_filter.project) value)
    | _ -> assert false

  let of_model (model : [ `JobFilter ] Models.t) = read (Models.json model)

  let to_json = function
    | MarkJobFilter value -> Mark_job_filter.to_json value
    | YieldJobFilter value -> Yield_job_filter.to_json value

  let to_model value =
    Models.decode Models.job_filter (Yojson.Raw.to_string (to_json value))
end

module Resource_descriptor_representations = struct
  type t = Representation of Representation.t | List of Representation.t list

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "mediaType" ];
          allowed = None;
          fixed =
            [
              ( "rel",
                [
                  Text_value "original";
                  Text_value "thumbnail";
                  Text_value "preview";
                  Text_value "optimized";
                  Text_value "derived";
                  Text_value "other";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = List_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> Representation ((record Representation.project) value)
    | 1 -> List ((list (record Representation.project)) value)
    | _ -> assert false

  let to_json = function
    | Representation value -> Representation.to_json value
    | List value -> (json_list Representation.to_json) value
end

module Inference_limits_result_response = struct
  type t = { limits : Engine_limits.t list }

  let project fields =
    let reader = start fields in
    { limits = required reader (list (record Engine_limits.project)) "limits" }

  let to_json (value : t) =
    write [ ("limits", Some ((json_list Engine_limits.to_json) value.limits)) ]
end

module Job_stored_result = struct
  type t = JobResult of Job_result.t | Empty of (string * Yojson.Raw.t) list

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "found"; "persisted" ];
          allowed =
            Some
              [
                "found";
                "persisted";
                "errors";
                "byCategory";
                "underReportedPieces";
                "uncheckedPieces";
              ];
          fixed = [];
          values = None;
        };
        {
          kind = Object_kind;
          required = [ "resourceId"; "resourceName"; "truncated" ];
          allowed = Some [ "resourceId"; "resourceName"; "truncated" ];
          fixed = [];
          values = None;
        };
        {
          kind = Object_kind;
          required = [ "declined"; "reason" ];
          allowed = Some [ "declined"; "reason" ];
          fixed =
            [
              ("declined", [ Boolean_value true ]);
              ( "reason",
                [
                  Text_value "no-text-layer";
                  Text_value "encrypted";
                  Text_value "corrupt";
                  Text_value "too-large";
                  Text_value "empty";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [];
          allowed = Some [];
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> JobResult (Job_result.read value)
    | 1 -> Empty ((map raw) value)
    | _ -> assert false

  let of_model (model : [ `JobStoredResult ] Models.t) =
    read (Models.json model)

  let to_json = function
    | JobResult value -> Job_result.to_json value
    | Empty value -> (json_map json_raw) value

  let to_model value =
    Models.decode Models.job_stored_result
      (Yojson.Raw.to_string (to_json value))
end

module Archivist_engines_jobs = struct
  type t = {
    mark : Archivist_engines_jobs_mark.t option;
    yield : Engine.t option;
  }

  let project fields =
    let reader = start fields in
    {
      mark = maybe reader (record Archivist_engines_jobs_mark.project) "mark";
      yield = maybe reader (record Engine.project) "yield";
    }

  let to_json (value : t) =
    write
      [
        ("mark", Option.map Archivist_engines_jobs_mark.to_json value.mark);
        ("yield", Option.map Engine.to_json value.yield);
      ]
end

module Anchored_text_entry = struct
  type t =
    | AnchoredTextExtractedEntry of Anchored_text_extracted_entry.t
    | AnchoredTextDeclinedEntry of Anchored_text_declined_entry.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "v"; "stamp"; "text"; "lines"; "method" ];
          allowed =
            Some
              [
                "v";
                "stamp";
                "text";
                "lines";
                "method";
                "pdfClass";
                "ocrConfidence";
                "unreadPages";
              ];
          fixed =
            [
              ("v", [ Integer_value 3 ]);
              ( "method",
                [
                  Text_value "text-passthrough";
                  Text_value "pdf-text-layer";
                  Text_value "table";
                  Text_value "form";
                  Text_value "ocr";
                ] );
              ( "pdfClass",
                [
                  Text_value "A";
                  Text_value "B";
                  Text_value "C";
                  Text_value "D";
                  Text_value "E";
                  Text_value "F";
                  Text_value "G";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "v"; "stamp"; "declined" ];
          allowed = Some [ "v"; "stamp"; "declined" ];
          fixed =
            [
              ("v", [ Integer_value 3 ]);
              ( "declined",
                [
                  Text_value "no-text-layer";
                  Text_value "encrypted";
                  Text_value "corrupt";
                  Text_value "too-large";
                ] );
            ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 ->
        AnchoredTextExtractedEntry
          ((record Anchored_text_extracted_entry.project) value)
    | 1 ->
        AnchoredTextDeclinedEntry
          ((record Anchored_text_declined_entry.project) value)
    | _ -> assert false

  let of_model (model : [ `AnchoredTextEntry ] Models.t) =
    read (Models.json model)

  let to_json = function
    | AnchoredTextExtractedEntry value ->
        Anchored_text_extracted_entry.to_json value
    | AnchoredTextDeclinedEntry value ->
        Anchored_text_declined_entry.to_json value

  let to_model value =
    Models.decode Models.anchored_text_entry
      (Yojson.Raw.to_string (to_json value))
end

module Conformance_step_fetches = struct
  type t = { fetches : Conformance_step_fetches_fetches_item.t list }

  let project fields =
    let reader = start fields in
    {
      fetches =
        required reader
          (list Conformance_step_fetches_fetches_item.read)
          "fetches";
    }

  let to_json (value : t) =
    write
      [
        ( "fetches",
          Some
            ((json_list Conformance_step_fetches_fetches_item.to_json)
               value.fetches) );
      ]
end

module Smelter_health_index = struct
  type t = { stamp : Smelter_health_index_stamp.t; made_anew : bool }

  let project fields =
    let reader = start fields in
    {
      stamp =
        required reader (record Smelter_health_index_stamp.project) "stamp";
      made_anew = required reader bool "madeAnew";
    }

  let to_json (value : t) =
    write
      [
        ("stamp", Some (Smelter_health_index_stamp.to_json value.stamp));
        ("madeAnew", Some (json_bool value.made_anew));
      ]
end

module Browser_spec = struct
  type t = { image : string; resources : Resources.t; port : int }

  let project fields =
    let reader = start fields in
    {
      image = required reader string "image";
      resources = required reader (record Resources.project) "resources";
      port = required reader int "port";
    }

  let to_json (value : t) =
    write
      [
        ("image", Some (json_string value.image));
        ("resources", Some (Resources.to_json value.resources));
        ("port", Some (json_int value.port));
      ]
end

module Issuer_spec_database = struct
  type t = {
    type_ : string;
    name : string;
    user : string;
    image : string option;
    resources : Resources.t option;
    port : int option;
    external_ : Issuer_spec_database_external.t option;
  }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader string "type";
      name = required reader string "name";
      user = required reader string "user";
      image = maybe reader string "image";
      resources = maybe reader (record Resources.project) "resources";
      port = maybe reader int "port";
      external_ =
        maybe reader (record Issuer_spec_database_external.project) "external";
    }

  let to_json (value : t) =
    write
      [
        ("type", Some (json_string value.type_));
        ("name", Some (json_string value.name));
        ("user", Some (json_string value.user));
        ("image", Option.map json_string value.image);
        ("resources", Option.map Resources.to_json value.resources);
        ("port", Option.map json_int value.port);
        ( "external",
          Option.map Issuer_spec_database_external.to_json value.external_ );
      ]
end

module Knowledge_index_spec_graph = struct
  type t = {
    type_ : string;
    username : string;
    image : string option;
    resources : Resources.t option;
    external_ : Knowledge_index_spec_graph_external.t option;
  }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader string "type";
      username = required reader string "username";
      image = maybe reader string "image";
      resources = maybe reader (record Resources.project) "resources";
      external_ =
        maybe reader
          (record Knowledge_index_spec_graph_external.project)
          "external";
    }

  let to_json (value : t) =
    write
      [
        ("type", Some (json_string value.type_));
        ("username", Some (json_string value.username));
        ("image", Option.map json_string value.image);
        ("resources", Option.map Resources.to_json value.resources);
        ( "external",
          Option.map Knowledge_index_spec_graph_external.to_json value.external_
        );
      ]
end

module Knowledge_index_spec_vectors = struct
  type t = {
    type_ : string;
    shared : (string * Yojson.Raw.t) list option;
    image : string option;
    resources : Resources.t option;
    external_ : Knowledge_index_spec_vectors_external.t option;
  }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader string "type";
      shared = maybe reader (map raw) "shared";
      image = maybe reader string "image";
      resources = maybe reader (record Resources.project) "resources";
      external_ =
        maybe reader
          (record Knowledge_index_spec_vectors_external.project)
          "external";
    }

  let to_json (value : t) =
    write
      [
        ("type", Some (json_string value.type_));
        ("shared", Option.map (json_map json_raw) value.shared);
        ("image", Option.map json_string value.image);
        ("resources", Option.map Resources.to_json value.resources);
        ( "external",
          Option.map Knowledge_index_spec_vectors_external.to_json
            value.external_ );
      ]
end

module Knowledge_index_spec_librarian = struct
  type t = {
    image : string;
    resources : Resources.t;
    gather : Knowledge_index_spec_librarian_gather.t;
    search : Knowledge_index_spec_librarian_search.t;
  }

  let project fields =
    let reader = start fields in
    {
      image = required reader string "image";
      resources = required reader (record Resources.project) "resources";
      gather =
        required reader
          (record Knowledge_index_spec_librarian_gather.project)
          "gather";
      search =
        required reader
          (record Knowledge_index_spec_librarian_search.project)
          "search";
    }

  let to_json (value : t) =
    write
      [
        ("image", Some (json_string value.image));
        ("resources", Some (Resources.to_json value.resources));
        ( "gather",
          Some (Knowledge_index_spec_librarian_gather.to_json value.gather) );
        ( "search",
          Some (Knowledge_index_spec_librarian_search.to_json value.search) );
      ]
end

module Knowledge_index_spec_smelter = struct
  type t = { image : string; resources : Resources.t; pdfs_at_once : int }

  let project fields =
    let reader = start fields in
    {
      image = required reader string "image";
      resources = required reader (record Resources.project) "resources";
      pdfs_at_once = required reader int "pdfsAtOnce";
    }

  let to_json (value : t) =
    write
      [
        ("image", Some (json_string value.image));
        ("resources", Some (Resources.to_json value.resources));
        ("pdfsAtOnce", Some (json_int value.pdfs_at_once));
      ]
end

module Knowledge_index_spec_weaver = struct
  type t = { image : string; resources : Resources.t }

  let project fields =
    let reader = start fields in
    {
      image = required reader string "image";
      resources = required reader (record Resources.project) "resources";
    }

  let to_json (value : t) =
    write
      [
        ("image", Some (json_string value.image));
        ("resources", Some (Resources.to_json value.resources));
      ]
end

module Stack_knowledge_base_spec_gateway = struct
  type t = {
    image : string;
    resources : Resources.t;
    port : int;
    public_url : string;
  }

  let project fields =
    let reader = start fields in
    {
      image = required reader string "image";
      resources = required reader (record Resources.project) "resources";
      port = required reader int "port";
      public_url = required reader string "publicURL";
    }

  let to_json (value : t) =
    write
      [
        ("image", Some (json_string value.image));
        ("resources", Some (Resources.to_json value.resources));
        ("port", Some (json_int value.port));
        ("publicURL", Some (json_string value.public_url));
      ]
end

module Stack_knowledge_base_spec_dispatcher = struct
  type t = { image : string; resources : Resources.t }

  let project fields =
    let reader = start fields in
    {
      image = required reader string "image";
      resources = required reader (record Resources.project) "resources";
    }

  let to_json (value : t) =
    write
      [
        ("image", Some (json_string value.image));
        ("resources", Some (Resources.to_json value.resources));
      ]
end

module Stack_knowledge_base_spec_archivist = struct
  type t = {
    image : string;
    resources : Resources.t;
    address : Host_port.t option;
  }

  let project fields =
    let reader = start fields in
    {
      image = required reader string "image";
      resources = required reader (record Resources.project) "resources";
      address = maybe reader (record Host_port.project) "address";
    }

  let to_json (value : t) =
    write
      [
        ("image", Some (json_string value.image));
        ("resources", Some (Resources.to_json value.resources));
        ("address", Option.map Host_port.to_json value.address);
      ]
end

module Stack_knowledge_base_spec_messaging = struct
  type t = {
    jobs : Stack_knowledge_base_spec_messaging_jobs.t;
    signal : Stack_knowledge_base_spec_messaging_signal.t;
    image : string option;
    resources : Resources.t option;
    external_ : Stack_knowledge_base_spec_messaging_external.t option;
  }

  let project fields =
    let reader = start fields in
    {
      jobs =
        required reader
          (record Stack_knowledge_base_spec_messaging_jobs.project)
          "jobs";
      signal =
        required reader
          (record Stack_knowledge_base_spec_messaging_signal.project)
          "signal";
      image = maybe reader string "image";
      resources = maybe reader (record Resources.project) "resources";
      external_ =
        maybe reader
          (record Stack_knowledge_base_spec_messaging_external.project)
          "external";
    }

  let to_json (value : t) =
    write
      [
        ( "jobs",
          Some (Stack_knowledge_base_spec_messaging_jobs.to_json value.jobs) );
        ( "signal",
          Some (Stack_knowledge_base_spec_messaging_signal.to_json value.signal)
        );
        ("image", Option.map json_string value.image);
        ("resources", Option.map Resources.to_json value.resources);
        ( "external",
          Option.map Stack_knowledge_base_spec_messaging_external.to_json
            value.external_ );
      ]
end

module Vector_store_spec = struct
  type t = {
    type_ : string;
    image : string;
    resources : Resources.t;
    port : int;
  }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader string "type";
      image = required reader string "image";
      resources = required reader (record Resources.project) "resources";
      port = required reader int "port";
    }

  let to_json (value : t) =
    write
      [
        ("type", Some (json_string value.type_));
        ("image", Some (json_string value.image));
        ("resources", Some (Resources.to_json value.resources));
        ("port", Some (json_int value.port));
      ]
end

module Worker_pool_spec_worker = struct
  type t = { image : string; resources : Resources.t }

  let project fields =
    let reader = start fields in
    {
      image = required reader string "image";
      resources = required reader (record Resources.project) "resources";
    }

  let to_json (value : t) =
    write
      [
        ("image", Some (json_string value.image));
        ("resources", Some (Resources.to_json value.resources));
      ]
end

module Anchored_text_answer = struct
  type t =
    | ExtractedText of Extracted_text.t
    | ExtractionDeclined of Extraction_declined.t
    | AnchoredTextAbsent of Anchored_text_absent.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "text"; "items"; "kind"; "method" ];
          allowed = None;
          fixed =
            [
              ("kind", [ Text_value "extracted" ]);
              ( "method",
                [
                  Text_value "text-passthrough";
                  Text_value "pdf-text-layer";
                  Text_value "table";
                  Text_value "form";
                  Text_value "ocr";
                ] );
              ( "pdfClass",
                [
                  Text_value "A";
                  Text_value "B";
                  Text_value "C";
                  Text_value "D";
                  Text_value "E";
                  Text_value "F";
                  Text_value "G";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "kind"; "declined" ];
          allowed = None;
          fixed =
            [
              ("kind", [ Text_value "declined" ]);
              ( "declined",
                [
                  Text_value "no-text-layer";
                  Text_value "encrypted";
                  Text_value "corrupt";
                  Text_value "too-large";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "kind" ];
          allowed = None;
          fixed =
            [
              ( "kind",
                [
                  Text_value "not-yet";
                  Text_value "no-map";
                  Text_value "unknown";
                ] );
            ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> ExtractedText ((record Extracted_text.project) value)
    | 1 -> ExtractionDeclined ((record Extraction_declined.project) value)
    | 2 -> AnchoredTextAbsent ((record Anchored_text_absent.project) value)
    | _ -> assert false

  let of_model (model : [ `AnchoredTextAnswer ] Models.t) =
    read (Models.json model)

  let to_json = function
    | ExtractedText value -> Extracted_text.to_json value
    | ExtractionDeclined value -> Extraction_declined.to_json value
    | AnchoredTextAbsent value -> Anchored_text_absent.to_json value

  let to_model value =
    Models.decode Models.anchored_text_answer
      (Yojson.Raw.to_string (to_json value))
end

module Extraction_outcome = struct
  type t =
    | ExtractedText of Extracted_text.t
    | ExtractionDeclined of Extraction_declined.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "text"; "items"; "kind"; "method" ];
          allowed = None;
          fixed =
            [
              ("kind", [ Text_value "extracted" ]);
              ( "method",
                [
                  Text_value "text-passthrough";
                  Text_value "pdf-text-layer";
                  Text_value "table";
                  Text_value "form";
                  Text_value "ocr";
                ] );
              ( "pdfClass",
                [
                  Text_value "A";
                  Text_value "B";
                  Text_value "C";
                  Text_value "D";
                  Text_value "E";
                  Text_value "F";
                  Text_value "G";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "kind"; "declined" ];
          allowed = None;
          fixed =
            [
              ("kind", [ Text_value "declined" ]);
              ( "declined",
                [
                  Text_value "no-text-layer";
                  Text_value "encrypted";
                  Text_value "corrupt";
                  Text_value "too-large";
                ] );
            ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> ExtractedText ((record Extracted_text.project) value)
    | 1 -> ExtractionDeclined ((record Extraction_declined.project) value)
    | _ -> assert false

  let of_model (model : [ `ExtractionOutcome ] Models.t) =
    read (Models.json model)

  let to_json = function
    | ExtractedText value -> Extracted_text.to_json value
    | ExtractionDeclined value -> Extraction_declined.to_json value

  let to_model value =
    Models.decode Models.extraction_outcome
      (Yojson.Raw.to_string (to_json value))
end

module Bus_stream_message = struct
  type t =
    | BusEventMessage of Bus_event_message.t
    | BusPingMessage of Bus_ping_message.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "event"; "id"; "data" ];
          allowed = Some [ "event"; "id"; "data" ];
          fixed = [ ("event", [ Text_value "bus-event" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "event"; "data" ];
          allowed = Some [ "event"; "data" ];
          fixed = [ ("event", [ Text_value "ping" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> BusEventMessage ((record Bus_event_message.project) value)
    | 1 -> BusPingMessage ((record Bus_ping_message.project) value)
    | _ -> assert false

  let of_model (model : [ `BusStreamMessage ] Models.t) =
    read (Models.json model)

  let to_json = function
    | BusEventMessage value -> Bus_event_message.to_json value
    | BusPingMessage value -> Bus_ping_message.to_json value

  let to_model value =
    Models.decode Models.bus_stream_message
      (Yojson.Raw.to_string (to_json value))
end

module Conformance_driver_line_emission_emission_state = struct
  type t =
    | Pending of Conformance_driver_line_emission_emission_state_pending.t
    | Ready of Conformance_driver_line_emission_emission_state_ready.t
    | Failed of Conformance_driver_line_emission_emission_state_failed.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "status" ];
          allowed = Some [ "status" ];
          fixed = [ ("status", [ Text_value "pending" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "status"; "value" ];
          allowed = Some [ "status"; "value" ];
          fixed = [ ("status", [ Text_value "ready" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "status"; "error" ];
          allowed = Some [ "status"; "error" ];
          fixed = [ ("status", [ Text_value "failed" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 ->
        Pending
          ((record
              Conformance_driver_line_emission_emission_state_pending.project)
             value)
    | 1 ->
        Ready
          ((record Conformance_driver_line_emission_emission_state_ready.project)
             value)
    | 2 ->
        Failed
          ((record
              Conformance_driver_line_emission_emission_state_failed.project)
             value)
    | _ -> assert false

  let to_json = function
    | Pending value ->
        Conformance_driver_line_emission_emission_state_pending.to_json value
    | Ready value ->
        Conformance_driver_line_emission_emission_state_ready.to_json value
    | Failed value ->
        Conformance_driver_line_emission_emission_state_failed.to_json value
end

module Annotation_target = struct
  module Type_ = struct
    type t = SpecificResource

    let to_string = function SpecificResource -> "SpecificResource"

    let of_string = function
      | "SpecificResource" -> Some SpecificResource
      | _ -> None
  end

  type t = {
    type_ : Type_.t option;
    source : string;
    selector : Annotation_selector.t option;
  }

  let project fields =
    let reader = start fields in
    {
      type_ = maybe reader (enum Type_.of_string) "type";
      source = required reader string "source";
      selector = maybe reader Annotation_selector.read "selector";
    }

  let of_model (model : [ `AnnotationTarget ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Option.map (json_enum Type_.to_string) value.type_);
        ("source", Some (json_string value.source));
        ("selector", Option.map Annotation_selector.to_json value.selector);
      ]

  let to_model value =
    Models.decode Models.annotation_target
      (Yojson.Raw.to_string (to_json value))
end

module Bind_update_body_command = struct
  type t = {
    field_user_id : string option;
    annotation_id : string;
    resource_id : string;
    operations : Bind_body_operation.t list;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      annotation_id = required reader string "annotationId";
      resource_id = required reader string "resourceId";
      operations =
        required reader (list (record Bind_body_operation.project)) "operations";
    }

  let of_model (model : [ `BindUpdateBodyCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("annotationId", Some (json_string value.annotation_id));
        ("resourceId", Some (json_string value.resource_id));
        ( "operations",
          Some ((json_list Bind_body_operation.to_json) value.operations) );
      ]

  let to_model value =
    Models.decode Models.bind_update_body_command
      (Yojson.Raw.to_string (to_json value))
end

module Browse_directory_result = struct
  type t = { response : Browse_directory_result_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader
          (record Browse_directory_result_response.project)
          "response";
    }

  let of_model (model : [ `BrowseDirectoryResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "response",
          Some (Browse_directory_result_response.to_json value.response) );
      ]

  let to_model value =
    Models.decode Models.browse_directory_result
      (Yojson.Raw.to_string (to_json value))
end

module Browse_tag_schemas_result = struct
  type t = { response : Get_tag_schemas_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader (record Get_tag_schemas_response.project) "response";
    }

  let of_model (model : [ `BrowseTagSchemasResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Get_tag_schemas_response.to_json value.response)) ]

  let to_model value =
    Models.decode Models.browse_tag_schemas_result
      (Yojson.Raw.to_string (to_json value))
end

module Engine_entry = struct
  type t = { engine : Engine.t; jobs : Job_filter.t list option }

  let project fields =
    let reader = start fields in
    {
      engine = required reader (record Engine.project) "engine";
      jobs = maybe reader (list Job_filter.read) "jobs";
    }

  let of_model (model : [ `EngineEntry ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("engine", Some (Engine.to_json value.engine));
        ("jobs", Option.map (json_list Job_filter.to_json) value.jobs);
      ]

  let to_model value =
    Models.decode Models.engine_entry (Yojson.Raw.to_string (to_json value))
end

module Get_annotation_history_response = struct
  type t = {
    events : Attributed_event.t list;
    total : float;
    annotation_id : string;
    resource_id : string;
  }

  let project fields =
    let reader = start fields in
    {
      events = required reader (list (record Attributed_event.project)) "events";
      total = required reader float "total";
      annotation_id = required reader string "annotationId";
      resource_id = required reader string "resourceId";
    }

  let of_model (model : [ `GetAnnotationHistoryResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("events", Some ((json_list Attributed_event.to_json) value.events));
        ("total", Some (json_float value.total));
        ("annotationId", Some (json_string value.annotation_id));
        ("resourceId", Some (json_string value.resource_id));
      ]

  let to_model value =
    Models.decode Models.get_annotation_history_response
      (Yojson.Raw.to_string (to_json value))
end

module Get_events_response = struct
  type t = {
    events : Attributed_event.t list;
    total : float;
    resource_id : string;
  }

  let project fields =
    let reader = start fields in
    {
      events = required reader (list (record Attributed_event.project)) "events";
      total = required reader float "total";
      resource_id = required reader string "resourceId";
    }

  let of_model (model : [ `GetEventsResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("events", Some ((json_list Attributed_event.to_json) value.events));
        ("total", Some (json_float value.total));
        ("resourceId", Some (json_string value.resource_id));
      ]

  let to_model value =
    Models.decode Models.get_events_response
      (Yojson.Raw.to_string (to_json value))
end

module Get_referenced_by_response = struct
  type t = {
    referenced_by : Get_referenced_by_response_referenced_by_item.t list;
  }

  let project fields =
    let reader = start fields in
    {
      referenced_by =
        required reader
          (list (record Get_referenced_by_response_referenced_by_item.project))
          "referencedBy";
    }

  let of_model (model : [ `GetReferencedByResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "referencedBy",
          Some
            ((json_list Get_referenced_by_response_referenced_by_item.to_json)
               value.referenced_by) );
      ]

  let to_model value =
    Models.decode Models.get_referenced_by_response
      (Yojson.Raw.to_string (to_json value))
end

module Inference_limits_result = struct
  type t = { response : Inference_limits_result_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader
          (record Inference_limits_result_response.project)
          "response";
    }

  let of_model (model : [ `InferenceLimitsResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "response",
          Some (Inference_limits_result_response.to_json value.response) );
      ]

  let to_model value =
    Models.decode Models.inference_limits_result
      (Yojson.Raw.to_string (to_json value))
end

module Job_claim_command = struct
  type t = {
    accepts : Job_filter.t list;
    field_user_id : string option;
    field_roles : string list option;
  }

  let project fields =
    let reader = start fields in
    {
      accepts = required reader (list Job_filter.read) "accepts";
      field_user_id = maybe reader string "_userId";
      field_roles = maybe reader (list string) "_roles";
    }

  let of_model (model : [ `JobClaimCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("accepts", Some ((json_list Job_filter.to_json) value.accepts));
        ("_userId", Option.map json_string value.field_user_id);
        ("_roles", Option.map (json_list json_string) value.field_roles);
      ]

  let to_model value =
    Models.decode Models.job_claim_command
      (Yojson.Raw.to_string (to_json value))
end

module Job_report_progress_command = struct
  type t = {
    field_user_id : string option;
    resource_id : string;
    job_id : string;
    job_type : Enums.Job_type.t;
    attempt : int option;
    annotation_id : string option;
    percentage : float;
    progress : Job_progress.t option;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      resource_id = required reader string "resourceId";
      job_id = required reader string "jobId";
      job_type = required reader (enum Enums.Job_type.of_string) "jobType";
      attempt = maybe reader int "attempt";
      annotation_id = maybe reader string "annotationId";
      percentage = required reader float "percentage";
      progress = maybe reader (record Job_progress.project) "progress";
    }

  let of_model (model : [ `JobReportProgressCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("resourceId", Some (json_string value.resource_id));
        ("jobId", Some (json_string value.job_id));
        ("jobType", Some ((json_enum Enums.Job_type.to_string) value.job_type));
        ("attempt", Option.map json_int value.attempt);
        ("annotationId", Option.map json_string value.annotation_id);
        ("percentage", Some (json_float value.percentage));
        ("progress", Option.map Job_progress.to_json value.progress);
      ]

  let to_model value =
    Models.decode Models.job_report_progress_command
      (Yojson.Raw.to_string (to_json value))
end

module Mark_requested_event = struct
  type t = {
    source : string;
    selector : Annotation_selector.t;
    motivation : Enums.Motivation.t;
  }

  let project fields =
    let reader = start fields in
    {
      source = required reader string "source";
      selector = required reader Annotation_selector.read "selector";
      motivation =
        required reader (enum Enums.Motivation.of_string) "motivation";
    }

  let of_model (model : [ `MarkRequestedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("source", Some (json_string value.source));
        ("selector", Some (Annotation_selector.to_json value.selector));
        ( "motivation",
          Some ((json_enum Enums.Motivation.to_string) value.motivation) );
      ]

  let to_model value =
    Models.decode Models.mark_requested_event
      (Yojson.Raw.to_string (to_json value))
end

module Mark_submit_event = struct
  type t = {
    source : string;
    motivation : Enums.Motivation.t;
    selector : Annotation_selector.t;
    body : Annotation_bodies.t option;
  }

  let project fields =
    let reader = start fields in
    {
      source = required reader string "source";
      motivation =
        required reader (enum Enums.Motivation.of_string) "motivation";
      selector = required reader Annotation_selector.read "selector";
      body = maybe reader Annotation_bodies.read "body";
    }

  let of_model (model : [ `MarkSubmitEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("source", Some (json_string value.source));
        ( "motivation",
          Some ((json_enum Enums.Motivation.to_string) value.motivation) );
        ("selector", Some (Annotation_selector.to_json value.selector));
        ("body", Option.map Annotation_bodies.to_json value.body);
      ]

  let to_model value =
    Models.decode Models.mark_submit_event
      (Yojson.Raw.to_string (to_json value))
end

module Resource_cloned_payload = struct
  type t = {
    name : string;
    format : string;
    content_checksum : string;
    content_byte_size : int option;
    storage_uri : string option;
    parent_resource_id : string;
    entity_types : string list option;
    language : string option;
    creator : Agent.t option;
    was_attributed_to : One_or_more_agents.t option;
  }

  let project fields =
    let reader = start fields in
    {
      name = required reader string "name";
      format = required reader string "format";
      content_checksum = required reader string "contentChecksum";
      content_byte_size = maybe reader int "contentByteSize";
      storage_uri = maybe reader string "storageUri";
      parent_resource_id = required reader string "parentResourceId";
      entity_types = maybe reader (list string) "entityTypes";
      language = maybe reader string "language";
      creator = maybe reader Agent.read "creator";
      was_attributed_to = maybe reader One_or_more_agents.read "wasAttributedTo";
    }

  let of_model (model : [ `ResourceClonedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("format", Some (json_string value.format));
        ("contentChecksum", Some (json_string value.content_checksum));
        ("contentByteSize", Option.map json_int value.content_byte_size);
        ("storageUri", Option.map json_string value.storage_uri);
        ("parentResourceId", Some (json_string value.parent_resource_id));
        ("entityTypes", Option.map (json_list json_string) value.entity_types);
        ("language", Option.map json_string value.language);
        ("creator", Option.map Agent.to_json value.creator);
        ( "wasAttributedTo",
          Option.map One_or_more_agents.to_json value.was_attributed_to );
      ]

  let to_model value =
    Models.decode Models.resource_cloned_payload
      (Yojson.Raw.to_string (to_json value))
end

module Resource_created_payload = struct
  type t = {
    name : string;
    format : string;
    content_checksum : string;
    content_byte_size : int option;
    entity_types : string list option;
    storage_uri : string option;
    language : string option;
    is_draft : bool option;
    job_id : string option;
    generated_from : Resource_created_payload_generated_from.t option;
    generation_prompt : string option;
    generator : One_or_more_agents.t option;
    creator : Agent.t option;
    was_attributed_to : One_or_more_agents.t option;
  }

  let project fields =
    let reader = start fields in
    {
      name = required reader string "name";
      format = required reader string "format";
      content_checksum = required reader string "contentChecksum";
      content_byte_size = maybe reader int "contentByteSize";
      entity_types = maybe reader (list string) "entityTypes";
      storage_uri = maybe reader string "storageUri";
      language = maybe reader string "language";
      is_draft = maybe reader bool "isDraft";
      job_id = maybe reader string "jobId";
      generated_from =
        maybe reader
          (record Resource_created_payload_generated_from.project)
          "generatedFrom";
      generation_prompt = maybe reader string "generationPrompt";
      generator = maybe reader One_or_more_agents.read "generator";
      creator = maybe reader Agent.read "creator";
      was_attributed_to = maybe reader One_or_more_agents.read "wasAttributedTo";
    }

  let of_model (model : [ `ResourceCreatedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("format", Some (json_string value.format));
        ("contentChecksum", Some (json_string value.content_checksum));
        ("contentByteSize", Option.map json_int value.content_byte_size);
        ("entityTypes", Option.map (json_list json_string) value.entity_types);
        ("storageUri", Option.map json_string value.storage_uri);
        ("language", Option.map json_string value.language);
        ("isDraft", Option.map json_bool value.is_draft);
        ("jobId", Option.map json_string value.job_id);
        ( "generatedFrom",
          Option.map Resource_created_payload_generated_from.to_json
            value.generated_from );
        ("generationPrompt", Option.map json_string value.generation_prompt);
        ("generator", Option.map One_or_more_agents.to_json value.generator);
        ("creator", Option.map Agent.to_json value.creator);
        ( "wasAttributedTo",
          Option.map One_or_more_agents.to_json value.was_attributed_to );
      ]

  let to_model value =
    Models.decode Models.resource_created_payload
      (Yojson.Raw.to_string (to_json value))
end

module Resource_descriptor = struct
  type t = {
    field_context : Resource_descriptor_context.t;
    field_id : string;
    field_type : One_or_more_strings.t option;
    name : string;
    description : string option;
    identifier : Resource_descriptor_identifier.t option;
    about : One_or_more_strings.t option;
    same_as : string list option;
    is_part_of : string list option;
    has_part : string list option;
    license : string option;
    version : string option;
    date_created : string option;
    date_modified : string option;
    was_derived_from : Resource_descriptor_was_derived_from.t option;
    was_attributed_to : One_or_more_agents.t option;
    generator : One_or_more_agents.t option;
    conforms_to : One_or_more_uris.t option;
    available_formats : string list option;
    representations : Resource_descriptor_representations.t;
    archived : bool option;
    entity_types : string list option;
    is_draft : bool option;
    source_annotation_id : string option;
    source_resource_id : string option;
    originated_from : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_context =
          required reader Resource_descriptor_context.read "@context";
        field_id = required reader string "@id";
        field_type = maybe reader One_or_more_strings.read "@type";
        name = required reader string "name";
        description = maybe reader string "description";
        identifier =
          maybe reader Resource_descriptor_identifier.read "identifier";
        about = maybe reader One_or_more_strings.read "about";
        same_as = maybe reader (list string) "sameAs";
        is_part_of = maybe reader (list string) "isPartOf";
        has_part = maybe reader (list string) "hasPart";
        license = maybe reader string "license";
        version = maybe reader string "version";
        date_created = maybe reader string "dateCreated";
        date_modified = maybe reader string "dateModified";
        was_derived_from =
          maybe reader Resource_descriptor_was_derived_from.read
            "wasDerivedFrom";
        was_attributed_to =
          maybe reader One_or_more_agents.read "wasAttributedTo";
        generator = maybe reader One_or_more_agents.read "generator";
        conforms_to = maybe reader One_or_more_uris.read "conformsTo";
        available_formats = maybe reader (list string) "availableFormats";
        representations =
          required reader Resource_descriptor_representations.read
            "representations";
        archived = maybe reader bool "archived";
        entity_types = maybe reader (list string) "entityTypes";
        is_draft = maybe reader bool "isDraft";
        source_annotation_id = maybe reader string "sourceAnnotationId";
        source_resource_id = maybe reader string "sourceResourceId";
        originated_from = maybe reader string "originatedFrom";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceDescriptor ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write_open
      [
        ( "@context",
          Some (Resource_descriptor_context.to_json value.field_context) );
        ("@id", Some (json_string value.field_id));
        ("@type", Option.map One_or_more_strings.to_json value.field_type);
        ("name", Some (json_string value.name));
        ("description", Option.map json_string value.description);
        ( "identifier",
          Option.map Resource_descriptor_identifier.to_json value.identifier );
        ("about", Option.map One_or_more_strings.to_json value.about);
        ("sameAs", Option.map (json_list json_string) value.same_as);
        ("isPartOf", Option.map (json_list json_string) value.is_part_of);
        ("hasPart", Option.map (json_list json_string) value.has_part);
        ("license", Option.map json_string value.license);
        ("version", Option.map json_string value.version);
        ("dateCreated", Option.map json_string value.date_created);
        ("dateModified", Option.map json_string value.date_modified);
        ( "wasDerivedFrom",
          Option.map Resource_descriptor_was_derived_from.to_json
            value.was_derived_from );
        ( "wasAttributedTo",
          Option.map One_or_more_agents.to_json value.was_attributed_to );
        ("generator", Option.map One_or_more_agents.to_json value.generator);
        ("conformsTo", Option.map One_or_more_uris.to_json value.conforms_to);
        ( "availableFormats",
          Option.map (json_list json_string) value.available_formats );
        ( "representations",
          Some
            (Resource_descriptor_representations.to_json value.representations)
        );
        ("archived", Option.map json_bool value.archived);
        ("entityTypes", Option.map (json_list json_string) value.entity_types);
        ("isDraft", Option.map json_bool value.is_draft);
        ("sourceAnnotationId", Option.map json_string value.source_annotation_id);
        ("sourceResourceId", Option.map json_string value.source_resource_id);
        ("originatedFrom", Option.map json_string value.originated_from);
      ]
      value.extra

  let to_model value =
    Models.decode Models.resource_descriptor
      (Yojson.Raw.to_string (to_json value))
end

module Scored_resource = struct
  type t = {
    field_context : Resource_descriptor_context.t;
    field_id : string;
    field_type : One_or_more_strings.t option;
    name : string;
    description : string option;
    identifier : Resource_descriptor_identifier.t option;
    about : One_or_more_strings.t option;
    same_as : string list option;
    is_part_of : string list option;
    has_part : string list option;
    license : string option;
    version : string option;
    date_created : string option;
    date_modified : string option;
    was_derived_from : Resource_descriptor_was_derived_from.t option;
    was_attributed_to : One_or_more_agents.t option;
    generator : One_or_more_agents.t option;
    conforms_to : One_or_more_uris.t option;
    available_formats : string list option;
    representations : Resource_descriptor_representations.t;
    archived : bool option;
    entity_types : string list option;
    is_draft : bool option;
    source_annotation_id : string option;
    source_resource_id : string option;
    originated_from : string option;
    score : float option;
    match_reason : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_context =
          required reader Resource_descriptor_context.read "@context";
        field_id = required reader string "@id";
        field_type = maybe reader One_or_more_strings.read "@type";
        name = required reader string "name";
        description = maybe reader string "description";
        identifier =
          maybe reader Resource_descriptor_identifier.read "identifier";
        about = maybe reader One_or_more_strings.read "about";
        same_as = maybe reader (list string) "sameAs";
        is_part_of = maybe reader (list string) "isPartOf";
        has_part = maybe reader (list string) "hasPart";
        license = maybe reader string "license";
        version = maybe reader string "version";
        date_created = maybe reader string "dateCreated";
        date_modified = maybe reader string "dateModified";
        was_derived_from =
          maybe reader Resource_descriptor_was_derived_from.read
            "wasDerivedFrom";
        was_attributed_to =
          maybe reader One_or_more_agents.read "wasAttributedTo";
        generator = maybe reader One_or_more_agents.read "generator";
        conforms_to = maybe reader One_or_more_uris.read "conformsTo";
        available_formats = maybe reader (list string) "availableFormats";
        representations =
          required reader Resource_descriptor_representations.read
            "representations";
        archived = maybe reader bool "archived";
        entity_types = maybe reader (list string) "entityTypes";
        is_draft = maybe reader bool "isDraft";
        source_annotation_id = maybe reader string "sourceAnnotationId";
        source_resource_id = maybe reader string "sourceResourceId";
        originated_from = maybe reader string "originatedFrom";
        score = maybe reader float "score";
        match_reason = maybe reader string "matchReason";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ScoredResource ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write_open
      [
        ( "@context",
          Some (Resource_descriptor_context.to_json value.field_context) );
        ("@id", Some (json_string value.field_id));
        ("@type", Option.map One_or_more_strings.to_json value.field_type);
        ("name", Some (json_string value.name));
        ("description", Option.map json_string value.description);
        ( "identifier",
          Option.map Resource_descriptor_identifier.to_json value.identifier );
        ("about", Option.map One_or_more_strings.to_json value.about);
        ("sameAs", Option.map (json_list json_string) value.same_as);
        ("isPartOf", Option.map (json_list json_string) value.is_part_of);
        ("hasPart", Option.map (json_list json_string) value.has_part);
        ("license", Option.map json_string value.license);
        ("version", Option.map json_string value.version);
        ("dateCreated", Option.map json_string value.date_created);
        ("dateModified", Option.map json_string value.date_modified);
        ( "wasDerivedFrom",
          Option.map Resource_descriptor_was_derived_from.to_json
            value.was_derived_from );
        ( "wasAttributedTo",
          Option.map One_or_more_agents.to_json value.was_attributed_to );
        ("generator", Option.map One_or_more_agents.to_json value.generator);
        ("conformsTo", Option.map One_or_more_uris.to_json value.conforms_to);
        ( "availableFormats",
          Option.map (json_list json_string) value.available_formats );
        ( "representations",
          Some
            (Resource_descriptor_representations.to_json value.representations)
        );
        ("archived", Option.map json_bool value.archived);
        ("entityTypes", Option.map (json_list json_string) value.entity_types);
        ("isDraft", Option.map json_bool value.is_draft);
        ("sourceAnnotationId", Option.map json_string value.source_annotation_id);
        ("sourceResourceId", Option.map json_string value.source_resource_id);
        ("originatedFrom", Option.map json_string value.originated_from);
        ("score", Option.map json_float value.score);
        ("matchReason", Option.map json_string value.match_reason);
      ]
      value.extra

  let to_model value =
    Models.decode Models.scored_resource (Yojson.Raw.to_string (to_json value))
end

module Yield_create_command = struct
  type t = {
    field_user_id : string option;
    field_roles : string list option;
    job_id : string option;
    name : string;
    storage_uri : string;
    content_checksum : string;
    byte_size : int;
    format : string;
    language : string option;
    entity_types : string list option;
    is_draft : bool option;
    generated_from : Yield_create_command_generated_from.t option;
    generation_prompt : string option;
    generator : One_or_more_agents.t option;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      field_roles = maybe reader (list string) "_roles";
      job_id = maybe reader string "jobId";
      name = required reader string "name";
      storage_uri = required reader string "storageUri";
      content_checksum = required reader string "contentChecksum";
      byte_size = required reader int "byteSize";
      format = required reader string "format";
      language = maybe reader string "language";
      entity_types = maybe reader (list string) "entityTypes";
      is_draft = maybe reader bool "isDraft";
      generated_from =
        maybe reader
          (record Yield_create_command_generated_from.project)
          "generatedFrom";
      generation_prompt = maybe reader string "generationPrompt";
      generator = maybe reader One_or_more_agents.read "generator";
    }

  let of_model (model : [ `YieldCreateCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("_roles", Option.map (json_list json_string) value.field_roles);
        ("jobId", Option.map json_string value.job_id);
        ("name", Some (json_string value.name));
        ("storageUri", Some (json_string value.storage_uri));
        ("contentChecksum", Some (json_string value.content_checksum));
        ("byteSize", Some (json_int value.byte_size));
        ("format", Some (json_string value.format));
        ("language", Option.map json_string value.language);
        ("entityTypes", Option.map (json_list json_string) value.entity_types);
        ("isDraft", Option.map json_bool value.is_draft);
        ( "generatedFrom",
          Option.map Yield_create_command_generated_from.to_json
            value.generated_from );
        ("generationPrompt", Option.map json_string value.generation_prompt);
        ("generator", Option.map One_or_more_agents.to_json value.generator);
      ]

  let to_model value =
    Models.decode Models.yield_create_command
      (Yojson.Raw.to_string (to_json value))
end

module Job_pending = struct
  module Status = struct
    type t = Pending

    let to_string = function Pending -> "pending"
    let of_string = function "pending" -> Some Pending | _ -> None
  end

  type t = {
    status : Status.t;
    metadata : Job_metadata.t;
    params : Job_params.t;
  }

  let project fields =
    let reader = start fields in
    {
      status = required reader (enum Status.of_string) "status";
      metadata = required reader (record Job_metadata.project) "metadata";
      params = required reader (record Job_params.project) "params";
    }

  let of_model (model : [ `JobPending ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("metadata", Some (Job_metadata.to_json value.metadata));
        ("params", Some (Job_params.to_json value.params));
      ]

  let to_model value =
    Models.decode Models.job_pending (Yojson.Raw.to_string (to_json value))
end

module Job_complete = struct
  module Status = struct
    type t = Complete

    let to_string = function Complete -> "complete"
    let of_string = function "complete" -> Some Complete | _ -> None
  end

  type t = {
    status : Status.t;
    metadata : Job_metadata.t;
    params : Job_params.t;
    started_at : string;
    completed_at : string;
    result : Job_stored_result.t;
  }

  let project fields =
    let reader = start fields in
    {
      status = required reader (enum Status.of_string) "status";
      metadata = required reader (record Job_metadata.project) "metadata";
      params = required reader (record Job_params.project) "params";
      started_at = required reader string "startedAt";
      completed_at = required reader string "completedAt";
      result = required reader Job_stored_result.read "result";
    }

  let of_model (model : [ `JobComplete ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("metadata", Some (Job_metadata.to_json value.metadata));
        ("params", Some (Job_params.to_json value.params));
        ("startedAt", Some (json_string value.started_at));
        ("completedAt", Some (json_string value.completed_at));
        ("result", Some (Job_stored_result.to_json value.result));
      ]

  let to_model value =
    Models.decode Models.job_complete (Yojson.Raw.to_string (to_json value))
end

module Job_failed = struct
  module Status = struct
    type t = Failed

    let to_string = function Failed -> "failed"
    let of_string = function "failed" -> Some Failed | _ -> None
  end

  type t = {
    status : Status.t;
    metadata : Job_metadata.t;
    params : Job_params.t;
    started_at : string option;
    completed_at : string;
    error : string;
    failure_class : Enums.Failure_class.t option;
  }

  let project fields =
    let reader = start fields in
    {
      status = required reader (enum Status.of_string) "status";
      metadata = required reader (record Job_metadata.project) "metadata";
      params = required reader (record Job_params.project) "params";
      started_at = maybe reader string "startedAt";
      completed_at = required reader string "completedAt";
      error = required reader string "error";
      failure_class =
        maybe reader (enum Enums.Failure_class.of_string) "failureClass";
    }

  let of_model (model : [ `JobFailed ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("metadata", Some (Job_metadata.to_json value.metadata));
        ("params", Some (Job_params.to_json value.params));
        ("startedAt", Option.map json_string value.started_at);
        ("completedAt", Some (json_string value.completed_at));
        ("error", Some (json_string value.error));
        ( "failureClass",
          Option.map
            (json_enum Enums.Failure_class.to_string)
            value.failure_class );
      ]

  let to_model value =
    Models.decode Models.job_failed (Yojson.Raw.to_string (to_json value))
end

module Job_cancelled = struct
  module Status = struct
    type t = Cancelled

    let to_string = function Cancelled -> "cancelled"
    let of_string = function "cancelled" -> Some Cancelled | _ -> None
  end

  type t = {
    status : Status.t;
    metadata : Job_metadata.t;
    params : Job_params.t;
    started_at : string option;
    completed_at : string;
  }

  let project fields =
    let reader = start fields in
    {
      status = required reader (enum Status.of_string) "status";
      metadata = required reader (record Job_metadata.project) "metadata";
      params = required reader (record Job_params.project) "params";
      started_at = maybe reader string "startedAt";
      completed_at = required reader string "completedAt";
    }

  let of_model (model : [ `JobCancelled ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("metadata", Some (Job_metadata.to_json value.metadata));
        ("params", Some (Job_params.to_json value.params));
        ("startedAt", Option.map json_string value.started_at);
        ("completedAt", Some (json_string value.completed_at));
      ]

  let to_model value =
    Models.decode Models.job_cancelled (Yojson.Raw.to_string (to_json value))
end

module Archivist_engines = struct
  type t = {
    jobs : Archivist_engines_jobs.t;
    actors : Archivist_engines_actors.t;
  }

  let project fields =
    let reader = start fields in
    {
      jobs = required reader (record Archivist_engines_jobs.project) "jobs";
      actors =
        required reader (record Archivist_engines_actors.project) "actors";
    }

  let of_model (model : [ `ArchivistEngines ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("jobs", Some (Archivist_engines_jobs.to_json value.jobs));
        ("actors", Some (Archivist_engines_actors.to_json value.actors));
      ]

  let to_model value =
    Models.decode Models.archivist_engines
      (Yojson.Raw.to_string (to_json value))
end

module Anchored_text_write = struct
  type t = { content_checksum : string; entry : Anchored_text_entry.t }

  let project fields =
    let reader = start fields in
    {
      content_checksum = required reader string "contentChecksum";
      entry = required reader Anchored_text_entry.read "entry";
    }

  let of_model (model : [ `AnchoredTextWrite ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("contentChecksum", Some (json_string value.content_checksum));
        ("entry", Some (Anchored_text_entry.to_json value.entry));
      ]

  let to_model value =
    Models.decode Models.anchored_text_write
      (Yojson.Raw.to_string (to_json value))
end

module Stack_start_result = struct
  type t = {
    dry_run : bool;
    knowledge_base : Knowledge_base_status.t option;
    shared : Service_status.t list option;
  }

  let project fields =
    let reader = start fields in
    {
      dry_run = required reader bool "dryRun";
      knowledge_base =
        maybe reader (record Knowledge_base_status.project) "knowledgeBase";
      shared = maybe reader (list (record Service_status.project)) "shared";
    }

  let of_model (model : [ `StackStartResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("dryRun", Some (json_bool value.dry_run));
        ( "knowledgeBase",
          Option.map Knowledge_base_status.to_json value.knowledge_base );
        ("shared", Option.map (json_list Service_status.to_json) value.shared);
      ]

  let to_model value =
    Models.decode Models.stack_start_result
      (Yojson.Raw.to_string (to_json value))
end

module Stack_stop_result = struct
  type t = {
    dry_run : bool;
    knowledge_bases : Knowledge_base_status.t list option;
    shared : Service_status.t list option;
  }

  let project fields =
    let reader = start fields in
    {
      dry_run = required reader bool "dryRun";
      knowledge_bases =
        maybe reader
          (list (record Knowledge_base_status.project))
          "knowledgeBases";
      shared = maybe reader (list (record Service_status.project)) "shared";
    }

  let of_model (model : [ `StackStopResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("dryRun", Some (json_bool value.dry_run));
        ( "knowledgeBases",
          Option.map
            (json_list Knowledge_base_status.to_json)
            value.knowledge_bases );
        ("shared", Option.map (json_list Service_status.to_json) value.shared);
      ]

  let to_model value =
    Models.decode Models.stack_stop_result
      (Yojson.Raw.to_string (to_json value))
end

module Status_snapshot_result = struct
  type t = {
    knowledge_bases : Knowledge_base_status.t list;
    shared : Service_status.t list;
  }

  let project fields =
    let reader = start fields in
    {
      knowledge_bases =
        required reader
          (list (record Knowledge_base_status.project))
          "knowledgeBases";
      shared = required reader (list (record Service_status.project)) "shared";
    }

  let of_model (model : [ `StatusSnapshotResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "knowledgeBases",
          Some ((json_list Knowledge_base_status.to_json) value.knowledge_bases)
        );
        ("shared", Some ((json_list Service_status.to_json) value.shared));
      ]

  let to_model value =
    Models.decode Models.status_snapshot_result
      (Yojson.Raw.to_string (to_json value))
end

module Smelter_health = struct
  module Status = struct
    type t = Ok

    let to_string = function Ok -> "ok"
    let of_string = function "ok" -> Some Ok | _ -> None
  end

  type t = {
    status : Status.t;
    kb : string;
    stream : Enums.Connection_state.t;
    following : Follower_following.t;
    events_processed : int;
    reconcile : Smelter_health_reconcile.t;
    index : Smelter_health_index.t;
  }

  let project fields =
    let reader = start fields in
    {
      status = required reader (enum Status.of_string) "status";
      kb = required reader string "kb";
      stream = required reader (enum Enums.Connection_state.of_string) "stream";
      following =
        required reader (record Follower_following.project) "following";
      events_processed = required reader int "eventsProcessed";
      reconcile =
        required reader (record Smelter_health_reconcile.project) "reconcile";
      index = required reader (record Smelter_health_index.project) "index";
    }

  let of_model (model : [ `SmelterHealth ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("kb", Some (json_string value.kb));
        ( "stream",
          Some ((json_enum Enums.Connection_state.to_string) value.stream) );
        ("following", Some (Follower_following.to_json value.following));
        ("eventsProcessed", Some (json_int value.events_processed));
        ("reconcile", Some (Smelter_health_reconcile.to_json value.reconcile));
        ("index", Some (Smelter_health_index.to_json value.index));
      ]

  let to_model value =
    Models.decode Models.smelter_health (Yojson.Raw.to_string (to_json value))
end

module Browser = struct
  module Kind = struct
    type t = Browser

    let to_string = function Browser -> "Browser"
    let of_string = function "Browser" -> Some Browser | _ -> None
  end

  type t = {
    api_version : Enums.Stack_api_version.t;
    kind : Kind.t;
    metadata : Metadata.t;
    spec : Browser_spec.t;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Stack_api_version.of_string) "apiVersion";
      kind = required reader (enum Kind.of_string) "kind";
      metadata = required reader (record Metadata.project) "metadata";
      spec = required reader (record Browser_spec.project) "spec";
    }

  let of_model (model : [ `Browser ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Stack_api_version.to_string) value.api_version)
        );
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("metadata", Some (Metadata.to_json value.metadata));
        ("spec", Some (Browser_spec.to_json value.spec));
      ]

  let to_model value =
    Models.decode Models.browser (Yojson.Raw.to_string (to_json value))
end

module Vector_store = struct
  module Kind = struct
    type t = VectorStore

    let to_string = function VectorStore -> "VectorStore"
    let of_string = function "VectorStore" -> Some VectorStore | _ -> None
  end

  type t = {
    api_version : Enums.Stack_api_version.t;
    kind : Kind.t;
    metadata : Metadata.t;
    spec : Vector_store_spec.t;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Stack_api_version.of_string) "apiVersion";
      kind = required reader (enum Kind.of_string) "kind";
      metadata = required reader (record Metadata.project) "metadata";
      spec = required reader (record Vector_store_spec.project) "spec";
    }

  let of_model (model : [ `VectorStore ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Stack_api_version.to_string) value.api_version)
        );
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("metadata", Some (Metadata.to_json value.metadata));
        ("spec", Some (Vector_store_spec.to_json value.spec));
      ]

  let to_model value =
    Models.decode Models.vector_store (Yojson.Raw.to_string (to_json value))
end

module Worker_engine_config = struct
  type t = {
    engine : Engine.t;
    jobs : Job_filter.t list;
    base_url : string;
    api_key_env : string option;
  }

  let project fields =
    let reader = start fields in
    {
      engine = required reader (record Engine.project) "engine";
      jobs = required reader (list Job_filter.read) "jobs";
      base_url = required reader string "baseUrl";
      api_key_env = maybe reader string "apiKeyEnv";
    }

  let of_model (model : [ `WorkerEngineConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("engine", Some (Engine.to_json value.engine));
        ("jobs", Some ((json_list Job_filter.to_json) value.jobs));
        ("baseUrl", Some (json_string value.base_url));
        ("apiKeyEnv", Option.map json_string value.api_key_env);
      ]

  let to_model value =
    Models.decode Models.worker_engine_config
      (Yojson.Raw.to_string (to_json value))
end

module Worker_engine_health = struct
  type t = {
    engine : Engine.t;
    jobs : Job_filter.t list;
    last_queued_event_at : string option;
    last_claim_at : string option;
    last_finished_at : string option;
    last_activity_at : string option;
    active_job : Worker_active_job.t option;
    jobs_completed : int;
  }

  let project fields =
    let reader = start fields in
    {
      engine = required reader (record Engine.project) "engine";
      jobs = required reader (list Job_filter.read) "jobs";
      last_queued_event_at =
        required reader (nullable string) "lastQueuedEventAt";
      last_claim_at = required reader (nullable string) "lastClaimAt";
      last_finished_at = required reader (nullable string) "lastFinishedAt";
      last_activity_at = required reader (nullable string) "lastActivityAt";
      active_job =
        required reader
          (nullable (record Worker_active_job.project))
          "activeJob";
      jobs_completed = required reader int "jobsCompleted";
    }

  let of_model (model : [ `WorkerEngineHealth ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("engine", Some (Engine.to_json value.engine));
        ("jobs", Some ((json_list Job_filter.to_json) value.jobs));
        ( "lastQueuedEventAt",
          Some ((json_nullable json_string) value.last_queued_event_at) );
        ("lastClaimAt", Some ((json_nullable json_string) value.last_claim_at));
        ( "lastFinishedAt",
          Some ((json_nullable json_string) value.last_finished_at) );
        ( "lastActivityAt",
          Some ((json_nullable json_string) value.last_activity_at) );
        ( "activeJob",
          Some ((json_nullable Worker_active_job.to_json) value.active_job) );
        ("jobsCompleted", Some (json_int value.jobs_completed));
      ]

  let to_model value =
    Models.decode Models.worker_engine_health
      (Yojson.Raw.to_string (to_json value))
end

module Body_operation = struct
  type t =
    | BodyOperationAdd of Body_operation_add.t
    | BodyOperationRemove of Body_operation_remove.t
    | BodyOperationReplace of Body_operation_replace.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "op"; "item" ];
          allowed = None;
          fixed = [ ("op", [ Text_value "add" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "op"; "item" ];
          allowed = None;
          fixed = [ ("op", [ Text_value "remove" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "op"; "oldItem"; "newItem" ];
          allowed = None;
          fixed = [ ("op", [ Text_value "replace" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> BodyOperationAdd ((record Body_operation_add.project) value)
    | 1 -> BodyOperationRemove ((record Body_operation_remove.project) value)
    | 2 -> BodyOperationReplace ((record Body_operation_replace.project) value)
    | _ -> assert false

  let of_model (model : [ `BodyOperation ] Models.t) = read (Models.json model)

  let to_json = function
    | BodyOperationAdd value -> Body_operation_add.to_json value
    | BodyOperationRemove value -> Body_operation_remove.to_json value
    | BodyOperationReplace value -> Body_operation_replace.to_json value

  let to_model value =
    Models.decode Models.body_operation (Yojson.Raw.to_string (to_json value))
end

module Job_stored_progress = struct
  type t =
    | JobProgress of Job_progress.t
    | Empty of (string * Yojson.Raw.t) list

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "percentage" ];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [];
          allowed = Some [];
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> JobProgress ((record Job_progress.project) value)
    | 1 -> Empty ((map raw) value)
    | _ -> assert false

  let of_model (model : [ `JobStoredProgress ] Models.t) =
    read (Models.json model)

  let to_json = function
    | JobProgress value -> Job_progress.to_json value
    | Empty value -> (json_map json_raw) value

  let to_model value =
    Models.decode Models.job_stored_progress
      (Yojson.Raw.to_string (to_json value))
end

module Conformance_step = struct
  type t =
    | Let of Conformance_step_let.t
    | Driver of Conformance_step_driver.t
    | Abandon of Conformance_step_abandon.t
    | Settles of Conformance_step_settles.t
    | Wire of Conformance_step_wire.t
    | Carried of Conformance_step_carried.t
    | Closed of Conformance_step_closed.t
    | Progress of Conformance_step_progress.t
    | State of Conformance_step_state.t
    | Stays of Conformance_step_stays.t
    | Frame of Conformance_step_frame.t
    | Frames of Conformance_step_frames.t
    | Error of Conformance_step_error.t
    | Backend of Conformance_step_backend.t
    | Quiet of Conformance_step_quiet.t
    | Observe of Conformance_step_observe.t
    | Leave of Conformance_step_leave.t
    | Reaches of Conformance_step_reaches.t
    | Holds of Conformance_step_holds.t
    | Completes of Conformance_step_completes.t
    | ConformanceBusFetch of Conformance_bus_fetch.t
    | ConformanceHttpFetch of Conformance_http_fetch.t
    | Fetches of Conformance_step_fetches.t
    | Scopes of Conformance_step_scopes.t
    | Claimed of Conformance_step_claimed.t
    | Refused of Conformance_step_refused.t
    | Signalled of Conformance_step_signalled.t
    | Stalled of Conformance_step_stalled.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "let" ];
          allowed = Some [ "let" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "driver" ];
          allowed = Some [ "driver"; "with"; "returns"; "fails"; "as" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "abandon" ];
          allowed = Some [ "abandon" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "settles" ];
          allowed = Some [ "settles"; "returns"; "fails"; "abandoned" ];
          fixed = [ ("abandoned", [ Boolean_value true ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "wire" ];
          allowed =
            Some
              [
                "wire";
                "at";
                "status";
                "params";
                "body";
                "token";
                "headers";
                "answer";
                "as";
                "follows";
                "waited";
              ];
          fixed =
            [
              ( "at",
                [ Text_value "arrival"; Text_value "answer"; Text_value "live" ]
              );
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "carried"; "is" ];
          allowed = Some [ "carried"; "is" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "closed" ];
          allowed = Some [ "closed" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "progress" ];
          allowed = Some [ "progress" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "state" ];
          allowed = Some [ "state" ];
          fixed =
            [
              ( "state",
                [
                  Text_value "initial";
                  Text_value "connecting";
                  Text_value "open";
                  Text_value "reconnecting";
                  Text_value "degraded";
                  Text_value "unauthenticated";
                  Text_value "closed";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "stays" ];
          allowed = Some [ "stays" ];
          fixed =
            [
              ( "stays",
                [
                  Text_value "initial";
                  Text_value "connecting";
                  Text_value "open";
                  Text_value "reconnecting";
                  Text_value "degraded";
                  Text_value "unauthenticated";
                  Text_value "closed";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "frame"; "is" ];
          allowed = Some [ "frame"; "is" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "frames"; "count" ];
          allowed = Some [ "frames"; "count" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "error" ];
          allowed = Some [ "error" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "backend" ];
          allowed = Some [ "backend"; "with" ];
          fixed =
            [
              ( "backend",
                [
                  Text_value "listen";
                  Text_value "emit";
                  Text_value "record";
                  Text_value "content";
                  Text_value "description";
                  Text_value "annotations";
                  Text_value "anchored-text";
                  Text_value "uploaded";
                  Text_value "refuse";
                  Text_value "unanswered";
                  Text_value "answer-lost";
                  Text_value "hold";
                  Text_value "release";
                  Text_value "rechunk";
                  Text_value "carry";
                  Text_value "cut";
                  Text_value "down";
                  Text_value "up";
                  Text_value "archivist";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "quiet" ];
          allowed = Some [ "quiet" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "observe"; "as" ];
          allowed = Some [ "observe"; "as" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "leave" ];
          allowed = Some [ "leave" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "reaches"; "state" ];
          allowed = Some [ "reaches"; "state" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "holds"; "state" ];
          allowed = Some [ "holds"; "state" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "completes" ];
          allowed = Some [ "completes" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "fetch"; "as" ];
          allowed = Some [ "fetch"; "payload"; "as" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "fetch" ];
          allowed = Some [ "fetch"; "params" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "fetches" ];
          allowed = Some [ "fetches" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "scopes" ];
          allowed = Some [ "scopes" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "claimed" ];
          allowed = Some [ "claimed" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "refused" ];
          allowed = Some [ "refused" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "signalled" ];
          allowed = Some [ "signalled" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "stalled" ];
          allowed = Some [ "stalled" ];
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> Let ((record Conformance_step_let.project) value)
    | 1 -> Driver ((record Conformance_step_driver.project) value)
    | 2 -> Abandon ((record Conformance_step_abandon.project) value)
    | 3 -> Settles ((record Conformance_step_settles.project) value)
    | 4 -> Wire ((record Conformance_step_wire.project) value)
    | 5 -> Carried ((record Conformance_step_carried.project) value)
    | 6 -> Closed ((record Conformance_step_closed.project) value)
    | 7 -> Progress ((record Conformance_step_progress.project) value)
    | 8 -> State ((record Conformance_step_state.project) value)
    | 9 -> Stays ((record Conformance_step_stays.project) value)
    | 10 -> Frame ((record Conformance_step_frame.project) value)
    | 11 -> Frames ((record Conformance_step_frames.project) value)
    | 12 -> Error ((record Conformance_step_error.project) value)
    | 13 -> Backend ((record Conformance_step_backend.project) value)
    | 14 -> Quiet ((record Conformance_step_quiet.project) value)
    | 15 -> Observe ((record Conformance_step_observe.project) value)
    | 16 -> Leave ((record Conformance_step_leave.project) value)
    | 17 -> Reaches ((record Conformance_step_reaches.project) value)
    | 18 -> Holds ((record Conformance_step_holds.project) value)
    | 19 -> Completes ((record Conformance_step_completes.project) value)
    | 20 -> ConformanceBusFetch ((record Conformance_bus_fetch.project) value)
    | 21 -> ConformanceHttpFetch ((record Conformance_http_fetch.project) value)
    | 22 -> Fetches ((record Conformance_step_fetches.project) value)
    | 23 -> Scopes ((record Conformance_step_scopes.project) value)
    | 24 -> Claimed ((record Conformance_step_claimed.project) value)
    | 25 -> Refused ((record Conformance_step_refused.project) value)
    | 26 -> Signalled ((record Conformance_step_signalled.project) value)
    | 27 -> Stalled ((record Conformance_step_stalled.project) value)
    | _ -> assert false

  let of_model (model : [ `ConformanceStep ] Models.t) =
    read (Models.json model)

  let to_json = function
    | Let value -> Conformance_step_let.to_json value
    | Driver value -> Conformance_step_driver.to_json value
    | Abandon value -> Conformance_step_abandon.to_json value
    | Settles value -> Conformance_step_settles.to_json value
    | Wire value -> Conformance_step_wire.to_json value
    | Carried value -> Conformance_step_carried.to_json value
    | Closed value -> Conformance_step_closed.to_json value
    | Progress value -> Conformance_step_progress.to_json value
    | State value -> Conformance_step_state.to_json value
    | Stays value -> Conformance_step_stays.to_json value
    | Frame value -> Conformance_step_frame.to_json value
    | Frames value -> Conformance_step_frames.to_json value
    | Error value -> Conformance_step_error.to_json value
    | Backend value -> Conformance_step_backend.to_json value
    | Quiet value -> Conformance_step_quiet.to_json value
    | Observe value -> Conformance_step_observe.to_json value
    | Leave value -> Conformance_step_leave.to_json value
    | Reaches value -> Conformance_step_reaches.to_json value
    | Holds value -> Conformance_step_holds.to_json value
    | Completes value -> Conformance_step_completes.to_json value
    | ConformanceBusFetch value -> Conformance_bus_fetch.to_json value
    | ConformanceHttpFetch value -> Conformance_http_fetch.to_json value
    | Fetches value -> Conformance_step_fetches.to_json value
    | Scopes value -> Conformance_step_scopes.to_json value
    | Claimed value -> Conformance_step_claimed.to_json value
    | Refused value -> Conformance_step_refused.to_json value
    | Signalled value -> Conformance_step_signalled.to_json value
    | Stalled value -> Conformance_step_stalled.to_json value

  let to_model value =
    Models.decode Models.conformance_step (Yojson.Raw.to_string (to_json value))
end

module Issuer_spec = struct
  type t = {
    type_ : string;
    image : string;
    resources : Resources.t;
    port : int;
    database : Issuer_spec_database.t;
  }

  let project fields =
    let reader = start fields in
    {
      type_ = required reader string "type";
      image = required reader string "image";
      resources = required reader (record Resources.project) "resources";
      port = required reader int "port";
      database =
        required reader (record Issuer_spec_database.project) "database";
    }

  let to_json (value : t) =
    write
      [
        ("type", Some (json_string value.type_));
        ("image", Some (json_string value.image));
        ("resources", Some (Resources.to_json value.resources));
        ("port", Some (json_int value.port));
        ("database", Some (Issuer_spec_database.to_json value.database));
      ]
end

module Knowledge_index_spec = struct
  type t = {
    knowledge_base : string;
    log_level : Enums.Log_level.t;
    graph : Knowledge_index_spec_graph.t;
    vectors : Knowledge_index_spec_vectors.t;
    embedding : Knowledge_index_spec_embedding.t;
    librarian : Knowledge_index_spec_librarian.t;
    smelter : Knowledge_index_spec_smelter.t;
    weaver : Knowledge_index_spec_weaver.t;
  }

  let project fields =
    let reader = start fields in
    {
      knowledge_base = required reader string "knowledgeBase";
      log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
      graph =
        required reader (record Knowledge_index_spec_graph.project) "graph";
      vectors =
        required reader (record Knowledge_index_spec_vectors.project) "vectors";
      embedding =
        required reader
          (record Knowledge_index_spec_embedding.project)
          "embedding";
      librarian =
        required reader
          (record Knowledge_index_spec_librarian.project)
          "librarian";
      smelter =
        required reader (record Knowledge_index_spec_smelter.project) "smelter";
      weaver =
        required reader (record Knowledge_index_spec_weaver.project) "weaver";
    }

  let to_json (value : t) =
    write
      [
        ("knowledgeBase", Some (json_string value.knowledge_base));
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ("graph", Some (Knowledge_index_spec_graph.to_json value.graph));
        ("vectors", Some (Knowledge_index_spec_vectors.to_json value.vectors));
        ( "embedding",
          Some (Knowledge_index_spec_embedding.to_json value.embedding) );
        ( "librarian",
          Some (Knowledge_index_spec_librarian.to_json value.librarian) );
        ("smelter", Some (Knowledge_index_spec_smelter.to_json value.smelter));
        ("weaver", Some (Knowledge_index_spec_weaver.to_json value.weaver));
      ]
end

module Stack_knowledge_base_spec = struct
  type t = {
    log_level : Enums.Log_level.t;
    gateway : Stack_knowledge_base_spec_gateway.t;
    dispatcher : Stack_knowledge_base_spec_dispatcher.t;
    archivist : Stack_knowledge_base_spec_archivist.t;
    messaging : Stack_knowledge_base_spec_messaging.t;
    issuer : Stack_knowledge_base_spec_issuer.t;
  }

  let project fields =
    let reader = start fields in
    {
      log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
      gateway =
        required reader
          (record Stack_knowledge_base_spec_gateway.project)
          "gateway";
      dispatcher =
        required reader
          (record Stack_knowledge_base_spec_dispatcher.project)
          "dispatcher";
      archivist =
        required reader
          (record Stack_knowledge_base_spec_archivist.project)
          "archivist";
      messaging =
        required reader
          (record Stack_knowledge_base_spec_messaging.project)
          "messaging";
      issuer =
        required reader
          (record Stack_knowledge_base_spec_issuer.project)
          "issuer";
    }

  let to_json (value : t) =
    write
      [
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ( "gateway",
          Some (Stack_knowledge_base_spec_gateway.to_json value.gateway) );
        ( "dispatcher",
          Some (Stack_knowledge_base_spec_dispatcher.to_json value.dispatcher)
        );
        ( "archivist",
          Some (Stack_knowledge_base_spec_archivist.to_json value.archivist) );
        ( "messaging",
          Some (Stack_knowledge_base_spec_messaging.to_json value.messaging) );
        ("issuer", Some (Stack_knowledge_base_spec_issuer.to_json value.issuer));
      ]
end

module Worker_pool_spec = struct
  type t = { log_level : Enums.Log_level.t; worker : Worker_pool_spec_worker.t }

  let project fields =
    let reader = start fields in
    {
      log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
      worker = required reader (record Worker_pool_spec_worker.project) "worker";
    }

  let to_json (value : t) =
    write
      [
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ("worker", Some (Worker_pool_spec_worker.to_json value.worker));
      ]
end

module Job_complete_command = struct
  type t =
    | MarkJobCompleteCommand of Mark_job_complete_command.t
    | YieldJobCompleteCommand of Yield_job_complete_command.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "resourceId"; "jobId"; "jobType" ];
          allowed = None;
          fixed =
            [
              ("jobType", [ Text_value "mark" ]);
              ( "durability",
                [
                  Text_value "acknowledged";
                  Text_value "probe-confirmed";
                  Text_value "probe-refused";
                  Text_value "probe-unreachable";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "resourceId"; "jobId"; "jobType" ];
          allowed = None;
          fixed =
            [
              ("jobType", [ Text_value "yield" ]);
              ( "durability",
                [
                  Text_value "acknowledged";
                  Text_value "probe-confirmed";
                  Text_value "probe-refused";
                  Text_value "probe-unreachable";
                ] );
            ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 ->
        MarkJobCompleteCommand
          ((record Mark_job_complete_command.project) value)
    | 1 ->
        YieldJobCompleteCommand
          ((record Yield_job_complete_command.project) value)
    | _ -> assert false

  let of_model (model : [ `JobCompleteCommand ] Models.t) =
    read (Models.json model)

  let to_json = function
    | MarkJobCompleteCommand value -> Mark_job_complete_command.to_json value
    | YieldJobCompleteCommand value -> Yield_job_complete_command.to_json value

  let to_model value =
    Models.decode Models.job_complete_command
      (Yojson.Raw.to_string (to_json value))
end

module Job_queued_event = struct
  type t =
    | MarkJobQueuedEvent of Mark_job_queued_event.t
    | YieldJobQueuedEvent of Yield_job_queued_event.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "jobId"; "jobType"; "resourceId"; "userId"; "params" ];
          allowed = None;
          fixed = [ ("jobType", [ Text_value "mark" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "jobId"; "jobType"; "resourceId"; "userId"; "params" ];
          allowed = None;
          fixed = [ ("jobType", [ Text_value "yield" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> MarkJobQueuedEvent ((record Mark_job_queued_event.project) value)
    | 1 -> YieldJobQueuedEvent ((record Yield_job_queued_event.project) value)
    | _ -> assert false

  let of_model (model : [ `JobQueuedEvent ] Models.t) = read (Models.json model)

  let to_json = function
    | MarkJobQueuedEvent value -> Mark_job_queued_event.to_json value
    | YieldJobQueuedEvent value -> Yield_job_queued_event.to_json value

  let to_model value =
    Models.decode Models.job_queued_event (Yojson.Raw.to_string (to_json value))
end

module Conformance_driver_line_emission_emission = struct
  type t = {
    observer : string;
    state : Conformance_driver_line_emission_emission_state.t;
  }

  let project fields =
    let reader = start fields in
    {
      observer = required reader string "observer";
      state =
        required reader Conformance_driver_line_emission_emission_state.read
          "state";
    }

  let to_json (value : t) =
    write
      [
        ("observer", Some (json_string value.observer));
        ( "state",
          Some
            (Conformance_driver_line_emission_emission_state.to_json value.state)
        );
      ]
end

module Annotation_body_updated_payload = struct
  type t = { annotation_id : string; operations : Body_operation.t list }

  let project fields =
    let reader = start fields in
    {
      annotation_id = required reader string "annotationId";
      operations = required reader (list Body_operation.read) "operations";
    }

  let of_model (model : [ `AnnotationBodyUpdatedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Some (json_string value.annotation_id));
        ( "operations",
          Some ((json_list Body_operation.to_json) value.operations) );
      ]

  let to_model value =
    Models.decode Models.annotation_body_updated_payload
      (Yojson.Raw.to_string (to_json value))
end

module Browse_annotation_history_result = struct
  type t = { response : Get_annotation_history_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader
          (record Get_annotation_history_response.project)
          "response";
    }

  let of_model (model : [ `BrowseAnnotationHistoryResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "response",
          Some (Get_annotation_history_response.to_json value.response) );
      ]

  let to_model value =
    Models.decode Models.browse_annotation_history_result
      (Yojson.Raw.to_string (to_json value))
end

module Browse_events_result = struct
  type t = { response : Get_events_response.t }

  let project fields =
    let reader = start fields in
    {
      response = required reader (record Get_events_response.project) "response";
    }

  let of_model (model : [ `BrowseEventsResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("response", Some (Get_events_response.to_json value.response)) ]

  let to_model value =
    Models.decode Models.browse_events_result
      (Yojson.Raw.to_string (to_json value))
end

module Clone_resource_with_token_response = struct
  type t = {
    token : string;
    expires_at : string;
    resource : Resource_descriptor.t;
  }

  let project fields =
    let reader = start fields in
    {
      token = required reader string "token";
      expires_at = required reader string "expiresAt";
      resource = required reader (record Resource_descriptor.project) "resource";
    }

  let of_model (model : [ `CloneResourceWithTokenResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("token", Some (json_string value.token));
        ("expiresAt", Some (json_string value.expires_at));
        ("resource", Some (Resource_descriptor.to_json value.resource));
      ]

  let to_model value =
    Models.decode Models.clone_resource_with_token_response
      (Yojson.Raw.to_string (to_json value))
end

module Create_annotation_request = struct
  type t = {
    motivation : Enums.Motivation.t;
    target : Annotation_target.t;
    body : Annotation_bodies.t option;
  }

  let project fields =
    let reader = start fields in
    {
      motivation =
        required reader (enum Enums.Motivation.of_string) "motivation";
      target = required reader (record Annotation_target.project) "target";
      body = maybe reader Annotation_bodies.read "body";
    }

  let of_model (model : [ `CreateAnnotationRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "motivation",
          Some ((json_enum Enums.Motivation.to_string) value.motivation) );
        ("target", Some (Annotation_target.to_json value.target));
        ("body", Option.map Annotation_bodies.to_json value.body);
      ]

  let to_model value =
    Models.decode Models.create_annotation_request
      (Yojson.Raw.to_string (to_json value))
end

module Gather_referenced_by_result = struct
  type t = { response : Get_referenced_by_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader (record Get_referenced_by_response.project) "response";
    }

  let of_model (model : [ `GatherReferencedByResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Get_referenced_by_response.to_json value.response)) ]

  let to_model value =
    Models.decode Models.gather_referenced_by_result
      (Yojson.Raw.to_string (to_json value))
end

module Get_resource_by_token_response = struct
  type t = { source_resource : Resource_descriptor.t; expires_at : string }

  let project fields =
    let reader = start fields in
    {
      source_resource =
        required reader (record Resource_descriptor.project) "sourceResource";
      expires_at = required reader string "expiresAt";
    }

  let of_model (model : [ `GetResourceByTokenResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "sourceResource",
          Some (Resource_descriptor.to_json value.source_resource) );
        ("expiresAt", Some (json_string value.expires_at));
      ]

  let to_model value =
    Models.decode Models.get_resource_by_token_response
      (Yojson.Raw.to_string (to_json value))
end

module Job_status_response = struct
  module Status = struct
    type t = Pending | Running | Complete | Failed | Cancelled

    let to_string = function
      | Pending -> "pending"
      | Running -> "running"
      | Complete -> "complete"
      | Failed -> "failed"
      | Cancelled -> "cancelled"

    let of_string = function
      | "pending" -> Some Pending
      | "running" -> Some Running
      | "complete" -> Some Complete
      | "failed" -> Some Failed
      | "cancelled" -> Some Cancelled
      | _ -> None
  end

  type t = {
    job_id : string;
    type_ : Enums.Job_type.t;
    status : Status.t;
    user_id : string;
    created : string;
    started_at : string option;
    completed_at : string option;
    error : string option;
    failure_class : Enums.Failure_class.t option;
    progress : Job_stored_progress.t option;
    result : Job_stored_result.t option;
  }

  let project fields =
    let reader = start fields in
    {
      job_id = required reader string "jobId";
      type_ = required reader (enum Enums.Job_type.of_string) "type";
      status = required reader (enum Status.of_string) "status";
      user_id = required reader string "userId";
      created = required reader string "created";
      started_at = maybe reader string "startedAt";
      completed_at = maybe reader string "completedAt";
      error = maybe reader string "error";
      failure_class =
        maybe reader (enum Enums.Failure_class.of_string) "failureClass";
      progress = maybe reader Job_stored_progress.read "progress";
      result = maybe reader Job_stored_result.read "result";
    }

  let of_model (model : [ `JobStatusResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("jobId", Some (json_string value.job_id));
        ("type", Some ((json_enum Enums.Job_type.to_string) value.type_));
        ("status", Some ((json_enum Status.to_string) value.status));
        ("userId", Some (json_string value.user_id));
        ("created", Some (json_string value.created));
        ("startedAt", Option.map json_string value.started_at);
        ("completedAt", Option.map json_string value.completed_at);
        ("error", Option.map json_string value.error);
        ( "failureClass",
          Option.map
            (json_enum Enums.Failure_class.to_string)
            value.failure_class );
        ("progress", Option.map Job_stored_progress.to_json value.progress);
        ("result", Option.map Job_stored_result.to_json value.result);
      ]

  let to_model value =
    Models.decode Models.job_status_response
      (Yojson.Raw.to_string (to_json value))
end

module List_resources_response = struct
  type t = {
    resources : Resource_descriptor.t list;
    total : float;
    offset : float;
    limit : float;
  }

  let project fields =
    let reader = start fields in
    {
      resources =
        required reader (list (record Resource_descriptor.project)) "resources";
      total = required reader float "total";
      offset = required reader float "offset";
      limit = required reader float "limit";
    }

  let of_model (model : [ `ListResourcesResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "resources",
          Some ((json_list Resource_descriptor.to_json) value.resources) );
        ("total", Some (json_float value.total));
        ("offset", Some (json_float value.offset));
        ("limit", Some (json_float value.limit));
      ]

  let to_model value =
    Models.decode Models.list_resources_response
      (Yojson.Raw.to_string (to_json value))
end

module Mark_update_body_command = struct
  type t = {
    field_user_id : string option;
    annotation_id : string;
    resource_id : string;
    operations : Body_operation.t list;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      annotation_id = required reader string "annotationId";
      resource_id = required reader string "resourceId";
      operations = required reader (list Body_operation.read) "operations";
    }

  let of_model (model : [ `MarkUpdateBodyCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("annotationId", Some (json_string value.annotation_id));
        ("resourceId", Some (json_string value.resource_id));
        ( "operations",
          Some ((json_list Body_operation.to_json) value.operations) );
      ]

  let to_model value =
    Models.decode Models.mark_update_body_command
      (Yojson.Raw.to_string (to_json value))
end

module Match_search_result = struct
  type t = { reference_id : string; response : Scored_resource.t list }

  let project fields =
    let reader = start fields in
    {
      reference_id = required reader string "referenceId";
      response =
        required reader (list (record Scored_resource.project)) "response";
    }

  let of_model (model : [ `MatchSearchResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("referenceId", Some (json_string value.reference_id));
        ("response", Some ((json_list Scored_resource.to_json) value.response));
      ]

  let to_model value =
    Models.decode Models.match_search_result
      (Yojson.Raw.to_string (to_json value))
end

module Match_resources_response = struct
  module Match_kind = struct
    type t = Lexical | Semantic

    let to_string = function Lexical -> "lexical" | Semantic -> "semantic"

    let of_string = function
      | "lexical" -> Some Lexical
      | "semantic" -> Some Semantic
      | _ -> None
  end

  type t = {
    resources : Resource_descriptor.t list;
    total : int;
    offset : int;
    limit : int;
    match_kind : Match_kind.t;
  }

  let project fields =
    let reader = start fields in
    {
      resources =
        required reader (list (record Resource_descriptor.project)) "resources";
      total = required reader int "total";
      offset = required reader int "offset";
      limit = required reader int "limit";
      match_kind = required reader (enum Match_kind.of_string) "matchKind";
    }

  let of_model (model : [ `MatchResourcesResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "resources",
          Some ((json_list Resource_descriptor.to_json) value.resources) );
        ("total", Some (json_int value.total));
        ("offset", Some (json_int value.offset));
        ("limit", Some (json_int value.limit));
        ("matchKind", Some ((json_enum Match_kind.to_string) value.match_kind));
      ]

  let to_model value =
    Models.decode Models.match_resources_response
      (Yojson.Raw.to_string (to_json value))
end

module Update_annotation_body_request = struct
  type t = { resource_id : string; operations : Body_operation.t list }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      operations = required reader (list Body_operation.read) "operations";
    }

  let of_model (model : [ `UpdateAnnotationBodyRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ( "operations",
          Some ((json_list Body_operation.to_json) value.operations) );
      ]

  let to_model value =
    Models.decode Models.update_annotation_body_request
      (Yojson.Raw.to_string (to_json value))
end

module Job_running = struct
  module Status = struct
    type t = Running

    let to_string = function Running -> "running"
    let of_string = function "running" -> Some Running | _ -> None
  end

  type t = {
    status : Status.t;
    metadata : Job_metadata.t;
    params : Job_params.t;
    started_at : string;
    progress : Job_stored_progress.t;
  }

  let project fields =
    let reader = start fields in
    {
      status = required reader (enum Status.of_string) "status";
      metadata = required reader (record Job_metadata.project) "metadata";
      params = required reader (record Job_params.project) "params";
      started_at = required reader string "startedAt";
      progress = required reader Job_stored_progress.read "progress";
    }

  let of_model (model : [ `JobRunning ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("metadata", Some (Job_metadata.to_json value.metadata));
        ("params", Some (Job_params.to_json value.params));
        ("startedAt", Some (json_string value.started_at));
        ("progress", Some (Job_stored_progress.to_json value.progress));
      ]

  let to_model value =
    Models.decode Models.job_running (Yojson.Raw.to_string (to_json value))
end

module Archivist_config = struct
  type t = {
    gateway_url : string;
    identity : Service_identity.t;
    root : string;
    state_home : string;
    anchored_text_dir : string;
    engines : Archivist_engines.t;
    port : int;
    skip_rebuild : bool;
    staging : Archivist_config_staging.t;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
  }

  let project fields =
    let reader = start fields in
    {
      gateway_url = required reader string "gatewayUrl";
      identity = required reader (record Service_identity.project) "identity";
      root = required reader string "root";
      state_home = required reader string "stateHome";
      anchored_text_dir = required reader string "anchoredTextDir";
      engines = required reader (record Archivist_engines.project) "engines";
      port = required reader int "port";
      skip_rebuild = required reader bool "skipRebuild";
      staging =
        required reader (record Archivist_config_staging.project) "staging";
      log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
      log_format = required reader (enum Enums.Log_format.of_string) "logFormat";
    }

  let of_model (model : [ `ArchivistConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("gatewayUrl", Some (json_string value.gateway_url));
        ("identity", Some (Service_identity.to_json value.identity));
        ("root", Some (json_string value.root));
        ("stateHome", Some (json_string value.state_home));
        ("anchoredTextDir", Some (json_string value.anchored_text_dir));
        ("engines", Some (Archivist_engines.to_json value.engines));
        ("port", Some (json_int value.port));
        ("skipRebuild", Some (json_bool value.skip_rebuild));
        ("staging", Some (Archivist_config_staging.to_json value.staging));
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ( "logFormat",
          Some ((json_enum Enums.Log_format.to_string) value.log_format) );
      ]

  let to_model value =
    Models.decode Models.archivist_config (Yojson.Raw.to_string (to_json value))
end

module Conformance_case = struct
  module Planes = struct
    type t = In_process | Nats

    let to_string = function In_process -> "in-process" | Nats -> "nats"

    let of_string = function
      | "in-process" -> Some In_process
      | "nats" -> Some Nats
      | _ -> None
  end

  module Tier = struct
    type t = Fleet | Parity

    let to_string = function Fleet -> "fleet" | Parity -> "parity"

    let of_string = function
      | "fleet" -> Some Fleet
      | "parity" -> Some Parity
      | _ -> None
  end

  type t = {
    about : string;
    source : string;
    planes : Planes.t list option;
    tier : Tier.t option;
    telemetry : bool option;
    steps : Conformance_step.t list;
  }

  let project fields =
    let reader = start fields in
    {
      about = required reader string "about";
      source = required reader string "source";
      planes = maybe reader (list (enum Planes.of_string)) "planes";
      tier = maybe reader (enum Tier.of_string) "tier";
      telemetry = maybe reader bool "telemetry";
      steps = required reader (list Conformance_step.read) "steps";
    }

  let of_model (model : [ `ConformanceCase ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("about", Some (json_string value.about));
        ("source", Some (json_string value.source));
        ( "planes",
          Option.map (json_list (json_enum Planes.to_string)) value.planes );
        ("tier", Option.map (json_enum Tier.to_string) value.tier);
        ("telemetry", Option.map json_bool value.telemetry);
        ("steps", Some ((json_list Conformance_step.to_json) value.steps));
      ]

  let to_model value =
    Models.decode Models.conformance_case (Yojson.Raw.to_string (to_json value))
end

module Issuer = struct
  module Kind = struct
    type t = Issuer

    let to_string = function Issuer -> "Issuer"
    let of_string = function "Issuer" -> Some Issuer | _ -> None
  end

  type t = {
    api_version : Enums.Stack_api_version.t;
    kind : Kind.t;
    metadata : Metadata.t;
    spec : Issuer_spec.t;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Stack_api_version.of_string) "apiVersion";
      kind = required reader (enum Kind.of_string) "kind";
      metadata = required reader (record Metadata.project) "metadata";
      spec = required reader (record Issuer_spec.project) "spec";
    }

  let of_model (model : [ `Issuer ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Stack_api_version.to_string) value.api_version)
        );
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("metadata", Some (Metadata.to_json value.metadata));
        ("spec", Some (Issuer_spec.to_json value.spec));
      ]

  let to_model value =
    Models.decode Models.issuer (Yojson.Raw.to_string (to_json value))
end

module Knowledge_index = struct
  module Kind = struct
    type t = KnowledgeIndex

    let to_string = function KnowledgeIndex -> "KnowledgeIndex"

    let of_string = function
      | "KnowledgeIndex" -> Some KnowledgeIndex
      | _ -> None
  end

  type t = {
    api_version : Enums.Stack_api_version.t;
    kind : Kind.t;
    metadata : Metadata.t;
    spec : Knowledge_index_spec.t;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Stack_api_version.of_string) "apiVersion";
      kind = required reader (enum Kind.of_string) "kind";
      metadata = required reader (record Metadata.project) "metadata";
      spec = required reader (record Knowledge_index_spec.project) "spec";
    }

  let of_model (model : [ `KnowledgeIndex ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Stack_api_version.to_string) value.api_version)
        );
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("metadata", Some (Metadata.to_json value.metadata));
        ("spec", Some (Knowledge_index_spec.to_json value.spec));
      ]

  let to_model value =
    Models.decode Models.knowledge_index (Yojson.Raw.to_string (to_json value))
end

module Stack_knowledge_base = struct
  module Kind = struct
    type t = KnowledgeBase

    let to_string = function KnowledgeBase -> "KnowledgeBase"
    let of_string = function "KnowledgeBase" -> Some KnowledgeBase | _ -> None
  end

  type t = {
    api_version : Enums.Stack_api_version.t;
    kind : Kind.t;
    metadata : Metadata.t;
    spec : Stack_knowledge_base_spec.t;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Stack_api_version.of_string) "apiVersion";
      kind = required reader (enum Kind.of_string) "kind";
      metadata = required reader (record Metadata.project) "metadata";
      spec = required reader (record Stack_knowledge_base_spec.project) "spec";
    }

  let of_model (model : [ `StackKnowledgeBase ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Stack_api_version.to_string) value.api_version)
        );
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("metadata", Some (Metadata.to_json value.metadata));
        ("spec", Some (Stack_knowledge_base_spec.to_json value.spec));
      ]

  let to_model value =
    Models.decode Models.stack_knowledge_base
      (Yojson.Raw.to_string (to_json value))
end

module Worker_pool = struct
  module Kind = struct
    type t = WorkerPool

    let to_string = function WorkerPool -> "WorkerPool"
    let of_string = function "WorkerPool" -> Some WorkerPool | _ -> None
  end

  type t = {
    api_version : Enums.Stack_api_version.t;
    kind : Kind.t;
    metadata : Metadata.t;
    spec : Worker_pool_spec.t;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Stack_api_version.of_string) "apiVersion";
      kind = required reader (enum Kind.of_string) "kind";
      metadata = required reader (record Metadata.project) "metadata";
      spec = required reader (record Worker_pool_spec.project) "spec";
    }

  let of_model (model : [ `WorkerPool ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Stack_api_version.to_string) value.api_version)
        );
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("metadata", Some (Metadata.to_json value.metadata));
        ("spec", Some (Worker_pool_spec.to_json value.spec));
      ]

  let to_model value =
    Models.decode Models.worker_pool (Yojson.Raw.to_string (to_json value))
end

module Worker_knowledge_base_config = struct
  type t = {
    domain : string;
    gateway_url : string;
    identity : Worker_knowledge_base_config_identity.t;
    engines : Worker_engine_config.t list;
  }

  let project fields =
    let reader = start fields in
    {
      domain = required reader string "domain";
      gateway_url = required reader string "gatewayUrl";
      identity =
        required reader
          (record Worker_knowledge_base_config_identity.project)
          "identity";
      engines =
        required reader (list (record Worker_engine_config.project)) "engines";
    }

  let of_model (model : [ `WorkerKnowledgeBaseConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("domain", Some (json_string value.domain));
        ("gatewayUrl", Some (json_string value.gateway_url));
        ( "identity",
          Some (Worker_knowledge_base_config_identity.to_json value.identity) );
        ( "engines",
          Some ((json_list Worker_engine_config.to_json) value.engines) );
      ]

  let to_model value =
    Models.decode Models.worker_knowledge_base_config
      (Yojson.Raw.to_string (to_json value))
end

module Worker_knowledge_base_health = struct
  module State = struct
    type t = Starting | Working | Refused

    let to_string = function
      | Starting -> "starting"
      | Working -> "working"
      | Refused -> "refused"

    let of_string = function
      | "starting" -> Some Starting
      | "working" -> Some Working
      | "refused" -> Some Refused
      | _ -> None
  end

  type t = {
    domain : string;
    state : State.t;
    did : string option;
    engines : Worker_engine_health.t list option;
  }

  let project fields =
    let reader = start fields in
    {
      domain = required reader string "domain";
      state = required reader (enum State.of_string) "state";
      did = maybe reader string "did";
      engines =
        maybe reader (list (record Worker_engine_health.project)) "engines";
    }

  let of_model (model : [ `WorkerKnowledgeBaseHealth ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("domain", Some (json_string value.domain));
        ("state", Some ((json_enum State.to_string) value.state));
        ("did", Option.map json_string value.did);
        ( "engines",
          Option.map (json_list Worker_engine_health.to_json) value.engines );
      ]

  let to_model value =
    Models.decode Models.worker_knowledge_base_health
      (Yojson.Raw.to_string (to_json value))
end

module Annotation_target_value = struct
  type t = ResourceId of string | AnnotationTarget of Annotation_target.t

  let members =
    [
      [
        {
          kind = Text_kind;
          required = [];
          allowed = None;
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "source" ];
          allowed = None;
          fixed = [ ("type", [ Text_value "SpecificResource" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> ResourceId (string value)
    | 1 -> AnnotationTarget ((record Annotation_target.project) value)
    | _ -> assert false

  let to_json = function
    | ResourceId value -> json_string value
    | AnnotationTarget value -> Annotation_target.to_json value
end

module Browse_engines_result_response = struct
  type t = { engines : Engine_entry.t list }

  let project fields =
    let reader = start fields in
    { engines = required reader (list (record Engine_entry.project)) "engines" }

  let to_json (value : t) =
    write [ ("engines", Some ((json_list Engine_entry.to_json) value.engines)) ]
end

module Browse_resource_result_response = struct
  type t = { resource : Resource_descriptor.t; last_sequence : int }

  let project fields =
    let reader = start fields in
    {
      resource = required reader (record Resource_descriptor.project) "resource";
      last_sequence = required reader int "lastSequence";
    }

  let to_json (value : t) =
    write
      [
        ("resource", Some (Resource_descriptor.to_json value.resource));
        ("lastSequence", Some (json_int value.last_sequence));
      ]
end

module Gathered_context_focus_resource = struct
  module Kind = struct
    type t = Resource

    let to_string = function Resource -> "resource"
    let of_string = function "resource" -> Some Resource | _ -> None
  end

  type t = {
    kind : Kind.t;
    resource : Resource_descriptor.t;
    summary : string option;
    suggested_references : string list option;
    content : Gathered_context_focus_resource_content.t option;
  }

  let project fields =
    let reader = start fields in
    {
      kind = required reader (enum Kind.of_string) "kind";
      resource = required reader (record Resource_descriptor.project) "resource";
      summary = maybe reader string "summary";
      suggested_references = maybe reader (list string) "suggestedReferences";
      content =
        maybe reader
          (record Gathered_context_focus_resource_content.project)
          "content";
    }

  let to_json (value : t) =
    write
      [
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("resource", Some (Resource_descriptor.to_json value.resource));
        ("summary", Option.map json_string value.summary);
        ( "suggestedReferences",
          Option.map (json_list json_string) value.suggested_references );
        ( "content",
          Option.map Gathered_context_focus_resource_content.to_json
            value.content );
      ]
end

module Inference_spec = struct
  type t = {
    providers : (string * Provider.t) list;
    engines : Archivist_engines.t;
  }

  let project fields =
    let reader = start fields in
    {
      providers = required reader (map (record Provider.project)) "providers";
      engines = required reader (record Archivist_engines.project) "engines";
    }

  let to_json (value : t) =
    write
      [
        ("providers", Some ((json_map Provider.to_json) value.providers));
        ("engines", Some (Archivist_engines.to_json value.engines));
      ]
end

module Conformance_driver_line_emission = struct
  type t = { emission : Conformance_driver_line_emission_emission.t }

  let project fields =
    let reader = start fields in
    {
      emission =
        required reader
          (record Conformance_driver_line_emission_emission.project)
          "emission";
    }

  let to_json (value : t) =
    write
      [
        ( "emission",
          Some
            (Conformance_driver_line_emission_emission.to_json value.emission)
        );
      ]
end

module Annotation = struct
  module Field_context = struct
    type t = Field_context

    let to_string = function
      | Field_context -> "http://www.w3.org/ns/anno.jsonld"

    let of_string = function
      | "http://www.w3.org/ns/anno.jsonld" -> Some Field_context
      | _ -> None
  end

  module Type_ = struct
    type t = Annotation

    let to_string = function Annotation -> "Annotation"
    let of_string = function "Annotation" -> Some Annotation | _ -> None
  end

  type t = {
    field_context : Field_context.t;
    type_ : Type_.t;
    id : string;
    motivation : Enums.Motivation.t;
    target : Annotation_target_value.t;
    body : Annotation_bodies.t option;
    creator : Agent.t option;
    created : string;
    modified : string option;
    generator : One_or_more_agents.t option;
    was_attributed_to : One_or_more_agents.t option;
  }

  let project fields =
    let reader = start fields in
    {
      field_context = required reader (enum Field_context.of_string) "@context";
      type_ = required reader (enum Type_.of_string) "type";
      id = required reader string "id";
      motivation =
        required reader (enum Enums.Motivation.of_string) "motivation";
      target = required reader Annotation_target_value.read "target";
      body = maybe reader Annotation_bodies.read "body";
      creator = maybe reader Agent.read "creator";
      created = required reader string "created";
      modified = maybe reader string "modified";
      generator = maybe reader One_or_more_agents.read "generator";
      was_attributed_to = maybe reader One_or_more_agents.read "wasAttributedTo";
    }

  let of_model (model : [ `Annotation ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "@context",
          Some ((json_enum Field_context.to_string) value.field_context) );
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("id", Some (json_string value.id));
        ( "motivation",
          Some ((json_enum Enums.Motivation.to_string) value.motivation) );
        ("target", Some (Annotation_target_value.to_json value.target));
        ("body", Option.map Annotation_bodies.to_json value.body);
        ("creator", Option.map Agent.to_json value.creator);
        ("created", Some (json_string value.created));
        ("modified", Option.map json_string value.modified);
        ("generator", Option.map One_or_more_agents.to_json value.generator);
        ( "wasAttributedTo",
          Option.map One_or_more_agents.to_json value.was_attributed_to );
      ]

  let to_model value =
    Models.decode Models.annotation (Yojson.Raw.to_string (to_json value))
end

module Browse_engines_result = struct
  type t = { response : Browse_engines_result_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader
          (record Browse_engines_result_response.project)
          "response";
    }

  let of_model (model : [ `BrowseEnginesResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "response",
          Some (Browse_engines_result_response.to_json value.response) );
      ]

  let to_model value =
    Models.decode Models.browse_engines_result
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resource_result = struct
  type t = { response : Browse_resource_result_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader
          (record Browse_resource_result_response.project)
          "response";
    }

  let of_model (model : [ `BrowseResourceResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "response",
          Some (Browse_resource_result_response.to_json value.response) );
      ]

  let to_model value =
    Models.decode Models.browse_resource_result
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resources_result = struct
  type t = { response : List_resources_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader (record List_resources_response.project) "response";
    }

  let of_model (model : [ `BrowseResourcesResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (List_resources_response.to_json value.response)) ]

  let to_model value =
    Models.decode Models.browse_resources_result
      (Yojson.Raw.to_string (to_json value))
end

module Job_status_result = struct
  type t = { response : Job_status_response.t }

  let project fields =
    let reader = start fields in
    {
      response = required reader (record Job_status_response.project) "response";
    }

  let of_model (model : [ `JobStatusResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("response", Some (Job_status_response.to_json value.response)) ]

  let to_model value =
    Models.decode Models.job_status_result
      (Yojson.Raw.to_string (to_json value))
end

module Mark_create_request = struct
  type t = { resource_id : string; request : Create_annotation_request.t }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      request =
        required reader (record Create_annotation_request.project) "request";
    }

  let of_model (model : [ `MarkCreateRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("request", Some (Create_annotation_request.to_json value.request));
      ]

  let to_model value =
    Models.decode Models.mark_create_request
      (Yojson.Raw.to_string (to_json value))
end

module Match_resources_result = struct
  type t = { response : Match_resources_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader (record Match_resources_response.project) "response";
    }

  let of_model (model : [ `MatchResourcesResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Match_resources_response.to_json value.response)) ]

  let to_model value =
    Models.decode Models.match_resources_result
      (Yojson.Raw.to_string (to_json value))
end

module Job_claimed_result = struct
  type t = { response : Job_running.t }

  let project fields =
    let reader = start fields in
    { response = required reader (record Job_running.project) "response" }

  let of_model (model : [ `JobClaimedResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("response", Some (Job_running.to_json value.response)) ]

  let to_model value =
    Models.decode Models.job_claimed_result
      (Yojson.Raw.to_string (to_json value))
end

module Inference = struct
  module Kind = struct
    type t = Inference

    let to_string = function Inference -> "Inference"
    let of_string = function "Inference" -> Some Inference | _ -> None
  end

  type t = {
    api_version : Enums.Stack_api_version.t;
    kind : Kind.t;
    metadata : Metadata.t;
    spec : Inference_spec.t;
  }

  let project fields =
    let reader = start fields in
    {
      api_version =
        required reader (enum Enums.Stack_api_version.of_string) "apiVersion";
      kind = required reader (enum Kind.of_string) "kind";
      metadata = required reader (record Metadata.project) "metadata";
      spec = required reader (record Inference_spec.project) "spec";
    }

  let of_model (model : [ `Inference ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "apiVersion",
          Some ((json_enum Enums.Stack_api_version.to_string) value.api_version)
        );
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("metadata", Some (Metadata.to_json value.metadata));
        ("spec", Some (Inference_spec.to_json value.spec));
      ]

  let to_model value =
    Models.decode Models.inference (Yojson.Raw.to_string (to_json value))
end

module Worker_config = struct
  type t = {
    knowledge_bases : Worker_knowledge_base_config.t list;
    model_catalogue : string;
    port : int;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
  }

  let project fields =
    let reader = start fields in
    {
      knowledge_bases =
        required reader
          (list (record Worker_knowledge_base_config.project))
          "knowledgeBases";
      model_catalogue = required reader string "modelCatalogue";
      port = required reader int "port";
      log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
      log_format = required reader (enum Enums.Log_format.of_string) "logFormat";
    }

  let of_model (model : [ `WorkerConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "knowledgeBases",
          Some
            ((json_list Worker_knowledge_base_config.to_json)
               value.knowledge_bases) );
        ("modelCatalogue", Some (json_string value.model_catalogue));
        ("port", Some (json_int value.port));
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ( "logFormat",
          Some ((json_enum Enums.Log_format.to_string) value.log_format) );
      ]

  let to_model value =
    Models.decode Models.worker_config (Yojson.Raw.to_string (to_json value))
end

module Worker_health = struct
  module Status = struct
    type t = Ok

    let to_string = function Ok -> "ok"
    let of_string = function "ok" -> Some Ok | _ -> None
  end

  type t = {
    status : Status.t;
    knowledge_bases : Worker_knowledge_base_health.t list;
  }

  let project fields =
    let reader = start fields in
    {
      status = required reader (enum Status.of_string) "status";
      knowledge_bases =
        required reader
          (list (record Worker_knowledge_base_health.project))
          "knowledgeBases";
    }

  let of_model (model : [ `WorkerHealth ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ( "knowledgeBases",
          Some
            ((json_list Worker_knowledge_base_health.to_json)
               value.knowledge_bases) );
      ]

  let to_model value =
    Models.decode Models.worker_health (Yojson.Raw.to_string (to_json value))
end

module Job = struct
  type t =
    | JobPending of Job_pending.t
    | JobRunning of Job_running.t
    | JobComplete of Job_complete.t
    | JobFailed of Job_failed.t
    | JobCancelled of Job_cancelled.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "status"; "metadata"; "params" ];
          allowed = Some [ "status"; "metadata"; "params" ];
          fixed = [ ("status", [ Text_value "pending" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "status"; "metadata"; "params"; "startedAt"; "progress" ];
          allowed =
            Some [ "status"; "metadata"; "params"; "startedAt"; "progress" ];
          fixed = [ ("status", [ Text_value "running" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required =
            [
              "status";
              "metadata";
              "params";
              "startedAt";
              "completedAt";
              "result";
            ];
          allowed =
            Some
              [
                "status";
                "metadata";
                "params";
                "startedAt";
                "completedAt";
                "result";
              ];
          fixed = [ ("status", [ Text_value "complete" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "status"; "metadata"; "params"; "completedAt"; "error" ];
          allowed =
            Some
              [
                "status";
                "metadata";
                "params";
                "startedAt";
                "completedAt";
                "error";
                "failureClass";
              ];
          fixed =
            [
              ("status", [ Text_value "failed" ]);
              ( "failureClass",
                [
                  Text_value "transient";
                  Text_value "deterministic";
                  Text_value "withheld";
                ] );
            ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "status"; "metadata"; "params"; "completedAt" ];
          allowed =
            Some [ "status"; "metadata"; "params"; "startedAt"; "completedAt" ];
          fixed = [ ("status", [ Text_value "cancelled" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> JobPending ((record Job_pending.project) value)
    | 1 -> JobRunning ((record Job_running.project) value)
    | 2 -> JobComplete ((record Job_complete.project) value)
    | 3 -> JobFailed ((record Job_failed.project) value)
    | 4 -> JobCancelled ((record Job_cancelled.project) value)
    | _ -> assert false

  let of_model (model : [ `Job ] Models.t) = read (Models.json model)

  let to_json = function
    | JobPending value -> Job_pending.to_json value
    | JobRunning value -> Job_running.to_json value
    | JobComplete value -> Job_complete.to_json value
    | JobFailed value -> Job_failed.to_json value
    | JobCancelled value -> Job_cancelled.to_json value

  let to_model value =
    Models.decode Models.job (Yojson.Raw.to_string (to_json value))
end

module Conformance_driver_line = struct
  type t =
    | Ready of Conformance_driver_line_ready.t
    | Ok of Conformance_driver_line_ok.t
    | Failed of Conformance_driver_line_failed.t
    | Abandoned of Conformance_driver_line_abandoned.t
    | Unsupported of Conformance_driver_line_unsupported.t
    | Misuse of Conformance_driver_line_misuse.t
    | State of Conformance_driver_line_state.t
    | Frame of Conformance_driver_line_frame.t
    | ErrorStream of Conformance_driver_line_error_stream.t
    | Progress of Conformance_driver_line_progress.t
    | Emission of Conformance_driver_line_emission.t
    | Completed of Conformance_driver_line_completed.t
    | Claimed of Conformance_driver_line_claimed.t
    | Refused of Conformance_driver_line_refused.t
    | Signalled of Conformance_driver_line_signalled.t
    | Stalled of Conformance_driver_line_stalled.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "ready" ];
          allowed = Some [ "ready" ];
          fixed = [ ("ready", [ Boolean_value true ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "id"; "ok" ];
          allowed = Some [ "id"; "ok" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "id"; "error" ];
          allowed = Some [ "id"; "error" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "id"; "abandoned" ];
          allowed = Some [ "id"; "abandoned" ];
          fixed = [ ("abandoned", [ Boolean_value true ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "id"; "unsupported" ];
          allowed = Some [ "id"; "unsupported" ];
          fixed = [ ("unsupported", [ Boolean_value true ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "id"; "misuse" ];
          allowed = Some [ "id"; "misuse" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "state" ];
          allowed = Some [ "state" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "frame" ];
          allowed = Some [ "frame" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "error" ];
          allowed = Some [ "error" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "progress" ];
          allowed = Some [ "progress" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "emission" ];
          allowed = Some [ "emission" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "completed" ];
          allowed = Some [ "completed" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "claimed" ];
          allowed = Some [ "claimed" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "refused" ];
          allowed = Some [ "refused" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "signalled" ];
          allowed = Some [ "signalled" ];
          fixed = [];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "stalled" ];
          allowed = Some [ "stalled" ];
          fixed = [];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> Ready ((record Conformance_driver_line_ready.project) value)
    | 1 -> Ok ((record Conformance_driver_line_ok.project) value)
    | 2 -> Failed ((record Conformance_driver_line_failed.project) value)
    | 3 -> Abandoned ((record Conformance_driver_line_abandoned.project) value)
    | 4 ->
        Unsupported ((record Conformance_driver_line_unsupported.project) value)
    | 5 -> Misuse ((record Conformance_driver_line_misuse.project) value)
    | 6 -> State ((record Conformance_driver_line_state.project) value)
    | 7 -> Frame ((record Conformance_driver_line_frame.project) value)
    | 8 ->
        ErrorStream
          ((record Conformance_driver_line_error_stream.project) value)
    | 9 -> Progress ((record Conformance_driver_line_progress.project) value)
    | 10 -> Emission ((record Conformance_driver_line_emission.project) value)
    | 11 -> Completed ((record Conformance_driver_line_completed.project) value)
    | 12 -> Claimed ((record Conformance_driver_line_claimed.project) value)
    | 13 -> Refused ((record Conformance_driver_line_refused.project) value)
    | 14 -> Signalled ((record Conformance_driver_line_signalled.project) value)
    | 15 -> Stalled ((record Conformance_driver_line_stalled.project) value)
    | _ -> assert false

  let of_model (model : [ `ConformanceDriverLine ] Models.t) =
    read (Models.json model)

  let to_json = function
    | Ready value -> Conformance_driver_line_ready.to_json value
    | Ok value -> Conformance_driver_line_ok.to_json value
    | Failed value -> Conformance_driver_line_failed.to_json value
    | Abandoned value -> Conformance_driver_line_abandoned.to_json value
    | Unsupported value -> Conformance_driver_line_unsupported.to_json value
    | Misuse value -> Conformance_driver_line_misuse.to_json value
    | State value -> Conformance_driver_line_state.to_json value
    | Frame value -> Conformance_driver_line_frame.to_json value
    | ErrorStream value -> Conformance_driver_line_error_stream.to_json value
    | Progress value -> Conformance_driver_line_progress.to_json value
    | Emission value -> Conformance_driver_line_emission.to_json value
    | Completed value -> Conformance_driver_line_completed.to_json value
    | Claimed value -> Conformance_driver_line_claimed.to_json value
    | Refused value -> Conformance_driver_line_refused.to_json value
    | Signalled value -> Conformance_driver_line_signalled.to_json value
    | Stalled value -> Conformance_driver_line_stalled.to_json value

  let to_model value =
    Models.decode Models.conformance_driver_line
      (Yojson.Raw.to_string (to_json value))
end

module Annotation_added_payload = struct
  type t = { annotation : Annotation.t; content_checksum : string option }

  let project fields =
    let reader = start fields in
    {
      annotation = required reader (record Annotation.project) "annotation";
      content_checksum = maybe reader string "contentChecksum";
    }

  let of_model (model : [ `AnnotationAddedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotation", Some (Annotation.to_json value.annotation));
        ("contentChecksum", Option.map json_string value.content_checksum);
      ]

  let to_model value =
    Models.decode Models.annotation_added_payload
      (Yojson.Raw.to_string (to_json value))
end

module Enriched_resource_event = struct
  type t = {
    id : string;
    type_ : string;
    timestamp : string;
    user_id : string;
    resource_id : string option;
    version : int;
    payload : (string * Yojson.Raw.t) list;
    metadata : Event_metadata.t;
    annotation : Annotation.t option;
  }

  let project fields =
    let reader = start fields in
    {
      id = required reader string "id";
      type_ = required reader string "type";
      timestamp = required reader string "timestamp";
      user_id = required reader string "userId";
      resource_id = maybe reader string "resourceId";
      version = required reader int "version";
      payload = required reader (map raw) "payload";
      metadata = required reader (record Event_metadata.project) "metadata";
      annotation = maybe reader (record Annotation.project) "annotation";
    }

  let of_model (model : [ `EnrichedResourceEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("type", Some (json_string value.type_));
        ("timestamp", Some (json_string value.timestamp));
        ("userId", Some (json_string value.user_id));
        ("resourceId", Option.map json_string value.resource_id);
        ("version", Some (json_int value.version));
        ("payload", Some ((json_map json_raw) value.payload));
        ("metadata", Some (Event_metadata.to_json value.metadata));
        ("annotation", Option.map Annotation.to_json value.annotation);
      ]

  let to_model value =
    Models.decode Models.enriched_resource_event
      (Yojson.Raw.to_string (to_json value))
end

module Get_annotation_response = struct
  type t = {
    annotation : Annotation.t;
    resource : Resource_descriptor.t option;
    resolved_resource : Resource_descriptor.t option;
  }

  let project fields =
    let reader = start fields in
    {
      annotation = required reader (record Annotation.project) "annotation";
      resource =
        required reader
          (nullable (record Resource_descriptor.project))
          "resource";
      resolved_resource =
        required reader
          (nullable (record Resource_descriptor.project))
          "resolvedResource";
    }

  let of_model (model : [ `GetAnnotationResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotation", Some (Annotation.to_json value.annotation));
        ( "resource",
          Some ((json_nullable Resource_descriptor.to_json) value.resource) );
        ( "resolvedResource",
          Some
            ((json_nullable Resource_descriptor.to_json)
               value.resolved_resource) );
      ]

  let to_model value =
    Models.decode Models.get_annotation_response
      (Yojson.Raw.to_string (to_json value))
end

module Get_annotations_response = struct
  type t = {
    annotations : Annotation.t list;
    total : float;
    motivation : Enums.Motivation.t option;
  }

  let project fields =
    let reader = start fields in
    {
      annotations =
        required reader (list (record Annotation.project)) "annotations";
      total = required reader float "total";
      motivation = maybe reader (enum Enums.Motivation.of_string) "motivation";
    }

  let of_model (model : [ `GetAnnotationsResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotations", Some ((json_list Annotation.to_json) value.annotations));
        ("total", Some (json_float value.total));
        ( "motivation",
          Option.map (json_enum Enums.Motivation.to_string) value.motivation );
      ]

  let to_model value =
    Models.decode Models.get_annotations_response
      (Yojson.Raw.to_string (to_json value))
end

module Get_resource_response = struct
  type t = { resource : Resource_descriptor.t; annotations : Annotation.t list }

  let project fields =
    let reader = start fields in
    {
      resource = required reader (record Resource_descriptor.project) "resource";
      annotations =
        required reader (list (record Annotation.project)) "annotations";
    }

  let of_model (model : [ `GetResourceResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resource", Some (Resource_descriptor.to_json value.resource));
        ("annotations", Some ((json_list Annotation.to_json) value.annotations));
      ]

  let to_model value =
    Models.decode Models.get_resource_response
      (Yojson.Raw.to_string (to_json value))
end

module Graph_annotation_node = struct
  module Type_ = struct
    type t = Annotation

    let to_string = function Annotation -> "annotation"
    let of_string = function "annotation" -> Some Annotation | _ -> None
  end

  type t = {
    id : string;
    type_ : Type_.t;
    label : string;
    entity_types : string list option;
    annotation : Annotation.t;
    metadata : (string * Yojson.Raw.t) list option;
  }

  let project fields =
    let reader = start fields in
    {
      id = required reader string "id";
      type_ = required reader (enum Type_.of_string) "type";
      label = required reader string "label";
      entity_types = maybe reader (list string) "entityTypes";
      annotation = required reader (record Annotation.project) "annotation";
      metadata = maybe reader (map raw) "metadata";
    }

  let of_model (model : [ `GraphAnnotationNode ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("label", Some (json_string value.label));
        ("entityTypes", Option.map (json_list json_string) value.entity_types);
        ("annotation", Some (Annotation.to_json value.annotation));
        ("metadata", Option.map (json_map json_raw) value.metadata);
      ]

  let to_model value =
    Models.decode Models.graph_annotation_node
      (Yojson.Raw.to_string (to_json value))
end

module Mark_commit_command = struct
  type t = {
    field_user_id : string option;
    field_roles : string list option;
    job_id : string option;
    resource_id : string;
    annotations : Annotation.t list;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      field_roles = maybe reader (list string) "_roles";
      job_id = maybe reader string "jobId";
      resource_id = required reader string "resourceId";
      annotations =
        required reader (list (record Annotation.project)) "annotations";
    }

  let of_model (model : [ `MarkCommitCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("_roles", Option.map (json_list json_string) value.field_roles);
        ("jobId", Option.map json_string value.job_id);
        ("resourceId", Some (json_string value.resource_id));
        ("annotations", Some ((json_list Annotation.to_json) value.annotations));
      ]

  let to_model value =
    Models.decode Models.mark_commit_command
      (Yojson.Raw.to_string (to_json value))
end

module Job_record = struct
  type t = { job : Job.t; last_progress_at : string }

  let project fields =
    let reader = start fields in
    {
      job = required reader Job.read "job";
      last_progress_at = required reader string "lastProgressAt";
    }

  let of_model (model : [ `JobRecord ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("job", Some (Job.to_json value.job));
        ("lastProgressAt", Some (json_string value.last_progress_at));
      ]

  let to_model value =
    Models.decode Models.job_record (Yojson.Raw.to_string (to_json value))
end

module Resource_annotations = struct
  type t = {
    resource_id : string;
    annotations : Annotation.t list;
    version : int;
    updated_at : string;
  }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      annotations =
        required reader (list (record Annotation.project)) "annotations";
      version = required reader int "version";
      updated_at = required reader string "updatedAt";
    }

  let of_model (model : [ `ResourceAnnotations ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("annotations", Some ((json_list Annotation.to_json) value.annotations));
        ("version", Some (json_int value.version));
        ("updatedAt", Some (json_string value.updated_at));
      ]

  let to_model value =
    Models.decode Models.resource_annotations
      (Yojson.Raw.to_string (to_json value))
end

module Gathered_context_focus_annotation = struct
  module Kind = struct
    type t = Annotation

    let to_string = function Annotation -> "annotation"
    let of_string = function "annotation" -> Some Annotation | _ -> None
  end

  type t = {
    kind : Kind.t;
    annotation : Annotation.t;
    source_resource : Resource_descriptor.t;
    selected : Gathered_context_focus_annotation_selected.t option;
    user_hint : string option;
    target_resource : Resource_descriptor.t option;
    target_context : Gathered_context_focus_annotation_target_context.t option;
  }

  let project fields =
    let reader = start fields in
    {
      kind = required reader (enum Kind.of_string) "kind";
      annotation = required reader (record Annotation.project) "annotation";
      source_resource =
        required reader (record Resource_descriptor.project) "sourceResource";
      selected =
        maybe reader
          (record Gathered_context_focus_annotation_selected.project)
          "selected";
      user_hint = maybe reader string "userHint";
      target_resource =
        maybe reader (record Resource_descriptor.project) "targetResource";
      target_context =
        maybe reader
          (record Gathered_context_focus_annotation_target_context.project)
          "targetContext";
    }

  let to_json (value : t) =
    write
      [
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("annotation", Some (Annotation.to_json value.annotation));
        ( "sourceResource",
          Some (Resource_descriptor.to_json value.source_resource) );
        ( "selected",
          Option.map Gathered_context_focus_annotation_selected.to_json
            value.selected );
        ("userHint", Option.map json_string value.user_hint);
        ( "targetResource",
          Option.map Resource_descriptor.to_json value.target_resource );
        ( "targetContext",
          Option.map Gathered_context_focus_annotation_target_context.to_json
            value.target_context );
      ]
end

module Browse_annotation_result = struct
  type t = { response : Get_annotation_response.t }

  let project fields =
    let reader = start fields in
    {
      response =
        required reader (record Get_annotation_response.project) "response";
    }

  let of_model (model : [ `BrowseAnnotationResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Get_annotation_response.to_json value.response)) ]

  let to_model value =
    Models.decode Models.browse_annotation_result
      (Yojson.Raw.to_string (to_json value))
end

module Resource_view = struct
  type t = {
    resource : Resource_descriptor.t;
    annotations : Resource_annotations.t;
    last_sequence : int;
  }

  let project fields =
    let reader = start fields in
    {
      resource = required reader (record Resource_descriptor.project) "resource";
      annotations =
        required reader (record Resource_annotations.project) "annotations";
      last_sequence = required reader int "lastSequence";
    }

  let of_model (model : [ `ResourceView ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resource", Some (Resource_descriptor.to_json value.resource));
        ("annotations", Some (Resource_annotations.to_json value.annotations));
        ("lastSequence", Some (json_int value.last_sequence));
      ]

  let to_model value =
    Models.decode Models.resource_view (Yojson.Raw.to_string (to_json value))
end

module Gathered_context_focus = struct
  type t =
    | Annotation of Gathered_context_focus_annotation.t
    | Resource of Gathered_context_focus_resource.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "kind"; "annotation"; "sourceResource" ];
          allowed = None;
          fixed = [ ("kind", [ Text_value "annotation" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "kind"; "resource" ];
          allowed = None;
          fixed = [ ("kind", [ Text_value "resource" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> Annotation ((record Gathered_context_focus_annotation.project) value)
    | 1 -> Resource ((record Gathered_context_focus_resource.project) value)
    | _ -> assert false

  let to_json = function
    | Annotation value -> Gathered_context_focus_annotation.to_json value
    | Resource value -> Gathered_context_focus_resource.to_json value
end

module Knowledge_graph_nodes_item = struct
  type t =
    | GraphResourceNode of Graph_resource_node.t
    | GraphAnnotationNode of Graph_annotation_node.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "id"; "type"; "label" ];
          allowed = None;
          fixed = [ ("type", [ Text_value "resource" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "id"; "type"; "label"; "annotation" ];
          allowed = None;
          fixed = [ ("type", [ Text_value "annotation" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> GraphResourceNode ((record Graph_resource_node.project) value)
    | 1 -> GraphAnnotationNode ((record Graph_annotation_node.project) value)
    | _ -> assert false

  let to_json = function
    | GraphResourceNode value -> Graph_resource_node.to_json value
    | GraphAnnotationNode value -> Graph_annotation_node.to_json value
end

module Knowledge_graph = struct
  type t = {
    nodes : Knowledge_graph_nodes_item.t list;
    edges : Knowledge_graph_edges_item.t list;
    truncated : bool option;
  }

  let project fields =
    let reader = start fields in
    {
      nodes = required reader (list Knowledge_graph_nodes_item.read) "nodes";
      edges =
        required reader
          (list (record Knowledge_graph_edges_item.project))
          "edges";
      truncated = maybe reader bool "truncated";
    }

  let of_model (model : [ `KnowledgeGraph ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "nodes",
          Some ((json_list Knowledge_graph_nodes_item.to_json) value.nodes) );
        ( "edges",
          Some ((json_list Knowledge_graph_edges_item.to_json) value.edges) );
        ("truncated", Option.map json_bool value.truncated);
      ]

  let to_model value =
    Models.decode Models.knowledge_graph (Yojson.Raw.to_string (to_json value))
end

module Gathered_context = struct
  type t = {
    focus : Gathered_context_focus.t;
    graph : Knowledge_graph.t;
    semantic_context : Gathered_context_semantic_context.t option;
    metadata : Gathered_context_metadata.t;
    inferred_relationship_summary : string option;
  }

  let project fields =
    let reader = start fields in
    {
      focus = required reader Gathered_context_focus.read "focus";
      graph = required reader (record Knowledge_graph.project) "graph";
      semantic_context =
        maybe reader
          (record Gathered_context_semantic_context.project)
          "semanticContext";
      metadata =
        required reader (record Gathered_context_metadata.project) "metadata";
      inferred_relationship_summary =
        maybe reader string "inferredRelationshipSummary";
    }

  let of_model (model : [ `GatheredContext ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("focus", Some (Gathered_context_focus.to_json value.focus));
        ("graph", Some (Knowledge_graph.to_json value.graph));
        ( "semanticContext",
          Option.map Gathered_context_semantic_context.to_json
            value.semantic_context );
        ("metadata", Some (Gathered_context_metadata.to_json value.metadata));
        ( "inferredRelationshipSummary",
          Option.map json_string value.inferred_relationship_summary );
      ]

  let to_model value =
    Models.decode Models.gathered_context (Yojson.Raw.to_string (to_json value))
end

module Gather_annotation_complete = struct
  type t = { annotation_id : string; response : Gathered_context.t }

  let project fields =
    let reader = start fields in
    {
      annotation_id = required reader string "annotationId";
      response = required reader (record Gathered_context.project) "response";
    }

  let of_model (model : [ `GatherAnnotationComplete ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Some (json_string value.annotation_id));
        ("response", Some (Gathered_context.to_json value.response));
      ]

  let to_model value =
    Models.decode Models.gather_annotation_complete
      (Yojson.Raw.to_string (to_json value))
end

module Gather_resource_complete = struct
  type t = { resource_id : string; response : Gathered_context.t }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      response = required reader (record Gathered_context.project) "response";
    }

  let of_model (model : [ `GatherResourceComplete ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("response", Some (Gathered_context.to_json value.response));
      ]

  let to_model value =
    Models.decode Models.gather_resource_complete
      (Yojson.Raw.to_string (to_json value))
end

module Generation_job_params = struct
  type t = {
    title : string;
    storage_uri : string;
    prompt : string option;
    entity_types : string list option;
    language : string option;
    source_language : string option;
    temperature : float option;
    max_tokens : float option;
    output_media_type : Enums.Supported_media_type.t option;
    task : string option;
    structure : string option;
    cite : bool option;
    context : Gathered_context.t;
  }

  let project fields =
    let reader = start fields in
    {
      title = required reader string "title";
      storage_uri = required reader string "storageUri";
      prompt = maybe reader string "prompt";
      entity_types = maybe reader (list string) "entityTypes";
      language = maybe reader string "language";
      source_language = maybe reader string "sourceLanguage";
      temperature = maybe reader float "temperature";
      max_tokens = maybe reader float "maxTokens";
      output_media_type =
        maybe reader
          (enum Enums.Supported_media_type.of_string)
          "outputMediaType";
      task = maybe reader string "task";
      structure = maybe reader string "structure";
      cite = maybe reader bool "cite";
      context = required reader (record Gathered_context.project) "context";
    }

  let of_model (model : [ `GenerationJobParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("title", Some (json_string value.title));
        ("storageUri", Some (json_string value.storage_uri));
        ("prompt", Option.map json_string value.prompt);
        ("entityTypes", Option.map (json_list json_string) value.entity_types);
        ("language", Option.map json_string value.language);
        ("sourceLanguage", Option.map json_string value.source_language);
        ("temperature", Option.map json_float value.temperature);
        ("maxTokens", Option.map json_float value.max_tokens);
        ( "outputMediaType",
          Option.map
            (json_enum Enums.Supported_media_type.to_string)
            value.output_media_type );
        ("task", Option.map json_string value.task);
        ("structure", Option.map json_string value.structure);
        ("cite", Option.map json_bool value.cite);
        ("context", Some (Gathered_context.to_json value.context));
      ]

  let to_model value =
    Models.decode Models.generation_job_params
      (Yojson.Raw.to_string (to_json value))
end

module Match_search_request = struct
  type t = {
    resource_id : string;
    reference_id : string;
    context : Gathered_context.t;
    limit : int option;
    use_semantic_scoring : bool option;
  }

  let project fields =
    let reader = start fields in
    {
      resource_id = required reader string "resourceId";
      reference_id = required reader string "referenceId";
      context = required reader (record Gathered_context.project) "context";
      limit = maybe reader int "limit";
      use_semantic_scoring = maybe reader bool "useSemanticScoring";
    }

  let of_model (model : [ `MatchSearchRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("referenceId", Some (json_string value.reference_id));
        ("context", Some (Gathered_context.to_json value.context));
        ("limit", Option.map json_int value.limit);
        ("useSemanticScoring", Option.map json_bool value.use_semantic_scoring);
      ]

  let to_model value =
    Models.decode Models.match_search_request
      (Yojson.Raw.to_string (to_json value))
end

module Yield_job_create_command = struct
  module Job_type = struct
    type t = Yield

    let to_string = function Yield -> "yield"
    let of_string = function "yield" -> Some Yield | _ -> None
  end

  type t = {
    field_user_id : string option;
    field_roles : string list option;
    job_type : Job_type.t;
    params : Generation_job_params.t;
  }

  let project fields =
    let reader = start fields in
    {
      field_user_id = maybe reader string "_userId";
      field_roles = maybe reader (list string) "_roles";
      job_type = required reader (enum Job_type.of_string) "jobType";
      params = required reader (record Generation_job_params.project) "params";
    }

  let of_model (model : [ `YieldJobCreateCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("_roles", Option.map (json_list json_string) value.field_roles);
        ("jobType", Some ((json_enum Job_type.to_string) value.job_type));
        ("params", Some (Generation_job_params.to_json value.params));
      ]

  let to_model value =
    Models.decode Models.yield_job_create_command
      (Yojson.Raw.to_string (to_json value))
end

module Job_create_command = struct
  type t =
    | MarkJobCreateCommand of Mark_job_create_command.t
    | YieldJobCreateCommand of Yield_job_create_command.t

  let members =
    [
      [
        {
          kind = Object_kind;
          required = [ "jobType"; "resourceId"; "params" ];
          allowed =
            Some [ "_userId"; "_roles"; "jobType"; "resourceId"; "params" ];
          fixed = [ ("jobType", [ Text_value "mark" ]) ];
          values = None;
        };
      ];
      [
        {
          kind = Object_kind;
          required = [ "jobType"; "params" ];
          allowed = Some [ "_userId"; "_roles"; "jobType"; "params" ];
          fixed = [ ("jobType", [ Text_value "yield" ]) ];
          values = None;
        };
      ];
    ]

  let read value =
    match member members value with
    | 0 -> MarkJobCreateCommand ((record Mark_job_create_command.project) value)
    | 1 ->
        YieldJobCreateCommand ((record Yield_job_create_command.project) value)
    | _ -> assert false

  let of_model (model : [ `JobCreateCommand ] Models.t) =
    read (Models.json model)

  let to_json = function
    | MarkJobCreateCommand value -> Mark_job_create_command.to_json value
    | YieldJobCreateCommand value -> Yield_job_create_command.to_json value

  let to_model value =
    Models.decode Models.job_create_command
      (Yojson.Raw.to_string (to_json value))
end
