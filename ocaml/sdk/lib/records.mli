(* Generated from OpenAPI object components and discriminator mappings, and the records of Protocol's tables. Do not edit.
   Regenerate: make generate (codegen/lib/ocaml_sdk/records.ml) *)

module Pending_authorization_issuer : sig
  type t = {
    issuer : string;
    authorization : string;
    token : string;
    device : string option;
    revocation : string option;
  }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Connection_identity : sig
  type t = { did : string; description : [ `KbDescription ] Models.t }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Expected : sig
  type t = { did : string; name : string option }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Kb_read_verdict : sig
  type t =
    | Recorded
    | Conflict of { observed_did : string; observed_name : string }
    | NoVerdict

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Tab_check : sig
  type t =
    | Gone
    | Ready of { name : string; media_type : string option }
    | Unknown

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Session_ended : sig
  type t = { reason : Enums.Session_end_reason.t }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Permission_denied : sig
  type t = { detail : string option }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Kb_identity_conflict : sig
  type t = { expected_did : string; observed_did : string }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Stored_session : sig
  type t = {
    access : string;
    refresh : string;
    client_id : string;
    token_endpoint : string;
    revocation_endpoint : string option;
    person_key : string option;
  }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Last_event_ids : sig
  type t = (string * string) list

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Begin_authorization_options : sig
  type t = {
    target : [ `HttpEndpoint ] Models.t;
    redirect_uri : string;
    kb_id : string option;
    expected_did : string option;
    expected_name : string option;
  }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Claim_options : sig
  type t = {
    accepts : [ `JobFilter ] Models.t list;
    job_claim_timeout_ms : int option;
    held_job_stall_ms : int option;
    held_job_stall_check_ms : int option;
    mark_commit_timeout_ms : int option;
  }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Create_from_token_options : sig
  type t = {
    token : string;
    name : string;
    content : string;
    archive_original : bool option;
  }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Device_code : sig
  type t = {
    user_code : string;
    verification_uri : string;
    verification_uri_complete : string option;
    expires_in : int;
  }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Engine_with_limits : sig
  type t = {
    engine : [ `Engine ] Models.t;
    jobs : [ `JobFilter ] Models.t list option;
    limits : [ `InferenceLimits ] Models.t option;
  }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Gather_resource_options : sig
  type t = {
    depth : int option;
    max_resources : int option;
    include_content : bool option;
    include_summary : bool option;
    exclude_entity_types : string list option;
  }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Issued_tokens : sig
  type t = { access : string; refresh : string }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Job_poll_options : sig
  type t = { every_ms : int option; within_ms : int option }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Match_search_options : sig
  type t = { limit : int option; use_semantic_scoring : bool option }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Pdf_coordinate : sig
  type t = { page : int; x : float; y : float; width : float; height : float }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Pending_annotation : sig
  type t = {
    selector : [ `AnnotationSelector ] Models.t;
    motivation : [ `Motivation ] Models.t;
  }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Put_binary_request : sig
  type t = {
    name : string;
    file : string;
    format : string;
    storage_uri : string;
    language : string option;
    entity_types : string list option;
    source_annotation_id : string option;
    source_resource_id : string option;
    generation_prompt : string option;
    generator : [ `OneOrMoreAgents ] Models.t option;
    job_id : string option;
    is_draft : bool option;
    clone_token : string option;
    archive_original : bool option;
  }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Quoted_text : sig
  type t = { exact : string; prefix : string option; suffix : string option }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Reconciled_span : sig
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

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Resource_representation : sig
  type t = { data : string; content_type : string }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Resource_search_filters : sig
  type t = {
    archived : bool option;
    entity_type : string option;
    offset : int option;
    limit : int option;
  }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Text_span : sig
  type t = {
    start : int;
    end_ : int;
    exact : string;
    prefix : string option;
    suffix : string option;
  }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Upload_progress : sig
  type t =
    | Started of { total_bytes : int }
    | Progress of { bytes_uploaded : int; total_bytes : int }
    | Finished of { resource_id : string }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Signed_in : sig
  type t = {
    endpoint : [ `KbEndpoint ] Models.t;
    description : [ `KbDescription ] Models.t;
    session : Stored_session.t;
    kb_id : string option;
    expected_did : string option;
    expected_name : string option;
  }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Sign_in_outcome : sig
  type t = { kb : [ `KnowledgeBase ] Models.t; expected : Expected.t option }

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Pending_authorization : sig
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

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Engines_with_limits : sig
  type t = Engine_with_limits.t list

  val of_json : Yojson.Safe.t -> (t, Models.fault) result
  val to_json : t -> Yojson.Safe.t
end

module Agent_organization : sig
  module Field_type : sig
    type t = Organization

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    field_type : Field_type.t;
    field_id : string option;
    name : string;
    homepage : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  val of_model : [ `AgentOrganization ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AgentOrganization ] Models.t, Models.decode_error) result
end

module Agent_person : sig
  module Field_type : sig
    type t = Person

    val to_string : t -> string
    val of_string : string -> t option
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

  val of_model : [ `AgentPerson ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `AgentPerson ] Models.t, Models.decode_error) result
end

module Agent_software : sig
  module Field_type : sig
    type t = Software

    val to_string : t -> string
    val of_string : string -> t option
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

  val of_model : [ `AgentSoftware ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `AgentSoftware ] Models.t, Models.decode_error) result
end

module Annotation_removed_payload : sig
  type t = { annotation_id : string }

  val of_model : [ `AnnotationRemovedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AnnotationRemovedPayload ] Models.t, Models.decode_error) result
end

module Beckon_focus_event : sig
  type t = { annotation_id : string option; resource_id : string }

  val of_model : [ `BeckonFocusEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BeckonFocusEvent ] Models.t, Models.decode_error) result
end

module Beckon_hover_event : sig
  type t = { annotation_id : string option }

  val of_model : [ `BeckonHoverEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BeckonHoverEvent ] Models.t, Models.decode_error) result
end

module Beckon_sparkle_event : sig
  type t = { annotation_id : string }

  val of_model : [ `BeckonSparkleEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BeckonSparkleEvent ] Models.t, Models.decode_error) result
end

module Bind_initiate_command : sig
  type t = {
    annotation_id : string;
    resource_id : string;
    default_title : string;
    entity_types : string list;
  }

  val of_model : [ `BindInitiateCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BindInitiateCommand ] Models.t, Models.decode_error) result
end

module Browse_profiles_request : sig
  type t = { dids : string list }

  val of_model : [ `BrowseProfilesRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseProfilesRequest ] Models.t, Models.decode_error) result
end

module Browse_annotation_history_request : sig
  type t = { resource_id : string; annotation_id : string }

  val of_model : [ `BrowseAnnotationHistoryRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `BrowseAnnotationHistoryRequest ] Models.t, Models.decode_error) result
end

module Browse_annotation_request : sig
  type t = { resource_id : string; annotation_id : string }

  val of_model : [ `BrowseAnnotationRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseAnnotationRequest ] Models.t, Models.decode_error) result
end

module Anchor_rect : sig
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

  val of_model : [ `AnchorRect ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `AnchorRect ] Models.t, Models.decode_error) result
end

module Browse_directory_request : sig
  module Sort : sig
    type t = Name | Mtime | AnnotationCount

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { path : string; sort : Sort.t option }

  val of_model : [ `BrowseDirectoryRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseDirectoryRequest ] Models.t, Models.decode_error) result
end

module Browse_entity_type_clicked_event : sig
  type t = { entity_type : string }

  val of_model : [ `BrowseEntityTypeClickedEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `BrowseEntityTypeClickedEvent ] Models.t, Models.decode_error) result
end

module Browse_events_request : sig
  type t = {
    resource_id : string;
    type_ : string option;
    user_id : string option;
    limit : int option;
  }

  val of_model : [ `BrowseEventsRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseEventsRequest ] Models.t, Models.decode_error) result
end

module Browse_external_navigate_event : sig
  type t = { url : string; resource_id : string option }

  val of_model : [ `BrowseExternalNavigateEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseExternalNavigateEvent ] Models.t, Models.decode_error) result
end

module Browse_link_clicked_event : sig
  type t = { href : string; label : string option }

  val of_model : [ `BrowseLinkClickedEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseLinkClickedEvent ] Models.t, Models.decode_error) result
end

module Browse_panel_open_event : sig
  type t = {
    panel : string;
    scroll_to_annotation_id : string option;
    motivation : Enums.Motivation.t option;
  }

  val of_model : [ `BrowsePanelOpenEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowsePanelOpenEvent ] Models.t, Models.decode_error) result
end

module Browse_panel_toggle_event : sig
  type t = { panel : string }

  val of_model : [ `BrowsePanelToggleEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowsePanelToggleEvent ] Models.t, Models.decode_error) result
end

module Browse_resource_open_event : sig
  type t = { resource_id : string }

  val of_model : [ `BrowseResourceOpenEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseResourceOpenEvent ] Models.t, Models.decode_error) result
end

module Browse_resource_viewed_event : sig
  type t = { resource_id : string }

  val of_model : [ `BrowseResourceViewedEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseResourceViewedEvent ] Models.t, Models.decode_error) result
end

module Browse_resource_close_event : sig
  type t = { resource_id : string }

  val of_model : [ `BrowseResourceCloseEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseResourceCloseEvent ] Models.t, Models.decode_error) result
end

module Browse_resource_reorder_event : sig
  type t = { old_index : int; new_index : int }

  val of_model : [ `BrowseResourceReorderEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseResourceReorderEvent ] Models.t, Models.decode_error) result
end

module Pdf_text_item : sig
  type t = {
    start : int;
    end_ : int;
    page : int;
    x : float;
    y : float;
    width : float;
    height : float;
  }

  val of_model : [ `PdfTextItem ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `PdfTextItem ] Models.t, Models.decode_error) result
end

module Anchored_text_absent : sig
  module Kind : sig
    type t = Not_yet | No_map | Unknown

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { kind : Kind.t }

  val of_model : [ `AnchoredTextAbsent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AnchoredTextAbsent ] Models.t, Models.decode_error) result
end

module Browse_resource_request : sig
  type t = { resource_id : string }

  val of_model : [ `BrowseResourceRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseResourceRequest ] Models.t, Models.decode_error) result
end

module Browse_resources_request : sig
  type t = {
    archived : bool option;
    entity_type : string option;
    offset : int option;
    limit : int option;
  }

  val of_model : [ `BrowseResourcesRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseResourcesRequest ] Models.t, Models.decode_error) result
end

module Browse_router_push_event : sig
  type t = { path : string; reason : string option }

  val of_model : [ `BrowseRouterPushEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseRouterPushEvent ] Models.t, Models.decode_error) result
end

module Bus_emit_accepted : sig
  type t = { subscribers : int option }

  val of_model : [ `BusEmitAccepted ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BusEmitAccepted ] Models.t, Models.decode_error) result
end

module Bus_emit_request : sig
  type t = {
    channel : string;
    payload : (string * Yojson.Raw.t) list;
    scope : string option;
    client_id : string option;
    correlation_id : string option;
  }

  val of_model : [ `BusEmitRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `BusEmitRequest ] Models.t, Models.decode_error) result
end

module Command_error : sig
  module Code : sig
    type t = Peer_unavailable | Not_found | Unauthorized | None_pending

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { code : Code.t option; message : string; details : string option }

  val of_model : [ `CommandError ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `CommandError ] Models.t, Models.decode_error) result
end

module Create_resource_response : sig
  type t = { resource_id : string }

  val of_model : [ `CreateResourceResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `CreateResourceResponse ] Models.t, Models.decode_error) result
end

module Dir_entry : sig
  module Type_ : sig
    type t = Dir

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { type_ : Type_.t; name : string; path : string; mtime : string }

  val of_model : [ `DirEntry ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `DirEntry ] Models.t, Models.decode_error) result
end

module Discovered_kb : sig
  module Placement : sig
    type t = Local | Codespace

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    host : string;
    port : int;
    placement : Placement.t;
    repo : string option;
    did : string;
    site_name : string option;
    managed_by : string;
  }

  val of_model : [ `DiscoveredKB ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `DiscoveredKB ] Models.t, Models.decode_error) result
end

module Entity_tag_changed_payload : sig
  type t = { entity_type : string }

  val of_model : [ `EntityTagChangedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `EntityTagChangedPayload ] Models.t, Models.decode_error) result
end

module Entity_type_added_payload : sig
  type t = { entity_type : string }

  val of_model : [ `EntityTypeAddedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `EntityTypeAddedPayload ] Models.t, Models.decode_error) result
end

module Error_response : sig
  type t = {
    error : string;
    code : string option;
    hint : string option;
    details : Yojson.Raw.t Types.presence;
  }

  val of_model : [ `ErrorResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ErrorResponse ] Models.t, Models.decode_error) result
end

module Event_metadata : sig
  type t = { sequence_number : int }

  val of_model : [ `EventMetadata ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `EventMetadata ] Models.t, Models.decode_error) result
end

module Ocr_confidence : sig
  type t = { mean : float; low_confidence_words : int; total_words : int }

  val of_model : [ `OcrConfidence ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `OcrConfidence ] Models.t, Models.decode_error) result
end

module Extraction_declined : sig
  module Kind : sig
    type t = Declined

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { kind : Kind.t; declined : Enums.Extraction_declined_reason.t }

  val of_model : [ `ExtractionDeclined ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ExtractionDeclined ] Models.t, Models.decode_error) result
end

module File_entry : sig
  module Type_ : sig
    type t = File

    val to_string : t -> string
    val of_string : string -> t option
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

  val of_model : [ `FileEntry ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `FileEntry ] Models.t, Models.decode_error) result
end

module Fragment_selector : sig
  module Type_ : sig
    type t = FragmentSelector

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { type_ : Type_.t; value : string; conforms_to : string option }

  val of_model : [ `FragmentSelector ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `FragmentSelector ] Models.t, Models.decode_error) result
end

module Frame_add_entity_type_command : sig
  type t = { tag : string; field_user_id : string option }

  val of_model : [ `FrameAddEntityTypeCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `FrameAddEntityTypeCommand ] Models.t, Models.decode_error) result
end

module Gather_annotation_options : sig
  type t = {
    include_source_context : bool option;
    include_target_context : bool option;
    context_window : int option;
  }

  val of_model : [ `GatherAnnotationOptions ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GatherAnnotationOptions ] Models.t, Models.decode_error) result
end

module Gather_resource_request_options : sig
  type t = {
    depth : int;
    max_resources : int;
    include_content : bool;
    include_summary : bool;
    exclude_entity_types : string list option;
  }

  val of_model : [ `GatherResourceRequestOptions ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `GatherResourceRequestOptions ] Models.t, Models.decode_error) result
end

module Gather_summary_request : sig
  type t = { annotation_id : string; resource_id : string }

  val of_model : [ `GatherSummaryRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GatherSummaryRequest ] Models.t, Models.decode_error) result
end

module Gather_referenced_by_request : sig
  type t = { resource_id : string; motivation : Enums.Motivation.t option }

  val of_model : [ `GatherReferencedByRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GatherReferencedByRequest ] Models.t, Models.decode_error) result
end

module Get_entity_types_response : sig
  type t = { entity_types : string list }

  val of_model : [ `GetEntityTypesResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GetEntityTypesResponse ] Models.t, Models.decode_error) result
end

module Health_response : sig
  type t = {
    status : string;
    message : string;
    version : string;
    timestamp : string;
  }

  val of_model : [ `HealthResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `HealthResponse ] Models.t, Models.decode_error) result
end

module Inference_limits : sig
  type t = {
    context_tokens : float;
    max_output_tokens : float;
    accepts_temperature : bool option;
  }

  val of_model : [ `InferenceLimits ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `InferenceLimits ] Models.t, Models.decode_error) result
end

module Graph_resource_node : sig
  module Type_ : sig
    type t = Resource

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    id : string;
    type_ : Type_.t;
    label : string;
    entity_types : string list option;
    metadata : (string * Yojson.Raw.t) list option;
  }

  val of_model : [ `GraphResourceNode ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GraphResourceNode ] Models.t, Models.decode_error) result
end

module Job_cancel_request : sig
  type t = { job_id : string }

  val of_model : [ `JobCancelRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobCancelRequest ] Models.t, Models.decode_error) result
end

module Job_completed_payload : sig
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

  val of_model : [ `JobCompletedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobCompletedPayload ] Models.t, Models.decode_error) result
end

module Job_created_result_response : sig
  type t = { job_id : string }

  val of_model : [ `JobCreatedResultResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobCreatedResultResponse ] Models.t, Models.decode_error) result
end

module Unit_cursor : sig
  type t = { next : int; size : int; found : int; emitted : int; errors : int }

  val of_model : [ `UnitCursor ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `UnitCursor ] Models.t, Models.decode_error) result
end

module Job_declined : sig
  module Reason : sig
    type t = No_text_layer | Encrypted | Corrupt | Too_large | Empty

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { declined : bool; reason : Reason.t }

  val of_model : [ `JobDeclined ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `JobDeclined ] Models.t, Models.decode_error) result
end

module Job_failed_payload : sig
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

  val of_model : [ `JobFailedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobFailedPayload ] Models.t, Models.decode_error) result
end

module Yield_job_done : sig
  type t = { resource_id : string; resource_name : string; truncated : bool }

  val of_model : [ `YieldJobDone ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `YieldJobDone ] Models.t, Models.decode_error) result
end

module Job_progress_analyzing : sig
  module Code : sig
    type t = Analyzing

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { code : Code.t }

  val of_model : [ `JobProgressAnalyzing ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobProgressAnalyzing ] Models.t, Models.decode_error) result
end

module Job_progress_analyzing_tags : sig
  module Code : sig
    type t = Analyzing_tags

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { code : Code.t }

  val of_model : [ `JobProgressAnalyzingTags ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobProgressAnalyzingTags ] Models.t, Models.decode_error) result
end

module Job_progress_complete_created : sig
  module Code : sig
    type t = Complete_created

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { code : Code.t; count : int; motivation : Enums.Motivation.t }

  val of_model : [ `JobProgressCompleteCreated ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobProgressCompleteCreated ] Models.t, Models.decode_error) result
end

module Job_progress_complete_generated : sig
  module Code : sig
    type t = Complete_generated

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { code : Code.t; truncated : bool }

  val of_model : [ `JobProgressCompleteGenerated ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `JobProgressCompleteGenerated ] Models.t, Models.decode_error) result
end

module Job_progress_creating_annotations : sig
  module Code : sig
    type t = Creating_annotations

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { code : Code.t; count : int }

  val of_model : [ `JobProgressCreatingAnnotations ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `JobProgressCreatingAnnotations ] Models.t, Models.decode_error) result
end

module Job_progress_creating_resource : sig
  module Code : sig
    type t = Creating_resource

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { code : Code.t }

  val of_model : [ `JobProgressCreatingResource ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobProgressCreatingResource ] Models.t, Models.decode_error) result
end

module Job_progress_creating_tag_annotations : sig
  module Code : sig
    type t = Creating_tag_annotations

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { code : Code.t; count : int }

  val of_model : [ `JobProgressCreatingTagAnnotations ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ( [ `JobProgressCreatingTagAnnotations ] Models.t,
      Models.decode_error )
    result
end

module Job_progress_detecting_entities : sig
  module Code : sig
    type t = Detecting_entities

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { code : Code.t; entity_type : string }

  val of_model : [ `JobProgressDetectingEntities ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `JobProgressDetectingEntities ] Models.t, Models.decode_error) result
end

module Job_progress_generating_resource : sig
  module Code : sig
    type t = Generating_resource

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { code : Code.t }

  val of_model : [ `JobProgressGeneratingResource ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `JobProgressGeneratingResource ] Models.t, Models.decode_error) result
end

module Job_progress_loading : sig
  module Code : sig
    type t = Loading

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { code : Code.t }

  val of_model : [ `JobProgressLoading ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobProgressLoading ] Models.t, Models.decode_error) result
end

module Mark_job_done : sig
  type t = {
    found : int;
    persisted : int;
    errors : int option;
    by_category : (string * int) list option;
    under_reported_pieces : int option;
    unchecked_pieces : int option;
  }

  val of_model : [ `MarkJobDone ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `MarkJobDone ] Models.t, Models.decode_error) result
end

module Job_start_command : sig
  type t = {
    field_user_id : string option;
    resource_id : string;
    job_id : string;
    job_type : Enums.Job_type.t;
    annotation_id : string option;
    attempt : int option;
  }

  val of_model : [ `JobStartCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobStartCommand ] Models.t, Models.decode_error) result
end

module Job_assign_command : sig
  type t = {
    field_user_id : string option;
    job_id : string;
    job_type : Enums.Job_type.t;
    resource_id : string;
    holder : string;
    requester : string;
  }

  val of_model : [ `JobAssignCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobAssignCommand ] Models.t, Models.decode_error) result
end

module Job_started_payload : sig
  type t = {
    job_id : string;
    job_type : Enums.Job_type.t;
    annotation_id : string option;
    total_steps : int option;
  }

  val of_model : [ `JobStartedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobStartedPayload ] Models.t, Models.decode_error) result
end

module Job_assigned_payload : sig
  type t = {
    job_id : string;
    job_type : Enums.Job_type.t;
    resource_id : string;
    holder : string;
    requester : string;
  }

  val of_model : [ `JobAssignedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobAssignedPayload ] Models.t, Models.decode_error) result
end

module Principal_profile_command : sig
  type t = { field_user_id : string option; name : string }

  val of_model : [ `PrincipalProfileCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `PrincipalProfileCommand ] Models.t, Models.decode_error) result
end

module Principal_profiled_payload : sig
  type t = { name : string }

  val of_model : [ `PrincipalProfiledPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `PrincipalProfiledPayload ] Models.t, Models.decode_error) result
end

module Job_status_request : sig
  type t = { job_id : string }

  val of_model : [ `JobStatusRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobStatusRequest ] Models.t, Models.decode_error) result
end

module Kb_description : sig
  type t = { name : string; domain : string; git_branch : string option }

  val of_model : [ `KbDescription ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `KbDescription ] Models.t, Models.decode_error) result
end

module Http_endpoint : sig
  module Kind : sig
    type t = Http

    val to_string : t -> string
    val of_string : string -> t option
  end

  module Protocol : sig
    type t = Http | Https

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { kind : Kind.t; host : string; port : int; protocol : Protocol.t }

  val of_model : [ `HttpEndpoint ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `HttpEndpoint ] Models.t, Models.decode_error) result
end

module Kb_read : sig
  type t = { at : string; git_branch : string option }

  val of_model : [ `KbRead ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `KbRead ] Models.t, Models.decode_error) result
end

module Local_endpoint : sig
  module Kind : sig
    type t = Local

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { kind : Kind.t; kb_id : string }

  val of_model : [ `LocalEndpoint ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `LocalEndpoint ] Models.t, Models.decode_error) result
end

module Mark_archive_command : sig
  type t = {
    field_user_id : string option;
    resource_id : string;
    storage_uri : string option;
    keep_file : bool option;
  }

  val of_model : [ `MarkArchiveCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MarkArchiveCommand ] Models.t, Models.decode_error) result
end

module Mark_create_ok_response : sig
  type t = { annotation_id : string }

  val of_model : [ `MarkCreateOkResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MarkCreateOkResponse ] Models.t, Models.decode_error) result
end

module Mark_delete_command : sig
  type t = {
    field_user_id : string option;
    annotation_id : string;
    resource_id : string option;
  }

  val of_model : [ `MarkDeleteCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MarkDeleteCommand ] Models.t, Models.decode_error) result
end

module Mark_unarchive_command : sig
  type t = {
    field_user_id : string option;
    resource_id : string;
    storage_uri : string option;
  }

  val of_model : [ `MarkUnarchiveCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MarkUnarchiveCommand ] Models.t, Models.decode_error) result
end

module Mark_update_entity_types_command : sig
  type t = {
    resource_id : string;
    field_user_id : string option;
    current_entity_types : string list;
    updated_entity_types : string list;
  }

  val of_model : [ `MarkUpdateEntityTypesCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `MarkUpdateEntityTypesCommand ] Models.t, Models.decode_error) result
end

module Match_search_failed : sig
  module Code : sig
    type t = Peer_unavailable | Not_found | Unauthorized | None_pending

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    code : Code.t option;
    message : string;
    details : string option;
    reference_id : string;
  }

  val of_model : [ `MatchSearchFailed ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MatchSearchFailed ] Models.t, Models.decode_error) result
end

module Match_resources_request : sig
  type t = {
    search : string;
    archived : bool option;
    entity_type : string option;
    offset : int option;
    limit : int option;
  }

  val of_model : [ `MatchResourcesRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MatchResourcesRequest ] Models.t, Models.decode_error) result
end

module Media_token_request : sig
  type t = { resource_id : string }

  val of_model : [ `MediaTokenRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MediaTokenRequest ] Models.t, Models.decode_error) result
end

module Media_token_response : sig
  type t = { token : string }

  val of_model : [ `MediaTokenResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MediaTokenResponse ] Models.t, Models.decode_error) result
end

module Protected_resource_metadata : sig
  module Bearer_methods_supported : sig
    type t = Header

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    resource : string;
    authorization_servers : string list;
    bearer_methods_supported : Bearer_methods_supported.t list;
    resource_name : string option;
  }

  val of_model : [ `ProtectedResourceMetadata ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ProtectedResourceMetadata ] Models.t, Models.decode_error) result
end

module Representation_removed_payload : sig
  type t = { checksum : string }

  val of_model : [ `RepresentationRemovedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `RepresentationRemovedPayload ] Models.t, Models.decode_error) result
end

module Resource_archived_payload : sig
  type t = { reason : string option }

  val of_model : [ `ResourceArchivedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ResourceArchivedPayload ] Models.t, Models.decode_error) result
end

module Resource_moved_payload : sig
  type t = { from_uri : string; to_uri : string }

  val of_model : [ `ResourceMovedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ResourceMovedPayload ] Models.t, Models.decode_error) result
end

module Resource_updated_payload : sig
  type t = { content_checksum : string; content_byte_size : int option }

  val of_model : [ `ResourceUpdatedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ResourceUpdatedPayload ] Models.t, Models.decode_error) result
end

module Semantic_match : sig
  type t = {
    text : string;
    resource_id : string;
    resource_name : string;
    annotation_id : string option;
    score : float;
    entity_types : string list option;
    machine_read : bool option;
  }

  val of_model : [ `SemanticMatch ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `SemanticMatch ] Models.t, Models.decode_error) result
end

module Session_joined_event : sig
  type t = { participant : string; connection_id : string }

  val of_model : [ `SessionJoinedEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SessionJoinedEvent ] Models.t, Models.decode_error) result
end

module Session_left_event : sig
  type t = { participant : string; connection_id : string }

  val of_model : [ `SessionLeftEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SessionLeftEvent ] Models.t, Models.decode_error) result
end

module Settings_hover_delay_changed_event : sig
  type t = { hover_delay_ms : int }

  val of_model : [ `SettingsHoverDelayChangedEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `SettingsHoverDelayChangedEvent ] Models.t, Models.decode_error) result
end

module Settings_locale_changed_event : sig
  type t = { locale : string }

  val of_model : [ `SettingsLocaleChangedEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SettingsLocaleChangedEvent ] Models.t, Models.decode_error) result
end

module Settings_theme_changed_event : sig
  module Theme : sig
    type t = Light | Dark | System

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { theme : Theme.t }

  val of_model : [ `SettingsThemeChangedEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SettingsThemeChangedEvent ] Models.t, Models.decode_error) result
end

module Specific_resource : sig
  module Type_ : sig
    type t = SpecificResource

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    type_ : Type_.t;
    source : string;
    purpose : Enums.Body_purpose.t option;
  }

  val of_model : [ `SpecificResource ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SpecificResource ] Models.t, Models.decode_error) result
end

module Svg_selector : sig
  module Type_ : sig
    type t = SvgSelector

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { type_ : Type_.t; value : string }

  val of_model : [ `SvgSelector ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `SvgSelector ] Models.t, Models.decode_error) result
end

module Tag_category : sig
  type t = { name : string; description : string; examples : string list }

  val of_model : [ `TagCategory ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `TagCategory ] Models.t, Models.decode_error) result
end

module Text_position_selector : sig
  module Type_ : sig
    type t = TextPositionSelector

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { type_ : Type_.t; start : int; end_ : int }

  val of_model : [ `TextPositionSelector ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `TextPositionSelector ] Models.t, Models.decode_error) result
end

module Text_quote_selector : sig
  module Type_ : sig
    type t = TextQuoteSelector

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    type_ : Type_.t;
    exact : string;
    prefix : string option;
    suffix : string option;
  }

  val of_model : [ `TextQuoteSelector ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `TextQuoteSelector ] Models.t, Models.decode_error) result
end

module Textual_body : sig
  module Type_ : sig
    type t = TextualBody

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    type_ : Type_.t;
    value : string;
    purpose : Enums.Body_purpose.t option;
    format : string option;
    language : string option;
  }

  val of_model : [ `TextualBody ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `TextualBody ] Models.t, Models.decode_error) result
end

module User_response : sig
  type t = {
    did : string;
    email : string option;
    name : string option;
    image : string option;
    domain : string;
  }

  val of_model : [ `UserResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `UserResponse ] Models.t, Models.decode_error) result
end

module Smelt_rebuild_anchors_command : sig
  type t = { resource_id : string option; field_user_id : string option }

  val of_model : [ `SmeltRebuildAnchorsCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SmeltRebuildAnchorsCommand ] Models.t, Models.decode_error) result
end

module Weave_rebuild_command : sig
  type t = { resource_id : string option; field_user_id : string option }

  val of_model : [ `WeaveRebuildCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `WeaveRebuildCommand ] Models.t, Models.decode_error) result
end

module Yield_clone_create_command : sig
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

  val of_model : [ `YieldCloneCreateCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `YieldCloneCreateCommand ] Models.t, Models.decode_error) result
end

module Yield_clone_resource_request : sig
  type t = { token : string }

  val of_model : [ `YieldCloneResourceRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `YieldCloneResourceRequest ] Models.t, Models.decode_error) result
end

module Yield_clone_token_request : sig
  type t = { resource_id : string }

  val of_model : [ `YieldCloneTokenRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `YieldCloneTokenRequest ] Models.t, Models.decode_error) result
end

module Yield_clone_persist_command : sig
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

  val of_model : [ `YieldClonePersistCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `YieldClonePersistCommand ] Models.t, Models.decode_error) result
end

module Yield_update_command : sig
  type t = {
    field_user_id : string option;
    resource_id : string;
    storage_uri : string;
    content_checksum : string;
    byte_size : int;
  }

  val of_model : [ `YieldUpdateCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `YieldUpdateCommand ] Models.t, Models.decode_error) result
end

module Yielded_resource : sig
  type t = { resource_id : string }

  val of_model : [ `YieldedResource ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `YieldedResource ] Models.t, Models.decode_error) result
end

module Bus_frame : sig
  type t = {
    channel : string;
    correlation_id : string option;
    payload : (string * Yojson.Raw.t) list;
    scope : string option;
  }

  val of_model : [ `BusFrame ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `BusFrame ] Models.t, Models.decode_error) result
end

module Bus_ping_message : sig
  module Event : sig
    type t = Ping

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { event : Event.t; data : string }

  val of_model : [ `BusPingMessage ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `BusPingMessage ] Models.t, Models.decode_error) result
end

module Bus_resume_gap : sig
  module Reason : sig
    type t =
      | Unparseable_last_event_id
      | Scope_mismatch
      | Retention_exceeded
      | Query_error

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { scope : string; last_seen_id : string; reason : Reason.t }

  val of_model : [ `BusResumeGap ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `BusResumeGap ] Models.t, Models.decode_error) result
end

module Kb_identity : sig
  type t = { name : string; domain : string }

  val of_model : [ `KbIdentity ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `KbIdentity ] Models.t, Models.decode_error) result
end

module Resource_upload : sig
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

  val of_model : [ `ResourceUpload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ResourceUpload ] Models.t, Models.decode_error) result
end

module Limit_refusal : sig
  module Code : sig
    type t =
      | Streams
      | Emit_rate
      | Unanswered_requests
      | Capacity
      | Refusal_rate

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    error : string;
    code : Code.t;
    hint : string option;
    details : Yojson.Raw.t Types.presence;
  }

  val of_model : [ `LimitRefusal ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `LimitRefusal ] Models.t, Models.decode_error) result
end

module Highlighting_job_params : sig
  module Motivation : sig
    type t = Highlighting

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    motivation : Motivation.t;
    instructions : string option;
    density : float option;
    source_language : string option;
  }

  val of_model : [ `HighlightingJobParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `HighlightingJobParams ] Models.t, Models.decode_error) result
end

module Commenting_job_params : sig
  module Motivation : sig
    type t = Commenting

    val to_string : t -> string
    val of_string : string -> t option
  end

  module Tone : sig
    type t = Scholarly | Explanatory | Conversational | Technical

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    motivation : Motivation.t;
    instructions : string option;
    tone : Tone.t option;
    density : float option;
    language : string option;
    source_language : string option;
  }

  val of_model : [ `CommentingJobParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `CommentingJobParams ] Models.t, Models.decode_error) result
end

module Assessing_job_params : sig
  module Motivation : sig
    type t = Assessing

    val to_string : t -> string
    val of_string : string -> t option
  end

  module Tone : sig
    type t = Analytical | Critical | Balanced | Constructive

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    motivation : Motivation.t;
    instructions : string option;
    tone : Tone.t option;
    density : float option;
    language : string option;
    source_language : string option;
  }

  val of_model : [ `AssessingJobParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AssessingJobParams ] Models.t, Models.decode_error) result
end

module Linking_job_params : sig
  module Motivation : sig
    type t = Linking

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    motivation : Motivation.t;
    entity_types : string list;
    include_descriptive_references : bool option;
    language : string option;
    source_language : string option;
  }

  val of_model : [ `LinkingJobParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `LinkingJobParams ] Models.t, Models.decode_error) result
end

module Tagging_job_params : sig
  module Motivation : sig
    type t = Tagging

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    motivation : Motivation.t;
    schema_id : string;
    categories : string list;
    language : string option;
    source_language : string option;
  }

  val of_model : [ `TaggingJobParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `TaggingJobParams ] Models.t, Models.decode_error) result
end

module Generation_job_request : sig
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

  val of_model : [ `GenerationJobRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GenerationJobRequest ] Models.t, Models.decode_error) result
end

module Yield_job_filter : sig
  module Job_type : sig
    type t = Yield

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { job_type : Job_type.t }

  val of_model : [ `YieldJobFilter ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `YieldJobFilter ] Models.t, Models.decode_error) result
end

module Service_identity : sig
  type t = { issuer : string }

  val of_model : [ `ServiceIdentity ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ServiceIdentity ] Models.t, Models.decode_error) result
end

module Service_address : sig
  type t = { host : string; port : int }

  val of_model : [ `ServiceAddress ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ServiceAddress ] Models.t, Models.decode_error) result
end

module Entity_types_projection : sig
  type t = { entity_types : string list }

  val of_model : [ `EntityTypesProjection ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `EntityTypesProjection ] Models.t, Models.decode_error) result
end

module Profile : sig
  type t = { name : string; since : string }

  val of_model : [ `Profile ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Profile ] Models.t, Models.decode_error) result
end

module Storage_uri_entry : sig
  type t = { uri : string; resource_id : string }

  val of_model : [ `StorageUriEntry ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `StorageUriEntry ] Models.t, Models.decode_error) result
end

module Engine : sig
  module Provider : sig
    type t = Anthropic | Google | Llamacpp | Ollama | Openai | Together | Vllm

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { provider : Provider.t; model : string }

  val of_model : [ `Engine ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Engine ] Models.t, Models.decode_error) result
end

module Gather_failed : sig
  module Code : sig
    type t = Peer_unavailable | Not_found | Unauthorized | None_pending

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    code : Code.t option;
    message : string;
    details : string option;
    annotation_id : string;
  }

  val of_model : [ `GatherFailed ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `GatherFailed ] Models.t, Models.decode_error) result
end

module Gather_resource_failed : sig
  module Code : sig
    type t = Peer_unavailable | Not_found | Unauthorized | None_pending

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    code : Code.t option;
    message : string;
    details : string option;
    resource_id : string;
  }

  val of_model : [ `GatherResourceFailed ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GatherResourceFailed ] Models.t, Models.decode_error) result
end

module Browse_directory_failed : sig
  module Code : sig
    type t = Peer_unavailable | Not_found | Unauthorized | None_pending

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    code : Code.t option;
    message : string;
    details : string option;
    path : string;
  }

  val of_model : [ `BrowseDirectoryFailed ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseDirectoryFailed ] Models.t, Models.decode_error) result
end

module Mark_delegate_timeout_event : sig
  type t = { resource_id : string; motivation : Enums.Motivation.t }

  val of_model : [ `MarkDelegateTimeoutEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MarkDelegateTimeoutEvent ] Models.t, Models.decode_error) result
end

module Resource_error_event : sig
  type t = { resource_id : string; message : string }

  val of_model : [ `ResourceErrorEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ResourceErrorEvent ] Models.t, Models.decode_error) result
end

module Job_cancel_result : sig
  type t = { cancelled : bool }

  val of_model : [ `JobCancelResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobCancelResult ] Models.t, Models.decode_error) result
end

module Weave_applied : sig
  type t = { resource_id : string; sequence_number : int }

  val of_model : [ `WeaveApplied ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `WeaveApplied ] Models.t, Models.decode_error) result
end

module Smelt_settled : sig
  module Outcome : sig
    type t = Indexed | Skipped

    val to_string : t -> string
    val of_string : string -> t option
  end

  module Reason : sig
    type t =
      | No_extractor
      | Empty
      | No_text_layer
      | Encrypted
      | Corrupt
      | Too_large

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    resource_id : string;
    content_checksum : string;
    outcome : Outcome.t;
    reason : Reason.t option;
  }

  val of_model : [ `SmeltSettled ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `SmeltSettled ] Models.t, Models.decode_error) result
end

module Anchored_text_declined_entry : sig
  type t = {
    v : int;
    stamp : string;
    declined : Enums.Extraction_declined_reason.t;
  }

  val of_model : [ `AnchoredTextDeclinedEntry ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AnchoredTextDeclinedEntry ] Models.t, Models.decode_error) result
end

module Anchored_text_entries : sig
  type t = { checksums : string list }

  val of_model : [ `AnchoredTextEntries ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AnchoredTextEntries ] Models.t, Models.decode_error) result
end

module Anchored_text_stamp : sig
  type t = { stamp : string }

  val of_model : [ `AnchoredTextStamp ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AnchoredTextStamp ] Models.t, Models.decode_error) result
end

module Archivist_health : sig
  module Status : sig
    type t = Ok

    val to_string : t -> string
    val of_string : string -> t option
  end

  module Actors : sig
    type t = Stower | Browser | CloneTokenManager

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { status : Status.t; actors : Actors.t list }

  val of_model : [ `ArchivistHealth ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ArchivistHealth ] Models.t, Models.decode_error) result
end

module Archivist_stream : sig
  type t = { resource_id : string; last_sequence : int }

  val of_model : [ `ArchivistStream ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ArchivistStream ] Models.t, Models.decode_error) result
end

module Representation_not_found : sig
  module Code : sig
    type t = Resource | Representation

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    error : string;
    code : Code.t;
    hint : string option;
    details : Yojson.Raw.t Types.presence;
  }

  val of_model : [ `RepresentationNotFound ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `RepresentationNotFound ] Models.t, Models.decode_error) result
end

module Retry_budget : sig
  type t = { attempts : int; initial_delay_ms : int; max_delay_ms : int }

  val of_model : [ `RetryBudget ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `RetryBudget ] Models.t, Models.decode_error) result
end

module Conformance_bus_fetch : sig
  type t = {
    fetch : string;
    payload : Yojson.Raw.t Types.presence;
    as_ : string;
  }

  val of_model : [ `ConformanceBusFetch ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ConformanceBusFetch ] Models.t, Models.decode_error) result
end

module Conformance_failure : sig
  type t = {
    code : string option;
    status : int option;
    failure_class : Enums.Failure_class.t option;
    detail : string;
  }

  val of_model : [ `ConformanceFailure ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ConformanceFailure ] Models.t, Models.decode_error) result
end

module Conformance_http_fetch : sig
  type t = { fetch : string; params : Yojson.Raw.t Types.presence }

  val of_model : [ `ConformanceHttpFetch ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ConformanceHttpFetch ] Models.t, Models.decode_error) result
end

module About_params : sig
  type t = { api_version : Enums.Api_version.t }

  val of_model : [ `AboutParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `AboutParams ] Models.t, Models.decode_error) result
end

module Auth_login_result : sig
  type t = { key : string; who : string; issuer : string }

  val of_model : [ `AuthLoginResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AuthLoginResult ] Models.t, Models.decode_error) result
end

module Auth_logout_result : sig
  type t = { key : string option; was_signed_in : bool; revoked : bool }

  val of_model : [ `AuthLogoutResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AuthLogoutResult ] Models.t, Models.decode_error) result
end

module Field_fault : sig
  type t = { field : string; message : string }

  val of_model : [ `FieldFault ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `FieldFault ] Models.t, Models.decode_error) result
end

module Identity_user : sig
  type t = { email : string; identity : string; enabled : bool }

  val of_model : [ `IdentityUser ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `IdentityUser ] Models.t, Models.decode_error) result
end

module Identity_useradd_result : sig
  type t = {
    email : string;
    identity : string;
    created : bool;
    generated_password : string option;
  }

  val of_model : [ `IdentityUseraddResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `IdentityUseraddResult ] Models.t, Models.decode_error) result
end

module Local_target : sig
  module Kind : sig
    type t = Local

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { kind : Kind.t; root : string }

  val of_model : [ `LocalTarget ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `LocalTarget ] Models.t, Models.decode_error) result
end

module Logs_follow_result : sig
  type t = { services : string list }

  val of_model : [ `LogsFollowResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `LogsFollowResult ] Models.t, Models.decode_error) result
end

module Root : sig
  module Placement : sig
    type t = Local | Codespace

    val to_string : t -> string
    val of_string : string -> t option
  end

  module Current : sig
    type t = Cwd | Xynolog_root

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    placement : Placement.t;
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

  val of_model : [ `Root ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Root ] Models.t, Models.decode_error) result
end

module Roots_forget_params : sig
  type t = { api_version : Enums.Api_version.t; root : string }

  val of_model : [ `RootsForgetParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `RootsForgetParams ] Models.t, Models.decode_error) result
end

module Roots_forget_result : sig
  type t = {
    path : string;
    directory_missing : bool;
    persistent_state : string option;
  }

  val of_model : [ `RootsForgetResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `RootsForgetResult ] Models.t, Models.decode_error) result
end

module Roots_init_params : sig
  module Inference : sig
    type t = Anthropic | Ollama

    val to_string : t -> string
    val of_string : string -> t option
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

  val of_model : [ `RootsInitParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `RootsInitParams ] Models.t, Models.decode_error) result
end

module Roots_init_result : sig
  type t = { path : string }

  val of_model : [ `RootsInitResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `RootsInitResult ] Models.t, Models.decode_error) result
end

module Roots_list_params : sig
  type t = { api_version : Enums.Api_version.t }

  val of_model : [ `RootsListParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `RootsListParams ] Models.t, Models.decode_error) result
end

module Runtime_state : sig
  type t = { name : Enums.Runtime.t; found : bool }

  val of_model : [ `RuntimeState ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `RuntimeState ] Models.t, Models.decode_error) result
end

module Service_host_params : sig
  type t = {
    api_version : Enums.Api_version.t;
    runtime : Enums.Runtime.t option;
  }

  val of_model : [ `ServiceHostParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ServiceHostParams ] Models.t, Models.decode_error) result
end

module Service_host_result : sig
  type t = { runtime : Enums.Runtime.t; address : string }

  val of_model : [ `ServiceHostResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ServiceHostResult ] Models.t, Models.decode_error) result
end

module Service_run_result : sig
  type t = { instance : string; exit_code : int; ran_ms : int }

  val of_model : [ `ServiceRunResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ServiceRunResult ] Models.t, Models.decode_error) result
end

module Service_signal_result : sig
  type t = { delivered : bool }

  val of_model : [ `ServiceSignalResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ServiceSignalResult ] Models.t, Models.decode_error) result
end

module Service_status : sig
  module State : sig
    type t =
      | Running
      | Stopped
      | Reachable
      | Unreachable
      | Absent
      | Not_configured

    val to_string : t -> string
    val of_string : string -> t option
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

  val of_model : [ `ServiceStatus ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ServiceStatus ] Models.t, Models.decode_error) result
end

module Session : sig
  module State : sig
    type t = Valid | Expired | Unverified | None

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { state : State.t; email : string option }

  val of_model : [ `Session ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Session ] Models.t, Models.decode_error) result
end

module Setting_line : sig
  type t = { value : string; source : string }

  val of_model : [ `SettingLine ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `SettingLine ] Models.t, Models.decode_error) result
end

module Settings_get_params : sig
  type t = {
    api_version : Enums.Api_version.t;
    name : string;
    default : bool option;
    root : string option;
  }

  val of_model : [ `SettingsGetParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SettingsGetParams ] Models.t, Models.decode_error) result
end

module Settings_list_params : sig
  type t = { api_version : Enums.Api_version.t; root : string option }

  val of_model : [ `SettingsListParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SettingsListParams ] Models.t, Models.decode_error) result
end

module Settings_path_params : sig
  module Document : sig
    type t = Browser | Worker | Issuer | Vectors

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { api_version : Enums.Api_version.t; document : Document.t }

  val of_model : [ `SettingsPathParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SettingsPathParams ] Models.t, Models.decode_error) result
end

module Settings_path_result : sig
  type t = { path : string }

  val of_model : [ `SettingsPathResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SettingsPathResult ] Models.t, Models.decode_error) result
end

module Settings_set_params : sig
  type t = {
    api_version : Enums.Api_version.t;
    name : string;
    default : bool option;
    root : string option;
    value : string;
  }

  val of_model : [ `SettingsSetParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SettingsSetParams ] Models.t, Models.decode_error) result
end

module Settings_unset_params : sig
  type t = {
    api_version : Enums.Api_version.t;
    name : string;
    default : bool option;
    root : string option;
  }

  val of_model : [ `SettingsUnsetParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SettingsUnsetParams ] Models.t, Models.decode_error) result
end

module Target : sig
  module Kind : sig
    type t = Local | Codespace

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { kind : Kind.t; root : string option; repo : string option }

  val of_model : [ `Target ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Target ] Models.t, Models.decode_error) result
end

module Dispatcher_health : sig
  module Status : sig
    type t = Ok

    val to_string : t -> string
    val of_string : string -> t option
  end

  module Queue : sig
    type t = Jetstream

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { status : Status.t; queue : Queue.t }

  val of_model : [ `DispatcherHealth ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `DispatcherHealth ] Models.t, Models.decode_error) result
end

module Ollama_embedding_config : sig
  module Type_ : sig
    type t = Ollama

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { type_ : Type_.t; model : string; base_url : string }

  val of_model : [ `OllamaEmbeddingConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `OllamaEmbeddingConfig ] Models.t, Models.decode_error) result
end

module Voyage_embedding_config : sig
  module Type_ : sig
    type t = Voyage

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    type_ : Type_.t;
    model : string;
    endpoint : string;
    api_key_env : string;
  }

  val of_model : [ `VoyageEmbeddingConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `VoyageEmbeddingConfig ] Models.t, Models.decode_error) result
end

module Follower_following : sig
  module Sweep : sig
    type t = Pending | Running | Done | Due

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { sweep : Sweep.t; stopped : int; refused : int; stream_drops : int }

  val of_model : [ `FollowerFollowing ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `FollowerFollowing ] Models.t, Models.decode_error) result
end

module Janus_graph_config : sig
  module Type_ : sig
    type t = Janusgraph

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { type_ : Type_.t; host : string; port : int }

  val of_model : [ `JanusGraphConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JanusGraphConfig ] Models.t, Models.decode_error) result
end

module Memory_graph_config : sig
  module Type_ : sig
    type t = Memory

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { type_ : Type_.t }

  val of_model : [ `MemoryGraphConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MemoryGraphConfig ] Models.t, Models.decode_error) result
end

module Neo4j_graph_config : sig
  module Type_ : sig
    type t = Neo4j

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    type_ : Type_.t;
    uri : string;
    username : string;
    password_env : string;
    database : string;
  }

  val of_model : [ `Neo4jGraphConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `Neo4jGraphConfig ] Models.t, Models.decode_error) result
end

module Neptune_graph_config : sig
  module Type_ : sig
    type t = Neptune

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { type_ : Type_.t; endpoint : string; port : int }

  val of_model : [ `NeptuneGraphConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `NeptuneGraphConfig ] Models.t, Models.decode_error) result
end

module Librarian_health : sig
  module Status : sig
    type t = Ok

    val to_string : t -> string
    val of_string : string -> t option
  end

  module Actors : sig
    type t = Matcher | Gatherer

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { status : Status.t; kb : string; actors : Actors.t list }

  val of_model : [ `LibrarianHealth ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `LibrarianHealth ] Models.t, Models.decode_error) result
end

module Librarian_prompt_score : sig
  type t = { candidate : float; score : float }

  val of_model : [ `LibrarianPromptScore ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `LibrarianPromptScore ] Models.t, Models.decode_error) result
end

module Client_secret_form : sig
  module Grant_type : sig
    type t = Grant_type

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    grant_type : Grant_type.t;
    client_id : string;
    client_secret : string;
  }

  val of_model : [ `ClientSecretForm ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ClientSecretForm ] Models.t, Models.decode_error) result
end

module Open_resource : sig
  type t = {
    id : string;
    name : string;
    opened_at : int;
    order : int;
    media_type : string option;
    storage_uri : string option;
  }

  val of_model : [ `OpenResource ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `OpenResource ] Models.t, Models.decode_error) result
end

module Smelter_chunking : sig
  type t = { chunk_size : int; overlap : int }

  val of_model : [ `SmelterChunking ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SmelterChunking ] Models.t, Models.decode_error) result
end

module Smelter_reconcile_summary : sig
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

  val of_model : [ `SmelterReconcileSummary ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SmelterReconcileSummary ] Models.t, Models.decode_error) result
end

module Host_port : sig
  type t = { host : string; port : int }

  val of_model : [ `HostPort ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `HostPort ] Models.t, Models.decode_error) result
end

module Metadata : sig
  type t = {
    name : string;
    namespace : string option;
    labels : (string * string) list option;
    annotations : (string * string) list option;
  }

  val of_model : [ `Metadata ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Metadata ] Models.t, Models.decode_error) result
end

module Secret_ref : sig
  type t = { from_env : string }

  val of_model : [ `SecretRef ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `SecretRef ] Models.t, Models.decode_error) result
end

module Memory_vectors_config : sig
  module Type_ : sig
    type t = Memory

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { type_ : Type_.t }

  val of_model : [ `MemoryVectorsConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MemoryVectorsConfig ] Models.t, Models.decode_error) result
end

module Qdrant_vectors_config : sig
  module Type_ : sig
    type t = Qdrant

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { type_ : Type_.t; host : string; port : int; token_env : string }

  val of_model : [ `QdrantVectorsConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `QdrantVectorsConfig ] Models.t, Models.decode_error) result
end

module Mark_job_filter_params : sig
  type t = { motivation : Enums.Motivation.t }

  val to_json : t -> Yojson.Raw.t
end

module Resource_descriptor_context_item : sig
  type t = Text of string | Object of (string * Yojson.Raw.t) list

  val to_json : t -> Yojson.Raw.t
end

module One_or_more_strings : sig
  type t = Text of string | List of string list

  val of_model : [ `OneOrMoreStrings ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `OneOrMoreStrings ] Models.t, Models.decode_error) result
end

module Resource_descriptor_identifier_object : sig
  type t = {
    field_id : string option;
    value : string option;
    scheme : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  val to_json : t -> Yojson.Raw.t
end

module Resource_descriptor_was_derived_from : sig
  type t = ResourceId of string | List of string list

  val to_json : t -> Yojson.Raw.t
end

module One_or_more_uris : sig
  type t = Text of string | List of string list

  val of_model : [ `OneOrMoreUris ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `OneOrMoreUris ] Models.t, Models.decode_error) result
end

module Bus_subscribe_request_scoped_item : sig
  type t = {
    scope : string;
    channels : string list;
    last_event_id : string option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Contextual_summary_response_relevant_fields : sig
  type t = {
    resource_id : string;
    resource_name : string;
    entity_types : string list;
  }

  val to_json : t -> Yojson.Raw.t
end

module Contextual_summary_response_context : sig
  type t = { before : string option; selected : string; after : string option }

  val to_json : t -> Yojson.Raw.t
end

module Gathered_context_focus_annotation_selected : sig
  type t = { before : string option; text : string; after : string option }

  val to_json : t -> Yojson.Raw.t
end

module Gathered_context_focus_annotation_target_context : sig
  type t = { content : string; summary : string option }

  val to_json : t -> Yojson.Raw.t
end

module Gathered_context_focus_resource_content : sig
  type t = { main : string option; related : (string * string) list option }

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_graph_edges_item : sig
  type t = {
    source : string;
    target : string;
    type_ : string;
    bidirectional : bool option;
    metadata : (string * Yojson.Raw.t) list option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Gathered_context_metadata : sig
  type t = {
    resource_type : string option;
    language : string option;
    entity_types : string list option;
    entity_type_frequencies : (string * int) list option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Get_referenced_by_response_referenced_by_item_target_selector : sig
  type t = { exact : string }

  val to_json : t -> Yojson.Raw.t
end

module Job_progress_current : sig
  module Kind : sig
    type t = Entity_type | Category

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { kind : Kind.t; value : string }

  val to_json : t -> Yojson.Raw.t
end

module Job_progress_completed_items_item_under_reported : sig
  type t = { pieces : int; found : int; counted : int }

  val to_json : t -> Yojson.Raw.t
end

module Job_progress_request_params_item : sig
  module Label : sig
    type t = Entity_types | Instructions | Tone | Density

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { label : Label.t; value : string }

  val to_json : t -> Yojson.Raw.t
end

module Mark_commit_ok_response : sig
  type t = { persisted : int; annotation_ids : string list }

  val to_json : t -> Yojson.Raw.t
end

module Mark_delete_ok_response : sig
  type t = { annotation_id : string }

  val to_json : t -> Yojson.Raw.t
end

module Resource_created_payload_generated_from : sig
  type t = { resource_id : string; annotation_id : string option }

  val to_json : t -> Yojson.Raw.t
end

module Status_response_features : sig
  type t = { semantic_content : string; collaboration : string }

  val to_json : t -> Yojson.Raw.t
end

module Yield_create_command_generated_from : sig
  type t = { resource_id : string option; annotation_id : string option }

  val to_json : t -> Yojson.Raw.t
end

module Anchored_text_extracted_entry_lines_item : sig
  type t = { p : int; y : float; h : float; words : float list list }

  val to_json : t -> Yojson.Raw.t
end

module Archivist_config_staging : sig
  type t = { flush_ms : int; max_wait_ms : int }

  val to_json : t -> Yojson.Raw.t
end

module Client_discovery_absent_reasons_item : sig
  type t = { reason : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Client_refresh_queries_item_asks_value : sig
  type t = { field_ref : string }

  val to_json : t -> Yojson.Raw.t
end

module Client_refresh_queries_item_reads_value : sig
  type t = { field_ref : string }

  val to_json : t -> Yojson.Raw.t
end

module Client_refresh_refresh_item_on_names : sig
  type t = { resource : string option; annotation : string option }

  val to_json : t -> Yojson.Raw.t
end

module Client_refresh_refresh_item_stream : sig
  module Stream : sig
    type t = Reopened | Unreadable

    val to_string : t -> string
    val of_string : string -> t option
  end

  module Reach : sig
    type t = Subject | Held

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    stream : Stream.t;
    reach : Reach.t option;
    refetches : string list option;
    docs : string;
  }

  val to_json : t -> Yojson.Raw.t
end

module Client_testing_fault_actions_item : sig
  type t = { name : string; kind : string; docs : string; holds : string list }

  val to_json : t -> Yojson.Raw.t
end

module Client_testing_delay_ms : sig
  type t = { docs : string; minimum : int; maximum : int }

  val to_json : t -> Yojson.Raw.t
end

module Client_testing_schedule_length : sig
  type t = { docs : string; minimum : int; maximum : int }

  val to_json : t -> Yojson.Raw.t
end

module Client_testing_slack : sig
  type t = { docs : string; times : int }

  val to_json : t -> Yojson.Raw.t
end

module Client_testing_delivery_ops : sig
  type t = { docs : string; ops : string list }

  val to_json : t -> Yojson.Raw.t
end

module Client_testing_records_item : sig
  type t = { name : string; docs : string; members : string list }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_let : sig
  type t = { let_ : (string * Yojson.Raw.t) list }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_driver : sig
  type t = {
    driver : string;
    with_ : (string * Yojson.Raw.t) list option;
    returns : Yojson.Raw.t Types.presence;
    fails : Yojson.Raw.t Types.presence;
    as_ : string option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_abandon : sig
  type t = { abandon : string }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_settles : sig
  type t = {
    settles : string;
    returns : Yojson.Raw.t Types.presence;
    fails : Yojson.Raw.t Types.presence;
    abandoned : bool option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_wire : sig
  module At : sig
    type t = Arrival | Answer | Live

    val to_string : t -> string
    val of_string : string -> t option
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

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_carried : sig
  type t = { carried : string; is : Yojson.Raw.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_closed : sig
  type t = { closed : string }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_progress : sig
  type t = { progress : string }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_state : sig
  module State : sig
    type t =
      | Initial
      | Connecting
      | Open
      | Reconnecting
      | Degraded
      | Unauthenticated
      | Closed

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { state : State.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_stays : sig
  module Stays : sig
    type t =
      | Initial
      | Connecting
      | Open
      | Reconnecting
      | Degraded
      | Unauthenticated
      | Closed

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { stays : Stays.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_frame : sig
  type t = { frame : string; is : Yojson.Raw.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_frames : sig
  type t = { frames : string; count : int }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_error : sig
  type t = { error : Yojson.Raw.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_backend : sig
  module Backend : sig
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

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { backend : Backend.t; with_ : (string * Yojson.Raw.t) list option }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_quiet : sig
  type t = { quiet : int }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_observe_observe : sig
  type t = {
    query : string;
    resource : Yojson.Raw.t Types.presence;
    annotation : Yojson.Raw.t Types.presence;
    search : Yojson.Raw.t Types.presence;
    filters : Yojson.Raw.t Types.presence;
  }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_leave : sig
  type t = { leave : string }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_reaches : sig
  type t = { reaches : string; state : Yojson.Raw.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_holds : sig
  type t = { holds : string; state : Yojson.Raw.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_completes : sig
  type t = { completes : string }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_scopes : sig
  type t = { scopes : Yojson.Raw.t list }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_claimed : sig
  type t = { claimed : Yojson.Raw.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_refused : sig
  type t = { refused : Yojson.Raw.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_signalled : sig
  type t = { signalled : Yojson.Raw.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_stalled : sig
  type t = { stalled : Yojson.Raw.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_implementations_sdks_value_live : sig
  module Tier : sig
    type t = Fleet | Parity

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { command : string list; tier : Tier.t }

  val to_json : t -> Yojson.Raw.t
end

module Request_id : sig
  type t = Text of string | Integer of int

  val of_model : [ `RequestId ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `RequestId ] Models.t, Models.decode_error) result
end

module Control_cli_commands_value_positionals_item_fields : sig
  type t = { name : string; fields : string list }

  val to_json : t -> Yojson.Raw.t
end

module Control_cli_commands_value_positionals_item_cli_only : sig
  type t = { name : string; cli_only : string }

  val to_json : t -> Yojson.Raw.t
end

module Control_cli_commands_value_flags_value_fields : sig
  type t = { fields : string list; notes : string option }

  val to_json : t -> Yojson.Raw.t
end

module Control_cli_commands_value_flags_value_method : sig
  type t = { method_ : string }

  val to_json : t -> Yojson.Raw.t
end

module Control_cli_commands_value_flags_value_cli_only : sig
  type t = { cli_only : string }

  val to_json : t -> Yojson.Raw.t
end

module Workload_status_ledger : sig
  type t = { claims : int; capacity : int }

  val to_json : t -> Yojson.Raw.t
end

module Workload_status_queue : sig
  type t = {
    pending : int;
    running : int;
    completed : int option;
    failed : int option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Dispatcher_config_queue : sig
  type t = {
    servers : string;
    user_env : string option;
    password_env : string option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Dispatcher_config_timing : sig
  type t = {
    tick_ms : int;
    stale_running_ms : int;
    ack_wait_ms : int;
    retention_ms : int;
    retention_sweep_ms : int;
    progress_write_interval_ms : int;
    boot_deadline_ms : int;
  }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_bus_request_codes_item : sig
  module Wire : sig
    type t = Peer_unavailable | Not_found | Unauthorized | None_pending

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { code : string; docs : string; wire : Wire.t option }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_transport_codes_item_status : sig
  type t = { code : string; docs : string; status : int }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_transport_codes_item_status_from : sig
  type t = { code : string; docs : string; status_from : int }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_transport_codes_item_no_status : sig
  type t = { code : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_job_codes_item : sig
  type t = { code : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_session_codes_item : sig
  type t = { code : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_sign_in_codes_item : sig
  type t = { code : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_kb_identity_codes_item : sig
  type t = { code : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_span_refusal_codes_item : sig
  type t = { code : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_control_codes_item : sig
  type t = { code : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Gateway_config_identity : sig
  type t = { issuer : string; subject_claim : string }

  val to_json : t -> Yojson.Raw.t
end

module Gateway_config_signal : sig
  module Type_ : sig
    type t = In_process | Nats

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    type_ : Type_.t;
    servers : string option;
    user_env : string option;
    password_env : string option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Gateway_config_capacity : sig
  type t = { queued_bytes : int; connections : int }

  val to_json : t -> Yojson.Raw.t
end

module Identifiers_kinds_kinds_item_accepts_item : sig
  type t = { id : string; why : string }

  val to_json : t -> Yojson.Raw.t
end

module Identifiers_kinds_kinds_item_refuses_item : sig
  type t = { id : string; why : string }

  val to_json : t -> Yojson.Raw.t
end

module Identifiers_kinds_others_item : sig
  type t = { property : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Project_config_project : sig
  type t = { name : string; version : string option }

  val to_json : t -> Yojson.Raw.t
end

module Project_config_git : sig
  type t = { sync : bool }

  val to_json : t -> Yojson.Raw.t
end

module Project_config_site : sig
  type t = { domain : string; site_name : string }

  val to_json : t -> Yojson.Raw.t
end

module Librarian_config_gather : sig
  type t = { settle_timeout_ms : int }

  val to_json : t -> Yojson.Raw.t
end

module Librarian_config_search : sig
  type t = { semantic_floor : float }

  val to_json : t -> Yojson.Raw.t
end

module Media_types_registry_media_types_item : sig
  type t = {
    media_type : Enums.Supported_media_type.t;
    extension : string;
    label : string;
    render : string;
    anchoring : string;
    text_source : string;
    authorable : bool;
    uploadable : bool;
    generatable : bool;
  }

  val to_json : t -> Yojson.Raw.t
end

module Sdk_telemetry_telemetry_spans_item_attributes_item_values_item : sig
  type t = Text of string | Boolean of bool

  val to_json : t -> Yojson.Raw.t
end

module Sdk_telemetry_telemetry_metrics_item_attributes_item_values_item : sig
  type t = Text of string | Boolean of bool

  val to_json : t -> Yojson.Raw.t
end

module Session_oauth_clients_item : sig
  type t = { name : string; id : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Session_oauth_scopes : sig
  type t = { value : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Sign_in_store_owner_only_directory_mode : sig
  type t = { value : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Sign_in_store_owner_only_file_mode : sig
  type t = { value : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Sign_in_store_owner_only_directory_access_list : sig
  type t = { value : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Sign_in_store_owner_only_file_access_list : sig
  type t = { value : string; docs : string }

  val to_json : t -> Yojson.Raw.t
end

module Smelter_health_index_stamp_embedding : sig
  type t = { type_ : string; model : string }

  val to_json : t -> Yojson.Raw.t
end

module Resources_limits : sig
  type t = { memory : string }

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_index_spec_embedding_chunking : sig
  type t = { chunk_size : int; overlap : int }

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_index_spec_librarian_gather : sig
  type t = { settle_timeout_ms : int }

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_index_spec_librarian_search : sig
  type t = { semantic_floor : float }

  val to_json : t -> Yojson.Raw.t
end

module Stack_knowledge_base_spec_messaging_jobs : sig
  type t = { type_ : string }

  val to_json : t -> Yojson.Raw.t
end

module Stack_knowledge_base_spec_messaging_signal : sig
  type t = { type_ : string }

  val to_json : t -> Yojson.Raw.t
end

module Stack_knowledge_base_spec_issuer_shared : sig
  type t = { access_token_lifespan : int }

  val to_json : t -> Yojson.Raw.t
end

module Stack_knowledge_base_spec_issuer_external : sig
  type t = { type_ : string; url : string }

  val to_json : t -> Yojson.Raw.t
end

module Weaver_health_reconcile_summary : sig
  type t = {
    resources_checked : int;
    divergent : int;
    healed : int;
    heal_failures : int;
    orphaned : int;
  }

  val to_json : t -> Yojson.Raw.t
end

module Worker_knowledge_base_config_identity : sig
  type t = { issuer : string; client_id : string }

  val to_json : t -> Yojson.Raw.t
end

module Worker_engine_health_active_job : sig
  type t = { job_id : string; type_ : Enums.Job_type.t; since : string }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_ready : sig
  type t = { ready : bool }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_ok : sig
  type t = { id : int; ok : Yojson.Raw.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_abandoned : sig
  type t = { id : int; abandoned : bool }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_unsupported : sig
  type t = { id : int; unsupported : bool }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_misuse : sig
  type t = { id : int; misuse : string }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_state : sig
  type t = { state : string }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_frame_frame : sig
  type t = {
    channel : string;
    payload : Yojson.Raw.t Types.presence;
    correlation_id : string option;
    scope : string option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_progress_progress : sig
  type t = { upload : int; bytes_uploaded : int; total_bytes : int }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_emission_emission_state_pending : sig
  module Status : sig
    type t = Pending

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { status : Status.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_emission_emission_state_ready : sig
  module Status : sig
    type t = Ready

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { status : Status.t; value : Yojson.Raw.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_completed : sig
  type t = { completed : string }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_claimed : sig
  type t = { claimed : (string * Yojson.Raw.t) list }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_signalled : sig
  type t = { signalled : string }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_stalled : sig
  type t = { stalled : string }

  val to_json : t -> Yojson.Raw.t
end

module Browse_click_event : sig
  type t = { annotation_id : string; anchor_rect : Anchor_rect.t option }

  val of_model : [ `BrowseClickEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseClickEvent ] Models.t, Models.decode_error) result
end

module Browse_entity_types_result : sig
  type t = { response : Get_entity_types_response.t }

  val of_model : [ `BrowseEntityTypesResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseEntityTypesResult ] Models.t, Models.decode_error) result
end

module Browse_kb_result : sig
  type t = { response : Kb_description.t }

  val of_model : [ `BrowseKbResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `BrowseKbResult ] Models.t, Models.decode_error) result
end

module Anchored_text : sig
  type t = { text : string; items : Pdf_text_item.t list }

  val of_model : [ `AnchoredText ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `AnchoredText ] Models.t, Models.decode_error) result
end

module Bus_subscribe_request : sig
  type t = {
    global : string list option;
    pending_replies : string list option;
    scoped : Bus_subscribe_request_scoped_item.t list option;
    client_id : string;
  }

  val of_model : [ `BusSubscribeRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BusSubscribeRequest ] Models.t, Models.decode_error) result
end

module Contextual_summary_response : sig
  type t = {
    summary : string;
    relevant_fields : Contextual_summary_response_relevant_fields.t;
    context : Contextual_summary_response_context.t;
  }

  val of_model : [ `ContextualSummaryResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ContextualSummaryResponse ] Models.t, Models.decode_error) result
end

module Discovery_document : sig
  type t = { version : int; kbs : Discovered_kb.t list }

  val of_model : [ `DiscoveryDocument ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `DiscoveryDocument ] Models.t, Models.decode_error) result
end

module Extracted_text : sig
  module Kind : sig
    type t = Extracted

    val to_string : t -> string
    val of_string : string -> t option
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

  val of_model : [ `ExtractedText ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ExtractedText ] Models.t, Models.decode_error) result
end

module Gather_annotation_request : sig
  type t = {
    annotation_id : string;
    resource_id : string;
    options : Gather_annotation_options.t option;
  }

  val of_model : [ `GatherAnnotationRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GatherAnnotationRequest ] Models.t, Models.decode_error) result
end

module Gather_resource_request : sig
  type t = { resource_id : string; options : Gather_resource_request_options.t }

  val of_model : [ `GatherResourceRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GatherResourceRequest ] Models.t, Models.decode_error) result
end

module Engine_limits : sig
  type t = { engine : Engine.t; limits : Inference_limits.t }

  val of_model : [ `EngineLimits ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `EngineLimits ] Models.t, Models.decode_error) result
end

module Job_cancel_command : sig
  type t = {
    field_user_id : string option;
    resource_id : string;
    job_id : string;
    job_type : Enums.Job_type.t;
    annotation_id : string option;
    completed_units : string list option;
    unit_cursors : (string * Unit_cursor.t) list option;
  }

  val of_model : [ `JobCancelCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobCancelCommand ] Models.t, Models.decode_error) result
end

module Job_created_result : sig
  type t = { response : Job_created_result_response.t }

  val of_model : [ `JobCreatedResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobCreatedResult ] Models.t, Models.decode_error) result
end

module Job_fail_command : sig
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

  val of_model : [ `JobFailCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `JobFailCommand ] Models.t, Models.decode_error) result
end

module Job_checkpoint_command : sig
  type t = {
    field_user_id : string option;
    job_id : string;
    completed_units : string list;
    unit_cursors : (string * Unit_cursor.t) list option;
  }

  val of_model : [ `JobCheckpointCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobCheckpointCommand ] Models.t, Models.decode_error) result
end

module Mark_create_ok : sig
  type t = { response : Mark_create_ok_response.t }

  val of_model : [ `MarkCreateOk ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `MarkCreateOk ] Models.t, Models.decode_error) result
end

module Mark_commit_ok : sig
  type t = { response : Mark_commit_ok_response.t }

  val of_model : [ `MarkCommitOk ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `MarkCommitOk ] Models.t, Models.decode_error) result
end

module Mark_delete_ok : sig
  type t = { response : Mark_delete_ok_response.t }

  val of_model : [ `MarkDeleteOk ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `MarkDeleteOk ] Models.t, Models.decode_error) result
end

module Representation : sig
  module Rel : sig
    type t = Original | Thumbnail | Preview | Optimized | Derived | Other

    val to_string : t -> string
    val of_string : string -> t option
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

  val of_model : [ `Representation ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Representation ] Models.t, Models.decode_error) result
end

module Status_response : sig
  type t = {
    status : string;
    version : string;
    features : Status_response_features.t;
    message : string;
    authenticated_as : string option;
  }

  val of_model : [ `StatusResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `StatusResponse ] Models.t, Models.decode_error) result
end

module Stored_event_response : sig
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

  val of_model : [ `StoredEventResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `StoredEventResponse ] Models.t, Models.decode_error) result
end

module Tag_schema : sig
  type t = {
    id : string;
    name : string;
    description : string;
    domain : string;
    tags : Tag_category.t list;
  }

  val of_model : [ `TagSchema ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `TagSchema ] Models.t, Models.decode_error) result
end

module Yield_clone_created : sig
  type t = { response : Yielded_resource.t }

  val of_model : [ `YieldCloneCreated ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `YieldCloneCreated ] Models.t, Models.decode_error) result
end

module Yield_create_ok : sig
  type t = { response : Yielded_resource.t }

  val of_model : [ `YieldCreateOk ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `YieldCreateOk ] Models.t, Models.decode_error) result
end

module Yield_clone_persist_ok : sig
  type t = { response : Yielded_resource.t }

  val of_model : [ `YieldClonePersistOk ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `YieldClonePersistOk ] Models.t, Models.decode_error) result
end

module Yield_update_ok : sig
  type t = { response : Yielded_resource.t }

  val of_model : [ `YieldUpdateOk ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `YieldUpdateOk ] Models.t, Models.decode_error) result
end

module Bus_event_message : sig
  module Event : sig
    type t = Bus_event

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { event : Event.t; id : string; data : Bus_frame.t }

  val of_model : [ `BusEventMessage ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BusEventMessage ] Models.t, Models.decode_error) result
end

module Job_metadata : sig
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

  val of_model : [ `JobMetadata ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `JobMetadata ] Models.t, Models.decode_error) result
end

module Yield_job_queued_event : sig
  module Job_type : sig
    type t = Yield

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    job_id : string;
    job_type : Job_type.t;
    resource_id : string;
    user_id : string;
    params : Generation_job_request.t;
  }

  val of_model : [ `YieldJobQueuedEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `YieldJobQueuedEvent ] Models.t, Models.decode_error) result
end

module Mark_job_filter : sig
  module Job_type : sig
    type t = Mark

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { job_type : Job_type.t; params : Mark_job_filter_params.t }

  val of_model : [ `MarkJobFilter ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `MarkJobFilter ] Models.t, Models.decode_error) result
end

module Profiles_projection : sig
  type t = { profiles : (string * Profile.t) list }

  val of_model : [ `ProfilesProjection ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ProfilesProjection ] Models.t, Models.decode_error) result
end

module Anchored_text_extracted_entry : sig
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

  val of_model : [ `AnchoredTextExtractedEntry ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AnchoredTextExtractedEntry ] Models.t, Models.decode_error) result
end

module Archivist_streams_response : sig
  type t = { streams : Archivist_stream.t list }

  val of_model : [ `ArchivistStreamsResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ArchivistStreamsResponse ] Models.t, Models.decode_error) result
end

module Client_discovery_absent : sig
  type t = {
    field_comment : string;
    reasons : Client_discovery_absent_reasons_item.t list;
  }

  val of_model : [ `ClientDiscoveryAbsent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ClientDiscoveryAbsent ] Models.t, Models.decode_error) result
end

module Client_testing : sig
  type t = {
    field_comment : string;
    fault_actions : Client_testing_fault_actions_item.t list;
    delay_ms : Client_testing_delay_ms.t;
    schedule_length : Client_testing_schedule_length.t;
    slack : Client_testing_slack.t;
    delivery_ops : Client_testing_delivery_ops.t;
    records : Client_testing_records_item.t list;
  }

  val of_model : [ `ClientTesting ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ClientTesting ] Models.t, Models.decode_error) result
end

module About_result : sig
  type t = {
    version : string option;
    development : bool;
    commit : string option;
    built : string option;
    api_versions : string list;
    image_registry : string;
    runtimes : Runtime_state.t list;
  }

  val of_model : [ `AboutResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `AboutResult ] Models.t, Models.decode_error) result
end

module Auth_login_params : sig
  type t = {
    api_version : Enums.Api_version.t;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
  }

  val of_model : [ `AuthLoginParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AuthLoginParams ] Models.t, Models.decode_error) result
end

module Auth_logout_params : sig
  type t = {
    api_version : Enums.Api_version.t;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
  }

  val of_model : [ `AuthLogoutParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AuthLogoutParams ] Models.t, Models.decode_error) result
end

module Cancelled : sig
  type t = { request_id : Request_id.t; reason : string option }

  val of_model : [ `Cancelled ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Cancelled ] Models.t, Models.decode_error) result
end

module Error_data : sig
  type t = {
    code : string;
    retryable : bool;
    fields : Field_fault.t list option;
    choices : Target.t list option;
    supported : string list option;
    may_still_run : bool option;
  }

  val of_model : [ `ErrorData ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ErrorData ] Models.t, Models.decode_error) result
end

module Identity_useradd_params : sig
  type t = {
    api_version : Enums.Api_version.t;
    target : Local_target.t;
    email : string;
    password : string option;
    generate_password : bool;
  }

  val of_model : [ `IdentityUseraddParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `IdentityUseraddParams ] Models.t, Models.decode_error) result
end

module Identity_users_list_params : sig
  type t = { api_version : Enums.Api_version.t; target : Local_target.t }

  val of_model : [ `IdentityUsersListParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `IdentityUsersListParams ] Models.t, Models.decode_error) result
end

module Identity_users_list_result : sig
  type t = { users : Identity_user.t list }

  val of_model : [ `IdentityUsersListResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `IdentityUsersListResult ] Models.t, Models.decode_error) result
end

module Log_record : sig
  type t = {
    request_id : Request_id.t;
    service : string;
    stream : Enums.Output_stream.t;
    line : string;
    received_at : string;
  }

  val of_model : [ `LogRecord ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `LogRecord ] Models.t, Models.decode_error) result
end

module Logs_follow_params : sig
  type t = {
    api_version : Enums.Api_version.t;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
    service : string option;
  }

  val of_model : [ `LogsFollowParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `LogsFollowParams ] Models.t, Models.decode_error) result
end

module Progress : sig
  module Kind : sig
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

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { request_id : Request_id.t; kind : Kind.t; text : string }

  val of_model : [ `Progress ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Progress ] Models.t, Models.decode_error) result
end

module Roots_list_result : sig
  type t = { roots : Root.t list; warnings : string list option }

  val of_model : [ `RootsListResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `RootsListResult ] Models.t, Models.decode_error) result
end

module Service_output : sig
  type t = {
    request_id : Request_id.t;
    instance : string;
    stream : Enums.Output_stream.t;
    line : string;
  }

  val of_model : [ `ServiceOutput ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ServiceOutput ] Models.t, Models.decode_error) result
end

module Service_run_params : sig
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

  val of_model : [ `ServiceRunParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ServiceRunParams ] Models.t, Models.decode_error) result
end

module Service_signal_params : sig
  module Signal : sig
    type t = Term | Kill

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    api_version : Enums.Api_version.t;
    target : Local_target.t;
    runtime : Enums.Runtime.t option;
    instance : string;
    signal : Signal.t;
  }

  val of_model : [ `ServiceSignalParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ServiceSignalParams ] Models.t, Models.decode_error) result
end

module Service_started : sig
  type t = {
    request_id : Request_id.t;
    instance : string;
    container : string;
    document_path : string option;
    address : string;
  }

  val of_model : [ `ServiceStarted ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ServiceStarted ] Models.t, Models.decode_error) result
end

module Setting : sig
  module Applies_to : sig
    type t = Machine | Knowledge_base

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    name : string;
    default : bool;
    applies_to : Applies_to.t;
    values : Setting_line.t list;
    settable : bool;
    changed_by : string option;
  }

  val of_model : [ `Setting ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Setting ] Models.t, Models.decode_error) result
end

module Stack_start_params : sig
  module Ollama_cache : sig
    type t = Host | Volume

    val to_string : t -> string
    val of_string : string -> t option
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

  val of_model : [ `StackStartParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `StackStartParams ] Models.t, Models.decode_error) result
end

module Stack_stop_params : sig
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

  val of_model : [ `StackStopParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `StackStopParams ] Models.t, Models.decode_error) result
end

module Status_snapshot_params : sig
  type t = {
    api_version : Enums.Api_version.t;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
  }

  val of_model : [ `StatusSnapshotParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `StatusSnapshotParams ] Models.t, Models.decode_error) result
end

module User_action : sig
  type t = {
    request_id : Request_id.t;
    verification_uri : string;
    verification_uri_complete : string option;
    user_code : string;
    expires_in_seconds : int;
  }

  val of_model : [ `UserAction ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `UserAction ] Models.t, Models.decode_error) result
end

module Workload_status : sig
  type t = {
    ledger : Workload_status_ledger.t option;
    queue : Workload_status_queue.t option;
  }

  val of_model : [ `WorkloadStatus ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `WorkloadStatus ] Models.t, Models.decode_error) result
end

module Dispatcher_config : sig
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

  val of_model : [ `DispatcherConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `DispatcherConfig ] Models.t, Models.decode_error) result
end

module Gateway_config : sig
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

  val of_model : [ `GatewayConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `GatewayConfig ] Models.t, Models.decode_error) result
end

module Project_config : sig
  type t = {
    project : Project_config_project.t;
    git : Project_config_git.t;
    site : Project_config_site.t;
  }

  val of_model : [ `ProjectConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ProjectConfig ] Models.t, Models.decode_error) result
end

module Librarian_engine_config : sig
  type t = { engine : Engine.t; base_url : string; api_key_env : string option }

  val of_model : [ `LibrarianEngineConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `LibrarianEngineConfig ] Models.t, Models.decode_error) result
end

module Media_types_registry : sig
  type t = {
    field_comment : string;
    render : string list;
    anchoring : string list;
    text_source : string list;
    extension_aliases : (string * string) list;
    media_types : Media_types_registry_media_types_item.t list;
  }

  val of_model : [ `MediaTypesRegistry ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MediaTypesRegistry ] Models.t, Models.decode_error) result
end

module Session_oauth : sig
  type t = {
    field_comment : string;
    clients : Session_oauth_clients_item.t list;
    scopes : Session_oauth_scopes.t;
  }

  val of_model : [ `SessionOauth ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `SessionOauth ] Models.t, Models.decode_error) result
end

module Sign_in_store_owner_only : sig
  type t = {
    field_comment : string;
    directory_mode : Sign_in_store_owner_only_directory_mode.t;
    file_mode : Sign_in_store_owner_only_file_mode.t;
    directory_access_list : Sign_in_store_owner_only_directory_access_list.t;
    file_access_list : Sign_in_store_owner_only_file_access_list.t;
  }

  val of_model : [ `SignInStoreOwnerOnly ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SignInStoreOwnerOnly ] Models.t, Models.decode_error) result
end

module Provider : sig
  type t = { base_url : string option; api_key : Secret_ref.t option }

  val of_model : [ `Provider ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Provider ] Models.t, Models.decode_error) result
end

module Resources : sig
  type t = { limits : Resources_limits.t }

  val of_model : [ `Resources ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Resources ] Models.t, Models.decode_error) result
end

module Selector : sig
  type t =
    | TextPositionSelector of Text_position_selector.t
    | TextQuoteSelector of Text_quote_selector.t
    | SvgSelector of Svg_selector.t
    | FragmentSelector of Fragment_selector.t

  val of_model : [ `Selector ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Selector ] Models.t, Models.decode_error) result
end

module Annotation_body : sig
  type t =
    | TextualBody of Textual_body.t
    | SpecificResource of Specific_resource.t

  val of_model : [ `AnnotationBody ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `AnnotationBody ] Models.t, Models.decode_error) result
end

module Agent : sig
  type t =
    | AgentPerson of Agent_person.t
    | AgentOrganization of Agent_organization.t
    | AgentSoftware of Agent_software.t

  val of_model : [ `Agent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Agent ] Models.t, Models.decode_error) result
end

module Browse_profiles_result_response : sig
  type t = { profiles : (string * Profile.t) list }

  val to_json : t -> Yojson.Raw.t
end

module Resource_descriptor_context : sig
  type t =
    | Text of string
    | Object of (string * Yojson.Raw.t) list
    | List of Resource_descriptor_context_item.t list

  val to_json : t -> Yojson.Raw.t
end

module Resource_descriptor_identifier : sig
  type t =
    | Text of string
    | List of string list
    | Object of Resource_descriptor_identifier_object.t

  val to_json : t -> Yojson.Raw.t
end

module Directory_entry : sig
  type t = FileEntry of File_entry.t | DirEntry of Dir_entry.t

  val of_model : [ `DirectoryEntry ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `DirectoryEntry ] Models.t, Models.decode_error) result
end

module Gathered_context_semantic_context : sig
  type t = {
    similar : Semantic_match.t list;
    excluded_entity_types : string list option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Get_referenced_by_response_referenced_by_item_target : sig
  type t = {
    source : string;
    selector : Get_referenced_by_response_referenced_by_item_target_selector.t;
  }

  val to_json : t -> Yojson.Raw.t
end

module Job_progress_message : sig
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

  val of_model : [ `JobProgressMessage ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobProgressMessage ] Models.t, Models.decode_error) result
end

module Job_progress_completed_items_item : sig
  type t = {
    value : string;
    found_count : int;
    persisted_count : int option;
    under_reported : Job_progress_completed_items_item_under_reported.t option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Job_result : sig
  type t =
    | MarkJobDone of Mark_job_done.t
    | YieldJobDone of Yield_job_done.t
    | JobDeclined of Job_declined.t

  val of_model : [ `JobResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `JobResult ] Models.t, Models.decode_error) result
end

module Kb_endpoint : sig
  type t = HttpEndpoint of Http_endpoint.t | LocalEndpoint of Local_endpoint.t

  val of_model : [ `KbEndpoint ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `KbEndpoint ] Models.t, Models.decode_error) result
end

module Mark_job_params : sig
  type t =
    | HighlightingJobParams of Highlighting_job_params.t
    | CommentingJobParams of Commenting_job_params.t
    | AssessingJobParams of Assessing_job_params.t
    | LinkingJobParams of Linking_job_params.t
    | TaggingJobParams of Tagging_job_params.t

  val of_model : [ `MarkJobParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `MarkJobParams ] Models.t, Models.decode_error) result
end

module Mark_job_result : sig
  type t = MarkJobDone of Mark_job_done.t | JobDeclined of Job_declined.t

  val of_model : [ `MarkJobResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `MarkJobResult ] Models.t, Models.decode_error) result
end

module Yield_job_result : sig
  type t = YieldJobDone of Yield_job_done.t | JobDeclined of Job_declined.t

  val of_model : [ `YieldJobResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `YieldJobResult ] Models.t, Models.decode_error) result
end

module Archivist_engines_jobs_mark : sig
  type t = {
    highlighting : Engine.t option;
    commenting : Engine.t option;
    assessing : Engine.t option;
    linking : Engine.t option;
    tagging : Engine.t option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Archivist_engines_actors : sig
  type t = { gatherer : Engine.t option; matcher : Engine.t option }

  val to_json : t -> Yojson.Raw.t
end

module Client_refresh_queries_item_asks : sig
  module Per : sig
    type t = Resource | Annotation | Filters

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    name : string;
    per : Per.t option;
    asks : string;
    persisted : bool option;
    value : Client_refresh_queries_item_asks_value.t;
    docs : string;
  }

  val to_json : t -> Yojson.Raw.t
end

module Client_refresh_queries_item_reads : sig
  module Per : sig
    type t = Resource | Annotation | Filters

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    name : string;
    per : Per.t option;
    reads : string;
    persisted : bool option;
    value : Client_refresh_queries_item_reads_value.t;
    docs : string;
  }

  val to_json : t -> Yojson.Raw.t
end

module Client_refresh_refresh_item_on : sig
  module When_ : sig
    type t = Enriched | Unenriched

    val to_string : t -> string
    val of_string : string -> t option
  end

  module Reach : sig
    type t = Subject | Held

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    on : string;
    when_ : When_.t option;
    reach : Reach.t option;
    names : Client_refresh_refresh_item_on_names.t option;
    carries : string option;
    refetches : string list option;
    writes : string list option;
    removes : string list option;
    docs : string;
  }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_observe : sig
  type t = { observe : Conformance_step_observe_observe.t; as_ : string }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_fetches_fetches_item : sig
  type t =
    | ConformanceBusFetch of Conformance_bus_fetch.t
    | ConformanceHttpFetch of Conformance_http_fetch.t

  val to_json : t -> Yojson.Raw.t
end

module Conformance_implementations_sdks_value : sig
  type t = {
    wire : string list option;
    live : Conformance_implementations_sdks_value_live.t option;
    worker : string list option;
    exempt : (string * string) list option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Control_cli_commands_value_positionals_item : sig
  type t =
    | Fields of Control_cli_commands_value_positionals_item_fields.t
    | CliOnly of Control_cli_commands_value_positionals_item_cli_only.t

  val to_json : t -> Yojson.Raw.t
end

module Control_cli_commands_value_flags_value : sig
  type t =
    | Fields of Control_cli_commands_value_flags_value_fields.t
    | Method of Control_cli_commands_value_flags_value_method.t
    | CliOnly of Control_cli_commands_value_flags_value_cli_only.t

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_bus_request : sig
  type t = {
    docs : string;
    unrecognized_failure : string;
    codes : Errors_codes_bus_request_codes_item.t list;
  }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_transport_codes_item : sig
  type t =
    | Status of Errors_codes_transport_codes_item_status.t
    | StatusFrom of Errors_codes_transport_codes_item_status_from.t
    | NoStatus of Errors_codes_transport_codes_item_no_status.t

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_job : sig
  type t = { docs : string; codes : Errors_codes_job_codes_item.t list }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_session : sig
  type t = { docs : string; codes : Errors_codes_session_codes_item.t list }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_sign_in : sig
  type t = { docs : string; codes : Errors_codes_sign_in_codes_item.t list }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_kb_identity : sig
  type t = { docs : string; codes : Errors_codes_kb_identity_codes_item.t list }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_span_refusal : sig
  type t = {
    docs : string;
    codes : Errors_codes_span_refusal_codes_item.t list;
  }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_control : sig
  type t = { docs : string; codes : Errors_codes_control_codes_item.t list }

  val to_json : t -> Yojson.Raw.t
end

module Identifiers_kinds_kinds_item : sig
  type t = {
    schema : string;
    properties : string list;
    accepts : Identifiers_kinds_kinds_item_accepts_item.t list;
    refuses : Identifiers_kinds_kinds_item_refuses_item.t list;
  }

  val to_json : t -> Yojson.Raw.t
end

module Graph_config : sig
  type t =
    | Neo4jGraphConfig of Neo4j_graph_config.t
    | JanusGraphConfig of Janus_graph_config.t
    | NeptuneGraphConfig of Neptune_graph_config.t
    | MemoryGraphConfig of Memory_graph_config.t

  val of_model : [ `GraphConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `GraphConfig ] Models.t, Models.decode_error) result
end

module Vectors_config : sig
  type t =
    | QdrantVectorsConfig of Qdrant_vectors_config.t
    | MemoryVectorsConfig of Memory_vectors_config.t

  val of_model : [ `VectorsConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `VectorsConfig ] Models.t, Models.decode_error) result
end

module Embedding_config : sig
  type t =
    | OllamaEmbeddingConfig of Ollama_embedding_config.t
    | VoyageEmbeddingConfig of Voyage_embedding_config.t

  val of_model : [ `EmbeddingConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `EmbeddingConfig ] Models.t, Models.decode_error) result
end

module Sdk_telemetry_telemetry_spans_item_attributes_item : sig
  type t = {
    key : string;
    only : string option;
    values :
      Sdk_telemetry_telemetry_spans_item_attributes_item_values_item.t list
      option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Sdk_telemetry_telemetry_metrics_item_attributes_item : sig
  type t = {
    key : string;
    only : string option;
    values :
      Sdk_telemetry_telemetry_metrics_item_attributes_item_values_item.t list
      option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Smelter_health_reconcile : sig
  module Phase : sig
    type t = Pending | Running | Done | Failed

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    phase : Phase.t;
    summary : Smelter_reconcile_summary.t option;
    error : string option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Smelter_health_index_stamp : sig
  type t = {
    embedding : Smelter_health_index_stamp_embedding.t;
    chunking : Smelter_chunking.t;
  }

  val to_json : t -> Yojson.Raw.t
end

module Issuer_spec_database_external : sig
  type t = { host : string; port : int; password : Secret_ref.t }

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_index_spec_graph_external : sig
  type t = { uri : string; password : Secret_ref.t }

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_index_spec_vectors_external : sig
  type t = {
    host : string;
    port : int;
    smelter_token : Secret_ref.t;
    librarian_token : Secret_ref.t;
  }

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_index_spec_embedding : sig
  type t = {
    type_ : string;
    model : string;
    chunking : Knowledge_index_spec_embedding_chunking.t;
    endpoint : string option;
    api_key : Secret_ref.t option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Stack_knowledge_base_spec_messaging_external : sig
  type t = { servers : string; user : Secret_ref.t; password : Secret_ref.t }

  val to_json : t -> Yojson.Raw.t
end

module Stack_knowledge_base_spec_issuer : sig
  type t = {
    shared : Stack_knowledge_base_spec_issuer_shared.t option;
    external_ : Stack_knowledge_base_spec_issuer_external.t option;
    subject_claim : string;
  }

  val to_json : t -> Yojson.Raw.t
end

module Weaver_health_reconcile : sig
  module Phase : sig
    type t = Pending | Running | Done | Failed

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    phase : Phase.t;
    summary : Weaver_health_reconcile_summary.t option;
    error : string option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_failed : sig
  type t = { id : int; error : Conformance_failure.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_frame : sig
  type t = { frame : Conformance_driver_line_frame_frame.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_error_stream : sig
  type t = { error : Conformance_failure.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_progress : sig
  type t = { progress : Conformance_driver_line_progress_progress.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_emission_emission_state_failed : sig
  module Status : sig
    type t = Failed

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { status : Status.t; error : Conformance_failure.t }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_refused : sig
  type t = { refused : Conformance_failure.t }

  val to_json : t -> Yojson.Raw.t
end

module Attributed_event : sig
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

  val of_model : [ `AttributedEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AttributedEvent ] Models.t, Models.decode_error) result
end

module Bind_body_operation : sig
  module Op : sig
    type t = Add | Remove | Replace

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    op : Op.t;
    item : Annotation_body.t option;
    old_item : Annotation_body.t option;
    new_item : Annotation_body.t option;
  }

  val of_model : [ `BindBodyOperation ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BindBodyOperation ] Models.t, Models.decode_error) result
end

module Body_operation_add : sig
  module Op : sig
    type t = Add

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { op : Op.t; item : Annotation_body.t }

  val of_model : [ `BodyOperationAdd ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BodyOperationAdd ] Models.t, Models.decode_error) result
end

module Body_operation_remove : sig
  module Op : sig
    type t = Remove

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = { op : Op.t; item : Annotation_body.t }

  val of_model : [ `BodyOperationRemove ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BodyOperationRemove ] Models.t, Models.decode_error) result
end

module Body_operation_replace : sig
  module Op : sig
    type t = Replace

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    op : Op.t;
    old_item : Annotation_body.t;
    new_item : Annotation_body.t;
  }

  val of_model : [ `BodyOperationReplace ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BodyOperationReplace ] Models.t, Models.decode_error) result
end

module Browse_profiles_result : sig
  type t = { response : Browse_profiles_result_response.t }

  val of_model : [ `BrowseProfilesResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseProfilesResult ] Models.t, Models.decode_error) result
end

module Browse_directory_result_response : sig
  type t = { path : string; entries : Directory_entry.t list }

  val of_model : [ `BrowseDirectoryResultResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `BrowseDirectoryResultResponse ] Models.t, Models.decode_error) result
end

module Browse_files_response : sig
  type t = { path : string; entries : Directory_entry.t list }

  val of_model : [ `BrowseFilesResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseFilesResponse ] Models.t, Models.decode_error) result
end

module Frame_add_tag_schema_command : sig
  type t = { schema : Tag_schema.t; field_user_id : string option }

  val of_model : [ `FrameAddTagSchemaCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `FrameAddTagSchemaCommand ] Models.t, Models.decode_error) result
end

module Get_referenced_by_response_referenced_by_item : sig
  type t = {
    id : string;
    resource_name : string option;
    target : Get_referenced_by_response_referenced_by_item_target.t;
  }

  val of_model : [ `GetReferencedByResponseReferencedByItem ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ( [ `GetReferencedByResponseReferencedByItem ] Models.t,
      Models.decode_error )
    result
end

module Get_tag_schemas_response : sig
  type t = { tag_schemas : Tag_schema.t list }

  val of_model : [ `GetTagSchemasResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GetTagSchemasResponse ] Models.t, Models.decode_error) result
end

module Job_progress : sig
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

  val of_model : [ `JobProgress ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `JobProgress ] Models.t, Models.decode_error) result
end

module Kb_target : sig
  type t = { id : string; label : string; endpoint : Kb_endpoint.t }

  val of_model : [ `KbTarget ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `KbTarget ] Models.t, Models.decode_error) result
end

module Knowledge_base : sig
  type t = {
    id : string;
    label : string;
    endpoint : Kb_endpoint.t;
    did : string;
    last_read : Kb_read.t option;
  }

  val of_model : [ `KnowledgeBase ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `KnowledgeBase ] Models.t, Models.decode_error) result
end

module New_knowledge_base : sig
  type t = {
    label : string;
    endpoint : Kb_endpoint.t;
    did : string;
    last_read : Kb_read.t option;
  }

  val of_model : [ `NewKnowledgeBase ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `NewKnowledgeBase ] Models.t, Models.decode_error) result
end

module Representation_added_payload : sig
  type t = { representation : Representation.t }

  val of_model : [ `RepresentationAddedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `RepresentationAddedPayload ] Models.t, Models.decode_error) result
end

module Tag_schema_added_payload : sig
  type t = { schema : Tag_schema.t }

  val of_model : [ `TagSchemaAddedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `TagSchemaAddedPayload ] Models.t, Models.decode_error) result
end

module Job_params : sig
  type t = {
    resource_id : string;
    schema : Tag_schema.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  val of_model : [ `JobParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `JobParams ] Models.t, Models.decode_error) result
end

module Mark_job_create_command : sig
  module Job_type : sig
    type t = Mark

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    field_user_id : string option;
    field_roles : string list option;
    job_type : Job_type.t;
    resource_id : string;
    params : Mark_job_params.t;
  }

  val of_model : [ `MarkJobCreateCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MarkJobCreateCommand ] Models.t, Models.decode_error) result
end

module Mark_job_queued_event : sig
  module Job_type : sig
    type t = Mark

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    job_id : string;
    job_type : Job_type.t;
    resource_id : string;
    user_id : string;
    params : Mark_job_params.t;
  }

  val of_model : [ `MarkJobQueuedEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MarkJobQueuedEvent ] Models.t, Models.decode_error) result
end

module Mark_job_complete_command : sig
  module Job_type : sig
    type t = Mark

    val to_string : t -> string
    val of_string : string -> t option
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

  val of_model : [ `MarkJobCompleteCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MarkJobCompleteCommand ] Models.t, Models.decode_error) result
end

module Yield_job_complete_command : sig
  module Job_type : sig
    type t = Yield

    val to_string : t -> string
    val of_string : string -> t option
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

  val of_model : [ `YieldJobCompleteCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `YieldJobCompleteCommand ] Models.t, Models.decode_error) result
end

module Tag_schemas_projection : sig
  type t = { tag_schemas : Tag_schema.t list }

  val of_model : [ `TagSchemasProjection ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `TagSchemasProjection ] Models.t, Models.decode_error) result
end

module Archivist_events_response : sig
  type t = { events : Stored_event_response.t list; last_sequence : int }

  val of_model : [ `ArchivistEventsResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ArchivistEventsResponse ] Models.t, Models.decode_error) result
end

module Conformance_implementations : sig
  type t = {
    launcher : string list;
    target : Local_target.t;
    sdks : (string * Conformance_implementations_sdks_value.t) list;
    model_catalogue : string option;
  }

  val of_model : [ `ConformanceImplementations ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ConformanceImplementations ] Models.t, Models.decode_error) result
end

module Knowledge_base_status : sig
  module Placement : sig
    type t = Local | Codespace

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    name : string;
    key : string;
    recorded : bool;
    placement : Placement.t;
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

  val of_model : [ `KnowledgeBaseStatus ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `KnowledgeBaseStatus ] Models.t, Models.decode_error) result
end

module Settings_list_result : sig
  type t = {
    root : string option;
    unresolved : string option;
    settings : Setting.t list;
  }

  val of_model : [ `SettingsListResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SettingsListResult ] Models.t, Models.decode_error) result
end

module Identifiers_kinds : sig
  type t = {
    field_comment : string;
    kinds : Identifiers_kinds_kinds_item.t list;
    others : Identifiers_kinds_others_item.t list;
  }

  val of_model : [ `IdentifiersKinds ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `IdentifiersKinds ] Models.t, Models.decode_error) result
end

module Librarian_config : sig
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

  val of_model : [ `LibrarianConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `LibrarianConfig ] Models.t, Models.decode_error) result
end

module Smelter_config : sig
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

  val of_model : [ `SmelterConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `SmelterConfig ] Models.t, Models.decode_error) result
end

module Weaver_config : sig
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

  val of_model : [ `WeaverConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `WeaverConfig ] Models.t, Models.decode_error) result
end

module Weaver_health : sig
  module Status : sig
    type t = Ok

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    status : Status.t;
    kb : string;
    following : Follower_following.t;
    reconcile : Weaver_health_reconcile.t;
  }

  val of_model : [ `WeaverHealth ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `WeaverHealth ] Models.t, Models.decode_error) result
end

module Annotation_selector : sig
  type t = Selector of Selector.t | List of Selector.t list

  val of_model : [ `AnnotationSelector ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AnnotationSelector ] Models.t, Models.decode_error) result
end

module Annotation_bodies : sig
  type t =
    | AnnotationBody of Annotation_body.t
    | List of Annotation_body.t list

  val of_model : [ `AnnotationBodies ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AnnotationBodies ] Models.t, Models.decode_error) result
end

module One_or_more_agents : sig
  type t = Agent of Agent.t | List of Agent.t list

  val of_model : [ `OneOrMoreAgents ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `OneOrMoreAgents ] Models.t, Models.decode_error) result
end

module Job_filter : sig
  type t =
    | MarkJobFilter of Mark_job_filter.t
    | YieldJobFilter of Yield_job_filter.t

  val of_model : [ `JobFilter ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `JobFilter ] Models.t, Models.decode_error) result
end

module Resource_descriptor_representations : sig
  type t = Representation of Representation.t | List of Representation.t list

  val to_json : t -> Yojson.Raw.t
end

module Inference_limits_result_response : sig
  type t = { limits : Engine_limits.t list }

  val to_json : t -> Yojson.Raw.t
end

module Job_stored_result : sig
  type t = JobResult of Job_result.t | Empty of (string * Yojson.Raw.t) list

  val of_model : [ `JobStoredResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobStoredResult ] Models.t, Models.decode_error) result
end

module Archivist_engines_jobs : sig
  type t = {
    mark : Archivist_engines_jobs_mark.t option;
    yield : Engine.t option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Anchored_text_entry : sig
  type t =
    | AnchoredTextExtractedEntry of Anchored_text_extracted_entry.t
    | AnchoredTextDeclinedEntry of Anchored_text_declined_entry.t

  val of_model : [ `AnchoredTextEntry ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AnchoredTextEntry ] Models.t, Models.decode_error) result
end

module Client_refresh_queries_item : sig
  type t =
    | Asks of Client_refresh_queries_item_asks.t
    | Reads of Client_refresh_queries_item_reads.t

  val to_json : t -> Yojson.Raw.t
end

module Client_refresh_refresh_item : sig
  type t =
    | On of Client_refresh_refresh_item_on.t
    | Stream of Client_refresh_refresh_item_stream.t

  val to_json : t -> Yojson.Raw.t
end

module Conformance_step_fetches : sig
  type t = { fetches : Conformance_step_fetches_fetches_item.t list }

  val to_json : t -> Yojson.Raw.t
end

module Control_cli_commands_value : sig
  type t = {
    parser : string;
    method_ : string;
    positionals : Control_cli_commands_value_positionals_item.t list option;
    flags : (string * Control_cli_commands_value_flags_value.t) list;
  }

  val to_json : t -> Yojson.Raw.t
end

module Errors_codes_transport : sig
  type t = {
    docs : string;
    unclassified : string;
    codes : Errors_codes_transport_codes_item.t list;
  }

  val to_json : t -> Yojson.Raw.t
end

module Sdk_telemetry_telemetry_spans_item : sig
  module Transport : sig
    type t = Bus | Content

    val to_string : t -> string
    val of_string : string -> t option
  end

  module Kind : sig
    type t = Client | Consumer | Internal | Producer | Server

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    name : string;
    transport : Transport.t;
    kind : Kind.t;
    meaning : string;
    attributes : Sdk_telemetry_telemetry_spans_item_attributes_item.t list;
  }

  val to_json : t -> Yojson.Raw.t
end

module Sdk_telemetry_telemetry_metrics_item : sig
  module Transport : sig
    type t = Bus | Content

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    name : string;
    transport : Transport.t;
    instrument : string;
    meaning : string;
    attributes : Sdk_telemetry_telemetry_metrics_item_attributes_item.t list;
  }

  val to_json : t -> Yojson.Raw.t
end

module Smelter_health_index : sig
  type t = { stamp : Smelter_health_index_stamp.t; made_anew : bool }

  val to_json : t -> Yojson.Raw.t
end

module Browser_spec : sig
  type t = { image : string; resources : Resources.t; port : int }

  val to_json : t -> Yojson.Raw.t
end

module Issuer_spec_database : sig
  type t = {
    type_ : string;
    name : string;
    user : string;
    image : string option;
    resources : Resources.t option;
    port : int option;
    external_ : Issuer_spec_database_external.t option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_index_spec_graph : sig
  type t = {
    type_ : string;
    username : string;
    image : string option;
    resources : Resources.t option;
    external_ : Knowledge_index_spec_graph_external.t option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_index_spec_vectors : sig
  type t = {
    type_ : string;
    shared : (string * Yojson.Raw.t) list option;
    image : string option;
    resources : Resources.t option;
    external_ : Knowledge_index_spec_vectors_external.t option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_index_spec_librarian : sig
  type t = {
    image : string;
    resources : Resources.t;
    gather : Knowledge_index_spec_librarian_gather.t;
    search : Knowledge_index_spec_librarian_search.t;
  }

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_index_spec_smelter : sig
  type t = { image : string; resources : Resources.t; pdfs_at_once : int }

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_index_spec_weaver : sig
  type t = { image : string; resources : Resources.t }

  val to_json : t -> Yojson.Raw.t
end

module Stack_knowledge_base_spec_gateway : sig
  type t = {
    image : string;
    resources : Resources.t;
    port : int;
    public_url : string;
  }

  val to_json : t -> Yojson.Raw.t
end

module Stack_knowledge_base_spec_dispatcher : sig
  type t = { image : string; resources : Resources.t }

  val to_json : t -> Yojson.Raw.t
end

module Stack_knowledge_base_spec_archivist : sig
  type t = {
    image : string;
    resources : Resources.t;
    address : Host_port.t option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Stack_knowledge_base_spec_messaging : sig
  type t = {
    jobs : Stack_knowledge_base_spec_messaging_jobs.t;
    signal : Stack_knowledge_base_spec_messaging_signal.t;
    image : string option;
    resources : Resources.t option;
    external_ : Stack_knowledge_base_spec_messaging_external.t option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Vector_store_spec : sig
  type t = {
    type_ : string;
    image : string;
    resources : Resources.t;
    port : int;
  }

  val to_json : t -> Yojson.Raw.t
end

module Worker_pool_spec_worker : sig
  type t = { image : string; resources : Resources.t }

  val to_json : t -> Yojson.Raw.t
end

module Anchored_text_answer : sig
  type t =
    | ExtractedText of Extracted_text.t
    | ExtractionDeclined of Extraction_declined.t
    | AnchoredTextAbsent of Anchored_text_absent.t

  val of_model : [ `AnchoredTextAnswer ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AnchoredTextAnswer ] Models.t, Models.decode_error) result
end

module Extraction_outcome : sig
  type t =
    | ExtractedText of Extracted_text.t
    | ExtractionDeclined of Extraction_declined.t

  val of_model : [ `ExtractionOutcome ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ExtractionOutcome ] Models.t, Models.decode_error) result
end

module Bus_stream_message : sig
  type t =
    | BusEventMessage of Bus_event_message.t
    | BusPingMessage of Bus_ping_message.t

  val of_model : [ `BusStreamMessage ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BusStreamMessage ] Models.t, Models.decode_error) result
end

module Conformance_driver_line_emission_emission_state : sig
  type t =
    | Pending of Conformance_driver_line_emission_emission_state_pending.t
    | Ready of Conformance_driver_line_emission_emission_state_ready.t
    | Failed of Conformance_driver_line_emission_emission_state_failed.t

  val to_json : t -> Yojson.Raw.t
end

module Annotation_target : sig
  module Type_ : sig
    type t = SpecificResource

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    type_ : Type_.t option;
    source : string;
    selector : Annotation_selector.t option;
  }

  val of_model : [ `AnnotationTarget ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AnnotationTarget ] Models.t, Models.decode_error) result
end

module Bind_update_body_command : sig
  type t = {
    field_user_id : string option;
    annotation_id : string;
    resource_id : string;
    operations : Bind_body_operation.t list;
  }

  val of_model : [ `BindUpdateBodyCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BindUpdateBodyCommand ] Models.t, Models.decode_error) result
end

module Browse_directory_result : sig
  type t = { response : Browse_directory_result_response.t }

  val of_model : [ `BrowseDirectoryResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseDirectoryResult ] Models.t, Models.decode_error) result
end

module Browse_tag_schemas_result : sig
  type t = { response : Get_tag_schemas_response.t }

  val of_model : [ `BrowseTagSchemasResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseTagSchemasResult ] Models.t, Models.decode_error) result
end

module Engine_entry : sig
  type t = { engine : Engine.t; jobs : Job_filter.t list option }

  val of_model : [ `EngineEntry ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `EngineEntry ] Models.t, Models.decode_error) result
end

module Get_annotation_history_response : sig
  type t = {
    events : Attributed_event.t list;
    total : float;
    annotation_id : string;
    resource_id : string;
  }

  val of_model : [ `GetAnnotationHistoryResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `GetAnnotationHistoryResponse ] Models.t, Models.decode_error) result
end

module Get_events_response : sig
  type t = {
    events : Attributed_event.t list;
    total : float;
    resource_id : string;
  }

  val of_model : [ `GetEventsResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GetEventsResponse ] Models.t, Models.decode_error) result
end

module Get_referenced_by_response : sig
  type t = {
    referenced_by : Get_referenced_by_response_referenced_by_item.t list;
  }

  val of_model : [ `GetReferencedByResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GetReferencedByResponse ] Models.t, Models.decode_error) result
end

module Inference_limits_result : sig
  type t = { response : Inference_limits_result_response.t }

  val of_model : [ `InferenceLimitsResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `InferenceLimitsResult ] Models.t, Models.decode_error) result
end

module Job_claim_command : sig
  type t = {
    accepts : Job_filter.t list;
    field_user_id : string option;
    field_roles : string list option;
  }

  val of_model : [ `JobClaimCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobClaimCommand ] Models.t, Models.decode_error) result
end

module Job_report_progress_command : sig
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

  val of_model : [ `JobReportProgressCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobReportProgressCommand ] Models.t, Models.decode_error) result
end

module Mark_requested_event : sig
  type t = {
    source : string;
    selector : Annotation_selector.t;
    motivation : Enums.Motivation.t;
  }

  val of_model : [ `MarkRequestedEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MarkRequestedEvent ] Models.t, Models.decode_error) result
end

module Mark_submit_event : sig
  type t = {
    source : string;
    motivation : Enums.Motivation.t;
    selector : Annotation_selector.t;
    body : Annotation_bodies.t option;
  }

  val of_model : [ `MarkSubmitEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MarkSubmitEvent ] Models.t, Models.decode_error) result
end

module Resource_cloned_payload : sig
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

  val of_model : [ `ResourceClonedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ResourceClonedPayload ] Models.t, Models.decode_error) result
end

module Resource_created_payload : sig
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

  val of_model : [ `ResourceCreatedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ResourceCreatedPayload ] Models.t, Models.decode_error) result
end

module Resource_descriptor : sig
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

  val of_model : [ `ResourceDescriptor ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ResourceDescriptor ] Models.t, Models.decode_error) result
end

module Scored_resource : sig
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

  val of_model : [ `ScoredResource ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ScoredResource ] Models.t, Models.decode_error) result
end

module Yield_create_command : sig
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

  val of_model : [ `YieldCreateCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `YieldCreateCommand ] Models.t, Models.decode_error) result
end

module Job_pending : sig
  module Status : sig
    type t = Pending

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    status : Status.t;
    metadata : Job_metadata.t;
    params : Job_params.t;
  }

  val of_model : [ `JobPending ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `JobPending ] Models.t, Models.decode_error) result
end

module Job_complete : sig
  module Status : sig
    type t = Complete

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    status : Status.t;
    metadata : Job_metadata.t;
    params : Job_params.t;
    started_at : string;
    completed_at : string;
    result : Job_stored_result.t;
  }

  val of_model : [ `JobComplete ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `JobComplete ] Models.t, Models.decode_error) result
end

module Job_failed : sig
  module Status : sig
    type t = Failed

    val to_string : t -> string
    val of_string : string -> t option
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

  val of_model : [ `JobFailed ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `JobFailed ] Models.t, Models.decode_error) result
end

module Job_cancelled : sig
  module Status : sig
    type t = Cancelled

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    status : Status.t;
    metadata : Job_metadata.t;
    params : Job_params.t;
    started_at : string option;
    completed_at : string;
  }

  val of_model : [ `JobCancelled ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `JobCancelled ] Models.t, Models.decode_error) result
end

module Archivist_engines : sig
  type t = {
    jobs : Archivist_engines_jobs.t;
    actors : Archivist_engines_actors.t;
  }

  val of_model : [ `ArchivistEngines ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ArchivistEngines ] Models.t, Models.decode_error) result
end

module Anchored_text_write : sig
  type t = { content_checksum : string; entry : Anchored_text_entry.t }

  val of_model : [ `AnchoredTextWrite ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AnchoredTextWrite ] Models.t, Models.decode_error) result
end

module Client_refresh : sig
  type t = {
    field_comment : string;
    queries : Client_refresh_queries_item.t list;
    refresh : Client_refresh_refresh_item.t list;
  }

  val of_model : [ `ClientRefresh ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ClientRefresh ] Models.t, Models.decode_error) result
end

module Control_cli : sig
  type t = {
    field_comment : string;
    commands : (string * Control_cli_commands_value.t) list;
  }

  val of_model : [ `ControlCli ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ControlCli ] Models.t, Models.decode_error) result
end

module Stack_start_result : sig
  type t = {
    dry_run : bool;
    knowledge_base : Knowledge_base_status.t option;
    shared : Service_status.t list option;
  }

  val of_model : [ `StackStartResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `StackStartResult ] Models.t, Models.decode_error) result
end

module Stack_stop_result : sig
  type t = {
    dry_run : bool;
    knowledge_bases : Knowledge_base_status.t list option;
    shared : Service_status.t list option;
  }

  val of_model : [ `StackStopResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `StackStopResult ] Models.t, Models.decode_error) result
end

module Status_snapshot_result : sig
  type t = {
    knowledge_bases : Knowledge_base_status.t list;
    shared : Service_status.t list;
  }

  val of_model : [ `StatusSnapshotResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `StatusSnapshotResult ] Models.t, Models.decode_error) result
end

module Errors_codes : sig
  type t = {
    field_comment : string;
    bus_request : Errors_codes_bus_request.t;
    transport : Errors_codes_transport.t;
    job : Errors_codes_job.t;
    session : Errors_codes_session.t;
    sign_in : Errors_codes_sign_in.t;
    kb_identity : Errors_codes_kb_identity.t;
    span_refusal : Errors_codes_span_refusal.t;
    control : Errors_codes_control.t;
  }

  val of_model : [ `ErrorsCodes ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ErrorsCodes ] Models.t, Models.decode_error) result
end

module Sdk_telemetry_telemetry : sig
  type t = {
    field_comment : string;
    spans : Sdk_telemetry_telemetry_spans_item.t list;
    metrics : Sdk_telemetry_telemetry_metrics_item.t list;
  }

  val of_model : [ `SdkTelemetryTelemetry ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `SdkTelemetryTelemetry ] Models.t, Models.decode_error) result
end

module Smelter_health : sig
  module Status : sig
    type t = Ok

    val to_string : t -> string
    val of_string : string -> t option
  end

  module Stream : sig
    type t =
      | Initial
      | Connecting
      | Open
      | Reconnecting
      | Degraded
      | Unauthenticated
      | Closed

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    status : Status.t;
    kb : string;
    stream : Stream.t;
    following : Follower_following.t;
    events_processed : int;
    reconcile : Smelter_health_reconcile.t;
    index : Smelter_health_index.t;
  }

  val of_model : [ `SmelterHealth ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `SmelterHealth ] Models.t, Models.decode_error) result
end

module Browser : sig
  module Kind : sig
    type t = Browser

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    api_version : Enums.Stack_api_version.t;
    kind : Kind.t;
    metadata : Metadata.t;
    spec : Browser_spec.t;
  }

  val of_model : [ `Browser ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Browser ] Models.t, Models.decode_error) result
end

module Vector_store : sig
  module Kind : sig
    type t = VectorStore

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    api_version : Enums.Stack_api_version.t;
    kind : Kind.t;
    metadata : Metadata.t;
    spec : Vector_store_spec.t;
  }

  val of_model : [ `VectorStore ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `VectorStore ] Models.t, Models.decode_error) result
end

module Worker_engine_config : sig
  type t = {
    engine : Engine.t;
    jobs : Job_filter.t list;
    base_url : string;
    api_key_env : string option;
  }

  val of_model : [ `WorkerEngineConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `WorkerEngineConfig ] Models.t, Models.decode_error) result
end

module Worker_engine_health : sig
  type t = {
    engine : Engine.t;
    jobs : Job_filter.t list;
    last_queued_event_at : string option;
    last_claim_at : string option;
    last_finished_at : string option;
    last_activity_at : string option;
    active_job : Worker_engine_health_active_job.t option;
    jobs_completed : int;
  }

  val of_model : [ `WorkerEngineHealth ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `WorkerEngineHealth ] Models.t, Models.decode_error) result
end

module Body_operation : sig
  type t =
    | BodyOperationAdd of Body_operation_add.t
    | BodyOperationRemove of Body_operation_remove.t
    | BodyOperationReplace of Body_operation_replace.t

  val of_model : [ `BodyOperation ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `BodyOperation ] Models.t, Models.decode_error) result
end

module Job_stored_progress : sig
  type t =
    | JobProgress of Job_progress.t
    | Empty of (string * Yojson.Raw.t) list

  val of_model : [ `JobStoredProgress ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobStoredProgress ] Models.t, Models.decode_error) result
end

module Conformance_step : sig
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

  val of_model : [ `ConformanceStep ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ConformanceStep ] Models.t, Models.decode_error) result
end

module Issuer_spec : sig
  type t = {
    type_ : string;
    image : string;
    resources : Resources.t;
    port : int;
    database : Issuer_spec_database.t;
  }

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_index_spec : sig
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

  val to_json : t -> Yojson.Raw.t
end

module Stack_knowledge_base_spec : sig
  type t = {
    log_level : Enums.Log_level.t;
    gateway : Stack_knowledge_base_spec_gateway.t;
    dispatcher : Stack_knowledge_base_spec_dispatcher.t;
    archivist : Stack_knowledge_base_spec_archivist.t;
    messaging : Stack_knowledge_base_spec_messaging.t;
    issuer : Stack_knowledge_base_spec_issuer.t;
  }

  val to_json : t -> Yojson.Raw.t
end

module Worker_pool_spec : sig
  type t = { log_level : Enums.Log_level.t; worker : Worker_pool_spec_worker.t }

  val to_json : t -> Yojson.Raw.t
end

module Job_complete_command : sig
  type t =
    | MarkJobCompleteCommand of Mark_job_complete_command.t
    | YieldJobCompleteCommand of Yield_job_complete_command.t

  val of_model : [ `JobCompleteCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobCompleteCommand ] Models.t, Models.decode_error) result
end

module Job_queued_event : sig
  type t =
    | MarkJobQueuedEvent of Mark_job_queued_event.t
    | YieldJobQueuedEvent of Yield_job_queued_event.t

  val of_model : [ `JobQueuedEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `JobQueuedEvent ] Models.t, Models.decode_error) result
end

module Conformance_driver_line_emission_emission : sig
  type t = {
    observer : string;
    state : Conformance_driver_line_emission_emission_state.t;
  }

  val to_json : t -> Yojson.Raw.t
end

module Annotation_body_updated_payload : sig
  type t = { annotation_id : string; operations : Body_operation.t list }

  val of_model : [ `AnnotationBodyUpdatedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `AnnotationBodyUpdatedPayload ] Models.t, Models.decode_error) result
end

module Browse_annotation_history_result : sig
  type t = { response : Get_annotation_history_response.t }

  val of_model : [ `BrowseAnnotationHistoryResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `BrowseAnnotationHistoryResult ] Models.t, Models.decode_error) result
end

module Browse_events_result : sig
  type t = { response : Get_events_response.t }

  val of_model : [ `BrowseEventsResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseEventsResult ] Models.t, Models.decode_error) result
end

module Clone_resource_with_token_response : sig
  type t = {
    token : string;
    expires_at : string;
    resource : Resource_descriptor.t;
  }

  val of_model : [ `CloneResourceWithTokenResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t ->
    ([ `CloneResourceWithTokenResponse ] Models.t, Models.decode_error) result
end

module Create_annotation_request : sig
  type t = {
    motivation : Enums.Motivation.t;
    target : Annotation_target.t;
    body : Annotation_bodies.t option;
  }

  val of_model : [ `CreateAnnotationRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `CreateAnnotationRequest ] Models.t, Models.decode_error) result
end

module Gather_referenced_by_result : sig
  type t = { response : Get_referenced_by_response.t }

  val of_model : [ `GatherReferencedByResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GatherReferencedByResult ] Models.t, Models.decode_error) result
end

module Get_resource_by_token_response : sig
  type t = { source_resource : Resource_descriptor.t; expires_at : string }

  val of_model : [ `GetResourceByTokenResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GetResourceByTokenResponse ] Models.t, Models.decode_error) result
end

module Job_status_response : sig
  module Status : sig
    type t = Pending | Running | Complete | Failed | Cancelled

    val to_string : t -> string
    val of_string : string -> t option
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

  val of_model : [ `JobStatusResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobStatusResponse ] Models.t, Models.decode_error) result
end

module List_resources_response : sig
  type t = {
    resources : Resource_descriptor.t list;
    total : float;
    offset : float;
    limit : float;
  }

  val of_model : [ `ListResourcesResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ListResourcesResponse ] Models.t, Models.decode_error) result
end

module Mark_update_body_command : sig
  type t = {
    field_user_id : string option;
    annotation_id : string;
    resource_id : string;
    operations : Body_operation.t list;
  }

  val of_model : [ `MarkUpdateBodyCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MarkUpdateBodyCommand ] Models.t, Models.decode_error) result
end

module Match_search_result : sig
  type t = { reference_id : string; response : Scored_resource.t list }

  val of_model : [ `MatchSearchResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MatchSearchResult ] Models.t, Models.decode_error) result
end

module Match_resources_response : sig
  module Match_kind : sig
    type t = Lexical | Semantic

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    resources : Resource_descriptor.t list;
    total : int;
    offset : int;
    limit : int;
    match_kind : Match_kind.t;
  }

  val of_model : [ `MatchResourcesResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MatchResourcesResponse ] Models.t, Models.decode_error) result
end

module Update_annotation_body_request : sig
  type t = { resource_id : string; operations : Body_operation.t list }

  val of_model : [ `UpdateAnnotationBodyRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `UpdateAnnotationBodyRequest ] Models.t, Models.decode_error) result
end

module Job_running : sig
  module Status : sig
    type t = Running

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    status : Status.t;
    metadata : Job_metadata.t;
    params : Job_params.t;
    started_at : string;
    progress : Job_stored_progress.t;
  }

  val of_model : [ `JobRunning ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `JobRunning ] Models.t, Models.decode_error) result
end

module Archivist_config : sig
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

  val of_model : [ `ArchivistConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ArchivistConfig ] Models.t, Models.decode_error) result
end

module Conformance_case : sig
  module Planes : sig
    type t = In_process | Nats

    val to_string : t -> string
    val of_string : string -> t option
  end

  module Tier : sig
    type t = Fleet | Parity

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    about : string;
    source : string;
    planes : Planes.t list option;
    tier : Tier.t option;
    telemetry : bool option;
    steps : Conformance_step.t list;
  }

  val of_model : [ `ConformanceCase ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ConformanceCase ] Models.t, Models.decode_error) result
end

module Issuer : sig
  module Kind : sig
    type t = Issuer

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    api_version : Enums.Stack_api_version.t;
    kind : Kind.t;
    metadata : Metadata.t;
    spec : Issuer_spec.t;
  }

  val of_model : [ `Issuer ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Issuer ] Models.t, Models.decode_error) result
end

module Knowledge_index : sig
  module Kind : sig
    type t = KnowledgeIndex

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    api_version : Enums.Stack_api_version.t;
    kind : Kind.t;
    metadata : Metadata.t;
    spec : Knowledge_index_spec.t;
  }

  val of_model : [ `KnowledgeIndex ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `KnowledgeIndex ] Models.t, Models.decode_error) result
end

module Stack_knowledge_base : sig
  module Kind : sig
    type t = KnowledgeBase

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    api_version : Enums.Stack_api_version.t;
    kind : Kind.t;
    metadata : Metadata.t;
    spec : Stack_knowledge_base_spec.t;
  }

  val of_model : [ `StackKnowledgeBase ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `StackKnowledgeBase ] Models.t, Models.decode_error) result
end

module Worker_pool : sig
  module Kind : sig
    type t = WorkerPool

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    api_version : Enums.Stack_api_version.t;
    kind : Kind.t;
    metadata : Metadata.t;
    spec : Worker_pool_spec.t;
  }

  val of_model : [ `WorkerPool ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `WorkerPool ] Models.t, Models.decode_error) result
end

module Worker_knowledge_base_config : sig
  type t = {
    domain : string;
    gateway_url : string;
    identity : Worker_knowledge_base_config_identity.t;
    engines : Worker_engine_config.t list;
  }

  val of_model : [ `WorkerKnowledgeBaseConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `WorkerKnowledgeBaseConfig ] Models.t, Models.decode_error) result
end

module Worker_knowledge_base_health : sig
  module State : sig
    type t = Starting | Working | Refused

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    domain : string;
    state : State.t;
    did : string option;
    engines : Worker_engine_health.t list option;
  }

  val of_model : [ `WorkerKnowledgeBaseHealth ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `WorkerKnowledgeBaseHealth ] Models.t, Models.decode_error) result
end

module Annotation_target_value : sig
  type t = ResourceId of string | AnnotationTarget of Annotation_target.t

  val to_json : t -> Yojson.Raw.t
end

module Browse_engines_result_response : sig
  type t = { engines : Engine_entry.t list }

  val to_json : t -> Yojson.Raw.t
end

module Browse_resource_result_response : sig
  type t = { resource : Resource_descriptor.t; last_sequence : int }

  val to_json : t -> Yojson.Raw.t
end

module Gathered_context_focus_resource : sig
  module Kind : sig
    type t = Resource

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    kind : Kind.t;
    resource : Resource_descriptor.t;
    summary : string option;
    suggested_references : string list option;
    content : Gathered_context_focus_resource_content.t option;
  }

  val to_json : t -> Yojson.Raw.t
end

module Inference_spec : sig
  type t = {
    providers : (string * Provider.t) list;
    engines : Archivist_engines.t;
  }

  val to_json : t -> Yojson.Raw.t
end

module Conformance_driver_line_emission : sig
  type t = { emission : Conformance_driver_line_emission_emission.t }

  val to_json : t -> Yojson.Raw.t
end

module Annotation : sig
  module Field_context : sig
    type t = Field_context

    val to_string : t -> string
    val of_string : string -> t option
  end

  module Type_ : sig
    type t = Annotation

    val to_string : t -> string
    val of_string : string -> t option
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

  val of_model : [ `Annotation ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Annotation ] Models.t, Models.decode_error) result
end

module Browse_engines_result : sig
  type t = { response : Browse_engines_result_response.t }

  val of_model : [ `BrowseEnginesResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseEnginesResult ] Models.t, Models.decode_error) result
end

module Browse_resource_result : sig
  type t = { response : Browse_resource_result_response.t }

  val of_model : [ `BrowseResourceResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseResourceResult ] Models.t, Models.decode_error) result
end

module Browse_resources_result : sig
  type t = { response : List_resources_response.t }

  val of_model : [ `BrowseResourcesResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseResourcesResult ] Models.t, Models.decode_error) result
end

module Job_status_result : sig
  type t = { response : Job_status_response.t }

  val of_model : [ `JobStatusResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobStatusResult ] Models.t, Models.decode_error) result
end

module Mark_create_request : sig
  type t = { resource_id : string; request : Create_annotation_request.t }

  val of_model : [ `MarkCreateRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MarkCreateRequest ] Models.t, Models.decode_error) result
end

module Match_resources_result : sig
  type t = { response : Match_resources_response.t }

  val of_model : [ `MatchResourcesResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MatchResourcesResult ] Models.t, Models.decode_error) result
end

module Job_claimed_result : sig
  type t = { response : Job_running.t }

  val of_model : [ `JobClaimedResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobClaimedResult ] Models.t, Models.decode_error) result
end

module Inference : sig
  module Kind : sig
    type t = Inference

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    api_version : Enums.Stack_api_version.t;
    kind : Kind.t;
    metadata : Metadata.t;
    spec : Inference_spec.t;
  }

  val of_model : [ `Inference ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Inference ] Models.t, Models.decode_error) result
end

module Worker_config : sig
  type t = {
    knowledge_bases : Worker_knowledge_base_config.t list;
    model_catalogue : string;
    port : int;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
  }

  val of_model : [ `WorkerConfig ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `WorkerConfig ] Models.t, Models.decode_error) result
end

module Worker_health : sig
  module Status : sig
    type t = Ok

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    status : Status.t;
    knowledge_bases : Worker_knowledge_base_health.t list;
  }

  val of_model : [ `WorkerHealth ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `WorkerHealth ] Models.t, Models.decode_error) result
end

module Job : sig
  type t =
    | JobPending of Job_pending.t
    | JobRunning of Job_running.t
    | JobComplete of Job_complete.t
    | JobFailed of Job_failed.t
    | JobCancelled of Job_cancelled.t

  val of_model : [ `Job ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `Job ] Models.t, Models.decode_error) result
end

module Conformance_driver_line : sig
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

  val of_model : [ `ConformanceDriverLine ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ConformanceDriverLine ] Models.t, Models.decode_error) result
end

module Annotation_added_payload : sig
  type t = { annotation : Annotation.t; content_checksum : string option }

  val of_model : [ `AnnotationAddedPayload ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `AnnotationAddedPayload ] Models.t, Models.decode_error) result
end

module Enriched_resource_event : sig
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

  val of_model : [ `EnrichedResourceEvent ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `EnrichedResourceEvent ] Models.t, Models.decode_error) result
end

module Get_annotation_response : sig
  type t = {
    annotation : Annotation.t;
    resource : Resource_descriptor.t option;
    resolved_resource : Resource_descriptor.t option;
  }

  val of_model : [ `GetAnnotationResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GetAnnotationResponse ] Models.t, Models.decode_error) result
end

module Get_annotations_response : sig
  type t = {
    annotations : Annotation.t list;
    total : float;
    motivation : Enums.Motivation.t option;
  }

  val of_model : [ `GetAnnotationsResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GetAnnotationsResponse ] Models.t, Models.decode_error) result
end

module Get_resource_response : sig
  type t = { resource : Resource_descriptor.t; annotations : Annotation.t list }

  val of_model : [ `GetResourceResponse ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GetResourceResponse ] Models.t, Models.decode_error) result
end

module Graph_annotation_node : sig
  module Type_ : sig
    type t = Annotation

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    id : string;
    type_ : Type_.t;
    label : string;
    entity_types : string list option;
    annotation : Annotation.t;
    metadata : (string * Yojson.Raw.t) list option;
  }

  val of_model : [ `GraphAnnotationNode ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GraphAnnotationNode ] Models.t, Models.decode_error) result
end

module Mark_commit_command : sig
  type t = {
    field_user_id : string option;
    field_roles : string list option;
    job_id : string option;
    resource_id : string;
    annotations : Annotation.t list;
  }

  val of_model : [ `MarkCommitCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MarkCommitCommand ] Models.t, Models.decode_error) result
end

module Job_record : sig
  type t = { job : Job.t; last_progress_at : string }

  val of_model : [ `JobRecord ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `JobRecord ] Models.t, Models.decode_error) result
end

module Resource_annotations : sig
  type t = {
    resource_id : string;
    annotations : Annotation.t list;
    version : int;
    updated_at : string;
  }

  val of_model : [ `ResourceAnnotations ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `ResourceAnnotations ] Models.t, Models.decode_error) result
end

module Gathered_context_focus_annotation : sig
  module Kind : sig
    type t = Annotation

    val to_string : t -> string
    val of_string : string -> t option
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

  val to_json : t -> Yojson.Raw.t
end

module Browse_annotation_result : sig
  type t = { response : Get_annotation_response.t }

  val of_model : [ `BrowseAnnotationResult ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `BrowseAnnotationResult ] Models.t, Models.decode_error) result
end

module Resource_view : sig
  type t = {
    resource : Resource_descriptor.t;
    annotations : Resource_annotations.t;
    last_sequence : int;
  }

  val of_model : [ `ResourceView ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `ResourceView ] Models.t, Models.decode_error) result
end

module Gathered_context_focus : sig
  type t =
    | Annotation of Gathered_context_focus_annotation.t
    | Resource of Gathered_context_focus_resource.t

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_graph_nodes_item : sig
  type t =
    | GraphResourceNode of Graph_resource_node.t
    | GraphAnnotationNode of Graph_annotation_node.t

  val to_json : t -> Yojson.Raw.t
end

module Knowledge_graph : sig
  type t = {
    nodes : Knowledge_graph_nodes_item.t list;
    edges : Knowledge_graph_edges_item.t list;
    truncated : bool option;
  }

  val of_model : [ `KnowledgeGraph ] Models.t -> t
  val to_json : t -> Yojson.Raw.t
  val to_model : t -> ([ `KnowledgeGraph ] Models.t, Models.decode_error) result
end

module Gathered_context : sig
  type t = {
    focus : Gathered_context_focus.t;
    graph : Knowledge_graph.t;
    semantic_context : Gathered_context_semantic_context.t option;
    metadata : Gathered_context_metadata.t;
    inferred_relationship_summary : string option;
  }

  val of_model : [ `GatheredContext ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GatheredContext ] Models.t, Models.decode_error) result
end

module Gather_annotation_complete : sig
  type t = { annotation_id : string; response : Gathered_context.t }

  val of_model : [ `GatherAnnotationComplete ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GatherAnnotationComplete ] Models.t, Models.decode_error) result
end

module Gather_resource_complete : sig
  type t = { resource_id : string; response : Gathered_context.t }

  val of_model : [ `GatherResourceComplete ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GatherResourceComplete ] Models.t, Models.decode_error) result
end

module Generation_job_params : sig
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

  val of_model : [ `GenerationJobParams ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `GenerationJobParams ] Models.t, Models.decode_error) result
end

module Match_search_request : sig
  type t = {
    resource_id : string;
    reference_id : string;
    context : Gathered_context.t;
    limit : int option;
    use_semantic_scoring : bool option;
  }

  val of_model : [ `MatchSearchRequest ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `MatchSearchRequest ] Models.t, Models.decode_error) result
end

module Yield_job_create_command : sig
  module Job_type : sig
    type t = Yield

    val to_string : t -> string
    val of_string : string -> t option
  end

  type t = {
    field_user_id : string option;
    field_roles : string list option;
    job_type : Job_type.t;
    params : Generation_job_params.t;
  }

  val of_model : [ `YieldJobCreateCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `YieldJobCreateCommand ] Models.t, Models.decode_error) result
end

module Job_create_command : sig
  type t =
    | MarkJobCreateCommand of Mark_job_create_command.t
    | YieldJobCreateCommand of Yield_job_create_command.t

  val of_model : [ `JobCreateCommand ] Models.t -> t
  val to_json : t -> Yojson.Raw.t

  val to_model :
    t -> ([ `JobCreateCommand ] Models.t, Models.decode_error) result
end
