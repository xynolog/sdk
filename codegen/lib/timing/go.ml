(* The timing as the Go SDK reads it (go/timing.go): one field of [Timing] per
   entry, and [DefaultTiming], the table's values. A duration is a
   time.Duration named without its unit ([reconnectMs] is [Reconnect]), a
   retry budget package api's RetryBudget, and a count an int. *)

module G = Go_syntax

let path = "go/timing_gen.go"

let field (e : Table.entry) =
  let name =
    match e.value with
    | Duration _ -> String.sub e.name 0 (String.length e.name - 2)
    | Budget _ | Count _ -> e.name
  in
  String.capitalize_ascii name

let ms n = G.Binary (G.Int n, G.Mul, G.Name "time.Millisecond")

let value (e : Table.entry) =
  match e.value with
  | Duration n -> ms n
  | Budget { attempts; initial_delay_ms; max_delay_ms } ->
      G.inline ~of_:(G.Named "api.RetryBudget")
        [
          G.keyed "Attempts" (G.Int attempts);
          G.keyed "InitialDelayMs" (G.Int initial_delay_ms);
          G.keyed "MaxDelayMs" (G.Int max_delay_ms);
        ]
  | Count n -> G.Int n

let text (t : Table.t) =
  G.text
    {
      header =
        G.verbatim
          "Code generated from protocol/specs/src/client/timing.json; DO NOT \
           EDIT.\n\n\
           Regenerate: make generate (codegen/lib/timing/go.ml)\n\
           The TypeScript, Python and Rust constants are generated from the \
           same table.";
      package = "xynolog";
      imports = [ [ "time" ]; [ "github.com/xynolog/sdk/go/api" ] ];
      decls =
        [
          G.Type
            {
              doc =
                G.prose
                  "Timing is the timing a Xynolog client keeps: its deadlines, \
                   its retry budgets, the cadence of its stream, and what it \
                   keeps count of, as protocol/specs/src/client/timing.json \
                   states them for every SDK. It holds one field per entry, \
                   under the entry's name. DefaultTiming is the table's \
                   values; a caller that wants another sets that field.";
              name = "Timing";
              def =
                Struct
                  {
                    spacing = Packed;
                    fields =
                      List.map
                        (fun (e : Table.entry) ->
                          {
                            G.doc =
                              G.prose
                                (Printf.sprintf "%s is %s: %s" (field e) e.name
                                   e.docs);
                            names = [ field e ];
                            type_ =
                              G.Named
                                (match e.value with
                                | Duration _ -> "time.Duration"
                                | Budget _ -> "api.RetryBudget"
                                | Count _ -> "int");
                            tag = None;
                          })
                        t;
                  };
            };
          G.func
            ~doc:[ G.Line "DefaultTiming is the table's values." ]
            ~results:(Unnamed [ G.Named "Timing" ]) "DefaultTiming"
            (Block
               [
                 Return
                   [
                     G.lines ~of_:(G.Named "Timing")
                       (List.map
                          (fun (e : Table.entry) -> G.keyed (field e) (value e))
                          t);
                   ];
               ]);
        ];
    }

let file t = { Output.path; text = text t }
