struct WireKey: CodingKey {
  let stringValue: String
  var intValue: Int? { nil }
  init(_ value: String) { stringValue = value }
  init?(stringValue: String) { self.stringValue = stringValue }
  init?(intValue: Int) { return nil }
}

/// How a generated model reads its members: each by its wire name, so a
/// model states only which members it has and which it requires.
extension KeyedDecodingContainer where Key == WireKey {
  /// A member the schema requires.
  func value<T: Decodable>(_ name: String) throws -> T {
    try decode(T.self, forKey: WireKey(name))
  }

  /// A member that may be absent. A stated null is refused: the member is
  /// not nullable.
  func ifPresent<T: Decodable>(_ name: String) throws -> T? {
    contains(WireKey(name)) ? try decode(T.self, forKey: WireKey(name)) : nil
  }

  /// Refuses a member that is none of `names`, the members of `model`.
  func refuseUnknown(_ names: Set<String>, in model: String) throws {
    if let key = allKeys.first(where: { !names.contains($0.stringValue) }) {
      throw DecodingError.dataCorruptedError(
        forKey: key, in: self, debugDescription: "unknown property in \(model)")
    }
  }

  /// Every member that is none of `names`, as it came.
  func rest(excluding names: Set<String>) throws -> [String: JSONValue] {
    var rest: [String: JSONValue] = [:]
    for key in allKeys where !names.contains(key.stringValue) {
      rest[key.stringValue] = try decode(JSONValue.self, forKey: key)
    }
    return rest
  }
}

/// How a generated model writes its members, each by its wire name.
extension KeyedEncodingContainer where Key == WireKey {
  /// A member the model always states.
  mutating func encode<T: Encodable>(_ value: T, as name: String) throws {
    try encode(value, forKey: WireKey(name))
  }

  /// A member that is written only when present.
  mutating func encodeIfPresent<T: Encodable>(_ value: T?, as name: String) throws {
    try encodeIfPresent(value, forKey: WireKey(name))
  }

  /// The members `rest` holds, none of which may be one of `names`, the
  /// members of `model`.
  mutating func encode(
    rest: [String: JSONValue], excluding names: Set<String>, of model: String
  ) throws {
    for (key, value) in rest {
      guard !names.contains(key) else {
        throw EncodingError.invalidValue(
          value,
          .init(
            codingPath: codingPath,
            debugDescription: "rest overrides a named property of \(model)"))
      }
      try encode(value, forKey: WireKey(key))
    }
  }
}
