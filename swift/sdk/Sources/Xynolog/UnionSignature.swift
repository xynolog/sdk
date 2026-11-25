/// What a member of a union admits, as its schema states it: what tells it
/// from the union's other members. Each generated union states its members'
/// (`members`), and is decoded as the one member that admits a value.
struct UnionSignature: Sendable {
  /// The kind of JSON value a signature admits.
  enum Kind: Sendable {
    case text, integer, number, boolean, list, object, null, any

    func of(_ value: JSONValue) -> Bool {
      switch (self, value) {
      case (.text, .string), (.number, .number), (.boolean, .bool), (.list, .array),
        (.object, .object), (.null, .null), (.any, _):
        return true
      case (.integer, .number(let number)):
        return number.isFinite && number.rounded() == number
      default:
        return false
      }
    }
  }

  /// One value a schema states.
  enum Literal: Sendable, CustomStringConvertible {
    case text(String)
    case integer(Int)
    case boolean(Bool)

    func matches(_ value: JSONValue) -> Bool {
      switch (self, value) {
      case (.text(let text), .string(let string)): return text == string
      case (.integer(let integer), .number(let number)): return Double(integer) == number
      case (.boolean(let boolean), .bool(let bool)): return boolean == bool
      default: return false
      }
    }

    var description: String {
      switch self {
      case .text(let text): return "`\(text)`"
      case .integer(let integer): return "`\(integer)`"
      case .boolean(let boolean): return "`\(boolean)`"
      }
    }
  }

  /// The values a member of an object may take.
  struct Fixed: Sendable {
    let property: String
    let values: [Literal]
  }

  let kind: Kind
  /// The members an object must carry.
  let required: [String]
  /// Every member an object may carry, where its schema says.
  let allowed: [String]?
  /// The values each of these members may take.
  let fixed: [Fixed]
  /// Every value it admits, where its schema says.
  let values: [Literal]?

  /// Whether `value` is of its kind, and states only the values it admits.
  func names(_ value: JSONValue) -> Bool {
    guard kind.of(value) else { return false }
    if let values, !values.contains(where: { $0.matches(value) }) { return false }
    guard case .object(let object) = value else { return true }
    return fixed.allSatisfy { stated in
      object[stated.property].map { member in stated.values.contains { $0.matches(member) } } ?? true
    }
  }

  /// Whether it admits `value`: it names it, and an object carries every
  /// member it requires and none it does not allow.
  func admits(_ value: JSONValue) -> Bool {
    guard names(value) else { return false }
    guard case .object(let object) = value else { return true }
    return required.allSatisfy { object[$0] != nil }
      && (allowed.map { allowed in object.keys.allSatisfy { allowed.contains($0) } } ?? true)
  }

  /// The one of a union's `members`, each its signatures, that admits
  /// `value`; or, none admitting it, the one that names it, whose decoding
  /// says what is wrong with it.
  static func member(of value: JSONValue, in members: [[UnionSignature]]) -> (at: Int, admitted: Bool)? {
    func only(_ test: (UnionSignature) -> Bool) -> Int? {
      let found = members.indices.filter { members[$0].contains(where: test) }
      return found.count == 1 ? found[0] : nil
    }
    if let at = only({ $0.admits(value) }) { return (at, true) }
    if let at = only({ $0.names(value) }) { return (at, false) }
    return nil
  }

  /// What is wrong with a value of `union` that none of its `members` names:
  /// where each states its values of one property, that the value's is none
  /// of them.
  static func noneOf(_ union: String, _ members: [[UnionSignature]]) -> String {
    let signatures = members.flatMap { $0 }
    let toldApart = members.first?.first?.fixed.lazy.compactMap { first -> (String, [Literal])? in
      let stated = signatures.map { signature in
        signature.fixed.first { $0.property == first.property }?.values
      }
      guard stated.allSatisfy({ $0 != nil }) else { return nil }
      return (first.property, stated.flatMap { $0 ?? [] })
    }.first
    guard let toldApart else { return "a \(union) that is none of its members" }
    let (property, values) = toldApart
    return "a \(union) states a `\(property)` that is one of \(values.map(\.description).joined(separator: ", "))"
  }

  /// A value of `union` from `decoder`, read as the one of its `variants`, in
  /// the order of its `members`, that `member(of:in:)` finds: one that admits
  /// the value is read as it, and one that only names it says what is wrong
  /// with it.
  static func decode<Union>(
    from decoder: any Decoder,
    union: String,
    members: [[UnionSignature]],
    variants: [(label: String, read: (any Decoder) throws -> Union)]
  ) throws -> Union {
    guard let found = member(of: try JSONValue(from: decoder), in: members) else {
      throw DecodingError.dataCorrupted(
        .init(codingPath: decoder.codingPath, debugDescription: noneOf(union, members)))
    }
    let variant = variants[found.at]
    let read = try variant.read(decoder)
    guard found.admitted else {
      throw DecodingError.dataCorrupted(
        .init(
          codingPath: decoder.codingPath,
          debugDescription: "a \(union) its member \(variant.label) does not admit"))
    }
    return read
  }
}
