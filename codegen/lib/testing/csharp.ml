(* The testing kit's facts as the C# SDK reads them
   (csharp/sdk/src/Xynolog/Generated/TestingKit.g.cs): the faults, a closed
   record and a case each, a delay held as a TimeSpan; every fault, to draw
   from, the delay and schedule bounds, each its least and its most, and the
   slack, in TestingKit; the delivery steps, each by its word; and the kit's
   records, each member of C#'s type for it, a duration named without its
   unit as the timing is. A member the table's record has a default for is a property to
   initialize, the rest its constructor's. The liveness records are partial:
   what C# holds of them besides, a scenario's end and a spec's clock, is the
   SDK's own (Liveness.cs), as drawing a schedule is. *)

module C = Csharp_syntax
module T = Tables.Client_testing

let path = "csharp/sdk/src/Xynolog/Generated/TestingKit.g.cs"
let t name = C.T name
let system name = C.T ("global::System." ^ name)
let generic name args = C.Generic ("global::System." ^ name, args)
let list_of item = generic "Collections.Generic.IReadOnlyList" [ item ]
let tasks = list_of (system "Threading.Tasks.Task")

(* Each record member's name, its type, and its initial value if it is a
   property to initialize; [Some None] initializes it to nothing. *)
let member ?initial name type_ = (name, type_, initial)

let member_types =
  [
    ( "RequestLogEntry",
      [
        ("channel", member "Channel" (t "string"));
        ("action", member "Action" (t "FaultAction"));
        ("correlationId", member "CorrelationId" (C.Nullable (t "string")));
        ("retryKey", member "RetryKey" (t "string"));
        ("payload", member "Payload" (system "Text.Json.JsonElement"));
      ] );
    ( "LivenessScenario",
      [
        ("outputs", member "Outputs" tasks);
        ("settlements", member "Settlements" tasks);
      ] );
    ( "LivenessSpec",
      [
        ( "setup",
          member "Setup"
            (generic "Func" [ t "FaultyTransport"; t "LivenessScenario" ]) );
        ("timeoutMs", member "Timeout" (system "TimeSpan"));
        ("retryBudget", member "RetryBudget" (t "int"));
        ("cases", member "Cases" (t "int"));
        ( "schedules",
          member "Schedules" ~initial:(Some (C.Collection []))
            (list_of (list_of (t "FaultAction"))) );
        ( "makeResponse",
          member "MakeResponse" ~initial:None (C.Nullable (t "Respond")) );
      ] );
  ]

let record records name =
  let (r : T.records_item), typed = Table.record name records in
  let members = List.map snd typed in
  let positional =
    List.filter_map
      (function
        | name, type_, None -> Some { C.by = `Value; type_; name }
        | _, _, Some _ -> None)
      members
  in
  let initialized =
    List.filter_map
      (function
        | name, type_, Some value ->
            Some
              (C.Property
                 {
                   attributes = [];
                   modifiers = [ Public ];
                   type_;
                   name;
                   accessors = [ Get; Init ];
                   value;
                 })
        | _, _, None -> None)
      members
  in
  C.Type
    {
      attributes = [];
      modifiers =
        (if name = "RequestLogEntry" then [ Public; Sealed ]
         else [ Public; Sealed; Partial ]);
      kind = Record;
      name = r.name;
      params = Some positional;
      base = None;
      body = (match initialized with [] -> None | p -> Some (Packed, p));
    }

let case_type (f : T.fault_actions_item) =
  C.Member_type (t "FaultAction", f.name)

let faults (s : T.t) =
  C.Type
    {
      attributes = [];
      modifiers = [ Public; Closed ];
      kind = Record;
      name = "FaultAction";
      params = None;
      base = None;
      body =
        Some
          ( Packed,
            List.map
              (fun (f : T.fault_actions_item) ->
                C.Nested
                  (C.Type
                     {
                       attributes = [];
                       modifiers = [ Public; Sealed ];
                       kind = Record;
                       name = f.name;
                       params =
                         (match f.holds with
                         | [] -> None
                         | _ ->
                             Some
                               [
                                 {
                                   C.by = `Value;
                                   type_ = system "TimeSpan";
                                   name = "Duration";
                                 };
                               ]);
                       base = Some (t "FaultAction");
                       body = None;
                     }))
              s.fault_actions );
    }

let constant name value =
  C.Field
    {
      modifiers = [ Internal; Const ];
      type_ = t "int";
      name;
      value = Some (C.Int value);
    }

let kit (s : T.t) =
  C.Type
    {
      attributes = [];
      modifiers = [ Internal; Static ];
      kind = Class;
      name = "TestingKit";
      params = None;
      base = None;
      body =
        Some
          ( Packed,
            [
              C.Field
                {
                  modifiers = [ Internal; Static; Readonly ];
                  type_ = list_of (t "FaultAction");
                  name = "Faults";
                  value =
                    Some
                      (C.Collection
                         (List.map
                            (fun (f : T.fault_actions_item) ->
                              C.New
                                {
                                  type_ = Some (case_type f);
                                  args =
                                    Some
                                      (List.map
                                         (fun _ ->
                                           C.Arg
                                             (C.Name
                                                "global::System.TimeSpan.Zero"))
                                         f.holds);
                                  init = None;
                                })
                            s.fault_actions));
                };
              constant "DelayMsMinimum" s.delay_ms.minimum;
              constant "DelayMsMaximum" s.delay_ms.maximum;
              constant "ScheduleLengthMinimum" s.schedule_length.minimum;
              constant "ScheduleLengthMaximum" s.schedule_length.maximum;
              constant "Slack" s.slack.times;
            ] );
    }

let delivery_ops (s : T.t) =
  let serialization = "global::System.Text.Json.Serialization." in
  let name = "DeliveryOp" in
  C.Enum
    {
      attributes =
        [
          {
            C.name = serialization ^ "JsonConverter";
            args =
              [
                Typeof
                  (Generic
                     (serialization ^ "JsonStringEnumConverter", [ T name ]));
              ];
          };
        ];
      modifiers = [ Public ];
      name;
      members =
        List.map
          (fun op ->
            ( [
                {
                  C.name = serialization ^ "JsonStringEnumMemberName";
                  args = [ Str op ];
                };
              ],
              Naming.variant op ))
          s.delivery_ops.ops;
    }

let file table =
  Result.map
    (fun records ->
      {
        Output.path;
        text =
          C.text
            {
              header = Banner.lines ~from_:Table.from_ __FILE__;
              nullable = true;
              usings = [];
              namespace = "Xynolog.Testing";
              decls =
                [
                  faults table;
                  kit table;
                  delivery_ops table;
                  record records "RequestLogEntry";
                  record records "LivenessScenario";
                  record records "LivenessSpec";
                ];
            };
      })
    (Table.typed ~language:"C#" member_types table)
