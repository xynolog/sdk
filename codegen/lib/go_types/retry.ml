(* The retry rules as the Go SDK keeps them (go/retry_gen.go): each rule of
   protocol/specs/src/retry/rules.json, its sets as the values of a RetryRule,
   whose Retryable (go/retry.go) asks them. *)

module G = Go_syntax
module T = Tables.Retry_rules

let path = "go/retry_gen.go"

let ints values =
  G.inline ~of_:(G.Slice (G.Named "int"))
    (List.map (fun n -> G.item (G.Int n)) values)

let strings values =
  G.inline ~of_:(G.Slice (G.Named "string"))
    (List.map (fun s -> G.item (G.Quoted s)) values)

let rule_name name = "RetryRule" ^ String.capitalize_ascii name

let rule name members =
  G.spec
    ~doc:
      (G.prose
         (Printf.sprintf "%s is the %s rule of retry/rules.json."
            (rule_name name) name))
    (rule_name name)
    (G.inline ~of_:(G.Named "RetryRule")
       (G.keyed "Name" (G.Quoted name) :: members))

let status_from from =
  G.keyed "StatusFrom" (G.Call (G.Name "new", [ G.Int from ]))

(* The pattern names every rule, so a rule retry/rules.json gains fails the
   build until it is written here. *)
let text (t : T.t) =
  let { T.comment = _; boot; job; transport; refresh } = t in
  let rules =
    [
      rule "boot" [ G.keyed "Statuses" (ints boot.statuses) ];
      rule "job"
        [ G.keyed "Statuses" (ints job.statuses); status_from job.status_from ];
      rule "transport"
        [
          G.keyed "Statuses" (ints transport.statuses);
          G.keyed "IdempotentMethods" (strings transport.idempotent_methods);
        ];
      rule "refresh"
        [
          G.keyed "Statuses" (ints refresh.statuses);
          status_from refresh.status_from;
          G.keyed "NoResponse" (G.Name (string_of_bool refresh.no_response));
        ];
    ]
  in
  G.text
    {
      header =
        G.verbatim
          ("Code generated from protocol/specs/src/retry/rules.json — DO NOT \
            EDIT.\n\n\
            Regenerate: make generate (" ^ Banner.writer __FILE__ ^ ")");
      package = "xynolog";
      imports = [];
      decls =
        [
          G.Vars { doc = []; spacing = Spaced; specs = rules };
          G.Func
            {
              doc = G.prose "RetryRules is every rule of retry/rules.json.";
              receiver = None;
              name = "RetryRules";
              params = [];
              results = G.Unnamed [ G.Slice (G.Named "RetryRule") ];
              body =
                G.One_line
                  (G.Return
                     [
                       G.inline ~of_:(G.Slice (G.Named "RetryRule"))
                         (List.map
                            (fun (s : G.spec) -> G.item (G.Name s.name))
                            rules);
                     ]);
            };
        ];
    }

let file (spec : Spec.t) = { Output.path; text = text spec.tables.retry_rules }
