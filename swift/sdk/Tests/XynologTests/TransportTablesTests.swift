import Foundation
import Testing

@testable import Xynolog

@Test func busLogRunsEverySharedCase() throws {
  let table = try Spec.read("bus/log-cases.json").object
  for value in try required(table, "cases").array {
    let row = try value.object
    let payload = try required(row, "payload")
    #expect(shownOnBus(payload) == (try required(row, "shown")), "\(row["why"] ?? .null)")
    if let channel = row["channel"] {
      let registry = try required(Spec.read("bus/registry.json").object, "channels").array.map {
        try $0.object
      }
      let declared = try #require(registry.first { $0["channel"] == channel })
      var value = payload
      if declared["shape"] == .string("envelope") {
        value = try required(payload.object, "response")
      }
      _ = try roundTripModel(required(declared, "schema").text, value)
    }

  }
  for value in [
    JSONValue.null, .number(1), .bool(true), .string("token"), .array([.object(["token": .null])]),
  ] {
    #expect(shownOnBus(shownOnBus(value)) == shownOnBus(value))
  }
}
@Test func retryRunsEverySharedRuleAndHeader() throws {
  let table = try Spec.read("retry/cases.json").object
  var covered: Set<String> = []
  for value in try required(table, "rules").array {
    let row = try value.object
    let name = try required(row, "rule").text
    let rule = try #require(RetryContext(rawValue: name))
    covered.insert(name)
    let status: Int? = if case .number(let n) = row["status"] { Int(n) } else { nil }
    let method = try row["method"].map { try $0.text }
    let keyed: Bool =
      switch row["keyed"] {
      case nil: false
      case .bool(let stated): stated
      default: throw SpecFailure.shape("keyed is not a boolean")
      }
    let retries = rule.retryable(status: status, method: method, keyed: keyed)
    #expect(.bool(retries) == (try required(row, "retries")), "\(row["why"] ?? .null)")
  }
  #expect(covered == Set(RetryContext.allCases.map(\.rawValue)))
  for value in try required(table, "retryAfter").array {
    let row = try value.object
    let header: String? = if case .string(let text) = row["header"] { text } else { nil }
    let actual = retryAfterMs(header).map { JSONValue.number(Double($0)) } ?? .null
    #expect(actual == (try required(row, "ms")), "\(row["why"] ?? .null)")
  }
}
// retry/cases.json states the job rows from 500 to 504; these are the edges past them.
@Test func jobRetriesEveryServerFault() {
  #expect(RetryContext.job.retryable(status: 599, method: nil, keyed: false))
  #expect(!RetryContext.job.retryable(status: 499, method: nil, keyed: false))
  #expect(!RetryContext.job.retryable(status: nil, method: nil, keyed: false))
}
@Test func uploadMembersFollowTheMultipartSchema() throws {
  let request = PutBinaryRequest(
    name: "name", file: Data(), format: "text/plain", storageUri: "file:///text")
  let members = Set(Mirror(reflecting: request).children.compactMap(\.label))
  let schema = try Spec.read("components/schemas/ResourceUpload.json").object
  #expect(members == Set(try required(schema, "properties").object.keys))
}
