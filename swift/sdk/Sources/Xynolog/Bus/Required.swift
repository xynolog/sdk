import Foundation

// The first fault of a value as one of the protocol's component schemas. Every SDK holds what it
// reads to the table of what each schema requires, names the first fault it finds the same way,
// and leaves out of what it reads a member the table reads as absent. The table is generated
// (requiredSchemas, in Generated/Models.swift, written by codegen/lib/swift_sdk), by the rules of
// codegen/lib/required/shape.ml, which states what each part of a shape means and
// the order a reader walks them in.

/// The first thing wrong with a value, thrown where a value is refused.
extension Fault: Error {
  /// The fault of a value its decoder refuses where the table finds none: the value itself.
  static let undecoded = Fault(member: "", reason: .malformed)

  /// What every SDK says of it.
  public var said: String {
    switch reason {
    case .lacks: "it has no `\(member)`"
    case .malformed: member.isEmpty ? "it is malformed" : "its `\(member)` is malformed"
    }
  }
}

enum Kind: Sendable {
  case object, array, string, integer, number, boolean, null
}

/// One term of a pattern: a step or a group.
enum Term: Sendable {
  case step(Step)
  case group(Group)
}

/// A step of a pattern: at least `min` of a text's next code points, and at most `max` (none: any
/// number), each in one of the ranges `of`.
struct Step: Sendable {
  let of: [ClosedRange<UInt32>]
  let min: Int
  let max: Int?
}

/// A group of a pattern: a text's next code points one of the series `either`, at least `min` times
/// and at most `max` (none: any number), a repetition past `min` taking at least one code point.
struct Group: Sendable {
  let either: [[Term]]
  let min: Int
  let max: Int?
}

/// The member whose value names the variant of a union a value is.
struct Discriminator: Sendable {
  let property: String
  let mapping: [String: Int]
}

/// What a value must be. A part that is nil is one the table does not state.
final class Shape: Sendable {
  let ref: String?
  let kinds: [Kind]?
  /// Of an object's member, the texts it is read as: one that holds another text is read as absent.
  let recognized: [String]?
  let enumeration: [JSONValue]?
  let pattern: [Term]?
  let minLength: Int?
  let maxLength: Int?
  let minimum: Double?
  let maximum: Double?
  let minItems: Int?
  let maxItems: Int?
  let required: [String]?
  let members: [String: Shape]?
  let closed: [String]?
  let items: Shape?
  let values: Shape?
  let oneOf: [Shape]?
  let discriminator: Discriminator?
  let allOf: [Shape]?
  /// Sets of members an object does not carry all of.
  let notAll: [[String]]?
  let minMembers: Int?
  /// What each of an object's members' names must be.
  let names: Shape?

  init(
    ref: String? = nil, kinds: [Kind]? = nil, recognized: [String]? = nil,
    enumeration: [JSONValue]? = nil, pattern: [Term]? = nil, minLength: Int? = nil,
    maxLength: Int? = nil, minimum: Double? = nil, maximum: Double? = nil, minItems: Int? = nil,
    maxItems: Int? = nil, required: [String]? = nil, members: [String: Shape]? = nil,
    closed: [String]? = nil, items: Shape? = nil, values: Shape? = nil, oneOf: [Shape]? = nil,
    discriminator: Discriminator? = nil, allOf: [Shape]? = nil, notAll: [[String]]? = nil,
    minMembers: Int? = nil, names: Shape? = nil
  ) {
    self.ref = ref
    self.kinds = kinds
    self.recognized = recognized
    self.enumeration = enumeration
    self.pattern = pattern
    self.minLength = minLength
    self.maxLength = maxLength
    self.minimum = minimum
    self.maximum = maximum
    self.minItems = minItems
    self.maxItems = maxItems
    self.required = required
    self.members = members
    self.closed = closed
    self.items = items
    self.values = values
    self.oneOf = oneOf
    self.discriminator = discriminator
    self.allOf = allOf
    self.notAll = notAll
    self.minMembers = minMembers
    self.names = names
  }
}

/// The first fault `value` has as the component schema `schema`, by the rules every SDK reads the
/// table by; nil when it has none. `schema` names a schema Protocol states: any other name is a
/// programming error, and traps.
public func faultOf(_ schema: String, _ value: JSONValue) -> Fault? {
  faultOf(component(schema), value)
}

/// The first fault `value` has as a value of `shape`, by the rules every SDK reads the table by;
/// nil when it has none.
func faultOf(_ shape: Shape, _ value: JSONValue) -> Fault? {
  var read = value
  return faultAt(shape, &read, way: "")
}

/// `value` as `Value`, a generated type, held to the table as the component schema of its name
/// before it is decoded: nil for its first fault, or where its decoder refuses it.
func readAs<Value: Decodable>(_ type: Value.Type, _ value: JSONValue) -> Value? {
  var read = value
  guard faultAt(component(String(describing: type)), &read, way: "") == nil else { return nil }
  return try? JSONDecoder().decode(type, from: JSONEncoder().encode(read))
}

/// `payload`, a payload on `channel`, as it is read by the rules every SDK reads the table by: a
/// member it reads as absent left out. It is refused for its first fault.
func payloadAsRead(_ payload: [String: JSONValue], on channel: String) throws(Fault)
  -> [String: JSONValue]
{
  guard let shape = requiredPayloadShapes[channel] else {
    preconditionFailure("\(channel) is no channel of the bus's registry")
  }
  var read = JSONValue.object(payload)
  if let fault = faultAt(shape, &read, way: "") { throw fault }
  guard case .object(let object) = read else {
    preconditionFailure("a payload read on \(channel) is no object")
  }
  return object
}

private func component(_ name: String) -> Shape {
  guard let shape = requiredSchemas[name] else {
    preconditionFailure("\(name) is no component schema of the spec")
  }
  return shape
}

private func resolved(_ shape: Shape) -> Shape {
  guard let ref = shape.ref else { return shape }
  return resolved(component(ref))
}

private func within(_ way: String, _ name: String) -> String {
  way.isEmpty ? name : "\(way).\(name)"
}

private func kind(of value: JSONValue) -> Kind {
  switch value {
  case .null: .null
  case .bool: .boolean
  case .number: .number
  case .string: .string
  case .array: .array
  case .object: .object
  }
}

/// Whether `kinds` allow `value`: none allow any, and an integer is a number with no fractional part.
private func allows(_ kinds: [Kind]?, _ value: JSONValue) -> Bool {
  guard let kinds else { return true }
  if kinds.contains(kind(of: value)) { return true }
  guard case .number(let number) = value else { return false }
  return kinds.contains(.integer) && number.isFinite && number.rounded(.towardZero) == number
}

/// Whether `count` is at least `least` and at most `most`, where each is stated.
private func counted<Count: Comparable>(_ least: Count?, _ count: Count, _ most: Count?) -> Bool {
  if let least, count < least { return false }
  if let most, count > most { return false }
  return true
}

/// Whether the code points from `at` are of `terms`, with `rest` taking what is left after them: a
/// step takes as many points as it may and gives them back one by one, and a group repeats as often
/// as it may and gives repetitions back the same way, until `rest` takes what is left.
private func series(
  _ terms: ArraySlice<Term>, _ points: [UInt32], _ at: Int, _ rest: (Int) -> Bool
) -> Bool {
  guard let first = terms.first else { return rest(at) }
  switch first {
  case .group(let group):
    return repeated(group, points, at, 0) { series(terms.dropFirst(), points, $0, rest) }
  case .step(let step):
    var taken = 0
    while at + taken < points.count, counted(nil, taken + 1, step.max),
      step.of.contains(where: { $0.contains(points[at + taken]) })
    {
      taken += 1
    }
    while taken >= step.min {
      if series(terms.dropFirst(), points, at + taken, rest) { return true }
      taken -= 1
    }
    return false
  }
}

/// Whether the code points from `at` are of `group` repeated once more than `count` times or more,
/// then of `next`: a repetition past the group's `min` takes at least one code point.
private func repeated(
  _ group: Group, _ points: [UInt32], _ at: Int, _ count: Int, _ next: (Int) -> Bool
) -> Bool {
  if counted(nil, count + 1, group.max) {
    for alternative in group.either {
      let matched = series(alternative[...], points, at) { after in
        (count < group.min || after > at) && repeated(group, points, after, count + 1, next)
      }
      if matched { return true }
    }
  }
  return count >= group.min && next(at)
}

/// Whether `value` is one of `shape`'s values, a text is of its pattern and has as many code
/// points as it allows, a number is within its bounds, and an array has as many items and an object
/// as many members as it allows.
private func isAsStated(_ shape: Shape, _ value: JSONValue) -> Bool {
  if let enumeration = shape.enumeration, !enumeration.contains(value) { return false }
  switch value {
  case .string(let text):
    let points = text.unicodeScalars.map(\.value)
    guard counted(shape.minLength, points.count, shape.maxLength) else { return false }
    guard let pattern = shape.pattern else { return true }
    return series(pattern[...], points, 0) { $0 == points.count }
  case .number(let number): return counted(shape.minimum, number, shape.maximum)
  case .array(let items): return counted(shape.minItems, items.count, shape.maxItems)
  case .object(let members): return counted(shape.minMembers, members.count, nil)
  case .null, .bool: return true
  }
}

/// The first fault `value` has as a value of `shape`, from `way`. What the shape reads as absent
/// is left out of `value`.
private func faultAt(_ shape: Shape, _ value: inout JSONValue, way: String) -> Fault? {
  let own = resolved(shape)
  if !allows(own.kinds, value) || !isAsStated(own, value) {
    return Fault(member: way, reason: .malformed)
  }
  if case .object(var object) = value {
    if let fault = faultOfMembers(own, &object, way: way) { return fault }
    value = .object(object)
  }
  if case .array(var held) = value, let items = own.items {
    for index in held.indices {
      var item = held[index]
      if let fault = faultAt(items, &item, way: way) { return fault }
      if item != held[index] { held[index] = item }
    }
    value = .array(held)
  }
  if let variants = own.oneOf,
    let fault = faultOfOneOf(variants, own.discriminator, &value, way: way)
  {
    return fault
  }
  if let parts = own.allOf {
    for part in parts {
      if let fault = faultAt(part, &value, way: way) { return fault }
    }
  }
  return nil
}

/// Whether `shape`, a member's, reads `value` as absent: a text none of its recognized texts.
private func isUnrecognized(_ shape: Shape, _ value: JSONValue) -> Bool {
  guard let recognized = resolved(shape).recognized, case .string(let text) = value else {
    return false
  }
  return !recognized.contains(text)
}

/// The first fault of an object in the members `shape` requires, in what its members are, in the
/// members it may not carry, in its members' names, in the sets of members it may not carry all of,
/// and in its values. A member it reads as absent is left out of `object`.
private func faultOfMembers(_ shape: Shape, _ object: inout [String: JSONValue], way: String)
  -> Fault?
{
  let carried = Set(object.keys)
  if let required = shape.required {
    for name in required {
      switch object[name] {
      case nil: return Fault(member: within(way, name), reason: .lacks)
      case .null?:
        if let member = shape.members?[name], !allows(resolved(member).kinds, .null) {
          return Fault(member: within(way, name), reason: .lacks)
        }
      case .some: break
      }
    }
  }
  if let members = shape.members {
    for (name, member) in members.sorted(by: { byCodePoint($0.key, $1.key) }) {
      guard let held = object[name] else { continue }
      if isUnrecognized(member, held) {
        object.removeValue(forKey: name)
        continue
      }
      var read = held
      if let fault = faultAt(member, &read, way: within(way, name)) { return fault }
      if read != held { object[name] = read }
    }
  }
  if let closed = shape.closed,
    let unnamed = object.keys.filter({ !closed.contains($0) }).min(by: byCodePoint)
  {
    return Fault(member: within(way, unnamed), reason: .malformed)
  }
  if let names = shape.names {
    for name in carried.sorted(by: byCodePoint) {
      var read = JSONValue.string(name)
      if faultAt(names, &read, way: "") != nil {
        return Fault(member: within(way, name), reason: .malformed)
      }
    }
  }
  if let notAll = shape.notAll,
    notAll.contains(where: { members in members.allSatisfy { carried.contains($0) } })
  {
    return Fault(member: way, reason: .malformed)
  }
  if let values = shape.values {
    for (name, held) in object.sorted(by: { byCodePoint($0.key, $1.key) }) {
      var read = held
      if let fault = faultAt(values, &read, way: way) { return fault }
      if read != held { object[name] = read }
    }
  }
  return nil
}

/// The fault `value` has as one of a union's `variants`: the variant its discriminator names, or
/// else each variant whose kinds allow it. None when one of them has none; the first one's when
/// each has one; and a value no variant allows is malformed. `value` is read as the first variant
/// that has none reads it.
private func faultOfOneOf(
  _ variants: [Shape], _ discriminator: Discriminator?, _ value: inout JSONValue, way: String
) -> Fault? {
  var candidates = variants.filter { allows(resolved($0).kinds, value) }
  if case .object(let object) = value, let discriminator,
    case .string(let named)? = object[discriminator.property],
    let at = discriminator.mapping[named], variants.indices.contains(at)
  {
    candidates = [variants[at]]
  }
  if candidates.isEmpty { return Fault(member: way, reason: .malformed) }
  var first: Fault?
  for candidate in candidates {
    var read = value
    guard let fault = faultAt(candidate, &read, way: way) else {
      value = read
      return nil
    }
    if first == nil { first = fault }
  }
  return first
}
