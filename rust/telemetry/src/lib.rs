//! The telemetry a Xynolog transport and a Xynolog service share, reported to
//! whatever OpenTelemetry the process installed: nothing here exports, and
//! with nothing installed no span is recorded and no trace context travels.
//!
//! A transport reports through one function per row of the SDK telemetry
//! table (protocol/specs/src/sdk-telemetry/telemetry.json): [`bus_emit`], which is
//! also the `xynolog.bus.sent` count, [`bus_recv`], [`content_put`],
//! [`content_get`], [`content_get_graph`], [`content_get_annotations`] and
//! [`content_get_anchored_text`].
//! It names no span, kind or attribute of its own: each is the table's, in
//! [`table`]. It puts [`active_trace`] on what it sends.
//!
//! A service's own spans are the service telemetry table's, which it states
//! itself over [`in_span`] and [`in_span_now`], continuing a caller's trace
//! with [`continued`] and a frame's with [`continuing`].
//!
//! The tracer, the meter and the propagator are taken from
//! `opentelemetry::global` at each use, so telemetry installed after a client
//! opened is reported to all the same.

#![forbid(unsafe_code)]
// A failure is a value its caller is given: outside the tests nothing
// unwraps one away.
#![cfg_attr(not(test), deny(clippy::unwrap_used, clippy::expect_used))]

use opentelemetry::context::FutureExt;
use opentelemetry::trace::{SpanKind, TraceContextExt, Tracer};
use opentelemetry::{Context, KeyValue, global};
use std::collections::HashMap;
use std::future::Future;
use xynolog::transport::TraceCarrier;

/// The SDK telemetry table's names: each span's, each metric's and each
/// attribute key's, generated from protocol/specs/src/sdk-telemetry/telemetry.json.
pub mod table {
    include!("generated/table.rs");
}

/// The instrumentation scope every span and count here is made under.
const SCOPE: &str = "xynolog";

// ── The SDK telemetry table ──────────────────────────────────────────────

/// `bus.emit:{channel}` and `xynolog.bus.sent`: an emit a client sent, counted
/// and run in a span of the trace that sent it.
pub async fn bus_emit<T>(channel: &str, scope: Option<&str>, send: impl Future<Output = T>) -> T {
    let attributes = on_the_bus(channel, scope);
    global::meter(SCOPE)
        .u64_counter(table::METRIC_XYNOLOG_BUS_SENT)
        .with_description("Emits sent")
        .build()
        .add(1, &attributes);
    in_span(
        table::SPAN_BUS_EMIT.replace(table::CHANNEL, channel),
        SpanKind::Producer,
        attributes,
        Context::current(),
        send,
    )
    .await
}

/// `bus.recv:{channel}`: a frame's arrival, in the trace it was sent under.
/// Answers the trace that what is done for the frame continues: the span's
/// own, or, when nothing records one, the one the frame came with.
pub fn bus_recv(
    channel: &str,
    scope: Option<&str>,
    sent_under: Option<TraceCarrier>,
) -> Option<TraceCarrier> {
    let parent = continued(
        sent_under.as_ref().map(|t| t.traceparent.as_str()),
        sent_under.as_ref().and_then(|t| t.tracestate.as_deref()),
    );
    in_span_now(
        table::SPAN_BUS_RECV.replace(table::CHANNEL, channel),
        SpanKind::Consumer,
        on_the_bus(channel, scope),
        &parent,
        active_trace,
    )
    .or(sent_under)
}

/// `content.put`: an upload.
pub async fn content_put<T>(format: &str, size_bytes: u64, upload: impl Future<Output = T>) -> T {
    in_span(
        table::SPAN_CONTENT_PUT.to_owned(),
        SpanKind::Client,
        vec![
            KeyValue::new(table::ATTR_CONTENT_FORMAT, format.to_owned()),
            KeyValue::new(
                table::ATTR_CONTENT_SIZE_BYTES,
                i64::try_from(size_bytes).unwrap_or(i64::MAX),
            ),
        ],
        Context::current(),
        upload,
    )
    .await
}

/// `content.get`: a read of a resource's bytes, whole or as a `stream`.
pub async fn content_get<T>(resource_id: &str, stream: bool, read: impl Future<Output = T>) -> T {
    let mut attributes = vec![KeyValue::new(
        table::ATTR_RESOURCE_ID,
        resource_id.to_owned(),
    )];
    if stream {
        attributes.push(KeyValue::new(table::ATTR_CONTENT_STREAM, true));
    }
    in_span(
        table::SPAN_CONTENT_GET.to_owned(),
        SpanKind::Client,
        attributes,
        Context::current(),
        read,
    )
    .await
}

/// `content.get_annotations`: a read of a resource's annotations.
pub async fn content_get_annotations<T>(resource_id: &str, read: impl Future<Output = T>) -> T {
    in_span(
        table::SPAN_CONTENT_GET_ANNOTATIONS.to_owned(),
        SpanKind::Client,
        vec![KeyValue::new(
            table::ATTR_RESOURCE_ID,
            resource_id.to_owned(),
        )],
        Context::current(),
        read,
    )
    .await
}

/// `content.get_graph`: a read of a resource's description.
pub async fn content_get_graph<T>(resource_id: &str, read: impl Future<Output = T>) -> T {
    in_span(
        table::SPAN_CONTENT_GET_GRAPH.to_owned(),
        SpanKind::Client,
        vec![KeyValue::new(
            table::ATTR_RESOURCE_ID,
            resource_id.to_owned(),
        )],
        Context::current(),
        read,
    )
    .await
}

/// `content.get_anchored_text`: a read of a resource's anchored text.
pub async fn content_get_anchored_text<T>(resource_id: &str, read: impl Future<Output = T>) -> T {
    in_span(
        table::SPAN_CONTENT_GET_ANCHORED_TEXT.to_owned(),
        SpanKind::Client,
        vec![KeyValue::new(
            table::ATTR_RESOURCE_ID,
            resource_id.to_owned(),
        )],
        Context::current(),
        read,
    )
    .await
}

/// What a span or a count of the bus carries: the channel, and the scope
/// when there is one.
pub fn on_the_bus(channel: &str, scope: Option<&str>) -> Vec<KeyValue> {
    let mut attributes = vec![KeyValue::new(table::ATTR_BUS_CHANNEL, channel.to_owned())];
    if let Some(scope) = scope {
        attributes.push(KeyValue::new(table::ATTR_BUS_SCOPE, scope.to_owned()));
    }
    attributes
}

// ── Trace context ────────────────────────────────────────────────────────

/// The W3C trace context a caller sent (`traceparent`, `tracestate`), as the
/// parent of what is done for it; the current context when it sent none, or
/// when the process installed no propagator.
pub fn continued(traceparent: Option<&str>, tracestate: Option<&str>) -> Context {
    let Some(traceparent) = traceparent else {
        return Context::current();
    };
    let mut carrier = HashMap::from([("traceparent".to_owned(), traceparent.to_owned())]);
    if let Some(state) = tracestate {
        carrier.insert("tracestate".to_owned(), state.to_owned());
    }
    global::get_text_map_propagator(|propagator| {
        propagator.extract_with_context(&Context::current(), &carrier)
    })
}

/// Run `work` in the trace a frame arrived in: what is done for it, and what
/// is sent in answer, belongs to the sender's trace.
pub async fn continuing<T>(trace: Option<&TraceCarrier>, work: impl Future<Output = T>) -> T {
    let context = continued(
        trace.map(|t| t.traceparent.as_str()),
        trace.and_then(|t| t.tracestate.as_deref()),
    );
    work.with_context(context).await
}

/// The active span's W3C trace context, when a span is active: what a
/// transport puts on what it sends.
pub fn active_trace() -> Option<TraceCarrier> {
    let context = Context::current();
    if !context.span().span_context().is_valid() {
        return None;
    }
    let mut carrier: HashMap<String, String> = HashMap::new();
    global::get_text_map_propagator(|propagator| {
        propagator.inject_context(&context, &mut carrier);
    });
    Some(TraceCarrier {
        traceparent: carrier.remove("traceparent")?,
        tracestate: carrier.remove("tracestate").filter(|s| !s.is_empty()),
    })
}

/// The active span's trace id, when a span is active: what the bus log's
/// `trace=` field reads (`xynolog::bus_log::set_trace_id_provider`).
pub fn active_trace_id() -> Option<String> {
    let context = Context::current();
    let span = context.span();
    let span_context = span.span_context();
    span_context
        .is_valid()
        .then(|| span_context.trace_id().to_string())
}

fn started(name: String, kind: SpanKind, attributes: Vec<KeyValue>, parent: &Context) -> Context {
    let tracer = global::tracer(SCOPE);
    let span = tracer
        .span_builder(name)
        .with_kind(kind)
        .with_attributes(attributes)
        .start_with_context(&tracer, parent);
    parent.with_span(span)
}

/// Run `work` in a span, a child of `parent`.
pub async fn in_span<T>(
    name: String,
    kind: SpanKind,
    attributes: Vec<KeyValue>,
    parent: Context,
    work: impl Future<Output = T>,
) -> T {
    let context = started(name, kind, attributes, &parent);
    let out = work.with_context(context.clone()).await;
    context.span().end();
    out
}

/// The same, for work that does not wait.
pub fn in_span_now<T>(
    name: String,
    kind: SpanKind,
    attributes: Vec<KeyValue>,
    parent: &Context,
    work: impl FnOnce() -> T,
) -> T {
    let context = started(name, kind, attributes, parent);
    let out = {
        let _attached = context.clone().attach();
        work()
    };
    context.span().end();
    out
}
