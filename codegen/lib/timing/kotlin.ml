(* The timing as the Kotlin SDK reads it: in xynolog.Timings a constant per
   entry, [busRequestTimeoutMs] as [BUS_REQUEST_TIMEOUT_MS], a budget a
   RetryBudget; and beside it the data classes of what a caller may set. *)

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

(* A record's member: its default is the constant's value, and a count is an
   [Int]. *)
let parameter (e : Table.entry) =
  let constant = "Timings." ^ Kotlin_sdk.Names.camel_constant e.name in
  let type_, default =
    match e.value with
    | Duration _ -> ("Long", K.Name constant)
    | Count _ -> ("Int", K.call (K.Member (K.Name constant, "toInt")) [])
    | Budget _ -> ("RetryBudget", K.Name constant)
  in
  {
    K.about = Some (K.Doc e.docs);
    annotations = [];
    binding = Bound { visibility = Public; mutable_ = false };
    name = e.name;
    type_ = K.Type type_;
    default = Some default;
  }

let record (t : Table.t) record =
  K.class_
    ~about:(K.Doc (Table.record_docs record))
    ~visibility:K.Public
    ~constructor:
      (K.constructor
         ~annotations:[ K.annotation "JvmOverloads" ]
         (List.map parameter (Table.members record t)))
    K.Data_class (Table.record_name record)

let file (t : Table.t) =
  Kotlin_sdk.table ~from_:Table.file __FILE__ ~package:"xynolog" ~name:"Timings"
    ~imports:[ "xynolog.types.RetryBudget" ]
    ([
       K.class_
         ~about:
           (K.Doc
              ("The timing a client keeps (protocol/specs/src/" ^ Table.file
             ^ ")."))
         ~visibility:K.Internal
         ~members:[ K.Packed (List.map member t) ]
         K.Object "Timings";
     ]
    @ List.map (record t) Table.records)
