(* The worker's channels as the C# SDK names them (WorkerRules, in
   csharp/sdk/src/Xynolog/Generated/WorkerRules.g.cs, a part of the class
   Jobs/WorkerRules.cs writes the rest of): a list of channel names per
   constant, under its name in Pascal case. *)

module C = Csharp_syntax

let path = "csharp/sdk/src/Xynolog/Generated/WorkerRules.g.cs"

let file (constants : Table.t list) =
  {
    Output.path;
    text =
      C.text
        {
          header =
            Banner.lines
              ~from_:
                ("protocol/specs/src/" ^ Table.file ^ " and bus/registry.json")
              __FILE__;
          nullable = false;
          usings = [];
          namespace = "Xynolog.Jobs";
          decls =
            [
              C.Type
                {
                  attributes = [];
                  modifiers = [ C.Public; Static; Partial ];
                  kind = Class;
                  name = "WorkerRules";
                  params = None;
                  base = None;
                  body =
                    Some
                      ( Packed,
                        List.map
                          (fun (c : Table.t) ->
                            C.Documented
                              ( Table.doc c,
                                C.Field
                                  {
                                    modifiers = [ Public; Static; Readonly ];
                                    type_ =
                                      Generic ("IReadOnlyList", [ T "string" ]);
                                    name = String.capitalize_ascii c.member;
                                    value =
                                      Some
                                        (Collection
                                           (List.map
                                              (fun n -> C.Str n)
                                              c.channels));
                                  } ))
                          constants );
                };
            ];
        };
  }
