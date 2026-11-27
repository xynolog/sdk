(* The table as JSON, which Go's package embeds. *)

let path = "go/internal/required/schemas_gen.json"

(* What every SDK's table is generated from ([Required.derive]). *)
let authority =
  "every schema Protocol roots (codegen/lib/roots.ml), each record its tables \
   state, each client type every SDK generates, the sign-in store's entry \
   (protocol/specs/src/sign-in-store/SignIn.json), and \
   protocol/specs/src/client/discovery-absent.json"

let comment =
  "Generated from " ^ authority
  ^ "; do not edit. Regenerate: make generate (codegen/lib/required). What \
     each requires of a value, by its name: codegen/lib/required/shape.ml \
     states the rules."

(* One schema to a line, so a change to one shows as that line. *)
let text (shapes : (string * Shape.shape) list) =
  let entry (name, shape) =
    "    "
    ^ Yojson.Safe.to_string (`String name)
    ^ ": "
    ^ Yojson.Safe.to_string (Shape.to_json ~pairs:false shape)
  in
  "{\n  \"$comment\": "
  ^ Yojson.Safe.to_string (`String comment)
  ^ ",\n  \"schemas\": {\n"
  ^ String.concat ",\n" (List.map entry shapes)
  ^ "\n  }\n}\n"

let file shapes = { Output.path; text = text shapes }
