(* The moves of a client's stream as the Rust SDK reads them
   (rust/sdk/src/generated/connection_states.rs, which transport.rs
   includes, ConnectionState in scope): each ConnectionState with the states
   it moves to. *)

module R = Rust_syntax

let path = "rust/sdk/src/generated/connection_states.rs"
let state_type = R.named "ConnectionState"
let state s = R.Path [ "ConnectionState"; Naming.variant s ]

let file (t : Table.t) =
  {
    Output.path;
    text =
      R.text
        ~header:(Banner.lines ~from_:Table.from_ __FILE__)
        [
          R.Const
            {
              doc =
                [
                  "Each state of a client's stream, with the states it moves \
                   to and no other.";
                ];
              attrs = [];
              vis = Pub;
              name = "CONNECTION_STATE_MOVES";
              ty =
                R.Array_of
                  ( R.Tuple_of [ state_type; R.Ref (None, R.Slice state_type) ],
                    List.length t );
              value =
                R.Array
                  (List.map
                     (fun (s, moves) ->
                       R.Tuple
                         [ state s; R.Ref_of (R.Array (List.map state moves)) ])
                     t);
            };
        ];
  }
