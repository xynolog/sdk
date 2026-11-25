(* The timing as the Kotlin SDK reads it (xynolog.Timings): a constant per
   entry, [busRequestTimeoutMs] as [BUS_REQUEST_TIMEOUT_MS], a budget a
   RetryBudget. *)

module K = Kotlin_syntax

let member (e : Table.entry) =
  let name = Kotlin_sdk.Names.camel_constant e.name in
  match e.value with
  | Duration n | Count n ->
      K.property ~const:true ~type_:(K.Type "Long")
        ~value:(K.Same_line (K.Int n)) name
  | Budget { attempts; initial_delay_ms; max_delay_ms } ->
      K.property ~type_:(K.Type "RetryBudget")
        ~value:
          (K.Same_line
             (K.named_call (K.Name "RetryBudget")
                [
                  ("attempts", K.Int attempts);
                  ("initialDelayMs", K.Int initial_delay_ms);
                  ("maxDelayMs", K.Int max_delay_ms);
                ]))
        name

let file (t : Table.t) =
  Kotlin_sdk.table ~from_:Table.file __FILE__ ~package:"xynolog" ~name:"Timings"
    ~imports:[ "xynolog.types.RetryBudget" ]
    [
      K.class_
        ~about:
          (K.Doc
             ("The timing a client keeps (protocol/specs/src/" ^ Table.file
            ^ ")."))
        ~visibility:K.Internal
        ~members:[ K.Packed (List.map member t) ]
        K.Object "Timings";
    ]
