(* The timing as the Go SDK reads it: in package timing, which the module
   alone imports (go/internal/timing), a value per entry; and in package
   xynolog (go/timing_gen.go) the structs of what a caller may set, each with
   a function giving the table's values. A duration is a time.Duration named
   without its unit ([reconnectMs] is [Reconnect]), a retry budget package
   api's RetryBudget, and a count an int. *)

module G = Go_syntax

let header =
  G.verbatim
    "Code generated from protocol/specs/src/client/timing.json; DO NOT EDIT.\n\n\
     Regenerate: make generate (codegen/lib/timing/go.ml)\n\
     The TypeScript, Python and Rust constants are generated from the same \
     table."

let api = "github.com/xynolog/sdk/go/api"
let internal = "github.com/xynolog/sdk/go/internal/timing"

let field (e : Table.entry) =
  let name =
    match e.value with
    | Duration _ -> String.sub e.name 0 (String.length e.name - 2)
    | Budget _ | Count _ -> e.name
  in
  String.capitalize_ascii name

let type_of (e : Table.entry) =
  G.Named
    (match e.value with
    | Duration _ -> "time.Duration"
    | Budget _ -> "api.RetryBudget"
    | Count _ -> "int")

let ms n = G.Binary (G.Int n, G.Mul, G.Name "time.Millisecond")

let about (e : Table.entry) =
  G.prose (Printf.sprintf "%s is %s: %s" (field e) e.name e.docs)

let value (e : Table.entry) =
  let spec = G.spec ~doc:(about e) (field e) in
  match e.value with
  | Duration n -> G.Const (spec (ms n))
  | Count n -> G.Const (spec (G.Int n))
  | Budget { attempts; initial_delay_ms; max_delay_ms } ->
      G.Var
        (spec
           (G.inline ~of_:(G.Named "api.RetryBudget")
              [
                G.keyed "Attempts" (G.Int attempts);
                G.keyed "InitialDelayMs" (G.Int initial_delay_ms);
                G.keyed "MaxDelayMs" (G.Int max_delay_ms);
              ]))

let values (t : Table.t) =
  G.text
    {
      header;
      package = "timing";
      imports = [ [ "time" ]; [ api ] ];
      decls = List.map value t;
    }

let record (t : Table.t) record =
  let name = Table.record_name record in
  let members = Table.members record t in
  let defaults = "Default" ^ name in
  [
    G.Type
      {
        doc =
          G.prose
            (Printf.sprintf
               "%s holds what a caller may set of the timing a %s keeps, one \
                field per entry of protocol/specs/src/%s under the entry's \
                name. %s is the table's values; a caller that wants another \
                sets that field."
               name
               (match record with
               | Table.Client -> "client"
               | Table.Transport -> "transport")
               Table.file defaults);
        name;
        def =
          Struct
            {
              spacing = Packed;
              fields =
                List.map
                  (fun e ->
                    {
                      G.doc = about e;
                      names = [ field e ];
                      type_ = type_of e;
                      tag = None;
                    })
                  members;
            };
      };
    G.func
      ~doc:[ G.Line (defaults ^ " is the table's values of " ^ name ^ ".") ]
      ~results:(Unnamed [ G.Named name ]) defaults
      (Block
         [
           Return
             [
               G.lines ~of_:(G.Named name)
                 (List.map
                    (fun e -> G.keyed (field e) (G.Name ("timing." ^ field e)))
                    members);
             ];
         ]);
  ]

let records (t : Table.t) =
  G.text
    {
      header;
      package = "xynolog";
      imports = [ [ "time" ]; [ api; internal ] ];
      decls = List.concat_map (record t) Table.records;
    }

let files t =
  [
    { Output.path = "go/internal/timing/timing_gen.go"; text = values t };
    { Output.path = "go/timing_gen.go"; text = records t };
  ]
