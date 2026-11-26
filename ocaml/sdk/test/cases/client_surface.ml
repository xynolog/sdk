(* Generated from protocol/specs/src/client/surface.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type shapes = {
  promise : string;
  stream : string;
  delegation : string;
  upload : string;
  cache : string;
  signal : string;
  count : string;
  events : string;
  claims : string;
}

let shapes_json (r : shapes) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("promise", (fun s -> `String s) r.promise);
         Option.Some ("stream", (fun s -> `String s) r.stream);
         Option.Some ("delegation", (fun s -> `String s) r.delegation);
         Option.Some ("upload", (fun s -> `String s) r.upload);
         Option.Some ("cache", (fun s -> `String s) r.cache);
         Option.Some ("signal", (fun s -> `String s) r.signal);
         Option.Some ("count", (fun s -> `String s) r.count);
         Option.Some ("events", (fun s -> `String s) r.events);
         Option.Some ("claims", (fun s -> `String s) r.claims);
       ])

type via = {
  request : string;
  emit : string;
  local : string;
  content : string;
  gateway : string;
  observes : string;
}

let via_json (r : via) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("request", (fun s -> `String s) r.request);
         Option.Some ("emit", (fun s -> `String s) r.emit);
         Option.Some ("local", (fun s -> `String s) r.local);
         Option.Some ("content", (fun s -> `String s) r.content);
         Option.Some ("gateway", (fun s -> `String s) r.gateway);
         Option.Some ("observes", (fun s -> `String s) r.observes);
       ])

type fixtures = { context : Yojson.Safe.t; selector : Yojson.Safe.t }

let fixtures_json (r : fixtures) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("context", Fun.id r.context);
         Option.Some ("selector", Fun.id r.selector);
       ])

type shape =
  | Promise
  | Stream
  | Delegation
  | Upload
  | Cache
  | Signal
  | Count
  | Events
  | Claims

let shape_value = function
  | (Promise : shape) -> "promise"
  | (Stream : shape) -> "stream"
  | (Delegation : shape) -> "delegation"
  | (Upload : shape) -> "upload"
  | (Cache : shape) -> "cache"
  | (Signal : shape) -> "signal"
  | (Count : shape) -> "count"
  | (Events : shape) -> "events"
  | (Claims : shape) -> "claims"

let shape_json v = `String (shape_value v)

type request = { request : string }

let request_json (r : request) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("request", (fun s -> `String s) r.request) ])

type emit = { emit : string }

let emit_json (r : emit) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("emit", (fun s -> `String s) r.emit) ])

type local = { local : string }

let local_json (r : local) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("local", (fun s -> `String s) r.local) ])

type content = { content : string }

let content_json (r : content) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("content", (fun s -> `String s) r.content) ])

type gateway = { gateway : string }

let gateway_json (r : gateway) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("gateway", (fun s -> `String s) r.gateway) ])

type observes = { observes : string }

let observes_json (r : observes) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("observes", (fun s -> `String s) r.observes) ])

type item_via =
  | Request of request
  | Emit of emit
  | Local of local
  | Content of content
  | Gateway of gateway
  | Observes of observes

let item_via_json = function
  | (Request v : item_via) -> request_json v
  | (Emit v : item_via) -> emit_json v
  | (Local v : item_via) -> local_json v
  | (Content v : item_via) -> content_json v
  | (Gateway v : item_via) -> gateway_json v
  | (Observes v : item_via) -> observes_json v

type value_schema = { type_parameter : string }

let value_schema_json (r : value_schema) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("typeParameter", (fun s -> `String s) r.type_parameter) ])

type reference = {
  ref : string;
  type_arguments : (string * value_schema) list option;
}

let reference_json (r : reference) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$ref", (fun s -> `String s) r.ref);
         Option.map
           (fun v ->
             ( "typeArguments",
               (fun l ->
                 `Assoc (List.map (fun (k, v) -> (k, value_schema_json v)) l))
                 v ))
           r.type_arguments;
       ])

type type_ = Integer | String | Boolean

let type__value = function
  | (Integer : type_) -> "integer"
  | (String : type_) -> "string"
  | (Boolean : type_) -> "boolean"

let type__json v = `String (type__value v)

type scalar = {
  type_ : type_;
  minimum : int option;
  format : string option;
  description : string;
}

let scalar_json (r : scalar) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("type", type__json r.type_);
         Option.map (fun v -> ("minimum", (fun n -> `Int n) v)) r.minimum;
         Option.map (fun v -> ("format", (fun s -> `String s) v)) r.format;
         Option.Some ("description", (fun s -> `String s) r.description);
       ])

type by = { member : string }

let by_json (r : by) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("member", (fun s -> `String s) r.member) ])

type decided_decided = { by : by; in_ : string }

let decided_decided_json (r : decided_decided) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("by", by_json r.by);
         Option.Some ("in", (fun s -> `String s) r.in_);
       ])

type decided = { decided : decided_decided }

let decided_json (r : decided) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("decided", decided_decided_json r.decided) ])

type schema =
  | Reference of reference
  | Scalar of scalar
  | Type_parameter of value_schema
  | Decided of decided

let schema_json = function
  | (Reference v : schema) -> reference_json v
  | (Scalar v : schema) -> scalar_json v
  | (Type_parameter v : schema) -> value_schema_json v
  | (Decided v : schema) -> decided_json v

type value = {
  parameter : string;
  schema : schema option;
  required : bool;
  absent : bool option;
}

let value_json (r : value) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("parameter", (fun s -> `String s) r.parameter);
         Option.map (fun v -> ("schema", schema_json v)) r.schema;
         Option.Some ("required", (fun b -> `Bool b) r.required);
         Option.map (fun v -> ("absent", (fun b -> `Bool b) v)) r.absent;
       ])

type callback = {
  parameter : string;
  calls : schema;
  required : bool;
  returns : schema option;
}

let callback_json (r : callback) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("parameter", (fun s -> `String s) r.parameter);
         Option.Some ("calls", schema_json r.calls);
         Option.Some ("required", (fun b -> `Bool b) r.required);
         Option.Some
           ( "returns",
             (function Option.None -> `Null | Option.Some v -> schema_json v)
               r.returns );
       ])

type parameters_item = Value of value | Callback of callback

let parameters_item_json = function
  | (Value v : parameters_item) -> value_json v
  | (Callback v : parameters_item) -> callback_json v

type then_item_request = { request : string; sends : Yojson.Safe.t }

let then_item_request_json (r : then_item_request) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("request", (fun s -> `String s) r.request);
         Option.Some ("sends", Fun.id r.sends);
       ])

type then_item_content = { content : string; sends : Yojson.Safe.t }

let then_item_content_json (r : then_item_content) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("content", (fun s -> `String s) r.content);
         Option.Some ("sends", Fun.id r.sends);
       ])

type then_item = Request of then_item_request | Content of then_item_content

let then_item_json = function
  | (Request v : then_item) -> then_item_request_json v
  | (Content v : then_item) -> then_item_content_json v

type cases_item = {
  why : string option;
  args : Yojson.Safe.t;
  sends : Yojson.Safe.t;
  answers : Yojson.Safe.t option;
  then_ : then_item list option;
  correlation_id : string option;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.map (fun v -> ("why", (fun s -> `String s) v)) r.why;
         Option.Some ("args", Fun.id r.args);
         Option.Some ("sends", Fun.id r.sends);
         Option.map (fun v -> ("answers", Fun.id v)) r.answers;
         Option.map
           (fun v -> ("then", (fun l -> `List (List.map then_item_json l)) v))
           r.then_;
         Option.map
           (fun v -> ("correlationId", (fun s -> `String s) v))
           r.correlation_id;
       ])

type methods_item = {
  method_ : string;
  shape : shape;
  via : item_via;
  parameters : parameters_item list;
  returns : schema option;
  cases : cases_item list;
}

let methods_item_json (r : methods_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("method", (fun s -> `String s) r.method_);
         Option.Some ("shape", shape_json r.shape);
         Option.Some ("via", item_via_json r.via);
         Option.Some
           ( "parameters",
             (fun l -> `List (List.map parameters_item_json l)) r.parameters );
         Option.Some
           ( "returns",
             (function Option.None -> `Null | Option.Some v -> schema_json v)
               r.returns );
         Option.Some
           ("cases", (fun l -> `List (List.map cases_item_json l)) r.cases);
       ])

type namespaces_item = {
  namespace : string;
  docs : string;
  methods : methods_item list;
}

let namespaces_item_json (r : namespaces_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("namespace", (fun s -> `String s) r.namespace);
         Option.Some ("docs", (fun s -> `String s) r.docs);
         Option.Some
           ("methods", (fun l -> `List (List.map methods_item_json l)) r.methods);
       ])

type named_value = { name : string; why : string }

let named_value_json (r : named_value) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("why", (fun s -> `String s) r.why);
       ])

type gives_value = {
  form : string;
  schema : schema option;
  absent : bool option;
}

let gives_value_json (r : gives_value) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("form", (fun s -> `String s) r.form);
         Option.map (fun v -> ("schema", schema_json v)) r.schema;
         Option.map (fun v -> ("absent", (fun b -> `Bool b) v)) r.absent;
       ])

type watched = { form : string; schema : schema option; absent : bool option }

let watched_json (r : watched) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("form", (fun s -> `String s) r.form);
         Option.map (fun v -> ("schema", schema_json v)) r.schema;
         Option.map (fun v -> ("absent", (fun b -> `Bool b) v)) r.absent;
       ])

type stream = { form : string; schema : schema option }

let stream_json (r : stream) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("form", (fun s -> `String s) r.form);
         Option.map (fun v -> ("schema", schema_json v)) r.schema;
       ])

type settles = { form : string }

let settles_json (r : settles) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("form", (fun s -> `String s) r.form) ])

type cancels = { form : string }

let cancels_json (r : cancels) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("form", (fun s -> `String s) r.form) ])

type handed = { handed : string }

let handed_json (r : handed) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("handed", (fun s -> `String s) r.handed) ])

type returns_function = { function_ : string }

let returns_function_json (r : returns_function) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("function", (fun s -> `String s) r.function_) ])

type returns_stream = { stream : schema }

let returns_stream_json (r : returns_stream) =
  `Assoc
    (List.filter_map Fun.id [ Option.Some ("stream", schema_json r.stream) ])

type items = { list : schema }

let items_json (r : items) =
  `Assoc (List.filter_map Fun.id [ Option.Some ("list", schema_json r.list) ])

type returns =
  | Reference of reference
  | Scalar of scalar
  | Type_parameter of value_schema
  | Handed of handed
  | Function of returns_function
  | Stream of returns_stream
  | Items of items

let returns_json = function
  | (Reference v : returns) -> reference_json v
  | (Scalar v : returns) -> scalar_json v
  | (Type_parameter v : returns) -> value_schema_json v
  | (Handed v : returns) -> handed_json v
  | (Function v : returns) -> returns_function_json v
  | (Stream v : returns) -> returns_stream_json v
  | (Items v : returns) -> items_json v

type signature = {
  parameters : parameters_item list;
  returns : returns option;
  absent : bool option;
}

let signature_json (r : signature) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some
           ( "parameters",
             (fun l -> `List (List.map parameters_item_json l)) r.parameters );
         Option.Some
           ( "returns",
             (function Option.None -> `Null | Option.Some v -> returns_json v)
               r.returns );
         Option.map (fun v -> ("absent", (fun b -> `Bool b) v)) r.absent;
       ])

type function_ = { form : string; signature : signature option }

let function__json (r : function_) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("form", (fun s -> `String s) r.form);
         Option.map (fun v -> ("signature", signature_json v)) r.signature;
       ])

type gives =
  | Value of gives_value
  | Watched of watched
  | Stream of stream
  | Settles of settles
  | Cancels of cancels
  | Function of function_

let gives_json = function
  | (Value v : gives) -> gives_value_json v
  | (Watched v : gives) -> watched_json v
  | (Stream v : gives) -> stream_json v
  | (Settles v : gives) -> settles_json v
  | (Cancels v : gives) -> cancels_json v
  | (Function v : gives) -> function__json v

type members_item = {
  member : string;
  named : (string * named_value) list option;
  takes : (string * string) list option;
  gives : gives;
}

let members_item_json (r : members_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("member", (fun s -> `String s) r.member);
         Option.map
           (fun v ->
             ( "named",
               (fun l ->
                 `Assoc (List.map (fun (k, v) -> (k, named_value_json v)) l))
                 v ))
           r.named;
         Option.map
           (fun v ->
             ( "takes",
               (fun l ->
                 `Assoc (List.map (fun (k, v) -> (k, (fun s -> `String s) v)) l))
                 v ))
           r.takes;
         Option.Some ("gives", gives_json r.gives);
       ])

type worker_item = {
  handed : string;
  docs : string;
  record : string option;
  members : members_item list;
}

let worker_item_json (r : worker_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("handed", (fun s -> `String s) r.handed);
         Option.Some ("docs", (fun s -> `String s) r.docs);
         Option.map (fun v -> ("record", (fun s -> `String s) v)) r.record;
         Option.Some
           ("members", (fun l -> `List (List.map members_item_json l)) r.members);
       ])

type type_parameters_item = { name : string; docs : string }

let type_parameters_item_json (r : type_parameters_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("docs", (fun s -> `String s) r.docs);
       ])

type item_members_item = { member : string; gives : gives }

let item_members_item_json (r : item_members_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("member", (fun s -> `String s) r.member);
         Option.Some ("gives", gives_json r.gives);
       ])

type state_units_item = {
  unit : string;
  docs : string;
  made : (string * string) list;
  made_by : (string * string) list;
  type_parameters : type_parameters_item list option;
  members : item_members_item list;
}

let state_units_item_json (r : state_units_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("unit", (fun s -> `String s) r.unit);
         Option.Some ("docs", (fun s -> `String s) r.docs);
         Option.Some
           ( "made",
             (fun l ->
               `Assoc (List.map (fun (k, v) -> (k, (fun s -> `String s) v)) l))
               r.made );
         Option.Some
           ( "madeBy",
             (fun l ->
               `Assoc (List.map (fun (k, v) -> (k, (fun s -> `String s) v)) l))
               r.made_by );
         Option.map
           (fun v ->
             ( "typeParameters",
               (fun l -> `List (List.map type_parameters_item_json l)) v ))
           r.type_parameters;
         Option.Some
           ( "members",
             (fun l -> `List (List.map item_members_item_json l)) r.members );
       ])

type wire_members_item = { member : string; gives : gives }

let wire_members_item_json (r : wire_members_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("member", (fun s -> `String s) r.member);
         Option.Some ("gives", gives_json r.gives);
       ])

type wire = {
  docs : string;
  made : (string * string) list;
  members : wire_members_item list;
}

let wire_json (r : wire) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("docs", (fun s -> `String s) r.docs);
         Option.Some
           ( "made",
             (fun l ->
               `Assoc (List.map (fun (k, v) -> (k, (fun s -> `String s) v)) l))
               r.made );
         Option.Some
           ( "members",
             (fun l -> `List (List.map wire_members_item_json l)) r.members );
       ])

type storage_members_item = { member : string }

let storage_members_item_json (r : storage_members_item) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("member", (fun s -> `String s) r.member) ])

type storage = {
  docs : string;
  made : (string * string) list;
  members : storage_members_item list;
}

let storage_json (r : storage) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("docs", (fun s -> `String s) r.docs);
         Option.Some
           ( "made",
             (fun l ->
               `Assoc (List.map (fun (k, v) -> (k, (fun s -> `String s) v)) l))
               r.made );
         Option.Some
           ( "members",
             (fun l -> `List (List.map storage_members_item_json l)) r.members
           );
       ])

type reader = { member : string; kind : string }

let reader_json (r : reader) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("member", (fun s -> `String s) r.member);
         Option.Some ("kind", (fun s -> `String s) r.kind);
       ])

type modules_item_members_item_function = {
  member : string;
  kind : string;
  named : (string * string) list option;
}

let modules_item_members_item_function_json
    (r : modules_item_members_item_function) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("member", (fun s -> `String s) r.member);
         Option.Some ("kind", (fun s -> `String s) r.kind);
         Option.map
           (fun v ->
             ( "named",
               (fun l ->
                 `Assoc (List.map (fun (k, v) -> (k, (fun s -> `String s) v)) l))
                 v ))
           r.named;
       ])

type modules_item_members_item_type = {
  member : string;
  kind : string;
  named : (string * string) list option;
  fields_named : (string * (string * string) list) list option;
  fields : string list option;
}

let modules_item_members_item_type_json (r : modules_item_members_item_type) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("member", (fun s -> `String s) r.member);
         Option.Some ("kind", (fun s -> `String s) r.kind);
         Option.map
           (fun v ->
             ( "named",
               (fun l ->
                 `Assoc (List.map (fun (k, v) -> (k, (fun s -> `String s) v)) l))
                 v ))
           r.named;
         Option.map
           (fun v ->
             ( "fieldsNamed",
               (fun l ->
                 `Assoc
                   (List.map
                      (fun (k, v) ->
                        ( k,
                          (fun l ->
                            `Assoc
                              (List.map
                                 (fun (k, v) -> (k, (fun s -> `String s) v))
                                 l))
                            v ))
                      l))
                 v ))
           r.fields_named;
         Option.map
           (fun v ->
             ("fields", (fun l -> `List (List.map (fun s -> `String s) l)) v))
           r.fields;
       ])

type names = { replies_of : string list; channels : string list }

let names_json (r : names) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some
           ( "repliesOf",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.replies_of );
         Option.Some
           ( "channels",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.channels );
       ])

type constant = {
  member : string;
  kind : string;
  named : (string * string) list option;
  names : names option;
  value : Yojson.Safe.t option;
}

let constant_json (r : constant) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("member", (fun s -> `String s) r.member);
         Option.Some ("kind", (fun s -> `String s) r.kind);
         Option.map
           (fun v ->
             ( "named",
               (fun l ->
                 `Assoc (List.map (fun (k, v) -> (k, (fun s -> `String s) v)) l))
                 v ))
           r.named;
         Option.map (fun v -> ("names", names_json v)) r.names;
         Option.map (fun v -> ("value", Fun.id v)) r.value;
       ])

type modules_item_members_item =
  | Reader of reader
  | Function of modules_item_members_item_function
  | Type of modules_item_members_item_type
  | Constant of constant

let modules_item_members_item_json = function
  | (Reader v : modules_item_members_item) -> reader_json v
  | (Function v : modules_item_members_item) ->
      modules_item_members_item_function_json v
  | (Type v : modules_item_members_item) ->
      modules_item_members_item_type_json v
  | (Constant v : modules_item_members_item) -> constant_json v

type modules_item = {
  module_ : string;
  docs : string;
  members : modules_item_members_item list;
}

let modules_item_json (r : modules_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("module", (fun s -> `String s) r.module_);
         Option.Some ("docs", (fun s -> `String s) r.docs);
         Option.Some
           ( "members",
             (fun l -> `List (List.map modules_item_members_item_json l))
               r.members );
       ])

type clock_item = {
  source : string;
  docs : string;
  type_words : string list;
  outside : (string * string) list;
  takes : (string * (string * string list) list) list;
}

let clock_item_json (r : clock_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("source", (fun s -> `String s) r.source);
         Option.Some ("docs", (fun s -> `String s) r.docs);
         Option.Some
           ( "typeWords",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.type_words );
         Option.Some
           ( "outside",
             (fun l ->
               `Assoc (List.map (fun (k, v) -> (k, (fun s -> `String s) v)) l))
               r.outside );
         Option.Some
           ( "takes",
             (fun l ->
               `Assoc
                 (List.map
                    (fun (k, v) ->
                      ( k,
                        (fun l ->
                          `Assoc
                            (List.map
                               (fun (k, v) ->
                                 ( k,
                                   (fun l ->
                                     `List (List.map (fun s -> `String s) l))
                                     v ))
                               l))
                          v ))
                    l))
               r.takes );
       ])

type t = {
  comment : string;
  shapes : shapes;
  via : via;
  fixtures : fixtures;
  namespaces : namespaces_item list;
  worker : worker_item list;
  state_units : state_units_item list;
  wire : wire;
  storage : storage;
  modules : modules_item list;
  clock : clock_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some ("shapes", shapes_json r.shapes);
         Option.Some ("via", via_json r.via);
         Option.Some ("fixtures", fixtures_json r.fixtures);
         Option.Some
           ( "namespaces",
             (fun l -> `List (List.map namespaces_item_json l)) r.namespaces );
         Option.Some
           ("worker", (fun l -> `List (List.map worker_item_json l)) r.worker);
         Option.Some
           ( "stateUnits",
             (fun l -> `List (List.map state_units_item_json l)) r.state_units
           );
         Option.Some ("wire", wire_json r.wire);
         Option.Some ("storage", storage_json r.storage);
         Option.Some
           ("modules", (fun l -> `List (List.map modules_item_json l)) r.modules);
         Option.Some
           ("clock", (fun l -> `List (List.map clock_item_json l)) r.clock);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for the surface of a Xynolog client: every namespace, every \
        method, the shape of what it returns, and what calling it does first. \
        Its behaviour is run: each SDK's surface test calls every method as \
        each of its `cases` states and holds what the call did to the row. \
        Which methods an SDK has is held by its own surface test, where the \
        test keeps a census of them; what each takes and returns is held by no \
        check yet. `parameters` is what a method takes, in order: each \
        parameter by the name its cases' `args` give it, whether a caller must \
        give it, and either its `schema` (a component, a member within one, or \
        a client type of specs/src/client/types, so that every object is \
        named; or a scalar where none states it) or, for a callback, the \
        schema of what each call hands it (`calls`). Protocol's reader holds \
        each case to its method's `parameters` (reader/lib/client_surface.ml): \
        a case gives no argument the method does not take, every one it \
        requires, and each as its parameter's schema says. A null is a value, \
        which a caller gives only where the schema admits it. Every SDK takes \
        each parameter the table states, and none another: an SDK's name for \
        one is the table's, spelled by its language's convention, and how it \
        takes one is its language's (positionally, by keyword, or as a member \
        of a record its writer makes of an object whose members a caller may \
        each leave out), as is the type it holds a count of milliseconds as. A \
        language's own means of cancelling a call (Go's `context.Context`, \
        C#'s `CancellationToken`) is no parameter here. The consumer-owned \
        generator is to write each SDK's namespace types from each method's \
        `parameters` and `shape`. A method name is the table's, in camelCase; \
        an SDK spells it by its language's convention (`resourceContent` is \
        `resource_content` in Rust and `ResourceContent` in Go, whose first \
        letter is a capital), and a namespace whose name is a keyword there \
        takes a trailing underscore (`yield_`, `match_`). Swift keeps both \
        names, including its contextual `yield`. Neither is a keyword in \
        Kotlin, which keeps both names; Java reaches them through their \
        getters (`getYield()`), which Java's contextual `yield` does not \
        touch. An `events` row is a property named `<method>$` in TypeScript. \
        The table names no SDK that lacks part of the surface: which SDK lacks \
        a method, a member, a unit, a module or a clock's maker, or is still \
        to have one, and why, is each SDK repository's to record. Add a row \
        here before adding a method to any SDK. `worker` is the surface of \
        what a worker is handed: the claims `job.claim` returns, and a job the \
        worker holds. Each lists its members by name, and every SDK is to \
        match the list both ways: it lacks no member the list has, and has no \
        public member the list lacks. No check holds an SDK to the list yet. A \
        member is matched by its name alone, spelled as its language spells \
        it, and its form is its language's: what a held job states is a \
        property in TypeScript and Python and a method in Rust, and a property \
        that gives a stream of values is named `<member>$` in TypeScript. What \
        a language's own protocols give a type is no member here: how a type \
        is made, Python's names that begin with an underscore, its \
        `__aenter__` and `__anext__` among them, Rust's trait implementations, \
        and what a TypeScript class inherits from a class the SDK does not \
        declare. `named` gives the name an SDK has the member under where its \
        ecosystem has a name of its own for it, and why: that SDK then has \
        that name, and not the table's as well. `takes` marks a member a held \
        job has as its verb's: for each verb, the schema of what the member \
        takes. What a member does is not held here and these rows have no \
        cases: contract/WORKER-CONTRACT.md states it, and the worker \
        conformance suite (conformance/worker) holds each SDK to it. Add a \
        member here before adding it to any SDK. `stateUnits` lists each state \
        unit: what each SDK makes it as (`made`), and its members by name. \
        Every SDK is to match it both ways, and no check holds one to it yet: \
        it declares every unit, each as a `StateUnit`; every `StateUnit` it \
        declares among its units is one a row makes; and each of its units has \
        every member the list has and no public member the list lacks. A \
        member is matched by its name alone, spelled as its language spells \
        it, and its form is its language's, as for `worker`. `dispose` is no \
        member here: every unit has it, being a `StateUnit`. How a unit is \
        made is stated apart from its members: every unit can be made from \
        outside its SDK, by the type's own public constructor (Rust's `pub fn \
        new` in the type's own `impl`, Python's class), or by the public \
        function that `madeBy` names for that SDK, spelled as that SDK spells \
        it, where the constructor is not what makes it; Go has no \
        constructors, so every Go unit names one. No unit is without a public \
        way to make it, and a `madeBy` names a function its SDK has publicly. \
        Public is reachable from outside the SDK, including what Swift \
        declares `public` or `open`: what TypeScript's entry exports, an item \
        a module Rust's crate root reaches declares or re-exports, a name in \
        the `__all__` of a Python module whose path has no private part, what \
        Kotlin declares `public`, and what Go exports from a package that is \
        not internal. What a unit does is not held here: each SDK's tests of \
        its units hold that. Add a unit or a member here before adding it to \
        any SDK. `wire` is the typed bus over a client's transport, which \
        every client hands out as `wire`: what each SDK makes it as (`made`), \
        and its members by name. Every SDK is to match it both ways, as for a \
        state unit, and no check holds one to it yet: it declares a bus, and \
        its bus has every member the list has and no public member the list \
        lacks. A member is matched by its name alone, as for `worker`; how a \
        bus is made is no member. A Go method takes no type parameters, so a \
        member of Go's bus that is generic in its channel is a function of its \
        package that takes the bus (`Emit(ctx, w, bus.MarkSubmit, payload)`). \
        TypeScript's bus is read where @xynolog/core declares it. A transport \
        is no member: a bus hands out none. Add a member here before adding it \
        to any SDK. `storage` is where a client keeps text under a key: the \
        interface an application implements (a trait in Rust, a protocol in \
        Python), what each SDK names it (`made`), and its members by name. \
        Every SDK is to match it both ways, as for `wire`, and no check holds \
        one to it yet: it declares a storage, and its storage has every member \
        the list has and no public member the list lacks. A member is matched \
        by its name alone, as for `worker`. What implements a storage is not \
        read here. Add a member here before adding it to any SDK. `modules` is \
        what each SDK has beside its namespaces: the free functions, types and \
        values of its modules, each module with its members. A member is named \
        as the table spells it and matched by its `kind`: a `function` is \
        spelled by each language's convention, a `reader` as a function but \
        `get` and its name in TypeScript, a `type` as the table spells it, and \
        a `constant` in capitals with underscores but in Go, as a function, \
        and in Swift, as the table spells it. `named` gives an SDK's own name \
        where the rule does not, and is stale once it is not so. `clock` is \
        what a caller controls of an SDK's time and chance: the clock every \
        wait keeps, and the random source every jitter draws, one row each. \
        For every SDK a row says either how a caller controls the source from \
        outside the SDK (`outside`), or which public makers take it (`takes`): \
        each maker as its SDK spells it (`Type.member`, or `Type::member` in \
        Rust, for a type's function), with the types it takes the source as. \
        Every SDK is to match it both ways, and no check holds one to it yet: \
        every public way of making a listed maker takes each of its types, or \
        is handed another maker of the row that takes them already, and keeps \
        that one's; and no parameter or field of an `outside` SDK has a type \
        the row's `typeWords` name. When a wait ends under a moved clock is \
        specs/src/client/clock-cases.json's.";
     shapes =
       ({
          promise =
            "Asked once, answered once: the value, or a failure with a code.";
          stream =
            "A long-running operation: what it reports as it goes, then its \
             final value. Awaited, it gives the final value.";
          delegation =
            "A job another party does: the job's events as it goes, the \
             queue's naming of it the first of them and its completion the \
             last. Awaited, it gives the completion.";
          upload =
            "An upload in flight: its progress, then the id of the resource \
             created.";
          cache =
            "A live query. Building it touches nothing; its one-shot read asks \
             the service now.";
          signal =
            "Fire-and-forget. Nothing is returned and nothing is awaited.";
          count =
            "A drive at the other participants: resolves with how many the \
             gateway reached, or with no count when it kept none.";
          events =
            "The events of one channel of the client's own bus, from now on.";
          claims =
            "A worker's claims: each job it comes to hold, one at a time, from \
             the first claim on. A held job starts, reports and settles \
             itself.";
        }
         : shapes);
     via =
       ({
          request =
            "A request of a bus operation, answered on its result or failure \
             channel.";
          emit = "A frame sent over the wire, with no reply awaited.";
          local = "A frame published on the client's own bus and nowhere else.";
          content =
            "An operation of the content transport: putBinary, getBinary, \
             getBinaryStream, getResourceGraph, getAnnotations or \
             getAnchoredText.";
          gateway =
            "One of the gateway's own operations: getCurrentUser, \
             getMediaToken, getProtectedResourceMetadata, healthCheck or \
             getStatus.";
          observes =
            "The channel of the client's own bus whose frames an `events` row \
             gives.";
        }
         : via);
     fixtures =
       ({
          context =
            `Assoc
              [
                ( "focus",
                  `Assoc
                    [
                      ("kind", `String "resource");
                      ( "resource",
                        `Assoc
                          [
                            ("@context", `String "https://schema.org");
                            ("@id", `String "res-1");
                            ("name", `String "A resource");
                            ( "representations",
                              `List
                                [
                                  `Assoc [ ("mediaType", `String "text/plain") ];
                                ] );
                          ] );
                    ] );
                ("graph", `Assoc [ ("nodes", `List []); ("edges", `List []) ]);
                ("metadata", `Assoc []);
              ];
          selector =
            `Assoc
              [
                ("type", `String "TextQuoteSelector"); ("exact", `String "hello");
              ];
        }
         : fixtures);
     namespaces =
       [
         ({
            namespace = "frame";
            docs =
              "The knowledge base's vocabulary: what kinds of things exist.";
            methods =
              [
                ({
                   method_ = "addEntityType";
                   shape = (Promise : shape);
                   via =
                     (Request ({ request = "frame:add-entity-type" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "type";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/FrameAddEntityTypeCommand.json#/properties/tag";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("type", `String "Person") ];
                          sends = `Assoc [ ("tag", `String "Person") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "addEntityTypes";
                   shape = (Promise : shape);
                   via =
                     (Request ({ request = "frame:add-entity-type" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "types";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/GetEntityTypesResponse.json#/properties/entityTypes";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why =
                            Some "one request per type, in order, each awaited";
                          args =
                            `Assoc
                              [
                                ( "types",
                                  `List [ `String "Person"; `String "Place" ] );
                              ];
                          sends = `Assoc [ ("tag", `String "Person") ];
                          answers = Some `Null;
                          then_ =
                            Some
                              [
                                (Request
                                   ({
                                      request = "frame:add-entity-type";
                                      sends =
                                        `Assoc [ ("tag", `String "Place") ];
                                    }
                                     : then_item_request)
                                  : then_item);
                              ];
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "addTagSchema";
                   shape = (Promise : shape);
                   via =
                     (Request ({ request = "frame:add-tag-schema" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "schema";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/TagSchema.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ( "schema",
                                  `Assoc
                                    [
                                      ("id", `String "s1");
                                      ("name", `String "Structure");
                                      ( "description",
                                        `String "Parts of an argument" );
                                      ("domain", `String "legal");
                                      ("tags", `List []);
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ( "schema",
                                  `Assoc
                                    [
                                      ("id", `String "s1");
                                      ("name", `String "Structure");
                                      ( "description",
                                        `String "Parts of an argument" );
                                      ("domain", `String "legal");
                                      ("tags", `List []);
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
              ];
          }
           : namespaces_item);
         ({
            namespace = "browse";
            docs =
              "Reads: live queries, one-shot reads, and this viewer's own \
               signals.";
            methods =
              [
                ({
                   method_ = "resource";
                   shape = (Cache : shape);
                   via =
                     (Request
                        ({ request = "browse:resource-requested" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/ResourceDescriptor.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "resources";
                   shape = (Cache : shape);
                   via =
                     (Request
                        ({ request = "browse:resources-requested" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "filters";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/BrowseResourcesRequest.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = false;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/ListResourcesResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = Some "no filters: the page is the Archivist's";
                          args = `Assoc [];
                          sends = `Assoc [];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ( "filters",
                                  `Assoc
                                    [
                                      ("archived", `Bool false);
                                      ("entityType", `String "Person");
                                      ("limit", `Int 5);
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("archived", `Bool false);
                                ("entityType", `String "Person");
                                ("limit", `Int 5);
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why =
                            Some
                              "a page further on: the resources before it are \
                               passed over";
                          args =
                            `Assoc
                              [
                                ( "filters",
                                  `Assoc
                                    [ ("limit", `Int 50); ("offset", `Int 100) ]
                                );
                              ];
                          sends =
                            `Assoc [ ("limit", `Int 50); ("offset", `Int 100) ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "annotations";
                   shape = (Cache : shape);
                   via =
                     (Content ({ content = "getAnnotations" } : content)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/GetAnnotationsResponse.json#/properties/annotations";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "annotation";
                   shape = (Cache : shape);
                   via =
                     (Request
                        ({ request = "browse:annotation-requested" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "annotationId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/AnnotationId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/Annotation.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("annotationId", `String "ann-1");
                              ];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("annotationId", `String "ann-1");
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "entityTypes";
                   shape = (Cache : shape);
                   via =
                     (Request
                        ({ request = "browse:entity-types-requested" }
                          : request)
                       : item_via);
                   parameters = [];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/GetEntityTypesResponse.json#/properties/entityTypes";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [];
                          sends = `Assoc [];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "tagSchemas";
                   shape = (Cache : shape);
                   via =
                     (Request
                        ({ request = "browse:tag-schemas-requested" } : request)
                       : item_via);
                   parameters = [];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/GetTagSchemasResponse.json#/properties/tagSchemas";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [];
                          sends = `Assoc [];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "engines";
                   shape = (Cache : shape);
                   via =
                     (Request
                        ({ request = "browse:engines-requested" } : request)
                       : item_via);
                   parameters = [];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/EnginesWithLimits.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why =
                            Some
                              "the engines are asked for first; each key \
                               holder's limits after it";
                          args = `Assoc [];
                          sends = `Assoc [];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "events";
                   shape = (Cache : shape);
                   via =
                     (Request
                        ({ request = "browse:events-requested" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/GetEventsResponse.json#/properties/events";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "resourceContent";
                   shape = (Promise : shape);
                   via =
                     (Content ({ content = "getBinary" } : content) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Scalar
                          ({
                             type_ = (String : type_);
                             minimum = None;
                             format = None;
                             description =
                               "The resource's text: its bytes decoded as \
                                contract/W3C-SELECTORS.md states, a byte-order \
                                mark first, then the charset the content \
                                transport answered with, then UTF-8. A media \
                                type whose text is not its bytes is refused.";
                           }
                            : scalar)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "resourceGraph";
                   shape = (Promise : shape);
                   via =
                     (Content ({ content = "getResourceGraph" } : content)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/GetResourceResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "resourceAnchoredText";
                   shape = (Promise : shape);
                   via =
                     (Content ({ content = "getAnchoredText" } : content)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/AnchoredTextAnswer.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "resourceRepresentation";
                   shape = (Promise : shape);
                   via =
                     (Content ({ content = "getBinary" } : content) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/ResourceRepresentation.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "resourceRepresentationStream";
                   shape = (Promise : shape);
                   via =
                     (Content ({ content = "getBinaryStream" } : content)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/ResourceRepresentationStream.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "resourceEvents";
                   shape = (Promise : shape);
                   via =
                     (Request
                        ({ request = "browse:events-requested" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/GetEventsResponse.json#/properties/events";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "annotationHistory";
                   shape = (Promise : shape);
                   via =
                     (Request
                        ({ request = "browse:annotation-history-requested" }
                          : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "annotationId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/AnnotationId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/GetAnnotationHistoryResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("annotationId", `String "ann-1");
                              ];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("annotationId", `String "ann-1");
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "files";
                   shape = (Promise : shape);
                   via =
                     (Request
                        ({ request = "browse:directory-requested" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "dirPath";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/BrowseDirectoryRequest.json#/properties/path";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = false;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "sort";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/BrowseDirectoryRequest.json#/properties/sort";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = false;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/BrowseDirectoryResultResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = Some "no arguments: the root, by name";
                          args = `Assoc [];
                          sends =
                            `Assoc
                              [
                                ("path", `String "."); ("sort", `String "name");
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ("dirPath", `String "docs");
                                ("sort", `String "mtime");
                              ];
                          sends =
                            `Assoc
                              [
                                ("path", `String "docs");
                                ("sort", `String "mtime");
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "kb";
                   shape = (Promise : shape);
                   via =
                     (Request ({ request = "browse:kb-requested" } : request)
                       : item_via);
                   parameters = [];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/KbDescription.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [];
                          sends = `Assoc [];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "click";
                   shape = (Signal : shape);
                   via = (Local ({ local = "browse:click" } : local) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "annotationId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/AnnotationId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "anchorRect";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/BrowseClickEvent.json#/properties/anchorRect";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = false;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("annotationId", `String "ann-1") ];
                          sends = `Assoc [ ("annotationId", `String "ann-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why =
                            Some
                              "A viewer that knows where the clicked \
                               annotation is on screen says so: the anchorRect \
                               rides the local frame beside the id.";
                          args =
                            `Assoc
                              [
                                ("annotationId", `String "ann-1");
                                ( "anchorRect",
                                  `Assoc
                                    [
                                      ("x", `Int 10);
                                      ("y", `Int 20);
                                      ("width", `Int 30);
                                      ("height", `Int 40);
                                      ("top", `Int 20);
                                      ("right", `Int 40);
                                      ("bottom", `Int 60);
                                      ("left", `Int 10);
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("annotationId", `String "ann-1");
                                ( "anchorRect",
                                  `Assoc
                                    [
                                      ("x", `Int 10);
                                      ("y", `Int 20);
                                      ("width", `Int 30);
                                      ("height", `Int 40);
                                      ("top", `Int 20);
                                      ("right", `Int 40);
                                      ("bottom", `Int 60);
                                      ("left", `Int 10);
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "openResource";
                   shape = (Signal : shape);
                   via =
                     (Local ({ local = "browse:resource-open" } : local)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "resourceViewed";
                   shape = (Signal : shape);
                   via =
                     (Emit ({ emit = "browse:resource-viewed" } : emit)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = Some "a report, so it goes over the wire";
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
              ];
          }
           : namespaces_item);
         ({
            namespace = "mark";
            docs =
              "Annotations: their creation and removal, a resource's own \
               metadata, and the annotating of a resource delegated as a job.";
            methods =
              [
                ({
                   method_ = "annotation";
                   shape = (Promise : shape);
                   via =
                     (Request ({ request = "mark:create-request" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "input";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/CreateAnnotationRequest.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/MarkCreateOkResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = Some "the resource is the annotation's target";
                          args =
                            `Assoc
                              [
                                ( "input",
                                  `Assoc
                                    [
                                      ("motivation", `String "highlighting");
                                      ( "target",
                                        `Assoc [ ("source", `String "res-1") ]
                                      );
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ( "request",
                                  `Assoc
                                    [
                                      ("motivation", `String "highlighting");
                                      ( "target",
                                        `Assoc [ ("source", `String "res-1") ]
                                      );
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "delete";
                   shape = (Promise : shape);
                   via =
                     (Request ({ request = "mark:delete" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "annotationId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/AnnotationId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("annotationId", `String "ann-1");
                              ];
                          sends =
                            `Assoc
                              [
                                ("annotationId", `String "ann-1");
                                ("resourceId", `String "res-1");
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "archive";
                   shape = (Promise : shape);
                   via =
                     (Request ({ request = "mark:archive" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "unarchive";
                   shape = (Promise : shape);
                   via =
                     (Request ({ request = "mark:unarchive" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "updateEntityTypes";
                   shape = (Promise : shape);
                   via =
                     (Request
                        ({ request = "mark:update-entity-types" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "current";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/MarkUpdateEntityTypesCommand.json#/properties/currentEntityTypes";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "updated";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/MarkUpdateEntityTypesCommand.json#/properties/updatedEntityTypes";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("current", `List [ `String "Person" ]);
                                ( "updated",
                                  `List [ `String "Person"; `String "Place" ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ( "currentEntityTypes",
                                  `List [ `String "Person" ] );
                                ( "updatedEntityTypes",
                                  `List [ `String "Person"; `String "Place" ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "delegate";
                   shape = (Delegation : shape);
                   via =
                     (Request ({ request = "job:create" } : request) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "params";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/MarkJobParams.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/MarkJobCompleteCommand.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why =
                            Some
                              "the namespace is the verb, so the job is a mark \
                               job; its parameters state its motivation";
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ( "params",
                                  `Assoc
                                    [ ("motivation", `String "highlighting") ]
                                );
                              ];
                          sends =
                            `Assoc
                              [
                                ("jobType", `String "mark");
                                ("resourceId", `String "res-1");
                                ( "params",
                                  `Assoc
                                    [ ("motivation", `String "highlighting") ]
                                );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ( "params",
                                  `Assoc
                                    [
                                      ("motivation", `String "linking");
                                      ("entityTypes", `List [ `String "Person" ]);
                                      ( "includeDescriptiveReferences",
                                        `Bool true );
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("jobType", `String "mark");
                                ("resourceId", `String "res-1");
                                ( "params",
                                  `Assoc
                                    [
                                      ("motivation", `String "linking");
                                      ("entityTypes", `List [ `String "Person" ]);
                                      ( "includeDescriptiveReferences",
                                        `Bool true );
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why =
                            Some
                              "a tagging job is given what a tagging job \
                               takes, each parameter under its own name";
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ( "params",
                                  `Assoc
                                    [
                                      ("motivation", `String "tagging");
                                      ("schemaId", `String "s1");
                                      ("categories", `List [ `String "claim" ]);
                                      ("language", `String "en");
                                      ("sourceLanguage", `String "fr");
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("jobType", `String "mark");
                                ("resourceId", `String "res-1");
                                ( "params",
                                  `Assoc
                                    [
                                      ("motivation", `String "tagging");
                                      ("schemaId", `String "s1");
                                      ("categories", `List [ `String "claim" ]);
                                      ("language", `String "en");
                                      ("sourceLanguage", `String "fr");
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why =
                            Some
                              "an assessing job is given what an assessing job \
                               takes";
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ( "params",
                                  `Assoc
                                    [
                                      ("motivation", `String "assessing");
                                      ("instructions", `String "be brief");
                                      ("tone", `String "critical");
                                      ("density", `Float 2.5);
                                      ("language", `String "en");
                                      ("sourceLanguage", `String "fr");
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("jobType", `String "mark");
                                ("resourceId", `String "res-1");
                                ( "params",
                                  `Assoc
                                    [
                                      ("motivation", `String "assessing");
                                      ("instructions", `String "be brief");
                                      ("tone", `String "critical");
                                      ("density", `Float 2.5);
                                      ("language", `String "en");
                                      ("sourceLanguage", `String "fr");
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ( "params",
                                  `Assoc
                                    [
                                      ("motivation", `String "commenting");
                                      ("tone", `String "scholarly");
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("jobType", `String "mark");
                                ("resourceId", `String "res-1");
                                ( "params",
                                  `Assoc
                                    [
                                      ("motivation", `String "commenting");
                                      ("tone", `String "scholarly");
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "request";
                   shape = (Signal : shape);
                   via =
                     (Local ({ local = "mark:requested" } : local) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "source";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/MarkRequestedEvent.json#/properties/source";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "selector";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/MarkRequestedEvent.json#/properties/selector";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "motivation";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/MarkRequestedEvent.json#/properties/motivation";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ("source", `String "res-1");
                                ( "selector",
                                  `Assoc [ ("$fixture", `String "selector") ] );
                                ("motivation", `String "highlighting");
                              ];
                          sends =
                            `Assoc
                              [
                                ("source", `String "res-1");
                                ( "selector",
                                  `Assoc [ ("$fixture", `String "selector") ] );
                                ("motivation", `String "highlighting");
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "submit";
                   shape = (Signal : shape);
                   via = (Local ({ local = "mark:submit" } : local) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "input";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/MarkSubmitEvent.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ( "input",
                                  `Assoc
                                    [
                                      ("source", `String "res-1");
                                      ("motivation", `String "highlighting");
                                      ( "selector",
                                        `Assoc
                                          [ ("$fixture", `String "selector") ]
                                      );
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("source", `String "res-1");
                                ("motivation", `String "highlighting");
                                ( "selector",
                                  `Assoc [ ("$fixture", `String "selector") ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "reportDeleteError";
                   shape = (Signal : shape);
                   via =
                     (Local ({ local = "mark:delete-error" } : local)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "input";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceErrorEvent.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ( "input",
                                  `Assoc
                                    [
                                      ("resourceId", `String "res-1");
                                      ( "message",
                                        `String "the delete was refused" );
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("message", `String "the delete was refused");
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
              ];
          }
           : namespaces_item);
         ({
            namespace = "bind";
            docs = "Linking a reference to what it refers to.";
            methods =
              [
                ({
                   method_ = "body";
                   shape = (Promise : shape);
                   via =
                     (Request ({ request = "bind:update-body" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "annotationId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/AnnotationId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "operations";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/BindUpdateBodyCommand.json#/properties/operations";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("annotationId", `String "ann-1");
                                ( "operations",
                                  `List [ `Assoc [ ("op", `String "remove") ] ]
                                );
                              ];
                          sends =
                            `Assoc
                              [
                                ("annotationId", `String "ann-1");
                                ("resourceId", `String "res-1");
                                ( "operations",
                                  `List [ `Assoc [ ("op", `String "remove") ] ]
                                );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "initiate";
                   shape = (Signal : shape);
                   via =
                     (Local ({ local = "bind:initiate" } : local) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "input";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/BindInitiateCommand.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ( "input",
                                  `Assoc
                                    [
                                      ("annotationId", `String "ann-1");
                                      ("resourceId", `String "res-1");
                                      ("defaultTitle", `String "A title");
                                      ("entityTypes", `List [ `String "Person" ]);
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("annotationId", `String "ann-1");
                                ("resourceId", `String "res-1");
                                ("defaultTitle", `String "A title");
                                ("entityTypes", `List [ `String "Person" ]);
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "reportBodyError";
                   shape = (Signal : shape);
                   via =
                     (Local ({ local = "bind:body-error" } : local) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "input";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceErrorEvent.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ( "input",
                                  `Assoc
                                    [
                                      ("resourceId", `String "res-1");
                                      ("message", `String "the link was refused");
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("message", `String "the link was refused");
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
              ];
          }
           : namespaces_item);
         ({
            namespace = "gather";
            docs =
              "Assembling the context a model is given, and what refers to a \
               resource.";
            methods =
              [
                ({
                   method_ = "annotation";
                   shape = (Stream : shape);
                   via =
                     (Request ({ request = "gather:requested" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "annotationId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/AnnotationId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "options";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/GatherAnnotationOptions.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = false;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/GatherAnnotationComplete.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why =
                            Some
                              "no options: the window and the contexts are the \
                               Librarian's";
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("annotationId", `String "ann-1");
                              ];
                          sends =
                            `Assoc
                              [
                                ("annotationId", `String "ann-1");
                                ("resourceId", `String "res-1");
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("annotationId", `String "ann-1");
                                ( "options",
                                  `Assoc [ ("contextWindow", `Int 500) ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("annotationId", `String "ann-1");
                                ("resourceId", `String "res-1");
                                ( "options",
                                  `Assoc [ ("contextWindow", `Int 500) ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why =
                            Some
                              "a context asked for or left out is sent as \
                               stated, false as well as true; the window not \
                               stated is not sent";
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("annotationId", `String "ann-1");
                                ( "options",
                                  `Assoc
                                    [
                                      ("includeSourceContext", `Bool false);
                                      ("includeTargetContext", `Bool true);
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("annotationId", `String "ann-1");
                                ("resourceId", `String "res-1");
                                ( "options",
                                  `Assoc
                                    [
                                      ("includeSourceContext", `Bool false);
                                      ("includeTargetContext", `Bool true);
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "resource";
                   shape = (Promise : shape);
                   via =
                     (Request
                        ({ request = "gather:resource-requested" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "options";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/GatherResourceOptions.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = false;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/GatheredContext.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why =
                            Some
                              "no options: two hops, ten resources, their \
                               content and no summary";
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ( "options",
                                  `Assoc
                                    [
                                      ("depth", `Int 2);
                                      ("maxResources", `Int 10);
                                      ("includeContent", `Bool true);
                                      ("includeSummary", `Bool false);
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ( "options",
                                  `Assoc
                                    [
                                      ("depth", `Int 1);
                                      ("maxResources", `Int 3);
                                      ("includeContent", `Bool false);
                                      ("includeSummary", `Bool true);
                                      ( "excludeEntityTypes",
                                        `List [ `String "Question" ] );
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ( "options",
                                  `Assoc
                                    [
                                      ("depth", `Int 1);
                                      ("maxResources", `Int 3);
                                      ("includeContent", `Bool false);
                                      ("includeSummary", `Bool true);
                                      ( "excludeEntityTypes",
                                        `List [ `String "Question" ] );
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why =
                            Some
                              "an empty exclusion is no exclusion, and is not \
                               sent";
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ( "options",
                                  `Assoc [ ("excludeEntityTypes", `List []) ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ( "options",
                                  `Assoc
                                    [
                                      ("depth", `Int 2);
                                      ("maxResources", `Int 10);
                                      ("includeContent", `Bool true);
                                      ("includeSummary", `Bool false);
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "referencedBy";
                   shape = (Cache : shape);
                   via =
                     (Request
                        ({ request = "gather:referenced-by-requested" }
                          : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/GetReferencedByResponse.json#/properties/referencedBy";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
              ];
          }
           : namespaces_item);
         ({
            namespace = "match";
            docs =
              "Searching: for what a reference could refer to, and for \
               resources by text.";
            methods =
              [
                ({
                   method_ = "search";
                   shape = (Stream : shape);
                   via =
                     (Request ({ request = "match:search-requested" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "referenceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/MatchSearchRequest.json#/properties/referenceId";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "context";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/MatchSearchRequest.json#/properties/context";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "options";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/MatchSearchOptions.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = false;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/MatchSearchResult.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why =
                            Some
                              "no options: ten candidates, scored as the \
                               Librarian scores unasked";
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("referenceId", `String "ann-1");
                                ( "context",
                                  `Assoc [ ("$fixture", `String "context") ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("referenceId", `String "ann-1");
                                ( "context",
                                  `Assoc [ ("$fixture", `String "context") ] );
                                ("limit", `Int 10);
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("referenceId", `String "ann-1");
                                ( "context",
                                  `Assoc [ ("$fixture", `String "context") ] );
                                ( "options",
                                  `Assoc
                                    [
                                      ("limit", `Int 3);
                                      ("useSemanticScoring", `Bool false);
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("referenceId", `String "ann-1");
                                ( "context",
                                  `Assoc [ ("$fixture", `String "context") ] );
                                ("limit", `Int 3);
                                ("useSemanticScoring", `Bool false);
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "requestSearch";
                   shape = (Signal : shape);
                   via =
                     (Local ({ local = "match:search-requested" } : local)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "input";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/MatchSearchRequest.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "correlationId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/BusFrame.json#/properties/correlationId";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why =
                            Some
                              "the caller's key rides the envelope, never the \
                               payload";
                          args =
                            `Assoc
                              [
                                ( "input",
                                  `Assoc
                                    [
                                      ("resourceId", `String "res-1");
                                      ("referenceId", `String "ann-1");
                                      ( "context",
                                        `Assoc
                                          [ ("$fixture", `String "context") ] );
                                    ] );
                                ("correlationId", `String "cid-1");
                              ];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("referenceId", `String "ann-1");
                                ( "context",
                                  `Assoc [ ("$fixture", `String "context") ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = Some "cid-1";
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "resources";
                   shape = (Cache : shape);
                   via =
                     (Request
                        ({ request = "match:resources-requested" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "search";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/MatchResourcesRequest.json#/properties/search";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "filters";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceSearchFilters.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = false;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/MatchResourcesResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = Some "no filters: the page is the Librarian's";
                          args = `Assoc [ ("search", `String "cat") ];
                          sends = `Assoc [ ("search", `String "cat") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ("search", `String "cat");
                                ( "filters",
                                  `Assoc
                                    [
                                      ("archived", `Bool false);
                                      ("entityType", `String "Person");
                                      ("limit", `Int 5);
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("search", `String "cat");
                                ("archived", `Bool false);
                                ("entityType", `String "Person");
                                ("limit", `Int 5);
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why =
                            Some
                              "a page further on: the resources before it are \
                               passed over";
                          args =
                            `Assoc
                              [
                                ("search", `String "cat");
                                ( "filters",
                                  `Assoc
                                    [ ("limit", `Int 50); ("offset", `Int 100) ]
                                );
                              ];
                          sends =
                            `Assoc
                              [
                                ("search", `String "cat");
                                ("limit", `Int 50);
                                ("offset", `Int 100);
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
              ];
          }
           : namespaces_item);
         ({
            namespace = "yield";
            docs =
              "Creating resources: by upload, by a generation delegated as a \
               job, by cloning.";
            methods =
              [
                ({
                   method_ = "resource";
                   shape = (Upload : shape);
                   via =
                     (Content ({ content = "putBinary" } : content) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "data";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/PutBinaryRequest.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/CreateResourceResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ( "data",
                                  `Assoc
                                    [
                                      ("name", `String "Notes");
                                      ("file", `String "hello");
                                      ("format", `String "text/plain");
                                      ("storageUri", `String "file://notes.txt");
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("name", `String "Notes");
                                ("content", `String "hello");
                                ("format", `String "text/plain");
                                ("storageUri", `String "file://notes.txt");
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "delegate";
                   shape = (Delegation : shape);
                   via =
                     (Request ({ request = "job:create" } : request) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "params";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/GenerationJobParams.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "stallDeadlineMs";
                             schema =
                               Some
                                 (Scalar
                                    ({
                                       type_ = (Integer : type_);
                                       minimum = Some 0;
                                       format = None;
                                       description =
                                         "How long the followed generation may \
                                          say nothing, in milliseconds, before \
                                          it is given up on. The follower's \
                                          own, never sent: left out, it grows \
                                          with the generation's `maxTokens` as \
                                          client/timing.json's generationStall \
                                          timings say.";
                                     }
                                      : scalar)
                                   : schema);
                             required = false;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/YieldJobCompleteCommand.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why =
                            Some
                              "the namespace is the verb, so the job is a \
                               yield job; it names no resource: its context's \
                               focus does";
                          args =
                            `Assoc
                              [
                                ( "params",
                                  `Assoc
                                    [
                                      ("title", `String "A summary");
                                      ( "storageUri",
                                        `String "file://a-summary.md" );
                                      ( "context",
                                        `Assoc
                                          [ ("$fixture", `String "context") ] );
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ("jobType", `String "yield");
                                ( "params",
                                  `Assoc
                                    [
                                      ("title", `String "A summary");
                                      ( "storageUri",
                                        `String "file://a-summary.md" );
                                      ( "context",
                                        `Assoc
                                          [ ("$fixture", `String "context") ] );
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why =
                            Some
                              "how long the follower waits is the client's \
                               own: it is given beside the job's parameters, \
                               and is not sent";
                          args =
                            `Assoc
                              [
                                ( "params",
                                  `Assoc
                                    [
                                      ("title", `String "A summary");
                                      ( "storageUri",
                                        `String "file://a-summary.md" );
                                      ("prompt", `String "in one line");
                                      ("maxTokens", `Int 200);
                                      ( "context",
                                        `Assoc
                                          [ ("$fixture", `String "context") ] );
                                    ] );
                                ("stallDeadlineMs", `Int 5000);
                              ];
                          sends =
                            `Assoc
                              [
                                ("jobType", `String "yield");
                                ( "params",
                                  `Assoc
                                    [
                                      ("title", `String "A summary");
                                      ( "storageUri",
                                        `String "file://a-summary.md" );
                                      ("prompt", `String "in one line");
                                      ("maxTokens", `Int 200);
                                      ( "context",
                                        `Assoc
                                          [ ("$fixture", `String "context") ] );
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "cloneToken";
                   shape = (Promise : shape);
                   via =
                     (Request
                        ({ request = "yield:clone-token-requested" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/CloneResourceWithTokenResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "fromToken";
                   shape = (Promise : shape);
                   via =
                     (Request
                        ({ request = "yield:clone-resource-requested" }
                          : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "token";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/YieldCloneResourceRequest.json#/properties/token";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/ResourceDescriptor.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("token", `String "tok-1") ];
                          sends = `Assoc [ ("token", `String "tok-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "createFromToken";
                   shape = (Promise : shape);
                   via =
                     (Request
                        ({ request = "yield:clone-resource-requested" }
                          : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "options";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/CreateFromTokenOptions.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/CreateResourceResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why =
                            Some
                              "the source is read first; the clone is uploaded \
                               in a format its source's allows, under a name \
                               made from its own";
                          args =
                            `Assoc
                              [
                                ( "options",
                                  `Assoc
                                    [
                                      ("token", `String "tok-1");
                                      ("name", `String "A Copy");
                                      ("content", `String "hello");
                                    ] );
                              ];
                          sends = `Assoc [ ("token", `String "tok-1") ];
                          answers =
                            Some
                              (`Assoc
                                 [
                                   ( "sourceResource",
                                     `Assoc
                                       [
                                         ( "@context",
                                           `String "https://schema.org" );
                                         ("@id", `String "res-1");
                                         ("name", `String "A resource");
                                         ( "representations",
                                           `List
                                             [
                                               `Assoc
                                                 [
                                                   ( "mediaType",
                                                     `String "text/markdown" );
                                                 ];
                                             ] );
                                       ] );
                                   ( "expiresAt",
                                     `String "2030-01-01T00:00:00.000Z" );
                                 ]);
                          then_ =
                            Some
                              [
                                (Content
                                   ({
                                      content = "putBinary";
                                      sends =
                                        `Assoc
                                          [
                                            ("name", `String "A Copy");
                                            ("content", `String "hello");
                                            ("format", `String "text/markdown");
                                            ( "storageUri",
                                              `String "file://a-copy.md" );
                                            ("cloneToken", `String "tok-1");
                                          ];
                                    }
                                     : then_item_content)
                                  : then_item);
                              ];
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why =
                            Some
                              "a source in a format nobody authors is cloned \
                               as plain text";
                          args =
                            `Assoc
                              [
                                ( "options",
                                  `Assoc
                                    [
                                      ("token", `String "tok-1");
                                      ("name", `String "A Copy");
                                      ("content", `String "hello");
                                    ] );
                              ];
                          sends = `Assoc [ ("token", `String "tok-1") ];
                          answers =
                            Some
                              (`Assoc
                                 [
                                   ( "sourceResource",
                                     `Assoc
                                       [
                                         ( "@context",
                                           `String "https://schema.org" );
                                         ("@id", `String "res-1");
                                         ("name", `String "A resource");
                                         ( "representations",
                                           `List
                                             [
                                               `Assoc
                                                 [
                                                   ( "mediaType",
                                                     `String "application/pdf"
                                                   );
                                                 ];
                                             ] );
                                       ] );
                                   ( "expiresAt",
                                     `String "2030-01-01T00:00:00.000Z" );
                                 ]);
                          then_ =
                            Some
                              [
                                (Content
                                   ({
                                      content = "putBinary";
                                      sends =
                                        `Assoc
                                          [
                                            ("name", `String "A Copy");
                                            ("content", `String "hello");
                                            ("format", `String "text/plain");
                                            ( "storageUri",
                                              `String "file://a-copy.txt" );
                                            ("cloneToken", `String "tok-1");
                                          ];
                                    }
                                     : then_item_content)
                                  : then_item);
                              ];
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "clone";
                   shape = (Signal : shape);
                   via = (Local ({ local = "yield:clone" } : local) : item_via);
                   parameters = [];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [];
                          sends = `Assoc [];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
              ];
          }
           : namespaces_item);
         ({
            namespace = "beckon";
            docs =
              "Attention: driving the other participants' viewers, and this \
               viewer's own signals.";
            methods =
              [
                ({
                   method_ = "attention";
                   shape = (Count : shape);
                   via = (Emit ({ emit = "beckon:focus" } : emit) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "annotationId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/BeckonFocusEvent.json#/properties/annotationId";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = false;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("annotationId", `String "ann-1");
                              ];
                          sends =
                            `Assoc
                              [
                                ("annotationId", `String "ann-1");
                                ("resourceId", `String "res-1");
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why =
                            Some
                              "no annotation: the focus is on the resource as \
                               a whole, and names none";
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "click";
                   shape = (Count : shape);
                   via = (Emit ({ emit = "browse:click" } : emit) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "annotationId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/AnnotationId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("annotationId", `String "ann-1") ];
                          sends = `Assoc [ ("annotationId", `String "ann-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "openResource";
                   shape = (Count : shape);
                   via =
                     (Emit ({ emit = "browse:resource-open" } : emit)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "sparkleAll";
                   shape = (Count : shape);
                   via = (Emit ({ emit = "beckon:sparkle" } : emit) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "annotationId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/AnnotationId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("annotationId", `String "ann-1") ];
                          sends = `Assoc [ ("annotationId", `String "ann-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "hover";
                   shape = (Signal : shape);
                   via = (Local ({ local = "beckon:hover" } : local) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "annotationId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/BeckonHoverEvent.json#/properties/annotationId";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("annotationId", `String "ann-1") ];
                          sends = `Assoc [ ("annotationId", `String "ann-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why = Some "nothing is hovered: the field says so";
                          args = `Assoc [ ("annotationId", `Null) ];
                          sends = `Assoc [ ("annotationId", `Null) ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "sparkle";
                   shape = (Signal : shape);
                   via =
                     (Local ({ local = "beckon:sparkle" } : local) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "annotationId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/AnnotationId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns = None;
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("annotationId", `String "ann-1") ];
                          sends = `Assoc [ ("annotationId", `String "ann-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
              ];
          }
           : namespaces_item);
         ({
            namespace = "job";
            docs =
              "Jobs: their lifecycle as it is announced, their status, their \
               cancellation, and, for a worker, the claiming of them.";
            methods =
              [
                ({
                   method_ = "queued";
                   shape = (Events : shape);
                   via =
                     (Observes ({ observes = "job:queued" } : observes)
                       : item_via);
                   parameters = [];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/JobQueuedEvent.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why =
                            Some
                              "a yield job is announced with what it is asked \
                               to make, and without its context";
                          args = `Assoc [];
                          sends =
                            `Assoc
                              [
                                ("jobId", `String "job-1");
                                ("jobType", `String "yield");
                                ("resourceId", `String "res-1");
                                ( "userId",
                                  `String "did:web:example.org:users:alice" );
                                ( "params",
                                  `Assoc
                                    [
                                      ("title", `String "A summary");
                                      ( "storageUri",
                                        `String "file://a-summary.md" );
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                       ({
                          why =
                            Some
                              "a mark job is announced with its parameters, \
                               its motivation among them";
                          args = `Assoc [];
                          sends =
                            `Assoc
                              [
                                ("jobId", `String "job-2");
                                ("jobType", `String "mark");
                                ("resourceId", `String "res-1");
                                ( "userId",
                                  `String "did:web:example.org:users:alice" );
                                ( "params",
                                  `Assoc
                                    [
                                      ("motivation", `String "tagging");
                                      ("schemaId", `String "s1");
                                      ("categories", `List [ `String "claim" ]);
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "progress";
                   shape = (Events : shape);
                   via =
                     (Observes ({ observes = "job:report-progress" } : observes)
                       : item_via);
                   parameters = [];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/JobReportProgressCommand.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("jobId", `String "job-1");
                                ("jobType", `String "yield");
                                ("percentage", `Float 12.5);
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "complete";
                   shape = (Events : shape);
                   via =
                     (Observes ({ observes = "job:complete" } : observes)
                       : item_via);
                   parameters = [];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/JobCompleteCommand.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("jobId", `String "job-1");
                                ("jobType", `String "yield");
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "fail";
                   shape = (Events : shape);
                   via =
                     (Observes ({ observes = "job:fail" } : observes)
                       : item_via);
                   parameters = [];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/JobFailCommand.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [];
                          sends =
                            `Assoc
                              [
                                ("resourceId", `String "res-1");
                                ("jobId", `String "job-1");
                                ("jobType", `String "yield");
                                ("error", `String "the model refused");
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "status";
                   shape = (Promise : shape);
                   via =
                     (Request ({ request = "job:status-requested" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "jobId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/JobId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/JobStatusResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("jobId", `String "job-1") ];
                          sends = `Assoc [ ("jobId", `String "job-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "pollUntilComplete";
                   shape = (Promise : shape);
                   via =
                     (Request ({ request = "job:status-requested" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "jobId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/JobId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Value
                          ({
                             parameter = "options";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/JobPollOptions.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = false;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                       (Callback
                          ({
                             parameter = "onStatus";
                             calls =
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/JobStatusResponse.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                             required = false;
                             returns = None;
                           }
                            : callback)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/JobStatusResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("jobId", `String "job-1") ];
                          sends = `Assoc [ ("jobId", `String "job-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "cancel";
                   shape = (Promise : shape);
                   via =
                     (Request ({ request = "job:cancel-requested" } : request)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "jobId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/JobId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/JobCancelResult.json#/properties/cancelled";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("jobId", `String "job-1") ];
                          sends = `Assoc [ ("jobId", `String "job-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "claim";
                   shape = (Claims : shape);
                   via =
                     (Request ({ request = "job:claim" } : request) : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "options";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ClaimOptions.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/JobRunning.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why =
                            Some
                              "a claim carries the filters of the jobs the \
                               worker takes, as it was given them";
                          args =
                            `Assoc
                              [
                                ( "options",
                                  `Assoc
                                    [
                                      ( "accepts",
                                        `List
                                          [
                                            `Assoc
                                              [
                                                ("jobType", `String "mark");
                                                ( "params",
                                                  `Assoc
                                                    [
                                                      ( "motivation",
                                                        `String "tagging" );
                                                    ] );
                                              ];
                                            `Assoc
                                              [ ("jobType", `String "yield") ];
                                          ] );
                                    ] );
                              ];
                          sends =
                            `Assoc
                              [
                                ( "accepts",
                                  `List
                                    [
                                      `Assoc
                                        [
                                          ("jobType", `String "mark");
                                          ( "params",
                                            `Assoc
                                              [
                                                ("motivation", `String "tagging");
                                              ] );
                                        ];
                                      `Assoc [ ("jobType", `String "yield") ];
                                    ] );
                              ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
              ];
          }
           : namespaces_item);
         ({
            namespace = "auth";
            docs =
              "The gateway's view of who is signed in. Present when the client \
               was given a gateway.";
            methods =
              [
                ({
                   method_ = "me";
                   shape = (Promise : shape);
                   via =
                     (Gateway ({ gateway = "getCurrentUser" } : gateway)
                       : item_via);
                   parameters = [];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/UserResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [];
                          sends = `Assoc [];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "mediaToken";
                   shape = (Promise : shape);
                   via =
                     (Gateway ({ gateway = "getMediaToken" } : gateway)
                       : item_via);
                   parameters =
                     [
                       (Value
                          ({
                             parameter = "resourceId";
                             schema =
                               Some
                                 (Reference
                                    ({
                                       ref =
                                         "https://xynolog.org/protocol/ResourceId.json";
                                       type_arguments = None;
                                     }
                                      : reference)
                                   : schema);
                             required = true;
                             absent = None;
                           }
                            : value)
                         : parameters_item);
                     ];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/MediaTokenResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [ ("resourceId", `String "res-1") ];
                          sends = `Assoc [ ("resourceId", `String "res-1") ];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "protectedResourceMetadata";
                   shape = (Promise : shape);
                   via =
                     (Gateway
                        ({ gateway = "getProtectedResourceMetadata" } : gateway)
                       : item_via);
                   parameters = [];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/ProtectedResourceMetadata.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [];
                          sends = `Assoc [];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
              ];
          }
           : namespaces_item);
         ({
            namespace = "system";
            docs =
              "What the knowledge base says about itself. Present when the \
               client was given a gateway.";
            methods =
              [
                ({
                   method_ = "healthCheck";
                   shape = (Promise : shape);
                   via =
                     (Gateway ({ gateway = "healthCheck" } : gateway)
                       : item_via);
                   parameters = [];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/HealthResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [];
                          sends = `Assoc [];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
                ({
                   method_ = "status";
                   shape = (Promise : shape);
                   via =
                     (Gateway ({ gateway = "getStatus" } : gateway) : item_via);
                   parameters = [];
                   returns =
                     Some
                       (Reference
                          ({
                             ref =
                               "https://xynolog.org/protocol/StatusResponse.json";
                             type_arguments = None;
                           }
                            : reference)
                         : schema);
                   cases =
                     [
                       ({
                          why = None;
                          args = `Assoc [];
                          sends = `Assoc [];
                          answers = None;
                          then_ = None;
                          correlation_id = None;
                        }
                         : cases_item);
                     ];
                 }
                  : methods_item);
              ];
          }
           : namespaces_item);
       ];
     worker =
       [
         ({
            handed = "claims";
            docs =
              "What `job.claim` returns: each job the worker comes to hold, \
               one at a time, and what the worker can say of itself meanwhile. \
               How the jobs are read is the language's: subscribed to in \
               TypeScript, iterated in Python, asked for one at a time in Rust \
               and Kotlin (`next`), ranged over in Go.";
            record = None;
            members =
              [
                ({
                   member = "next";
                   named =
                     Some
                       [
                         ( "go",
                           ({
                              name = "All";
                              why =
                                "The claims are ranged over, `for job, err := \
                                 range claims.All()`, and Go's standard \
                                 library names the method that gives a \
                                 sequence of every element `All` (`maps.All`, \
                                 `slices.All`).";
                            }
                             : named_value) );
                       ];
                   takes = None;
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters = [];
                                  returns =
                                    Some
                                      (Handed ({ handed = "heldJob" } : handed)
                                        : returns);
                                  absent = Some true;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "refused";
                   named = None;
                   takes = None;
                   gives =
                     (Stream
                        ({
                           form = "stream";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/ClaimRefusal.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                         }
                          : stream)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "stalled";
                   named = None;
                   takes = None;
                   gives =
                     (Stream
                        ({
                           form = "stream";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/HeldJobStall.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                         }
                          : stream)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "vitals";
                   named = None;
                   takes = None;
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/WorkerVitals.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = None;
                         }
                          : gives_value)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "stop";
                   named =
                     Some
                       [
                         ( "python",
                           ({
                              name = "aclose";
                              why =
                                "Python closes an asynchronous iterator with \
                                 `aclose`: it is what an asynchronous \
                                 generator has, and what `contextlib.aclosing` \
                                 calls.";
                            }
                             : named_value) );
                         ( "go",
                           ({
                              name = "Close";
                              why =
                                "Go stops what is held with `Close`, the name \
                                 `io.Closer` gives it and what a `defer` \
                                 calls.";
                            }
                             : named_value) );
                       ];
                   takes = None;
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters = [];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : members_item);
              ];
          }
           : worker_item);
         ({
            handed = "heldJob";
            docs =
              "A job a worker holds, from its claim until it settles it. A \
               held job is its verb's, `mark` or `yield`. A member with \
               `takes` is one a held job has as its verb's, and it takes what \
               that verb's entry names; every other member is the same for \
               both verbs, and a job held as either verb's has it without its \
               verb being asked.";
            record = Some "HeldJobRecord";
            members =
              [
                ({
                   member = "jobId";
                   named = None;
                   takes = None;
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/HeldJobRecord.json#/properties/jobId";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = None;
                         }
                          : gives_value)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "jobType";
                   named = None;
                   takes = None;
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/HeldJobRecord.json#/properties/jobType";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = None;
                         }
                          : gives_value)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "resourceId";
                   named = None;
                   takes = None;
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/HeldJobRecord.json#/properties/resourceId";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = None;
                         }
                          : gives_value)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "params";
                   named = None;
                   takes = None;
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/HeldJobRecord.json#/properties/params";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = None;
                         }
                          : gives_value)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "completedUnits";
                   named = None;
                   takes = None;
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/HeldJobRecord.json#/properties/completedUnits";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = None;
                         }
                          : gives_value)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "unitCursors";
                   named = None;
                   takes = None;
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/HeldJobRecord.json#/properties/unitCursors";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = None;
                         }
                          : gives_value)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "retryCount";
                   named = None;
                   takes = None;
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/HeldJobRecord.json#/properties/retryCount";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = None;
                         }
                          : gives_value)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "maxRetries";
                   named = None;
                   takes = None;
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/HeldJobRecord.json#/properties/maxRetries";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = None;
                         }
                          : gives_value)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "attempt";
                   named = None;
                   takes = None;
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/JobStartCommand.json#/properties/attempt";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = None;
                         }
                          : gives_value)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "annotationId";
                   named = None;
                   takes = None;
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/AnnotationId.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : gives_value)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "trace";
                   named = None;
                   takes = None;
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/TraceCarrier.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : gives_value)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "cancelled";
                   named = None;
                   takes = None;
                   gives = (Cancels ({ form = "cancels" } : cancels) : gives);
                 }
                  : members_item);
                ({
                   member = "settled";
                   named = None;
                   takes = None;
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Scalar
                                  ({
                                     type_ = (Boolean : type_);
                                     minimum = None;
                                     format = None;
                                     description =
                                       "Whether the job has settled: \
                                        completed, failed or cancelled.";
                                   }
                                    : scalar)
                                 : schema);
                           absent = None;
                         }
                          : gives_value)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "start";
                   named = None;
                   takes = None;
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters = [];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "progress";
                   named = None;
                   takes = None;
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "progress";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/JobProgress.json";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "checkpoint";
                   named = None;
                   takes = None;
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "checkpoint";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/JobCheckpoint.json";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "commit";
                   named = None;
                   takes = None;
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "resourceId";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/MarkCommitCommand.json#/properties/resourceId";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                      (Value
                                         ({
                                            parameter = "annotations";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/MarkCommitCommand.json#/properties/annotations";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "complete";
                   named = None;
                   takes =
                     Some
                       [
                         ("mark", "MarkJobResult"); ("yield", "YieldJobResult");
                       ];
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "result";
                                            schema =
                                              Some
                                                (Decided
                                                   ({
                                                      decided =
                                                        ({
                                                           by =
                                                             ({
                                                                member =
                                                                  "jobType";
                                                              }
                                                               : by);
                                                           in_ = "takes";
                                                         }
                                                          : decided_decided);
                                                    }
                                                     : decided)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "fail";
                   named = None;
                   takes = None;
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "error";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/JobFailCommand.json#/properties/error";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                      (Value
                                         ({
                                            parameter = "failure";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/JobFailure.json";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = false;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : members_item);
                ({
                   member = "cancel";
                   named = None;
                   takes = None;
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "reached";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/JobReached.json";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = false;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : members_item);
              ];
          }
           : worker_item);
       ];
     state_units =
       [
         ({
            unit = "mark";
            docs =
              "The composing and delegating of annotations on one resource: \
               the annotation being composed, the delegated job's motivation, \
               its progress and what that progress is of, why the last job \
               ended without completing, and the job's id. A request and a \
               submission reach it as the signals the mark namespace \
               publishes, which name its resource; a delegation, the \
               cancelling of the annotation being composed and the dismissing \
               of a job's progress are asked of the unit itself, so none \
               reaches a unit of another resource.";
            made =
              [
                ("ocaml", "Mark");
                ("csharp", "MarkStateUnit");
                ("typescript", "MarkStateUnit");
                ("rust", "MarkStateUnit");
                ("python", "MarkStateUnit");
                ("go", "MarkStateUnit");
                ("kotlin", "MarkStateUnit");
                ("swift", "MarkStateUnit");
                ("haskell", "MarkStateUnit");
              ];
            made_by =
              [
                ("typescript", "createMarkStateUnit");
                ("go", "NewMarkStateUnit");
                ("haskell", "newMarkStateUnit");
              ];
            type_parameters = None;
            members =
              [
                ({
                   member = "pendingAnnotation";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/PendingAnnotation.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "delegatingMotivation";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/Motivation.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "progress";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/JobProgress.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "progressMotivation";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/Motivation.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "failure";
                   gives =
                     (Watched
                        ({ form = "watched"; schema = None; absent = Some true }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "jobId";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/JobId.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "requestDelegate";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "params";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/MarkJobParams.json";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "cancelPending";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters = [];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "dismissProgress";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters = [];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
              ];
          }
           : state_units_item);
         ({
            unit = "yield";
            docs =
              "A generation: whether a run is under way, its progress, what \
               the finished run produced, why the last run ended without a \
               result, and the job's id. It is moved by its own methods.";
            made =
              [
                ("ocaml", "Yield");
                ("csharp", "YieldStateUnit");
                ("typescript", "YieldStateUnit");
                ("rust", "YieldStateUnit");
                ("python", "YieldStateUnit");
                ("go", "YieldStateUnit");
                ("kotlin", "YieldStateUnit");
                ("swift", "YieldStateUnit");
                ("haskell", "YieldStateUnit");
              ];
            made_by =
              [
                ("typescript", "createYieldStateUnit");
                ("go", "NewYieldStateUnit");
                ("haskell", "newYieldStateUnit");
              ];
            type_parameters = None;
            members =
              [
                ({
                   member = "isGenerating";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Scalar
                                  ({
                                     type_ = (Boolean : type_);
                                     minimum = None;
                                     format = None;
                                     description =
                                       "Whether a generation is on its way.";
                                   }
                                    : scalar)
                                 : schema);
                           absent = None;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "progress";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/JobProgress.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "outcome";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/YieldJobDone.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "failure";
                   gives =
                     (Watched
                        ({ form = "watched"; schema = None; absent = Some true }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "jobId";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/JobId.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "generate";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "params";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/GenerationJobParams.json";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                      (Value
                                         ({
                                            parameter = "stallDeadlineMs";
                                            schema =
                                              Some
                                                (Scalar
                                                   ({
                                                      type_ = (Integer : type_);
                                                      minimum = Some 0;
                                                      format = None;
                                                      description =
                                                        "How long the followed \
                                                         generation may say \
                                                         nothing, in \
                                                         milliseconds, before \
                                                         it is given up on. \
                                                         The follower's own, \
                                                         never sent: left out, \
                                                         it grows with the \
                                                         generation's \
                                                         `maxTokens` as \
                                                         client/timing.json's \
                                                         generationStall \
                                                         timings say.";
                                                    }
                                                     : scalar)
                                                  : schema);
                                            required = false;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "dismissProgress";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters = [];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
              ];
          }
           : state_units_item);
         ({
            unit = "gather";
            docs =
              "The context gathered around one resource: for the annotation \
               last asked about and for the resource last asked about, the \
               context, whether it is loading and why it failed. Each gather \
               is asked of the unit itself, so none reaches a unit of another \
               resource.";
            made =
              [
                ("ocaml", "Gather");
                ("csharp", "GatherStateUnit");
                ("typescript", "GatherStateUnit");
                ("rust", "GatherStateUnit");
                ("python", "GatherStateUnit");
                ("go", "GatherStateUnit");
                ("kotlin", "GatherStateUnit");
                ("swift", "GatherStateUnit");
                ("haskell", "GatherStateUnit");
              ];
            made_by =
              [
                ("typescript", "createGatherStateUnit");
                ("go", "NewGatherStateUnit");
                ("haskell", "newGatherStateUnit");
              ];
            type_parameters = None;
            members =
              [
                ({
                   member = "context";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/GatheredContext.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "loading";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Scalar
                                  ({
                                     type_ = (Boolean : type_);
                                     minimum = None;
                                     format = None;
                                     description =
                                       "Whether an annotation's gather is on \
                                        its way.";
                                   }
                                    : scalar)
                                 : schema);
                           absent = None;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "error";
                   gives =
                     (Watched
                        ({ form = "watched"; schema = None; absent = Some true }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "annotationId";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/AnnotationId.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "resourceContext";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/GatheredContext.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "resourceLoading";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Scalar
                                  ({
                                     type_ = (Boolean : type_);
                                     minimum = None;
                                     format = None;
                                     description =
                                       "Whether a resource's gather is on its \
                                        way.";
                                   }
                                    : scalar)
                                 : schema);
                           absent = None;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "resourceError";
                   gives =
                     (Watched
                        ({ form = "watched"; schema = None; absent = Some true }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "gatherAnnotation";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "annotationId";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/AnnotationId.json";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                      (Value
                                         ({
                                            parameter = "options";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/GatherAnnotationOptions.json";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = false;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "gatherResource";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "resourceId";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/ResourceId.json";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                      (Value
                                         ({
                                            parameter = "options";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/GatherResourceOptions.json";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = false;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
              ];
          }
           : state_units_item);
         ({
            unit = "match";
            docs =
              "Matching, run for whoever asks on the client's own bus: a \
               search asked for by a signal is run and answered under the \
               asker's correlation id. It holds no state: what it found is \
               what it said.";
            made =
              [
                ("ocaml", "Match");
                ("csharp", "MatchStateUnit");
                ("typescript", "MatchStateUnit");
                ("rust", "MatchStateUnit");
                ("python", "MatchStateUnit");
                ("go", "MatchStateUnit");
                ("kotlin", "MatchStateUnit");
                ("swift", "MatchStateUnit");
                ("haskell", "MatchStateUnit");
              ];
            made_by =
              [
                ("typescript", "createMatchStateUnit");
                ("go", "NewMatchStateUnit");
                ("haskell", "newMatchStateUnit");
              ];
            type_parameters = None;
            members = [];
          }
           : state_units_item);
         ({
            unit = "beckon";
            docs =
              "Attention on one resource: the annotation this participant \
               hovers, a sparkle for one the moment it is hovered, and a \
               focus, naming the unit's resource, for one clicked here or by \
               another participant.";
            made =
              [
                ("ocaml", "Beckon");
                ("csharp", "BeckonStateUnit");
                ("typescript", "BeckonStateUnit");
                ("rust", "BeckonStateUnit");
                ("python", "BeckonStateUnit");
                ("go", "BeckonStateUnit");
                ("kotlin", "BeckonStateUnit");
                ("swift", "BeckonStateUnit");
                ("haskell", "BeckonStateUnit");
              ];
            made_by =
              [
                ("typescript", "createBeckonStateUnit");
                ("go", "NewBeckonStateUnit");
                ("haskell", "newBeckonStateUnit");
              ];
            type_parameters = None;
            members =
              [
                ({
                   member = "hoveredAnnotationId";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/AnnotationId.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "focus";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "annotationId";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/AnnotationId.json";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
              ];
          }
           : state_units_item);
         ({
            unit = "hoverDwell";
            docs =
              "A pointer's rest: an annotation is said to be hovered once the \
               pointer has rested on it for a delay, and none at once when it \
               leaves.";
            made =
              [
                ("ocaml", "Hover_dwell");
                ("csharp", "HoverDwell");
                ("typescript", "HoverDwell");
                ("rust", "HoverDwell");
                ("python", "HoverDwell");
                ("go", "HoverDwell");
                ("kotlin", "HoverDwell");
                ("swift", "HoverDwell");
                ("haskell", "HoverDwell");
              ];
            made_by =
              [
                ("typescript", "createHoverDwell");
                ("go", "NewHoverDwell");
                ("haskell", "newHoverDwell");
              ];
            type_parameters = None;
            members =
              [
                ({
                   member = "enter";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "annotationId";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/AnnotationId.json";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "leave";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters = [];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
              ];
          }
           : state_units_item);
         ({
            unit = "search";
            docs =
              "A search that follows a query as it is typed: the query as last \
               set, and the results of the query it last settled on, once that \
               query has stayed the same for a debounce.";
            made =
              [
                ("ocaml", "Search");
                ("csharp", "SearchPipeline");
                ("typescript", "SearchPipeline");
                ("rust", "SearchPipeline");
                ("python", "SearchPipeline");
                ("go", "SearchPipeline");
                ("kotlin", "SearchPipeline");
                ("swift", "SearchPipeline");
                ("haskell", "SearchPipeline");
              ];
            made_by =
              [
                ("typescript", "createSearchPipeline");
                ("go", "NewSearchPipeline");
                ("haskell", "newSearchPipeline");
              ];
            type_parameters =
              Some
                [
                  ({
                     name = "R";
                     docs =
                       "What one result is: what the search the unit is made \
                        with gives.";
                   }
                    : type_parameters_item);
                ];
            members =
              [
                ({
                   member = "query";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Scalar
                                  ({
                                     type_ = (String : type_);
                                     minimum = None;
                                     format = None;
                                     description = "The query as last set.";
                                   }
                                    : scalar)
                                 : schema);
                           absent = None;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "state";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/SearchState.json";
                                     type_arguments =
                                       Some
                                         [
                                           ( "R",
                                             ({ type_parameter = "R" }
                                               : value_schema) );
                                         ];
                                   }
                                    : reference)
                                 : schema);
                           absent = None;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "setQuery";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "value";
                                            schema =
                                              Some
                                                (Scalar
                                                   ({
                                                      type_ = (String : type_);
                                                      minimum = None;
                                                      format = None;
                                                      description = "The query.";
                                                    }
                                                     : scalar)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
              ];
          }
           : state_units_item);
         ({
            unit = "sessionSignals";
            docs =
              "What a host shows about a session, apart from the session: that \
               it ended and why, that a request was refused for lack of \
               permission, and that a different knowledge base answers at a \
               registered address. Each is a notice while something is raised \
               and none once it is acknowledged; raising it again is a new \
               occurrence, told to every reader even when the notice equals \
               the last. A host builds one beside each live session and wires \
               the session's failures into it.";
            made =
              [
                ("ocaml", "Session_signals");
                ("csharp", "SessionSignals");
                ("typescript", "SessionSignals");
                ("rust", "SessionSignals");
                ("python", "SessionSignals");
                ("go", "SessionSignals");
                ("kotlin", "SessionSignals");
                ("swift", "SessionSignals");
                ("haskell", "SessionSignals");
              ];
            made_by =
              [
                ("typescript", "createSessionSignals");
                ("go", "NewSessionSignals");
                ("haskell", "newSessionSignals");
              ];
            type_parameters = None;
            members =
              [
                ({
                   member = "sessionEnded";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/SessionEnded.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "permissionDenied";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/PermissionDenied.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "kbIdentityConflict";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/KbIdentityConflict.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "notifySessionEnded";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "reason";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/SessionEnded.json#/properties/reason";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "notifyPermissionDenied";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "detail";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/PermissionDenied.json#/properties/detail";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "notifyKbIdentityConflict";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "conflict";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/KbIdentityConflict.json";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "acknowledgeSessionEnded";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters = [];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "acknowledgePermissionDenied";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters = [];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "acknowledgeKbIdentityConflict";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters = [];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
              ];
          }
           : state_units_item);
         ({
            unit = "cache";
            docs =
              "Values the knowledge base answers with, kept by key and held as \
               state: each key's state (pending, ready with its value, or \
               failed), fetched when first observed and again when \
               invalidated, and set, removed or invalidated by its methods. \
               What it does is held by the cache's own tables \
               (specs/src/client/refresh.json and the cache's rules in each \
               SDK), not by the behaviour table.";
            made =
              [
                ("ocaml", "Cache");
                ("csharp", "Cache");
                ("typescript", "Cache");
                ("rust", "Cache");
                ("python", "Cache");
                ("go", "Cache");
                ("kotlin", "Cache");
                ("swift", "Cache");
                ("haskell", "Cache");
              ];
            made_by =
              [
                ("typescript", "createCache");
                ("go", "NewCache");
                ("haskell", "newCache");
              ];
            type_parameters =
              Some
                [
                  ({
                     name = "K";
                     docs =
                       "What a query is keyed by: the parameters of the method \
                        it is made for, together.";
                   }
                    : type_parameters_item);
                  ({
                     name = "V";
                     docs = "What the query holds: what that method returns.";
                   }
                    : type_parameters_item);
                ];
            members =
              [
                ({
                   member = "observe";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "key";
                                            schema =
                                              Some
                                                (Type_parameter
                                                   ({ type_parameter = "K" }
                                                     : value_schema)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns =
                                    Some
                                      (Stream
                                         ({
                                            stream =
                                              (Reference
                                                 ({
                                                    ref =
                                                      "https://xynolog.org/protocol/CacheState.json";
                                                    type_arguments =
                                                      Some
                                                        [
                                                          ( "V",
                                                            ({
                                                               type_parameter =
                                                                 "V";
                                                             }
                                                              : value_schema) );
                                                        ];
                                                  }
                                                   : reference)
                                                : schema);
                                          }
                                           : returns_stream)
                                        : returns);
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "fetch";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "key";
                                            schema =
                                              Some
                                                (Type_parameter
                                                   ({ type_parameter = "K" }
                                                     : value_schema)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns =
                                    Some
                                      (Type_parameter
                                         ({ type_parameter = "V" }
                                           : value_schema)
                                        : returns);
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "get";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "key";
                                            schema =
                                              Some
                                                (Type_parameter
                                                   ({ type_parameter = "K" }
                                                     : value_schema)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns =
                                    Some
                                      (Type_parameter
                                         ({ type_parameter = "V" }
                                           : value_schema)
                                        : returns);
                                  absent = Some true;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "known";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "key";
                                            schema =
                                              Some
                                                (Type_parameter
                                                   ({ type_parameter = "K" }
                                                     : value_schema)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns =
                                    Some
                                      (Scalar
                                         ({
                                            type_ = (Boolean : type_);
                                            minimum = None;
                                            format = None;
                                            description =
                                              "Whether anything has asked for \
                                               the key and not let go of it: \
                                               it holds a value or a failure, \
                                               or a fetch for it is on its \
                                               way.";
                                          }
                                           : scalar)
                                        : returns);
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "keys";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters = [];
                                  returns =
                                    Some
                                      (Items
                                         ({
                                            list =
                                              (Type_parameter
                                                 ({ type_parameter = "K" }
                                                   : value_schema)
                                                : schema);
                                          }
                                           : items)
                                        : returns);
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "invalidate";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "key";
                                            schema =
                                              Some
                                                (Type_parameter
                                                   ({ type_parameter = "K" }
                                                     : value_schema)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "invalidateAll";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters = [];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "remove";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "key";
                                            schema =
                                              Some
                                                (Type_parameter
                                                   ({ type_parameter = "K" }
                                                     : value_schema)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                      (Value
                                         ({
                                            parameter = "gone";
                                            schema = None;
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "set";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "key";
                                            schema =
                                              Some
                                                (Type_parameter
                                                   ({ type_parameter = "K" }
                                                     : value_schema)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                      (Value
                                         ({
                                            parameter = "value";
                                            schema =
                                              Some
                                                (Type_parameter
                                                   ({ type_parameter = "V" }
                                                     : value_schema)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "patch";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "key";
                                            schema =
                                              Some
                                                (Type_parameter
                                                   ({ type_parameter = "K" }
                                                     : value_schema)
                                                  : schema);
                                            required = true;
                                            absent = None;
                                          }
                                           : value)
                                        : parameters_item);
                                      (Callback
                                         ({
                                            parameter = "change";
                                            calls =
                                              (Type_parameter
                                                 ({ type_parameter = "V" }
                                                   : value_schema)
                                                : schema);
                                            required = true;
                                            returns =
                                              Some
                                                (Type_parameter
                                                   ({ type_parameter = "V" }
                                                     : value_schema)
                                                  : schema);
                                          }
                                           : callback)
                                        : parameters_item);
                                    ];
                                  returns = None;
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "persistencePending";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters = [];
                                  returns =
                                    Some
                                      (Scalar
                                         ({
                                            type_ = (Boolean : type_);
                                            minimum = None;
                                            format = None;
                                            description =
                                              "Whether the cache's content may \
                                               be ahead of what it has \
                                               persisted: a fetch on its way, \
                                               or a save owed.";
                                          }
                                           : scalar)
                                        : returns);
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "keptFetching";
                   gives =
                     (Function
                        ({ form = "function"; signature = None } : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "attach";
                   gives =
                     (Function
                        ({ form = "function"; signature = None } : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "query";
                   gives =
                     (Function
                        ({ form = "function"; signature = None } : function_)
                       : gives);
                 }
                  : item_members_item);
              ];
          }
           : state_units_item);
         ({
            unit = "session";
            docs =
              "A session with one knowledge base: the token its client's \
               transport sends and who is signed in, the token renewed before \
               it expires and when the gateway refuses it. It writes its token \
               and who is signed in, so it ends them; it only uses its client, \
               so it never ends it, and whoever made the client and the \
               session ends both. Its `errors` are its one stream of what went \
               wrong: its own errors (a SessionError: its sign-in could not be \
               checked or renewed, the gateway refused a token just issued, \
               what its client keeps could not be kept, its storage refused a \
               write of it) and its transport's failures, each said once; a \
               session takes no callback for them. They end when the session \
               ends. Whoever ends both closes the client first, waiting for \
               its closing flush, and then ends the session, so what that \
               flush meets is said before the errors end; what the client \
               meets once its session has ended is said nowhere. What it does \
               is held by the session's own table \
               (specs/src/session/cases.json), not by the behaviour table.";
            made =
              [
                ("ocaml", "Session");
                ("csharp", "XynologSession");
                ("typescript", "XynologSession");
                ("rust", "XynologSession");
                ("python", "XynologSession");
                ("go", "Session");
                ("kotlin", "XynologSession");
                ("swift", "XynologSession");
                ("haskell", "Session");
              ];
            made_by =
              [
                ("go", "StartSession");
                ("kotlin", "sessionFromKept");
                ("swift", "sessionFromKept");
                ("csharp", "FromKeptAsync");
                ("haskell", "newSession");
              ];
            type_parameters = None;
            members =
              [
                ({
                   member = "id";
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Scalar
                                  ({
                                     type_ = (String : type_);
                                     minimum = None;
                                     format = None;
                                     description =
                                       "The session's own id: a session made \
                                        again for the same knowledge base has \
                                        another.";
                                   }
                                    : scalar)
                                 : schema);
                           absent = None;
                         }
                          : gives_value)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "kb";
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/KbTarget.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = None;
                         }
                          : gives_value)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "client";
                   gives =
                     (Value
                        ({ form = "value"; schema = None; absent = None }
                          : gives_value)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "token";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/AccessToken.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "user";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/UserResponse.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = Some true;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "streamState";
                   gives =
                     (Watched
                        ({
                           form = "watched";
                           schema =
                             Some
                               (Reference
                                  ({
                                     ref =
                                       "https://xynolog.org/protocol/ConnectionState.json";
                                     type_arguments = None;
                                   }
                                    : reference)
                                 : schema);
                           absent = None;
                         }
                          : watched)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "errors";
                   gives =
                     (Stream ({ form = "stream"; schema = None } : stream)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "ready";
                   gives = (Settles ({ form = "settles" } : settles) : gives);
                 }
                  : item_members_item);
                ({
                   member = "expiresAt";
                   gives =
                     (Value
                        ({
                           form = "value";
                           schema =
                             Some
                               (Scalar
                                  ({
                                     type_ = (String : type_);
                                     minimum = None;
                                     format = Some "date-time";
                                     description =
                                       "When the session's token stops \
                                        working, as the token states it.";
                                   }
                                    : scalar)
                                 : schema);
                           absent = Some true;
                         }
                          : gives_value)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "refresh";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters =
                                    [
                                      (Value
                                         ({
                                            parameter = "refused";
                                            schema =
                                              Some
                                                (Reference
                                                   ({
                                                      ref =
                                                        "https://xynolog.org/protocol/AccessToken.json";
                                                      type_arguments = None;
                                                    }
                                                     : reference)
                                                  : schema);
                                            required = true;
                                            absent = Some true;
                                          }
                                           : value)
                                        : parameters_item);
                                    ];
                                  returns =
                                    Some
                                      (Reference
                                         ({
                                            ref =
                                              "https://xynolog.org/protocol/AccessToken.json";
                                            type_arguments = None;
                                          }
                                           : reference)
                                        : returns);
                                  absent = Some true;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
                ({
                   member = "renewer";
                   gives =
                     (Function
                        ({
                           form = "function";
                           signature =
                             Some
                               ({
                                  parameters = [];
                                  returns =
                                    Some
                                      (Function
                                         ({ function_ = "refresh" }
                                           : returns_function)
                                        : returns);
                                  absent = None;
                                }
                                 : signature);
                         }
                          : function_)
                       : gives);
                 }
                  : item_members_item);
              ];
          }
           : state_units_item);
       ];
     wire =
       ({
          docs =
            "The typed bus over a client's transport, which a client hands out \
             as `wire`: what it emits goes over the wire, and what it reads is \
             what the wire delivers. A read gives each frame with its \
             envelope, who emitted it and the trace it was sent under. A \
             channel of a resource's scope is read for one resource, and the \
             read holds that resource's scope while it is read. The client's \
             own in-process signals are on its own bus, never here. It hands \
             out no transport: a client's transport is the client's \
             `transport`, and only there.";
          made =
            [
              ("ocaml", "Bus");
              ("haskell", "Bus");
              ("csharp", "Bus");
              ("swift", "Bus");
              ("typescript", "Bus");
              ("rust", "Bus");
              ("python", "Bus");
              ("go", "Wire");
              ("kotlin", "Bus");
            ];
          members =
            [
              ({
                 member = "emit";
                 gives =
                   (Function
                      ({ form = "function"; signature = None } : function_)
                     : gives);
               }
                : wire_members_item);
              ({
                 member = "frames";
                 gives =
                   (Function
                      ({ form = "function"; signature = None } : function_)
                     : gives);
               }
                : wire_members_item);
              ({
                 member = "framesOf";
                 gives =
                   (Function
                      ({ form = "function"; signature = None } : function_)
                     : gives);
               }
                : wire_members_item);
              ({
                 member = "request";
                 gives =
                   (Function
                      ({ form = "function"; signature = None } : function_)
                     : gives);
               }
                : wire_members_item);
              ({
                 member = "emitOn";
                 gives =
                   (Function
                      ({ form = "function"; signature = None } : function_)
                     : gives);
               }
                : wire_members_item);
              ({
                 member = "framesOn";
                 gives =
                   (Function
                      ({ form = "function"; signature = None } : function_)
                     : gives);
               }
                : wire_members_item);
              ({
                 member = "requestOf";
                 gives =
                   (Function
                      ({ form = "function"; signature = None } : function_)
                     : gives);
               }
                : wire_members_item);
            ];
        }
         : wire);
     storage =
       ({
          docs =
            "Where a client keeps what must outlive it: text under a key, in a \
             store the application supplies (a file, a browser's storage, a \
             platform's store), so nothing above it knows where it runs. A \
             client's sessions, its registry of knowledge bases and its kept \
             caches keep what they keep there. More than one context can write \
             one store, two windows or two processes: what is written from \
             what was read goes through `update`, which a store makes one \
             step, so one writer's change is never lost under another's; and \
             `subscribe` hears what another context writes, and is null where \
             no other context writes.";
          made =
            [
              ("ocaml", "Storage");
              ("haskell", "SessionStorage");
              ("csharp", "ISessionStorage");
              ("typescript", "SessionStorage");
              ("rust", "SessionStorage");
              ("python", "SessionStorage");
              ("go", "SessionStorage");
              ("kotlin", "SessionStorage");
              ("swift", "SessionStorage");
            ];
          members =
            [
              ({ member = "get" } : storage_members_item);
              ({ member = "set" } : storage_members_item);
              ({ member = "delete" } : storage_members_item);
              ({ member = "update" } : storage_members_item);
              ({ member = "subscribe" } : storage_members_item);
            ];
        }
         : storage);
     modules =
       [
         ({
            module_ = "annotations";
            docs =
              "The readers of an annotation, its builders, and the reconciling \
               of a quote: what a program that reads or makes annotations is \
               given, so that none parses or builds one by hand. Held by \
               specs/src/annotations's tables.";
            members =
              [
                (Reader ({ member = "bodySource"; kind = "reader" } : reader)
                  : modules_item_members_item);
                (Reader ({ member = "targetSource"; kind = "reader" } : reader)
                  : modules_item_members_item);
                (Reader
                   ({ member = "targetSelector"; kind = "reader" } : reader)
                  : modules_item_members_item);
                (Reader ({ member = "commentText"; kind = "reader" } : reader)
                  : modules_item_members_item);
                (Reader
                   ({ member = "textQuoteSelector"; kind = "reader" } : reader)
                  : modules_item_members_item);
                (Reader ({ member = "exactText"; kind = "reader" } : reader)
                  : modules_item_members_item);
                (Reader
                   ({ member = "annotationExactText"; kind = "reader" }
                     : reader)
                  : modules_item_members_item);
                (Reader ({ member = "entityTypes"; kind = "reader" } : reader)
                  : modules_item_members_item);
                (Reader ({ member = "tagCategory"; kind = "reader" } : reader)
                  : modules_item_members_item);
                (Reader ({ member = "tagSchemaId"; kind = "reader" } : reader)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "isBodyResolved";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({ member = "isHighlight"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({ member = "isReference"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({ member = "isAssessment"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({ member = "isComment"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({ member = "isTag"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "isStubReference";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "isResolvedReference";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Reader
                   ({ member = "textPositionSelector"; kind = "reader" }
                     : reader)
                  : modules_item_members_item);
                (Reader ({ member = "svgSelector"; kind = "reader" } : reader)
                  : modules_item_members_item);
                (Reader
                   ({ member = "fragmentSelector"; kind = "reader" } : reader)
                  : modules_item_members_item);
                (Function
                   ({ member = "reconcile"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "annotationOfSpan";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "annotationOfResource";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "QuotedText";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "TextSpan";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "ReconciledSpan";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "AnchorMethod";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "MatchQuality";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "SpanRefusedError";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "SpanRefusal";
                      kind = "type";
                      named = Some [ ("haskell", "SpanRefusalCode") ];
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "Spanned";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "OfSpan";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "OfResource";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "jobFilter";
            docs =
              "Whether a job matches a filter: asked by the dispatcher \
               choosing a claim's next job, and by a worker checking an \
               announcement against its claim. Held by \
               specs/src/jobs/filter-cases.json.";
            members =
              [
                (Function
                   ({
                      member = "jobMatchesFilter";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "claims";
            docs =
              "What a worker's stream names, and whether a failed job is run \
               again: the channels claiming reads and the channels committing \
               reads, each constant's `names`, and whether a failed attempt is \
               retried, which a held job reports on `job:fail`. Held by \
               specs/src/jobs/retry-cases.json.";
            members =
              [
                (Constant
                   ({
                      member = "jobClaimChannels";
                      kind = "constant";
                      named = None;
                      names =
                        Some
                          ({
                             replies_of = [ "job:claim" ];
                             channels = [ "job:queued"; "job:cancel-requested" ];
                           }
                            : names);
                      value = None;
                    }
                     : constant)
                  : modules_item_members_item);
                (Constant
                   ({
                      member = "jobCommitChannels";
                      kind = "constant";
                      named = None;
                      names =
                        Some
                          ({
                             replies_of =
                               [ "mark:commit"; "browse:annotation-requested" ];
                             channels = [];
                           }
                            : names);
                      value = None;
                    }
                     : constant)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "willRetryAfter";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "retry";
            docs =
              "Doing work again by a backoff, until it succeeds, it fails as \
               nothing can mend, or the attempts run out.";
            members =
              [
                (Function
                   ({
                      member = "retryWithBackoff";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "hostName";
            docs =
              "Whether a host is one a knowledge base's HTTP endpoint may \
               name. Held by specs/src/session/gateway-url-cases.json.";
            members =
              [
                (Function
                   ({
                      member = "isValidHostname";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "tokens";
            docs =
              "What a session reads of an access token: a claim it names as \
               text, when it expires, whether it has, and when to renew it. \
               Held by specs/src/session/cases.json.";
            members =
              [
                (Function
                   ({ member = "textClaim"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "tokenExpiry";
                      kind = "function";
                      named = Some [ ("typescript", "parseJwtExpiry") ];
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "isTokenExpired";
                      kind = "function";
                      named = Some [ ("typescript", "isJwtExpired") ];
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({ member = "renewalDelay"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "refreshDelay";
                      kind = "function";
                      named = Some [ ("typescript", "refreshDelayMs") ];
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "storagePersister";
            docs =
              "Where a client keeps its queries' values: a session storage, \
               one key for each query it keeps for the person signed in, each \
               kept within a size.";
            members =
              [
                (Type
                   ({
                      member = "StoragePersister";
                      kind = "type";
                      named =
                        Some
                          [
                            ("typescript", "sessionStoragePersister");
                            ("csharp", "CachePersistence");
                          ];
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "bus";
            docs =
              "What the bus's registry gives a program beside its channels: \
               the reply channels of given operations, the refusal of a \
               request whose replies cannot arrive, and the channels whose \
               events the record keeps; and what a transport delivers in place \
               of a frame it refuses, and why it refuses it.";
            members =
              [
                (Function
                   ({
                      member = "replyChannelsFor";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({ member = "unsubscribed"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Constant
                   ({
                      member = "persistedEventTypes";
                      kind = "constant";
                      named = None;
                      names = None;
                      value = None;
                    }
                     : constant)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "FrameRefusal";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "FrameRefusalReason";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "Carried";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "registry";
            docs =
              "What an application holds beside its knowledge bases: the list \
               it has registered, which one is active and its session, what a \
               person has open in each, and what it keeps in its storage, \
               under which keys. Sessions are built by a factory it is given; \
               one over HTTP reaches a knowledge base at its gateway. A \
               person's sign-in by a page redirect lands on the entry for the \
               knowledge base that answered. The registry is the one reader of \
               each session's errors, from the first thing the session said: \
               each of the session's own it says on its own errors; a refusal \
               for lack of permission is said through the session's signals; a \
               refusal for want of a valid token, and a failure of its \
               transport for any other reason, it does nothing with. It renews \
               no session: the transport that met such a refusal renews the \
               token it sent (contract/TRANSPORT-CONTRACT.md \194\167 A \
               refused credential). A factory reads none of them, so a session \
               built by a factory a host writes is read the same way.";
            members =
              [
                (Type
                   ({
                      member = "XynologBrowser";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "newXynologBrowser";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "XynologBrowserConfig";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "SignedIn";
                      kind = "type";
                      named = None;
                      fields_named = Some [ ("go", [ ("kbId", "KbID") ]) ];
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "Expected";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "SignInOutcome";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "KbReadVerdict";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "KbReadKind";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "SessionFactory";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "SessionFactoryOptions";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = Some [ "kb"; "storage"; "signals" ];
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "HttpSessionFactory";
                      kind = "type";
                      named =
                        Some
                          [
                            ("typescript", "createHttpSessionFactory");
                            ("haskell", "newHttpSessionFactory");
                          ];
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "KbSessionStatus";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "OpenResource";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "TabCheck";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "TabVerdict";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "applyTabChecks";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "sortOpenResources";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "StoredSession";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Constant
                   ({
                      member = "knowledgeBasesKey";
                      kind = "constant";
                      named = Some [ ("typescript", "STORAGE_KEY") ];
                      names = None;
                      value = None;
                    }
                     : constant)
                  : modules_item_members_item);
                (Constant
                   ({
                      member = "activeKey";
                      kind = "constant";
                      named = None;
                      names = None;
                      value = None;
                    }
                     : constant)
                  : modules_item_members_item);
                (Constant
                   ({
                      member = "openResourcesByKbKey";
                      kind = "constant";
                      named = None;
                      names = None;
                      value = None;
                    }
                     : constant)
                  : modules_item_members_item);
                (Constant
                   ({
                      member = "lastViewedResourceByKbKey";
                      kind = "constant";
                      named = None;
                      names = None;
                      value = None;
                    }
                     : constant)
                  : modules_item_members_item);
                (Function
                   ({ member = "sessionKey"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "kbOfSessionKey";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "storedSession";
                      kind = "function";
                      named =
                        Some
                          [
                            ("typescript", "getStoredSession");
                            ("go", "StoredSessionOf");
                          ];
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "storeSession";
                      kind = "function";
                      named = Some [ ("typescript", "setStoredSession") ];
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "clearStoredSession";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "loadKnowledgeBases";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "saveKnowledgeBases";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({ member = "keptIn"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({ member = "beginSignIn"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "completeSignIn";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "sessionNotices";
            docs =
              "What a session's signals raise: that a session ended and why, \
               that a request was refused for lack of permission, and that a \
               different knowledge base answers at a registered address. Each \
               is a client type of specs/src/client/types.";
            members =
              [
                (Type
                   ({
                      member = "SessionEnded";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "PermissionDenied";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "KbIdentityConflict";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "redirectSignIn";
            docs =
              "A person's sign-in by a page redirect: the authorization-code \
               grant with PKCE, its pending record kept across the trip to the \
               issuer and back, and the question a completed sign-in asks the \
               knowledge base, who it is.";
            members =
              [
                (Function
                   ({
                      member = "codeChallenge";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "PendingAuthorization";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Constant
                   ({
                      member = "pendingAuthorizationKey";
                      kind = "constant";
                      named = None;
                      names = None;
                      value = None;
                    }
                     : constant)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "BeginAuthorizationOptions";
                      kind = "type";
                      named = Some [ ("rust", "BeginAuthorization") ];
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "beginAuthorization";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "completeAuthorization";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "describeConnection";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "ConnectionIdentity";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "IdentityUnverifiableError";
                      kind = "type";
                      named = Some [ ("rust", "IdentityUnverifiable") ];
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "serviceToken";
            docs =
              "A service account's token, which a process holds for its own \
               account at the issuer a knowledge base trusts: the issuer's \
               token endpoint discovered once, through the HTTP client the \
               token was made with, one client-credentials grant at a time, \
               the token held until it is due for renewal, and the \
               `Authorization` header's value it gives (`authorization`).";
            members =
              [
                (Type
                   ({
                      member = "ServiceToken";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "signInStore";
            docs =
              "The sign-ins `xynolog login` keeps, as specs/src/sign-in-store \
               states them: the store, whose every change holds the lock every \
               writer takes, and where the launcher's state home is on each \
               system. Held by sign-in-store/cases.json.";
            members =
              [
                (Type
                   ({
                      member = "SignInStore";
                      kind = "type";
                      named = Some [ ("ocaml", "t") ];
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "stateDir";
                      kind = "function";
                      named =
                        Some
                          [
                            ("haskell", "stateDirectory");
                            ("ocaml", "state_directory");
                          ];
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "System";
                      kind = "type";
                      named =
                        Some
                          [
                            ("kotlin", "Platform");
                            ("swift", "Platform");
                            ("ocaml", "platform");
                          ];
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "thisSystem";
                      kind = "function";
                      named = Some [ ("kotlin", "thisPlatform") ];
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Constant
                   ({
                      member = "fileName";
                      kind = "constant";
                      named =
                        Some
                          [
                            ("go", "SignInFile"); ("haskell", "signInFileName");
                          ];
                      names = None;
                      value = None;
                    }
                     : constant)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "SignInFiles";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "keptSignIn";
            docs =
              "A sign-in a session holds and renews wherever it is kept (a \
               registry's storage, through the registry's keptIn; the sign-ins \
               `xynolog login` keeps; memory; a host's own), and what a script \
               does with one: signs a person in to it by the device grant, \
               opens a session over it, renews it at the issuer, and signs out \
               of it. A session opened over one asks the gateway who its token \
               is unless it is told not to (`validate`, true when it is left \
               out). Its client keeps for the person the kept sign-in names \
               from the start, whether or not it asks \
               (specs/src/session/persisted-cases.json, `startup`); asking is \
               how it learns the person when the sign-in names nobody yet, and \
               a session that does not ask then keeps for nobody. \
               docs/builder/SIGN-IN.md says which to use when.";
            members =
              [
                (Type
                   ({
                      member = "SignInKept";
                      kind = "type";
                      named =
                        Some
                          [
                            ("csharp", "ISignInKept"); ("haskell", "KeptSignIn");
                          ];
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "MemorySignIn";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "signInDevice";
                      kind = "function";
                      named = Some [ ("go", "SignInWithDevice") ];
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "sessionFromKept";
                      kind = "function";
                      named = Some [ ("haskell", "fromKeptSession") ];
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({ member = "renewKept"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({ member = "signOut"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "discovery";
            docs =
              "The knowledge bases a launcher manages, as it publishes them: \
               its document read whole or not at all, absent told from empty, \
               entries told apart by address, and what changed since it was \
               last read.";
            members =
              [
                (Constant
                   ({
                      member = "discoveryInterval";
                      kind = "constant";
                      named = None;
                      names = None;
                      value = None;
                    }
                     : constant)
                  : modules_item_members_item);
                (Constant
                   ({
                      member = "discoveryUrlPath";
                      kind = "constant";
                      named = None;
                      names = None;
                      value = Some (`String "/discovery/kbs.json");
                    }
                     : constant)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "DiscoveryAbsentReason";
                      kind = "type";
                      named = Some [ ("haskell", "DiscoveryAbsentCode") ];
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "DiscoveryRead";
                      kind = "type";
                      named = Some [ ("typescript", "DiscoveryReadResult") ];
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "DiscoveryState";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "Absent";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "Managed";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "Unchanged";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "DiscoveryTransport";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "parseDiscoveryDocument";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "textDiscovery";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "httpDiscovery";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "DiscoveryDiff";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "subscribeDiscovery";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "testing";
            docs =
              "What a consumer's tests hold a composition and a registry to: \
               the liveness axioms, that under any behaviour of the wire \
               something is eventually said and every event is delivered \
               exactly once; a real session over test doubles; a factory of \
               scripted sessions for a registry; and a storage several \
               contexts share.";
            members =
              [
                (Type
                   ({
                      member = "LivenessScenario";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "LivenessSpec";
                      kind = "type";
                      named = Some [ ("typescript", "LivenessAxiomSpec") ];
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "Respond";
                      kind = "type";
                      named =
                        Some
                          [ ("go", "MakeResponse"); ("python", "MakeResponse") ];
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "faultActions";
                      kind = "function";
                      named = Some [ ("typescript", "arbFaultAction") ];
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "faultSchedules";
                      kind = "function";
                      named = Some [ ("typescript", "arbFaultSchedule") ];
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "assertLivenessAxioms";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "DeliverySubject";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "DeliveryOp";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "deliveryOps";
                      kind = "function";
                      named = Some [ ("typescript", "arbDeliveryOps") ];
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "assertExactlyOnceDelivery";
                      kind = "function";
                      named = None;
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({
                      member = "createTestSession";
                      kind = "function";
                      named = Some [ ("go", "NewTestSession") ];
                    }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "TestSession";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "TestSessionOptions";
                      kind = "type";
                      named = Some [ ("go", "TestSessionConfig") ];
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "ScriptedSessions";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "Renewal";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "SharedStorage";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
         ({
            module_ = "refusals";
            docs =
              "The first fault a body has as a component schema, and what \
               every SDK says of it as it refuses it (`it has no `x``, `its \
               `x` is malformed`, `it is malformed`): for an SDK whose HTTP \
               transport is a package of its own, which reads its answers and \
               holds its stream's frames by them. Held by the table of what \
               each schema requires (the consumer-owned generator).";
            members =
              [
                (Function
                   ({ member = "faultSaid"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({ member = "faultOf"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Function
                   ({ member = "said"; kind = "function"; named = None }
                     : modules_item_members_item_function)
                  : modules_item_members_item);
                (Type
                   ({
                      member = "Fault";
                      kind = "type";
                      named = None;
                      fields_named = None;
                      fields = None;
                    }
                     : modules_item_members_item_type)
                  : modules_item_members_item);
              ];
          }
           : modules_item);
       ];
     clock =
       [
         ({
            source = "clock";
            docs =
              "What every wait an SDK makes, and every interval it measures, \
               keeps the time of: a clock its caller controls, so a caller who \
               moves it sees each wait end when \
               specs/src/client/clock-cases.json says. Where the runtime owns \
               time, the caller moves the runtime's clock from outside the \
               SDK, which takes none (`outside`). Where the ecosystem's waits \
               take a clock, every public maker of something that waits takes \
               one, its system clock when none is given, unless it is handed \
               something that already carries one, whose clock it keeps; and \
               what it makes keeps its clock (`takes`). A reading of the wall \
               clock, which compares now with an instant a server stated or \
               stamps a record, is no part of it.";
            type_words =
              [
                "Clock"; "TimeSource"; "TimeProvider"; "Scheduler"; "EventLoop";
              ];
            outside =
              [
                ( "typescript",
                  "A test runner's fake timers, which fake every timer global \
                   and Date: every wait the SDK makes is a timer global." );
                ( "rust",
                  "Tokio's paused clock: every wait and interval is \
                   tokio::time's, reqwest's request deadline among them." );
                ( "python",
                  "The running asyncio loop's clock: every wait is the running \
                   loop's, and every request deadline is the SDK's own asyncio \
                   timeout." );
                ( "go",
                  "testing/synctest: every wait is package time's, on \
                   goroutines the caller's call starts." );
              ];
            takes =
              [
                ( "ocaml",
                  [
                    ("Clock.make", [ "Eio.Time.Mono.t"; "Eio.Time.clock" ]);
                    ("Subscription.start", [ "Clock.t" ]);
                    ("Session.start", [ "Clock.t" ]);
                    ("Http_wire.make", [ "Clock.t" ]);
                    ("Live_query.make", [ "Clock.t" ]);
                  ] );
                ( "kotlin",
                  [
                    ("XynologClient", [ "CoroutineContext"; "TimeSource" ]);
                    ("TestClient", [ "CoroutineContext"; "TimeSource" ]);
                    ("HttpTransport", [ "CoroutineContext"; "TimeSource" ]);
                    ("Bus", [ "CoroutineContext"; "TimeSource" ]);
                    ("request", [ "TimeSource" ]);
                    ("HoverDwell", [ "CoroutineContext" ]);
                    ("SearchPipeline", [ "CoroutineContext" ]);
                    ("Cache", [ "CoroutineContext" ]);
                    ("httpDiscovery", [ "CoroutineContext" ]);
                    ("FaultyTransport", [ "CoroutineContext" ]);
                    ("ServiceToken", [ "CoroutineContext"; "TimeSource" ]);
                    ("AgentToken", [ "CoroutineContext" ]);
                    ("signInDevice", [ "TimeSource" ]);
                    ("describeConnection", [ "TimeSource" ]);
                    ("TestSessionOptions", [ "CoroutineContext"; "TimeSource" ]);
                    ("LivenessSpec", [ "CoroutineContext" ]);
                    ("sessionFromKept", [ "CoroutineContext"; "TimeSource" ]);
                    ("HttpSessionFactory", [ "CoroutineContext"; "TimeSource" ]);
                    ( "XynologBrowserConfig",
                      [ "CoroutineContext"; "TimeSource" ] );
                    ("ScriptedSessions", [ "CoroutineContext"; "TimeSource" ]);
                    ("requestFuture", [ "CoroutineContext"; "TimeSource" ]);
                    ("retryWithBackoffFuture", [ "CoroutineContext" ]);
                    ("renewKeptFuture", [ "CoroutineContext" ]);
                    ("signInDeviceFuture", [ "CoroutineContext"; "TimeSource" ]);
                    ("signOutFuture", [ "CoroutineContext" ]);
                    ("beginAuthorizationFuture", [ "CoroutineContext" ]);
                    ("completeAuthorizationFuture", [ "CoroutineContext" ]);
                    ( "describeConnectionFuture",
                      [ "CoroutineContext"; "TimeSource" ] );
                    ( "sessionFromKeptFuture",
                      [ "CoroutineContext"; "TimeSource" ] );
                    ("createTestSessionFuture", [ "CoroutineContext" ]);
                  ] );
                ( "swift",
                  [
                    ("XynologClient", [ "Clock" ]);
                    ("HttpTransport", [ "Clock" ]);
                    ("Bus", [ "Clock" ]);
                    ("Cache", [ "Clock" ]);
                    ("HoverDwell", [ "Clock" ]);
                    ("SearchPipeline", [ "Clock" ]);
                    ("subscribeDiscovery", [ "Clock" ]);
                    ("httpDiscovery", [ "Clock" ]);
                    ("retryWithBackoff", [ "Clock" ]);
                    ("signInDevice", [ "Clock" ]);
                    ("renewKept", [ "Clock" ]);
                    ("ServiceToken", [ "Clock" ]);
                    ("AgentToken", [ "Clock" ]);
                    ("StoragePersister", [ "Clock" ]);
                    ("sessionFromKept", [ "Clock" ]);
                    ("HttpSessionFactory", [ "Clock" ]);
                    ("XynologBrowserConfig", [ "Clock" ]);
                    ("XynologClient.fromHttp", [ "Clock" ]);
                    ("signOut", [ "Clock" ]);
                    ("whoAmI", [ "Clock" ]);
                    ("beginAuthorization", [ "Clock" ]);
                    ("completeAuthorization", [ "Clock" ]);
                    ("describeConnection", [ "Clock" ]);
                    ("ScriptedTransport", [ "Clock" ]);
                    ("ScriptedSessions", [ "Clock" ]);
                    ("TestSessionOptions", [ "Clock" ]);
                    ("LivenessSpec", [ "Clock" ]);
                  ] );
                ( "csharp",
                  [
                    ("XynologClient", [ "TimeProvider" ]);
                    ("HttpTransport", [ "TimeProvider" ]);
                    ("Issuer", [ "TimeProvider" ]);
                    ("ServiceToken", [ "TimeProvider" ]);
                    ("AgentToken", [ "TimeProvider" ]);
                    ("FromKeptAsync", [ "TimeProvider" ]);
                    ("SignInStore", [ "TimeProvider" ]);
                    ("Cache", [ "TimeProvider" ]);
                    ("HoverDwell", [ "TimeProvider" ]);
                    ("SearchPipeline", [ "TimeProvider" ]);
                    ("HttpDiscovery", [ "TimeProvider" ]);
                    ("SubscribeDiscovery", [ "TimeProvider" ]);
                    ("GetCurrentUserAsync", [ "TimeProvider" ]);
                    ("HttpSessionFactory", [ "TimeProvider" ]);
                    ("XynologBrowserConfig", [ "TimeProvider" ]);
                    ("FaultyTransport", [ "TimeProvider" ]);
                    ("TestSessionOptions", [ "TimeProvider" ]);
                    ("ScriptedSessions", [ "TimeProvider" ]);
                    ("BeginAuthorizationAsync", [ "TimeProvider" ]);
                    ("CompleteAuthorizationAsync", [ "TimeProvider" ]);
                    ("DescribeConnectionAsync", [ "TimeProvider" ]);
                    ("LivenessSpec", [ "TimeProvider" ]);
                    ("RetryWithBackoffAsync", [ "TimeProvider" ]);
                  ] );
                ( "haskell",
                  [
                    ("newClient", [ "BusOptions" ]);
                    ("fromHttp", [ "HttpOptions" ]);
                    ("newHttpTransport", [ "HttpOptions" ]);
                    ("HttpOptions", [ "RetryOptions" ]);
                    ("newCache", [ "CacheOptions" ]);
                    ("newClaims", [ "WorkerOptions" ]);
                    ("WorkerOptions", [ "BusOptions" ]);
                    ("newBus", [ "BusOptions" ]);
                    ("newJob", [ "BusOptions" ]);
                    ("subscribeDiscovery", [ "DiscoveryOptions" ]);
                    ("retryWithBackoff", [ "RetryOptions" ]);
                    ("newSession", [ "RetryOptions" ]);
                    ("fromIssuedSession", [ "HttpOptions" ]);
                    ("signInDevice", [ "HttpOptions" ]);
                    ("IssuerOptions", [ "RetryOptions" ]);
                    ("newServiceTokenSecret", [ "IssuerOptions" ]);
                    ("newServiceTokenKey", [ "IssuerOptions" ]);
                    ("signInAgent", [ "HttpOptions" ]);
                    ("fromKeptSession", [ "HttpOptions" ]);
                    ("pollUntilComplete", [ "JobNamespace" ]);
                    ("httpDiscovery", [ "RetryOptions" ]);
                    ("newSignInStore", [ "SignInStoreOptions" ]);
                    ("SignInStoreOptions", [ "RetryOptions" ]);
                    ("newHttpSessionFactory", [ "HttpOptions" ]);
                    ("XynologBrowserConfig", [ "HttpOptions" ]);
                    ("describeConnection", [ "HttpOptions" ]);
                    ("newHoverDwell", [ "RetryOptions" ]);
                    ("newSearchPipeline", [ "RetryOptions" ]);
                    ("newMarkStateUnit", [ "RetryOptions" ]);
                    ("newFaultyTransport", [ "RetryOptions" ]);
                    ("newScriptedSessions", [ "RetryOptions" ]);
                    ("createTestSession", [ "TestSessionOptions" ]);
                    ("TestSessionOptions", [ "RetryOptions" ]);
                    ("assertLivenessAxioms", [ "LivenessSpec" ]);
                    ("LivenessSpec", [ "RetryOptions" ]);
                  ] );
              ];
          }
           : clock_item);
         ({
            source = "random";
            docs =
              "What every jitter an SDK draws draws from: a random source its \
               caller controls, so a caller can make each draw the lowest the \
               source gives, as specs/src/client/clock-cases.json does. Where \
               every draw can already be reached from outside the SDK, the \
               caller reaches it there, and the SDK takes none (`outside`). \
               Elsewhere every public maker of something that backs off, and \
               every public function that draws a jitter, takes one, the \
               system's source when none is given, unless it is handed \
               something that already carries one, whose source it keeps; and \
               what it makes keeps its source (`takes`). The randomness of a \
               secret, a PKCE verifier, a nonce or a client assertion's `jti`, \
               stays the platform's cryptographic source, and is no part of \
               it.";
            type_words = [ "Random"; "Rng" ];
            outside =
              [
                ( "typescript",
                  "Math.random, which a test replaces: every jitter draws from \
                   it." );
                ( "python",
                  "The random module, which a test seeds or patches: every \
                   jitter draws random.random()." );
              ];
            takes =
              [
                ( "ocaml",
                  [
                    ("Clock.make", [ "Random.State.t" ]);
                    ("Subscription.start", [ "Clock.t" ]);
                    ("Session.start", [ "Clock.t" ]);
                    ("Http_wire.make", [ "Clock.t" ]);
                    ("Live_query.make", [ "Clock.t" ]);
                  ] );
                ( "rust",
                  [
                    ("HttpTransportConfig", [ "Rng" ]);
                    ("XynologSessionConfig", [ "Rng" ]);
                    ("retry_with_backoff", [ "Rng" ]);
                    ("SessionFromKept", [ "Rng" ]);
                    ("AgentToken::sign_in", [ "Rng" ]);
                    ("equal_jitter", [ "Rng" ]);
                    ("HttpSession", [ "Rng" ]);
                    ("HttpSessionFactory::new", [ "Rng" ]);
                    ("describe_connection", [ "Rng" ]);
                    ("complete_sign_in", [ "Rng" ]);
                    ("ScriptedSessions::new", [ "Rng" ]);
                    ("ScriptedSessions::answering", [ "Rng" ]);
                  ] );
                ( "go",
                  [
                    ("HTTPTransportConfig", [ "rand.Rand" ]);
                    ("SessionConfig", [ "rand.Rand" ]);
                    ("ResumeConfig", [ "rand.Rand" ]);
                    ("SessionFromKeptConfig", [ "rand.Rand" ]);
                    ("Issuer", [ "rand.Rand" ]);
                    ("AgentConfig", [ "rand.Rand" ]);
                    ("HttpSessionFactory", [ "rand.Rand" ]);
                    ("CompleteSignIn", [ "rand.Rand" ]);
                    ("DescribeConnection", [ "rand.Rand" ]);
                    ("NewScriptedSessions", [ "rand.Rand" ]);
                    ("RetryWithBackoff", [ "rand.Rand" ]);
                    ("EqualJitter", [ "rand.Rand" ]);
                  ] );
                ( "kotlin",
                  [
                    ("HttpTransport", [ "Random" ]);
                    ("AgentToken", [ "Random" ]);
                    ("sessionFromKept", [ "Random" ]);
                    ("HttpSessionFactory", [ "Random" ]);
                    ("XynologBrowserConfig", [ "Random" ]);
                    ("ScriptedSessions", [ "Random" ]);
                    ("retryWithBackoff", [ "Random" ]);
                    ("equalJitter", [ "Random" ]);
                    ("describeConnection", [ "Random" ]);
                    ("renewKept", [ "Random" ]);
                    ("TestSessionOptions", [ "Random" ]);
                    ("retryWithBackoffFuture", [ "Random" ]);
                    ("renewKeptFuture", [ "Random" ]);
                    ("sessionFromKeptFuture", [ "Random" ]);
                    ("describeConnectionFuture", [ "Random" ]);
                  ] );
                ( "swift",
                  [
                    ("HttpTransport", [ "RandomNumberGenerator" ]);
                    ("retryWithBackoff", [ "RandomNumberGenerator" ]);
                    ("renewKept", [ "RandomNumberGenerator" ]);
                    ("AgentToken", [ "RandomNumberGenerator" ]);
                    ("sessionFromKept", [ "RandomNumberGenerator" ]);
                    ("HttpSessionFactory", [ "RandomNumberGenerator" ]);
                    ("XynologBrowserConfig", [ "RandomNumberGenerator" ]);
                    ("XynologClient.fromHttp", [ "RandomNumberGenerator" ]);
                    ("describeConnection", [ "RandomNumberGenerator" ]);
                    ("ScriptedSessions", [ "RandomNumberGenerator" ]);
                    ("TestSessionOptions", [ "RandomNumberGenerator" ]);
                  ] );
                ( "csharp",
                  [
                    ("XynologClient", [ "Random" ]);
                    ("HttpTransport", [ "Random" ]);
                    ("Issuer", [ "Random" ]);
                    ("ServiceToken", [ "Random" ]);
                    ("FromKeptAsync", [ "Random" ]);
                    ("SignInStore", [ "Random" ]);
                    ("HttpSessionFactory", [ "Random" ]);
                    ("XynologBrowserConfig", [ "Random" ]);
                    ("TestSessionOptions", [ "Random" ]);
                    ("ScriptedSessions", [ "Random" ]);
                    ("BeginAuthorizationAsync", [ "Random" ]);
                    ("CompleteAuthorizationAsync", [ "Random" ]);
                    ("DescribeConnectionAsync", [ "Random" ]);
                    ("RetryWithBackoffAsync", [ "Random" ]);
                  ] );
                ( "haskell",
                  [
                    ("newHttpTransport", [ "HttpOptions" ]);
                    ("HttpOptions", [ "RetryOptions" ]);
                    ("fromHttp", [ "HttpOptions" ]);
                    ("retryWithBackoff", [ "RetryOptions" ]);
                    ("newSession", [ "RetryOptions" ]);
                    ("fromIssuedSession", [ "HttpOptions" ]);
                    ("signInDevice", [ "HttpOptions" ]);
                    ("IssuerOptions", [ "RetryOptions" ]);
                    ("newServiceTokenSecret", [ "IssuerOptions" ]);
                    ("newServiceTokenKey", [ "IssuerOptions" ]);
                    ("signInAgent", [ "HttpOptions" ]);
                    ("fromKeptSession", [ "HttpOptions" ]);
                    ("newHttpSessionFactory", [ "HttpOptions" ]);
                    ("XynologBrowserConfig", [ "HttpOptions" ]);
                    ("describeConnection", [ "HttpOptions" ]);
                  ] );
              ];
          }
           : clock_item);
       ];
   }
    : t)
