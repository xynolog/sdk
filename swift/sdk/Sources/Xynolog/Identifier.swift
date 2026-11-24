/// What each kind of id shares: text held to its kind's rule. An id keys a dictionary by its text, so a map Protocol
/// keys by an id (`LastEventIds`) is a JSON object, and a key its kind's rule refuses is no key.
public protocol Identifier: Hashable, Sendable, Codable, CustomStringConvertible, CodingKeyRepresentable {
  var value: String { get }
  init(_ value: String) throws
}

extension Identifier {
  public var codingKey: any CodingKey { WireKey(value) }

  public init?<T: CodingKey>(codingKey: T) {
    guard let made = try? Self(codingKey.stringValue) else { return nil }
    self = made
  }
}
