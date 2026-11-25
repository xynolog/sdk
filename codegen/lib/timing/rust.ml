(* The timing as the Rust SDK reads it (rust/sdk/src/timing.rs): a constant
   per entry. A duration is a std::time::Duration named without its unit
   ([reconnectMs] is [RECONNECT]), a retry budget a RetryBudget, and a count
   a usize. *)

module R = Rust_syntax

let path = "rust/sdk/src/generated/timing.rs"
let duration = R.named "std::time::Duration"
let millis n = R.call "std::time::Duration::from_millis" [ R.Int n ]

let name (e : Table.entry) =
  R.screaming
    (match e.value with
    | Duration _ -> String.sub e.name 0 (String.length e.name - 2)
    | Budget _ | Count _ -> e.name)

let constant (e : Table.entry) =
  let ty, value =
    match e.value with
    | Duration n -> (duration, millis n)
    | Budget { attempts; initial_delay_ms; max_delay_ms } ->
        ( R.named "crate::types::RetryBudget",
          R.Struct
            ( [ "crate"; "types"; "RetryBudget" ],
              [
                ("attempts", R.Int attempts);
                ("initial_delay_ms", R.Int initial_delay_ms);
                ("max_delay_ms", R.Int max_delay_ms);
              ],
              None ) )
    | Count n -> (R.named "usize", R.Int n)
  in
  R.Const { doc = [ e.docs ]; attrs = []; vis = Pub; name = name e; ty; value }

let file (t : Table.t) =
  {
    Output.path;
    text =
      R.text
        ~header:
          (Banner.lines ~from_:"protocol/specs/src/client/timing.json" __FILE__)
        (List.map constant t);
  }
