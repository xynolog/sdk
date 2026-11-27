import Xynolog

// A case's `timing`, whose rows a driver reads by name into the records it builds: a name none of
// them holds is the suite's mistake.

extension Dictionary where Key == String, Value == JSONValue {
  /// The rows `timing` states: none when it is not stated.
  func timingRows() throws -> [String: JSONValue] {
    self["timing"] == nil ? [:] : try object("timing")
  }
  /// A whole number that is not negative.
  func amount(_ key: String) throws -> Int {
    let amount = try integer(key)
    guard amount >= 0 else { throw Misuse(description: "\(key) must not be negative") }
    return amount
  }
}

extension TransportTiming {
  /// Sets the row `name` as `rows` states it.
  mutating func set(_ name: String, from rows: [String: JSONValue]) throws {
    switch name {
    case "emitRetry":
      let budget = try rows.object(name)
      emitRetry = RetryBudget(
        attempts: try budget.amount("attempts"),
        initialDelayMs: try budget.amount("initialDelayMs"),
        maxDelayMs: try budget.amount("maxDelayMs"))
    case "httpRequestTimeoutMs": httpRequestTimeoutMs = try rows.amount(name)
    case "streamOpenTimeoutMs": streamOpenTimeoutMs = try rows.amount(name)
    case "reconnectMs": reconnectMs = try rows.amount(name)
    case "lingerMs": lingerMs = try rows.amount(name)
    case "seenEventIdsCount": seenEventIdsCount = try rows.amount(name)
    case "lazyRemoveMs": lazyRemoveMs = try rows.amount(name)
    default: throw Misuse(description: "Unknown timing override \(name)")
    }
  }
}

/// The client's and its transport's timing with each of `rows`.
func timings(_ rows: [String: JSONValue]) throws -> (
  client: ClientTiming, transport: TransportTiming
) {
  var client = ClientTiming()
  var transport = TransportTiming()
  for name in rows.keys {
    switch name {
    case "busRequestTimeoutMs": client.busRequestTimeoutMs = try rows.amount(name)
    case "invalidationWindowMs": client.invalidationWindowMs = try rows.amount(name)
    case "jobSilenceMs": client.jobSilenceMs = try rows.amount(name)
    case "jobStatusPollMs": client.jobStatusPollMs = try rows.amount(name)
    default: try transport.set(name, from: rows)
    }
  }
  return (client, transport)
}
