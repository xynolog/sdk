(* Shared worker filter cases from jobs/filter-cases.json. *)
module T = Protocol_cases.Jobs_filter_cases

let () =
  List.iter
    (fun (row : T.cases_item) ->
      Alcotest.(check bool)
        row.why row.matches
        (Xynolog.Worker.accepts ~filters:(`List [ row.filter ])
           ~announcement:(T.job_json row.job)))
    T.table.cases
