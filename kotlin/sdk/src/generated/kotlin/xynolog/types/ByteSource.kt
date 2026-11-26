// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

/** Bytes opened afresh each time they are to be sent. Each opening reads them from the first byte, in order, once, and gives the same bytes as every other; whoever opened them releases what they opened. Their length is stated when it is known and stated by nothing when it is not. An upload takes its bytes so: held whole, a file larger than memory could not be sent at all, and read once, as a ByteStream is, an upload sent again would have nothing left to send. */
public typealias ByteSource = ByteArray
