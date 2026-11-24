(* Generated from OpenAPI object components and discriminator mappings, and the records of Protocol's tables. Do not edit.
   Regenerate: make generate (codegen/lib/ocaml_sdk/records.ml) *)

open Record_reader

module Agent_organization = struct
  type t = {
    field_type : string;
    field_id : string Types.presence;
    name : string;
    homepage : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_type = required reader string "@type";
        field_id = optional reader string "@id";
        name = required reader string "name";
        homepage = optional reader string "homepage";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AgentOrganization ] Models.t) =
    project (fields_of (Models.json model))
end

module Agent_person = struct
  type t = {
    field_type : string;
    field_id : string Types.presence;
    name : string Types.presence;
    nickname : string Types.presence;
    email : string Types.presence;
    email_sha1 : string Types.presence;
    homepage : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_type = required reader string "@type";
        field_id = optional reader string "@id";
        name = optional reader string "name";
        nickname = optional reader string "nickname";
        email = optional reader string "email";
        email_sha1 = optional reader string "email_sha1";
        homepage = optional reader string "homepage";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AgentPerson ] Models.t) =
    project (fields_of (Models.json model))
end

module Agent_software = struct
  type t = {
    field_type : string;
    field_id : string Types.presence;
    name : string Types.presence;
    provider : string Types.presence;
    model : string Types.presence;
    parameters : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_type = required reader string "@type";
        field_id = optional reader string "@id";
        name = optional reader string "name";
        provider = optional reader string "provider";
        model = optional reader string "model";
        parameters = optional reader raw "parameters";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AgentSoftware ] Models.t) =
    project (fields_of (Models.json model))
end

module Annotation = struct
  type t = {
    field_context : string;
    type_ : string;
    id : Yojson.Raw.t;
    motivation : Yojson.Raw.t;
    target : Yojson.Raw.t;
    body : Yojson.Raw.t Types.presence;
    creator : Yojson.Raw.t Types.presence;
    created : string;
    modified : string Types.presence;
    generator : Yojson.Raw.t Types.presence;
    was_attributed_to : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_context = required reader string "@context";
        type_ = required reader string "type";
        id = required reader raw "id";
        motivation = required reader raw "motivation";
        target = required reader raw "target";
        body = optional reader raw "body";
        creator = optional reader raw "creator";
        created = required reader string "created";
        modified = optional reader string "modified";
        generator = optional reader raw "generator";
        was_attributed_to = optional reader raw "wasAttributedTo";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Annotation ] Models.t) =
    project (fields_of (Models.json model))
end

module Annotation_added_payload = struct
  type t = {
    annotation : Yojson.Raw.t;
    content_checksum : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation = required reader raw "annotation";
        content_checksum = optional reader string "contentChecksum";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnnotationAddedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Annotation_body_updated_payload = struct
  type t = {
    annotation_id : Yojson.Raw.t;
    operations : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = required reader raw "annotationId";
        operations = required reader raw "operations";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnnotationBodyUpdatedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Annotation_removed_payload = struct
  type t = {
    annotation_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      { annotation_id = required reader raw "annotationId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnnotationRemovedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Annotation_target = struct
  type t = {
    type_ : string Types.presence;
    source : Yojson.Raw.t;
    selector : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = optional reader string "type";
        source = required reader raw "source";
        selector = optional reader raw "selector";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnnotationTarget ] Models.t) =
    project (fields_of (Models.json model))
end

module Attributed_event = struct
  type t = {
    id : string;
    type_ : string;
    timestamp : string;
    user_id : Yojson.Raw.t;
    resource_id : Yojson.Raw.t Types.presence;
    version : Yojson.Raw.t;
    payload : Yojson.Raw.t;
    metadata : Yojson.Raw.t;
    agent : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader string "id";
        type_ = required reader string "type";
        timestamp = required reader string "timestamp";
        user_id = required reader raw "userId";
        resource_id = optional reader raw "resourceId";
        version = required reader raw "version";
        payload = required reader raw "payload";
        metadata = required reader raw "metadata";
        agent = required reader raw "agent";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AttributedEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Beckon_focus_event = struct
  type t = {
    annotation_id : Yojson.Raw.t Types.presence;
    resource_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = optional reader raw "annotationId";
        resource_id = required reader raw "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BeckonFocusEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Beckon_hover_event = struct
  type t = {
    annotation_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      { annotation_id = required reader raw "annotationId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BeckonHoverEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Beckon_sparkle_event = struct
  type t = {
    annotation_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      { annotation_id = required reader raw "annotationId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BeckonSparkleEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Bind_body_operation = struct
  type t = {
    op : string;
    item : Yojson.Raw.t Types.presence;
    old_item : Yojson.Raw.t Types.presence;
    new_item : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        op = required reader string "op";
        item = optional reader raw "item";
        old_item = optional reader raw "oldItem";
        new_item = optional reader raw "newItem";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BindBodyOperation ] Models.t) =
    project (fields_of (Models.json model))
end

module Bind_initiate_command = struct
  type t = {
    annotation_id : Yojson.Raw.t;
    resource_id : Yojson.Raw.t;
    default_title : string;
    entity_types : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = required reader raw "annotationId";
        resource_id = required reader raw "resourceId";
        default_title = required reader string "defaultTitle";
        entity_types = required reader raw "entityTypes";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BindInitiateCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Bind_update_body_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    annotation_id : Yojson.Raw.t;
    resource_id : Yojson.Raw.t;
    operations : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        annotation_id = required reader raw "annotationId";
        resource_id = required reader raw "resourceId";
        operations = required reader raw "operations";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BindUpdateBodyCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Body_operation_add = struct
  type t = {
    op : string;
    item : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        op = required reader string "op";
        item = required reader raw "item";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BodyOperationAdd ] Models.t) =
    project (fields_of (Models.json model))
end

module Body_operation_remove = struct
  type t = {
    op : string;
    item : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        op = required reader string "op";
        item = required reader raw "item";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BodyOperationRemove ] Models.t) =
    project (fields_of (Models.json model))
end

module Body_operation_replace = struct
  type t = {
    op : string;
    old_item : Yojson.Raw.t;
    new_item : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        op = required reader string "op";
        old_item = required reader raw "oldItem";
        new_item = required reader raw "newItem";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BodyOperationReplace ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_engines_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseEnginesResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_profiles_request = struct
  type t = { dids : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { dids = required reader raw "dids"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseProfilesRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_profiles_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseProfilesResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_annotation_history_request = struct
  type t = {
    resource_id : Yojson.Raw.t;
    annotation_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        annotation_id = required reader raw "annotationId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseAnnotationHistoryRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_annotation_history_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseAnnotationHistoryResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_annotation_request = struct
  type t = {
    resource_id : Yojson.Raw.t;
    annotation_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        annotation_id = required reader raw "annotationId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseAnnotationRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_annotation_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseAnnotationResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Anchor_rect = struct
  type t = {
    x : Yojson.Raw.t;
    y : Yojson.Raw.t;
    width : Yojson.Raw.t;
    height : Yojson.Raw.t;
    top : Yojson.Raw.t;
    right : Yojson.Raw.t;
    bottom : Yojson.Raw.t;
    left : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        x = required reader raw "x";
        y = required reader raw "y";
        width = required reader raw "width";
        height = required reader raw "height";
        top = required reader raw "top";
        right = required reader raw "right";
        bottom = required reader raw "bottom";
        left = required reader raw "left";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnchorRect ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_click_event = struct
  type t = {
    annotation_id : Yojson.Raw.t;
    anchor_rect : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = required reader raw "annotationId";
        anchor_rect = optional reader raw "anchorRect";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseClickEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_directory_request = struct
  type t = {
    path : string;
    sort : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        path = required reader string "path";
        sort = optional reader string "sort";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseDirectoryRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_directory_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseDirectoryResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_directory_result_response = struct
  type t = {
    path : string;
    entries : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        path = required reader string "path";
        entries = required reader raw "entries";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseDirectoryResultResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_entity_type_clicked_event = struct
  type t = { entity_type : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { entity_type = required reader string "entityType"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseEntityTypeClickedEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_entity_types_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseEntityTypesResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_events_request = struct
  type t = {
    resource_id : Yojson.Raw.t;
    type_ : string Types.presence;
    user_id : Yojson.Raw.t Types.presence;
    limit : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        type_ = optional reader string "type";
        user_id = optional reader raw "userId";
        limit = optional reader raw "limit";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseEventsRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_events_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseEventsResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_external_navigate_event = struct
  type t = {
    url : string;
    resource_id : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        url = required reader string "url";
        resource_id = optional reader raw "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseExternalNavigateEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_files_response = struct
  type t = {
    path : string;
    entries : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        path = required reader string "path";
        entries = required reader raw "entries";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseFilesResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_kb_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseKbResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_link_clicked_event = struct
  type t = {
    href : string;
    label : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        href = required reader string "href";
        label = optional reader string "label";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseLinkClickedEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_panel_open_event = struct
  type t = {
    panel : string;
    scroll_to_annotation_id : Yojson.Raw.t Types.presence;
    motivation : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        panel = required reader string "panel";
        scroll_to_annotation_id = optional reader raw "scrollToAnnotationId";
        motivation = optional reader raw "motivation";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowsePanelOpenEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_panel_toggle_event = struct
  type t = { panel : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { panel = required reader string "panel"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowsePanelToggleEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_resource_open_event = struct
  type t = { resource_id : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader raw "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourceOpenEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_resource_viewed_event = struct
  type t = { resource_id : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader raw "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourceViewedEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_resource_close_event = struct
  type t = { resource_id : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader raw "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourceCloseEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_resource_reorder_event = struct
  type t = {
    old_index : Yojson.Raw.t;
    new_index : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        old_index = required reader raw "oldIndex";
        new_index = required reader raw "newIndex";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourceReorderEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Anchored_text = struct
  type t = {
    text : string;
    items : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        text = required reader string "text";
        items = required reader raw "items";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnchoredText ] Models.t) =
    project (fields_of (Models.json model))
end

module Pdf_text_item = struct
  type t = {
    start : Yojson.Raw.t;
    end_ : Yojson.Raw.t;
    page : Yojson.Raw.t;
    x : Yojson.Raw.t;
    y : Yojson.Raw.t;
    width : Yojson.Raw.t;
    height : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        start = required reader raw "start";
        end_ = required reader raw "end";
        page = required reader raw "page";
        x = required reader raw "x";
        y = required reader raw "y";
        width = required reader raw "width";
        height = required reader raw "height";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `PdfTextItem ] Models.t) =
    project (fields_of (Models.json model))
end

module Anchored_text_absent = struct
  type t = { kind : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { kind = required reader string "kind"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `AnchoredTextAbsent ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_resource_request = struct
  type t = { resource_id : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader raw "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourceRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_resource_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourceResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_resources_request = struct
  type t = {
    archived : bool Types.presence;
    entity_type : string Types.presence;
    offset : Yojson.Raw.t Types.presence;
    limit : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        archived = optional reader bool "archived";
        entity_type = optional reader string "entityType";
        offset = optional reader raw "offset";
        limit = optional reader raw "limit";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourcesRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_resources_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourcesResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_router_push_event = struct
  type t = {
    path : string;
    reason : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        path = required reader string "path";
        reason = optional reader string "reason";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseRouterPushEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_tag_schemas_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseTagSchemasResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Bus_emit_accepted = struct
  type t = {
    subscribers : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      { subscribers = optional reader raw "subscribers"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BusEmitAccepted ] Models.t) =
    project (fields_of (Models.json model))
end

module Bus_emit_request = struct
  type t = {
    channel : string;
    payload : Yojson.Raw.t;
    scope : Yojson.Raw.t Types.presence;
    client_id : string Types.presence;
    correlation_id : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        channel = required reader string "channel";
        payload = required reader raw "payload";
        scope = optional reader raw "scope";
        client_id = optional reader string "clientId";
        correlation_id = optional reader string "correlationId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BusEmitRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Bus_subscribe_request = struct
  type t = {
    global : Yojson.Raw.t Types.presence;
    pending_replies : Yojson.Raw.t Types.presence;
    scoped : Yojson.Raw.t Types.presence;
    client_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        global = optional reader raw "global";
        pending_replies = optional reader raw "pendingReplies";
        scoped = optional reader raw "scoped";
        client_id = required reader string "clientId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BusSubscribeRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Clone_resource_with_token_response = struct
  type t = {
    token : string;
    expires_at : string;
    resource : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        token = required reader string "token";
        expires_at = required reader string "expiresAt";
        resource = required reader raw "resource";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `CloneResourceWithTokenResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Engine_entry = struct
  type t = {
    engine : Yojson.Raw.t;
    jobs : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        engine = required reader raw "engine";
        jobs = optional reader raw "jobs";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `EngineEntry ] Models.t) =
    project (fields_of (Models.json model))
end

module Command_error = struct
  type t = {
    code : string Types.presence;
    message : string;
    details : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = optional reader string "code";
        message = required reader string "message";
        details = optional reader string "details";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `CommandError ] Models.t) =
    project (fields_of (Models.json model))
end

module Contextual_summary_response = struct
  type t = {
    summary : string;
    relevant_fields : Yojson.Raw.t;
    context : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        summary = required reader string "summary";
        relevant_fields = required reader raw "relevantFields";
        context = required reader raw "context";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ContextualSummaryResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Create_annotation_request = struct
  type t = {
    motivation : Yojson.Raw.t;
    target : Yojson.Raw.t;
    body : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        motivation = required reader raw "motivation";
        target = required reader raw "target";
        body = optional reader raw "body";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `CreateAnnotationRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Create_resource_response = struct
  type t = { resource_id : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader raw "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `CreateResourceResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Dir_entry = struct
  type t = {
    type_ : string;
    name : string;
    path : string;
    mtime : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader string "type";
        name = required reader string "name";
        path = required reader string "path";
        mtime = required reader string "mtime";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `DirEntry ] Models.t) =
    project (fields_of (Models.json model))
end

module Discovered_kb = struct
  type t = {
    host : string;
    port : Yojson.Raw.t;
    placement : string;
    repo : string Types.presence;
    did : string;
    site_name : string Types.presence;
    managed_by : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        host = required reader string "host";
        port = required reader raw "port";
        placement = required reader string "placement";
        repo = optional reader string "repo";
        did = required reader string "did";
        site_name = optional reader string "siteName";
        managed_by = required reader string "managedBy";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `DiscoveredKB ] Models.t) =
    project (fields_of (Models.json model))
end

module Discovery_document = struct
  type t = {
    version : Yojson.Raw.t;
    kbs : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        version = required reader raw "version";
        kbs = required reader raw "kbs";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `DiscoveryDocument ] Models.t) =
    project (fields_of (Models.json model))
end

module Enriched_resource_event = struct
  type t = {
    id : string;
    type_ : string;
    timestamp : string;
    user_id : Yojson.Raw.t;
    resource_id : Yojson.Raw.t Types.presence;
    version : Yojson.Raw.t;
    payload : Yojson.Raw.t;
    metadata : Yojson.Raw.t;
    annotation : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader string "id";
        type_ = required reader string "type";
        timestamp = required reader string "timestamp";
        user_id = required reader raw "userId";
        resource_id = optional reader raw "resourceId";
        version = required reader raw "version";
        payload = required reader raw "payload";
        metadata = required reader raw "metadata";
        annotation = optional reader raw "annotation";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `EnrichedResourceEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Entity_tag_changed_payload = struct
  type t = { entity_type : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { entity_type = required reader string "entityType"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `EntityTagChangedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Entity_type_added_payload = struct
  type t = { entity_type : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { entity_type = required reader string "entityType"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `EntityTypeAddedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Error_response = struct
  type t = {
    error : string;
    code : string Types.presence;
    hint : string Types.presence;
    details : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        error = required reader string "error";
        code = optional reader string "code";
        hint = optional reader string "hint";
        details = optional reader raw "details";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ErrorResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Event_metadata = struct
  type t = {
    sequence_number : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      { sequence_number = required reader raw "sequenceNumber"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `EventMetadata ] Models.t) =
    project (fields_of (Models.json model))
end

module Extracted_text = struct
  type t = {
    text : string;
    items : Yojson.Raw.t;
    kind : string;
    method_ : Yojson.Raw.t;
    pdf_class : Yojson.Raw.t Types.presence;
    ocr_confidence : Yojson.Raw.t Types.presence;
    unread_pages : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        text = required reader string "text";
        items = required reader raw "items";
        kind = required reader string "kind";
        method_ = required reader raw "method";
        pdf_class = optional reader raw "pdfClass";
        ocr_confidence = optional reader raw "ocrConfidence";
        unread_pages = optional reader raw "unreadPages";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ExtractedText ] Models.t) =
    project (fields_of (Models.json model))
end

module Ocr_confidence = struct
  type t = {
    mean : Yojson.Raw.t;
    low_confidence_words : Yojson.Raw.t;
    total_words : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        mean = required reader raw "mean";
        low_confidence_words = required reader raw "lowConfidenceWords";
        total_words = required reader raw "totalWords";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `OcrConfidence ] Models.t) =
    project (fields_of (Models.json model))
end

module Extraction_declined = struct
  type t = {
    kind : string;
    declined : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kind = required reader string "kind";
        declined = required reader raw "declined";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ExtractionDeclined ] Models.t) =
    project (fields_of (Models.json model))
end

module File_entry = struct
  type t = {
    type_ : string;
    name : string;
    path : string;
    size : Yojson.Raw.t;
    mtime : string;
    tracked : bool;
    resource_id : Yojson.Raw.t Types.presence;
    entity_types : Yojson.Raw.t Types.presence;
    annotation_count : Yojson.Raw.t Types.presence;
    creator : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader string "type";
        name = required reader string "name";
        path = required reader string "path";
        size = required reader raw "size";
        mtime = required reader string "mtime";
        tracked = required reader bool "tracked";
        resource_id = optional reader raw "resourceId";
        entity_types = optional reader raw "entityTypes";
        annotation_count = optional reader raw "annotationCount";
        creator = optional reader string "creator";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `FileEntry ] Models.t) =
    project (fields_of (Models.json model))
end

module Fragment_selector = struct
  type t = {
    type_ : string;
    value : string;
    conforms_to : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader string "type";
        value = required reader string "value";
        conforms_to = optional reader string "conformsTo";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `FragmentSelector ] Models.t) =
    project (fields_of (Models.json model))
end

module Frame_add_entity_type_command = struct
  type t = {
    tag : string;
    field_user_id : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        tag = required reader string "tag";
        field_user_id = optional reader raw "_userId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `FrameAddEntityTypeCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Frame_add_tag_schema_command = struct
  type t = {
    schema : Yojson.Raw.t;
    field_user_id : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        schema = required reader raw "schema";
        field_user_id = optional reader raw "_userId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `FrameAddTagSchemaCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Gather_annotation_complete = struct
  type t = {
    annotation_id : Yojson.Raw.t;
    response : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = required reader raw "annotationId";
        response = required reader raw "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherAnnotationComplete ] Models.t) =
    project (fields_of (Models.json model))
end

module Gather_annotation_options = struct
  type t = {
    include_source_context : bool Types.presence;
    include_target_context : bool Types.presence;
    context_window : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        include_source_context = optional reader bool "includeSourceContext";
        include_target_context = optional reader bool "includeTargetContext";
        context_window = optional reader raw "contextWindow";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherAnnotationOptions ] Models.t) =
    project (fields_of (Models.json model))
end

module Gather_annotation_request = struct
  type t = {
    annotation_id : Yojson.Raw.t;
    resource_id : Yojson.Raw.t;
    options : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = required reader raw "annotationId";
        resource_id = required reader raw "resourceId";
        options = optional reader raw "options";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherAnnotationRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Gather_resource_complete = struct
  type t = {
    resource_id : Yojson.Raw.t;
    response : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        response = required reader raw "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherResourceComplete ] Models.t) =
    project (fields_of (Models.json model))
end

module Gather_resource_request = struct
  type t = {
    resource_id : Yojson.Raw.t;
    options : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        options = required reader raw "options";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherResourceRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Gather_resource_request_options = struct
  type t = {
    depth : Yojson.Raw.t;
    max_resources : Yojson.Raw.t;
    include_content : bool;
    include_summary : bool;
    exclude_entity_types : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        depth = required reader raw "depth";
        max_resources = required reader raw "maxResources";
        include_content = required reader bool "includeContent";
        include_summary = required reader bool "includeSummary";
        exclude_entity_types = optional reader raw "excludeEntityTypes";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherResourceRequestOptions ] Models.t) =
    project (fields_of (Models.json model))
end

module Gather_summary_request = struct
  type t = {
    annotation_id : Yojson.Raw.t;
    resource_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = required reader raw "annotationId";
        resource_id = required reader raw "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherSummaryRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Gather_referenced_by_request = struct
  type t = {
    resource_id : Yojson.Raw.t;
    motivation : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        motivation = optional reader raw "motivation";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherReferencedByRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Gather_referenced_by_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `GatherReferencedByResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Gathered_context = struct
  type t = {
    focus : Yojson.Raw.t;
    graph : Yojson.Raw.t;
    semantic_context : Yojson.Raw.t Types.presence;
    metadata : Yojson.Raw.t;
    inferred_relationship_summary : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        focus = required reader raw "focus";
        graph = required reader raw "graph";
        semantic_context = optional reader raw "semanticContext";
        metadata = required reader raw "metadata";
        inferred_relationship_summary =
          optional reader string "inferredRelationshipSummary";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatheredContext ] Models.t) =
    project (fields_of (Models.json model))
end

module Generation_job_params = struct
  type t = {
    title : string;
    storage_uri : string;
    prompt : string Types.presence;
    entity_types : Yojson.Raw.t Types.presence;
    language : string Types.presence;
    source_language : string Types.presence;
    temperature : Yojson.Raw.t Types.presence;
    max_tokens : Yojson.Raw.t Types.presence;
    output_media_type : Yojson.Raw.t Types.presence;
    task : string Types.presence;
    structure : string Types.presence;
    cite : bool Types.presence;
    context : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        title = required reader string "title";
        storage_uri = required reader string "storageUri";
        prompt = optional reader string "prompt";
        entity_types = optional reader raw "entityTypes";
        language = optional reader string "language";
        source_language = optional reader string "sourceLanguage";
        temperature = optional reader raw "temperature";
        max_tokens = optional reader raw "maxTokens";
        output_media_type = optional reader raw "outputMediaType";
        task = optional reader string "task";
        structure = optional reader string "structure";
        cite = optional reader bool "cite";
        context = required reader raw "context";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GenerationJobParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Get_annotation_history_response = struct
  type t = {
    events : Yojson.Raw.t;
    total : Yojson.Raw.t;
    annotation_id : Yojson.Raw.t;
    resource_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        events = required reader raw "events";
        total = required reader raw "total";
        annotation_id = required reader raw "annotationId";
        resource_id = required reader raw "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetAnnotationHistoryResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Get_annotation_response = struct
  type t = {
    annotation : Yojson.Raw.t;
    resource : Yojson.Raw.t;
    resolved_resource : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation = required reader raw "annotation";
        resource = required reader raw "resource";
        resolved_resource = required reader raw "resolvedResource";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetAnnotationResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Get_annotations_response = struct
  type t = {
    annotations : Yojson.Raw.t;
    total : Yojson.Raw.t;
    motivation : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotations = required reader raw "annotations";
        total = required reader raw "total";
        motivation = optional reader raw "motivation";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetAnnotationsResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Get_entity_types_response = struct
  type t = { entity_types : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { entity_types = required reader raw "entityTypes"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetEntityTypesResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Get_events_response = struct
  type t = {
    events : Yojson.Raw.t;
    total : Yojson.Raw.t;
    resource_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        events = required reader raw "events";
        total = required reader raw "total";
        resource_id = required reader raw "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetEventsResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Get_referenced_by_response = struct
  type t = {
    referenced_by : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      { referenced_by = required reader raw "referencedBy"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetReferencedByResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Get_referenced_by_response_referenced_by_item = struct
  type t = {
    id : Yojson.Raw.t;
    resource_name : string Types.presence;
    target : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader raw "id";
        resource_name = optional reader string "resourceName";
        target = required reader raw "target";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetReferencedByResponseReferencedByItem ] Models.t) =
    project (fields_of (Models.json model))
end

module Get_resource_by_token_response = struct
  type t = {
    source_resource : Yojson.Raw.t;
    expires_at : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        source_resource = required reader raw "sourceResource";
        expires_at = required reader string "expiresAt";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetResourceByTokenResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Get_resource_response = struct
  type t = {
    resource : Yojson.Raw.t;
    annotations : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource = required reader raw "resource";
        annotations = required reader raw "annotations";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetResourceResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Get_tag_schemas_response = struct
  type t = { tag_schemas : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { tag_schemas = required reader raw "tagSchemas"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetTagSchemasResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Health_response = struct
  type t = {
    status : string;
    message : string;
    version : string;
    timestamp : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader string "status";
        message = required reader string "message";
        version = required reader string "version";
        timestamp = required reader string "timestamp";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `HealthResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Inference_limits = struct
  type t = {
    context_tokens : Yojson.Raw.t;
    max_output_tokens : Yojson.Raw.t;
    accepts_temperature : bool Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        context_tokens = required reader raw "contextTokens";
        max_output_tokens = required reader raw "maxOutputTokens";
        accepts_temperature = optional reader bool "acceptsTemperature";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `InferenceLimits ] Models.t) =
    project (fields_of (Models.json model))
end

module Inference_limits_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `InferenceLimitsResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Engine_limits = struct
  type t = {
    engine : Yojson.Raw.t;
    limits : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        engine = required reader raw "engine";
        limits = required reader raw "limits";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `EngineLimits ] Models.t) =
    project (fields_of (Models.json model))
end

module Graph_annotation_node = struct
  type t = {
    id : Yojson.Raw.t;
    type_ : string;
    label : string;
    entity_types : Yojson.Raw.t Types.presence;
    annotation : Yojson.Raw.t;
    metadata : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader raw "id";
        type_ = required reader string "type";
        label = required reader string "label";
        entity_types = optional reader raw "entityTypes";
        annotation = required reader raw "annotation";
        metadata = optional reader raw "metadata";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GraphAnnotationNode ] Models.t) =
    project (fields_of (Models.json model))
end

module Graph_resource_node = struct
  type t = {
    id : Yojson.Raw.t;
    type_ : string;
    label : string;
    entity_types : Yojson.Raw.t Types.presence;
    metadata : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader raw "id";
        type_ = required reader string "type";
        label = required reader string "label";
        entity_types = optional reader raw "entityTypes";
        metadata = optional reader raw "metadata";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GraphResourceNode ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_cancel_request = struct
  type t = { job_id : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { job_id = required reader raw "jobId"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobCancelRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_cancel_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    resource_id : Yojson.Raw.t;
    job_id : Yojson.Raw.t;
    job_type : Yojson.Raw.t;
    annotation_id : Yojson.Raw.t Types.presence;
    completed_units : Yojson.Raw.t Types.presence;
    unit_cursors : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        resource_id = required reader raw "resourceId";
        job_id = required reader raw "jobId";
        job_type = required reader raw "jobType";
        annotation_id = optional reader raw "annotationId";
        completed_units = optional reader raw "completedUnits";
        unit_cursors = optional reader raw "unitCursors";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobCancelCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_claim_command = struct
  type t = {
    accepts : Yojson.Raw.t;
    field_user_id : Yojson.Raw.t Types.presence;
    field_roles : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        accepts = required reader raw "accepts";
        field_user_id = optional reader raw "_userId";
        field_roles = optional reader raw "_roles";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobClaimCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_completed_payload = struct
  type t = {
    job_id : Yojson.Raw.t;
    job_type : Yojson.Raw.t;
    attempt : Yojson.Raw.t Types.presence;
    annotation_id : Yojson.Raw.t Types.presence;
    total_steps : Yojson.Raw.t Types.presence;
    found_count : Yojson.Raw.t Types.presence;
    result_resource_id : Yojson.Raw.t Types.presence;
    annotation_uri : string Types.presence;
    result : Yojson.Raw.t Types.presence;
    durability : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_id = required reader raw "jobId";
        job_type = required reader raw "jobType";
        attempt = optional reader raw "attempt";
        annotation_id = optional reader raw "annotationId";
        total_steps = optional reader raw "totalSteps";
        found_count = optional reader raw "foundCount";
        result_resource_id = optional reader raw "resultResourceId";
        annotation_uri = optional reader string "annotationUri";
        result = optional reader raw "result";
        durability = optional reader raw "durability";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobCompletedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_created_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobCreatedResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_created_result_response = struct
  type t = { job_id : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { job_id = required reader raw "jobId"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobCreatedResultResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_fail_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    resource_id : Yojson.Raw.t;
    job_id : Yojson.Raw.t;
    job_type : Yojson.Raw.t;
    attempt : Yojson.Raw.t Types.presence;
    annotation_id : Yojson.Raw.t Types.presence;
    error : string;
    completed_units : Yojson.Raw.t Types.presence;
    unit_cursors : Yojson.Raw.t Types.presence;
    failure_class : Yojson.Raw.t Types.presence;
    will_retry : bool Types.presence;
    durability : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        resource_id = required reader raw "resourceId";
        job_id = required reader raw "jobId";
        job_type = required reader raw "jobType";
        attempt = optional reader raw "attempt";
        annotation_id = optional reader raw "annotationId";
        error = required reader string "error";
        completed_units = optional reader raw "completedUnits";
        unit_cursors = optional reader raw "unitCursors";
        failure_class = optional reader raw "failureClass";
        will_retry = optional reader bool "willRetry";
        durability = optional reader raw "durability";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobFailCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_checkpoint_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    job_id : Yojson.Raw.t;
    completed_units : Yojson.Raw.t;
    unit_cursors : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        job_id = required reader raw "jobId";
        completed_units = required reader raw "completedUnits";
        unit_cursors = optional reader raw "unitCursors";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobCheckpointCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Unit_cursor = struct
  type t = {
    next : Yojson.Raw.t;
    size : Yojson.Raw.t;
    found : Yojson.Raw.t;
    emitted : Yojson.Raw.t;
    errors : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        next = required reader raw "next";
        size = required reader raw "size";
        found = required reader raw "found";
        emitted = required reader raw "emitted";
        errors = required reader raw "errors";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `UnitCursor ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_declined = struct
  type t = {
    declined : bool;
    reason : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        declined = required reader bool "declined";
        reason = required reader string "reason";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobDeclined ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_failed_payload = struct
  type t = {
    job_id : Yojson.Raw.t;
    job_type : Yojson.Raw.t;
    attempt : Yojson.Raw.t Types.presence;
    annotation_id : Yojson.Raw.t Types.presence;
    error : string;
    failure_class : Yojson.Raw.t Types.presence;
    will_retry : bool Types.presence;
    durability : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_id = required reader raw "jobId";
        job_type = required reader raw "jobType";
        attempt = optional reader raw "attempt";
        annotation_id = optional reader raw "annotationId";
        error = required reader string "error";
        failure_class = optional reader raw "failureClass";
        will_retry = optional reader bool "willRetry";
        durability = optional reader raw "durability";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobFailedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_job_done = struct
  type t = {
    resource_id : Yojson.Raw.t;
    resource_name : string;
    truncated : bool;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        resource_name = required reader string "resourceName";
        truncated = required reader bool "truncated";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldJobDone ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_progress = struct
  type t = {
    percentage : Yojson.Raw.t;
    message : Yojson.Raw.t Types.presence;
    annotation_id : Yojson.Raw.t Types.presence;
    current : Yojson.Raw.t Types.presence;
    processed : Yojson.Raw.t Types.presence;
    total : Yojson.Raw.t Types.presence;
    entities_found : Yojson.Raw.t Types.presence;
    entities_expected : Yojson.Raw.t Types.presence;
    entities_emitted : Yojson.Raw.t Types.presence;
    completed_items : Yojson.Raw.t Types.presence;
    request_params : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        percentage = required reader raw "percentage";
        message = optional reader raw "message";
        annotation_id = optional reader raw "annotationId";
        current = optional reader raw "current";
        processed = optional reader raw "processed";
        total = optional reader raw "total";
        entities_found = optional reader raw "entitiesFound";
        entities_expected = optional reader raw "entitiesExpected";
        entities_emitted = optional reader raw "entitiesEmitted";
        completed_items = optional reader raw "completedItems";
        request_params = optional reader raw "requestParams";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgress ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_progress_analyzing = struct
  type t = { code : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { code = required reader string "code"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressAnalyzing ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_progress_analyzing_tags = struct
  type t = { code : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { code = required reader string "code"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressAnalyzingTags ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_progress_complete_created = struct
  type t = {
    code : string;
    count : Yojson.Raw.t;
    motivation : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = required reader string "code";
        count = required reader raw "count";
        motivation = required reader raw "motivation";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressCompleteCreated ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_progress_complete_generated = struct
  type t = {
    code : string;
    truncated : bool;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = required reader string "code";
        truncated = required reader bool "truncated";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressCompleteGenerated ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_progress_creating_annotations = struct
  type t = {
    code : string;
    count : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = required reader string "code";
        count = required reader raw "count";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressCreatingAnnotations ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_progress_creating_resource = struct
  type t = { code : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { code = required reader string "code"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressCreatingResource ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_progress_creating_tag_annotations = struct
  type t = {
    code : string;
    count : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = required reader string "code";
        count = required reader raw "count";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressCreatingTagAnnotations ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_progress_detecting_entities = struct
  type t = {
    code : string;
    entity_type : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = required reader string "code";
        entity_type = required reader string "entityType";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressDetectingEntities ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_progress_generating_resource = struct
  type t = { code : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { code = required reader string "code"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressGeneratingResource ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_progress_loading = struct
  type t = { code : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { code = required reader string "code"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressLoading ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_job_done = struct
  type t = {
    found : Yojson.Raw.t;
    persisted : Yojson.Raw.t;
    errors : Yojson.Raw.t Types.presence;
    by_category : Yojson.Raw.t Types.presence;
    under_reported_pieces : Yojson.Raw.t Types.presence;
    unchecked_pieces : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        found = required reader raw "found";
        persisted = required reader raw "persisted";
        errors = optional reader raw "errors";
        by_category = optional reader raw "byCategory";
        under_reported_pieces = optional reader raw "underReportedPieces";
        unchecked_pieces = optional reader raw "uncheckedPieces";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkJobDone ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_report_progress_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    resource_id : Yojson.Raw.t;
    job_id : Yojson.Raw.t;
    job_type : Yojson.Raw.t;
    attempt : Yojson.Raw.t Types.presence;
    annotation_id : Yojson.Raw.t Types.presence;
    percentage : Yojson.Raw.t;
    progress : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        resource_id = required reader raw "resourceId";
        job_id = required reader raw "jobId";
        job_type = required reader raw "jobType";
        attempt = optional reader raw "attempt";
        annotation_id = optional reader raw "annotationId";
        percentage = required reader raw "percentage";
        progress = optional reader raw "progress";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobReportProgressCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_start_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    resource_id : Yojson.Raw.t;
    job_id : Yojson.Raw.t;
    job_type : Yojson.Raw.t;
    annotation_id : Yojson.Raw.t Types.presence;
    attempt : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        resource_id = required reader raw "resourceId";
        job_id = required reader raw "jobId";
        job_type = required reader raw "jobType";
        annotation_id = optional reader raw "annotationId";
        attempt = optional reader raw "attempt";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobStartCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_assign_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    job_id : Yojson.Raw.t;
    job_type : Yojson.Raw.t;
    resource_id : Yojson.Raw.t;
    holder : Yojson.Raw.t;
    requester : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        job_id = required reader raw "jobId";
        job_type = required reader raw "jobType";
        resource_id = required reader raw "resourceId";
        holder = required reader raw "holder";
        requester = required reader raw "requester";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobAssignCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_started_payload = struct
  type t = {
    job_id : Yojson.Raw.t;
    job_type : Yojson.Raw.t;
    annotation_id : Yojson.Raw.t Types.presence;
    total_steps : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_id = required reader raw "jobId";
        job_type = required reader raw "jobType";
        annotation_id = optional reader raw "annotationId";
        total_steps = optional reader raw "totalSteps";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobStartedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_assigned_payload = struct
  type t = {
    job_id : Yojson.Raw.t;
    job_type : Yojson.Raw.t;
    resource_id : Yojson.Raw.t;
    holder : Yojson.Raw.t;
    requester : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_id = required reader raw "jobId";
        job_type = required reader raw "jobType";
        resource_id = required reader raw "resourceId";
        holder = required reader raw "holder";
        requester = required reader raw "requester";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobAssignedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Principal_profile_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    name : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        name = required reader string "name";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `PrincipalProfileCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Principal_profiled_payload = struct
  type t = { name : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { name = required reader string "name"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `PrincipalProfiledPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_status_request = struct
  type t = { job_id : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { job_id = required reader raw "jobId"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobStatusRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_status_response = struct
  type t = {
    job_id : Yojson.Raw.t;
    type_ : Yojson.Raw.t;
    status : string;
    user_id : Yojson.Raw.t;
    created : string;
    started_at : string Types.presence;
    completed_at : string Types.presence;
    error : string Types.presence;
    failure_class : Yojson.Raw.t Types.presence;
    progress : Yojson.Raw.t Types.presence;
    result : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_id = required reader raw "jobId";
        type_ = required reader raw "type";
        status = required reader string "status";
        user_id = required reader raw "userId";
        created = required reader string "created";
        started_at = optional reader string "startedAt";
        completed_at = optional reader string "completedAt";
        error = optional reader string "error";
        failure_class = optional reader raw "failureClass";
        progress = optional reader raw "progress";
        result = optional reader raw "result";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobStatusResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_status_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobStatusResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Kb_description = struct
  type t = {
    name : string;
    domain : string;
    git_branch : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        domain = required reader string "domain";
        git_branch = optional reader string "gitBranch";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `KbDescription ] Models.t) =
    project (fields_of (Models.json model))
end

module Http_endpoint = struct
  type t = {
    kind : string;
    host : string;
    port : Yojson.Raw.t;
    protocol : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kind = required reader string "kind";
        host = required reader string "host";
        port = required reader raw "port";
        protocol = required reader string "protocol";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `HttpEndpoint ] Models.t) =
    project (fields_of (Models.json model))
end

module Kb_read = struct
  type t = {
    at : string;
    git_branch : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        at = required reader string "at";
        git_branch = optional reader string "gitBranch";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `KbRead ] Models.t) =
    project (fields_of (Models.json model))
end

module Kb_target = struct
  type t = {
    id : string;
    label : string;
    endpoint : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader string "id";
        label = required reader string "label";
        endpoint = required reader raw "endpoint";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `KbTarget ] Models.t) =
    project (fields_of (Models.json model))
end

module Knowledge_base = struct
  type t = {
    id : string;
    label : string;
    endpoint : Yojson.Raw.t;
    did : string;
    last_read : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader string "id";
        label = required reader string "label";
        endpoint = required reader raw "endpoint";
        did = required reader string "did";
        last_read = optional reader raw "lastRead";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `KnowledgeBase ] Models.t) =
    project (fields_of (Models.json model))
end

module Local_endpoint = struct
  type t = {
    kind : string;
    kb_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kind = required reader string "kind";
        kb_id = required reader string "kbId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LocalEndpoint ] Models.t) =
    project (fields_of (Models.json model))
end

module New_knowledge_base = struct
  type t = {
    label : string;
    endpoint : Yojson.Raw.t;
    did : string;
    last_read : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        label = required reader string "label";
        endpoint = required reader raw "endpoint";
        did = required reader string "did";
        last_read = optional reader raw "lastRead";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `NewKnowledgeBase ] Models.t) =
    project (fields_of (Models.json model))
end

module Knowledge_graph = struct
  type t = {
    nodes : Yojson.Raw.t;
    edges : Yojson.Raw.t;
    truncated : bool Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        nodes = required reader raw "nodes";
        edges = required reader raw "edges";
        truncated = optional reader bool "truncated";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `KnowledgeGraph ] Models.t) =
    project (fields_of (Models.json model))
end

module List_resources_response = struct
  type t = {
    resources : Yojson.Raw.t;
    total : Yojson.Raw.t;
    offset : Yojson.Raw.t;
    limit : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resources = required reader raw "resources";
        total = required reader raw "total";
        offset = required reader raw "offset";
        limit = required reader raw "limit";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ListResourcesResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_archive_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    resource_id : Yojson.Raw.t;
    storage_uri : string Types.presence;
    keep_file : bool Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        resource_id = required reader raw "resourceId";
        storage_uri = optional reader string "storageUri";
        keep_file = optional reader bool "keepFile";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkArchiveCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_create_ok = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `MarkCreateOk ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_create_ok_response = struct
  type t = {
    annotation_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      { annotation_id = required reader raw "annotationId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkCreateOkResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_commit_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    field_roles : Yojson.Raw.t Types.presence;
    job_id : Yojson.Raw.t Types.presence;
    resource_id : Yojson.Raw.t;
    annotations : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        field_roles = optional reader raw "_roles";
        job_id = optional reader raw "jobId";
        resource_id = required reader raw "resourceId";
        annotations = required reader raw "annotations";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkCommitCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_commit_ok = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `MarkCommitOk ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_create_request = struct
  type t = {
    resource_id : Yojson.Raw.t;
    request : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        request = required reader raw "request";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkCreateRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_delete_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    annotation_id : Yojson.Raw.t;
    resource_id : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        annotation_id = required reader raw "annotationId";
        resource_id = optional reader raw "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkDeleteCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_delete_ok = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `MarkDeleteOk ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_requested_event = struct
  type t = {
    source : Yojson.Raw.t;
    selector : Yojson.Raw.t;
    motivation : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        source = required reader raw "source";
        selector = required reader raw "selector";
        motivation = required reader raw "motivation";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkRequestedEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_submit_event = struct
  type t = {
    source : Yojson.Raw.t;
    motivation : Yojson.Raw.t;
    selector : Yojson.Raw.t;
    body : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        source = required reader raw "source";
        motivation = required reader raw "motivation";
        selector = required reader raw "selector";
        body = optional reader raw "body";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkSubmitEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_unarchive_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    resource_id : Yojson.Raw.t;
    storage_uri : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        resource_id = required reader raw "resourceId";
        storage_uri = optional reader string "storageUri";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkUnarchiveCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_update_body_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    annotation_id : Yojson.Raw.t;
    resource_id : Yojson.Raw.t;
    operations : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        annotation_id = required reader raw "annotationId";
        resource_id = required reader raw "resourceId";
        operations = required reader raw "operations";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkUpdateBodyCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_update_entity_types_command = struct
  type t = {
    resource_id : Yojson.Raw.t;
    field_user_id : Yojson.Raw.t Types.presence;
    current_entity_types : Yojson.Raw.t;
    updated_entity_types : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        field_user_id = optional reader raw "_userId";
        current_entity_types = required reader raw "currentEntityTypes";
        updated_entity_types = required reader raw "updatedEntityTypes";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkUpdateEntityTypesCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Match_search_failed = struct
  type t = {
    code : string Types.presence;
    message : string;
    details : string Types.presence;
    reference_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = optional reader string "code";
        message = required reader string "message";
        details = optional reader string "details";
        reference_id = required reader raw "referenceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MatchSearchFailed ] Models.t) =
    project (fields_of (Models.json model))
end

module Match_search_request = struct
  type t = {
    resource_id : Yojson.Raw.t;
    reference_id : Yojson.Raw.t;
    context : Yojson.Raw.t;
    limit : Yojson.Raw.t Types.presence;
    use_semantic_scoring : bool Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        reference_id = required reader raw "referenceId";
        context = required reader raw "context";
        limit = optional reader raw "limit";
        use_semantic_scoring = optional reader bool "useSemanticScoring";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MatchSearchRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Match_search_result = struct
  type t = {
    reference_id : Yojson.Raw.t;
    response : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        reference_id = required reader raw "referenceId";
        response = required reader raw "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MatchSearchResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Match_resources_request = struct
  type t = {
    search : string;
    archived : bool Types.presence;
    entity_type : string Types.presence;
    offset : Yojson.Raw.t Types.presence;
    limit : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        search = required reader string "search";
        archived = optional reader bool "archived";
        entity_type = optional reader string "entityType";
        offset = optional reader raw "offset";
        limit = optional reader raw "limit";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MatchResourcesRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Match_resources_response = struct
  type t = {
    resources : Yojson.Raw.t;
    total : Yojson.Raw.t;
    offset : Yojson.Raw.t;
    limit : Yojson.Raw.t;
    match_kind : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resources = required reader raw "resources";
        total = required reader raw "total";
        offset = required reader raw "offset";
        limit = required reader raw "limit";
        match_kind = required reader string "matchKind";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MatchResourcesResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Match_resources_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `MatchResourcesResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Media_token_request = struct
  type t = { resource_id : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader raw "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MediaTokenRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Media_token_response = struct
  type t = { token : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { token = required reader string "token"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `MediaTokenResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Protected_resource_metadata = struct
  type t = {
    resource : string;
    authorization_servers : Yojson.Raw.t;
    bearer_methods_supported : Yojson.Raw.t;
    resource_name : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource = required reader string "resource";
        authorization_servers = required reader raw "authorization_servers";
        bearer_methods_supported =
          required reader raw "bearer_methods_supported";
        resource_name = optional reader string "resource_name";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ProtectedResourceMetadata ] Models.t) =
    project (fields_of (Models.json model))
end

module Representation = struct
  type t = {
    field_id : string Types.presence;
    field_type : Yojson.Raw.t Types.presence;
    media_type : string;
    storage_uri : string Types.presence;
    filename : string Types.presence;
    byte_size : Yojson.Raw.t Types.presence;
    checksum : string Types.presence;
    encoding : string Types.presence;
    language : string Types.presence;
    width : Yojson.Raw.t Types.presence;
    height : Yojson.Raw.t Types.presence;
    duration : Yojson.Raw.t Types.presence;
    created : string Types.presence;
    modified : string Types.presence;
    conforms_to : Yojson.Raw.t Types.presence;
    tags : Yojson.Raw.t Types.presence;
    rel : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_id = optional reader string "@id";
        field_type = optional reader raw "@type";
        media_type = required reader string "mediaType";
        storage_uri = optional reader string "storageUri";
        filename = optional reader string "filename";
        byte_size = optional reader raw "byteSize";
        checksum = optional reader string "checksum";
        encoding = optional reader string "encoding";
        language = optional reader string "language";
        width = optional reader raw "width";
        height = optional reader raw "height";
        duration = optional reader raw "duration";
        created = optional reader string "created";
        modified = optional reader string "modified";
        conforms_to = optional reader raw "conformsTo";
        tags = optional reader raw "tags";
        rel = optional reader string "rel";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Representation ] Models.t) =
    project (fields_of (Models.json model))
end

module Representation_added_payload = struct
  type t = {
    representation : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      { representation = required reader raw "representation"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RepresentationAddedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Representation_removed_payload = struct
  type t = { checksum : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { checksum = required reader string "checksum"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `RepresentationRemovedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Resource_archived_payload = struct
  type t = {
    reason : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record = { reason = optional reader string "reason"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceArchivedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Resource_cloned_payload = struct
  type t = {
    name : string;
    format : Yojson.Raw.t;
    content_checksum : string;
    content_byte_size : Yojson.Raw.t Types.presence;
    storage_uri : string Types.presence;
    parent_resource_id : Yojson.Raw.t;
    entity_types : Yojson.Raw.t Types.presence;
    language : string Types.presence;
    creator : Yojson.Raw.t Types.presence;
    was_attributed_to : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        format = required reader raw "format";
        content_checksum = required reader string "contentChecksum";
        content_byte_size = optional reader raw "contentByteSize";
        storage_uri = optional reader string "storageUri";
        parent_resource_id = required reader raw "parentResourceId";
        entity_types = optional reader raw "entityTypes";
        language = optional reader string "language";
        creator = optional reader raw "creator";
        was_attributed_to = optional reader raw "wasAttributedTo";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceClonedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Resource_created_payload = struct
  type t = {
    name : string;
    format : Yojson.Raw.t;
    content_checksum : string;
    content_byte_size : Yojson.Raw.t Types.presence;
    entity_types : Yojson.Raw.t Types.presence;
    storage_uri : string Types.presence;
    language : string Types.presence;
    is_draft : bool Types.presence;
    job_id : Yojson.Raw.t Types.presence;
    generated_from : Yojson.Raw.t Types.presence;
    generation_prompt : string Types.presence;
    generator : Yojson.Raw.t Types.presence;
    creator : Yojson.Raw.t Types.presence;
    was_attributed_to : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        format = required reader raw "format";
        content_checksum = required reader string "contentChecksum";
        content_byte_size = optional reader raw "contentByteSize";
        entity_types = optional reader raw "entityTypes";
        storage_uri = optional reader string "storageUri";
        language = optional reader string "language";
        is_draft = optional reader bool "isDraft";
        job_id = optional reader raw "jobId";
        generated_from = optional reader raw "generatedFrom";
        generation_prompt = optional reader string "generationPrompt";
        generator = optional reader raw "generator";
        creator = optional reader raw "creator";
        was_attributed_to = optional reader raw "wasAttributedTo";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceCreatedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Resource_descriptor = struct
  type t = {
    field_context : Yojson.Raw.t;
    field_id : Yojson.Raw.t;
    field_type : Yojson.Raw.t Types.presence;
    name : string;
    description : string Types.presence;
    identifier : Yojson.Raw.t Types.presence;
    about : Yojson.Raw.t Types.presence;
    same_as : Yojson.Raw.t Types.presence;
    is_part_of : Yojson.Raw.t Types.presence;
    has_part : Yojson.Raw.t Types.presence;
    license : string Types.presence;
    version : string Types.presence;
    date_created : string Types.presence;
    date_modified : string Types.presence;
    was_derived_from : Yojson.Raw.t Types.presence;
    was_attributed_to : Yojson.Raw.t Types.presence;
    generator : Yojson.Raw.t Types.presence;
    conforms_to : Yojson.Raw.t Types.presence;
    available_formats : Yojson.Raw.t Types.presence;
    representations : Yojson.Raw.t;
    archived : bool Types.presence;
    entity_types : Yojson.Raw.t Types.presence;
    is_draft : bool Types.presence;
    source_annotation_id : Yojson.Raw.t Types.presence;
    source_resource_id : Yojson.Raw.t Types.presence;
    originated_from : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_context = required reader raw "@context";
        field_id = required reader raw "@id";
        field_type = optional reader raw "@type";
        name = required reader string "name";
        description = optional reader string "description";
        identifier = optional reader raw "identifier";
        about = optional reader raw "about";
        same_as = optional reader raw "sameAs";
        is_part_of = optional reader raw "isPartOf";
        has_part = optional reader raw "hasPart";
        license = optional reader string "license";
        version = optional reader string "version";
        date_created = optional reader string "dateCreated";
        date_modified = optional reader string "dateModified";
        was_derived_from = optional reader raw "wasDerivedFrom";
        was_attributed_to = optional reader raw "wasAttributedTo";
        generator = optional reader raw "generator";
        conforms_to = optional reader raw "conformsTo";
        available_formats = optional reader raw "availableFormats";
        representations = required reader raw "representations";
        archived = optional reader bool "archived";
        entity_types = optional reader raw "entityTypes";
        is_draft = optional reader bool "isDraft";
        source_annotation_id = optional reader raw "sourceAnnotationId";
        source_resource_id = optional reader raw "sourceResourceId";
        originated_from = optional reader string "originatedFrom";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceDescriptor ] Models.t) =
    project (fields_of (Models.json model))
end

module Resource_moved_payload = struct
  type t = {
    from_uri : string;
    to_uri : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        from_uri = required reader string "fromUri";
        to_uri = required reader string "toUri";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceMovedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Resource_updated_payload = struct
  type t = {
    content_checksum : string;
    content_byte_size : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        content_checksum = required reader string "contentChecksum";
        content_byte_size = optional reader raw "contentByteSize";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceUpdatedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Scored_resource = struct
  type t = {
    field_context : Yojson.Raw.t;
    field_id : Yojson.Raw.t;
    field_type : Yojson.Raw.t Types.presence;
    name : string;
    description : string Types.presence;
    identifier : Yojson.Raw.t Types.presence;
    about : Yojson.Raw.t Types.presence;
    same_as : Yojson.Raw.t Types.presence;
    is_part_of : Yojson.Raw.t Types.presence;
    has_part : Yojson.Raw.t Types.presence;
    license : string Types.presence;
    version : string Types.presence;
    date_created : string Types.presence;
    date_modified : string Types.presence;
    was_derived_from : Yojson.Raw.t Types.presence;
    was_attributed_to : Yojson.Raw.t Types.presence;
    generator : Yojson.Raw.t Types.presence;
    conforms_to : Yojson.Raw.t Types.presence;
    available_formats : Yojson.Raw.t Types.presence;
    representations : Yojson.Raw.t;
    archived : bool Types.presence;
    entity_types : Yojson.Raw.t Types.presence;
    is_draft : bool Types.presence;
    source_annotation_id : Yojson.Raw.t Types.presence;
    source_resource_id : Yojson.Raw.t Types.presence;
    originated_from : string Types.presence;
    score : Yojson.Raw.t Types.presence;
    match_reason : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_context = required reader raw "@context";
        field_id = required reader raw "@id";
        field_type = optional reader raw "@type";
        name = required reader string "name";
        description = optional reader string "description";
        identifier = optional reader raw "identifier";
        about = optional reader raw "about";
        same_as = optional reader raw "sameAs";
        is_part_of = optional reader raw "isPartOf";
        has_part = optional reader raw "hasPart";
        license = optional reader string "license";
        version = optional reader string "version";
        date_created = optional reader string "dateCreated";
        date_modified = optional reader string "dateModified";
        was_derived_from = optional reader raw "wasDerivedFrom";
        was_attributed_to = optional reader raw "wasAttributedTo";
        generator = optional reader raw "generator";
        conforms_to = optional reader raw "conformsTo";
        available_formats = optional reader raw "availableFormats";
        representations = required reader raw "representations";
        archived = optional reader bool "archived";
        entity_types = optional reader raw "entityTypes";
        is_draft = optional reader bool "isDraft";
        source_annotation_id = optional reader raw "sourceAnnotationId";
        source_resource_id = optional reader raw "sourceResourceId";
        originated_from = optional reader string "originatedFrom";
        score = optional reader raw "score";
        match_reason = optional reader string "matchReason";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ScoredResource ] Models.t) =
    project (fields_of (Models.json model))
end

module Semantic_match = struct
  type t = {
    text : string;
    resource_id : Yojson.Raw.t;
    resource_name : string;
    annotation_id : Yojson.Raw.t Types.presence;
    score : Yojson.Raw.t;
    entity_types : Yojson.Raw.t Types.presence;
    machine_read : bool Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        text = required reader string "text";
        resource_id = required reader raw "resourceId";
        resource_name = required reader string "resourceName";
        annotation_id = optional reader raw "annotationId";
        score = required reader raw "score";
        entity_types = optional reader raw "entityTypes";
        machine_read = optional reader bool "machineRead";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SemanticMatch ] Models.t) =
    project (fields_of (Models.json model))
end

module Session_joined_event = struct
  type t = {
    participant : Yojson.Raw.t;
    connection_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        participant = required reader raw "participant";
        connection_id = required reader string "connectionId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SessionJoinedEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Session_left_event = struct
  type t = {
    participant : Yojson.Raw.t;
    connection_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        participant = required reader raw "participant";
        connection_id = required reader string "connectionId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SessionLeftEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Settings_hover_delay_changed_event = struct
  type t = {
    hover_delay_ms : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      { hover_delay_ms = required reader raw "hoverDelayMs"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsHoverDelayChangedEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Settings_locale_changed_event = struct
  type t = { locale : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { locale = required reader string "locale"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsLocaleChangedEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Settings_theme_changed_event = struct
  type t = { theme : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { theme = required reader string "theme"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsThemeChangedEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Specific_resource = struct
  type t = {
    type_ : string;
    source : Yojson.Raw.t;
    purpose : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader string "type";
        source = required reader raw "source";
        purpose = optional reader raw "purpose";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SpecificResource ] Models.t) =
    project (fields_of (Models.json model))
end

module Status_response = struct
  type t = {
    status : string;
    version : string;
    features : Yojson.Raw.t;
    message : string;
    authenticated_as : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader string "status";
        version = required reader string "version";
        features = required reader raw "features";
        message = required reader string "message";
        authenticated_as = optional reader string "authenticatedAs";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StatusResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Stored_event_response = struct
  type t = {
    id : string;
    type_ : string;
    timestamp : string;
    user_id : Yojson.Raw.t;
    resource_id : Yojson.Raw.t Types.presence;
    version : Yojson.Raw.t;
    payload : Yojson.Raw.t;
    metadata : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader string "id";
        type_ = required reader string "type";
        timestamp = required reader string "timestamp";
        user_id = required reader raw "userId";
        resource_id = optional reader raw "resourceId";
        version = required reader raw "version";
        payload = required reader raw "payload";
        metadata = required reader raw "metadata";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StoredEventResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Svg_selector = struct
  type t = {
    type_ : string;
    value : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader string "type";
        value = required reader string "value";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SvgSelector ] Models.t) =
    project (fields_of (Models.json model))
end

module Tag_category = struct
  type t = {
    name : string;
    description : string;
    examples : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        description = required reader string "description";
        examples = required reader raw "examples";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `TagCategory ] Models.t) =
    project (fields_of (Models.json model))
end

module Tag_schema = struct
  type t = {
    id : string;
    name : string;
    description : string;
    domain : string;
    tags : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader string "id";
        name = required reader string "name";
        description = required reader string "description";
        domain = required reader string "domain";
        tags = required reader raw "tags";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `TagSchema ] Models.t) =
    project (fields_of (Models.json model))
end

module Tag_schema_added_payload = struct
  type t = { schema : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { schema = required reader raw "schema"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `TagSchemaAddedPayload ] Models.t) =
    project (fields_of (Models.json model))
end

module Text_position_selector = struct
  type t = {
    type_ : string;
    start : Yojson.Raw.t;
    end_ : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader string "type";
        start = required reader raw "start";
        end_ = required reader raw "end";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `TextPositionSelector ] Models.t) =
    project (fields_of (Models.json model))
end

module Text_quote_selector = struct
  type t = {
    type_ : string;
    exact : string;
    prefix : string Types.presence;
    suffix : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader string "type";
        exact = required reader string "exact";
        prefix = optional reader string "prefix";
        suffix = optional reader string "suffix";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `TextQuoteSelector ] Models.t) =
    project (fields_of (Models.json model))
end

module Textual_body = struct
  type t = {
    type_ : string;
    value : string;
    purpose : Yojson.Raw.t Types.presence;
    format : string Types.presence;
    language : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader string "type";
        value = required reader string "value";
        purpose = optional reader raw "purpose";
        format = optional reader string "format";
        language = optional reader string "language";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `TextualBody ] Models.t) =
    project (fields_of (Models.json model))
end

module Update_annotation_body_request = struct
  type t = {
    resource_id : Yojson.Raw.t;
    operations : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        operations = required reader raw "operations";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `UpdateAnnotationBodyRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module User_response = struct
  type t = {
    did : Yojson.Raw.t;
    email : Yojson.Raw.t;
    name : Yojson.Raw.t;
    image : Yojson.Raw.t;
    domain : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        did = required reader raw "did";
        email = required reader raw "email";
        name = required reader raw "name";
        image = required reader raw "image";
        domain = required reader string "domain";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `UserResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Smelt_rebuild_anchors_command = struct
  type t = {
    resource_id : Yojson.Raw.t Types.presence;
    field_user_id : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = optional reader raw "resourceId";
        field_user_id = optional reader raw "_userId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SmeltRebuildAnchorsCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Weave_rebuild_command = struct
  type t = {
    resource_id : Yojson.Raw.t Types.presence;
    field_user_id : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = optional reader raw "resourceId";
        field_user_id = optional reader raw "_userId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WeaveRebuildCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_clone_create_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    token : string;
    name : string;
    storage_uri : string;
    content_checksum : string;
    byte_size : Yojson.Raw.t;
    format : Yojson.Raw.t;
    archive_original : bool Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        token = required reader string "token";
        name = required reader string "name";
        storage_uri = required reader string "storageUri";
        content_checksum = required reader string "contentChecksum";
        byte_size = required reader raw "byteSize";
        format = required reader raw "format";
        archive_original = optional reader bool "archiveOriginal";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldCloneCreateCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_clone_created = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `YieldCloneCreated ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_clone_resource_request = struct
  type t = { token : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { token = required reader string "token"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `YieldCloneResourceRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_clone_token_request = struct
  type t = { resource_id : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader raw "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldCloneTokenRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_create_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    field_roles : Yojson.Raw.t Types.presence;
    job_id : Yojson.Raw.t Types.presence;
    name : string;
    storage_uri : string;
    content_checksum : string;
    byte_size : Yojson.Raw.t;
    format : Yojson.Raw.t;
    language : string Types.presence;
    entity_types : Yojson.Raw.t Types.presence;
    is_draft : bool Types.presence;
    generated_from : Yojson.Raw.t Types.presence;
    generation_prompt : string Types.presence;
    generator : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        field_roles = optional reader raw "_roles";
        job_id = optional reader raw "jobId";
        name = required reader string "name";
        storage_uri = required reader string "storageUri";
        content_checksum = required reader string "contentChecksum";
        byte_size = required reader raw "byteSize";
        format = required reader raw "format";
        language = optional reader string "language";
        entity_types = optional reader raw "entityTypes";
        is_draft = optional reader bool "isDraft";
        generated_from = optional reader raw "generatedFrom";
        generation_prompt = optional reader string "generationPrompt";
        generator = optional reader raw "generator";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldCreateCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_clone_persist_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    name : string;
    storage_uri : string;
    content_checksum : string;
    byte_size : Yojson.Raw.t;
    format : Yojson.Raw.t;
    language : string Types.presence;
    entity_types : Yojson.Raw.t Types.presence;
    parent_resource_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        name = required reader string "name";
        storage_uri = required reader string "storageUri";
        content_checksum = required reader string "contentChecksum";
        byte_size = required reader raw "byteSize";
        format = required reader raw "format";
        language = optional reader string "language";
        entity_types = optional reader raw "entityTypes";
        parent_resource_id = required reader raw "parentResourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldClonePersistCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_create_ok = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `YieldCreateOk ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_clone_persist_ok = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `YieldClonePersistOk ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_update_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    resource_id : Yojson.Raw.t;
    storage_uri : string;
    content_checksum : string;
    byte_size : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        resource_id = required reader raw "resourceId";
        storage_uri = required reader string "storageUri";
        content_checksum = required reader string "contentChecksum";
        byte_size = required reader raw "byteSize";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldUpdateCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_update_ok = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `YieldUpdateOk ] Models.t) =
    project (fields_of (Models.json model))
end

module Yielded_resource = struct
  type t = { resource_id : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader raw "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldedResource ] Models.t) =
    project (fields_of (Models.json model))
end

module Bus_event_message = struct
  type t = {
    event : string;
    id : Yojson.Raw.t;
    data : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        event = required reader string "event";
        id = required reader raw "id";
        data = required reader raw "data";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BusEventMessage ] Models.t) =
    project (fields_of (Models.json model))
end

module Bus_frame = struct
  type t = {
    channel : string;
    correlation_id : string Types.presence;
    payload : Yojson.Raw.t;
    scope : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        channel = required reader string "channel";
        correlation_id = optional reader string "correlationId";
        payload = required reader raw "payload";
        scope = optional reader raw "scope";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BusFrame ] Models.t) =
    project (fields_of (Models.json model))
end

module Bus_ping_message = struct
  type t = {
    event : string;
    data : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        event = required reader string "event";
        data = required reader string "data";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BusPingMessage ] Models.t) =
    project (fields_of (Models.json model))
end

module Bus_resume_gap = struct
  type t = {
    scope : Yojson.Raw.t;
    last_seen_id : string;
    reason : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        scope = required reader raw "scope";
        last_seen_id = required reader string "lastSeenId";
        reason = required reader string "reason";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BusResumeGap ] Models.t) =
    project (fields_of (Models.json model))
end

module Kb_identity = struct
  type t = {
    name : string;
    domain : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        domain = required reader string "domain";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `KbIdentity ] Models.t) =
    project (fields_of (Models.json model))
end

module Resource_upload = struct
  type t = {
    name : string;
    file : string;
    format : string;
    storage_uri : string;
    language : string Types.presence;
    entity_types : string Types.presence;
    source_annotation_id : Yojson.Raw.t Types.presence;
    source_resource_id : Yojson.Raw.t Types.presence;
    generation_prompt : string Types.presence;
    generator : string Types.presence;
    job_id : Yojson.Raw.t Types.presence;
    is_draft : string Types.presence;
    clone_token : string Types.presence;
    archive_original : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        file = required reader string "file";
        format = required reader string "format";
        storage_uri = required reader string "storageUri";
        language = optional reader string "language";
        entity_types = optional reader string "entityTypes";
        source_annotation_id = optional reader raw "sourceAnnotationId";
        source_resource_id = optional reader raw "sourceResourceId";
        generation_prompt = optional reader string "generationPrompt";
        generator = optional reader string "generator";
        job_id = optional reader raw "jobId";
        is_draft = optional reader string "isDraft";
        clone_token = optional reader string "cloneToken";
        archive_original = optional reader string "archiveOriginal";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceUpload ] Models.t) =
    project (fields_of (Models.json model))
end

module Limit_refusal = struct
  type t = {
    error : string;
    code : Yojson.Raw.t;
    hint : string Types.presence;
    details : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        error = required reader string "error";
        code = required reader raw "code";
        hint = optional reader string "hint";
        details = optional reader raw "details";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LimitRefusal ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_metadata = struct
  type t = {
    id : Yojson.Raw.t;
    type_ : Yojson.Raw.t;
    user_id : Yojson.Raw.t;
    created : string;
    retry_count : Yojson.Raw.t;
    max_retries : Yojson.Raw.t;
    completed_units : Yojson.Raw.t Types.presence;
    unit_cursors : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader raw "id";
        type_ = required reader raw "type";
        user_id = required reader raw "userId";
        created = required reader string "created";
        retry_count = required reader raw "retryCount";
        max_retries = required reader raw "maxRetries";
        completed_units = optional reader raw "completedUnits";
        unit_cursors = optional reader raw "unitCursors";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobMetadata ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_params = struct
  type t = {
    resource_id : Yojson.Raw.t;
    schema : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        schema = optional reader raw "schema";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Highlighting_job_params = struct
  type t = {
    motivation : string;
    instructions : string Types.presence;
    density : Yojson.Raw.t Types.presence;
    source_language : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        motivation = required reader string "motivation";
        instructions = optional reader string "instructions";
        density = optional reader raw "density";
        source_language = optional reader string "sourceLanguage";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `HighlightingJobParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Commenting_job_params = struct
  type t = {
    motivation : string;
    instructions : string Types.presence;
    tone : string Types.presence;
    density : Yojson.Raw.t Types.presence;
    language : string Types.presence;
    source_language : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        motivation = required reader string "motivation";
        instructions = optional reader string "instructions";
        tone = optional reader string "tone";
        density = optional reader raw "density";
        language = optional reader string "language";
        source_language = optional reader string "sourceLanguage";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `CommentingJobParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Assessing_job_params = struct
  type t = {
    motivation : string;
    instructions : string Types.presence;
    tone : string Types.presence;
    density : Yojson.Raw.t Types.presence;
    language : string Types.presence;
    source_language : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        motivation = required reader string "motivation";
        instructions = optional reader string "instructions";
        tone = optional reader string "tone";
        density = optional reader raw "density";
        language = optional reader string "language";
        source_language = optional reader string "sourceLanguage";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AssessingJobParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Linking_job_params = struct
  type t = {
    motivation : string;
    entity_types : Yojson.Raw.t;
    include_descriptive_references : bool Types.presence;
    language : string Types.presence;
    source_language : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        motivation = required reader string "motivation";
        entity_types = required reader raw "entityTypes";
        include_descriptive_references =
          optional reader bool "includeDescriptiveReferences";
        language = optional reader string "language";
        source_language = optional reader string "sourceLanguage";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LinkingJobParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Tagging_job_params = struct
  type t = {
    motivation : string;
    schema_id : string;
    categories : Yojson.Raw.t;
    language : string Types.presence;
    source_language : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        motivation = required reader string "motivation";
        schema_id = required reader string "schemaId";
        categories = required reader raw "categories";
        language = optional reader string "language";
        source_language = optional reader string "sourceLanguage";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `TaggingJobParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Generation_job_request = struct
  type t = {
    title : string;
    storage_uri : string;
    prompt : string Types.presence;
    entity_types : Yojson.Raw.t Types.presence;
    language : string Types.presence;
    source_language : string Types.presence;
    temperature : Yojson.Raw.t Types.presence;
    max_tokens : Yojson.Raw.t Types.presence;
    output_media_type : Yojson.Raw.t Types.presence;
    task : string Types.presence;
    structure : string Types.presence;
    cite : bool Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        title = required reader string "title";
        storage_uri = required reader string "storageUri";
        prompt = optional reader string "prompt";
        entity_types = optional reader raw "entityTypes";
        language = optional reader string "language";
        source_language = optional reader string "sourceLanguage";
        temperature = optional reader raw "temperature";
        max_tokens = optional reader raw "maxTokens";
        output_media_type = optional reader raw "outputMediaType";
        task = optional reader string "task";
        structure = optional reader string "structure";
        cite = optional reader bool "cite";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GenerationJobRequest ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_job_create_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    field_roles : Yojson.Raw.t Types.presence;
    job_type : string;
    resource_id : Yojson.Raw.t;
    params : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        field_roles = optional reader raw "_roles";
        job_type = required reader string "jobType";
        resource_id = required reader raw "resourceId";
        params = required reader raw "params";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkJobCreateCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_job_create_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    field_roles : Yojson.Raw.t Types.presence;
    job_type : string;
    params : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        field_roles = optional reader raw "_roles";
        job_type = required reader string "jobType";
        params = required reader raw "params";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldJobCreateCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_job_queued_event = struct
  type t = {
    job_id : Yojson.Raw.t;
    job_type : string;
    resource_id : Yojson.Raw.t;
    user_id : Yojson.Raw.t;
    params : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_id = required reader raw "jobId";
        job_type = required reader string "jobType";
        resource_id = required reader raw "resourceId";
        user_id = required reader raw "userId";
        params = required reader raw "params";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkJobQueuedEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_job_queued_event = struct
  type t = {
    job_id : Yojson.Raw.t;
    job_type : string;
    resource_id : Yojson.Raw.t;
    user_id : Yojson.Raw.t;
    params : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_id = required reader raw "jobId";
        job_type = required reader string "jobType";
        resource_id = required reader raw "resourceId";
        user_id = required reader raw "userId";
        params = required reader raw "params";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldJobQueuedEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_job_complete_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    resource_id : Yojson.Raw.t;
    job_id : Yojson.Raw.t;
    job_type : string;
    attempt : Yojson.Raw.t Types.presence;
    result : Yojson.Raw.t Types.presence;
    durability : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        resource_id = required reader raw "resourceId";
        job_id = required reader raw "jobId";
        job_type = required reader string "jobType";
        attempt = optional reader raw "attempt";
        result = optional reader raw "result";
        durability = optional reader raw "durability";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkJobCompleteCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_job_complete_command = struct
  type t = {
    field_user_id : Yojson.Raw.t Types.presence;
    resource_id : Yojson.Raw.t;
    job_id : Yojson.Raw.t;
    job_type : string;
    attempt : Yojson.Raw.t Types.presence;
    annotation_id : Yojson.Raw.t Types.presence;
    result : Yojson.Raw.t Types.presence;
    durability : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = optional reader raw "_userId";
        resource_id = required reader raw "resourceId";
        job_id = required reader raw "jobId";
        job_type = required reader string "jobType";
        attempt = optional reader raw "attempt";
        annotation_id = optional reader raw "annotationId";
        result = optional reader raw "result";
        durability = optional reader raw "durability";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldJobCompleteCommand ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_job_filter = struct
  type t = {
    job_type : string;
    params : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_type = required reader string "jobType";
        params = required reader raw "params";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkJobFilter ] Models.t) =
    project (fields_of (Models.json model))
end

module Yield_job_filter = struct
  type t = { job_type : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { job_type = required reader string "jobType"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `YieldJobFilter ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_pending = struct
  type t = {
    status : string;
    metadata : Yojson.Raw.t;
    params : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader string "status";
        metadata = required reader raw "metadata";
        params = required reader raw "params";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobPending ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_running = struct
  type t = {
    status : string;
    metadata : Yojson.Raw.t;
    params : Yojson.Raw.t;
    started_at : string;
    progress : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader string "status";
        metadata = required reader raw "metadata";
        params = required reader raw "params";
        started_at = required reader string "startedAt";
        progress = required reader raw "progress";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobRunning ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_complete = struct
  type t = {
    status : string;
    metadata : Yojson.Raw.t;
    params : Yojson.Raw.t;
    started_at : string;
    completed_at : string;
    result : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader string "status";
        metadata = required reader raw "metadata";
        params = required reader raw "params";
        started_at = required reader string "startedAt";
        completed_at = required reader string "completedAt";
        result = required reader raw "result";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobComplete ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_failed = struct
  type t = {
    status : string;
    metadata : Yojson.Raw.t;
    params : Yojson.Raw.t;
    started_at : string Types.presence;
    completed_at : string;
    error : string;
    failure_class : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader string "status";
        metadata = required reader raw "metadata";
        params = required reader raw "params";
        started_at = optional reader string "startedAt";
        completed_at = required reader string "completedAt";
        error = required reader string "error";
        failure_class = optional reader raw "failureClass";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobFailed ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_cancelled = struct
  type t = {
    status : string;
    metadata : Yojson.Raw.t;
    params : Yojson.Raw.t;
    started_at : string Types.presence;
    completed_at : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader string "status";
        metadata = required reader raw "metadata";
        params = required reader raw "params";
        started_at = optional reader string "startedAt";
        completed_at = required reader string "completedAt";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobCancelled ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_record = struct
  type t = {
    job : Yojson.Raw.t;
    last_progress_at : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job = required reader raw "job";
        last_progress_at = required reader string "lastProgressAt";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobRecord ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_claimed_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobClaimedResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Service_identity = struct
  type t = { issuer : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { issuer = required reader string "issuer"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceIdentity ] Models.t) =
    project (fields_of (Models.json model))
end

module Service_address = struct
  type t = {
    host : string;
    port : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        host = required reader string "host";
        port = required reader raw "port";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceAddress ] Models.t) =
    project (fields_of (Models.json model))
end

module Resource_annotations = struct
  type t = {
    resource_id : Yojson.Raw.t;
    annotations : Yojson.Raw.t;
    version : Yojson.Raw.t;
    updated_at : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        annotations = required reader raw "annotations";
        version = required reader raw "version";
        updated_at = required reader string "updatedAt";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceAnnotations ] Models.t) =
    project (fields_of (Models.json model))
end

module Resource_view = struct
  type t = {
    resource : Yojson.Raw.t;
    annotations : Yojson.Raw.t;
    last_sequence : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource = required reader raw "resource";
        annotations = required reader raw "annotations";
        last_sequence = required reader raw "lastSequence";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceView ] Models.t) =
    project (fields_of (Models.json model))
end

module Entity_types_projection = struct
  type t = { entity_types : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { entity_types = required reader raw "entityTypes"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `EntityTypesProjection ] Models.t) =
    project (fields_of (Models.json model))
end

module Tag_schemas_projection = struct
  type t = { tag_schemas : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { tag_schemas = required reader raw "tagSchemas"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `TagSchemasProjection ] Models.t) =
    project (fields_of (Models.json model))
end

module Profiles_projection = struct
  type t = { profiles : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { profiles = required reader raw "profiles"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `ProfilesProjection ] Models.t) =
    project (fields_of (Models.json model))
end

module Profile = struct
  type t = {
    name : string;
    since : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        since = required reader string "since";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Profile ] Models.t) =
    project (fields_of (Models.json model))
end

module Storage_uri_entry = struct
  type t = {
    uri : string;
    resource_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        uri = required reader string "uri";
        resource_id = required reader raw "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StorageUriEntry ] Models.t) =
    project (fields_of (Models.json model))
end

module Archivist_engines = struct
  type t = {
    jobs : Yojson.Raw.t;
    actors : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        jobs = required reader raw "jobs";
        actors = required reader raw "actors";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ArchivistEngines ] Models.t) =
    project (fields_of (Models.json model))
end

module Engine = struct
  type t = {
    provider : string;
    model : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        provider = required reader string "provider";
        model = required reader string "model";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Engine ] Models.t) =
    project (fields_of (Models.json model))
end

module Gather_failed = struct
  type t = {
    code : string Types.presence;
    message : string;
    details : string Types.presence;
    annotation_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = optional reader string "code";
        message = required reader string "message";
        details = optional reader string "details";
        annotation_id = required reader raw "annotationId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherFailed ] Models.t) =
    project (fields_of (Models.json model))
end

module Gather_resource_failed = struct
  type t = {
    code : string Types.presence;
    message : string;
    details : string Types.presence;
    resource_id : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = optional reader string "code";
        message = required reader string "message";
        details = optional reader string "details";
        resource_id = required reader raw "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherResourceFailed ] Models.t) =
    project (fields_of (Models.json model))
end

module Browse_directory_failed = struct
  type t = {
    code : string Types.presence;
    message : string;
    details : string Types.presence;
    path : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = optional reader string "code";
        message = required reader string "message";
        details = optional reader string "details";
        path = required reader string "path";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseDirectoryFailed ] Models.t) =
    project (fields_of (Models.json model))
end

module Mark_delegate_timeout_event = struct
  type t = {
    resource_id : Yojson.Raw.t;
    motivation : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        motivation = required reader raw "motivation";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkDelegateTimeoutEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Resource_error_event = struct
  type t = {
    resource_id : Yojson.Raw.t;
    message : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        message = required reader string "message";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceErrorEvent ] Models.t) =
    project (fields_of (Models.json model))
end

module Job_cancel_result = struct
  type t = { cancelled : bool; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { cancelled = required reader bool "cancelled"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobCancelResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Weave_applied = struct
  type t = {
    resource_id : Yojson.Raw.t;
    sequence_number : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        sequence_number = required reader raw "sequenceNumber";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WeaveApplied ] Models.t) =
    project (fields_of (Models.json model))
end

module Smelt_settled = struct
  type t = {
    resource_id : Yojson.Raw.t;
    content_checksum : string;
    outcome : string;
    reason : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        content_checksum = required reader string "contentChecksum";
        outcome = required reader string "outcome";
        reason = optional reader string "reason";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SmeltSettled ] Models.t) =
    project (fields_of (Models.json model))
end

module Anchored_text_declined_entry = struct
  type t = {
    v : Yojson.Raw.t;
    stamp : string;
    declined : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        v = required reader raw "v";
        stamp = required reader string "stamp";
        declined = required reader raw "declined";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnchoredTextDeclinedEntry ] Models.t) =
    project (fields_of (Models.json model))
end

module Anchored_text_entries = struct
  type t = { checksums : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { checksums = required reader raw "checksums"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `AnchoredTextEntries ] Models.t) =
    project (fields_of (Models.json model))
end

module Anchored_text_extracted_entry = struct
  type t = {
    v : Yojson.Raw.t;
    stamp : string;
    text : string;
    lines : Yojson.Raw.t;
    method_ : Yojson.Raw.t;
    pdf_class : Yojson.Raw.t Types.presence;
    ocr_confidence : Yojson.Raw.t Types.presence;
    unread_pages : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        v = required reader raw "v";
        stamp = required reader string "stamp";
        text = required reader string "text";
        lines = required reader raw "lines";
        method_ = required reader raw "method";
        pdf_class = optional reader raw "pdfClass";
        ocr_confidence = optional reader raw "ocrConfidence";
        unread_pages = optional reader raw "unreadPages";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnchoredTextExtractedEntry ] Models.t) =
    project (fields_of (Models.json model))
end

module Anchored_text_stamp = struct
  type t = { stamp : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { stamp = required reader string "stamp"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `AnchoredTextStamp ] Models.t) =
    project (fields_of (Models.json model))
end

module Anchored_text_write = struct
  type t = {
    content_checksum : string;
    entry : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        content_checksum = required reader string "contentChecksum";
        entry = required reader raw "entry";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnchoredTextWrite ] Models.t) =
    project (fields_of (Models.json model))
end

module Archivist_config = struct
  type t = {
    gateway_url : string;
    identity : Yojson.Raw.t;
    root : string;
    state_home : string;
    anchored_text_dir : string;
    engines : Yojson.Raw.t;
    port : Yojson.Raw.t;
    skip_rebuild : bool;
    staging : Yojson.Raw.t;
    log_level : Yojson.Raw.t;
    log_format : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        gateway_url = required reader string "gatewayUrl";
        identity = required reader raw "identity";
        root = required reader string "root";
        state_home = required reader string "stateHome";
        anchored_text_dir = required reader string "anchoredTextDir";
        engines = required reader raw "engines";
        port = required reader raw "port";
        skip_rebuild = required reader bool "skipRebuild";
        staging = required reader raw "staging";
        log_level = required reader raw "logLevel";
        log_format = required reader raw "logFormat";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ArchivistConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Archivist_events_response = struct
  type t = {
    events : Yojson.Raw.t;
    last_sequence : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        events = required reader raw "events";
        last_sequence = required reader raw "lastSequence";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ArchivistEventsResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Archivist_health = struct
  type t = {
    status : string;
    actors : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader string "status";
        actors = required reader raw "actors";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ArchivistHealth ] Models.t) =
    project (fields_of (Models.json model))
end

module Archivist_stream = struct
  type t = {
    resource_id : Yojson.Raw.t;
    last_sequence : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader raw "resourceId";
        last_sequence = required reader raw "lastSequence";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ArchivistStream ] Models.t) =
    project (fields_of (Models.json model))
end

module Archivist_streams_response = struct
  type t = { streams : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { streams = required reader raw "streams"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `ArchivistStreamsResponse ] Models.t) =
    project (fields_of (Models.json model))
end

module Representation_not_found = struct
  type t = {
    error : string;
    code : Yojson.Raw.t;
    hint : string Types.presence;
    details : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        error = required reader string "error";
        code = required reader raw "code";
        hint = optional reader string "hint";
        details = optional reader raw "details";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RepresentationNotFound ] Models.t) =
    project (fields_of (Models.json model))
end

module Conformance_bus_fetch = struct
  type t = {
    fetch : string;
    payload : Yojson.Raw.t Types.presence;
    as_ : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        fetch = required reader string "fetch";
        payload = optional reader raw "payload";
        as_ = required reader string "as";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ConformanceBusFetch ] Models.t) =
    project (fields_of (Models.json model))
end

module Conformance_case = struct
  type t = {
    about : string;
    source : string;
    planes : Yojson.Raw.t Types.presence;
    tier : string Types.presence;
    telemetry : bool Types.presence;
    steps : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        about = required reader string "about";
        source = required reader string "source";
        planes = optional reader raw "planes";
        tier = optional reader string "tier";
        telemetry = optional reader bool "telemetry";
        steps = required reader raw "steps";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ConformanceCase ] Models.t) =
    project (fields_of (Models.json model))
end

module Conformance_failure = struct
  type t = {
    code : string Types.presence;
    status : Yojson.Raw.t Types.presence;
    failure_class : Yojson.Raw.t Types.presence;
    detail : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = optional reader string "code";
        status = optional reader raw "status";
        failure_class = optional reader raw "failureClass";
        detail = required reader string "detail";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ConformanceFailure ] Models.t) =
    project (fields_of (Models.json model))
end

module Conformance_http_fetch = struct
  type t = {
    fetch : string;
    params : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        fetch = required reader string "fetch";
        params = optional reader raw "params";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ConformanceHttpFetch ] Models.t) =
    project (fields_of (Models.json model))
end

module Conformance_implementations = struct
  type t = {
    launcher : Yojson.Raw.t;
    target : Yojson.Raw.t;
    sdks : Yojson.Raw.t;
    model_catalogue : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        launcher = required reader raw "launcher";
        target = required reader raw "target";
        sdks = required reader raw "sdks";
        model_catalogue = optional reader string "modelCatalogue";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ConformanceImplementations ] Models.t) =
    project (fields_of (Models.json model))
end

module About_params = struct
  type t = { api_version : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { api_version = required reader raw "apiVersion"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AboutParams ] Models.t) =
    project (fields_of (Models.json model))
end

module About_result = struct
  type t = {
    version : string Types.presence;
    development : bool;
    commit : string Types.presence;
    built : string Types.presence;
    api_versions : Yojson.Raw.t;
    image_registry : string;
    runtimes : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        version = optional reader string "version";
        development = required reader bool "development";
        commit = optional reader string "commit";
        built = optional reader string "built";
        api_versions = required reader raw "apiVersions";
        image_registry = required reader string "imageRegistry";
        runtimes = required reader raw "runtimes";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AboutResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Auth_login_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    target : Yojson.Raw.t Types.presence;
    runtime : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        target = optional reader raw "target";
        runtime = optional reader raw "runtime";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AuthLoginParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Auth_login_result = struct
  type t = {
    key : string;
    who : string;
    issuer : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        key = required reader string "key";
        who = required reader string "who";
        issuer = required reader string "issuer";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AuthLoginResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Auth_logout_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    target : Yojson.Raw.t Types.presence;
    runtime : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        target = optional reader raw "target";
        runtime = optional reader raw "runtime";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AuthLogoutParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Auth_logout_result = struct
  type t = {
    key : string Types.presence;
    was_signed_in : bool;
    revoked : bool;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        key = optional reader string "key";
        was_signed_in = required reader bool "wasSignedIn";
        revoked = required reader bool "revoked";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AuthLogoutResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Cancelled = struct
  type t = {
    request_id : Yojson.Raw.t;
    reason : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        request_id = required reader raw "requestId";
        reason = optional reader string "reason";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Cancelled ] Models.t) =
    project (fields_of (Models.json model))
end

module Error_data = struct
  type t = {
    code : string;
    retryable : bool;
    fields : Yojson.Raw.t Types.presence;
    choices : Yojson.Raw.t Types.presence;
    supported : Yojson.Raw.t Types.presence;
    may_still_run : bool Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = required reader string "code";
        retryable = required reader bool "retryable";
        fields = optional reader raw "fields";
        choices = optional reader raw "choices";
        supported = optional reader raw "supported";
        may_still_run = optional reader bool "mayStillRun";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ErrorData ] Models.t) =
    project (fields_of (Models.json model))
end

module Field_fault = struct
  type t = {
    field : string;
    message : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field = required reader string "field";
        message = required reader string "message";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `FieldFault ] Models.t) =
    project (fields_of (Models.json model))
end

module Identity_user = struct
  type t = {
    email : string;
    identity : string;
    enabled : bool;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        email = required reader string "email";
        identity = required reader string "identity";
        enabled = required reader bool "enabled";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `IdentityUser ] Models.t) =
    project (fields_of (Models.json model))
end

module Identity_useradd_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    target : Yojson.Raw.t;
    email : string;
    password : string Types.presence;
    generate_password : bool;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        target = required reader raw "target";
        email = required reader string "email";
        password = optional reader string "password";
        generate_password = required reader bool "generatePassword";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `IdentityUseraddParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Identity_useradd_result = struct
  type t = {
    email : string;
    identity : string;
    created : bool;
    generated_password : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        email = required reader string "email";
        identity = required reader string "identity";
        created = required reader bool "created";
        generated_password = optional reader string "generatedPassword";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `IdentityUseraddResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Identity_users_list_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    target : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        target = required reader raw "target";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `IdentityUsersListParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Identity_users_list_result = struct
  type t = { users : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { users = required reader raw "users"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `IdentityUsersListResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Knowledge_base_status = struct
  type t = {
    name : string;
    key : string;
    recorded : bool;
    placement : Yojson.Raw.t;
    root : string Types.presence;
    repo : Yojson.Raw.t Types.presence;
    did : Yojson.Raw.t Types.presence;
    site_name : Yojson.Raw.t Types.presence;
    identity_error : string Types.presence;
    kb : Yojson.Raw.t Types.presence;
    runtime : Yojson.Raw.t Types.presence;
    gateway : string Types.presence;
    secret_store : string Types.presence;
    lan : string Types.presence;
    starting : bool;
    session : Yojson.Raw.t Types.presence;
    healthy : bool;
    services : Yojson.Raw.t;
    workload : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        key = required reader string "key";
        recorded = required reader bool "recorded";
        placement = required reader raw "placement";
        root = optional reader string "root";
        repo = optional reader raw "repo";
        did = optional reader raw "did";
        site_name = optional reader raw "siteName";
        identity_error = optional reader string "identityError";
        kb = optional reader raw "kb";
        runtime = optional reader raw "runtime";
        gateway = optional reader string "gateway";
        secret_store = optional reader string "secretStore";
        lan = optional reader string "lan";
        starting = required reader bool "starting";
        session = optional reader raw "session";
        healthy = required reader bool "healthy";
        services = required reader raw "services";
        workload = optional reader raw "workload";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `KnowledgeBaseStatus ] Models.t) =
    project (fields_of (Models.json model))
end

module Local_target = struct
  type t = {
    kind : string;
    root : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kind = required reader string "kind";
        root = required reader string "root";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LocalTarget ] Models.t) =
    project (fields_of (Models.json model))
end

module Log_record = struct
  type t = {
    request_id : Yojson.Raw.t;
    service : string;
    stream : Yojson.Raw.t;
    line : string;
    received_at : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        request_id = required reader raw "requestId";
        service = required reader string "service";
        stream = required reader raw "stream";
        line = required reader string "line";
        received_at = required reader string "receivedAt";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LogRecord ] Models.t) =
    project (fields_of (Models.json model))
end

module Logs_follow_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    target : Yojson.Raw.t Types.presence;
    runtime : Yojson.Raw.t Types.presence;
    service : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        target = optional reader raw "target";
        runtime = optional reader raw "runtime";
        service = optional reader string "service";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LogsFollowParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Logs_follow_result = struct
  type t = { services : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { services = required reader raw "services"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `LogsFollowResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Progress = struct
  type t = {
    request_id : Yojson.Raw.t;
    kind : string;
    text : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        request_id = required reader raw "requestId";
        kind = required reader string "kind";
        text = required reader string "text";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Progress ] Models.t) =
    project (fields_of (Models.json model))
end

module Root = struct
  type t = {
    placement : Yojson.Raw.t;
    path : string Types.presence;
    present : bool Types.presence;
    current : string Types.presence;
    registered : bool;
    running : bool;
    last_used : string Types.presence;
    did : Yojson.Raw.t Types.presence;
    site_name : Yojson.Raw.t Types.presence;
    identity_error : string Types.presence;
    config : string Types.presence;
    configs : Yojson.Raw.t Types.presence;
    repo : Yojson.Raw.t Types.presence;
    codespace : string Types.presence;
    codespace_state : string Types.presence;
    forward_port : Yojson.Raw.t Types.presence;
    forwarded : bool Types.presence;
    reachable : bool Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        placement = required reader raw "placement";
        path = optional reader string "path";
        present = optional reader bool "present";
        current = optional reader string "current";
        registered = required reader bool "registered";
        running = required reader bool "running";
        last_used = optional reader string "lastUsed";
        did = optional reader raw "did";
        site_name = optional reader raw "siteName";
        identity_error = optional reader string "identityError";
        config = optional reader string "config";
        configs = optional reader raw "configs";
        repo = optional reader raw "repo";
        codespace = optional reader string "codespace";
        codespace_state = optional reader string "codespaceState";
        forward_port = optional reader raw "forwardPort";
        forwarded = optional reader bool "forwarded";
        reachable = optional reader bool "reachable";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Root ] Models.t) =
    project (fields_of (Models.json model))
end

module Roots_forget_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    root : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        root = required reader string "root";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RootsForgetParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Roots_forget_result = struct
  type t = {
    path : string;
    directory_missing : bool;
    persistent_state : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        path = required reader string "path";
        directory_missing = required reader bool "directoryMissing";
        persistent_state = optional reader string "persistentState";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RootsForgetResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Roots_init_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    path : string;
    domain : string;
    name : string Types.presence;
    site_name : string Types.presence;
    inference : string Types.presence;
    model : string Types.presence;
    model_light : string Types.presence;
    embedding : string Types.presence;
    config_name : string Types.presence;
    anthropic_endpoint : string Types.presence;
    ollama_base : string Types.presence;
    ollama_registry : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        path = required reader string "path";
        domain = required reader string "domain";
        name = optional reader string "name";
        site_name = optional reader string "siteName";
        inference = optional reader string "inference";
        model = optional reader string "model";
        model_light = optional reader string "modelLight";
        embedding = optional reader string "embedding";
        config_name = optional reader string "configName";
        anthropic_endpoint = optional reader string "anthropicEndpoint";
        ollama_base = optional reader string "ollamaBase";
        ollama_registry = optional reader string "ollamaRegistry";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RootsInitParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Roots_init_result = struct
  type t = { path : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { path = required reader string "path"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `RootsInitResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Roots_list_params = struct
  type t = { api_version : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { api_version = required reader raw "apiVersion"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RootsListParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Roots_list_result = struct
  type t = {
    roots : Yojson.Raw.t;
    warnings : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        roots = required reader raw "roots";
        warnings = optional reader raw "warnings";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RootsListResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Runtime_state = struct
  type t = {
    name : Yojson.Raw.t;
    found : bool;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader raw "name";
        found = required reader bool "found";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RuntimeState ] Models.t) =
    project (fields_of (Models.json model))
end

module Service_host_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    runtime : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        runtime = optional reader raw "runtime";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceHostParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Service_host_result = struct
  type t = {
    runtime : Yojson.Raw.t;
    address : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        runtime = required reader raw "runtime";
        address = required reader string "address";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceHostResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Service_output = struct
  type t = {
    request_id : Yojson.Raw.t;
    instance : Yojson.Raw.t;
    stream : Yojson.Raw.t;
    line : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        request_id = required reader raw "requestId";
        instance = required reader raw "instance";
        stream = required reader raw "stream";
        line = required reader string "line";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceOutput ] Models.t) =
    project (fields_of (Models.json model))
end

module Service_run_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    target : Yojson.Raw.t;
    runtime : Yojson.Raw.t Types.presence;
    service : Yojson.Raw.t;
    instance : Yojson.Raw.t;
    document : string Types.presence;
    args : Yojson.Raw.t Types.presence;
    environment : Yojson.Raw.t;
    mounts : Yojson.Raw.t;
    path_first : Yojson.Raw.t;
    ports : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        target = required reader raw "target";
        runtime = optional reader raw "runtime";
        service = required reader raw "service";
        instance = required reader raw "instance";
        document = optional reader string "document";
        args = optional reader raw "args";
        environment = required reader raw "environment";
        mounts = required reader raw "mounts";
        path_first = required reader raw "pathFirst";
        ports = required reader raw "ports";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceRunParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Service_run_result = struct
  type t = {
    instance : Yojson.Raw.t;
    exit_code : Yojson.Raw.t;
    ran_ms : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        instance = required reader raw "instance";
        exit_code = required reader raw "exitCode";
        ran_ms = required reader raw "ranMs";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceRunResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Service_signal_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    target : Yojson.Raw.t;
    runtime : Yojson.Raw.t Types.presence;
    instance : Yojson.Raw.t;
    signal : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        target = required reader raw "target";
        runtime = optional reader raw "runtime";
        instance = required reader raw "instance";
        signal = required reader string "signal";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceSignalParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Service_signal_result = struct
  type t = { delivered : bool; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { delivered = required reader bool "delivered"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceSignalResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Service_started = struct
  type t = {
    request_id : Yojson.Raw.t;
    instance : Yojson.Raw.t;
    container : string;
    document_path : string Types.presence;
    address : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        request_id = required reader raw "requestId";
        instance = required reader raw "instance";
        container = required reader string "container";
        document_path = optional reader string "documentPath";
        address = required reader string "address";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceStarted ] Models.t) =
    project (fields_of (Models.json model))
end

module Service_status = struct
  type t = {
    role : string;
    group : Yojson.Raw.t;
    product : string Types.presence;
    runs_on : string Types.presence;
    state : string;
    container_state : string Types.presence;
    healthy : bool;
    counted : bool;
    probe : string Types.presence;
    page : string Types.presence;
    realm : string Types.presence;
    serves : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        role = required reader string "role";
        group = required reader raw "group";
        product = optional reader string "product";
        runs_on = optional reader string "runsOn";
        state = required reader string "state";
        container_state = optional reader string "containerState";
        healthy = required reader bool "healthy";
        counted = required reader bool "counted";
        probe = optional reader string "probe";
        page = optional reader string "page";
        realm = optional reader string "realm";
        serves = optional reader raw "serves";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceStatus ] Models.t) =
    project (fields_of (Models.json model))
end

module Session = struct
  type t = {
    state : string;
    email : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        state = required reader string "state";
        email = optional reader string "email";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Session ] Models.t) =
    project (fields_of (Models.json model))
end

module Setting = struct
  type t = {
    name : string;
    default : bool;
    applies_to : string;
    values : Yojson.Raw.t;
    settable : bool;
    changed_by : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        default = required reader bool "default";
        applies_to = required reader string "appliesTo";
        values = required reader raw "values";
        settable = required reader bool "settable";
        changed_by = optional reader string "changedBy";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Setting ] Models.t) =
    project (fields_of (Models.json model))
end

module Setting_line = struct
  type t = {
    value : string;
    source : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        value = required reader string "value";
        source = required reader string "source";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingLine ] Models.t) =
    project (fields_of (Models.json model))
end

module Settings_get_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    name : string;
    default : bool Types.presence;
    root : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        name = required reader string "name";
        default = optional reader bool "default";
        root = optional reader string "root";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsGetParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Settings_list_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    root : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        root = optional reader string "root";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsListParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Settings_list_result = struct
  type t = {
    root : string Types.presence;
    unresolved : string Types.presence;
    settings : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        root = optional reader string "root";
        unresolved = optional reader string "unresolved";
        settings = required reader raw "settings";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsListResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Settings_path_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    document : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        document = required reader string "document";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsPathParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Settings_path_result = struct
  type t = { path : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { path = required reader string "path"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsPathResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Settings_set_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    name : string;
    default : bool Types.presence;
    root : string Types.presence;
    value : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        name = required reader string "name";
        default = optional reader bool "default";
        root = optional reader string "root";
        value = required reader string "value";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsSetParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Settings_unset_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    name : string;
    default : bool Types.presence;
    root : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        name = required reader string "name";
        default = optional reader bool "default";
        root = optional reader string "root";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsUnsetParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Stack_start_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    target : Yojson.Raw.t Types.presence;
    runtime : Yojson.Raw.t Types.presence;
    config : string Types.presence;
    service : string Types.presence;
    group : Yojson.Raw.t Types.presence;
    codespace_name : string Types.presence;
    machine : string Types.presence;
    idle_timeout : string Types.presence;
    retention_period : string Types.presence;
    observe : bool Types.presence;
    ollama_cache : string Types.presence;
    dry_run : bool Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        target = optional reader raw "target";
        runtime = optional reader raw "runtime";
        config = optional reader string "config";
        service = optional reader string "service";
        group = optional reader raw "group";
        codespace_name = optional reader string "codespaceName";
        machine = optional reader string "machine";
        idle_timeout = optional reader string "idleTimeout";
        retention_period = optional reader string "retentionPeriod";
        observe = optional reader bool "observe";
        ollama_cache = optional reader string "ollamaCache";
        dry_run = optional reader bool "dryRun";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StackStartParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Stack_start_result = struct
  type t = {
    dry_run : bool;
    knowledge_base : Yojson.Raw.t Types.presence;
    shared : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        dry_run = required reader bool "dryRun";
        knowledge_base = optional reader raw "knowledgeBase";
        shared = optional reader raw "shared";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StackStartResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Stack_stop_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    target : Yojson.Raw.t Types.presence;
    runtime : Yojson.Raw.t Types.presence;
    service : string Types.presence;
    group : Yojson.Raw.t Types.presence;
    delete : bool Types.presence;
    delete_confirmed : bool Types.presence;
    dry_run : bool Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        target = optional reader raw "target";
        runtime = optional reader raw "runtime";
        service = optional reader string "service";
        group = optional reader raw "group";
        delete = optional reader bool "delete";
        delete_confirmed = optional reader bool "deleteConfirmed";
        dry_run = optional reader bool "dryRun";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StackStopParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Stack_stop_result = struct
  type t = {
    dry_run : bool;
    knowledge_bases : Yojson.Raw.t Types.presence;
    shared : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        dry_run = required reader bool "dryRun";
        knowledge_bases = optional reader raw "knowledgeBases";
        shared = optional reader raw "shared";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StackStopResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Status_snapshot_params = struct
  type t = {
    api_version : Yojson.Raw.t;
    target : Yojson.Raw.t Types.presence;
    runtime : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        target = optional reader raw "target";
        runtime = optional reader raw "runtime";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StatusSnapshotParams ] Models.t) =
    project (fields_of (Models.json model))
end

module Status_snapshot_result = struct
  type t = {
    knowledge_bases : Yojson.Raw.t;
    shared : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        knowledge_bases = required reader raw "knowledgeBases";
        shared = required reader raw "shared";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StatusSnapshotResult ] Models.t) =
    project (fields_of (Models.json model))
end

module Target = struct
  type t = {
    kind : string;
    root : string Types.presence;
    repo : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kind = required reader string "kind";
        root = optional reader string "root";
        repo = optional reader string "repo";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Target ] Models.t) =
    project (fields_of (Models.json model))
end

module User_action = struct
  type t = {
    request_id : Yojson.Raw.t;
    verification_uri : string;
    verification_uri_complete : string Types.presence;
    user_code : string;
    expires_in_seconds : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        request_id = required reader raw "requestId";
        verification_uri = required reader string "verificationUri";
        verification_uri_complete =
          optional reader string "verificationUriComplete";
        user_code = required reader string "userCode";
        expires_in_seconds = required reader raw "expiresInSeconds";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `UserAction ] Models.t) =
    project (fields_of (Models.json model))
end

module Workload_status = struct
  type t = {
    ledger : Yojson.Raw.t Types.presence;
    queue : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        ledger = optional reader raw "ledger";
        queue = optional reader raw "queue";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WorkloadStatus ] Models.t) =
    project (fields_of (Models.json model))
end

module Dispatcher_config = struct
  type t = {
    kb : Yojson.Raw.t;
    gateway_url : string;
    identity : Yojson.Raw.t;
    queue : Yojson.Raw.t;
    port : Yojson.Raw.t;
    timing : Yojson.Raw.t;
    log_level : Yojson.Raw.t;
    log_format : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kb = required reader raw "kb";
        gateway_url = required reader string "gatewayUrl";
        identity = required reader raw "identity";
        queue = required reader raw "queue";
        port = required reader raw "port";
        timing = required reader raw "timing";
        log_level = required reader raw "logLevel";
        log_format = required reader raw "logFormat";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `DispatcherConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Dispatcher_health = struct
  type t = {
    status : string;
    queue : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader string "status";
        queue = required reader string "queue";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `DispatcherHealth ] Models.t) =
    project (fields_of (Models.json model))
end

module Ollama_embedding_config = struct
  type t = {
    type_ : string;
    model : string;
    base_url : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader string "type";
        model = required reader string "model";
        base_url = required reader string "baseUrl";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `OllamaEmbeddingConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Voyage_embedding_config = struct
  type t = {
    type_ : string;
    model : string;
    endpoint : string;
    api_key_env : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader string "type";
        model = required reader string "model";
        endpoint = required reader string "endpoint";
        api_key_env = required reader string "apiKeyEnv";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `VoyageEmbeddingConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Follower_following = struct
  type t = {
    sweep : string;
    stopped : Yojson.Raw.t;
    refused : Yojson.Raw.t;
    stream_drops : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        sweep = required reader string "sweep";
        stopped = required reader raw "stopped";
        refused = required reader raw "refused";
        stream_drops = required reader raw "streamDrops";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `FollowerFollowing ] Models.t) =
    project (fields_of (Models.json model))
end

module Gateway_config = struct
  type t = {
    kb : Yojson.Raw.t;
    port : Yojson.Raw.t;
    public_url : string;
    identity : Yojson.Raw.t;
    archivist : Yojson.Raw.t;
    signal : Yojson.Raw.t;
    log_level : Yojson.Raw.t;
    log_format : Yojson.Raw.t;
    capacity : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kb = required reader raw "kb";
        port = required reader raw "port";
        public_url = required reader string "publicUrl";
        identity = required reader raw "identity";
        archivist = required reader raw "archivist";
        signal = required reader raw "signal";
        log_level = required reader raw "logLevel";
        log_format = required reader raw "logFormat";
        capacity = required reader raw "capacity";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatewayConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Janus_graph_config = struct
  type t = {
    type_ : string;
    host : string;
    port : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader string "type";
        host = required reader string "host";
        port = required reader raw "port";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JanusGraphConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Memory_graph_config = struct
  type t = { type_ : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { type_ = required reader string "type"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `MemoryGraphConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Neo4j_graph_config = struct
  type t = {
    type_ : string;
    uri : string;
    username : string;
    password_env : string;
    database : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader string "type";
        uri = required reader string "uri";
        username = required reader string "username";
        password_env = required reader string "passwordEnv";
        database = required reader string "database";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Neo4jGraphConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Neptune_graph_config = struct
  type t = {
    type_ : string;
    endpoint : string;
    port : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader string "type";
        endpoint = required reader string "endpoint";
        port = required reader raw "port";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `NeptuneGraphConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Project_config = struct
  type t = {
    project : Yojson.Raw.t;
    git : Yojson.Raw.t;
    site : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        project = required reader raw "project";
        git = required reader raw "git";
        site = required reader raw "site";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ProjectConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Librarian_config = struct
  type t = {
    kb : Yojson.Raw.t;
    gateway_url : string;
    identity : Yojson.Raw.t;
    archivist : Yojson.Raw.t;
    graph : Yojson.Raw.t;
    vectors : Yojson.Raw.t;
    embedding : Yojson.Raw.t;
    matcher : Yojson.Raw.t;
    gatherer : Yojson.Raw.t;
    model_catalogue : string;
    gather : Yojson.Raw.t;
    search : Yojson.Raw.t;
    port : Yojson.Raw.t;
    log_level : Yojson.Raw.t;
    log_format : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kb = required reader raw "kb";
        gateway_url = required reader string "gatewayUrl";
        identity = required reader raw "identity";
        archivist = required reader raw "archivist";
        graph = required reader raw "graph";
        vectors = required reader raw "vectors";
        embedding = required reader raw "embedding";
        matcher = required reader raw "matcher";
        gatherer = required reader raw "gatherer";
        model_catalogue = required reader string "modelCatalogue";
        gather = required reader raw "gather";
        search = required reader raw "search";
        port = required reader raw "port";
        log_level = required reader raw "logLevel";
        log_format = required reader raw "logFormat";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LibrarianConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Librarian_engine_config = struct
  type t = {
    engine : Yojson.Raw.t;
    base_url : string;
    api_key_env : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        engine = required reader raw "engine";
        base_url = required reader string "baseUrl";
        api_key_env = optional reader string "apiKeyEnv";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LibrarianEngineConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Librarian_health = struct
  type t = {
    status : string;
    kb : Yojson.Raw.t;
    actors : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader string "status";
        kb = required reader raw "kb";
        actors = required reader raw "actors";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LibrarianHealth ] Models.t) =
    project (fields_of (Models.json model))
end

module Librarian_prompt_score = struct
  type t = {
    candidate : Yojson.Raw.t;
    score : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        candidate = required reader raw "candidate";
        score = required reader raw "score";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LibrarianPromptScore ] Models.t) =
    project (fields_of (Models.json model))
end

module Client_secret_form = struct
  type t = {
    grant_type : string;
    client_id : string;
    client_secret : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        grant_type = required reader string "grant_type";
        client_id = required reader string "client_id";
        client_secret = required reader string "client_secret";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ClientSecretForm ] Models.t) =
    project (fields_of (Models.json model))
end

module Open_resource = struct
  type t = {
    id : Yojson.Raw.t;
    name : string;
    opened_at : Yojson.Raw.t;
    order : Yojson.Raw.t;
    media_type : string Types.presence;
    storage_uri : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader raw "id";
        name = required reader string "name";
        opened_at = required reader raw "openedAt";
        order = required reader raw "order";
        media_type = optional reader string "mediaType";
        storage_uri = optional reader string "storageUri";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `OpenResource ] Models.t) =
    project (fields_of (Models.json model))
end

module Smelter_chunking = struct
  type t = {
    chunk_size : Yojson.Raw.t;
    overlap : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        chunk_size = required reader raw "chunkSize";
        overlap = required reader raw "overlap";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SmelterChunking ] Models.t) =
    project (fields_of (Models.json model))
end

module Smelter_config = struct
  type t = {
    kb : Yojson.Raw.t;
    gateway_url : string;
    identity : Yojson.Raw.t;
    archivist : Yojson.Raw.t;
    embedding : Yojson.Raw.t;
    vectors : Yojson.Raw.t;
    chunking : Yojson.Raw.t;
    pdfs_at_once : Yojson.Raw.t;
    cursors_path : Yojson.Raw.t;
    port : Yojson.Raw.t;
    log_level : Yojson.Raw.t;
    log_format : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kb = required reader raw "kb";
        gateway_url = required reader string "gatewayUrl";
        identity = required reader raw "identity";
        archivist = required reader raw "archivist";
        embedding = required reader raw "embedding";
        vectors = required reader raw "vectors";
        chunking = required reader raw "chunking";
        pdfs_at_once = required reader raw "pdfsAtOnce";
        cursors_path = required reader raw "cursorsPath";
        port = required reader raw "port";
        log_level = required reader raw "logLevel";
        log_format = required reader raw "logFormat";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SmelterConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Smelter_health = struct
  type t = {
    status : string;
    kb : Yojson.Raw.t;
    stream : string;
    following : Yojson.Raw.t;
    events_processed : Yojson.Raw.t;
    reconcile : Yojson.Raw.t;
    index : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader string "status";
        kb = required reader raw "kb";
        stream = required reader string "stream";
        following = required reader raw "following";
        events_processed = required reader raw "eventsProcessed";
        reconcile = required reader raw "reconcile";
        index = required reader raw "index";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SmelterHealth ] Models.t) =
    project (fields_of (Models.json model))
end

module Smelter_reconcile_summary = struct
  type t = {
    resources_embedded : Yojson.Raw.t;
    resources_skipped : Yojson.Raw.t;
    resources_unavailable : Yojson.Raw.t;
    resources_failed : Yojson.Raw.t;
    resources_restamped : Yojson.Raw.t;
    resources_reanchored : Yojson.Raw.t;
    resource_vectors_deleted : Yojson.Raw.t;
    annotations_embedded : Yojson.Raw.t;
    annotations_restamped : Yojson.Raw.t;
    annotation_vectors_deleted : Yojson.Raw.t;
    resources_eligible : Yojson.Raw.t;
    resources_indexed : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resources_embedded = required reader raw "resourcesEmbedded";
        resources_skipped = required reader raw "resourcesSkipped";
        resources_unavailable = required reader raw "resourcesUnavailable";
        resources_failed = required reader raw "resourcesFailed";
        resources_restamped = required reader raw "resourcesRestamped";
        resources_reanchored = required reader raw "resourcesReanchored";
        resource_vectors_deleted = required reader raw "resourceVectorsDeleted";
        annotations_embedded = required reader raw "annotationsEmbedded";
        annotations_restamped = required reader raw "annotationsRestamped";
        annotation_vectors_deleted =
          required reader raw "annotationVectorsDeleted";
        resources_eligible = required reader raw "resourcesEligible";
        resources_indexed = required reader raw "resourcesIndexed";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SmelterReconcileSummary ] Models.t) =
    project (fields_of (Models.json model))
end

module Browser = struct
  type t = {
    api_version : Yojson.Raw.t;
    kind : string;
    metadata : Yojson.Raw.t;
    spec : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        kind = required reader string "kind";
        metadata = required reader raw "metadata";
        spec = required reader raw "spec";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Browser ] Models.t) =
    project (fields_of (Models.json model))
end

module Host_port = struct
  type t = {
    host : string;
    port : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        host = required reader string "host";
        port = required reader raw "port";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `HostPort ] Models.t) =
    project (fields_of (Models.json model))
end

module Inference = struct
  type t = {
    api_version : Yojson.Raw.t;
    kind : string;
    metadata : Yojson.Raw.t;
    spec : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        kind = required reader string "kind";
        metadata = required reader raw "metadata";
        spec = required reader raw "spec";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Inference ] Models.t) =
    project (fields_of (Models.json model))
end

module Issuer = struct
  type t = {
    api_version : Yojson.Raw.t;
    kind : string;
    metadata : Yojson.Raw.t;
    spec : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        kind = required reader string "kind";
        metadata = required reader raw "metadata";
        spec = required reader raw "spec";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Issuer ] Models.t) =
    project (fields_of (Models.json model))
end

module Knowledge_index = struct
  type t = {
    api_version : Yojson.Raw.t;
    kind : string;
    metadata : Yojson.Raw.t;
    spec : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        kind = required reader string "kind";
        metadata = required reader raw "metadata";
        spec = required reader raw "spec";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `KnowledgeIndex ] Models.t) =
    project (fields_of (Models.json model))
end

module Metadata = struct
  type t = {
    name : string;
    namespace : string Types.presence;
    labels : Yojson.Raw.t Types.presence;
    annotations : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        namespace = optional reader string "namespace";
        labels = optional reader raw "labels";
        annotations = optional reader raw "annotations";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Metadata ] Models.t) =
    project (fields_of (Models.json model))
end

module Provider = struct
  type t = {
    base_url : string Types.presence;
    api_key : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        base_url = optional reader string "baseURL";
        api_key = optional reader raw "apiKey";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Provider ] Models.t) =
    project (fields_of (Models.json model))
end

module Resources = struct
  type t = { limits : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { limits = required reader raw "limits"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `Resources ] Models.t) =
    project (fields_of (Models.json model))
end

module Secret_ref = struct
  type t = { from_env : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { from_env = required reader string "fromEnv"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `SecretRef ] Models.t) =
    project (fields_of (Models.json model))
end

module Stack_knowledge_base = struct
  type t = {
    api_version : Yojson.Raw.t;
    kind : string;
    metadata : Yojson.Raw.t;
    spec : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        kind = required reader string "kind";
        metadata = required reader raw "metadata";
        spec = required reader raw "spec";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StackKnowledgeBase ] Models.t) =
    project (fields_of (Models.json model))
end

module Vector_store = struct
  type t = {
    api_version : Yojson.Raw.t;
    kind : string;
    metadata : Yojson.Raw.t;
    spec : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        kind = required reader string "kind";
        metadata = required reader raw "metadata";
        spec = required reader raw "spec";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `VectorStore ] Models.t) =
    project (fields_of (Models.json model))
end

module Worker_pool = struct
  type t = {
    api_version : Yojson.Raw.t;
    kind : string;
    metadata : Yojson.Raw.t;
    spec : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader raw "apiVersion";
        kind = required reader string "kind";
        metadata = required reader raw "metadata";
        spec = required reader raw "spec";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WorkerPool ] Models.t) =
    project (fields_of (Models.json model))
end

module Memory_vectors_config = struct
  type t = { type_ : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { type_ = required reader string "type"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `MemoryVectorsConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Qdrant_vectors_config = struct
  type t = {
    type_ : string;
    host : string;
    port : Yojson.Raw.t;
    token_env : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader string "type";
        host = required reader string "host";
        port = required reader raw "port";
        token_env = required reader string "tokenEnv";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `QdrantVectorsConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Weaver_config = struct
  type t = {
    kb : Yojson.Raw.t;
    gateway_url : string;
    identity : Yojson.Raw.t;
    archivist : Yojson.Raw.t;
    graph : Yojson.Raw.t;
    cursors_path : Yojson.Raw.t;
    port : Yojson.Raw.t;
    log_level : Yojson.Raw.t;
    log_format : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kb = required reader raw "kb";
        gateway_url = required reader string "gatewayUrl";
        identity = required reader raw "identity";
        archivist = required reader raw "archivist";
        graph = required reader raw "graph";
        cursors_path = required reader raw "cursorsPath";
        port = required reader raw "port";
        log_level = required reader raw "logLevel";
        log_format = required reader raw "logFormat";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WeaverConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Weaver_health = struct
  type t = {
    status : string;
    kb : Yojson.Raw.t;
    following : Yojson.Raw.t;
    reconcile : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader string "status";
        kb = required reader raw "kb";
        following = required reader raw "following";
        reconcile = required reader raw "reconcile";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WeaverHealth ] Models.t) =
    project (fields_of (Models.json model))
end

module Worker_config = struct
  type t = {
    knowledge_bases : Yojson.Raw.t;
    model_catalogue : string;
    port : Yojson.Raw.t;
    log_level : Yojson.Raw.t;
    log_format : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        knowledge_bases = required reader raw "knowledgeBases";
        model_catalogue = required reader string "modelCatalogue";
        port = required reader raw "port";
        log_level = required reader raw "logLevel";
        log_format = required reader raw "logFormat";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WorkerConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Worker_engine_config = struct
  type t = {
    engine : Yojson.Raw.t;
    jobs : Yojson.Raw.t;
    base_url : string;
    api_key_env : string Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        engine = required reader raw "engine";
        jobs = required reader raw "jobs";
        base_url = required reader string "baseUrl";
        api_key_env = optional reader string "apiKeyEnv";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WorkerEngineConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Worker_engine_health = struct
  type t = {
    engine : Yojson.Raw.t;
    jobs : Yojson.Raw.t;
    last_queued_event_at : Yojson.Raw.t;
    last_claim_at : Yojson.Raw.t;
    last_finished_at : Yojson.Raw.t;
    last_activity_at : Yojson.Raw.t;
    active_job : Yojson.Raw.t;
    jobs_completed : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        engine = required reader raw "engine";
        jobs = required reader raw "jobs";
        last_queued_event_at = required reader raw "lastQueuedEventAt";
        last_claim_at = required reader raw "lastClaimAt";
        last_finished_at = required reader raw "lastFinishedAt";
        last_activity_at = required reader raw "lastActivityAt";
        active_job = required reader raw "activeJob";
        jobs_completed = required reader raw "jobsCompleted";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WorkerEngineHealth ] Models.t) =
    project (fields_of (Models.json model))
end

module Worker_health = struct
  type t = {
    status : string;
    knowledge_bases : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader string "status";
        knowledge_bases = required reader raw "knowledgeBases";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WorkerHealth ] Models.t) =
    project (fields_of (Models.json model))
end

module Worker_knowledge_base_config = struct
  type t = {
    domain : string;
    gateway_url : string;
    identity : Yojson.Raw.t;
    engines : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        domain = required reader string "domain";
        gateway_url = required reader string "gatewayUrl";
        identity = required reader raw "identity";
        engines = required reader raw "engines";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WorkerKnowledgeBaseConfig ] Models.t) =
    project (fields_of (Models.json model))
end

module Worker_knowledge_base_health = struct
  type t = {
    domain : string;
    state : string;
    did : string Types.presence;
    engines : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        domain = required reader string "domain";
        state = required reader string "state";
        did = optional reader string "did";
        engines = optional reader raw "engines";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WorkerKnowledgeBaseHealth ] Models.t) =
    project (fields_of (Models.json model))
end

module Agent = struct
  type t =
    | Person of Agent_person.t
    | Organization of Agent_organization.t
    | Software of Agent_software.t

  let of_model (model : [ `Agent ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "@type" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "Person" -> Some (Person (Agent_person.project fields))
        | "Organization" ->
            Some (Organization (Agent_organization.project fields))
        | "Software" -> Some (Software (Agent_software.project fields))
        | _ -> None)
    | _ -> None
end

module Annotation_body = struct
  type t =
    | TextualBody of Textual_body.t
    | SpecificResource of Specific_resource.t

  let of_model (model : [ `AnnotationBody ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "type" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "TextualBody" -> Some (TextualBody (Textual_body.project fields))
        | "SpecificResource" ->
            Some (SpecificResource (Specific_resource.project fields))
        | _ -> None)
    | _ -> None
end

module Anchored_text_answer = struct
  type t =
    | Extracted of Extracted_text.t
    | Declined of Extraction_declined.t
    | NotYet of Anchored_text_absent.t
    | NoMap of Anchored_text_absent.t
    | Unknown of Anchored_text_absent.t

  let of_model (model : [ `AnchoredTextAnswer ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "kind" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "extracted" -> Some (Extracted (Extracted_text.project fields))
        | "declined" -> Some (Declined (Extraction_declined.project fields))
        | "not-yet" -> Some (NotYet (Anchored_text_absent.project fields))
        | "no-map" -> Some (NoMap (Anchored_text_absent.project fields))
        | "unknown" -> Some (Unknown (Anchored_text_absent.project fields))
        | _ -> None)
    | _ -> None
end

module Directory_entry = struct
  type t = File of File_entry.t | Dir of Dir_entry.t

  let of_model (model : [ `DirectoryEntry ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "type" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "file" -> Some (File (File_entry.project fields))
        | "dir" -> Some (Dir (Dir_entry.project fields))
        | _ -> None)
    | _ -> None
end

module Extraction_outcome = struct
  type t = Extracted of Extracted_text.t | Declined of Extraction_declined.t

  let of_model (model : [ `ExtractionOutcome ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "kind" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "extracted" -> Some (Extracted (Extracted_text.project fields))
        | "declined" -> Some (Declined (Extraction_declined.project fields))
        | _ -> None)
    | _ -> None
end

module Job_complete_command = struct
  type t =
    | Mark of Mark_job_complete_command.t
    | Yield of Yield_job_complete_command.t

  let of_model (model : [ `JobCompleteCommand ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "jobType" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "mark" -> Some (Mark (Mark_job_complete_command.project fields))
        | "yield" -> Some (Yield (Yield_job_complete_command.project fields))
        | _ -> None)
    | _ -> None
end

module Job_create_command = struct
  type t =
    | Mark of Mark_job_create_command.t
    | Yield of Yield_job_create_command.t

  let of_model (model : [ `JobCreateCommand ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "jobType" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "mark" -> Some (Mark (Mark_job_create_command.project fields))
        | "yield" -> Some (Yield (Yield_job_create_command.project fields))
        | _ -> None)
    | _ -> None
end

module Job_progress_message = struct
  type t =
    | Loading of Job_progress_loading.t
    | Analyzing of Job_progress_analyzing.t
    | AnalyzingTags of Job_progress_analyzing_tags.t
    | GeneratingResource of Job_progress_generating_resource.t
    | CreatingResource of Job_progress_creating_resource.t
    | CompleteGenerated of Job_progress_complete_generated.t
    | DetectingEntities of Job_progress_detecting_entities.t
    | CreatingAnnotations of Job_progress_creating_annotations.t
    | CreatingTagAnnotations of Job_progress_creating_tag_annotations.t
    | CompleteCreated of Job_progress_complete_created.t

  let of_model (model : [ `JobProgressMessage ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "code" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "loading" -> Some (Loading (Job_progress_loading.project fields))
        | "analyzing" ->
            Some (Analyzing (Job_progress_analyzing.project fields))
        | "analyzing-tags" ->
            Some (AnalyzingTags (Job_progress_analyzing_tags.project fields))
        | "generating-resource" ->
            Some
              (GeneratingResource
                 (Job_progress_generating_resource.project fields))
        | "creating-resource" ->
            Some
              (CreatingResource (Job_progress_creating_resource.project fields))
        | "complete-generated" ->
            Some
              (CompleteGenerated
                 (Job_progress_complete_generated.project fields))
        | "detecting-entities" ->
            Some
              (DetectingEntities
                 (Job_progress_detecting_entities.project fields))
        | "creating-annotations" ->
            Some
              (CreatingAnnotations
                 (Job_progress_creating_annotations.project fields))
        | "creating-tag-annotations" ->
            Some
              (CreatingTagAnnotations
                 (Job_progress_creating_tag_annotations.project fields))
        | "complete-created" ->
            Some
              (CompleteCreated (Job_progress_complete_created.project fields))
        | _ -> None)
    | _ -> None
end

module Job_queued_event = struct
  type t = Mark of Mark_job_queued_event.t | Yield of Yield_job_queued_event.t

  let of_model (model : [ `JobQueuedEvent ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "jobType" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "mark" -> Some (Mark (Mark_job_queued_event.project fields))
        | "yield" -> Some (Yield (Yield_job_queued_event.project fields))
        | _ -> None)
    | _ -> None
end

module Kb_endpoint = struct
  type t = Http of Http_endpoint.t | Local of Local_endpoint.t

  let of_model (model : [ `KbEndpoint ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "kind" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "http" -> Some (Http (Http_endpoint.project fields))
        | "local" -> Some (Local (Local_endpoint.project fields))
        | _ -> None)
    | _ -> None
end

module Selector = struct
  type t =
    | TextPositionSelector of Text_position_selector.t
    | TextQuoteSelector of Text_quote_selector.t
    | SvgSelector of Svg_selector.t
    | FragmentSelector of Fragment_selector.t

  let of_model (model : [ `Selector ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "type" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "TextPositionSelector" ->
            Some (TextPositionSelector (Text_position_selector.project fields))
        | "TextQuoteSelector" ->
            Some (TextQuoteSelector (Text_quote_selector.project fields))
        | "SvgSelector" -> Some (SvgSelector (Svg_selector.project fields))
        | "FragmentSelector" ->
            Some (FragmentSelector (Fragment_selector.project fields))
        | _ -> None)
    | _ -> None
end

module Mark_job_params = struct
  type t =
    | Highlighting of Highlighting_job_params.t
    | Commenting of Commenting_job_params.t
    | Assessing of Assessing_job_params.t
    | Linking of Linking_job_params.t
    | Tagging of Tagging_job_params.t

  let of_model (model : [ `MarkJobParams ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "motivation" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "highlighting" ->
            Some (Highlighting (Highlighting_job_params.project fields))
        | "commenting" ->
            Some (Commenting (Commenting_job_params.project fields))
        | "assessing" -> Some (Assessing (Assessing_job_params.project fields))
        | "linking" -> Some (Linking (Linking_job_params.project fields))
        | "tagging" -> Some (Tagging (Tagging_job_params.project fields))
        | _ -> None)
    | _ -> None
end

module Job_filter = struct
  type t = Mark of Mark_job_filter.t | Yield of Yield_job_filter.t

  let of_model (model : [ `JobFilter ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "jobType" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "mark" -> Some (Mark (Mark_job_filter.project fields))
        | "yield" -> Some (Yield (Yield_job_filter.project fields))
        | _ -> None)
    | _ -> None
end

module Job = struct
  type t =
    | Pending of Job_pending.t
    | Running of Job_running.t
    | Complete of Job_complete.t
    | Failed of Job_failed.t
    | Cancelled of Job_cancelled.t

  let of_model (model : [ `Job ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "status" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "pending" -> Some (Pending (Job_pending.project fields))
        | "running" -> Some (Running (Job_running.project fields))
        | "complete" -> Some (Complete (Job_complete.project fields))
        | "failed" -> Some (Failed (Job_failed.project fields))
        | "cancelled" -> Some (Cancelled (Job_cancelled.project fields))
        | _ -> None)
    | _ -> None
end

module Embedding_config = struct
  type t =
    | Ollama of Ollama_embedding_config.t
    | Voyage of Voyage_embedding_config.t

  let of_model (model : [ `EmbeddingConfig ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "type" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "ollama" -> Some (Ollama (Ollama_embedding_config.project fields))
        | "voyage" -> Some (Voyage (Voyage_embedding_config.project fields))
        | _ -> None)
    | _ -> None
end

module Graph_config = struct
  type t =
    | Neo4j of Neo4j_graph_config.t
    | Janusgraph of Janus_graph_config.t
    | Neptune of Neptune_graph_config.t
    | Memory of Memory_graph_config.t

  let of_model (model : [ `GraphConfig ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "type" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "neo4j" -> Some (Neo4j (Neo4j_graph_config.project fields))
        | "janusgraph" -> Some (Janusgraph (Janus_graph_config.project fields))
        | "neptune" -> Some (Neptune (Neptune_graph_config.project fields))
        | "memory" -> Some (Memory (Memory_graph_config.project fields))
        | _ -> None)
    | _ -> None
end

module Vectors_config = struct
  type t =
    | Qdrant of Qdrant_vectors_config.t
    | Memory of Memory_vectors_config.t

  let of_model (model : [ `VectorsConfig ] Models.t) =
    let fields = fields_of (Models.json model) in
    match List.assoc_opt "type" fields with
    | Some (`Stringlit literal) -> (
        match string (`Stringlit literal) with
        | "qdrant" -> Some (Qdrant (Qdrant_vectors_config.project fields))
        | "memory" -> Some (Memory (Memory_vectors_config.project fields))
        | _ -> None)
    | _ -> None
end

module Connection_identity = struct
  type t = { did : string; description : [ `KbDescription ] Models.t }
end

module Expected = struct
  type t = { did : string; name : string option }
end

module Kb_read_verdict = struct
  type t =
    | Recorded
    | Conflict of { observed_did : string; observed_name : string }
    | NoVerdict
end

module Tab_check = struct
  type t =
    | Gone
    | Ready of { name : string; media_type : string option }
    | Unknown
end

module Session_ended = struct
  type t = { reason : Enums.Session_end_reason.t }
end

module Permission_denied = struct
  type t = { detail : string option }
end

module Kb_identity_conflict = struct
  type t = { expected_did : string; observed_did : string }
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
end

module Begin_authorization_options = struct
  type t = {
    target : [ `HttpEndpoint ] Models.t;
    redirect_uri : string;
    kb_id : string option;
    expected_did : string option;
    expected_name : string option;
  }
end

module Claim_options = struct
  type t = {
    accepts : [ `JobFilter ] Models.t list;
    job_claim_timeout_ms : int option;
    held_job_stall_ms : int option;
    held_job_stall_check_ms : int option;
    mark_commit_timeout_ms : int option;
  }
end

module Create_from_token_options = struct
  type t = {
    token : string;
    name : string;
    content : string;
    archive_original : bool option;
  }
end

module Device_code = struct
  type t = {
    user_code : string;
    verification_uri : string;
    verification_uri_complete : string option;
    expires_in : int;
  }
end

module Gather_resource_options = struct
  type t = {
    depth : int option;
    max_resources : int option;
    include_content : bool option;
    include_summary : bool option;
    exclude_entity_types : string list option;
  }
end

module Issued_tokens = struct
  type t = { access : string; refresh : string }
end

module Job_poll_options = struct
  type t = { every_ms : int option; within_ms : int option }
end

module Match_search_options = struct
  type t = { limit : int option; use_semantic_scoring : bool option }
end

module Pdf_coordinate = struct
  type t = { page : int; x : float; y : float; width : float; height : float }
end

module Pending_annotation = struct
  type t = {
    selector : [ `AnnotationSelector ] Models.t;
    motivation : [ `Motivation ] Models.t;
  }
end

module Quoted_text = struct
  type t = { exact : string; prefix : string option; suffix : string option }
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
end

module Resource_search_filters = struct
  type t = {
    archived : bool option;
    entity_type : string option;
    offset : int option;
    limit : int option;
  }
end

module Text_span = struct
  type t = {
    start : int;
    end_ : int;
    exact : string;
    prefix : string option;
    suffix : string option;
  }
end

module Upload_progress = struct
  type t =
    | Started of { total_bytes : int }
    | Progress of { bytes_uploaded : int; total_bytes : int }
    | Finished of { resource_id : string }
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
end

module Sign_in_outcome = struct
  type t = { kb : [ `KnowledgeBase ] Models.t; expected : Expected.t option }
end
