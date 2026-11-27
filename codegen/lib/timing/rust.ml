(* The timing as the Rust SDK reads it (rust/sdk/src/timing.rs): a constant
   per entry, and the records of what a caller may set. A duration is a
   std::time::Duration named without its unit ([reconnectMs] is [RECONNECT],
   and the member [reconnect]), a retry budget a RetryBudget, and a count a
   usize. *)

module R = Rust_syntax

let path = "rust/sdk/src/generated/timing.rs"
let duration = R.named "std::time::Duration"
let millis n = R.call "std::time::Duration::from_millis" [ R.Int n ]

let stem (e : Table.entry) =
  match e.value with
  | Duration _ -> String.sub e.name 0 (String.length e.name - 2)
  | Budget _ | Count _ -> e.name

let name e = R.screaming (stem e)
let budget = R.named "crate::types::RetryBudget"

let type_of (e : Table.entry) =
  match e.value with
  | Duration _ -> duration
  | Budget _ -> budget
  | Count _ -> R.named "usize"

let constant (e : Table.entry) =
  let value =
    match e.value with
    | Duration n -> millis n
    | Budget { attempts; initial_delay_ms; max_delay_ms } ->
        R.Struct
          ( [ "crate"; "types"; "RetryBudget" ],
            [
              ("attempts", R.Int attempts);
              ("initial_delay_ms", R.Int initial_delay_ms);
              ("max_delay_ms", R.Int max_delay_ms);
            ],
            None )
    | Count n -> R.Int n
  in
  R.Const
    {
      doc = [ e.docs ];
      attrs = [];
      vis = Pub;
      name = name e;
      ty = type_of e;
      value;
    }

(* A record and its [Default], the table's values. It is [Copy] where every
   member is. *)
let record (t : Table.t) record =
  let record_name = Table.record_name record in
  let members = Table.members record t in
  let copy =
    List.for_all
      (fun (e : Table.entry) ->
        match e.value with Budget _ -> false | Duration _ | Count _ -> true)
      members
  in
  let member (e : Table.entry) = R.snake (stem e) in
  [
    R.Blank;
    R.Struct_def
      {
        doc = [ Table.record_docs record ];
        attrs =
          [
            R.List
              ( [ "derive" ],
                List.map
                  (fun trait_ -> R.Word [ trait_ ])
                  ([ "Debug"; "Clone" ]
                  @ (if copy then [ "Copy" ] else [])
                  @ [ "PartialEq"; "Eq" ]) );
          ];
        vis = Pub;
        name = record_name;
        generics = [];
        body =
          Fields
            (List.map
               (fun (e : Table.entry) ->
                 R.field ~doc:[ e.docs ] (member e) (type_of e))
               members);
      };
    R.Blank;
    R.Impl
      {
        generics = [];
        trait_ = Some (R.named "Default");
        for_ = R.named record_name;
        items =
          [
            R.I_fn
              (R.fn_ ~ret:(R.named "Self") "default"
                 [
                   R.Tail
                     (R.Struct
                        ( [ record_name ],
                          List.map (fun e -> (member e, R.p (name e))) members,
                          None ));
                 ]);
          ];
      };
  ]

let file (t : Table.t) =
  {
    Output.path;
    text =
      R.text
        ~header:
          (Banner.lines ~from_:"protocol/specs/src/client/timing.json" __FILE__)
        (List.map constant t @ List.concat_map (record t) Table.records);
  }
