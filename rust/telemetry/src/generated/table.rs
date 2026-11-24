// Generated from protocol/specs/src/sdk-telemetry/telemetry.json; do not edit.
// Regenerate: make generate (codegen/lib/telemetry/telemetry.ml)
/// What stands for the bus channel in a span's name.
pub const CHANNEL: &str = "{channel}";
/// A frame the client sent, in the trace of the work that sent it.
pub const SPAN_BUS_EMIT: &str = "bus.emit:{channel}";
/// A frame the client received, and the work done for it, in the trace the frame was sent under.
pub const SPAN_BUS_RECV: &str = "bus.recv:{channel}";
/// An upload.
pub const SPAN_CONTENT_PUT: &str = "content.put";
/// A read of a resource's bytes.
pub const SPAN_CONTENT_GET: &str = "content.get";
/// A read of a resource's description.
pub const SPAN_CONTENT_GET_GRAPH: &str = "content.get_graph";
/// A read of a resource's anchored text.
pub const SPAN_CONTENT_GET_ANCHORED_TEXT: &str = "content.get_anchored_text";
/// A read of a resource's annotations.
pub const SPAN_CONTENT_GET_ANNOTATIONS: &str = "content.get_annotations";
/// Emits the client sent.
pub const METRIC_XYNOLOG_BUS_SENT: &str = "xynolog.bus.sent";
/// An attribute key a row of the telemetry table lists.
pub const ATTR_BUS_CHANNEL: &str = "bus.channel";
/// An attribute key a row of the telemetry table lists.
pub const ATTR_BUS_SCOPE: &str = "bus.scope";
/// An attribute key a row of the telemetry table lists.
pub const ATTR_CONTENT_FORMAT: &str = "content.format";
/// An attribute key a row of the telemetry table lists.
pub const ATTR_CONTENT_SIZE_BYTES: &str = "content.size_bytes";
/// An attribute key a row of the telemetry table lists.
pub const ATTR_CONTENT_STREAM: &str = "content.stream";
/// An attribute key a row of the telemetry table lists.
pub const ATTR_RESOURCE_ID: &str = "resource.id";
/// An attribute key a row of the telemetry table lists.
pub const ATTR_THREAD_ID: &str = "thread.id";
