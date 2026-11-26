(* The telemetry as the Kotlin SDK's transports export it
   (xynolog.telemetry.TelemetryTable): each span with its kind, and each
   metric, by its name with [{channel}] dropped. [table] is one whose kinds
   and instruments [Telemetry.derive] holds; [from_] is its file; [keys]
   each attribute key, behind the name the SDK gives it. *)

module K = Kotlin_syntax
module T = Tables.Sdk_telemetry_telemetry

(* A row's constant: its name without what stands for the channel. *)
let constant name = Kotlin_sdk.Names.constant_name (Channel.without name)

let file ~from_ ~keys (table : T.t) =
  let taken = Hashtbl.create 32 in
  let row ~meaning ~type_ name args =
    let constant = constant name in
    if Hashtbl.mem taken constant then
      Kotlin_sdk.Names.refuse "the telemetry table: two rows would both be %s"
        constant;
    Hashtbl.replace taken constant ();
    K.property ~about:(K.Block meaning) ~type_:(K.Type type_)
      ~value:(K.Same_line (K.call (K.Name type_) (K.Str name :: args)))
      constant
  in
  Kotlin_sdk.table ~from_ __FILE__ ~package:"xynolog.telemetry"
    ~name:"TelemetryTable"
    ~imports:[ "io.opentelemetry.api.trace.SpanKind" ]
    (K.class_
       ~about:
         (K.Doc
            ("The telemetry a Xynolog SDK's transports export \
              (protocol/specs/src/" ^ from_
           ^ "). A span's name may hold `{channel}`, the bus channel."))
       ~visibility:K.Internal
       ~members:
         (List.map
            (fun (s : T.spans_item) ->
              row ~meaning:s.meaning ~type_:"SpanRow" s.name
                [
                  K.Member
                    ( K.Name "SpanKind",
                      String.uppercase_ascii
                        (T.service_telemetry_telemetry_kind_value s.kind) );
                ])
            table.spans
         @ List.map
             (fun (m : T.metrics_item) ->
               row ~meaning:m.meaning ~type_:"MetricRow" m.name
                 [ K.Str m.meaning ])
             table.metrics)
       K.Object "TelemetryTable"
    :: List.map
         (fun (name, k) ->
           K.property
             ~about:
               (K.Block "An attribute key a row of the telemetry table lists.")
             ~visibility:K.Internal ~const:true ~type_:(K.Type "String")
             ~value:(K.Same_line (K.Str k)) name)
         keys)
