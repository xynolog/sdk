(* The timing as the Python SDK reads it (python/sdk/src/xynolog): a constant
   per entry under its name in upper case, and the names as the table states
   them, by which a caller overrides one. *)

module P = Python_syntax

let path = "python/sdk/src/xynolog/timing.py"
let name (e : Table.entry) = Text.upper_snake e.name

let value (e : Table.entry) =
  match e.value with
  | Duration n | Count n -> P.Int n
  | Budget { attempts; initial_delay_ms; max_delay_ms } ->
      P.call "RetryPolicy"
        [
          P.keyword "attempts" (P.Int attempts);
          P.keyword "initial_delay_ms" (P.Int initial_delay_ms);
          P.keyword "max_delay_ms" (P.Int max_delay_ms);
        ]

let text (t : Table.t) =
  P.text
    {
      header =
        Banner.python_lines ~from_:"protocol/specs/src/client/timing.json"
          __FILE__;
      doc =
        As_is
          "The timing a Xynolog client keeps: its deadlines, its retry \
           budgets, the\n\
           cadence of its stream, and what it keeps count of.\n\n\
           Each constant is an entry of the table every SDK generates from, \
           under the\n\
           entry's own name: `emitRetry` is `EMIT_RETRY`. `TIMING_NAMES` lists \
           the names\n\
           as the table states them, which is how a caller overrides one.\n";
      imports =
        [
          [ P.From ("typing", [ "Final" ]) ];
          [ P.From ("xynolog.retry", [ "RetryPolicy" ]) ];
        ];
      body =
        P.assign "__all__"
          ~value:
            (P.List
               (P.items ~magic:true
                  (List.map
                     (fun n -> P.item (P.Str n))
                     (List.sort compare ("TIMING_NAMES" :: List.map name t)))))
        :: List.map
             (fun (e : Table.entry) ->
               P.assign ~about:[ Prose e.docs ] ~annotation:(P.Name "Final")
                 ~value:(value e) (name e))
             t
        @ [
            P.assign
              ~about:[ Line "Every entry's name, as the table states it." ]
              ~annotation:
                (P.sub "Final"
                   [
                     P.item
                       (P.sub "tuple"
                          [ P.item (P.Name "str"); P.item P.Ellipsis ]);
                   ])
              ~value:
                (P.strings ~magic:true
                   (List.map (fun (e : Table.entry) -> e.name) t))
              "TIMING_NAMES";
          ];
    }

let file t = { Output.path; text = text t }
