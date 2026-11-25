import Foundation
import Testing

@testable import Xynolog

/// A union's value is read as the one member whose signature admits it, as
/// Typing states each member's.

private func answer(_ wire: String) throws -> AnchoredTextAnswer {
  try JSONDecoder().decode(AnchoredTextAnswer.self, from: Data(wire.utf8))
}

/// What a decoding error says.
private func refusal(_ read: () throws -> Any) -> String {
  do {
    _ = try read()
    return "read"
  } catch DecodingError.dataCorrupted(let context) {
    return context.debugDescription
  } catch {
    return "\(error)"
  }
}

@Test func aUnionIsDecodedAsTheOneMemberThatAdmitsAValue() throws {
  guard case .anchoredTextAbsent = try answer(#"{"kind":"no-map"}"#) else {
    Issue.record("no-map is no absence")
    return
  }
  guard case .extractionDeclined = try answer(#"{"kind":"declined","declined":"encrypted"}"#) else {
    Issue.record("declined is no decline")
    return
  }
  #expect(refusal { try answer(#"{"kind":"declined"}"#) }.contains("declined"))
  #expect(
    refusal { try answer(#"{"kind":"later"}"#) }
      == "a AnchoredTextAnswer states a `kind` that is one of `extracted`, `declined`, `not-yet`, `no-map`, `unknown`"
  )
}

@Test func aValueNoMemberNamesIsNoneOfThem() {
  #expect(UnionSignature.member(of: .string("text"), in: AnchoredTextAnswer.members) == nil)
  #expect(
    refusal { try JSONDecoder().decode(JobStoredProgress.self, from: Data(#""text""#.utf8)) }
      == "a JobStoredProgress that is none of its members")
}

@Test func eachKindIsTheJsonItNames() {
  let values: [JSONValue] = [
    .string("a"), .number(1), .number(1.5), .bool(true), .array([]), .object([:]), .null,
  ]
  let admitted: [(UnionSignature.Kind, [Int])] = [
    (.text, [0]), (.integer, [1]), (.number, [1, 2]), (.boolean, [3]), (.list, [4]), (.object, [5]),
    (.null, [6]), (.any, Array(values.indices)),
  ]
  for (kind, indices) in admitted {
    #expect(values.indices.filter { kind.of(values[$0]) } == indices, "\(kind)")
  }
}

@Test func aLiteralIsTheOneValueItStates() {
  #expect(UnionSignature.Literal.integer(3).matches(.number(3)))
  #expect(!UnionSignature.Literal.integer(3).matches(.string("3")))
  #expect(UnionSignature.Literal.boolean(false).matches(.bool(false)))
  #expect(!UnionSignature.Literal.boolean(false).matches(.bool(true)))
  #expect(UnionSignature.Literal.text("x").matches(.string("x")))
  let literals: [UnionSignature.Literal] = [.integer(3), .boolean(false), .text("x")]
  #expect(literals.map(\.description) == ["`3`", "`false`", "`x`"])
}

/// A union told apart by `kind`, whose second member admits only the
/// members it names: a value it names and does not admit is refused, though
/// it decodes.
private enum Closed: Decodable, Equatable {
  struct Open: Decodable, Equatable {
    let kind: String
    let a: String
  }

  struct Shut: Decodable, Equatable {
    let kind: String
    let b: Int
  }

  case open(Open)
  case shut(Shut)

  static let members: [[UnionSignature]] = [
    [
      UnionSignature(
        kind: .object, required: ["kind", "a"], allowed: nil,
        fixed: [.init(property: "kind", values: [.text("open")])], values: nil)
    ],
    [
      UnionSignature(
        kind: .object, required: ["kind", "b"], allowed: ["kind", "b"],
        fixed: [.init(property: "kind", values: [.text("shut")])], values: nil)
    ],
  ]

  init(from decoder: any Decoder) throws {
    self = try UnionSignature.decode(
      from: decoder, union: "Closed", members: Self.members,
      variants: [
        ("open", { decoder in try Self.open(Open(from: decoder)) }),
        ("shut", { decoder in try Self.shut(Shut(from: decoder)) }),
      ])
  }
}

@Test func aMemberThatOnlyNamesAValueSaysItDoesNotAdmitIt() throws {
  let closed = { (wire: String) in try JSONDecoder().decode(Closed.self, from: Data(wire.utf8)) }
  #expect(try closed(#"{"kind":"shut","b":1}"#) == .shut(.init(kind: "shut", b: 1)))
  #expect(
    refusal { try closed(#"{"kind":"shut","b":1,"c":2}"#) }
      == "a Closed its member shut does not admit")
  #expect(
    refusal { try closed(#"{"kind":"other"}"#) }
      == "a Closed states a `kind` that is one of `open`, `shut`")
}
