(* An OCaml held job's members that are its record's
   (ocaml/sdk/lib/held_job_members.ml, which worker.ml includes): for each
   record, a module of it holding [S], what holds one has, and [Make], which,
   given how to read the record from what holds it, makes [record] and a
   function per field of the record as records.ml declares it, reading it
   from the record. *)

module O = Ocaml_syntax
module Table = Held_job.Table

let path = "ocaml/sdk/lib/held_job_members.ml"

(* What the OCaml SDK holds a handed in: the type worker.ml includes [S] at. *)
let held = function "heldJob" -> Some "held" | _ -> None

let module_of (t : Table.t) ~tabled =
  let module_ = Enums.module_name t.record in
  let fields =
    match
      List.find_opt (fun (r : Records.tabled) -> r.module_ = module_) tabled
    with
    | Some { form = Fields { fields; _ }; _ } -> fields
    | Some _ -> Definitions.refuse "%s: Records holds it as no record" t.record
    | None -> Definitions.refuse "%s: Records has no module of it" t.record
  in
  let holder = Table.types ~sdk:"OCaml" held t in
  let record_type = O.type_ ("Records." ^ module_ ^ ".t") in
  let read holder_type = O.arrow holder_type record_type in
  let signature =
    O.module_type "S"
      (O.type_spec (O.type_declaration holder O.Abstract)
      :: O.val_ "record" (read (O.type_ holder))
      :: List.map
           (fun (f : Records.field) ->
             O.val_ f.label (O.arrow (O.type_ holder) (Records.field_type f)))
           fields)
  in
  let make =
    O.functor_ "Make" ~param:"Held"
      ~needs:
        [
          O.type_spec (O.type_declaration "t" O.Abstract);
          O.val_ "record" (read (O.type_ "t"));
        ]
      ~result:(O.substituted "S" ~type_:holder ~by:(O.type_ "Held.t"))
      (O.let_ "record" (O.ident "Held.record")
      :: List.map
           (fun (f : Records.field) ->
             O.define f.label [ "held" ]
               (O.field
                  (O.call "Held.record" [ O.ident "held" ])
                  ("Records." ^ module_ ^ "." ^ f.label)))
           fields)
  in
  O.module_ module_ [ signature; make ]

let file (spec : Spec.t) (_, tabled) =
  match List.map (module_of ~tabled) (Table.all spec) with
  | modules ->
      Ok
        (O.implementation ~path
           ~banner:
             (Banner.ocaml
                ~from_:("protocol/specs/src/" ^ Table.file ^ " and client/types")
                __FILE__)
           modules)
  | exception Definitions.Refused message ->
      Error
        [
          {
            Decode.file = "protocol/specs/src/" ^ Table.file;
            pointer = "";
            message;
          };
        ]
