import Foundation

public struct TransportError: Error, Sendable, CustomStringConvertible {
  public let reason: TransportErrorCode
  public let status: Int?
  public let description: String
  public let retryAfterMs: Int?
  public var code: String { reason.rawValue }
  init(
    _ reason: TransportErrorCode, _ message: String, status: Int? = nil, retryAfterMs: Int? = nil
  ) {
    self.reason = reason
    self.description = message
    self.status = status
    self.retryAfterMs = retryAfterMs
  }
}
public struct BusRequestError: Error, Sendable, CustomStringConvertible {
  public let reason: BusRequestErrorCode
  public let description: String
  public var code: String { reason.rawValue }
  package init(_ reason: BusRequestErrorCode, _ message: String) {
    self.reason = reason
    self.description = message
  }
}
public enum ConnectionState: String, Sendable, CaseIterable {
  case initial, connecting, open, reconnecting, degraded, unauthenticated, closed
  func mayBecome(_ next: Self) -> Bool {
    switch self {
    case .initial: [.connecting, .unauthenticated, .closed].contains(next)
    case .connecting: [.open, .reconnecting, .unauthenticated, .closed].contains(next)
    case .open: [.reconnecting, .closed].contains(next)
    case .reconnecting: [.connecting, .degraded, .unauthenticated, .closed].contains(next)
    case .degraded: [.connecting, .unauthenticated, .closed].contains(next)
    case .unauthenticated: [.connecting, .closed].contains(next)
    case .closed: false
    }
  }
}

/// The four retry rules of `retryRules`, each asked whether it retries an answer: its status, or
/// nil when there was no answer; the request's method; and whether it carries an `Idempotency-Key`.
public enum RetryContext: String, CaseIterable, Sendable {
  case boot, transport, refresh, job
  public func retryable(status: Int?, method: String?, keyed: Bool) -> Bool {
    switch self {
    case .boot:
      return status.map(retryRules.boot.statuses.contains) == true
    case .transport:
      let rule = retryRules.transport
      return status.map(rule.statuses.contains) == true
        && (keyed || method.map { rule.idempotentMethods.contains($0.uppercased()) } == true)
    case .refresh:
      let rule = retryRules.refresh
      guard let status else { return rule.noResponse }
      return rule.statuses.contains(status) || status >= rule.statusFrom
    case .job:
      let rule = retryRules.job
      guard let status else { return false }
      return rule.statuses.contains(status) || status >= rule.statusFrom
    }
  }
}
func retryAfterMs(_ header: String?) -> Int? {
  guard let text = header?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty,
    text.utf8.allSatisfy({ (48...57).contains($0) }), let seconds = Int(text),
    seconds <= Int.max / 1000
  else { return nil }
  return seconds * 1000
}

public struct TransportTiming: Sendable {
  public var reconnectMs: Int
  public var lazyRemoveMs: Int
  public var lingerMs: Int
  public var seenEventIdsCount: Int
  public var httpRequestMs: Int
  public var streamOpenMs: Int
  public var emitAttempts: Int
  public var emitInitialDelayMs: Int
  public var emitMaxDelayMs: Int
  public init(
    reconnectMs: Int? = nil, lazyRemoveMs: Int? = nil, lingerMs: Int? = nil,
    seenEventIdsCount: Int? = nil, httpRequestMs: Int? = nil, streamOpenMs: Int? = nil,
    emitAttempts: Int? = nil, emitInitialDelayMs: Int? = nil, emitMaxDelayMs: Int? = nil
  ) {
    self.reconnectMs = reconnectMs ?? Timings.reconnectMs
    self.lazyRemoveMs = lazyRemoveMs ?? Timings.lazyRemoveMs
    self.lingerMs = lingerMs ?? Timings.lingerMs
    self.seenEventIdsCount = seenEventIdsCount ?? Timings.seenEventIdsCount
    self.httpRequestMs = httpRequestMs ?? Timings.httpRequestTimeoutMs
    self.streamOpenMs = streamOpenMs ?? Timings.streamOpenTimeoutMs
    self.emitAttempts = emitAttempts ?? Timings.emitRetry.attempts
    self.emitInitialDelayMs = emitInitialDelayMs ?? Timings.emitRetry.initialDelayMs
    self.emitMaxDelayMs = emitMaxDelayMs ?? Timings.emitRetry.maxDelayMs
  }
}
