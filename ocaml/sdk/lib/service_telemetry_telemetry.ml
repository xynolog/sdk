(* Generated from protocol/specs/src/service-telemetry/telemetry.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type services_item =
  | Archivist
  | Dispatcher
  | Gateway
  | Librarian
  | Smelter
  | Weaver
  | Worker

let services_item_value = function
  | (Archivist : services_item) -> "archivist"
  | (Dispatcher : services_item) -> "dispatcher"
  | (Gateway : services_item) -> "gateway"
  | (Librarian : services_item) -> "librarian"
  | (Smelter : services_item) -> "smelter"
  | (Weaver : services_item) -> "weaver"
  | (Worker : services_item) -> "worker"

let services_item_json v = `String (services_item_value v)

type resource_item = {
  key : string;
  services : services_item list;
  meaning : string;
  default : string option;
}

let resource_item_json (r : resource_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("key", (fun s -> `String s) r.key);
         Option.Some
           ( "services",
             (fun l -> `List (List.map services_item_json l)) r.services );
         Option.Some ("meaning", (fun s -> `String s) r.meaning);
         Option.map (fun v -> ("default", (fun s -> `String s) v)) r.default;
       ])

type kind = Client | Consumer | Internal | Producer | Server

let kind_value = function
  | (Client : kind) -> "client"
  | (Consumer : kind) -> "consumer"
  | (Internal : kind) -> "internal"
  | (Producer : kind) -> "producer"
  | (Server : kind) -> "server"

let kind_json v = `String (kind_value v)

type when_ = Export | Traffic | Supervised | Fatal

let when__value = function
  | (Export : when_) -> "export"
  | (Traffic : when_) -> "traffic"
  | (Supervised : when_) -> "supervised"
  | (Fatal : when_) -> "fatal"

let when__json v = `String (when__value v)

type values_item = String of string | Boolean of bool

let values_item_json = function
  | (String v : values_item) -> (fun s -> `String s) v
  | (Boolean v : values_item) -> (fun b -> `Bool b) v

type attributes_item = {
  key : string;
  only : string option;
  values : values_item list option;
}

let attributes_item_json (r : attributes_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("key", (fun s -> `String s) r.key);
         Option.map (fun v -> ("only", (fun s -> `String s) v)) r.only;
         Option.map
           (fun v ->
             ("values", (fun l -> `List (List.map values_item_json l)) v))
           r.values;
       ])

type spans_item = {
  name : string;
  services : services_item list;
  kind : kind;
  when_ : when_;
  meaning : string;
  attributes : attributes_item list;
}

let spans_item_json (r : spans_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some
           ( "services",
             (fun l -> `List (List.map services_item_json l)) r.services );
         Option.Some ("kind", kind_json r.kind);
         Option.Some ("when", when__json r.when_);
         Option.Some ("meaning", (fun s -> `String s) r.meaning);
         Option.Some
           ( "attributes",
             (fun l -> `List (List.map attributes_item_json l)) r.attributes );
       ])

type instrument = Counter | Up_down_counter | Gauge | Histogram

let instrument_value = function
  | (Counter : instrument) -> "counter"
  | (Up_down_counter : instrument) -> "up-down counter"
  | (Gauge : instrument) -> "gauge"
  | (Histogram : instrument) -> "histogram"

let instrument_json v = `String (instrument_value v)

type gateway_config_type = In_process | Nats

let gateway_config_type_value = function
  | (In_process : gateway_config_type) -> "in-process"
  | (Nats : gateway_config_type) -> "nats"

let gateway_config_type_json v = `String (gateway_config_type_value v)

type metrics_item = {
  name : string;
  services : services_item list;
  instrument : instrument;
  when_ : when_;
  planes : gateway_config_type list option;
  meaning : string;
  attributes : attributes_item list;
}

let metrics_item_json (r : metrics_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some
           ( "services",
             (fun l -> `List (List.map services_item_json l)) r.services );
         Option.Some ("instrument", instrument_json r.instrument);
         Option.Some ("when", when__json r.when_);
         Option.map
           (fun v ->
             ("planes", (fun l -> `List (List.map gateway_config_type_json l)) v))
           r.planes;
         Option.Some ("meaning", (fun s -> `String s) r.meaning);
         Option.Some
           ( "attributes",
             (fun l -> `List (List.map attributes_item_json l)) r.attributes );
       ])

type t = {
  comment : string;
  sdk : (services_item * string list) list;
  resource : resource_item list;
  spans : spans_item list;
  metrics : metrics_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ( "sdk",
             (fun l ->
               `Assoc
                 (List.map
                    (fun (k, v) ->
                      ( services_item_value k,
                        (fun l -> `List (List.map (fun s -> `String s) l)) v ))
                    l))
               r.sdk );
         Option.Some
           ( "resource",
             (fun l -> `List (List.map resource_item_json l)) r.resource );
         Option.Some
           ("spans", (fun l -> `List (List.map spans_item_json l)) r.spans);
         Option.Some
           ("metrics", (fun l -> `List (List.map metrics_item_json l)) r.metrics);
       ])

let table : t =
  ({
     comment =
       "The telemetry each Xynolog service exports over OTLP, in any language: \
        every span and metric, the services that export it, its kind, and the \
        attributes it carries. A service exports the rows that list it and no \
        others. Each service's conformance suite holds it to this table from \
        outside, in both directions: every span and metric its observability \
        cases receive must be a row listing the service, of the listed kind, \
        carrying only listed attribute keys (and, where a row lists values, \
        only those values); and every row listing it whose `when` is `export` \
        or `traffic` must arrive, with every attribute not marked `only`. \
        `when`: `export` \226\128\148 whenever export is on; `traffic` \
        \226\128\148 once the service's observability cases' traffic has run; \
        `supervised` \226\128\148 only under the supervisor (SUPERVISE_EVENTS \
        and SUPERVISE_NAME set), checked by the environment cases; `fatal` \
        \226\128\148 only on a fatal error, which no case causes. `planes`, \
        where given, names the only signal planes a gateway row arrives on. \
        `sdk` names the services that reach the bus through an SDK, and for \
        each the SDK transports it uses, or, of a transport it uses part of, \
        the rows it exports, by name: such a service also exports the rows \
        specs/src/sdk-telemetry/telemetry.json lists for those transports, and \
        those rows, and its suite holds it to both tables as one. In a span \
        name, `{channel}` is the bus channel. `{jobType}` is the job's type. \
        Span kinds are OTLP's; a metric's `instrument` is `counter` (a \
        monotonic sum), `up-down counter` (a non-monotonic sum), `gauge` or \
        `histogram`. `resource` lists the attributes of the resource every \
        span and metric of a service is exported under, and the services that \
        carry each: a service's resource carries exactly the keys listed for \
        it.";
     sdk =
       [
         ((Dispatcher : services_item), [ "bus" ]);
         ((Archivist : services_item), [ "bus" ]);
         ( (Worker : services_item),
           [ "bus"; "content.put"; "content.get"; "content.get_anchored_text" ]
         );
         ((Weaver : services_item), [ "bus" ]);
         ((Smelter : services_item), [ "bus" ]);
         ((Librarian : services_item), [ "bus"; "content.get_anchored_text" ]);
       ];
     resource =
       [
         ({
            key = "service.name";
            services =
              [
                (Archivist : services_item);
                (Dispatcher : services_item);
                (Gateway : services_item);
                (Librarian : services_item);
                (Smelter : services_item);
                (Weaver : services_item);
                (Worker : services_item);
              ];
            meaning =
              "The service's name: what `OTEL_SERVICE_NAME` says, or, when it \
               is unset, `default` with `{service}` the service's name.";
            default = Some "xynolog-{service}";
          }
           : resource_item);
         ({
            key = "service.version";
            services =
              [
                (Archivist : services_item);
                (Dispatcher : services_item);
                (Gateway : services_item);
                (Librarian : services_item);
                (Smelter : services_item);
                (Weaver : services_item);
                (Worker : services_item);
              ];
            meaning = "The version of Xynolog the service was built as.";
            default = None;
          }
           : resource_item);
         ({
            key = "xynolog.kb";
            services =
              [
                (Gateway : services_item);
                (Dispatcher : services_item);
                (Archivist : services_item);
                (Librarian : services_item);
                (Smelter : services_item);
                (Weaver : services_item);
              ];
            meaning =
              "The DID of the knowledge base the service serves: `kb_did` of \
               its document's `kb.domain`, or, for the Archivist, which reads \
               what the knowledge base says of itself from its tree, of the \
               `site.domain` its committed `.xynolog/config.yaml` names. A \
               service that serves several knowledge bases names none in its \
               resource, and carries `xynolog.kb` instead on each span and \
               data point of its own rows that list it: the DID of the \
               knowledge base whose job the work was.";
            default = None;
          }
           : resource_item);
       ];
     spans =
       [
         ({
            name = "bus.dispatch:{channel}";
            services = [ (Gateway : services_item) ];
            kind = (Server : kind);
            when_ = (Traffic : when_);
            meaning =
              "An emit the gateway accepted, in the caller's trace when the \
               request carried one.";
            attributes =
              [
                ({ key = "bus.channel"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : spans_item);
         ({
            name = "sse.deliver:{channel}";
            services = [ (Gateway : services_item) ];
            kind = (Producer : kind);
            when_ = (Traffic : when_);
            meaning =
              "A correlated reply written to the stream of the client whose \
               request it answers.";
            attributes =
              [
                ({ key = "bus.channel"; only = None; values = None }
                  : attributes_item);
                ({ key = "bus.cid"; only = None; values = None }
                  : attributes_item);
                ({
                   key = "bus.scope";
                   only = Some "on a reply in a resource scope";
                   values = None;
                 }
                  : attributes_item);
              ];
          }
           : spans_item);
         ({
            name = "content.get.server";
            services = [ (Gateway : services_item) ];
            kind = (Server : kind);
            when_ = (Traffic : when_);
            meaning = "A read of a resource's bytes.";
            attributes =
              [
                ({ key = "resource.id"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : spans_item);
         ({
            name = "content.put.server";
            services = [ (Gateway : services_item) ];
            kind = (Server : kind);
            when_ = (Traffic : when_);
            meaning = "An upload.";
            attributes = [];
          }
           : spans_item);
         ({
            name = "archivist.resources.record";
            services = [ (Gateway : services_item) ];
            kind = (Client : kind);
            when_ = (Traffic : when_);
            meaning = "An upload forwarded to the Archivist.";
            attributes =
              [
                ({
                   key = "peer.service";
                   only = None;
                   values = Some [ (String "archivist" : values_item) ];
                 }
                  : attributes_item);
              ];
          }
           : spans_item);
         ({
            name = "archivist.resources.describe";
            services = [ (Gateway : services_item) ];
            kind = (Client : kind);
            when_ = (Traffic : when_);
            meaning = "A JSON-LD description asked of the Archivist.";
            attributes =
              [
                ({
                   key = "peer.service";
                   only = None;
                   values = Some [ (String "archivist" : values_item) ];
                 }
                  : attributes_item);
              ];
          }
           : spans_item);
         ({
            name = "archivist.resources.annotations";
            services = [ (Gateway : services_item) ];
            kind = (Client : kind);
            when_ = (Traffic : when_);
            meaning = "A resource's annotations asked of the Archivist.";
            attributes =
              [
                ({
                   key = "peer.service";
                   only = None;
                   values = Some [ (String "archivist" : values_item) ];
                 }
                  : attributes_item);
              ];
          }
           : spans_item);
         ({
            name = "archivist.resources.anchored_text";
            services = [ (Gateway : services_item) ];
            kind = (Client : kind);
            when_ = (Traffic : when_);
            meaning = "A resource's anchored text asked of the Archivist.";
            attributes =
              [
                ({
                   key = "peer.service";
                   only = None;
                   values = Some [ (String "archivist" : values_item) ];
                 }
                  : attributes_item);
              ];
          }
           : spans_item);
         ({
            name = "archivist.content.get";
            services = [ (Gateway : services_item) ];
            kind = (Client : kind);
            when_ = (Traffic : when_);
            meaning = "Bytes read from the Archivist.";
            attributes =
              [
                ({
                   key = "peer.service";
                   only = None;
                   values = Some [ (String "archivist" : values_item) ];
                 }
                  : attributes_item);
              ];
          }
           : spans_item);
         ({
            name = "archivist.events.replay";
            services = [ (Gateway : services_item) ];
            kind = (Client : kind);
            when_ = (Traffic : when_);
            meaning =
              "A scope's persisted events read from the Archivist for a replay.";
            attributes =
              [
                ({
                   key = "peer.service";
                   only = None;
                   values = Some [ (String "archivist" : values_item) ];
                 }
                  : attributes_item);
              ];
          }
           : spans_item);
         ({
            name = "job:{jobType}";
            services = [ (Worker : services_item) ];
            kind = (Consumer : kind);
            when_ = (Traffic : when_);
            meaning =
              "A job a worker held, from the claim that handed it over to its \
               conclusion.";
            attributes =
              [
                ({
                   key = "job.type";
                   only = None;
                   values =
                     Some
                       [
                         (String "mark" : values_item);
                         (String "yield" : values_item);
                       ];
                 }
                  : attributes_item);
                ({
                   key = "job.motivation";
                   only = Some "on a mark job";
                   values =
                     Some
                       [
                         (String "highlighting" : values_item);
                         (String "commenting" : values_item);
                         (String "assessing" : values_item);
                         (String "linking" : values_item);
                         (String "tagging" : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "job.id"; only = None; values = None }
                  : attributes_item);
                ({ key = "resource.id"; only = None; values = None }
                  : attributes_item);
                ({ key = "xynolog.kb"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : spans_item);
         ({
            name = "detection:prepare";
            services = [ (Worker : services_item) ];
            kind = (Internal : kind);
            when_ = (Traffic : when_);
            meaning =
              "A mark job's reading of its resource: the description's media \
               type, and the text read by it.";
            attributes =
              [
                ({ key = "resource.id"; only = None; values = None }
                  : attributes_item);
                ({ key = "media.type"; only = None; values = None }
                  : attributes_item);
                ({ key = "xynolog.kb"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : spans_item);
         ({
            name = "inference:structured";
            services = [ (Worker : services_item) ];
            kind = (Internal : kind);
            when_ = (Traffic : when_);
            meaning =
              "One generation a worker asked of its provider for an array of \
               objects, from the request to its answer or its time bound.";
            attributes =
              [
                ({
                   key = "inference.provider";
                   only = None;
                   values =
                     Some
                       [
                         (String "anthropic" : values_item);
                         (String "google" : values_item);
                         (String "llamacpp" : values_item);
                         (String "ollama" : values_item);
                         (String "openai" : values_item);
                         (String "together" : values_item);
                         (String "vllm" : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "inference.model"; only = None; values = None }
                  : attributes_item);
                ({ key = "inference.max_tokens"; only = None; values = None }
                  : attributes_item);
                ({ key = "xynolog.kb"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : spans_item);
         ({
            name = "inference:text";
            services = [ (Worker : services_item) ];
            kind = (Internal : kind);
            when_ = (Traffic : when_);
            meaning =
              "One generation a worker asked of its provider for text, from \
               the request to its answer or its time bound.";
            attributes =
              [
                ({
                   key = "inference.provider";
                   only = None;
                   values =
                     Some
                       [
                         (String "anthropic" : values_item);
                         (String "google" : values_item);
                         (String "llamacpp" : values_item);
                         (String "ollama" : values_item);
                         (String "openai" : values_item);
                         (String "together" : values_item);
                         (String "vllm" : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "inference.model"; only = None; values = None }
                  : attributes_item);
                ({ key = "inference.max_tokens"; only = None; values = None }
                  : attributes_item);
                ({ key = "xynolog.kb"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : spans_item);
       ];
     metrics =
       [
         ({
            name = "xynolog.bus.emit";
            services = [ (Gateway : services_item) ];
            instrument = (Counter : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning = "Emits the gateway accepted.";
            attributes =
              [
                ({ key = "bus.channel"; only = None; values = None }
                  : attributes_item);
                ({
                   key = "bus.scope";
                   only = Some "on an emit in a resource scope";
                   values = None;
                 }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.bus.reply.suppressed";
            services = [ (Gateway : services_item) ];
            instrument = (Counter : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning =
              "Correlated replies withheld from a subscriber that did not ask \
               for them.";
            attributes =
              [
                ({ key = "bus.channel"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.bus.resume_gap";
            services = [ (Gateway : services_item) ];
            instrument = (Counter : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning = "Resumes answered with a gap, by the gap's reason.";
            attributes =
              [
                ({ key = "bus.resume_gap.reason"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.bus.unanswerable";
            services = [ (Gateway : services_item) ];
            instrument = (Counter : instrument);
            when_ = (Traffic : when_);
            planes = Some [ (In_process : gateway_config_type) ];
            meaning =
              "Requests no participant could answer; only a plane that can \
               count subscribers counts them.";
            attributes =
              [
                ({ key = "bus.channel"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.sse.subscribers";
            services = [ (Gateway : services_item) ];
            instrument = (Up_down_counter : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning = "Open bus streams.";
            attributes = [];
          }
           : metrics_item);
         ({
            name = "xynolog.gateway.refused";
            services = [ (Gateway : services_item) ];
            instrument = (Counter : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning =
              "Requests a limit refused \226\128\148 a principal's streams or \
               emit bucket, a client's unanswered requests, the process's \
               queued bytes, the requests a holder has had refused \
               \226\128\148 and connections closed at its connection cap.";
            attributes =
              [
                ({
                   key = "refused.reason";
                   only = None;
                   values =
                     Some
                       [
                         (String "streams" : values_item);
                         (String "emit-rate" : values_item);
                         (String "unanswered-requests" : values_item);
                         (String "capacity" : values_item);
                         (String "refusal-rate" : values_item);
                         (String "connections" : values_item);
                       ];
                 }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.gateway.unauthenticated";
            services = [ (Gateway : services_item) ];
            instrument = (Counter : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning =
              "Requests answered 401, by why: no bearer token, a bearer token \
               refused, a media token refused.";
            attributes =
              [
                ({
                   key = "unauthenticated.reason";
                   only = None;
                   values =
                     Some
                       [
                         (String "missing_token" : values_item);
                         (String "invalid_token" : values_item);
                         (String "invalid_media_token" : values_item);
                       ];
                 }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.bus.correlation.size";
            services = [ (Gateway : services_item) ];
            instrument = (Gauge : instrument);
            when_ = (Export : when_);
            planes = None;
            meaning = "Outstanding request claims, and the cap on them.";
            attributes =
              [
                ({
                   key = "correlation.kind";
                   only = None;
                   values =
                     Some
                       [
                         (String "claims" : values_item);
                         (String "claims_max" : values_item);
                       ];
                 }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.process.start_time";
            services =
              [
                (Gateway : services_item);
                (Dispatcher : services_item);
                (Archivist : services_item);
                (Worker : services_item);
                (Weaver : services_item);
                (Smelter : services_item);
                (Librarian : services_item);
              ];
            instrument = (Gauge : instrument);
            when_ = (Export : when_);
            planes = None;
            meaning = "When the process started.";
            attributes = [];
          }
           : metrics_item);
         ({
            name = "xynolog.runtime.event_loop.lag";
            services =
              [
                (Gateway : services_item);
                (Dispatcher : services_item);
                (Archivist : services_item);
                (Worker : services_item);
                (Weaver : services_item);
                (Smelter : services_item);
                (Librarian : services_item);
              ];
            instrument = (Gauge : instrument);
            when_ = (Export : when_);
            planes = None;
            meaning =
              "Time the process could not serve anything, over the last export \
               interval.";
            attributes =
              [
                ({
                   key = "lag.stat";
                   only = None;
                   values =
                     Some
                       [
                         (String "mean" : values_item);
                         (String "p99" : values_item);
                         (String "max" : values_item);
                       ];
                 }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.runtime.heap";
            services =
              [
                (Gateway : services_item);
                (Dispatcher : services_item);
                (Archivist : services_item);
                (Worker : services_item);
                (Weaver : services_item);
                (Smelter : services_item);
                (Librarian : services_item);
              ];
            instrument = (Gauge : instrument);
            when_ = (Export : when_);
            planes = None;
            meaning = "Memory in use, allocated, allowed, and resident.";
            attributes =
              [
                ({
                   key = "heap.stat";
                   only = None;
                   values =
                     Some
                       [
                         (String "used" : values_item);
                         (String "total" : values_item);
                         (String "limit" : values_item);
                         (String "rss" : values_item);
                       ];
                 }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.process.restarts";
            services =
              [
                (Gateway : services_item);
                (Dispatcher : services_item);
                (Archivist : services_item);
                (Worker : services_item);
                (Weaver : services_item);
                (Smelter : services_item);
                (Librarian : services_item);
              ];
            instrument = (Gauge : instrument);
            when_ = (Supervised : when_);
            planes = None;
            meaning = "Lives the supervisor recorded, less one.";
            attributes = [];
          }
           : metrics_item);
         ({
            name = "xynolog.process.abnormal_exit";
            services =
              [
                (Gateway : services_item);
                (Dispatcher : services_item);
                (Archivist : services_item);
                (Worker : services_item);
                (Weaver : services_item);
                (Smelter : services_item);
                (Librarian : services_item);
              ];
            instrument = (Counter : instrument);
            when_ = (Fatal : when_);
            planes = None;
            meaning = "A fatal error, just before the process exits.";
            attributes =
              [
                ({
                   key = "reason";
                   only = None;
                   values =
                     Some
                       [
                         (String "uncaughtException" : values_item);
                         (String "unhandledRejection" : values_item);
                       ];
                 }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.job.queue.size";
            services = [ (Dispatcher : services_item) ];
            instrument = (Gauge : instrument);
            when_ = (Export : when_);
            planes = None;
            meaning = "The jobs in the queue, by status.";
            attributes =
              [
                ({
                   key = "job.status";
                   only = None;
                   values =
                     Some
                       [
                         (String "pending" : values_item);
                         (String "running" : values_item);
                         (String "complete" : values_item);
                         (String "failed" : values_item);
                         (String "cancelled" : values_item);
                       ];
                 }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.vector.index.size";
            services = [ (Smelter : services_item) ];
            instrument = (Gauge : instrument);
            when_ = (Export : when_);
            planes = None;
            meaning =
              "Points the vector index holds, of resources and of annotations \
               together.";
            attributes = [];
          }
           : metrics_item);
         ({
            name = "xynolog.archivist.fact_pump.depth";
            services = [ (Archivist : services_item) ];
            instrument = (Gauge : instrument);
            when_ = (Export : when_);
            planes = None;
            meaning =
              "Events appended to the record and not yet published on the bus. \
               Zero at rest; a rising floor means publishing is behind its \
               transport.";
            attributes = [];
          }
           : metrics_item);
         ({
            name = "xynolog.git.duration";
            services = [ (Archivist : services_item) ];
            instrument = (Histogram : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning =
              "How long each git command the staging driver ran took, in \
               milliseconds, the failing ones too.";
            attributes =
              [
                ({
                   key = "git.command";
                   only = None;
                   values =
                     Some
                       [
                         (String "add" : values_item);
                         (String "rm" : values_item);
                         (String "rev-parse" : values_item);
                       ];
                 }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.git.staging.failures";
            services = [ (Archivist : services_item) ];
            instrument = (Counter : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning =
              "Staging degradations: changes recorded and not staged, by why.";
            attributes =
              [
                ({
                   key = "reason";
                   only = None;
                   values =
                     Some
                       [
                         (String "index-lock" : values_item);
                         (String "other" : values_item);
                       ];
                 }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.job.outcome";
            services = [ (Worker : services_item) ];
            instrument = (Counter : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning = "The jobs a worker concluded, by how.";
            attributes =
              [
                ({
                   key = "job.type";
                   only = None;
                   values =
                     Some
                       [
                         (String "mark" : values_item);
                         (String "yield" : values_item);
                       ];
                 }
                  : attributes_item);
                ({
                   key = "job.motivation";
                   only = Some "on a mark job";
                   values =
                     Some
                       [
                         (String "highlighting" : values_item);
                         (String "commenting" : values_item);
                         (String "assessing" : values_item);
                         (String "linking" : values_item);
                         (String "tagging" : values_item);
                       ];
                 }
                  : attributes_item);
                ({
                   key = "job.outcome";
                   only = None;
                   values =
                     Some
                       [
                         (String "completed" : values_item);
                         (String "failed" : values_item);
                         (String "cancelled" : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "xynolog.kb"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.job.duration";
            services = [ (Worker : services_item) ];
            instrument = (Histogram : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning = "How long a worker held a job, in milliseconds.";
            attributes =
              [
                ({
                   key = "job.type";
                   only = None;
                   values =
                     Some
                       [
                         (String "mark" : values_item);
                         (String "yield" : values_item);
                       ];
                 }
                  : attributes_item);
                ({
                   key = "job.motivation";
                   only = Some "on a mark job";
                   values =
                     Some
                       [
                         (String "highlighting" : values_item);
                         (String "commenting" : values_item);
                         (String "assessing" : values_item);
                         (String "linking" : values_item);
                         (String "tagging" : values_item);
                       ];
                 }
                  : attributes_item);
                ({
                   key = "job.outcome";
                   only = None;
                   values =
                     Some
                       [
                         (String "completed" : values_item);
                         (String "failed" : values_item);
                         (String "cancelled" : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "xynolog.kb"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.inference.calls";
            services = [ (Worker : services_item); (Librarian : services_item) ];
            instrument = (Counter : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning =
              "The generations a service asked of its providers, by how each \
               ended.";
            attributes =
              [
                ({
                   key = "inference.provider";
                   only = None;
                   values =
                     Some
                       [
                         (String "anthropic" : values_item);
                         (String "google" : values_item);
                         (String "llamacpp" : values_item);
                         (String "ollama" : values_item);
                         (String "openai" : values_item);
                         (String "together" : values_item);
                         (String "vllm" : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "inference.model"; only = None; values = None }
                  : attributes_item);
                ({
                   key = "inference.outcome";
                   only = None;
                   values =
                     Some
                       [
                         (String "success" : values_item);
                         (String "error" : values_item);
                       ];
                 }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.inference.duration";
            services = [ (Worker : services_item); (Librarian : services_item) ];
            instrument = (Histogram : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning =
              "How long each generation took, in milliseconds, the failing \
               ones too.";
            attributes =
              [
                ({
                   key = "inference.provider";
                   only = None;
                   values =
                     Some
                       [
                         (String "anthropic" : values_item);
                         (String "google" : values_item);
                         (String "llamacpp" : values_item);
                         (String "ollama" : values_item);
                         (String "openai" : values_item);
                         (String "together" : values_item);
                         (String "vllm" : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "inference.model"; only = None; values = None }
                  : attributes_item);
                ({
                   key = "inference.outcome";
                   only = None;
                   values =
                     Some
                       [
                         (String "success" : values_item);
                         (String "error" : values_item);
                       ];
                 }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.inference.tokens";
            services = [ (Worker : services_item); (Librarian : services_item) ];
            instrument = (Counter : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning =
              "The tokens a provider reported for a generation, read and \
               written. A generation whose provider reports none adds nothing.";
            attributes =
              [
                ({
                   key = "inference.provider";
                   only = None;
                   values =
                     Some
                       [
                         (String "anthropic" : values_item);
                         (String "google" : values_item);
                         (String "llamacpp" : values_item);
                         (String "ollama" : values_item);
                         (String "openai" : values_item);
                         (String "together" : values_item);
                         (String "vllm" : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "inference.model"; only = None; values = None }
                  : attributes_item);
                ({
                   key = "inference.direction";
                   only = None;
                   values =
                     Some
                       [
                         (String "input" : values_item);
                         (String "output" : values_item);
                       ];
                 }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.detection.calls";
            services = [ (Worker : services_item) ];
            instrument = (Counter : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning =
              "The generations a mark job made, by what asked, how each ended, \
               how many times its piece had been halved, and whether it was \
               the second asking of a piece too small to halve.";
            attributes =
              [
                ({
                   key = "detection.label";
                   only = None;
                   values =
                     Some
                       [
                         (String "highlight" : values_item);
                         (String "comment" : values_item);
                         (String "assessment" : values_item);
                         (String "tag" : values_item);
                         (String "reference" : values_item);
                       ];
                 }
                  : attributes_item);
                ({
                   key = "detection.outcome";
                   only = None;
                   values =
                     Some
                       [
                         (String "success" : values_item);
                         (String "truncated" : values_item);
                         (String "timeout" : values_item);
                         (String "collapsed" : values_item);
                         (String "error" : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "detection.depth"; only = None; values = None }
                  : attributes_item);
                ({
                   key = "detection.reroll";
                   only = None;
                   values =
                     Some
                       [
                         (Boolean true : values_item);
                         (Boolean false : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "xynolog.kb"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.detection.call.duration";
            services = [ (Worker : services_item) ];
            instrument = (Histogram : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning =
              "How long each of those generations took, in milliseconds, the \
               failing ones too.";
            attributes =
              [
                ({
                   key = "detection.label";
                   only = None;
                   values =
                     Some
                       [
                         (String "highlight" : values_item);
                         (String "comment" : values_item);
                         (String "assessment" : values_item);
                         (String "tag" : values_item);
                         (String "reference" : values_item);
                       ];
                 }
                  : attributes_item);
                ({
                   key = "detection.outcome";
                   only = None;
                   values =
                     Some
                       [
                         (String "success" : values_item);
                         (String "truncated" : values_item);
                         (String "timeout" : values_item);
                         (String "collapsed" : values_item);
                         (String "error" : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "detection.depth"; only = None; values = None }
                  : attributes_item);
                ({
                   key = "detection.reroll";
                   only = None;
                   values =
                     Some
                       [
                         (Boolean true : values_item);
                         (Boolean false : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "xynolog.kb"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.detection.call.items";
            services = [ (Worker : services_item) ];
            instrument = (Histogram : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning =
              "The proposals each of those generations returned; none, for one \
               that failed.";
            attributes =
              [
                ({
                   key = "detection.label";
                   only = None;
                   values =
                     Some
                       [
                         (String "highlight" : values_item);
                         (String "comment" : values_item);
                         (String "assessment" : values_item);
                         (String "tag" : values_item);
                         (String "reference" : values_item);
                       ];
                 }
                  : attributes_item);
                ({
                   key = "detection.outcome";
                   only = None;
                   values =
                     Some
                       [
                         (String "success" : values_item);
                         (String "truncated" : values_item);
                         (String "timeout" : values_item);
                         (String "collapsed" : values_item);
                         (String "error" : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "detection.depth"; only = None; values = None }
                  : attributes_item);
                ({
                   key = "detection.reroll";
                   only = None;
                   values =
                     Some
                       [
                         (Boolean true : values_item);
                         (Boolean false : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "xynolog.kb"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.detection.call.tokens";
            services = [ (Worker : services_item) ];
            instrument = (Histogram : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning =
              "The tokens a provider reported for each of those generations, \
               read and written. A generation whose provider reports none adds \
               nothing.";
            attributes =
              [
                ({
                   key = "detection.label";
                   only = None;
                   values =
                     Some
                       [
                         (String "highlight" : values_item);
                         (String "comment" : values_item);
                         (String "assessment" : values_item);
                         (String "tag" : values_item);
                         (String "reference" : values_item);
                       ];
                 }
                  : attributes_item);
                ({
                   key = "detection.outcome";
                   only = None;
                   values =
                     Some
                       [
                         (String "success" : values_item);
                         (String "truncated" : values_item);
                         (String "timeout" : values_item);
                         (String "collapsed" : values_item);
                         (String "error" : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "detection.depth"; only = None; values = None }
                  : attributes_item);
                ({
                   key = "detection.reroll";
                   only = None;
                   values =
                     Some
                       [
                         (Boolean true : values_item);
                         (Boolean false : values_item);
                       ];
                 }
                  : attributes_item);
                ({
                   key = "detection.direction";
                   only = None;
                   values =
                     Some
                       [
                         (String "input" : values_item);
                         (String "output" : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "xynolog.kb"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.detection.anchors";
            services = [ (Worker : services_item) ];
            instrument = (Counter : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning =
              "The spans a mark job anchored in its text, by how each was \
               found.";
            attributes =
              [
                ({
                   key = "detection.label";
                   only = None;
                   values =
                     Some
                       [
                         (String "highlight" : values_item);
                         (String "comment" : values_item);
                         (String "assessment" : values_item);
                         (String "tag" : values_item);
                         (String "reference" : values_item);
                       ];
                 }
                  : attributes_item);
                ({
                   key = "anchor.method";
                   only = None;
                   values =
                     Some
                       [
                         (String "unique-match" : values_item);
                         (String "context-recovered" : values_item);
                         (String "first-of-many" : values_item);
                         (String "fuzzy-match" : values_item);
                       ];
                 }
                  : attributes_item);
                ({ key = "xynolog.kb"; only = None; values = None }
                  : attributes_item);
              ];
          }
           : metrics_item);
         ({
            name = "xynolog.gather.degraded";
            services = [ (Librarian : services_item) ];
            instrument = (Counter : instrument);
            when_ = (Traffic : when_);
            planes = None;
            meaning =
              "Gathers that went without something, by what each went without: \
               the graph, which did not come to hold the resource; the vector \
               index, which failed or did not settle in time; or what a model \
               failed to give, which is the summary and suggestions of a \
               resource, the summary of the resource an annotation links to, \
               or the relationship sentence.";
            attributes =
              [
                ({
                   key = "projection";
                   only = None;
                   values =
                     Some
                       [
                         (String "graph" : values_item);
                         (String "vectors" : values_item);
                         (String "suggestions" : values_item);
                         (String "summary" : values_item);
                         (String "relationship" : values_item);
                       ];
                 }
                  : attributes_item);
              ];
          }
           : metrics_item);
       ];
   }
    : t)
