(* The option defaults as the Rust SDK reads them
   (rust/sdk/src/generated/option_defaults.rs, which option_defaults.rs
   includes): a constant per row under its name in upper snake case, an
   integer of the type the SDK's types give its bounds, and a value of a named
   schema, which no constant can hold, a function under the row's name in
   snake case giving it, written member by member as the SDK's types hold
   it. *)

module R = Rust_syntax

let path = "rust/sdk/src/generated/option_defaults.rs"

(* The SDK's session_from_kept takes [validate] as a required member of
   SessionFromKept, which states no default. *)
let lacks =
  [
    ( "keptSignInSessionFromKeptValidate",
      "SessionFromKept's validate is a member every caller states" );
  ]

let types name = [ "crate"; "types"; name ]

let rec literal : Table.typed -> R.expr = function
  | T_text s -> R.Method (R.Str s, "to_owned", [])
  | T_integer n -> R.Int n
  | T_boolean b -> R.Bool b
  | T_member { enum; value } -> R.Path (types enum @ [ Naming.variant value ])
  | T_record { record; fields } ->
      R.Struct
        ( types record,
          List.map
            (fun (f : Table.field) ->
              ( R.snake f.wire,
                match f.given with
                | Some v -> literal v
                | None -> R.Path [ "None" ] ))
            fields,
          None )
  | T_branch { union; variant; value } ->
      R.Call (R.Path (types union @ [ variant ]), [ literal value ])

let item (e : Table.entry) =
  let const ty value =
    R.Const
      {
        doc = [ e.docs ];
        attrs = [];
        vis = Pub;
        name = R.screaming e.name;
        ty;
        value;
      }
  in
  match e.value with
  | Text s -> const R.str_ty (R.Str s)
  | Integer { value; minimum; maximum } ->
      const
        (R.named (Rust_types.Generate.integer ~minimum ~maximum))
        (R.Int value)
  | Boolean b -> const (R.named "bool") (R.Bool b)
  | Member { enum; value } ->
      const
        (R.Named (types enum, []))
        (R.Path (types enum @ [ Naming.variant value ]))
  | Read { schema; typed; _ } ->
      R.Fn
        (R.fn_ ~doc:[ e.docs ] ~vis:Pub
           ~ret:(R.Named (types schema, []))
           (R.snake e.name)
           [ R.Tail (literal typed) ])

let file (t : Table.t) =
  let t = Table.written ~language:"Rust" ~lacks t in
  {
    Output.path;
    text =
      R.text
        ~header:
          (Banner.lines ~from_:("protocol/specs/src/" ^ Table.file) __FILE__)
        (List.concat_map (fun e -> [ item e; R.Blank ]) t);
  }
