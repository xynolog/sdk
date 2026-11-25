(* The worker's channels as the Rust SDK names them
   (rust/sdk/src/generated/worker_channels.rs, which claims.rs includes): an
   array of channel names per constant, under its name in upper case. *)

module R = Rust_syntax

let path = "rust/sdk/src/generated/worker_channels.rs"

let file (constants : Table.t list) =
  {
    Output.path;
    text =
      R.text
        ~header:
          (Banner.lines
             ~from_:
               ("protocol/specs/src/" ^ Table.file ^ " and bus/registry.json")
             __FILE__)
        (List.map
           (fun (c : Table.t) ->
             R.Const
               {
                 doc = [ Table.doc c ];
                 attrs = [];
                 vis = Pub;
                 name = R.screaming c.member;
                 ty =
                   R.Array_of
                     (R.Ref (None, R.named "str"), List.length c.channels);
                 value = R.Array (List.map (fun n -> R.Str n) c.channels);
               })
           constants);
  }
