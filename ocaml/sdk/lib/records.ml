(* Generated from OpenAPI object components and discriminator mappings, and the records of Protocol's tables. Do not edit.
   Regenerate: make generate (codegen/lib/ocaml_sdk/records.ml) *)

open Record_reader

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
    write
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
    write
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
    parameters : Yojson.Raw.t Types.presence;
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
        parameters = optional reader raw "parameters";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AgentSoftware ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("@type", Some ((json_enum Field_type.to_string) value.field_type));
        ("@id", Option.map json_string value.field_id);
        ("name", Option.map json_string value.name);
        ("provider", Option.map json_string value.provider);
        ("model", Option.map json_string value.model);
        ("parameters", present json_raw value.parameters);
      ]
      value.extra

  let to_model value =
    Models.decode Models.agent_software (Yojson.Raw.to_string (to_json value))
end

module Annotation = struct
  module Type_ = struct
    type t = Annotation

    let to_string = function Annotation -> "Annotation"
    let of_string = function "Annotation" -> Some Annotation | _ -> None
  end

  type t = {
    field_context : string;
    type_ : Type_.t;
    id : string;
    motivation : Enums.Motivation.t;
    target : Yojson.Raw.t;
    body : Yojson.Raw.t Types.presence;
    creator : Yojson.Raw.t Types.presence;
    created : string;
    modified : string option;
    generator : Yojson.Raw.t Types.presence;
    was_attributed_to : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_context = required reader string "@context";
        type_ = required reader (enum Type_.of_string) "type";
        id = required reader string "id";
        motivation =
          required reader (enum Enums.Motivation.of_string) "motivation";
        target = required reader raw "target";
        body = optional reader raw "body";
        creator = optional reader raw "creator";
        created = required reader string "created";
        modified = maybe reader string "modified";
        generator = optional reader raw "generator";
        was_attributed_to = optional reader raw "wasAttributedTo";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Annotation ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("@context", Some (json_string value.field_context));
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("id", Some (json_string value.id));
        ( "motivation",
          Some ((json_enum Enums.Motivation.to_string) value.motivation) );
        ("target", Some (json_raw value.target));
        ("body", present json_raw value.body);
        ("creator", present json_raw value.creator);
        ("created", Some (json_string value.created));
        ("modified", Option.map json_string value.modified);
        ("generator", present json_raw value.generator);
        ("wasAttributedTo", present json_raw value.was_attributed_to);
      ]
      value.extra

  let to_model value =
    Models.decode Models.annotation (Yojson.Raw.to_string (to_json value))
end

module Annotation_body_updated_payload = struct
  type t = {
    annotation_id : string;
    operations : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = required reader string "annotationId";
        operations = required reader raw "operations";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnnotationBodyUpdatedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Some (json_string value.annotation_id));
        ("operations", Some (json_raw value.operations));
      ]
      value.extra

  let to_model value =
    Models.decode Models.annotation_body_updated_payload
      (Yojson.Raw.to_string (to_json value))
end

module Annotation_removed_payload = struct
  type t = { annotation_id : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { annotation_id = required reader string "annotationId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnnotationRemovedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("annotationId", Some (json_string value.annotation_id)) ]
      value.extra

  let to_model value =
    Models.decode Models.annotation_removed_payload
      (Yojson.Raw.to_string (to_json value))
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
    selector : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = maybe reader (enum Type_.of_string) "type";
        source = required reader string "source";
        selector = optional reader raw "selector";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnnotationTarget ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Option.map (json_enum Type_.to_string) value.type_);
        ("source", Some (json_string value.source));
        ("selector", present json_raw value.selector);
      ]
      value.extra

  let to_model value =
    Models.decode Models.annotation_target
      (Yojson.Raw.to_string (to_json value))
end

module Beckon_focus_event = struct
  type t = {
    annotation_id : string option;
    resource_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = maybe reader string "annotationId";
        resource_id = required reader string "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BeckonFocusEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Option.map json_string value.annotation_id);
        ("resourceId", Some (json_string value.resource_id));
      ]
      value.extra

  let to_model value =
    Models.decode Models.beckon_focus_event
      (Yojson.Raw.to_string (to_json value))
end

module Beckon_hover_event = struct
  type t = {
    annotation_id : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = required reader (nullable string) "annotationId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BeckonHoverEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Some ((json_nullable json_string) value.annotation_id));
      ]
      value.extra

  let to_model value =
    Models.decode Models.beckon_hover_event
      (Yojson.Raw.to_string (to_json value))
end

module Beckon_sparkle_event = struct
  type t = { annotation_id : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { annotation_id = required reader string "annotationId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BeckonSparkleEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("annotationId", Some (json_string value.annotation_id)) ]
      value.extra

  let to_model value =
    Models.decode Models.beckon_sparkle_event
      (Yojson.Raw.to_string (to_json value))
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
    item : Yojson.Raw.t Types.presence;
    old_item : Yojson.Raw.t Types.presence;
    new_item : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        op = required reader (enum Op.of_string) "op";
        item = optional reader raw "item";
        old_item = optional reader raw "oldItem";
        new_item = optional reader raw "newItem";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BindBodyOperation ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("op", Some ((json_enum Op.to_string) value.op));
        ("item", present json_raw value.item);
        ("oldItem", present json_raw value.old_item);
        ("newItem", present json_raw value.new_item);
      ]
      value.extra

  let to_model value =
    Models.decode Models.bind_body_operation
      (Yojson.Raw.to_string (to_json value))
end

module Bind_initiate_command = struct
  type t = {
    annotation_id : string;
    resource_id : string;
    default_title : string;
    entity_types : string list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = required reader string "annotationId";
        resource_id = required reader string "resourceId";
        default_title = required reader string "defaultTitle";
        entity_types = required reader (list string) "entityTypes";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.bind_initiate_command
      (Yojson.Raw.to_string (to_json value))
end

module Body_operation_add = struct
  module Op = struct
    type t = Add

    let to_string = function Add -> "add"
    let of_string = function "add" -> Some Add | _ -> None
  end

  type t = {
    op : Op.t;
    item : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        op = required reader (enum Op.of_string) "op";
        item = required reader raw "item";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BodyOperationAdd ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("op", Some ((json_enum Op.to_string) value.op));
        ("item", Some (json_raw value.item));
      ]
      value.extra

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

  type t = {
    op : Op.t;
    item : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        op = required reader (enum Op.of_string) "op";
        item = required reader raw "item";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BodyOperationRemove ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("op", Some ((json_enum Op.to_string) value.op));
        ("item", Some (json_raw value.item));
      ]
      value.extra

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
    old_item : Yojson.Raw.t;
    new_item : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        op = required reader (enum Op.of_string) "op";
        old_item = required reader raw "oldItem";
        new_item = required reader raw "newItem";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BodyOperationReplace ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("op", Some ((json_enum Op.to_string) value.op));
        ("oldItem", Some (json_raw value.old_item));
        ("newItem", Some (json_raw value.new_item));
      ]
      value.extra

  let to_model value =
    Models.decode Models.body_operation_replace
      (Yojson.Raw.to_string (to_json value))
end

module Browse_engines_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseEnginesResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("response", Some (json_raw value.response)) ] value.extra

  let to_model value =
    Models.decode Models.browse_engines_result
      (Yojson.Raw.to_string (to_json value))
end

module Browse_profiles_request = struct
  type t = { dids : string list; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { dids = required reader (list string) "dids"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseProfilesRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("dids", Some ((json_list json_string) value.dids)) ] value.extra

  let to_model value =
    Models.decode Models.browse_profiles_request
      (Yojson.Raw.to_string (to_json value))
end

module Browse_profiles_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseProfilesResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("response", Some (json_raw value.response)) ] value.extra

  let to_model value =
    Models.decode Models.browse_profiles_result
      (Yojson.Raw.to_string (to_json value))
end

module Browse_annotation_history_request = struct
  type t = {
    resource_id : string;
    annotation_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        annotation_id = required reader string "annotationId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseAnnotationHistoryRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("annotationId", Some (json_string value.annotation_id));
      ]
      value.extra

  let to_model value =
    Models.decode Models.browse_annotation_history_request
      (Yojson.Raw.to_string (to_json value))
end

module Browse_annotation_request = struct
  type t = {
    resource_id : string;
    annotation_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        annotation_id = required reader string "annotationId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseAnnotationRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("annotationId", Some (json_string value.annotation_id));
      ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        x = required reader float "x";
        y = required reader float "y";
        width = required reader float "width";
        height = required reader float "height";
        top = required reader float "top";
        right = required reader float "right";
        bottom = required reader float "bottom";
        left = required reader float "left";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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

  type t = {
    path : string;
    sort : Sort.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        path = required reader string "path";
        sort = maybe reader (enum Sort.of_string) "sort";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseDirectoryRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("path", Some (json_string value.path));
        ("sort", Option.map (json_enum Sort.to_string) value.sort);
      ]
      value.extra

  let to_model value =
    Models.decode Models.browse_directory_request
      (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("path", Some (json_string value.path));
        ("entries", Some (json_raw value.entries));
      ]
      value.extra

  let to_model value =
    Models.decode Models.browse_directory_result_response
      (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write [ ("entityType", Some (json_string value.entity_type)) ] value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        type_ = maybe reader string "type";
        user_id = maybe reader string "userId";
        limit = maybe reader int "limit";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.browse_events_request
      (Yojson.Raw.to_string (to_json value))
end

module Browse_external_navigate_event = struct
  type t = {
    url : string;
    resource_id : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        url = required reader string "url";
        resource_id = maybe reader string "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseExternalNavigateEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("url", Some (json_string value.url));
        ("resourceId", Option.map json_string value.resource_id);
      ]
      value.extra

  let to_model value =
    Models.decode Models.browse_external_navigate_event
      (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("path", Some (json_string value.path));
        ("entries", Some (json_raw value.entries));
      ]
      value.extra

  let to_model value =
    Models.decode Models.browse_files_response
      (Yojson.Raw.to_string (to_json value))
end

module Browse_link_clicked_event = struct
  type t = {
    href : string;
    label : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        href = required reader string "href";
        label = maybe reader string "label";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseLinkClickedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("href", Some (json_string value.href));
        ("label", Option.map json_string value.label);
      ]
      value.extra

  let to_model value =
    Models.decode Models.browse_link_clicked_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_panel_open_event = struct
  type t = {
    panel : string;
    scroll_to_annotation_id : string option;
    motivation : Enums.Motivation.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        panel = required reader string "panel";
        scroll_to_annotation_id = maybe reader string "scrollToAnnotationId";
        motivation = maybe reader (enum Enums.Motivation.of_string) "motivation";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.browse_panel_open_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_panel_toggle_event = struct
  type t = { panel : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { panel = required reader string "panel"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowsePanelToggleEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("panel", Some (json_string value.panel)) ] value.extra

  let to_model value =
    Models.decode Models.browse_panel_toggle_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resource_open_event = struct
  type t = { resource_id : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader string "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourceOpenEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ] value.extra

  let to_model value =
    Models.decode Models.browse_resource_open_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resource_viewed_event = struct
  type t = { resource_id : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader string "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourceViewedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ] value.extra

  let to_model value =
    Models.decode Models.browse_resource_viewed_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resource_close_event = struct
  type t = { resource_id : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader string "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourceCloseEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ] value.extra

  let to_model value =
    Models.decode Models.browse_resource_close_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resource_reorder_event = struct
  type t = {
    old_index : int;
    new_index : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        old_index = required reader int "oldIndex";
        new_index = required reader int "newIndex";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourceReorderEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("oldIndex", Some (json_int value.old_index));
        ("newIndex", Some (json_int value.new_index));
      ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        start = required reader int "start";
        end_ = required reader int "end";
        page = required reader int "page";
        x = required reader float "x";
        y = required reader float "y";
        width = required reader float "width";
        height = required reader float "height";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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

  type t = { kind : Kind.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { kind = required reader (enum Kind.of_string) "kind"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnchoredTextAbsent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("kind", Some ((json_enum Kind.to_string) value.kind)) ] value.extra

  let to_model value =
    Models.decode Models.anchored_text_absent
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resource_request = struct
  type t = { resource_id : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader string "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourceRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ] value.extra

  let to_model value =
    Models.decode Models.browse_resource_request
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resource_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourceResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("response", Some (json_raw value.response)) ] value.extra

  let to_model value =
    Models.decode Models.browse_resource_result
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resources_request = struct
  type t = {
    archived : bool option;
    entity_type : string option;
    offset : int option;
    limit : int option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        archived = maybe reader bool "archived";
        entity_type = maybe reader string "entityType";
        offset = maybe reader int "offset";
        limit = maybe reader int "limit";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.browse_resources_request
      (Yojson.Raw.to_string (to_json value))
end

module Browse_router_push_event = struct
  type t = {
    path : string;
    reason : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        path = required reader string "path";
        reason = maybe reader string "reason";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseRouterPushEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("path", Some (json_string value.path));
        ("reason", Option.map json_string value.reason);
      ]
      value.extra

  let to_model value =
    Models.decode Models.browse_router_push_event
      (Yojson.Raw.to_string (to_json value))
end

module Bus_emit_accepted = struct
  type t = { subscribers : int option; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { subscribers = maybe reader int "subscribers"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `BusEmitAccepted ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("subscribers", Option.map json_int value.subscribers) ] value.extra

  let to_model value =
    Models.decode Models.bus_emit_accepted
      (Yojson.Raw.to_string (to_json value))
end

module Bus_emit_request = struct
  type t = {
    channel : string;
    payload : Yojson.Raw.t;
    scope : string option;
    client_id : string option;
    correlation_id : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        channel = required reader string "channel";
        payload = required reader raw "payload";
        scope = maybe reader string "scope";
        client_id = maybe reader string "clientId";
        correlation_id = maybe reader string "correlationId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BusEmitRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("channel", Some (json_string value.channel));
        ("payload", Some (json_raw value.payload));
        ("scope", Option.map json_string value.scope);
        ("clientId", Option.map json_string value.client_id);
        ("correlationId", Option.map json_string value.correlation_id);
      ]
      value.extra

  let to_model value =
    Models.decode Models.bus_emit_request (Yojson.Raw.to_string (to_json value))
end

module Bus_subscribe_request = struct
  type t = {
    global : string list option;
    pending_replies : string list option;
    scoped : Yojson.Raw.t Types.presence;
    client_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        global = maybe reader (list string) "global";
        pending_replies = maybe reader (list string) "pendingReplies";
        scoped = optional reader raw "scoped";
        client_id = required reader string "clientId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BusSubscribeRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("global", Option.map (json_list json_string) value.global);
        ( "pendingReplies",
          Option.map (json_list json_string) value.pending_replies );
        ("scoped", present json_raw value.scoped);
        ("clientId", Some (json_string value.client_id));
      ]
      value.extra

  let to_model value =
    Models.decode Models.bus_subscribe_request
      (Yojson.Raw.to_string (to_json value))
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

  type t = {
    code : Code.t option;
    message : string;
    details : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = maybe reader (enum Code.of_string) "code";
        message = required reader string "message";
        details = maybe reader string "details";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `CommandError ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Option.map (json_enum Code.to_string) value.code);
        ("message", Some (json_string value.message));
        ("details", Option.map json_string value.details);
      ]
      value.extra

  let to_model value =
    Models.decode Models.command_error (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("summary", Some (json_string value.summary));
        ("relevantFields", Some (json_raw value.relevant_fields));
        ("context", Some (json_raw value.context));
      ]
      value.extra

  let to_model value =
    Models.decode Models.contextual_summary_response
      (Yojson.Raw.to_string (to_json value))
end

module Create_resource_response = struct
  type t = { resource_id : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader string "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `CreateResourceResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ] value.extra

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

  type t = {
    type_ : Type_.t;
    name : string;
    path : string;
    mtime : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader (enum Type_.of_string) "type";
        name = required reader string "name";
        path = required reader string "path";
        mtime = required reader string "mtime";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.dir_entry (Yojson.Raw.to_string (to_json value))
end

module Discovered_kb = struct
  module Placement = struct
    type t = Local | Codespace

    let to_string = function Local -> "local" | Codespace -> "codespace"

    let of_string = function
      | "local" -> Some Local
      | "codespace" -> Some Codespace
      | _ -> None
  end

  type t = {
    host : string;
    port : int;
    placement : Placement.t;
    repo : string option;
    did : string;
    site_name : string option;
    managed_by : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        host = required reader string "host";
        port = required reader int "port";
        placement = required reader (enum Placement.of_string) "placement";
        repo = maybe reader string "repo";
        did = required reader string "did";
        site_name = maybe reader string "siteName";
        managed_by = required reader string "managedBy";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `DiscoveredKB ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("host", Some (json_string value.host));
        ("port", Some (json_int value.port));
        ("placement", Some ((json_enum Placement.to_string) value.placement));
        ("repo", Option.map json_string value.repo);
        ("did", Some (json_string value.did));
        ("siteName", Option.map json_string value.site_name);
        ("managedBy", Some (json_string value.managed_by));
      ]
      value.extra

  let to_model value =
    Models.decode Models.discovered_kb (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write [ ("entityType", Some (json_string value.entity_type)) ] value.extra

  let to_model value =
    Models.decode Models.entity_tag_changed_payload
      (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write [ ("entityType", Some (json_string value.entity_type)) ] value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        error = required reader string "error";
        code = maybe reader string "code";
        hint = maybe reader string "hint";
        details = optional reader raw "details";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.error_response (Yojson.Raw.to_string (to_json value))
end

module Event_metadata = struct
  type t = { sequence_number : int; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { sequence_number = required reader int "sequenceNumber"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `EventMetadata ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("sequenceNumber", Some (json_int value.sequence_number)) ]
      value.extra

  let to_model value =
    Models.decode Models.event_metadata (Yojson.Raw.to_string (to_json value))
end

module Ocr_confidence = struct
  type t = {
    mean : float;
    low_confidence_words : int;
    total_words : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        mean = required reader float "mean";
        low_confidence_words = required reader int "lowConfidenceWords";
        total_words = required reader int "totalWords";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `OcrConfidence ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("mean", Some (json_float value.mean));
        ("lowConfidenceWords", Some (json_int value.low_confidence_words));
        ("totalWords", Some (json_int value.total_words));
      ]
      value.extra

  let to_model value =
    Models.decode Models.ocr_confidence (Yojson.Raw.to_string (to_json value))
end

module Extraction_declined = struct
  module Kind = struct
    type t = Declined

    let to_string = function Declined -> "declined"
    let of_string = function "declined" -> Some Declined | _ -> None
  end

  type t = {
    kind : Kind.t;
    declined : Enums.Extraction_declined_reason.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kind = required reader (enum Kind.of_string) "kind";
        declined =
          required reader
            (enum Enums.Extraction_declined_reason.of_string)
            "declined";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
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
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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

  type t = {
    type_ : Type_.t;
    value : string;
    conforms_to : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader (enum Type_.of_string) "type";
        value = required reader string "value";
        conforms_to = maybe reader string "conformsTo";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `FragmentSelector ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("value", Some (json_string value.value));
        ("conformsTo", Option.map json_string value.conforms_to);
      ]
      value.extra

  let to_model value =
    Models.decode Models.fragment_selector
      (Yojson.Raw.to_string (to_json value))
end

module Frame_add_entity_type_command = struct
  type t = {
    tag : string;
    field_user_id : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        tag = required reader string "tag";
        field_user_id = maybe reader string "_userId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `FrameAddEntityTypeCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("tag", Some (json_string value.tag));
        ("_userId", Option.map json_string value.field_user_id);
      ]
      value.extra

  let to_model value =
    Models.decode Models.frame_add_entity_type_command
      (Yojson.Raw.to_string (to_json value))
end

module Gather_annotation_options = struct
  type t = {
    include_source_context : bool option;
    include_target_context : bool option;
    context_window : int option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        include_source_context = maybe reader bool "includeSourceContext";
        include_target_context = maybe reader bool "includeTargetContext";
        context_window = maybe reader int "contextWindow";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        depth = required reader int "depth";
        max_resources = required reader int "maxResources";
        include_content = required reader bool "includeContent";
        include_summary = required reader bool "includeSummary";
        exclude_entity_types = maybe reader (list string) "excludeEntityTypes";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.gather_resource_request_options
      (Yojson.Raw.to_string (to_json value))
end

module Gather_summary_request = struct
  type t = {
    annotation_id : string;
    resource_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = required reader string "annotationId";
        resource_id = required reader string "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherSummaryRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Some (json_string value.annotation_id));
        ("resourceId", Some (json_string value.resource_id));
      ]
      value.extra

  let to_model value =
    Models.decode Models.gather_summary_request
      (Yojson.Raw.to_string (to_json value))
end

module Gather_referenced_by_request = struct
  type t = {
    resource_id : string;
    motivation : Enums.Motivation.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        motivation = maybe reader (enum Enums.Motivation.of_string) "motivation";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherReferencedByRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ( "motivation",
          Option.map (json_enum Enums.Motivation.to_string) value.motivation );
      ]
      value.extra

  let to_model value =
    Models.decode Models.gather_referenced_by_request
      (Yojson.Raw.to_string (to_json value))
end

module Get_entity_types_response = struct
  type t = { entity_types : string list; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { entity_types = required reader (list string) "entityTypes"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetEntityTypesResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("entityTypes", Some ((json_list json_string) value.entity_types)) ]
      value.extra

  let to_model value =
    Models.decode Models.get_entity_types_response
      (Yojson.Raw.to_string (to_json value))
end

module Get_referenced_by_response_referenced_by_item = struct
  type t = {
    id : string;
    resource_name : string option;
    target : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader string "id";
        resource_name = maybe reader string "resourceName";
        target = required reader raw "target";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetReferencedByResponseReferencedByItem ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("resourceName", Option.map json_string value.resource_name);
        ("target", Some (json_raw value.target));
      ]
      value.extra

  let to_model value =
    Models.decode Models.get_referenced_by_response_referenced_by_item
      (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("status", Some (json_string value.status));
        ("message", Some (json_string value.message));
        ("version", Some (json_string value.version));
        ("timestamp", Some (json_string value.timestamp));
      ]
      value.extra

  let to_model value =
    Models.decode Models.health_response (Yojson.Raw.to_string (to_json value))
end

module Inference_limits = struct
  type t = {
    context_tokens : float;
    max_output_tokens : float;
    accepts_temperature : bool option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        context_tokens = required reader float "contextTokens";
        max_output_tokens = required reader float "maxOutputTokens";
        accepts_temperature = maybe reader bool "acceptsTemperature";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `InferenceLimits ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("contextTokens", Some (json_float value.context_tokens));
        ("maxOutputTokens", Some (json_float value.max_output_tokens));
        ("acceptsTemperature", Option.map json_bool value.accepts_temperature);
      ]
      value.extra

  let to_model value =
    Models.decode Models.inference_limits (Yojson.Raw.to_string (to_json value))
end

module Inference_limits_result = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `InferenceLimitsResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("response", Some (json_raw value.response)) ] value.extra

  let to_model value =
    Models.decode Models.inference_limits_result
      (Yojson.Raw.to_string (to_json value))
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
    metadata : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader string "id";
        type_ = required reader (enum Type_.of_string) "type";
        label = required reader string "label";
        entity_types = maybe reader (list string) "entityTypes";
        metadata = optional reader raw "metadata";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GraphResourceNode ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("label", Some (json_string value.label));
        ("entityTypes", Option.map (json_list json_string) value.entity_types);
        ("metadata", present json_raw value.metadata);
      ]
      value.extra

  let to_model value =
    Models.decode Models.graph_resource_node
      (Yojson.Raw.to_string (to_json value))
end

module Job_cancel_request = struct
  type t = { job_id : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { job_id = required reader string "jobId"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobCancelRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("jobId", Some (json_string value.job_id)) ] value.extra

  let to_model value =
    Models.decode Models.job_cancel_request
      (Yojson.Raw.to_string (to_json value))
end

module Job_cancel_command = struct
  type t = {
    field_user_id : string option;
    resource_id : string;
    job_id : string;
    job_type : Enums.Job_type.t;
    annotation_id : string option;
    completed_units : string list option;
    unit_cursors : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        resource_id = required reader string "resourceId";
        job_id = required reader string "jobId";
        job_type = required reader (enum Enums.Job_type.of_string) "jobType";
        annotation_id = maybe reader string "annotationId";
        completed_units = maybe reader (list string) "completedUnits";
        unit_cursors = optional reader raw "unitCursors";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("unitCursors", present json_raw value.unit_cursors);
      ]
      value.extra

  let to_model value =
    Models.decode Models.job_cancel_command
      (Yojson.Raw.to_string (to_json value))
end

module Job_claim_command = struct
  type t = {
    accepts : Yojson.Raw.t;
    field_user_id : string option;
    field_roles : string list option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        accepts = required reader raw "accepts";
        field_user_id = maybe reader string "_userId";
        field_roles = maybe reader (list string) "_roles";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobClaimCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("accepts", Some (json_raw value.accepts));
        ("_userId", Option.map json_string value.field_user_id);
        ("_roles", Option.map (json_list json_string) value.field_roles);
      ]
      value.extra

  let to_model value =
    Models.decode Models.job_claim_command
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
    result : Yojson.Raw.t Types.presence;
    durability : Enums.Durability_evidence.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_id = required reader string "jobId";
        job_type = required reader (enum Enums.Job_type.of_string) "jobType";
        attempt = maybe reader int "attempt";
        annotation_id = maybe reader string "annotationId";
        total_steps = maybe reader int "totalSteps";
        found_count = maybe reader int "foundCount";
        result_resource_id = maybe reader string "resultResourceId";
        annotation_uri = maybe reader string "annotationUri";
        result = optional reader raw "result";
        durability =
          maybe reader (enum Enums.Durability_evidence.of_string) "durability";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("result", present json_raw value.result);
        ( "durability",
          Option.map
            (json_enum Enums.Durability_evidence.to_string)
            value.durability );
      ]
      value.extra

  let to_model value =
    Models.decode Models.job_completed_payload
      (Yojson.Raw.to_string (to_json value))
end

module Job_created_result_response = struct
  type t = { job_id : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { job_id = required reader string "jobId"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobCreatedResultResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("jobId", Some (json_string value.job_id)) ] value.extra

  let to_model value =
    Models.decode Models.job_created_result_response
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
    unit_cursors : Yojson.Raw.t Types.presence;
    failure_class : Enums.Failure_class.t option;
    will_retry : bool option;
    durability : Enums.Durability_evidence.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        resource_id = required reader string "resourceId";
        job_id = required reader string "jobId";
        job_type = required reader (enum Enums.Job_type.of_string) "jobType";
        attempt = maybe reader int "attempt";
        annotation_id = maybe reader string "annotationId";
        error = required reader string "error";
        completed_units = maybe reader (list string) "completedUnits";
        unit_cursors = optional reader raw "unitCursors";
        failure_class =
          maybe reader (enum Enums.Failure_class.of_string) "failureClass";
        will_retry = maybe reader bool "willRetry";
        durability =
          maybe reader (enum Enums.Durability_evidence.of_string) "durability";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("unitCursors", present json_raw value.unit_cursors);
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
      value.extra

  let to_model value =
    Models.decode Models.job_fail_command (Yojson.Raw.to_string (to_json value))
end

module Job_checkpoint_command = struct
  type t = {
    field_user_id : string option;
    job_id : string;
    completed_units : string list;
    unit_cursors : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        job_id = required reader string "jobId";
        completed_units = required reader (list string) "completedUnits";
        unit_cursors = optional reader raw "unitCursors";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobCheckpointCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("jobId", Some (json_string value.job_id));
        ("completedUnits", Some ((json_list json_string) value.completed_units));
        ("unitCursors", present json_raw value.unit_cursors);
      ]
      value.extra

  let to_model value =
    Models.decode Models.job_checkpoint_command
      (Yojson.Raw.to_string (to_json value))
end

module Unit_cursor = struct
  type t = {
    next : int;
    size : int;
    found : int;
    emitted : int;
    errors : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        next = required reader int "next";
        size = required reader int "size";
        found = required reader int "found";
        emitted = required reader int "emitted";
        errors = required reader int "errors";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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

  type t = {
    declined : bool;
    reason : Reason.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        declined = required reader bool "declined";
        reason = required reader (enum Reason.of_string) "reason";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobDeclined ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("declined", Some (json_bool value.declined));
        ("reason", Some ((json_enum Reason.to_string) value.reason));
      ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
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
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.job_failed_payload
      (Yojson.Raw.to_string (to_json value))
end

module Yield_job_done = struct
  type t = {
    resource_id : string;
    resource_name : string;
    truncated : bool;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        resource_name = required reader string "resourceName";
        truncated = required reader bool "truncated";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldJobDone ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("resourceName", Some (json_string value.resource_name));
        ("truncated", Some (json_bool value.truncated));
      ]
      value.extra

  let to_model value =
    Models.decode Models.yield_job_done (Yojson.Raw.to_string (to_json value))
end

module Job_progress = struct
  type t = {
    percentage : float;
    message : Yojson.Raw.t Types.presence;
    annotation_id : string option;
    current : Yojson.Raw.t Types.presence;
    processed : int option;
    total : int option;
    entities_found : int option;
    entities_expected : int option;
    entities_emitted : int option;
    completed_items : Yojson.Raw.t Types.presence;
    request_params : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        percentage = required reader float "percentage";
        message = optional reader raw "message";
        annotation_id = maybe reader string "annotationId";
        current = optional reader raw "current";
        processed = maybe reader int "processed";
        total = maybe reader int "total";
        entities_found = maybe reader int "entitiesFound";
        entities_expected = maybe reader int "entitiesExpected";
        entities_emitted = maybe reader int "entitiesEmitted";
        completed_items = optional reader raw "completedItems";
        request_params = optional reader raw "requestParams";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgress ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("percentage", Some (json_float value.percentage));
        ("message", present json_raw value.message);
        ("annotationId", Option.map json_string value.annotation_id);
        ("current", present json_raw value.current);
        ("processed", Option.map json_int value.processed);
        ("total", Option.map json_int value.total);
        ("entitiesFound", Option.map json_int value.entities_found);
        ("entitiesExpected", Option.map json_int value.entities_expected);
        ("entitiesEmitted", Option.map json_int value.entities_emitted);
        ("completedItems", present json_raw value.completed_items);
        ("requestParams", present json_raw value.request_params);
      ]
      value.extra

  let to_model value =
    Models.decode Models.job_progress (Yojson.Raw.to_string (to_json value))
end

module Job_progress_analyzing = struct
  module Code = struct
    type t = Analyzing

    let to_string = function Analyzing -> "analyzing"
    let of_string = function "analyzing" -> Some Analyzing | _ -> None
  end

  type t = { code : Code.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { code = required reader (enum Code.of_string) "code"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressAnalyzing ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("code", Some ((json_enum Code.to_string) value.code)) ] value.extra

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

  type t = { code : Code.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { code = required reader (enum Code.of_string) "code"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressAnalyzingTags ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("code", Some ((json_enum Code.to_string) value.code)) ] value.extra

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

  type t = {
    code : Code.t;
    count : int;
    motivation : Enums.Motivation.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = required reader (enum Code.of_string) "code";
        count = required reader int "count";
        motivation =
          required reader (enum Enums.Motivation.of_string) "motivation";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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

  type t = {
    code : Code.t;
    truncated : bool;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = required reader (enum Code.of_string) "code";
        truncated = required reader bool "truncated";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressCompleteGenerated ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Some ((json_enum Code.to_string) value.code));
        ("truncated", Some (json_bool value.truncated));
      ]
      value.extra

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

  type t = { code : Code.t; count : int; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = required reader (enum Code.of_string) "code";
        count = required reader int "count";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressCreatingAnnotations ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Some ((json_enum Code.to_string) value.code));
        ("count", Some (json_int value.count));
      ]
      value.extra

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

  type t = { code : Code.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { code = required reader (enum Code.of_string) "code"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressCreatingResource ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("code", Some ((json_enum Code.to_string) value.code)) ] value.extra

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

  type t = { code : Code.t; count : int; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = required reader (enum Code.of_string) "code";
        count = required reader int "count";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressCreatingTagAnnotations ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Some ((json_enum Code.to_string) value.code));
        ("count", Some (json_int value.count));
      ]
      value.extra

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

  type t = {
    code : Code.t;
    entity_type : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = required reader (enum Code.of_string) "code";
        entity_type = required reader string "entityType";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressDetectingEntities ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("code", Some ((json_enum Code.to_string) value.code));
        ("entityType", Some (json_string value.entity_type));
      ]
      value.extra

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

  type t = { code : Code.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { code = required reader (enum Code.of_string) "code"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressGeneratingResource ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("code", Some ((json_enum Code.to_string) value.code)) ] value.extra

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

  type t = { code : Code.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { code = required reader (enum Code.of_string) "code"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobProgressLoading ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("code", Some ((json_enum Code.to_string) value.code)) ] value.extra

  let to_model value =
    Models.decode Models.job_progress_loading
      (Yojson.Raw.to_string (to_json value))
end

module Mark_job_done = struct
  type t = {
    found : int;
    persisted : int;
    errors : int option;
    by_category : Yojson.Raw.t Types.presence;
    under_reported_pieces : int option;
    unchecked_pieces : int option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        found = required reader int "found";
        persisted = required reader int "persisted";
        errors = maybe reader int "errors";
        by_category = optional reader raw "byCategory";
        under_reported_pieces = maybe reader int "underReportedPieces";
        unchecked_pieces = maybe reader int "uncheckedPieces";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkJobDone ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("found", Some (json_int value.found));
        ("persisted", Some (json_int value.persisted));
        ("errors", Option.map json_int value.errors);
        ("byCategory", present json_raw value.by_category);
        ("underReportedPieces", Option.map json_int value.under_reported_pieces);
        ("uncheckedPieces", Option.map json_int value.unchecked_pieces);
      ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        resource_id = required reader string "resourceId";
        job_id = required reader string "jobId";
        job_type = required reader (enum Enums.Job_type.of_string) "jobType";
        annotation_id = maybe reader string "annotationId";
        attempt = maybe reader int "attempt";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        job_id = required reader string "jobId";
        job_type = required reader (enum Enums.Job_type.of_string) "jobType";
        resource_id = required reader string "resourceId";
        holder = required reader string "holder";
        requester = required reader string "requester";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_id = required reader string "jobId";
        job_type = required reader (enum Enums.Job_type.of_string) "jobType";
        annotation_id = maybe reader string "annotationId";
        total_steps = maybe reader int "totalSteps";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_id = required reader string "jobId";
        job_type = required reader (enum Enums.Job_type.of_string) "jobType";
        resource_id = required reader string "resourceId";
        holder = required reader string "holder";
        requester = required reader string "requester";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.job_assigned_payload
      (Yojson.Raw.to_string (to_json value))
end

module Principal_profile_command = struct
  type t = {
    field_user_id : string option;
    name : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        name = required reader string "name";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `PrincipalProfileCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("name", Some (json_string value.name));
      ]
      value.extra

  let to_model value =
    Models.decode Models.principal_profile_command
      (Yojson.Raw.to_string (to_json value))
end

module Principal_profiled_payload = struct
  type t = { name : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { name = required reader string "name"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `PrincipalProfiledPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("name", Some (json_string value.name)) ] value.extra

  let to_model value =
    Models.decode Models.principal_profiled_payload
      (Yojson.Raw.to_string (to_json value))
end

module Job_status_request = struct
  type t = { job_id : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { job_id = required reader string "jobId"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobStatusRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("jobId", Some (json_string value.job_id)) ] value.extra

  let to_model value =
    Models.decode Models.job_status_request
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
    progress : Yojson.Raw.t Types.presence;
    result : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
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
        progress = optional reader raw "progress";
        result = optional reader raw "result";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("progress", present json_raw value.progress);
        ("result", present json_raw value.result);
      ]
      value.extra

  let to_model value =
    Models.decode Models.job_status_response
      (Yojson.Raw.to_string (to_json value))
end

module Kb_description = struct
  type t = {
    name : string;
    domain : string;
    git_branch : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        domain = required reader string "domain";
        git_branch = maybe reader string "gitBranch";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `KbDescription ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("domain", Some (json_string value.domain));
        ("gitBranch", Option.map json_string value.git_branch);
      ]
      value.extra

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

  type t = {
    kind : Kind.t;
    host : string;
    port : int;
    protocol : Protocol.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kind = required reader (enum Kind.of_string) "kind";
        host = required reader string "host";
        port = required reader int "port";
        protocol = required reader (enum Protocol.of_string) "protocol";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.http_endpoint (Yojson.Raw.to_string (to_json value))
end

module Kb_read = struct
  type t = {
    at : string;
    git_branch : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        at = required reader string "at";
        git_branch = maybe reader string "gitBranch";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `KbRead ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("at", Some (json_string value.at));
        ("gitBranch", Option.map json_string value.git_branch);
      ]
      value.extra

  let to_model value =
    Models.decode Models.kb_read (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("label", Some (json_string value.label));
        ("endpoint", Some (json_raw value.endpoint));
      ]
      value.extra

  let to_model value =
    Models.decode Models.kb_target (Yojson.Raw.to_string (to_json value))
end

module Local_endpoint = struct
  module Kind = struct
    type t = Local

    let to_string = function Local -> "local"
    let of_string = function "local" -> Some Local | _ -> None
  end

  type t = {
    kind : Kind.t;
    kb_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kind = required reader (enum Kind.of_string) "kind";
        kb_id = required reader string "kbId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LocalEndpoint ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("kbId", Some (json_string value.kb_id));
      ]
      value.extra

  let to_model value =
    Models.decode Models.local_endpoint (Yojson.Raw.to_string (to_json value))
end

module Knowledge_graph = struct
  type t = {
    nodes : Yojson.Raw.t;
    edges : Yojson.Raw.t;
    truncated : bool option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        nodes = required reader raw "nodes";
        edges = required reader raw "edges";
        truncated = maybe reader bool "truncated";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `KnowledgeGraph ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("nodes", Some (json_raw value.nodes));
        ("edges", Some (json_raw value.edges));
        ("truncated", Option.map json_bool value.truncated);
      ]
      value.extra

  let to_model value =
    Models.decode Models.knowledge_graph (Yojson.Raw.to_string (to_json value))
end

module Mark_archive_command = struct
  type t = {
    field_user_id : string option;
    resource_id : string;
    storage_uri : string option;
    keep_file : bool option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        resource_id = required reader string "resourceId";
        storage_uri = maybe reader string "storageUri";
        keep_file = maybe reader bool "keepFile";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.mark_archive_command
      (Yojson.Raw.to_string (to_json value))
end

module Mark_create_ok_response = struct
  type t = { annotation_id : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { annotation_id = required reader string "annotationId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkCreateOkResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("annotationId", Some (json_string value.annotation_id)) ]
      value.extra

  let to_model value =
    Models.decode Models.mark_create_ok_response
      (Yojson.Raw.to_string (to_json value))
end

module Mark_commit_ok = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `MarkCommitOk ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("response", Some (json_raw value.response)) ] value.extra

  let to_model value =
    Models.decode Models.mark_commit_ok (Yojson.Raw.to_string (to_json value))
end

module Mark_delete_command = struct
  type t = {
    field_user_id : string option;
    annotation_id : string;
    resource_id : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        annotation_id = required reader string "annotationId";
        resource_id = maybe reader string "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkDeleteCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("annotationId", Some (json_string value.annotation_id));
        ("resourceId", Option.map json_string value.resource_id);
      ]
      value.extra

  let to_model value =
    Models.decode Models.mark_delete_command
      (Yojson.Raw.to_string (to_json value))
end

module Mark_delete_ok = struct
  type t = { response : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { response = required reader raw "response"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `MarkDeleteOk ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("response", Some (json_raw value.response)) ] value.extra

  let to_model value =
    Models.decode Models.mark_delete_ok (Yojson.Raw.to_string (to_json value))
end

module Mark_requested_event = struct
  type t = {
    source : string;
    selector : Yojson.Raw.t;
    motivation : Enums.Motivation.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        source = required reader string "source";
        selector = required reader raw "selector";
        motivation =
          required reader (enum Enums.Motivation.of_string) "motivation";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkRequestedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("source", Some (json_string value.source));
        ("selector", Some (json_raw value.selector));
        ( "motivation",
          Some ((json_enum Enums.Motivation.to_string) value.motivation) );
      ]
      value.extra

  let to_model value =
    Models.decode Models.mark_requested_event
      (Yojson.Raw.to_string (to_json value))
end

module Mark_submit_event = struct
  type t = {
    source : string;
    motivation : Enums.Motivation.t;
    selector : Yojson.Raw.t;
    body : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        source = required reader string "source";
        motivation =
          required reader (enum Enums.Motivation.of_string) "motivation";
        selector = required reader raw "selector";
        body = optional reader raw "body";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkSubmitEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("source", Some (json_string value.source));
        ( "motivation",
          Some ((json_enum Enums.Motivation.to_string) value.motivation) );
        ("selector", Some (json_raw value.selector));
        ("body", present json_raw value.body);
      ]
      value.extra

  let to_model value =
    Models.decode Models.mark_submit_event
      (Yojson.Raw.to_string (to_json value))
end

module Mark_unarchive_command = struct
  type t = {
    field_user_id : string option;
    resource_id : string;
    storage_uri : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        resource_id = required reader string "resourceId";
        storage_uri = maybe reader string "storageUri";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkUnarchiveCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("resourceId", Some (json_string value.resource_id));
        ("storageUri", Option.map json_string value.storage_uri);
      ]
      value.extra

  let to_model value =
    Models.decode Models.mark_unarchive_command
      (Yojson.Raw.to_string (to_json value))
end

module Mark_update_body_command = struct
  type t = {
    field_user_id : string option;
    annotation_id : string;
    resource_id : string;
    operations : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        annotation_id = required reader string "annotationId";
        resource_id = required reader string "resourceId";
        operations = required reader raw "operations";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkUpdateBodyCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("annotationId", Some (json_string value.annotation_id));
        ("resourceId", Some (json_string value.resource_id));
        ("operations", Some (json_raw value.operations));
      ]
      value.extra

  let to_model value =
    Models.decode Models.mark_update_body_command
      (Yojson.Raw.to_string (to_json value))
end

module Mark_update_entity_types_command = struct
  type t = {
    resource_id : string;
    field_user_id : string option;
    current_entity_types : string list;
    updated_entity_types : string list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        field_user_id = maybe reader string "_userId";
        current_entity_types =
          required reader (list string) "currentEntityTypes";
        updated_entity_types =
          required reader (list string) "updatedEntityTypes";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = maybe reader (enum Code.of_string) "code";
        message = required reader string "message";
        details = maybe reader string "details";
        reference_id = required reader string "referenceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        search = required reader string "search";
        archived = maybe reader bool "archived";
        entity_type = maybe reader string "entityType";
        offset = maybe reader int "offset";
        limit = maybe reader int "limit";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.match_resources_request
      (Yojson.Raw.to_string (to_json value))
end

module Media_token_request = struct
  type t = { resource_id : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader string "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MediaTokenRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ] value.extra

  let to_model value =
    Models.decode Models.media_token_request
      (Yojson.Raw.to_string (to_json value))
end

module Media_token_response = struct
  type t = { token : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { token = required reader string "token"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `MediaTokenResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("token", Some (json_string value.token)) ] value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource = required reader string "resource";
        authorization_servers =
          required reader (list string) "authorization_servers";
        bearer_methods_supported =
          required reader
            (list (enum Bearer_methods_supported.of_string))
            "bearer_methods_supported";
        resource_name = maybe reader string "resource_name";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.protected_resource_metadata
      (Yojson.Raw.to_string (to_json value))
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
    field_type : Yojson.Raw.t Types.presence;
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
    conforms_to : Yojson.Raw.t Types.presence;
    tags : string list option;
    rel : Rel.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_id = maybe reader string "@id";
        field_type = optional reader raw "@type";
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
        conforms_to = optional reader raw "conformsTo";
        tags = maybe reader (list string) "tags";
        rel = maybe reader (enum Rel.of_string) "rel";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Representation ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("@id", Option.map json_string value.field_id);
        ("@type", present json_raw value.field_type);
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
        ("conformsTo", present json_raw value.conforms_to);
        ("tags", Option.map (json_list json_string) value.tags);
        ("rel", Option.map (json_enum Rel.to_string) value.rel);
      ]
      value.extra

  let to_model value =
    Models.decode Models.representation (Yojson.Raw.to_string (to_json value))
end

module Representation_removed_payload = struct
  type t = { checksum : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { checksum = required reader string "checksum"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `RepresentationRemovedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("checksum", Some (json_string value.checksum)) ] value.extra

  let to_model value =
    Models.decode Models.representation_removed_payload
      (Yojson.Raw.to_string (to_json value))
end

module Resource_archived_payload = struct
  type t = { reason : string option; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { reason = maybe reader string "reason"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceArchivedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("reason", Option.map json_string value.reason) ] value.extra

  let to_model value =
    Models.decode Models.resource_archived_payload
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
    creator : Yojson.Raw.t Types.presence;
    was_attributed_to : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        format = required reader string "format";
        content_checksum = required reader string "contentChecksum";
        content_byte_size = maybe reader int "contentByteSize";
        storage_uri = maybe reader string "storageUri";
        parent_resource_id = required reader string "parentResourceId";
        entity_types = maybe reader (list string) "entityTypes";
        language = maybe reader string "language";
        creator = optional reader raw "creator";
        was_attributed_to = optional reader raw "wasAttributedTo";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("creator", present json_raw value.creator);
        ("wasAttributedTo", present json_raw value.was_attributed_to);
      ]
      value.extra

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
    generated_from : Yojson.Raw.t Types.presence;
    generation_prompt : string option;
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
        format = required reader string "format";
        content_checksum = required reader string "contentChecksum";
        content_byte_size = maybe reader int "contentByteSize";
        entity_types = maybe reader (list string) "entityTypes";
        storage_uri = maybe reader string "storageUri";
        language = maybe reader string "language";
        is_draft = maybe reader bool "isDraft";
        job_id = maybe reader string "jobId";
        generated_from = optional reader raw "generatedFrom";
        generation_prompt = maybe reader string "generationPrompt";
        generator = optional reader raw "generator";
        creator = optional reader raw "creator";
        was_attributed_to = optional reader raw "wasAttributedTo";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("generatedFrom", present json_raw value.generated_from);
        ("generationPrompt", Option.map json_string value.generation_prompt);
        ("generator", present json_raw value.generator);
        ("creator", present json_raw value.creator);
        ("wasAttributedTo", present json_raw value.was_attributed_to);
      ]
      value.extra

  let to_model value =
    Models.decode Models.resource_created_payload
      (Yojson.Raw.to_string (to_json value))
end

module Resource_descriptor = struct
  type t = {
    field_context : Yojson.Raw.t;
    field_id : string;
    field_type : Yojson.Raw.t Types.presence;
    name : string;
    description : string option;
    identifier : Yojson.Raw.t Types.presence;
    about : Yojson.Raw.t Types.presence;
    same_as : string list option;
    is_part_of : string list option;
    has_part : string list option;
    license : string option;
    version : string option;
    date_created : string option;
    date_modified : string option;
    was_derived_from : Yojson.Raw.t Types.presence;
    was_attributed_to : Yojson.Raw.t Types.presence;
    generator : Yojson.Raw.t Types.presence;
    conforms_to : Yojson.Raw.t Types.presence;
    available_formats : string list option;
    representations : Yojson.Raw.t;
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
        field_context = required reader raw "@context";
        field_id = required reader string "@id";
        field_type = optional reader raw "@type";
        name = required reader string "name";
        description = maybe reader string "description";
        identifier = optional reader raw "identifier";
        about = optional reader raw "about";
        same_as = maybe reader (list string) "sameAs";
        is_part_of = maybe reader (list string) "isPartOf";
        has_part = maybe reader (list string) "hasPart";
        license = maybe reader string "license";
        version = maybe reader string "version";
        date_created = maybe reader string "dateCreated";
        date_modified = maybe reader string "dateModified";
        was_derived_from = optional reader raw "wasDerivedFrom";
        was_attributed_to = optional reader raw "wasAttributedTo";
        generator = optional reader raw "generator";
        conforms_to = optional reader raw "conformsTo";
        available_formats = maybe reader (list string) "availableFormats";
        representations = required reader raw "representations";
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
    write
      [
        ("@context", Some (json_raw value.field_context));
        ("@id", Some (json_string value.field_id));
        ("@type", present json_raw value.field_type);
        ("name", Some (json_string value.name));
        ("description", Option.map json_string value.description);
        ("identifier", present json_raw value.identifier);
        ("about", present json_raw value.about);
        ("sameAs", Option.map (json_list json_string) value.same_as);
        ("isPartOf", Option.map (json_list json_string) value.is_part_of);
        ("hasPart", Option.map (json_list json_string) value.has_part);
        ("license", Option.map json_string value.license);
        ("version", Option.map json_string value.version);
        ("dateCreated", Option.map json_string value.date_created);
        ("dateModified", Option.map json_string value.date_modified);
        ("wasDerivedFrom", present json_raw value.was_derived_from);
        ("wasAttributedTo", present json_raw value.was_attributed_to);
        ("generator", present json_raw value.generator);
        ("conformsTo", present json_raw value.conforms_to);
        ( "availableFormats",
          Option.map (json_list json_string) value.available_formats );
        ("representations", Some (json_raw value.representations));
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

  let to_json (value : t) =
    write
      [
        ("fromUri", Some (json_string value.from_uri));
        ("toUri", Some (json_string value.to_uri));
      ]
      value.extra

  let to_model value =
    Models.decode Models.resource_moved_payload
      (Yojson.Raw.to_string (to_json value))
end

module Resource_updated_payload = struct
  type t = {
    content_checksum : string;
    content_byte_size : int option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        content_checksum = required reader string "contentChecksum";
        content_byte_size = maybe reader int "contentByteSize";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceUpdatedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("contentChecksum", Some (json_string value.content_checksum));
        ("contentByteSize", Option.map json_int value.content_byte_size);
      ]
      value.extra

  let to_model value =
    Models.decode Models.resource_updated_payload
      (Yojson.Raw.to_string (to_json value))
end

module Scored_resource = struct
  type t = {
    field_context : Yojson.Raw.t;
    field_id : string;
    field_type : Yojson.Raw.t Types.presence;
    name : string;
    description : string option;
    identifier : Yojson.Raw.t Types.presence;
    about : Yojson.Raw.t Types.presence;
    same_as : string list option;
    is_part_of : string list option;
    has_part : string list option;
    license : string option;
    version : string option;
    date_created : string option;
    date_modified : string option;
    was_derived_from : Yojson.Raw.t Types.presence;
    was_attributed_to : Yojson.Raw.t Types.presence;
    generator : Yojson.Raw.t Types.presence;
    conforms_to : Yojson.Raw.t Types.presence;
    available_formats : string list option;
    representations : Yojson.Raw.t;
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
        field_context = required reader raw "@context";
        field_id = required reader string "@id";
        field_type = optional reader raw "@type";
        name = required reader string "name";
        description = maybe reader string "description";
        identifier = optional reader raw "identifier";
        about = optional reader raw "about";
        same_as = maybe reader (list string) "sameAs";
        is_part_of = maybe reader (list string) "isPartOf";
        has_part = maybe reader (list string) "hasPart";
        license = maybe reader string "license";
        version = maybe reader string "version";
        date_created = maybe reader string "dateCreated";
        date_modified = maybe reader string "dateModified";
        was_derived_from = optional reader raw "wasDerivedFrom";
        was_attributed_to = optional reader raw "wasAttributedTo";
        generator = optional reader raw "generator";
        conforms_to = optional reader raw "conformsTo";
        available_formats = maybe reader (list string) "availableFormats";
        representations = required reader raw "representations";
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
    write
      [
        ("@context", Some (json_raw value.field_context));
        ("@id", Some (json_string value.field_id));
        ("@type", present json_raw value.field_type);
        ("name", Some (json_string value.name));
        ("description", Option.map json_string value.description);
        ("identifier", present json_raw value.identifier);
        ("about", present json_raw value.about);
        ("sameAs", Option.map (json_list json_string) value.same_as);
        ("isPartOf", Option.map (json_list json_string) value.is_part_of);
        ("hasPart", Option.map (json_list json_string) value.has_part);
        ("license", Option.map json_string value.license);
        ("version", Option.map json_string value.version);
        ("dateCreated", Option.map json_string value.date_created);
        ("dateModified", Option.map json_string value.date_modified);
        ("wasDerivedFrom", present json_raw value.was_derived_from);
        ("wasAttributedTo", present json_raw value.was_attributed_to);
        ("generator", present json_raw value.generator);
        ("conformsTo", present json_raw value.conforms_to);
        ( "availableFormats",
          Option.map (json_list json_string) value.available_formats );
        ("representations", Some (json_raw value.representations));
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

module Semantic_match = struct
  type t = {
    text : string;
    resource_id : string;
    resource_name : string;
    annotation_id : string option;
    score : float;
    entity_types : string list option;
    machine_read : bool option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        text = required reader string "text";
        resource_id = required reader string "resourceId";
        resource_name = required reader string "resourceName";
        annotation_id = maybe reader string "annotationId";
        score = required reader float "score";
        entity_types = maybe reader (list string) "entityTypes";
        machine_read = maybe reader bool "machineRead";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.semantic_match (Yojson.Raw.to_string (to_json value))
end

module Session_joined_event = struct
  type t = {
    participant : string;
    connection_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        participant = required reader string "participant";
        connection_id = required reader string "connectionId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SessionJoinedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("participant", Some (json_string value.participant));
        ("connectionId", Some (json_string value.connection_id));
      ]
      value.extra

  let to_model value =
    Models.decode Models.session_joined_event
      (Yojson.Raw.to_string (to_json value))
end

module Session_left_event = struct
  type t = {
    participant : string;
    connection_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        participant = required reader string "participant";
        connection_id = required reader string "connectionId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SessionLeftEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("participant", Some (json_string value.participant));
        ("connectionId", Some (json_string value.connection_id));
      ]
      value.extra

  let to_model value =
    Models.decode Models.session_left_event
      (Yojson.Raw.to_string (to_json value))
end

module Settings_hover_delay_changed_event = struct
  type t = { hover_delay_ms : int; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { hover_delay_ms = required reader int "hoverDelayMs"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsHoverDelayChangedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("hoverDelayMs", Some (json_int value.hover_delay_ms)) ] value.extra

  let to_model value =
    Models.decode Models.settings_hover_delay_changed_event
      (Yojson.Raw.to_string (to_json value))
end

module Settings_locale_changed_event = struct
  type t = { locale : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { locale = required reader string "locale"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsLocaleChangedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("locale", Some (json_string value.locale)) ] value.extra

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

  type t = { theme : Theme.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { theme = required reader (enum Theme.of_string) "theme"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsThemeChangedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("theme", Some ((json_enum Theme.to_string) value.theme)) ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader (enum Type_.of_string) "type";
        source = required reader string "source";
        purpose = maybe reader (enum Enums.Body_purpose.of_string) "purpose";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.specific_resource
      (Yojson.Raw.to_string (to_json value))
end

module Status_response = struct
  type t = {
    status : string;
    version : string;
    features : Yojson.Raw.t;
    message : string;
    authenticated_as : string option;
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
        authenticated_as = maybe reader string "authenticatedAs";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StatusResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some (json_string value.status));
        ("version", Some (json_string value.version));
        ("features", Some (json_raw value.features));
        ("message", Some (json_string value.message));
        ("authenticatedAs", Option.map json_string value.authenticated_as);
      ]
      value.extra

  let to_model value =
    Models.decode Models.status_response (Yojson.Raw.to_string (to_json value))
end

module Svg_selector = struct
  module Type_ = struct
    type t = SvgSelector

    let to_string = function SvgSelector -> "SvgSelector"
    let of_string = function "SvgSelector" -> Some SvgSelector | _ -> None
  end

  type t = {
    type_ : Type_.t;
    value : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader (enum Type_.of_string) "type";
        value = required reader string "value";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SvgSelector ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("value", Some (json_string value.value));
      ]
      value.extra

  let to_model value =
    Models.decode Models.svg_selector (Yojson.Raw.to_string (to_json value))
end

module Tag_category = struct
  type t = {
    name : string;
    description : string;
    examples : string list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        description = required reader string "description";
        examples = required reader (list string) "examples";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `TagCategory ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("description", Some (json_string value.description));
        ("examples", Some ((json_list json_string) value.examples));
      ]
      value.extra

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

  type t = {
    type_ : Type_.t;
    start : int;
    end_ : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader (enum Type_.of_string) "type";
        start = required reader int "start";
        end_ = required reader int "end";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `TextPositionSelector ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("start", Some (json_int value.start));
        ("end", Some (json_int value.end_));
      ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader (enum Type_.of_string) "type";
        exact = required reader string "exact";
        prefix = maybe reader string "prefix";
        suffix = maybe reader string "suffix";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader (enum Type_.of_string) "type";
        value = required reader string "value";
        purpose = maybe reader (enum Enums.Body_purpose.of_string) "purpose";
        format = maybe reader string "format";
        language = maybe reader string "language";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.textual_body (Yojson.Raw.to_string (to_json value))
end

module Update_annotation_body_request = struct
  type t = {
    resource_id : string;
    operations : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        operations = required reader raw "operations";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `UpdateAnnotationBodyRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("operations", Some (json_raw value.operations));
      ]
      value.extra

  let to_model value =
    Models.decode Models.update_annotation_body_request
      (Yojson.Raw.to_string (to_json value))
end

module User_response = struct
  type t = {
    did : string;
    email : string option;
    name : string option;
    image : string option;
    domain : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        did = required reader string "did";
        email = required reader (nullable string) "email";
        name = required reader (nullable string) "name";
        image = required reader (nullable string) "image";
        domain = required reader string "domain";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.user_response (Yojson.Raw.to_string (to_json value))
end

module Smelt_rebuild_anchors_command = struct
  type t = {
    resource_id : string option;
    field_user_id : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = maybe reader string "resourceId";
        field_user_id = maybe reader string "_userId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SmeltRebuildAnchorsCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Option.map json_string value.resource_id);
        ("_userId", Option.map json_string value.field_user_id);
      ]
      value.extra

  let to_model value =
    Models.decode Models.smelt_rebuild_anchors_command
      (Yojson.Raw.to_string (to_json value))
end

module Weave_rebuild_command = struct
  type t = {
    resource_id : string option;
    field_user_id : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = maybe reader string "resourceId";
        field_user_id = maybe reader string "_userId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WeaveRebuildCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Option.map json_string value.resource_id);
        ("_userId", Option.map json_string value.field_user_id);
      ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        token = required reader string "token";
        name = required reader string "name";
        storage_uri = required reader string "storageUri";
        content_checksum = required reader string "contentChecksum";
        byte_size = required reader int "byteSize";
        format = required reader string "format";
        archive_original = maybe reader bool "archiveOriginal";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.yield_clone_create_command
      (Yojson.Raw.to_string (to_json value))
end

module Yield_clone_resource_request = struct
  type t = { token : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { token = required reader string "token"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `YieldCloneResourceRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("token", Some (json_string value.token)) ] value.extra

  let to_model value =
    Models.decode Models.yield_clone_resource_request
      (Yojson.Raw.to_string (to_json value))
end

module Yield_clone_token_request = struct
  type t = { resource_id : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader string "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldCloneTokenRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ] value.extra

  let to_model value =
    Models.decode Models.yield_clone_token_request
      (Yojson.Raw.to_string (to_json value))
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
    generated_from : Yojson.Raw.t Types.presence;
    generation_prompt : string option;
    generator : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
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
        generated_from = optional reader raw "generatedFrom";
        generation_prompt = maybe reader string "generationPrompt";
        generator = optional reader raw "generator";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("generatedFrom", present json_raw value.generated_from);
        ("generationPrompt", Option.map json_string value.generation_prompt);
        ("generator", present json_raw value.generator);
      ]
      value.extra

  let to_model value =
    Models.decode Models.yield_create_command
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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
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
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        resource_id = required reader string "resourceId";
        storage_uri = required reader string "storageUri";
        content_checksum = required reader string "contentChecksum";
        byte_size = required reader int "byteSize";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.yield_update_command
      (Yojson.Raw.to_string (to_json value))
end

module Yielded_resource = struct
  type t = { resource_id : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { resource_id = required reader string "resourceId"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldedResource ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("resourceId", Some (json_string value.resource_id)) ] value.extra

  let to_model value =
    Models.decode Models.yielded_resource (Yojson.Raw.to_string (to_json value))
end

module Bus_frame = struct
  type t = {
    channel : string;
    correlation_id : string option;
    payload : Yojson.Raw.t;
    scope : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        channel = required reader string "channel";
        correlation_id = maybe reader string "correlationId";
        payload = required reader raw "payload";
        scope = maybe reader string "scope";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BusFrame ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("channel", Some (json_string value.channel));
        ("correlationId", Option.map json_string value.correlation_id);
        ("payload", Some (json_raw value.payload));
        ("scope", Option.map json_string value.scope);
      ]
      value.extra

  let to_model value =
    Models.decode Models.bus_frame (Yojson.Raw.to_string (to_json value))
end

module Bus_ping_message = struct
  module Event = struct
    type t = Ping

    let to_string = function Ping -> "ping"
    let of_string = function "ping" -> Some Ping | _ -> None
  end

  type t = {
    event : Event.t;
    data : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        event = required reader (enum Event.of_string) "event";
        data = required reader string "data";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BusPingMessage ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("event", Some ((json_enum Event.to_string) value.event));
        ("data", Some (json_string value.data));
      ]
      value.extra

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

  type t = {
    scope : string;
    last_seen_id : string;
    reason : Reason.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        scope = required reader string "scope";
        last_seen_id = required reader string "lastSeenId";
        reason = required reader (enum Reason.of_string) "reason";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BusResumeGap ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("scope", Some (json_string value.scope));
        ("lastSeenId", Some (json_string value.last_seen_id));
        ("reason", Some ((json_enum Reason.to_string) value.reason));
      ]
      value.extra

  let to_model value =
    Models.decode Models.bus_resume_gap (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("domain", Some (json_string value.domain));
      ]
      value.extra

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
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.resource_upload (Yojson.Raw.to_string (to_json value))
end

module Limit_refusal = struct
  type t = {
    error : string;
    code : Yojson.Raw.t;
    hint : string option;
    details : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        error = required reader string "error";
        code = required reader raw "code";
        hint = maybe reader string "hint";
        details = optional reader raw "details";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LimitRefusal ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("error", Some (json_string value.error));
        ("code", Some (json_raw value.code));
        ("hint", Option.map json_string value.hint);
        ("details", present json_raw value.details);
      ]
      value.extra

  let to_model value =
    Models.decode Models.limit_refusal (Yojson.Raw.to_string (to_json value))
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
    unit_cursors : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader string "id";
        type_ = required reader (enum Enums.Job_type.of_string) "type";
        user_id = required reader string "userId";
        created = required reader string "created";
        retry_count = required reader int "retryCount";
        max_retries = required reader int "maxRetries";
        completed_units = maybe reader (list string) "completedUnits";
        unit_cursors = optional reader raw "unitCursors";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("unitCursors", present json_raw value.unit_cursors);
      ]
      value.extra

  let to_model value =
    Models.decode Models.job_metadata (Yojson.Raw.to_string (to_json value))
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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        motivation = required reader (enum Motivation.of_string) "motivation";
        instructions = maybe reader string "instructions";
        density = maybe reader float "density";
        source_language = maybe reader string "sourceLanguage";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        motivation = required reader (enum Motivation.of_string) "motivation";
        instructions = maybe reader string "instructions";
        tone = maybe reader (enum Tone.of_string) "tone";
        density = maybe reader float "density";
        language = maybe reader string "language";
        source_language = maybe reader string "sourceLanguage";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        motivation = required reader (enum Motivation.of_string) "motivation";
        instructions = maybe reader string "instructions";
        tone = maybe reader (enum Tone.of_string) "tone";
        density = maybe reader float "density";
        language = maybe reader string "language";
        source_language = maybe reader string "sourceLanguage";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        motivation = required reader (enum Motivation.of_string) "motivation";
        entity_types = required reader (list string) "entityTypes";
        include_descriptive_references =
          maybe reader bool "includeDescriptiveReferences";
        language = maybe reader string "language";
        source_language = maybe reader string "sourceLanguage";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        motivation = required reader (enum Motivation.of_string) "motivation";
        schema_id = required reader string "schemaId";
        categories = required reader (list string) "categories";
        language = maybe reader string "language";
        source_language = maybe reader string "sourceLanguage";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
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
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.generation_job_request
      (Yojson.Raw.to_string (to_json value))
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
    params : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        field_roles = maybe reader (list string) "_roles";
        job_type = required reader (enum Job_type.of_string) "jobType";
        resource_id = required reader string "resourceId";
        params = required reader raw "params";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkJobCreateCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("_userId", Option.map json_string value.field_user_id);
        ("_roles", Option.map (json_list json_string) value.field_roles);
        ("jobType", Some ((json_enum Job_type.to_string) value.job_type));
        ("resourceId", Some (json_string value.resource_id));
        ("params", Some (json_raw value.params));
      ]
      value.extra

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
    params : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_id = required reader string "jobId";
        job_type = required reader (enum Job_type.of_string) "jobType";
        resource_id = required reader string "resourceId";
        user_id = required reader string "userId";
        params = required reader raw "params";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkJobQueuedEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("jobId", Some (json_string value.job_id));
        ("jobType", Some ((json_enum Job_type.to_string) value.job_type));
        ("resourceId", Some (json_string value.resource_id));
        ("userId", Some (json_string value.user_id));
        ("params", Some (json_raw value.params));
      ]
      value.extra

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
    result : Yojson.Raw.t Types.presence;
    durability : Enums.Durability_evidence.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        resource_id = required reader string "resourceId";
        job_id = required reader string "jobId";
        job_type = required reader (enum Job_type.of_string) "jobType";
        attempt = maybe reader int "attempt";
        result = optional reader raw "result";
        durability =
          maybe reader (enum Enums.Durability_evidence.of_string) "durability";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("result", present json_raw value.result);
        ( "durability",
          Option.map
            (json_enum Enums.Durability_evidence.to_string)
            value.durability );
      ]
      value.extra

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
    result : Yojson.Raw.t Types.presence;
    durability : Enums.Durability_evidence.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        resource_id = required reader string "resourceId";
        job_id = required reader string "jobId";
        job_type = required reader (enum Job_type.of_string) "jobType";
        attempt = maybe reader int "attempt";
        annotation_id = maybe reader string "annotationId";
        result = optional reader raw "result";
        durability =
          maybe reader (enum Enums.Durability_evidence.of_string) "durability";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("result", present json_raw value.result);
        ( "durability",
          Option.map
            (json_enum Enums.Durability_evidence.to_string)
            value.durability );
      ]
      value.extra

  let to_model value =
    Models.decode Models.yield_job_complete_command
      (Yojson.Raw.to_string (to_json value))
end

module Mark_job_filter = struct
  module Job_type = struct
    type t = Mark

    let to_string = function Mark -> "mark"
    let of_string = function "mark" -> Some Mark | _ -> None
  end

  type t = {
    job_type : Job_type.t;
    params : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_type = required reader (enum Job_type.of_string) "jobType";
        params = required reader raw "params";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkJobFilter ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("jobType", Some ((json_enum Job_type.to_string) value.job_type));
        ("params", Some (json_raw value.params));
      ]
      value.extra

  let to_model value =
    Models.decode Models.mark_job_filter (Yojson.Raw.to_string (to_json value))
end

module Yield_job_filter = struct
  module Job_type = struct
    type t = Yield

    let to_string = function Yield -> "yield"
    let of_string = function "yield" -> Some Yield | _ -> None
  end

  type t = { job_type : Job_type.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_type = required reader (enum Job_type.of_string) "jobType";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldJobFilter ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("jobType", Some ((json_enum Job_type.to_string) value.job_type)) ]
      value.extra

  let to_model value =
    Models.decode Models.yield_job_filter (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("job", Some (json_raw value.job));
        ("lastProgressAt", Some (json_string value.last_progress_at));
      ]
      value.extra

  let to_model value =
    Models.decode Models.job_record (Yojson.Raw.to_string (to_json value))
end

module Service_identity = struct
  type t = { issuer : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { issuer = required reader string "issuer"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceIdentity ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("issuer", Some (json_string value.issuer)) ] value.extra

  let to_model value =
    Models.decode Models.service_identity (Yojson.Raw.to_string (to_json value))
end

module Service_address = struct
  type t = { host : string; port : int; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      {
        host = required reader string "host";
        port = required reader int "port";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceAddress ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("host", Some (json_string value.host));
        ("port", Some (json_int value.port));
      ]
      value.extra

  let to_model value =
    Models.decode Models.service_address (Yojson.Raw.to_string (to_json value))
end

module Entity_types_projection = struct
  type t = { entity_types : string list; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { entity_types = required reader (list string) "entityTypes"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `EntityTypesProjection ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("entityTypes", Some ((json_list json_string) value.entity_types)) ]
      value.extra

  let to_model value =
    Models.decode Models.entity_types_projection
      (Yojson.Raw.to_string (to_json value))
end

module Profiles_projection = struct
  type t = { profiles : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { profiles = required reader raw "profiles"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `ProfilesProjection ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("profiles", Some (json_raw value.profiles)) ] value.extra

  let to_model value =
    Models.decode Models.profiles_projection
      (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("since", Some (json_string value.since));
      ]
      value.extra

  let to_model value =
    Models.decode Models.profile (Yojson.Raw.to_string (to_json value))
end

module Storage_uri_entry = struct
  type t = {
    uri : string;
    resource_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        uri = required reader string "uri";
        resource_id = required reader string "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StorageUriEntry ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("uri", Some (json_string value.uri));
        ("resourceId", Some (json_string value.resource_id));
      ]
      value.extra

  let to_model value =
    Models.decode Models.storage_uri_entry
      (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("jobs", Some (json_raw value.jobs));
        ("actors", Some (json_raw value.actors));
      ]
      value.extra

  let to_model value =
    Models.decode Models.archivist_engines
      (Yojson.Raw.to_string (to_json value))
end

module Engine = struct
  module Provider = struct
    type t = Anthropic | Google | Llamacpp | Ollama | Openai | Together | Vllm

    let to_string = function
      | Anthropic -> "anthropic"
      | Google -> "google"
      | Llamacpp -> "llamacpp"
      | Ollama -> "ollama"
      | Openai -> "openai"
      | Together -> "together"
      | Vllm -> "vllm"

    let of_string = function
      | "anthropic" -> Some Anthropic
      | "google" -> Some Google
      | "llamacpp" -> Some Llamacpp
      | "ollama" -> Some Ollama
      | "openai" -> Some Openai
      | "together" -> Some Together
      | "vllm" -> Some Vllm
      | _ -> None
  end

  type t = {
    provider : Provider.t;
    model : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        provider = required reader (enum Provider.of_string) "provider";
        model = required reader string "model";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Engine ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("provider", Some ((json_enum Provider.to_string) value.provider));
        ("model", Some (json_string value.model));
      ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = maybe reader (enum Code.of_string) "code";
        message = required reader string "message";
        details = maybe reader string "details";
        annotation_id = required reader string "annotationId";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = maybe reader (enum Code.of_string) "code";
        message = required reader string "message";
        details = maybe reader string "details";
        resource_id = required reader string "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = maybe reader (enum Code.of_string) "code";
        message = required reader string "message";
        details = maybe reader string "details";
        path = required reader string "path";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.browse_directory_failed
      (Yojson.Raw.to_string (to_json value))
end

module Mark_delegate_timeout_event = struct
  type t = {
    resource_id : string;
    motivation : Enums.Motivation.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        motivation =
          required reader (enum Enums.Motivation.of_string) "motivation";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkDelegateTimeoutEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ( "motivation",
          Some ((json_enum Enums.Motivation.to_string) value.motivation) );
      ]
      value.extra

  let to_model value =
    Models.decode Models.mark_delegate_timeout_event
      (Yojson.Raw.to_string (to_json value))
end

module Resource_error_event = struct
  type t = {
    resource_id : string;
    message : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        message = required reader string "message";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceErrorEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("message", Some (json_string value.message));
      ]
      value.extra

  let to_model value =
    Models.decode Models.resource_error_event
      (Yojson.Raw.to_string (to_json value))
end

module Job_cancel_result = struct
  type t = { cancelled : bool; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { cancelled = required reader bool "cancelled"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `JobCancelResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("cancelled", Some (json_bool value.cancelled)) ] value.extra

  let to_model value =
    Models.decode Models.job_cancel_result
      (Yojson.Raw.to_string (to_json value))
end

module Weave_applied = struct
  type t = {
    resource_id : string;
    sequence_number : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        sequence_number = required reader int "sequenceNumber";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WeaveApplied ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("sequenceNumber", Some (json_int value.sequence_number));
      ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        content_checksum = required reader string "contentChecksum";
        outcome = required reader (enum Outcome.of_string) "outcome";
        reason = maybe reader (enum Reason.of_string) "reason";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.smelt_settled (Yojson.Raw.to_string (to_json value))
end

module Anchored_text_declined_entry = struct
  type t = {
    v : int;
    stamp : string;
    declined : Enums.Extraction_declined_reason.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        v = required reader int "v";
        stamp = required reader string "stamp";
        declined =
          required reader
            (enum Enums.Extraction_declined_reason.of_string)
            "declined";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.anchored_text_declined_entry
      (Yojson.Raw.to_string (to_json value))
end

module Anchored_text_entries = struct
  type t = { checksums : string list; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { checksums = required reader (list string) "checksums"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnchoredTextEntries ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("checksums", Some ((json_list json_string) value.checksums)) ]
      value.extra

  let to_model value =
    Models.decode Models.anchored_text_entries
      (Yojson.Raw.to_string (to_json value))
end

module Anchored_text_stamp = struct
  type t = { stamp : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { stamp = required reader string "stamp"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `AnchoredTextStamp ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("stamp", Some (json_string value.stamp)) ] value.extra

  let to_model value =
    Models.decode Models.anchored_text_stamp
      (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("contentChecksum", Some (json_string value.content_checksum));
        ("entry", Some (json_raw value.entry));
      ]
      value.extra

  let to_model value =
    Models.decode Models.anchored_text_write
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

  type t = {
    status : Status.t;
    actors : Actors.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader (enum Status.of_string) "status";
        actors = required reader (list (enum Actors.of_string)) "actors";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ArchivistHealth ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("actors", Some ((json_list (json_enum Actors.to_string)) value.actors));
      ]
      value.extra

  let to_model value =
    Models.decode Models.archivist_health (Yojson.Raw.to_string (to_json value))
end

module Archivist_stream = struct
  type t = {
    resource_id : string;
    last_sequence : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        last_sequence = required reader int "lastSequence";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ArchivistStream ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("lastSequence", Some (json_int value.last_sequence));
      ]
      value.extra

  let to_model value =
    Models.decode Models.archivist_stream (Yojson.Raw.to_string (to_json value))
end

module Representation_not_found = struct
  type t = {
    error : string;
    code : Yojson.Raw.t;
    hint : string option;
    details : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        error = required reader string "error";
        code = required reader raw "code";
        hint = maybe reader string "hint";
        details = optional reader raw "details";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RepresentationNotFound ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("error", Some (json_string value.error));
        ("code", Some (json_raw value.code));
        ("hint", Option.map json_string value.hint);
        ("details", present json_raw value.details);
      ]
      value.extra

  let to_model value =
    Models.decode Models.representation_not_found
      (Yojson.Raw.to_string (to_json value))
end

module Retry_budget = struct
  type t = {
    attempts : int;
    initial_delay_ms : int;
    max_delay_ms : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        attempts = required reader int "attempts";
        initial_delay_ms = required reader int "initialDelayMs";
        max_delay_ms = required reader int "maxDelayMs";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RetryBudget ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("attempts", Some (json_int value.attempts));
        ("initialDelayMs", Some (json_int value.initial_delay_ms));
        ("maxDelayMs", Some (json_int value.max_delay_ms));
      ]
      value.extra

  let to_model value =
    Models.decode Models.retry_budget (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("fetch", Some (json_string value.fetch));
        ("payload", present json_raw value.payload);
        ("as", Some (json_string value.as_));
      ]
      value.extra

  let to_model value =
    Models.decode Models.conformance_bus_fetch
      (Yojson.Raw.to_string (to_json value))
end

module Conformance_case = struct
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
    planes : Yojson.Raw.t Types.presence;
    tier : Tier.t option;
    telemetry : bool option;
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
        tier = maybe reader (enum Tier.of_string) "tier";
        telemetry = maybe reader bool "telemetry";
        steps = required reader raw "steps";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ConformanceCase ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("about", Some (json_string value.about));
        ("source", Some (json_string value.source));
        ("planes", present json_raw value.planes);
        ("tier", Option.map (json_enum Tier.to_string) value.tier);
        ("telemetry", Option.map json_bool value.telemetry);
        ("steps", Some (json_raw value.steps));
      ]
      value.extra

  let to_model value =
    Models.decode Models.conformance_case (Yojson.Raw.to_string (to_json value))
end

module Conformance_failure = struct
  type t = {
    code : string option;
    status : int option;
    failure_class : Enums.Failure_class.t option;
    detail : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = maybe reader string "code";
        status = maybe reader int "status";
        failure_class =
          maybe reader (enum Enums.Failure_class.of_string) "failureClass";
        detail = required reader string "detail";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.conformance_failure
      (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("fetch", Some (json_string value.fetch));
        ("params", present json_raw value.params);
      ]
      value.extra

  let to_model value =
    Models.decode Models.conformance_http_fetch
      (Yojson.Raw.to_string (to_json value))
end

module About_params = struct
  type t = { api_version : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { api_version = required reader string "apiVersion"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AboutParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("apiVersion", Some (json_string value.api_version)) ] value.extra

  let to_model value =
    Models.decode Models.about_params (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("key", Some (json_string value.key));
        ("who", Some (json_string value.who));
        ("issuer", Some (json_string value.issuer));
      ]
      value.extra

  let to_model value =
    Models.decode Models.auth_login_result
      (Yojson.Raw.to_string (to_json value))
end

module Auth_logout_result = struct
  type t = {
    key : string option;
    was_signed_in : bool;
    revoked : bool;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        key = maybe reader string "key";
        was_signed_in = required reader bool "wasSignedIn";
        revoked = required reader bool "revoked";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AuthLogoutResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("key", Option.map json_string value.key);
        ("wasSignedIn", Some (json_bool value.was_signed_in));
        ("revoked", Some (json_bool value.revoked));
      ]
      value.extra

  let to_model value =
    Models.decode Models.auth_logout_result
      (Yojson.Raw.to_string (to_json value))
end

module Cancelled = struct
  type t = {
    request_id : Yojson.Raw.t;
    reason : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        request_id = required reader raw "requestId";
        reason = maybe reader string "reason";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Cancelled ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("requestId", Some (json_raw value.request_id));
        ("reason", Option.map json_string value.reason);
      ]
      value.extra

  let to_model value =
    Models.decode Models.cancelled (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("field", Some (json_string value.field));
        ("message", Some (json_string value.message));
      ]
      value.extra

  let to_model value =
    Models.decode Models.field_fault (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("email", Some (json_string value.email));
        ("identity", Some (json_string value.identity));
        ("enabled", Some (json_bool value.enabled));
      ]
      value.extra

  let to_model value =
    Models.decode Models.identity_user (Yojson.Raw.to_string (to_json value))
end

module Identity_useradd_result = struct
  type t = {
    email : string;
    identity : string;
    created : bool;
    generated_password : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        email = required reader string "email";
        identity = required reader string "identity";
        created = required reader bool "created";
        generated_password = maybe reader string "generatedPassword";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.identity_useradd_result
      (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("kind", Some (json_string value.kind));
        ("root", Some (json_string value.root));
      ]
      value.extra

  let to_model value =
    Models.decode Models.local_target (Yojson.Raw.to_string (to_json value))
end

module Log_record = struct
  type t = {
    request_id : Yojson.Raw.t;
    service : string;
    stream : Enums.Output_stream.t;
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
        stream = required reader (enum Enums.Output_stream.of_string) "stream";
        line = required reader string "line";
        received_at = required reader string "receivedAt";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LogRecord ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("requestId", Some (json_raw value.request_id));
        ("service", Some (json_string value.service));
        ("stream", Some ((json_enum Enums.Output_stream.to_string) value.stream));
        ("line", Some (json_string value.line));
        ("receivedAt", Some (json_string value.received_at));
      ]
      value.extra

  let to_model value =
    Models.decode Models.log_record (Yojson.Raw.to_string (to_json value))
end

module Logs_follow_result = struct
  type t = { services : string list; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { services = required reader (list string) "services"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LogsFollowResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("services", Some ((json_list json_string) value.services)) ]
      value.extra

  let to_model value =
    Models.decode Models.logs_follow_result
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

  type t = {
    request_id : Yojson.Raw.t;
    kind : Kind.t;
    text : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        request_id = required reader raw "requestId";
        kind = required reader (enum Kind.of_string) "kind";
        text = required reader string "text";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Progress ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("requestId", Some (json_raw value.request_id));
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("text", Some (json_string value.text));
      ]
      value.extra

  let to_model value =
    Models.decode Models.progress (Yojson.Raw.to_string (to_json value))
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
    placement : Yojson.Raw.t;
    path : string option;
    present : bool option;
    current : Current.t option;
    registered : bool;
    running : bool;
    last_used : string option;
    did : Yojson.Raw.t Types.presence;
    site_name : Yojson.Raw.t Types.presence;
    identity_error : string option;
    config : string option;
    configs : string list option;
    repo : Yojson.Raw.t Types.presence;
    codespace : string option;
    codespace_state : string option;
    forward_port : int option;
    forwarded : bool option;
    reachable : bool option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        placement = required reader raw "placement";
        path = maybe reader string "path";
        present = maybe reader bool "present";
        current = maybe reader (enum Current.of_string) "current";
        registered = required reader bool "registered";
        running = required reader bool "running";
        last_used = maybe reader string "lastUsed";
        did = optional reader raw "did";
        site_name = optional reader raw "siteName";
        identity_error = maybe reader string "identityError";
        config = maybe reader string "config";
        configs = maybe reader (list string) "configs";
        repo = optional reader raw "repo";
        codespace = maybe reader string "codespace";
        codespace_state = maybe reader string "codespaceState";
        forward_port = maybe reader int "forwardPort";
        forwarded = maybe reader bool "forwarded";
        reachable = maybe reader bool "reachable";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Root ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("placement", Some (json_raw value.placement));
        ("path", Option.map json_string value.path);
        ("present", Option.map json_bool value.present);
        ("current", Option.map (json_enum Current.to_string) value.current);
        ("registered", Some (json_bool value.registered));
        ("running", Some (json_bool value.running));
        ("lastUsed", Option.map json_string value.last_used);
        ("did", present json_raw value.did);
        ("siteName", present json_raw value.site_name);
        ("identityError", Option.map json_string value.identity_error);
        ("config", Option.map json_string value.config);
        ("configs", Option.map (json_list json_string) value.configs);
        ("repo", present json_raw value.repo);
        ("codespace", Option.map json_string value.codespace);
        ("codespaceState", Option.map json_string value.codespace_state);
        ("forwardPort", Option.map json_int value.forward_port);
        ("forwarded", Option.map json_bool value.forwarded);
        ("reachable", Option.map json_bool value.reachable);
      ]
      value.extra

  let to_model value =
    Models.decode Models.root (Yojson.Raw.to_string (to_json value))
end

module Roots_forget_params = struct
  type t = {
    api_version : string;
    root : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        root = required reader string "root";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RootsForgetParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("root", Some (json_string value.root));
      ]
      value.extra

  let to_model value =
    Models.decode Models.roots_forget_params
      (Yojson.Raw.to_string (to_json value))
end

module Roots_forget_result = struct
  type t = {
    path : string;
    directory_missing : bool;
    persistent_state : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        path = required reader string "path";
        directory_missing = required reader bool "directoryMissing";
        persistent_state = maybe reader string "persistentState";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RootsForgetResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("path", Some (json_string value.path));
        ("directoryMissing", Some (json_bool value.directory_missing));
        ("persistentState", Option.map json_string value.persistent_state);
      ]
      value.extra

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
    api_version : string;
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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
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
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RootsInitParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
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
      value.extra

  let to_model value =
    Models.decode Models.roots_init_params
      (Yojson.Raw.to_string (to_json value))
end

module Roots_init_result = struct
  type t = { path : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { path = required reader string "path"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `RootsInitResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("path", Some (json_string value.path)) ] value.extra

  let to_model value =
    Models.decode Models.roots_init_result
      (Yojson.Raw.to_string (to_json value))
end

module Roots_list_params = struct
  type t = { api_version : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { api_version = required reader string "apiVersion"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RootsListParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("apiVersion", Some (json_string value.api_version)) ] value.extra

  let to_model value =
    Models.decode Models.roots_list_params
      (Yojson.Raw.to_string (to_json value))
end

module Runtime_state = struct
  type t = {
    name : Enums.Runtime.t;
    found : bool;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader (enum Enums.Runtime.of_string) "name";
        found = required reader bool "found";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RuntimeState ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some ((json_enum Enums.Runtime.to_string) value.name));
        ("found", Some (json_bool value.found));
      ]
      value.extra

  let to_model value =
    Models.decode Models.runtime_state (Yojson.Raw.to_string (to_json value))
end

module Service_host_params = struct
  type t = {
    api_version : string;
    runtime : Enums.Runtime.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceHostParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
      ]
      value.extra

  let to_model value =
    Models.decode Models.service_host_params
      (Yojson.Raw.to_string (to_json value))
end

module Service_host_result = struct
  type t = {
    runtime : Enums.Runtime.t;
    address : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        runtime = required reader (enum Enums.Runtime.of_string) "runtime";
        address = required reader string "address";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceHostResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("runtime", Some ((json_enum Enums.Runtime.to_string) value.runtime));
        ("address", Some (json_string value.address));
      ]
      value.extra

  let to_model value =
    Models.decode Models.service_host_result
      (Yojson.Raw.to_string (to_json value))
end

module Service_output = struct
  type t = {
    request_id : Yojson.Raw.t;
    instance : string;
    stream : Enums.Output_stream.t;
    line : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        request_id = required reader raw "requestId";
        instance = required reader string "instance";
        stream = required reader (enum Enums.Output_stream.of_string) "stream";
        line = required reader string "line";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceOutput ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("requestId", Some (json_raw value.request_id));
        ("instance", Some (json_string value.instance));
        ("stream", Some ((json_enum Enums.Output_stream.to_string) value.stream));
        ("line", Some (json_string value.line));
      ]
      value.extra

  let to_model value =
    Models.decode Models.service_output (Yojson.Raw.to_string (to_json value))
end

module Service_run_result = struct
  type t = {
    instance : string;
    exit_code : int;
    ran_ms : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        instance = required reader string "instance";
        exit_code = required reader int "exitCode";
        ran_ms = required reader int "ranMs";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceRunResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("instance", Some (json_string value.instance));
        ("exitCode", Some (json_int value.exit_code));
        ("ranMs", Some (json_int value.ran_ms));
      ]
      value.extra

  let to_model value =
    Models.decode Models.service_run_result
      (Yojson.Raw.to_string (to_json value))
end

module Service_signal_result = struct
  type t = { delivered : bool; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { delivered = required reader bool "delivered"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceSignalResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("delivered", Some (json_bool value.delivered)) ] value.extra

  let to_model value =
    Models.decode Models.service_signal_result
      (Yojson.Raw.to_string (to_json value))
end

module Service_started = struct
  type t = {
    request_id : Yojson.Raw.t;
    instance : string;
    container : string;
    document_path : string option;
    address : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        request_id = required reader raw "requestId";
        instance = required reader string "instance";
        container = required reader string "container";
        document_path = maybe reader string "documentPath";
        address = required reader string "address";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceStarted ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("requestId", Some (json_raw value.request_id));
        ("instance", Some (json_string value.instance));
        ("container", Some (json_string value.container));
        ("documentPath", Option.map json_string value.document_path);
        ("address", Some (json_string value.address));
      ]
      value.extra

  let to_model value =
    Models.decode Models.service_started (Yojson.Raw.to_string (to_json value))
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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
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
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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

  type t = {
    state : State.t;
    email : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        state = required reader (enum State.of_string) "state";
        email = maybe reader string "email";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Session ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("state", Some ((json_enum State.to_string) value.state));
        ("email", Option.map json_string value.email);
      ]
      value.extra

  let to_model value =
    Models.decode Models.session (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("value", Some (json_string value.value));
        ("source", Some (json_string value.source));
      ]
      value.extra

  let to_model value =
    Models.decode Models.setting_line (Yojson.Raw.to_string (to_json value))
end

module Settings_get_params = struct
  type t = {
    api_version : string;
    name : string;
    default : bool option;
    root : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        name = required reader string "name";
        default = maybe reader bool "default";
        root = maybe reader string "root";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsGetParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("name", Some (json_string value.name));
        ("default", Option.map json_bool value.default);
        ("root", Option.map json_string value.root);
      ]
      value.extra

  let to_model value =
    Models.decode Models.settings_get_params
      (Yojson.Raw.to_string (to_json value))
end

module Settings_list_params = struct
  type t = {
    api_version : string;
    root : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        root = maybe reader string "root";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsListParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("root", Option.map json_string value.root);
      ]
      value.extra

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

  type t = {
    api_version : string;
    document : Document.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        document = required reader (enum Document.of_string) "document";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsPathParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("document", Some ((json_enum Document.to_string) value.document));
      ]
      value.extra

  let to_model value =
    Models.decode Models.settings_path_params
      (Yojson.Raw.to_string (to_json value))
end

module Settings_path_result = struct
  type t = { path : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { path = required reader string "path"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsPathResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("path", Some (json_string value.path)) ] value.extra

  let to_model value =
    Models.decode Models.settings_path_result
      (Yojson.Raw.to_string (to_json value))
end

module Settings_set_params = struct
  type t = {
    api_version : string;
    name : string;
    default : bool option;
    root : string option;
    value : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        name = required reader string "name";
        default = maybe reader bool "default";
        root = maybe reader string "root";
        value = required reader string "value";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsSetParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("name", Some (json_string value.name));
        ("default", Option.map json_bool value.default);
        ("root", Option.map json_string value.root);
        ("value", Some (json_string value.value));
      ]
      value.extra

  let to_model value =
    Models.decode Models.settings_set_params
      (Yojson.Raw.to_string (to_json value))
end

module Settings_unset_params = struct
  type t = {
    api_version : string;
    name : string;
    default : bool option;
    root : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        name = required reader string "name";
        default = maybe reader bool "default";
        root = maybe reader string "root";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsUnsetParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("name", Some (json_string value.name));
        ("default", Option.map json_bool value.default);
        ("root", Option.map json_string value.root);
      ]
      value.extra

  let to_model value =
    Models.decode Models.settings_unset_params
      (Yojson.Raw.to_string (to_json value))
end

module Target = struct
  module Kind = struct
    type t = Local | Codespace

    let to_string = function Local -> "local" | Codespace -> "codespace"

    let of_string = function
      | "local" -> Some Local
      | "codespace" -> Some Codespace
      | _ -> None
  end

  type t = {
    kind : Kind.t;
    root : string option;
    repo : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kind = required reader (enum Kind.of_string) "kind";
        root = maybe reader string "root";
        repo = maybe reader string "repo";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Target ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kind", Some ((json_enum Kind.to_string) value.kind));
        ("root", Option.map json_string value.root);
        ("repo", Option.map json_string value.repo);
      ]
      value.extra

  let to_model value =
    Models.decode Models.target (Yojson.Raw.to_string (to_json value))
end

module User_action = struct
  type t = {
    request_id : Yojson.Raw.t;
    verification_uri : string;
    verification_uri_complete : string option;
    user_code : string;
    expires_in_seconds : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        request_id = required reader raw "requestId";
        verification_uri = required reader string "verificationUri";
        verification_uri_complete =
          maybe reader string "verificationUriComplete";
        user_code = required reader string "userCode";
        expires_in_seconds = required reader int "expiresInSeconds";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `UserAction ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("requestId", Some (json_raw value.request_id));
        ("verificationUri", Some (json_string value.verification_uri));
        ( "verificationUriComplete",
          Option.map json_string value.verification_uri_complete );
        ("userCode", Some (json_string value.user_code));
        ("expiresInSeconds", Some (json_int value.expires_in_seconds));
      ]
      value.extra

  let to_model value =
    Models.decode Models.user_action (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("ledger", present json_raw value.ledger);
        ("queue", present json_raw value.queue);
      ]
      value.extra

  let to_model value =
    Models.decode Models.workload_status (Yojson.Raw.to_string (to_json value))
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

  type t = {
    status : Status.t;
    queue : Queue.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader (enum Status.of_string) "status";
        queue = required reader (enum Queue.of_string) "queue";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `DispatcherHealth ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("queue", Some ((json_enum Queue.to_string) value.queue));
      ]
      value.extra

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

  type t = {
    type_ : Type_.t;
    model : string;
    base_url : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader (enum Type_.of_string) "type";
        model = required reader string "model";
        base_url = required reader string "baseUrl";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `OllamaEmbeddingConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("model", Some (json_string value.model));
        ("baseUrl", Some (json_string value.base_url));
      ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader (enum Type_.of_string) "type";
        model = required reader string "model";
        endpoint = required reader string "endpoint";
        api_key_env = required reader string "apiKeyEnv";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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

  type t = {
    sweep : Sweep.t;
    stopped : int;
    refused : int;
    stream_drops : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        sweep = required reader (enum Sweep.of_string) "sweep";
        stopped = required reader int "stopped";
        refused = required reader int "refused";
        stream_drops = required reader int "streamDrops";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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

  type t = {
    type_ : Type_.t;
    host : string;
    port : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader (enum Type_.of_string) "type";
        host = required reader string "host";
        port = required reader int "port";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JanusGraphConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("host", Some (json_string value.host));
        ("port", Some (json_int value.port));
      ]
      value.extra

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

  type t = { type_ : Type_.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { type_ = required reader (enum Type_.of_string) "type"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MemoryGraphConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("type", Some ((json_enum Type_.to_string) value.type_)) ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader (enum Type_.of_string) "type";
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

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("uri", Some (json_string value.uri));
        ("username", Some (json_string value.username));
        ("passwordEnv", Some (json_string value.password_env));
        ("database", Some (json_string value.database));
      ]
      value.extra

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

  type t = {
    type_ : Type_.t;
    endpoint : string;
    port : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader (enum Type_.of_string) "type";
        endpoint = required reader string "endpoint";
        port = required reader int "port";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `NeptuneGraphConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("type", Some ((json_enum Type_.to_string) value.type_));
        ("endpoint", Some (json_string value.endpoint));
        ("port", Some (json_int value.port));
      ]
      value.extra

  let to_model value =
    Models.decode Models.neptune_graph_config
      (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("project", Some (json_raw value.project));
        ("git", Some (json_raw value.git));
        ("site", Some (json_raw value.site));
      ]
      value.extra

  let to_model value =
    Models.decode Models.project_config (Yojson.Raw.to_string (to_json value))
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

  type t = {
    status : Status.t;
    kb : string;
    actors : Actors.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader (enum Status.of_string) "status";
        kb = required reader string "kb";
        actors = required reader (list (enum Actors.of_string)) "actors";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LibrarianHealth ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("kb", Some (json_string value.kb));
        ("actors", Some ((json_list (json_enum Actors.to_string)) value.actors));
      ]
      value.extra

  let to_model value =
    Models.decode Models.librarian_health (Yojson.Raw.to_string (to_json value))
end

module Librarian_prompt_score = struct
  type t = {
    candidate : float;
    score : float;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        candidate = required reader float "candidate";
        score = required reader float "score";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LibrarianPromptScore ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("candidate", Some (json_float value.candidate));
        ("score", Some (json_float value.score));
      ]
      value.extra

  let to_model value =
    Models.decode Models.librarian_prompt_score
      (Yojson.Raw.to_string (to_json value))
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

  let to_json (value : t) =
    write
      [
        ("grant_type", Some (json_string value.grant_type));
        ("client_id", Some (json_string value.client_id));
        ("client_secret", Some (json_string value.client_secret));
      ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader string "id";
        name = required reader string "name";
        opened_at = required reader int "openedAt";
        order = required reader int "order";
        media_type = maybe reader string "mediaType";
        storage_uri = maybe reader string "storageUri";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.open_resource (Yojson.Raw.to_string (to_json value))
end

module Smelter_chunking = struct
  type t = {
    chunk_size : int;
    overlap : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        chunk_size = required reader int "chunkSize";
        overlap = required reader int "overlap";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SmelterChunking ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("chunkSize", Some (json_int value.chunk_size));
        ("overlap", Some (json_int value.overlap));
      ]
      value.extra

  let to_model value =
    Models.decode Models.smelter_chunking (Yojson.Raw.to_string (to_json value))
end

module Smelter_reconcile_summary = struct
  type t = {
    resources_embedded : int;
    resources_skipped : Yojson.Raw.t;
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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resources_embedded = required reader int "resourcesEmbedded";
        resources_skipped = required reader raw "resourcesSkipped";
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
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SmelterReconcileSummary ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourcesEmbedded", Some (json_int value.resources_embedded));
        ("resourcesSkipped", Some (json_raw value.resources_skipped));
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
      value.extra

  let to_model value =
    Models.decode Models.smelter_reconcile_summary
      (Yojson.Raw.to_string (to_json value))
end

module Host_port = struct
  type t = { host : string; port : int; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      {
        host = required reader string "host";
        port = required reader int "port";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `HostPort ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("host", Some (json_string value.host));
        ("port", Some (json_int value.port));
      ]
      value.extra

  let to_model value =
    Models.decode Models.host_port (Yojson.Raw.to_string (to_json value))
end

module Metadata = struct
  type t = {
    name : string;
    namespace : string option;
    labels : Yojson.Raw.t Types.presence;
    annotations : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        namespace = maybe reader string "namespace";
        labels = optional reader raw "labels";
        annotations = optional reader raw "annotations";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Metadata ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("namespace", Option.map json_string value.namespace);
        ("labels", present json_raw value.labels);
        ("annotations", present json_raw value.annotations);
      ]
      value.extra

  let to_model value =
    Models.decode Models.metadata (Yojson.Raw.to_string (to_json value))
end

module Resources = struct
  type t = { limits : Yojson.Raw.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { limits = required reader raw "limits"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `Resources ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("limits", Some (json_raw value.limits)) ] value.extra

  let to_model value =
    Models.decode Models.resources (Yojson.Raw.to_string (to_json value))
end

module Secret_ref = struct
  type t = { from_env : string; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record = { from_env = required reader string "fromEnv"; extra = [] } in
    { record with extra = rest reader }

  let of_model (model : [ `SecretRef ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("fromEnv", Some (json_string value.from_env)) ] value.extra

  let to_model value =
    Models.decode Models.secret_ref (Yojson.Raw.to_string (to_json value))
end

module Memory_vectors_config = struct
  module Type_ = struct
    type t = Memory

    let to_string = function Memory -> "memory"
    let of_string = function "memory" -> Some Memory | _ -> None
  end

  type t = { type_ : Type_.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      { type_ = required reader (enum Type_.of_string) "type"; extra = [] }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MemoryVectorsConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("type", Some ((json_enum Type_.to_string) value.type_)) ]
      value.extra

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

  type t = {
    type_ : Type_.t;
    host : string;
    port : int;
    token_env : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        type_ = required reader (enum Type_.of_string) "type";
        host = required reader string "host";
        port = required reader int "port";
        token_env = required reader string "tokenEnv";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.qdrant_vectors_config
      (Yojson.Raw.to_string (to_json value))
end

module Annotation_added_payload = struct
  type t = {
    annotation : Annotation.t;
    content_checksum : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation = required reader (record Annotation.project) "annotation";
        content_checksum = maybe reader string "contentChecksum";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnnotationAddedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotation", Some (Annotation.to_json value.annotation));
        ("contentChecksum", Option.map json_string value.content_checksum);
      ]
      value.extra

  let to_model value =
    Models.decode Models.annotation_added_payload
      (Yojson.Raw.to_string (to_json value))
end

module Attributed_event = struct
  type t = {
    id : string;
    type_ : string;
    timestamp : string;
    user_id : string;
    resource_id : string option;
    version : int;
    payload : Yojson.Raw.t;
    metadata : Event_metadata.t;
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
        user_id = required reader string "userId";
        resource_id = maybe reader string "resourceId";
        version = required reader int "version";
        payload = required reader raw "payload";
        metadata = required reader (record Event_metadata.project) "metadata";
        agent = required reader raw "agent";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("payload", Some (json_raw value.payload));
        ("metadata", Some (Event_metadata.to_json value.metadata));
        ("agent", Some (json_raw value.agent));
      ]
      value.extra

  let to_model value =
    Models.decode Models.attributed_event (Yojson.Raw.to_string (to_json value))
end

module Bind_update_body_command = struct
  type t = {
    field_user_id : string option;
    annotation_id : string;
    resource_id : string;
    operations : Bind_body_operation.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        annotation_id = required reader string "annotationId";
        resource_id = required reader string "resourceId";
        operations =
          required reader
            (list (record Bind_body_operation.project))
            "operations";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.bind_update_body_command
      (Yojson.Raw.to_string (to_json value))
end

module Browse_click_event = struct
  type t = {
    annotation_id : string;
    anchor_rect : Anchor_rect.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = required reader string "annotationId";
        anchor_rect = maybe reader (record Anchor_rect.project) "anchorRect";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseClickEvent ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Some (json_string value.annotation_id));
        ("anchorRect", Option.map Anchor_rect.to_json value.anchor_rect);
      ]
      value.extra

  let to_model value =
    Models.decode Models.browse_click_event
      (Yojson.Raw.to_string (to_json value))
end

module Browse_directory_result = struct
  type t = {
    response : Browse_directory_result_response.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response =
          required reader
            (record Browse_directory_result_response.project)
            "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseDirectoryResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "response",
          Some (Browse_directory_result_response.to_json value.response) );
      ]
      value.extra

  let to_model value =
    Models.decode Models.browse_directory_result
      (Yojson.Raw.to_string (to_json value))
end

module Browse_entity_types_result = struct
  type t = {
    response : Get_entity_types_response.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response =
          required reader (record Get_entity_types_response.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseEntityTypesResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Get_entity_types_response.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.browse_entity_types_result
      (Yojson.Raw.to_string (to_json value))
end

module Browse_kb_result = struct
  type t = { response : Kb_description.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      {
        response = required reader (record Kb_description.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseKbResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Kb_description.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.browse_kb_result (Yojson.Raw.to_string (to_json value))
end

module Anchored_text = struct
  type t = {
    text : string;
    items : Pdf_text_item.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        text = required reader string "text";
        items = required reader (list (record Pdf_text_item.project)) "items";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnchoredText ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("text", Some (json_string value.text));
        ("items", Some ((json_list Pdf_text_item.to_json) value.items));
      ]
      value.extra

  let to_model value =
    Models.decode Models.anchored_text (Yojson.Raw.to_string (to_json value))
end

module Clone_resource_with_token_response = struct
  type t = {
    token : string;
    expires_at : string;
    resource : Resource_descriptor.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        token = required reader string "token";
        expires_at = required reader string "expiresAt";
        resource =
          required reader (record Resource_descriptor.project) "resource";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `CloneResourceWithTokenResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("token", Some (json_string value.token));
        ("expiresAt", Some (json_string value.expires_at));
        ("resource", Some (Resource_descriptor.to_json value.resource));
      ]
      value.extra

  let to_model value =
    Models.decode Models.clone_resource_with_token_response
      (Yojson.Raw.to_string (to_json value))
end

module Engine_entry = struct
  type t = {
    engine : Engine.t;
    jobs : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        engine = required reader (record Engine.project) "engine";
        jobs = optional reader raw "jobs";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `EngineEntry ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("engine", Some (Engine.to_json value.engine));
        ("jobs", present json_raw value.jobs);
      ]
      value.extra

  let to_model value =
    Models.decode Models.engine_entry (Yojson.Raw.to_string (to_json value))
end

module Create_annotation_request = struct
  type t = {
    motivation : Enums.Motivation.t;
    target : Annotation_target.t;
    body : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        motivation =
          required reader (enum Enums.Motivation.of_string) "motivation";
        target = required reader (record Annotation_target.project) "target";
        body = optional reader raw "body";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `CreateAnnotationRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "motivation",
          Some ((json_enum Enums.Motivation.to_string) value.motivation) );
        ("target", Some (Annotation_target.to_json value.target));
        ("body", present json_raw value.body);
      ]
      value.extra

  let to_model value =
    Models.decode Models.create_annotation_request
      (Yojson.Raw.to_string (to_json value))
end

module Discovery_document = struct
  type t = {
    version : int;
    kbs : Discovered_kb.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        version = required reader int "version";
        kbs = required reader (list (record Discovered_kb.project)) "kbs";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `DiscoveryDocument ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("version", Some (json_int value.version));
        ("kbs", Some ((json_list Discovered_kb.to_json) value.kbs));
      ]
      value.extra

  let to_model value =
    Models.decode Models.discovery_document
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
    payload : Yojson.Raw.t;
    metadata : Event_metadata.t;
    annotation : Annotation.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader string "id";
        type_ = required reader string "type";
        timestamp = required reader string "timestamp";
        user_id = required reader string "userId";
        resource_id = maybe reader string "resourceId";
        version = required reader int "version";
        payload = required reader raw "payload";
        metadata = required reader (record Event_metadata.project) "metadata";
        annotation = maybe reader (record Annotation.project) "annotation";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("payload", Some (json_raw value.payload));
        ("metadata", Some (Event_metadata.to_json value.metadata));
        ("annotation", Option.map Annotation.to_json value.annotation);
      ]
      value.extra

  let to_model value =
    Models.decode Models.enriched_resource_event
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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
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
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.extracted_text (Yojson.Raw.to_string (to_json value))
end

module Gather_annotation_request = struct
  type t = {
    annotation_id : string;
    resource_id : string;
    options : Gather_annotation_options.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = required reader string "annotationId";
        resource_id = required reader string "resourceId";
        options =
          maybe reader (record Gather_annotation_options.project) "options";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherAnnotationRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Some (json_string value.annotation_id));
        ("resourceId", Some (json_string value.resource_id));
        ("options", Option.map Gather_annotation_options.to_json value.options);
      ]
      value.extra

  let to_model value =
    Models.decode Models.gather_annotation_request
      (Yojson.Raw.to_string (to_json value))
end

module Gather_resource_request = struct
  type t = {
    resource_id : string;
    options : Gather_resource_request_options.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        options =
          required reader
            (record Gather_resource_request_options.project)
            "options";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherResourceRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("options", Some (Gather_resource_request_options.to_json value.options));
      ]
      value.extra

  let to_model value =
    Models.decode Models.gather_resource_request
      (Yojson.Raw.to_string (to_json value))
end

module Gathered_context = struct
  type t = {
    focus : Yojson.Raw.t;
    graph : Knowledge_graph.t;
    semantic_context : Yojson.Raw.t Types.presence;
    metadata : Yojson.Raw.t;
    inferred_relationship_summary : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        focus = required reader raw "focus";
        graph = required reader (record Knowledge_graph.project) "graph";
        semantic_context = optional reader raw "semanticContext";
        metadata = required reader raw "metadata";
        inferred_relationship_summary =
          maybe reader string "inferredRelationshipSummary";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatheredContext ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("focus", Some (json_raw value.focus));
        ("graph", Some (Knowledge_graph.to_json value.graph));
        ("semanticContext", present json_raw value.semantic_context);
        ("metadata", Some (json_raw value.metadata));
        ( "inferredRelationshipSummary",
          Option.map json_string value.inferred_relationship_summary );
      ]
      value.extra

  let to_model value =
    Models.decode Models.gathered_context (Yojson.Raw.to_string (to_json value))
end

module Get_annotation_response = struct
  type t = {
    annotation : Annotation.t;
    resource : Resource_descriptor.t option;
    resolved_resource : Resource_descriptor.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
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
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.get_annotation_response
      (Yojson.Raw.to_string (to_json value))
end

module Get_annotations_response = struct
  type t = {
    annotations : Annotation.t list;
    total : float;
    motivation : Enums.Motivation.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotations =
          required reader (list (record Annotation.project)) "annotations";
        total = required reader float "total";
        motivation = maybe reader (enum Enums.Motivation.of_string) "motivation";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.get_annotations_response
      (Yojson.Raw.to_string (to_json value))
end

module Get_referenced_by_response = struct
  type t = {
    referenced_by : Get_referenced_by_response_referenced_by_item.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        referenced_by =
          required reader
            (list
               (record Get_referenced_by_response_referenced_by_item.project))
            "referencedBy";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.get_referenced_by_response
      (Yojson.Raw.to_string (to_json value))
end

module Get_resource_by_token_response = struct
  type t = {
    source_resource : Resource_descriptor.t;
    expires_at : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        source_resource =
          required reader (record Resource_descriptor.project) "sourceResource";
        expires_at = required reader string "expiresAt";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetResourceByTokenResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "sourceResource",
          Some (Resource_descriptor.to_json value.source_resource) );
        ("expiresAt", Some (json_string value.expires_at));
      ]
      value.extra

  let to_model value =
    Models.decode Models.get_resource_by_token_response
      (Yojson.Raw.to_string (to_json value))
end

module Get_resource_response = struct
  type t = {
    resource : Resource_descriptor.t;
    annotations : Annotation.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource =
          required reader (record Resource_descriptor.project) "resource";
        annotations =
          required reader (list (record Annotation.project)) "annotations";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetResourceResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resource", Some (Resource_descriptor.to_json value.resource));
        ("annotations", Some ((json_list Annotation.to_json) value.annotations));
      ]
      value.extra

  let to_model value =
    Models.decode Models.get_resource_response
      (Yojson.Raw.to_string (to_json value))
end

module Engine_limits = struct
  type t = {
    engine : Engine.t;
    limits : Inference_limits.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        engine = required reader (record Engine.project) "engine";
        limits = required reader (record Inference_limits.project) "limits";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `EngineLimits ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("engine", Some (Engine.to_json value.engine));
        ("limits", Some (Inference_limits.to_json value.limits));
      ]
      value.extra

  let to_model value =
    Models.decode Models.engine_limits (Yojson.Raw.to_string (to_json value))
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
    metadata : Yojson.Raw.t Types.presence;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader string "id";
        type_ = required reader (enum Type_.of_string) "type";
        label = required reader string "label";
        entity_types = maybe reader (list string) "entityTypes";
        annotation = required reader (record Annotation.project) "annotation";
        metadata = optional reader raw "metadata";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("metadata", present json_raw value.metadata);
      ]
      value.extra

  let to_model value =
    Models.decode Models.graph_annotation_node
      (Yojson.Raw.to_string (to_json value))
end

module Job_created_result = struct
  type t = {
    response : Job_created_result_response.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response =
          required reader
            (record Job_created_result_response.project)
            "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobCreatedResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("response", Some (Job_created_result_response.to_json value.response));
      ]
      value.extra

  let to_model value =
    Models.decode Models.job_created_result
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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        resource_id = required reader string "resourceId";
        job_id = required reader string "jobId";
        job_type = required reader (enum Enums.Job_type.of_string) "jobType";
        attempt = maybe reader int "attempt";
        annotation_id = maybe reader string "annotationId";
        percentage = required reader float "percentage";
        progress = maybe reader (record Job_progress.project) "progress";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.job_report_progress_command
      (Yojson.Raw.to_string (to_json value))
end

module Job_status_result = struct
  type t = {
    response : Job_status_response.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response =
          required reader (record Job_status_response.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobStatusResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Job_status_response.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.job_status_result
      (Yojson.Raw.to_string (to_json value))
end

module Knowledge_base = struct
  type t = {
    id : string;
    label : string;
    endpoint : Yojson.Raw.t;
    did : string;
    last_read : Kb_read.t option;
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
        last_read = maybe reader (record Kb_read.project) "lastRead";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `KnowledgeBase ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("id", Some (json_string value.id));
        ("label", Some (json_string value.label));
        ("endpoint", Some (json_raw value.endpoint));
        ("did", Some (json_string value.did));
        ("lastRead", Option.map Kb_read.to_json value.last_read);
      ]
      value.extra

  let to_model value =
    Models.decode Models.knowledge_base (Yojson.Raw.to_string (to_json value))
end

module New_knowledge_base = struct
  type t = {
    label : string;
    endpoint : Yojson.Raw.t;
    did : string;
    last_read : Kb_read.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        label = required reader string "label";
        endpoint = required reader raw "endpoint";
        did = required reader string "did";
        last_read = maybe reader (record Kb_read.project) "lastRead";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `NewKnowledgeBase ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("label", Some (json_string value.label));
        ("endpoint", Some (json_raw value.endpoint));
        ("did", Some (json_string value.did));
        ("lastRead", Option.map Kb_read.to_json value.last_read);
      ]
      value.extra

  let to_model value =
    Models.decode Models.new_knowledge_base
      (Yojson.Raw.to_string (to_json value))
end

module List_resources_response = struct
  type t = {
    resources : Resource_descriptor.t list;
    total : float;
    offset : float;
    limit : float;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resources =
          required reader
            (list (record Resource_descriptor.project))
            "resources";
        total = required reader float "total";
        offset = required reader float "offset";
        limit = required reader float "limit";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.list_resources_response
      (Yojson.Raw.to_string (to_json value))
end

module Mark_create_ok = struct
  type t = {
    response : Mark_create_ok_response.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response =
          required reader (record Mark_create_ok_response.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkCreateOk ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Mark_create_ok_response.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.mark_create_ok (Yojson.Raw.to_string (to_json value))
end

module Mark_commit_command = struct
  type t = {
    field_user_id : string option;
    field_roles : string list option;
    job_id : string option;
    resource_id : string;
    annotations : Annotation.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        field_roles = maybe reader (list string) "_roles";
        job_id = maybe reader string "jobId";
        resource_id = required reader string "resourceId";
        annotations =
          required reader (list (record Annotation.project)) "annotations";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.mark_commit_command
      (Yojson.Raw.to_string (to_json value))
end

module Match_search_result = struct
  type t = {
    reference_id : string;
    response : Scored_resource.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        reference_id = required reader string "referenceId";
        response =
          required reader (list (record Scored_resource.project)) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MatchSearchResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("referenceId", Some (json_string value.reference_id));
        ("response", Some ((json_list Scored_resource.to_json) value.response));
      ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resources =
          required reader
            (list (record Resource_descriptor.project))
            "resources";
        total = required reader int "total";
        offset = required reader int "offset";
        limit = required reader int "limit";
        match_kind = required reader (enum Match_kind.of_string) "matchKind";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.match_resources_response
      (Yojson.Raw.to_string (to_json value))
end

module Representation_added_payload = struct
  type t = {
    representation : Representation.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        representation =
          required reader (record Representation.project) "representation";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RepresentationAddedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("representation", Some (Representation.to_json value.representation)) ]
      value.extra

  let to_model value =
    Models.decode Models.representation_added_payload
      (Yojson.Raw.to_string (to_json value))
end

module Stored_event_response = struct
  type t = {
    id : string;
    type_ : string;
    timestamp : string;
    user_id : string;
    resource_id : string option;
    version : int;
    payload : Yojson.Raw.t;
    metadata : Event_metadata.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        id = required reader string "id";
        type_ = required reader string "type";
        timestamp = required reader string "timestamp";
        user_id = required reader string "userId";
        resource_id = maybe reader string "resourceId";
        version = required reader int "version";
        payload = required reader raw "payload";
        metadata = required reader (record Event_metadata.project) "metadata";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("payload", Some (json_raw value.payload));
        ("metadata", Some (Event_metadata.to_json value.metadata));
      ]
      value.extra

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
        tags = required reader (list (record Tag_category.project)) "tags";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.tag_schema (Yojson.Raw.to_string (to_json value))
end

module Yield_clone_created = struct
  type t = {
    response : Yielded_resource.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response = required reader (record Yielded_resource.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldCloneCreated ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Yielded_resource.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.yield_clone_created
      (Yojson.Raw.to_string (to_json value))
end

module Yield_create_ok = struct
  type t = {
    response : Yielded_resource.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response = required reader (record Yielded_resource.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldCreateOk ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Yielded_resource.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.yield_create_ok (Yojson.Raw.to_string (to_json value))
end

module Yield_clone_persist_ok = struct
  type t = {
    response : Yielded_resource.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response = required reader (record Yielded_resource.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldClonePersistOk ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Yielded_resource.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.yield_clone_persist_ok
      (Yojson.Raw.to_string (to_json value))
end

module Yield_update_ok = struct
  type t = {
    response : Yielded_resource.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response = required reader (record Yielded_resource.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `YieldUpdateOk ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Yielded_resource.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.yield_update_ok (Yojson.Raw.to_string (to_json value))
end

module Bus_event_message = struct
  module Event = struct
    type t = Bus_event

    let to_string = function Bus_event -> "bus-event"
    let of_string = function "bus-event" -> Some Bus_event | _ -> None
  end

  type t = {
    event : Event.t;
    id : Yojson.Raw.t;
    data : Bus_frame.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        event = required reader (enum Event.of_string) "event";
        id = required reader raw "id";
        data = required reader (record Bus_frame.project) "data";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BusEventMessage ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("event", Some ((json_enum Event.to_string) value.event));
        ("id", Some (json_raw value.id));
        ("data", Some (Bus_frame.to_json value.data));
      ]
      value.extra

  let to_model value =
    Models.decode Models.bus_event_message
      (Yojson.Raw.to_string (to_json value))
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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        job_id = required reader string "jobId";
        job_type = required reader (enum Job_type.of_string) "jobType";
        resource_id = required reader string "resourceId";
        user_id = required reader string "userId";
        params =
          required reader (record Generation_job_request.project) "params";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.yield_job_queued_event
      (Yojson.Raw.to_string (to_json value))
end

module Resource_annotations = struct
  type t = {
    resource_id : string;
    annotations : Annotation.t list;
    version : int;
    updated_at : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        annotations =
          required reader (list (record Annotation.project)) "annotations";
        version = required reader int "version";
        updated_at = required reader string "updatedAt";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.resource_annotations
      (Yojson.Raw.to_string (to_json value))
end

module Anchored_text_extracted_entry = struct
  type t = {
    v : int;
    stamp : string;
    text : string;
    lines : Yojson.Raw.t;
    method_ : Enums.Extraction_method.t;
    pdf_class : Enums.Pdf_class.t option;
    ocr_confidence : Ocr_confidence.t option;
    unread_pages : int list option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        v = required reader int "v";
        stamp = required reader string "stamp";
        text = required reader string "text";
        lines = required reader raw "lines";
        method_ =
          required reader (enum Enums.Extraction_method.of_string) "method";
        pdf_class = maybe reader (enum Enums.Pdf_class.of_string) "pdfClass";
        ocr_confidence =
          maybe reader (record Ocr_confidence.project) "ocrConfidence";
        unread_pages = maybe reader (list int) "unreadPages";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AnchoredTextExtractedEntry ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("v", Some (json_int value.v));
        ("stamp", Some (json_string value.stamp));
        ("text", Some (json_string value.text));
        ("lines", Some (json_raw value.lines));
        ( "method",
          Some ((json_enum Enums.Extraction_method.to_string) value.method_) );
        ( "pdfClass",
          Option.map (json_enum Enums.Pdf_class.to_string) value.pdf_class );
        ("ocrConfidence", Option.map Ocr_confidence.to_json value.ocr_confidence);
        ("unreadPages", Option.map (json_list json_int) value.unread_pages);
      ]
      value.extra

  let to_model value =
    Models.decode Models.anchored_text_extracted_entry
      (Yojson.Raw.to_string (to_json value))
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
    staging : Yojson.Raw.t;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        gateway_url = required reader string "gatewayUrl";
        identity = required reader (record Service_identity.project) "identity";
        root = required reader string "root";
        state_home = required reader string "stateHome";
        anchored_text_dir = required reader string "anchoredTextDir";
        engines = required reader (record Archivist_engines.project) "engines";
        port = required reader int "port";
        skip_rebuild = required reader bool "skipRebuild";
        staging = required reader raw "staging";
        log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
        log_format =
          required reader (enum Enums.Log_format.of_string) "logFormat";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("staging", Some (json_raw value.staging));
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ( "logFormat",
          Some ((json_enum Enums.Log_format.to_string) value.log_format) );
      ]
      value.extra

  let to_model value =
    Models.decode Models.archivist_config (Yojson.Raw.to_string (to_json value))
end

module Archivist_streams_response = struct
  type t = {
    streams : Archivist_stream.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        streams =
          required reader (list (record Archivist_stream.project)) "streams";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ArchivistStreamsResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("streams", Some ((json_list Archivist_stream.to_json) value.streams)) ]
      value.extra

  let to_model value =
    Models.decode Models.archivist_streams_response
      (Yojson.Raw.to_string (to_json value))
end

module Conformance_implementations = struct
  type t = {
    launcher : string list;
    target : Local_target.t;
    sdks : Yojson.Raw.t;
    model_catalogue : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        launcher = required reader (list string) "launcher";
        target = required reader (record Local_target.project) "target";
        sdks = required reader raw "sdks";
        model_catalogue = maybe reader string "modelCatalogue";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ConformanceImplementations ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("launcher", Some ((json_list json_string) value.launcher));
        ("target", Some (Local_target.to_json value.target));
        ("sdks", Some (json_raw value.sdks));
        ("modelCatalogue", Option.map json_string value.model_catalogue);
      ]
      value.extra

  let to_model value =
    Models.decode Models.conformance_implementations
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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        version = maybe reader string "version";
        development = required reader bool "development";
        commit = maybe reader string "commit";
        built = maybe reader string "built";
        api_versions = required reader (list string) "apiVersions";
        image_registry = required reader string "imageRegistry";
        runtimes =
          required reader (list (record Runtime_state.project)) "runtimes";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.about_result (Yojson.Raw.to_string (to_json value))
end

module Auth_login_params = struct
  type t = {
    api_version : string;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        target = maybe reader (record Target.project) "target";
        runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AuthLoginParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("target", Option.map Target.to_json value.target);
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
      ]
      value.extra

  let to_model value =
    Models.decode Models.auth_login_params
      (Yojson.Raw.to_string (to_json value))
end

module Auth_logout_params = struct
  type t = {
    api_version : string;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        target = maybe reader (record Target.project) "target";
        runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `AuthLogoutParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("target", Option.map Target.to_json value.target);
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
      ]
      value.extra

  let to_model value =
    Models.decode Models.auth_logout_params
      (Yojson.Raw.to_string (to_json value))
end

module Error_data = struct
  type t = {
    code : string;
    retryable : bool;
    fields : Field_fault.t list option;
    choices : Target.t list option;
    supported : string list option;
    may_still_run : bool option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        code = required reader string "code";
        retryable = required reader bool "retryable";
        fields = maybe reader (list (record Field_fault.project)) "fields";
        choices = maybe reader (list (record Target.project)) "choices";
        supported = maybe reader (list string) "supported";
        may_still_run = maybe reader bool "mayStillRun";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.error_data (Yojson.Raw.to_string (to_json value))
end

module Identity_useradd_params = struct
  type t = {
    api_version : string;
    target : Local_target.t;
    email : string;
    password : string option;
    generate_password : bool;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        target = required reader (record Local_target.project) "target";
        email = required reader string "email";
        password = maybe reader string "password";
        generate_password = required reader bool "generatePassword";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `IdentityUseraddParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("target", Some (Local_target.to_json value.target));
        ("email", Some (json_string value.email));
        ("password", Option.map json_string value.password);
        ("generatePassword", Some (json_bool value.generate_password));
      ]
      value.extra

  let to_model value =
    Models.decode Models.identity_useradd_params
      (Yojson.Raw.to_string (to_json value))
end

module Identity_users_list_params = struct
  type t = {
    api_version : string;
    target : Local_target.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        target = required reader (record Local_target.project) "target";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `IdentityUsersListParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("target", Some (Local_target.to_json value.target));
      ]
      value.extra

  let to_model value =
    Models.decode Models.identity_users_list_params
      (Yojson.Raw.to_string (to_json value))
end

module Identity_users_list_result = struct
  type t = {
    users : Identity_user.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        users = required reader (list (record Identity_user.project)) "users";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `IdentityUsersListResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("users", Some ((json_list Identity_user.to_json) value.users)) ]
      value.extra

  let to_model value =
    Models.decode Models.identity_users_list_result
      (Yojson.Raw.to_string (to_json value))
end

module Knowledge_base_status = struct
  type t = {
    name : string;
    key : string;
    recorded : bool;
    placement : Yojson.Raw.t;
    root : string option;
    repo : Yojson.Raw.t Types.presence;
    did : Yojson.Raw.t Types.presence;
    site_name : Yojson.Raw.t Types.presence;
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
        root = maybe reader string "root";
        repo = optional reader raw "repo";
        did = optional reader raw "did";
        site_name = optional reader raw "siteName";
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
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `KnowledgeBaseStatus ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("name", Some (json_string value.name));
        ("key", Some (json_string value.key));
        ("recorded", Some (json_bool value.recorded));
        ("placement", Some (json_raw value.placement));
        ("root", Option.map json_string value.root);
        ("repo", present json_raw value.repo);
        ("did", present json_raw value.did);
        ("siteName", present json_raw value.site_name);
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
      value.extra

  let to_model value =
    Models.decode Models.knowledge_base_status
      (Yojson.Raw.to_string (to_json value))
end

module Logs_follow_params = struct
  type t = {
    api_version : string;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
    service : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        target = maybe reader (record Target.project) "target";
        runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
        service = maybe reader string "service";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LogsFollowParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("target", Option.map Target.to_json value.target);
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
        ("service", Option.map json_string value.service);
      ]
      value.extra

  let to_model value =
    Models.decode Models.logs_follow_params
      (Yojson.Raw.to_string (to_json value))
end

module Roots_list_result = struct
  type t = {
    roots : Root.t list;
    warnings : string list option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        roots = required reader (list (record Root.project)) "roots";
        warnings = maybe reader (list string) "warnings";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `RootsListResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("roots", Some ((json_list Root.to_json) value.roots));
        ("warnings", Option.map (json_list json_string) value.warnings);
      ]
      value.extra

  let to_model value =
    Models.decode Models.roots_list_result
      (Yojson.Raw.to_string (to_json value))
end

module Service_run_params = struct
  type t = {
    api_version : string;
    target : Local_target.t;
    runtime : Enums.Runtime.t option;
    service : Enums.Run_service.t;
    instance : string;
    document : string option;
    args : string list option;
    environment : Yojson.Raw.t;
    mounts : string list;
    path_first : string list;
    ports : int list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        target = required reader (record Local_target.project) "target";
        runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
        service = required reader (enum Enums.Run_service.of_string) "service";
        instance = required reader string "instance";
        document = maybe reader string "document";
        args = maybe reader (list string) "args";
        environment = required reader raw "environment";
        mounts = required reader (list string) "mounts";
        path_first = required reader (list string) "pathFirst";
        ports = required reader (list int) "ports";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceRunParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("target", Some (Local_target.to_json value.target));
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
        ("service", Some ((json_enum Enums.Run_service.to_string) value.service));
        ("instance", Some (json_string value.instance));
        ("document", Option.map json_string value.document);
        ("args", Option.map (json_list json_string) value.args);
        ("environment", Some (json_raw value.environment));
        ("mounts", Some ((json_list json_string) value.mounts));
        ("pathFirst", Some ((json_list json_string) value.path_first));
        ("ports", Some ((json_list json_int) value.ports));
      ]
      value.extra

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
    api_version : string;
    target : Local_target.t;
    runtime : Enums.Runtime.t option;
    instance : string;
    signal : Signal.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        target = required reader (record Local_target.project) "target";
        runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
        instance = required reader string "instance";
        signal = required reader (enum Signal.of_string) "signal";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ServiceSignalParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("target", Some (Local_target.to_json value.target));
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
        ("instance", Some (json_string value.instance));
        ("signal", Some ((json_enum Signal.to_string) value.signal));
      ]
      value.extra

  let to_model value =
    Models.decode Models.service_signal_params
      (Yojson.Raw.to_string (to_json value))
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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        name = required reader string "name";
        default = required reader bool "default";
        applies_to = required reader (enum Applies_to.of_string) "appliesTo";
        values = required reader (list (record Setting_line.project)) "values";
        settable = required reader bool "settable";
        changed_by = maybe reader string "changedBy";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    api_version : string;
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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
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
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StackStartParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
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
      value.extra

  let to_model value =
    Models.decode Models.stack_start_params
      (Yojson.Raw.to_string (to_json value))
end

module Stack_stop_params = struct
  type t = {
    api_version : string;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
    service : string option;
    group : Enums.Service_group.t option;
    delete : bool option;
    delete_confirmed : bool option;
    dry_run : bool option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        target = maybe reader (record Target.project) "target";
        runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
        service = maybe reader string "service";
        group = maybe reader (enum Enums.Service_group.of_string) "group";
        delete = maybe reader bool "delete";
        delete_confirmed = maybe reader bool "deleteConfirmed";
        dry_run = maybe reader bool "dryRun";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StackStopParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("target", Option.map Target.to_json value.target);
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
        ("service", Option.map json_string value.service);
        ( "group",
          Option.map (json_enum Enums.Service_group.to_string) value.group );
        ("delete", Option.map json_bool value.delete);
        ("deleteConfirmed", Option.map json_bool value.delete_confirmed);
        ("dryRun", Option.map json_bool value.dry_run);
      ]
      value.extra

  let to_model value =
    Models.decode Models.stack_stop_params
      (Yojson.Raw.to_string (to_json value))
end

module Status_snapshot_params = struct
  type t = {
    api_version : string;
    target : Target.t option;
    runtime : Enums.Runtime.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        target = maybe reader (record Target.project) "target";
        runtime = maybe reader (enum Enums.Runtime.of_string) "runtime";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StatusSnapshotParams ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("target", Option.map Target.to_json value.target);
        ("runtime", Option.map (json_enum Enums.Runtime.to_string) value.runtime);
      ]
      value.extra

  let to_model value =
    Models.decode Models.status_snapshot_params
      (Yojson.Raw.to_string (to_json value))
end

module Dispatcher_config = struct
  type t = {
    kb : Kb_identity.t;
    gateway_url : string;
    identity : Service_identity.t;
    queue : Yojson.Raw.t;
    port : int;
    timing : Yojson.Raw.t;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kb = required reader (record Kb_identity.project) "kb";
        gateway_url = required reader string "gatewayUrl";
        identity = required reader (record Service_identity.project) "identity";
        queue = required reader raw "queue";
        port = required reader int "port";
        timing = required reader raw "timing";
        log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
        log_format =
          required reader (enum Enums.Log_format.of_string) "logFormat";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `DispatcherConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kb", Some (Kb_identity.to_json value.kb));
        ("gatewayUrl", Some (json_string value.gateway_url));
        ("identity", Some (Service_identity.to_json value.identity));
        ("queue", Some (json_raw value.queue));
        ("port", Some (json_int value.port));
        ("timing", Some (json_raw value.timing));
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ( "logFormat",
          Some ((json_enum Enums.Log_format.to_string) value.log_format) );
      ]
      value.extra

  let to_model value =
    Models.decode Models.dispatcher_config
      (Yojson.Raw.to_string (to_json value))
end

module Gateway_config = struct
  type t = {
    kb : Kb_identity.t;
    port : int;
    public_url : string;
    identity : Yojson.Raw.t;
    archivist : Service_address.t;
    signal : Yojson.Raw.t;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
    capacity : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kb = required reader (record Kb_identity.project) "kb";
        port = required reader int "port";
        public_url = required reader string "publicUrl";
        identity = required reader raw "identity";
        archivist = required reader (record Service_address.project) "archivist";
        signal = required reader raw "signal";
        log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
        log_format =
          required reader (enum Enums.Log_format.of_string) "logFormat";
        capacity = required reader raw "capacity";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatewayConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kb", Some (Kb_identity.to_json value.kb));
        ("port", Some (json_int value.port));
        ("publicUrl", Some (json_string value.public_url));
        ("identity", Some (json_raw value.identity));
        ("archivist", Some (Service_address.to_json value.archivist));
        ("signal", Some (json_raw value.signal));
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ( "logFormat",
          Some ((json_enum Enums.Log_format.to_string) value.log_format) );
        ("capacity", Some (json_raw value.capacity));
      ]
      value.extra

  let to_model value =
    Models.decode Models.gateway_config (Yojson.Raw.to_string (to_json value))
end

module Librarian_engine_config = struct
  type t = {
    engine : Engine.t;
    base_url : string;
    api_key_env : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        engine = required reader (record Engine.project) "engine";
        base_url = required reader string "baseUrl";
        api_key_env = maybe reader string "apiKeyEnv";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LibrarianEngineConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("engine", Some (Engine.to_json value.engine));
        ("baseUrl", Some (json_string value.base_url));
        ("apiKeyEnv", Option.map json_string value.api_key_env);
      ]
      value.extra

  let to_model value =
    Models.decode Models.librarian_engine_config
      (Yojson.Raw.to_string (to_json value))
end

module Smelter_config = struct
  type t = {
    kb : Kb_identity.t;
    gateway_url : string;
    identity : Service_identity.t;
    archivist : Service_address.t;
    embedding : Yojson.Raw.t;
    vectors : Yojson.Raw.t;
    chunking : Smelter_chunking.t;
    pdfs_at_once : int;
    cursors_path : string;
    port : int;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kb = required reader (record Kb_identity.project) "kb";
        gateway_url = required reader string "gatewayUrl";
        identity = required reader (record Service_identity.project) "identity";
        archivist = required reader (record Service_address.project) "archivist";
        embedding = required reader raw "embedding";
        vectors = required reader raw "vectors";
        chunking = required reader (record Smelter_chunking.project) "chunking";
        pdfs_at_once = required reader int "pdfsAtOnce";
        cursors_path = required reader string "cursorsPath";
        port = required reader int "port";
        log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
        log_format =
          required reader (enum Enums.Log_format.of_string) "logFormat";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SmelterConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kb", Some (Kb_identity.to_json value.kb));
        ("gatewayUrl", Some (json_string value.gateway_url));
        ("identity", Some (Service_identity.to_json value.identity));
        ("archivist", Some (Service_address.to_json value.archivist));
        ("embedding", Some (json_raw value.embedding));
        ("vectors", Some (json_raw value.vectors));
        ("chunking", Some (Smelter_chunking.to_json value.chunking));
        ("pdfsAtOnce", Some (json_int value.pdfs_at_once));
        ("cursorsPath", Some (json_string value.cursors_path));
        ("port", Some (json_int value.port));
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ( "logFormat",
          Some ((json_enum Enums.Log_format.to_string) value.log_format) );
      ]
      value.extra

  let to_model value =
    Models.decode Models.smelter_config (Yojson.Raw.to_string (to_json value))
end

module Smelter_health = struct
  module Status = struct
    type t = Ok

    let to_string = function Ok -> "ok"
    let of_string = function "ok" -> Some Ok | _ -> None
  end

  module Stream = struct
    type t =
      | Initial
      | Connecting
      | Open
      | Reconnecting
      | Degraded
      | Unauthenticated
      | Closed

    let to_string = function
      | Initial -> "initial"
      | Connecting -> "connecting"
      | Open -> "open"
      | Reconnecting -> "reconnecting"
      | Degraded -> "degraded"
      | Unauthenticated -> "unauthenticated"
      | Closed -> "closed"

    let of_string = function
      | "initial" -> Some Initial
      | "connecting" -> Some Connecting
      | "open" -> Some Open
      | "reconnecting" -> Some Reconnecting
      | "degraded" -> Some Degraded
      | "unauthenticated" -> Some Unauthenticated
      | "closed" -> Some Closed
      | _ -> None
  end

  type t = {
    status : Status.t;
    kb : string;
    stream : Stream.t;
    following : Follower_following.t;
    events_processed : int;
    reconcile : Yojson.Raw.t;
    index : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader (enum Status.of_string) "status";
        kb = required reader string "kb";
        stream = required reader (enum Stream.of_string) "stream";
        following =
          required reader (record Follower_following.project) "following";
        events_processed = required reader int "eventsProcessed";
        reconcile = required reader raw "reconcile";
        index = required reader raw "index";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SmelterHealth ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("kb", Some (json_string value.kb));
        ("stream", Some ((json_enum Stream.to_string) value.stream));
        ("following", Some (Follower_following.to_json value.following));
        ("eventsProcessed", Some (json_int value.events_processed));
        ("reconcile", Some (json_raw value.reconcile));
        ("index", Some (json_raw value.index));
      ]
      value.extra

  let to_model value =
    Models.decode Models.smelter_health (Yojson.Raw.to_string (to_json value))
end

module Browser = struct
  type t = {
    api_version : string;
    kind : string;
    metadata : Metadata.t;
    spec : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        kind = required reader string "kind";
        metadata = required reader (record Metadata.project) "metadata";
        spec = required reader raw "spec";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Browser ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("kind", Some (json_string value.kind));
        ("metadata", Some (Metadata.to_json value.metadata));
        ("spec", Some (json_raw value.spec));
      ]
      value.extra

  let to_model value =
    Models.decode Models.browser (Yojson.Raw.to_string (to_json value))
end

module Inference = struct
  type t = {
    api_version : string;
    kind : string;
    metadata : Metadata.t;
    spec : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        kind = required reader string "kind";
        metadata = required reader (record Metadata.project) "metadata";
        spec = required reader raw "spec";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Inference ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("kind", Some (json_string value.kind));
        ("metadata", Some (Metadata.to_json value.metadata));
        ("spec", Some (json_raw value.spec));
      ]
      value.extra

  let to_model value =
    Models.decode Models.inference (Yojson.Raw.to_string (to_json value))
end

module Issuer = struct
  type t = {
    api_version : string;
    kind : string;
    metadata : Metadata.t;
    spec : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        kind = required reader string "kind";
        metadata = required reader (record Metadata.project) "metadata";
        spec = required reader raw "spec";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Issuer ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("kind", Some (json_string value.kind));
        ("metadata", Some (Metadata.to_json value.metadata));
        ("spec", Some (json_raw value.spec));
      ]
      value.extra

  let to_model value =
    Models.decode Models.issuer (Yojson.Raw.to_string (to_json value))
end

module Knowledge_index = struct
  type t = {
    api_version : string;
    kind : string;
    metadata : Metadata.t;
    spec : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        kind = required reader string "kind";
        metadata = required reader (record Metadata.project) "metadata";
        spec = required reader raw "spec";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `KnowledgeIndex ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("kind", Some (json_string value.kind));
        ("metadata", Some (Metadata.to_json value.metadata));
        ("spec", Some (json_raw value.spec));
      ]
      value.extra

  let to_model value =
    Models.decode Models.knowledge_index (Yojson.Raw.to_string (to_json value))
end

module Provider = struct
  type t = {
    base_url : string option;
    api_key : Secret_ref.t option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        base_url = maybe reader string "baseURL";
        api_key = maybe reader (record Secret_ref.project) "apiKey";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `Provider ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("baseURL", Option.map json_string value.base_url);
        ("apiKey", Option.map Secret_ref.to_json value.api_key);
      ]
      value.extra

  let to_model value =
    Models.decode Models.provider (Yojson.Raw.to_string (to_json value))
end

module Stack_knowledge_base = struct
  type t = {
    api_version : string;
    kind : string;
    metadata : Metadata.t;
    spec : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        kind = required reader string "kind";
        metadata = required reader (record Metadata.project) "metadata";
        spec = required reader raw "spec";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `StackKnowledgeBase ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("kind", Some (json_string value.kind));
        ("metadata", Some (Metadata.to_json value.metadata));
        ("spec", Some (json_raw value.spec));
      ]
      value.extra

  let to_model value =
    Models.decode Models.stack_knowledge_base
      (Yojson.Raw.to_string (to_json value))
end

module Vector_store = struct
  type t = {
    api_version : string;
    kind : string;
    metadata : Metadata.t;
    spec : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        kind = required reader string "kind";
        metadata = required reader (record Metadata.project) "metadata";
        spec = required reader raw "spec";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `VectorStore ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("kind", Some (json_string value.kind));
        ("metadata", Some (Metadata.to_json value.metadata));
        ("spec", Some (json_raw value.spec));
      ]
      value.extra

  let to_model value =
    Models.decode Models.vector_store (Yojson.Raw.to_string (to_json value))
end

module Worker_pool = struct
  type t = {
    api_version : string;
    kind : string;
    metadata : Metadata.t;
    spec : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        api_version = required reader string "apiVersion";
        kind = required reader string "kind";
        metadata = required reader (record Metadata.project) "metadata";
        spec = required reader raw "spec";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WorkerPool ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("apiVersion", Some (json_string value.api_version));
        ("kind", Some (json_string value.kind));
        ("metadata", Some (Metadata.to_json value.metadata));
        ("spec", Some (json_raw value.spec));
      ]
      value.extra

  let to_model value =
    Models.decode Models.worker_pool (Yojson.Raw.to_string (to_json value))
end

module Weaver_config = struct
  type t = {
    kb : Kb_identity.t;
    gateway_url : string;
    identity : Service_identity.t;
    archivist : Service_address.t;
    graph : Yojson.Raw.t;
    cursors_path : string;
    port : int;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kb = required reader (record Kb_identity.project) "kb";
        gateway_url = required reader string "gatewayUrl";
        identity = required reader (record Service_identity.project) "identity";
        archivist = required reader (record Service_address.project) "archivist";
        graph = required reader raw "graph";
        cursors_path = required reader string "cursorsPath";
        port = required reader int "port";
        log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
        log_format =
          required reader (enum Enums.Log_format.of_string) "logFormat";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WeaverConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kb", Some (Kb_identity.to_json value.kb));
        ("gatewayUrl", Some (json_string value.gateway_url));
        ("identity", Some (Service_identity.to_json value.identity));
        ("archivist", Some (Service_address.to_json value.archivist));
        ("graph", Some (json_raw value.graph));
        ("cursorsPath", Some (json_string value.cursors_path));
        ("port", Some (json_int value.port));
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ( "logFormat",
          Some ((json_enum Enums.Log_format.to_string) value.log_format) );
      ]
      value.extra

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
    reconcile : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader (enum Status.of_string) "status";
        kb = required reader string "kb";
        following =
          required reader (record Follower_following.project) "following";
        reconcile = required reader raw "reconcile";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WeaverHealth ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("kb", Some (json_string value.kb));
        ("following", Some (Follower_following.to_json value.following));
        ("reconcile", Some (json_raw value.reconcile));
      ]
      value.extra

  let to_model value =
    Models.decode Models.weaver_health (Yojson.Raw.to_string (to_json value))
end

module Worker_engine_config = struct
  type t = {
    engine : Engine.t;
    jobs : Yojson.Raw.t;
    base_url : string;
    api_key_env : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        engine = required reader (record Engine.project) "engine";
        jobs = required reader raw "jobs";
        base_url = required reader string "baseUrl";
        api_key_env = maybe reader string "apiKeyEnv";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WorkerEngineConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("engine", Some (Engine.to_json value.engine));
        ("jobs", Some (json_raw value.jobs));
        ("baseUrl", Some (json_string value.base_url));
        ("apiKeyEnv", Option.map json_string value.api_key_env);
      ]
      value.extra

  let to_model value =
    Models.decode Models.worker_engine_config
      (Yojson.Raw.to_string (to_json value))
end

module Worker_engine_health = struct
  type t = {
    engine : Engine.t;
    jobs : Yojson.Raw.t;
    last_queued_event_at : string option;
    last_claim_at : string option;
    last_finished_at : string option;
    last_activity_at : string option;
    active_job : Yojson.Raw.t;
    jobs_completed : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        engine = required reader (record Engine.project) "engine";
        jobs = required reader raw "jobs";
        last_queued_event_at =
          required reader (nullable string) "lastQueuedEventAt";
        last_claim_at = required reader (nullable string) "lastClaimAt";
        last_finished_at = required reader (nullable string) "lastFinishedAt";
        last_activity_at = required reader (nullable string) "lastActivityAt";
        active_job = required reader raw "activeJob";
        jobs_completed = required reader int "jobsCompleted";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WorkerEngineHealth ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("engine", Some (Engine.to_json value.engine));
        ("jobs", Some (json_raw value.jobs));
        ( "lastQueuedEventAt",
          Some ((json_nullable json_string) value.last_queued_event_at) );
        ("lastClaimAt", Some ((json_nullable json_string) value.last_claim_at));
        ( "lastFinishedAt",
          Some ((json_nullable json_string) value.last_finished_at) );
        ( "lastActivityAt",
          Some ((json_nullable json_string) value.last_activity_at) );
        ("activeJob", Some (json_raw value.active_job));
        ("jobsCompleted", Some (json_int value.jobs_completed));
      ]
      value.extra

  let to_model value =
    Models.decode Models.worker_engine_health
      (Yojson.Raw.to_string (to_json value))
end

module Browse_annotation_result = struct
  type t = {
    response : Get_annotation_response.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response =
          required reader (record Get_annotation_response.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseAnnotationResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Get_annotation_response.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.browse_annotation_result
      (Yojson.Raw.to_string (to_json value))
end

module Browse_resources_result = struct
  type t = {
    response : List_resources_response.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response =
          required reader (record List_resources_response.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseResourcesResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (List_resources_response.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.browse_resources_result
      (Yojson.Raw.to_string (to_json value))
end

module Frame_add_tag_schema_command = struct
  type t = {
    schema : Tag_schema.t;
    field_user_id : string option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        schema = required reader (record Tag_schema.project) "schema";
        field_user_id = maybe reader string "_userId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `FrameAddTagSchemaCommand ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("schema", Some (Tag_schema.to_json value.schema));
        ("_userId", Option.map json_string value.field_user_id);
      ]
      value.extra

  let to_model value =
    Models.decode Models.frame_add_tag_schema_command
      (Yojson.Raw.to_string (to_json value))
end

module Gather_annotation_complete = struct
  type t = {
    annotation_id : string;
    response : Gathered_context.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        annotation_id = required reader string "annotationId";
        response = required reader (record Gathered_context.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherAnnotationComplete ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("annotationId", Some (json_string value.annotation_id));
        ("response", Some (Gathered_context.to_json value.response));
      ]
      value.extra

  let to_model value =
    Models.decode Models.gather_annotation_complete
      (Yojson.Raw.to_string (to_json value))
end

module Gather_resource_complete = struct
  type t = {
    resource_id : string;
    response : Gathered_context.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        response = required reader (record Gathered_context.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherResourceComplete ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("response", Some (Gathered_context.to_json value.response));
      ]
      value.extra

  let to_model value =
    Models.decode Models.gather_resource_complete
      (Yojson.Raw.to_string (to_json value))
end

module Gather_referenced_by_result = struct
  type t = {
    response : Get_referenced_by_response.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response =
          required reader (record Get_referenced_by_response.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GatherReferencedByResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Get_referenced_by_response.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.gather_referenced_by_result
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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
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
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.generation_job_params
      (Yojson.Raw.to_string (to_json value))
end

module Get_annotation_history_response = struct
  type t = {
    events : Attributed_event.t list;
    total : float;
    annotation_id : string;
    resource_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        events =
          required reader (list (record Attributed_event.project)) "events";
        total = required reader float "total";
        annotation_id = required reader string "annotationId";
        resource_id = required reader string "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.get_annotation_history_response
      (Yojson.Raw.to_string (to_json value))
end

module Get_events_response = struct
  type t = {
    events : Attributed_event.t list;
    total : float;
    resource_id : string;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        events =
          required reader (list (record Attributed_event.project)) "events";
        total = required reader float "total";
        resource_id = required reader string "resourceId";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetEventsResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("events", Some ((json_list Attributed_event.to_json) value.events));
        ("total", Some (json_float value.total));
        ("resourceId", Some (json_string value.resource_id));
      ]
      value.extra

  let to_model value =
    Models.decode Models.get_events_response
      (Yojson.Raw.to_string (to_json value))
end

module Get_tag_schemas_response = struct
  type t = {
    tag_schemas : Tag_schema.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        tag_schemas =
          required reader (list (record Tag_schema.project)) "tagSchemas";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `GetTagSchemasResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("tagSchemas", Some ((json_list Tag_schema.to_json) value.tag_schemas));
      ]
      value.extra

  let to_model value =
    Models.decode Models.get_tag_schemas_response
      (Yojson.Raw.to_string (to_json value))
end

module Mark_create_request = struct
  type t = {
    resource_id : string;
    request : Create_annotation_request.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        request =
          required reader (record Create_annotation_request.project) "request";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MarkCreateRequest ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("request", Some (Create_annotation_request.to_json value.request));
      ]
      value.extra

  let to_model value =
    Models.decode Models.mark_create_request
      (Yojson.Raw.to_string (to_json value))
end

module Match_search_request = struct
  type t = {
    resource_id : string;
    reference_id : string;
    context : Gathered_context.t;
    limit : int option;
    use_semantic_scoring : bool option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource_id = required reader string "resourceId";
        reference_id = required reader string "referenceId";
        context = required reader (record Gathered_context.project) "context";
        limit = maybe reader int "limit";
        use_semantic_scoring = maybe reader bool "useSemanticScoring";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.match_search_request
      (Yojson.Raw.to_string (to_json value))
end

module Match_resources_result = struct
  type t = {
    response : Match_resources_response.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response =
          required reader (record Match_resources_response.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `MatchResourcesResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Match_resources_response.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.match_resources_result
      (Yojson.Raw.to_string (to_json value))
end

module Tag_schema_added_payload = struct
  type t = { schema : Tag_schema.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      {
        schema = required reader (record Tag_schema.project) "schema";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `TagSchemaAddedPayload ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write [ ("schema", Some (Tag_schema.to_json value.schema)) ] value.extra

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
    write
      [
        ("resourceId", Some (json_string value.resource_id));
        ("schema", Option.map Tag_schema.to_json value.schema);
      ]
      value.extra

  let to_model value =
    Models.decode Models.job_params (Yojson.Raw.to_string (to_json value))
end

module Resource_view = struct
  type t = {
    resource : Resource_descriptor.t;
    annotations : Resource_annotations.t;
    last_sequence : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        resource =
          required reader (record Resource_descriptor.project) "resource";
        annotations =
          required reader (record Resource_annotations.project) "annotations";
        last_sequence = required reader int "lastSequence";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ResourceView ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("resource", Some (Resource_descriptor.to_json value.resource));
        ("annotations", Some (Resource_annotations.to_json value.annotations));
        ("lastSequence", Some (json_int value.last_sequence));
      ]
      value.extra

  let to_model value =
    Models.decode Models.resource_view (Yojson.Raw.to_string (to_json value))
end

module Tag_schemas_projection = struct
  type t = {
    tag_schemas : Tag_schema.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        tag_schemas =
          required reader (list (record Tag_schema.project)) "tagSchemas";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `TagSchemasProjection ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("tagSchemas", Some ((json_list Tag_schema.to_json) value.tag_schemas));
      ]
      value.extra

  let to_model value =
    Models.decode Models.tag_schemas_projection
      (Yojson.Raw.to_string (to_json value))
end

module Archivist_events_response = struct
  type t = {
    events : Stored_event_response.t list;
    last_sequence : int;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        events =
          required reader (list (record Stored_event_response.project)) "events";
        last_sequence = required reader int "lastSequence";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `ArchivistEventsResponse ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("events", Some ((json_list Stored_event_response.to_json) value.events));
        ("lastSequence", Some (json_int value.last_sequence));
      ]
      value.extra

  let to_model value =
    Models.decode Models.archivist_events_response
      (Yojson.Raw.to_string (to_json value))
end

module Settings_list_result = struct
  type t = {
    root : string option;
    unresolved : string option;
    settings : Setting.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        root = maybe reader string "root";
        unresolved = maybe reader string "unresolved";
        settings = required reader (list (record Setting.project)) "settings";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `SettingsListResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("root", Option.map json_string value.root);
        ("unresolved", Option.map json_string value.unresolved);
        ("settings", Some ((json_list Setting.to_json) value.settings));
      ]
      value.extra

  let to_model value =
    Models.decode Models.settings_list_result
      (Yojson.Raw.to_string (to_json value))
end

module Stack_start_result = struct
  type t = {
    dry_run : bool;
    knowledge_base : Knowledge_base_status.t option;
    shared : Service_status.t list option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        dry_run = required reader bool "dryRun";
        knowledge_base =
          maybe reader (record Knowledge_base_status.project) "knowledgeBase";
        shared = maybe reader (list (record Service_status.project)) "shared";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.stack_start_result
      (Yojson.Raw.to_string (to_json value))
end

module Stack_stop_result = struct
  type t = {
    dry_run : bool;
    knowledge_bases : Knowledge_base_status.t list option;
    shared : Service_status.t list option;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        dry_run = required reader bool "dryRun";
        knowledge_bases =
          maybe reader
            (list (record Knowledge_base_status.project))
            "knowledgeBases";
        shared = maybe reader (list (record Service_status.project)) "shared";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.stack_stop_result
      (Yojson.Raw.to_string (to_json value))
end

module Status_snapshot_result = struct
  type t = {
    knowledge_bases : Knowledge_base_status.t list;
    shared : Service_status.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        knowledge_bases =
          required reader
            (list (record Knowledge_base_status.project))
            "knowledgeBases";
        shared = required reader (list (record Service_status.project)) "shared";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.status_snapshot_result
      (Yojson.Raw.to_string (to_json value))
end

module Librarian_config = struct
  type t = {
    kb : Kb_identity.t;
    gateway_url : string;
    identity : Service_identity.t;
    archivist : Service_address.t;
    graph : Yojson.Raw.t;
    vectors : Yojson.Raw.t;
    embedding : Yojson.Raw.t;
    matcher : Librarian_engine_config.t;
    gatherer : Librarian_engine_config.t;
    model_catalogue : string;
    gather : Yojson.Raw.t;
    search : Yojson.Raw.t;
    port : int;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        kb = required reader (record Kb_identity.project) "kb";
        gateway_url = required reader string "gatewayUrl";
        identity = required reader (record Service_identity.project) "identity";
        archivist = required reader (record Service_address.project) "archivist";
        graph = required reader raw "graph";
        vectors = required reader raw "vectors";
        embedding = required reader raw "embedding";
        matcher =
          required reader (record Librarian_engine_config.project) "matcher";
        gatherer =
          required reader (record Librarian_engine_config.project) "gatherer";
        model_catalogue = required reader string "modelCatalogue";
        gather = required reader raw "gather";
        search = required reader raw "search";
        port = required reader int "port";
        log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
        log_format =
          required reader (enum Enums.Log_format.of_string) "logFormat";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `LibrarianConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("kb", Some (Kb_identity.to_json value.kb));
        ("gatewayUrl", Some (json_string value.gateway_url));
        ("identity", Some (Service_identity.to_json value.identity));
        ("archivist", Some (Service_address.to_json value.archivist));
        ("graph", Some (json_raw value.graph));
        ("vectors", Some (json_raw value.vectors));
        ("embedding", Some (json_raw value.embedding));
        ("matcher", Some (Librarian_engine_config.to_json value.matcher));
        ("gatherer", Some (Librarian_engine_config.to_json value.gatherer));
        ("modelCatalogue", Some (json_string value.model_catalogue));
        ("gather", Some (json_raw value.gather));
        ("search", Some (json_raw value.search));
        ("port", Some (json_int value.port));
        ( "logLevel",
          Some ((json_enum Enums.Log_level.to_string) value.log_level) );
        ( "logFormat",
          Some ((json_enum Enums.Log_format.to_string) value.log_format) );
      ]
      value.extra

  let to_model value =
    Models.decode Models.librarian_config (Yojson.Raw.to_string (to_json value))
end

module Worker_knowledge_base_config = struct
  type t = {
    domain : string;
    gateway_url : string;
    identity : Yojson.Raw.t;
    engines : Worker_engine_config.t list;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        domain = required reader string "domain";
        gateway_url = required reader string "gatewayUrl";
        identity = required reader raw "identity";
        engines =
          required reader (list (record Worker_engine_config.project)) "engines";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `WorkerKnowledgeBaseConfig ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("domain", Some (json_string value.domain));
        ("gatewayUrl", Some (json_string value.gateway_url));
        ("identity", Some (json_raw value.identity));
        ( "engines",
          Some ((json_list Worker_engine_config.to_json) value.engines) );
      ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        domain = required reader string "domain";
        state = required reader (enum State.of_string) "state";
        did = maybe reader string "did";
        engines =
          maybe reader (list (record Worker_engine_health.project)) "engines";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.worker_knowledge_base_health
      (Yojson.Raw.to_string (to_json value))
end

module Browse_annotation_history_result = struct
  type t = {
    response : Get_annotation_history_response.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response =
          required reader
            (record Get_annotation_history_response.project)
            "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseAnnotationHistoryResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ( "response",
          Some (Get_annotation_history_response.to_json value.response) );
      ]
      value.extra

  let to_model value =
    Models.decode Models.browse_annotation_history_result
      (Yojson.Raw.to_string (to_json value))
end

module Browse_events_result = struct
  type t = {
    response : Get_events_response.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response =
          required reader (record Get_events_response.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseEventsResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Get_events_response.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.browse_events_result
      (Yojson.Raw.to_string (to_json value))
end

module Browse_tag_schemas_result = struct
  type t = {
    response : Get_tag_schemas_response.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        response =
          required reader (record Get_tag_schemas_response.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `BrowseTagSchemasResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Get_tag_schemas_response.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.browse_tag_schemas_result
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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        field_user_id = maybe reader string "_userId";
        field_roles = maybe reader (list string) "_roles";
        job_type = required reader (enum Job_type.of_string) "jobType";
        params = required reader (record Generation_job_params.project) "params";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.yield_job_create_command
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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader (enum Status.of_string) "status";
        metadata = required reader (record Job_metadata.project) "metadata";
        params = required reader (record Job_params.project) "params";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobPending ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("metadata", Some (Job_metadata.to_json value.metadata));
        ("params", Some (Job_params.to_json value.params));
      ]
      value.extra

  let to_model value =
    Models.decode Models.job_pending (Yojson.Raw.to_string (to_json value))
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
    progress : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader (enum Status.of_string) "status";
        metadata = required reader (record Job_metadata.project) "metadata";
        params = required reader (record Job_params.project) "params";
        started_at = required reader string "startedAt";
        progress = required reader raw "progress";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobRunning ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [
        ("status", Some ((json_enum Status.to_string) value.status));
        ("metadata", Some (Job_metadata.to_json value.metadata));
        ("params", Some (Job_params.to_json value.params));
        ("startedAt", Some (json_string value.started_at));
        ("progress", Some (json_raw value.progress));
      ]
      value.extra

  let to_model value =
    Models.decode Models.job_running (Yojson.Raw.to_string (to_json value))
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
    result : Yojson.Raw.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader (enum Status.of_string) "status";
        metadata = required reader (record Job_metadata.project) "metadata";
        params = required reader (record Job_params.project) "params";
        started_at = required reader string "startedAt";
        completed_at = required reader string "completedAt";
        result = required reader raw "result";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
        ("result", Some (json_raw value.result));
      ]
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader (enum Status.of_string) "status";
        metadata = required reader (record Job_metadata.project) "metadata";
        params = required reader (record Job_params.project) "params";
        started_at = maybe reader string "startedAt";
        completed_at = required reader string "completedAt";
        error = required reader string "error";
        failure_class =
          maybe reader (enum Enums.Failure_class.of_string) "failureClass";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader (enum Status.of_string) "status";
        metadata = required reader (record Job_metadata.project) "metadata";
        params = required reader (record Job_params.project) "params";
        started_at = maybe reader string "startedAt";
        completed_at = required reader string "completedAt";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.job_cancelled (Yojson.Raw.to_string (to_json value))
end

module Worker_config = struct
  type t = {
    knowledge_bases : Worker_knowledge_base_config.t list;
    model_catalogue : string;
    port : int;
    log_level : Enums.Log_level.t;
    log_format : Enums.Log_format.t;
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        knowledge_bases =
          required reader
            (list (record Worker_knowledge_base_config.project))
            "knowledgeBases";
        model_catalogue = required reader string "modelCatalogue";
        port = required reader int "port";
        log_level = required reader (enum Enums.Log_level.of_string) "logLevel";
        log_format =
          required reader (enum Enums.Log_format.of_string) "logFormat";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

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
    extra : (string * Yojson.Raw.t) list;
  }

  let project fields =
    let reader = start fields in
    let record =
      {
        status = required reader (enum Status.of_string) "status";
        knowledge_bases =
          required reader
            (list (record Worker_knowledge_base_health.project))
            "knowledgeBases";
        extra = [];
      }
    in
    { record with extra = rest reader }

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
      value.extra

  let to_model value =
    Models.decode Models.worker_health (Yojson.Raw.to_string (to_json value))
end

module Job_claimed_result = struct
  type t = { response : Job_running.t; extra : (string * Yojson.Raw.t) list }

  let project fields =
    let reader = start fields in
    let record =
      {
        response = required reader (record Job_running.project) "response";
        extra = [];
      }
    in
    { record with extra = rest reader }

  let of_model (model : [ `JobClaimedResult ] Models.t) =
    project (fields_of (Models.json model))

  let to_json (value : t) =
    write
      [ ("response", Some (Job_running.to_json value.response)) ]
      value.extra

  let to_model value =
    Models.decode Models.job_claimed_result
      (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | Person value -> Agent_person.to_json value
    | Organization value -> Agent_organization.to_json value
    | Software value -> Agent_software.to_json value

  let to_model value =
    Models.decode Models.agent (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | TextualBody value -> Textual_body.to_json value
    | SpecificResource value -> Specific_resource.to_json value

  let to_model value =
    Models.decode Models.annotation_body (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | Extracted value -> Extracted_text.to_json value
    | Declined value -> Extraction_declined.to_json value
    | NotYet value -> Anchored_text_absent.to_json value
    | NoMap value -> Anchored_text_absent.to_json value
    | Unknown value -> Anchored_text_absent.to_json value

  let to_model value =
    Models.decode Models.anchored_text_answer
      (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | File value -> File_entry.to_json value
    | Dir value -> Dir_entry.to_json value

  let to_model value =
    Models.decode Models.directory_entry (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | Extracted value -> Extracted_text.to_json value
    | Declined value -> Extraction_declined.to_json value

  let to_model value =
    Models.decode Models.extraction_outcome
      (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | Mark value -> Mark_job_complete_command.to_json value
    | Yield value -> Yield_job_complete_command.to_json value

  let to_model value =
    Models.decode Models.job_complete_command
      (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | Mark value -> Mark_job_create_command.to_json value
    | Yield value -> Yield_job_create_command.to_json value

  let to_model value =
    Models.decode Models.job_create_command
      (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | Loading value -> Job_progress_loading.to_json value
    | Analyzing value -> Job_progress_analyzing.to_json value
    | AnalyzingTags value -> Job_progress_analyzing_tags.to_json value
    | GeneratingResource value -> Job_progress_generating_resource.to_json value
    | CreatingResource value -> Job_progress_creating_resource.to_json value
    | CompleteGenerated value -> Job_progress_complete_generated.to_json value
    | DetectingEntities value -> Job_progress_detecting_entities.to_json value
    | CreatingAnnotations value ->
        Job_progress_creating_annotations.to_json value
    | CreatingTagAnnotations value ->
        Job_progress_creating_tag_annotations.to_json value
    | CompleteCreated value -> Job_progress_complete_created.to_json value

  let to_model value =
    Models.decode Models.job_progress_message
      (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | Mark value -> Mark_job_queued_event.to_json value
    | Yield value -> Yield_job_queued_event.to_json value

  let to_model value =
    Models.decode Models.job_queued_event (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | Http value -> Http_endpoint.to_json value
    | Local value -> Local_endpoint.to_json value

  let to_model value =
    Models.decode Models.kb_endpoint (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | TextPositionSelector value -> Text_position_selector.to_json value
    | TextQuoteSelector value -> Text_quote_selector.to_json value
    | SvgSelector value -> Svg_selector.to_json value
    | FragmentSelector value -> Fragment_selector.to_json value

  let to_model value =
    Models.decode Models.selector (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | Highlighting value -> Highlighting_job_params.to_json value
    | Commenting value -> Commenting_job_params.to_json value
    | Assessing value -> Assessing_job_params.to_json value
    | Linking value -> Linking_job_params.to_json value
    | Tagging value -> Tagging_job_params.to_json value

  let to_model value =
    Models.decode Models.mark_job_params (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | Mark value -> Mark_job_filter.to_json value
    | Yield value -> Yield_job_filter.to_json value

  let to_model value =
    Models.decode Models.job_filter (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | Pending value -> Job_pending.to_json value
    | Running value -> Job_running.to_json value
    | Complete value -> Job_complete.to_json value
    | Failed value -> Job_failed.to_json value
    | Cancelled value -> Job_cancelled.to_json value

  let to_model value =
    Models.decode Models.job (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | Ollama value -> Ollama_embedding_config.to_json value
    | Voyage value -> Voyage_embedding_config.to_json value

  let to_model value =
    Models.decode Models.embedding_config (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | Neo4j value -> Neo4j_graph_config.to_json value
    | Janusgraph value -> Janus_graph_config.to_json value
    | Neptune value -> Neptune_graph_config.to_json value
    | Memory value -> Memory_graph_config.to_json value

  let to_model value =
    Models.decode Models.graph_config (Yojson.Raw.to_string (to_json value))
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

  let to_json = function
    | Qdrant value -> Qdrant_vectors_config.to_json value
    | Memory value -> Memory_vectors_config.to_json value

  let to_model value =
    Models.decode Models.vectors_config (Yojson.Raw.to_string (to_json value))
end

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
  type t = { did : string; description : [ `KbDescription ] Models.t }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* did = required string "did" members in
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
          ("did", Some (json_string value.did));
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
    motivation : [ `Motivation ] Models.t;
  }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members ->
        let* selector =
          required (model Models.annotation_selector) "selector" members
        in
        let* motivation =
          required (model Models.motivation) "motivation" members
        in
        Ok { selector; motivation }
    | _ -> malformed ""

  let to_json : t -> Yojson.Safe.t =
    let open Table_codec in
    fun value ->
      write
        [
          ("selector", Some (json_model value.selector));
          ("motivation", Some (json_model value.motivation));
        ]
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

module Upload_progress = struct
  type t =
    | Started of { total_bytes : int }
    | Progress of { bytes_uploaded : int; total_bytes : int }
    | Finished of { resource_id : string }

  let of_json : Yojson.Safe.t -> (t, Models.fault) result =
    let open Table_codec in
    function
    | `Assoc members -> (
        let* tag = required string "phase" members in
        match tag with
        | "started" ->
            let* total_bytes = required int "totalBytes" members in
            Ok (Started { total_bytes })
        | "progress" ->
            let* bytes_uploaded = required int "bytesUploaded" members in
            let* total_bytes = required int "totalBytes" members in
            Ok (Progress { bytes_uploaded; total_bytes })
        | "finished" ->
            let* resource_id = required string "resourceId" members in
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
            ("totalBytes", Some (json_int value.total_bytes));
          ]
    | Progress value ->
        write
          [
            ("phase", Some (json_string "progress"));
            ("bytesUploaded", Some (json_int value.bytes_uploaded));
            ("totalBytes", Some (json_int value.total_bytes));
          ]
    | Finished value ->
        write
          [
            ("phase", Some (json_string "finished"));
            ("resourceId", Some (json_string value.resource_id));
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
