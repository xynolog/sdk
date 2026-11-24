// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/sdk-telemetry/telemetry.json
// Regenerate:  make generate  (codegen/lib/telemetry/telemetry.ml)

/** What stands for the bus channel in a span's name. */
export const TELEMETRY_CHANNEL = '{channel}';

/** A frame the client sent, in the trace of the work that sent it. */
export const SPAN_BUS_EMIT = 'bus.emit:{channel}';

/** A frame the client received, and the work done for it, in the trace the frame was sent under. */
export const SPAN_BUS_RECV = 'bus.recv:{channel}';

/** An upload. */
export const SPAN_CONTENT_PUT = 'content.put';

/** A read of a resource's bytes. */
export const SPAN_CONTENT_GET = 'content.get';

/** A read of a resource's description. */
export const SPAN_CONTENT_GET_GRAPH = 'content.get_graph';

/** A read of a resource's anchored text. */
export const SPAN_CONTENT_GET_ANCHORED_TEXT = 'content.get_anchored_text';

/** A read of a resource's annotations. */
export const SPAN_CONTENT_GET_ANNOTATIONS = 'content.get_annotations';

/** Emits the client sent. */
export const METRIC_XYNOLOG_BUS_SENT = 'xynolog.bus.sent';
