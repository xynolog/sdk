import Foundation
import OpenTelemetryApi

struct TraceMap: Getter, Setter {
  func get(carrier: [String: String], key: String) -> [String]? { carrier[key].map { [$0] } }
  func set(carrier: inout [String: String], key: String, value: String) { carrier[key] = value }
}
func transportSpan(
  _ role: TransportSpan, channel: String? = nil, scope: ResourceId? = nil,
  attributes: [String: AttributeValue] = [:], parent: [String: String]? = nil
) -> any Span {
  guard let row = telemetrySpans.first(where: { $0.name == role.rawValue }),
    let kind = SpanKind(rawValue: row.kind)
  else {
    preconditionFailure("Unsupported telemetry span \(role)")
  }
  let name: String
  if let channel {
    name = role.rawValue.replacingOccurrences(of: "{channel}", with: channel)
  } else {
    precondition(!role.rawValue.contains("{channel}"), "A bus span needs its channel")
    name = role.rawValue
  }
  let builder = OpenTelemetry.instance.tracerProvider.get(instrumentationName: "Xynolog")
    .spanBuilder(spanName: name)
    .setSpanKind(spanKind: kind)
  if let parent {
    if let context = OpenTelemetry.instance.propagators.textMapPropagator.extract(
      carrier: parent, getter: TraceMap())
    {
      builder.setParent(context)
    } else {
      builder.setNoParent()
    }
  }
  if let channel { builder.setAttribute(key: attributeBusChannel, value: channel) }
  if let scope { builder.setAttribute(key: attributeBusScope, value: scope.value) }
  for (key, value) in attributes { builder.setAttribute(key: key, value: value) }
  return builder.startSpan()
}

/// `carried`'s members by their wire names, as the propagator reads a carrier.
func propagated(_ carried: TraceCarrier) -> [String: String] {
  do {
    return try JSONDecoder().decode(
      [String: String].self, from: JSONEncoder().encode(carried))
  } catch {
    preconditionFailure("A TraceCarrier is members of text: \(error)")
  }
}

func traceCarrier(_ span: any Span) -> [String: String] {
  var fields: [String: String] = [:]
  OpenTelemetry.instance.propagators.textMapPropagator.inject(
    spanContext: span.context, carrier: &fields, setter: TraceMap())
  return fields
}

extension HttpTransport {
  func sent(channel: String, scope: ResourceId?) {
    if sentCounter == nil {
      sentCounter = OpenTelemetry.instance.meterProvider.get(name: "Xynolog").counterBuilder(
        name: TransportMetric.xynologBusSent.rawValue
      ).build()
    }
    var attributes: [String: AttributeValue] = [attributeBusChannel: .string(channel)]
    if let scope { attributes[attributeBusScope] = .string(scope.value) }
    sentCounter?.add(value: 1, attributes: attributes)
  }
}

actor StreamingReadTrace {
  private let span: any Span
  init(_ resource: ResourceId) {
    span = transportSpan(
      .contentGet,
      attributes: [
        attributeResourceId: .string(resource.value), attributeContentStream: .bool(true),
      ])
  }
  func headers() -> [String: String] { traceCarrier(span) }
  func end() { span.end() }
}
