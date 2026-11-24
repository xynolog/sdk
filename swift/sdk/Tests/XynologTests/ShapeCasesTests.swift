import Foundation
import Testing

@testable import Xynolog

// The reading of a value, held to protocol/specs/src/client/shape-cases.json, the table every
// SDK's reading of a value runs. Each case's value is held to the schema it names, and its first
// fault is the one the case states, or none.

@Test func everyValueHasTheFirstFaultItsCaseStates() throws {
  let cases = try required(Spec.read("client/shape-cases.json").object, "cases").array
  #expect(!cases.isEmpty, "shape-cases.json states no case")
  for value in cases {
    let row = try value.object
    let why = try required(row, "why").text
    let schema = try required(row, "schema").text
    try #require(requiredSchemas[schema] != nil, "the table has no schema \(schema): \(why)")
    var stated: Fault?
    if row["refused"] == .bool(true) {
      let reason = try required(row, "reason").text
      stated = Fault(
        member: try required(row, "member").text,
        reason: try #require(FrameRefusalReason(rawValue: reason), "no reason is \(reason)"))
    }
    #expect(faultOf(schema, try required(row, "value")) == stated, "\(why)")
  }
}
