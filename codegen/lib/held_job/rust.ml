(* A Rust held job's members that are its record's
   (rust/sdk/src/generated/held_job.rs, which claims.rs includes): for each
   type of the handed, a method per field of the struct the Rust types
   declare of the record, which reads it from the record the hand-written
   [record] returns. A copied value is returned as it is, a [Vec] as a slice,
   and anything else by reference. *)

module R = Rust_syntax

let path = "rust/sdk/src/generated/held_job.rs"

(* The Rust SDK's types of a handed, each with its generics. *)
let held = function
  | "heldJob" ->
      Some
        [
          ([ R.Type_param ("V", []) ], R.named ~args:[ R.named "V" ] "Held");
          ([], R.named "HeldJob");
        ]
  | _ -> None

let accessor ~copied (f : R.field) =
  let read = R.Field (R.Method (R.p "self", "record", []), f.name) in
  let ret, value =
    match f.ty with
    | R.Named ([ "Vec" ], [ item ]) ->
        (R.Ref (None, R.Slice item), R.Ref_of read)
    | ty when copied ty -> (ty, read)
    | ty -> (R.Ref (None, ty), R.Ref_of read)
  in
  R.I_fn
    (R.fn_ ~doc:f.doc ~vis:R.Pub ~params:[ R.Self_ref ] ~ret f.name
       [ R.Tail value ])

let file spec (records : Table.t list) =
  let impls (t : Table.t) =
    let fields, copied = Rust_types.fields spec t.record in
    List.concat_map
      (fun (generics, for_) ->
        [
          R.Impl
            {
              generics;
              trait_ = None;
              for_;
              items = List.map (accessor ~copied) fields;
            };
          R.Blank;
        ])
      (Table.types ~sdk:"Rust" held t)
  in
  {
    Output.path;
    text =
      R.text
        ~header:
          (Banner.lines
             ~from_:("protocol/specs/src/" ^ Table.file ^ " and client/types")
             __FILE__)
        (List.concat_map impls records);
  }
