(* The refresh table as the Rust SDK reads it (rust/sdk/src/refresh.rs): its
   queries, its triggers, which of them are channels of the registry, and
   each trigger's rows, their ways the names of the members they are
   within; and the cache of each persisted query as the browse namespace's
   [Live] holds it (rust/sdk/src/namespaces/browse.rs), in the field named
   after the query, so a persisted query with no such field fails to
   compile. *)

module R = Rust_syntax
module T = Tables.Client_refresh

let from_ = "protocol/specs/src/client/refresh.json"
let variant name = Text.pascal name
let query name = R.Path [ "CacheQuery"; variant name ]
let trigger on = R.Path [ "RefreshTrigger"; Text.pascal on ]
let some e = R.call "Some" [ e ]
let slice items = R.Ref_of (R.Array items)
let static_slice name = R.Ref (Some "'static", R.Slice (R.named name))

let derives =
  R.List
    ( [ "derive" ],
      List.map
        (fun w -> R.Word [ w ])
        [ "Debug"; "Clone"; "Copy"; "PartialEq"; "Eq"; "Hash" ] )

let const ~doc name ty value =
  R.I_const { doc = [ doc ]; vis = Pub; name; ty; value = Some value }

let method_ ~doc name ~ret arms =
  R.I_fn
    (R.fn_ ~doc:[ doc ] ~vis:Pub ~const:true name ~params:[ R.Self_value ] ~ret
       [ R.Tail (R.Match (R.p "self", arms)) ])

(* What the Rust SDK can do without asking: an event carries an
   annotation's new value, and says an annotation is gone. A row that says
   more needs code that reads it. *)
let able (t : Table.t) =
  let refused (tr : Table.trigger) key name =
    {
      Decode.file = Table.file;
      pointer = "/refresh";
      message =
        Printf.sprintf "%s %s %s, which no event the Rust SDK reads says how to"
          tr.name key name;
    }
  in
  List.concat_map
    (fun (tr : Table.trigger) ->
      List.concat_map
        (fun (row : Table.row) ->
          List.filter_map
            (fun name ->
              if List.mem name [ "annotations"; "annotation" ] then None
              else Some (refused tr "writes" name))
            row.writes
          @ List.filter_map
              (fun name ->
                if name = "annotation" then None
                else Some (refused tr "removes" name))
              row.removes)
        tr.rows)
    t.triggers

let way = function
  | None -> R.p "None"
  | Some names -> some (slice (List.map (fun n -> R.Str n) names))

let row (r : Table.row) =
  R.Struct
    ( [ "CacheRefresh" ],
      [
        ( "when",
          match r.when_ with
          | None -> R.p "None"
          | Some Enriched -> some (R.p "RefreshWhen::Enriched")
          | Some Unenriched -> some (R.p "RefreshWhen::Unenriched") );
        ( "reach",
          match r.reach with
          | Subject -> R.p "Reach::Subject"
          | Held -> R.p "Reach::Held" );
        ( "names",
          R.Struct
            ( [ "RefreshNames" ],
              [ ("resource", way r.resource); ("annotation", way r.annotation) ],
              None ) );
        ("carries", way r.carries);
        ("refetches", slice (List.map query r.refetches));
        ("writes", slice (List.map query r.writes));
        ("removes", slice (List.map query r.removes));
      ],
      None )

let cache_refresh (table : T.t) (t : Table.t) =
  let docs on =
    String.concat " "
      (List.filter_map
         (fun (item : T.refresh_item) ->
           if Table.trigger_name item = on then Some (Table.docs_of item)
           else None)
         table.refresh)
  in
  let persisted =
    List.filter (fun (q : Table.query) -> q.persisted) t.queries
  in
  {
    Output.path = "rust/sdk/src/generated/cache_refresh.rs";
    text =
      R.text
        ~header:(Banner.lines ~from_ __FILE__)
        [
          R.Enum
            {
              doc = [ "The live queries a client's cache answers." ];
              attrs = [ derives ];
              vis = Pub;
              name = "CacheQuery";
              variants =
                List.map
                  (fun (q : Table.query) ->
                    R.variant ~doc:[ q.docs ] (variant q.name))
                  t.queries;
            };
          R.Blank;
          R.Impl
            {
              generics = [];
              trait_ = None;
              for_ = R.named "CacheQuery";
              items =
                [
                  const ~doc:"Every query, in the table's order." "ALL"
                    (static_slice "CacheQuery")
                    (slice
                       (List.map
                          (fun (q : Table.query) -> query q.name)
                          t.queries));
                  R.I_blank;
                  const
                    ~doc:
                      "The queries whose answers a client keeps across its \
                       lives, for the person signed in, in the table's order."
                    "PERSISTED"
                    (static_slice "CacheQuery")
                    (slice
                       (List.map
                          (fun (q : Table.query) -> query q.name)
                          persisted));
                  R.I_blank;
                  method_
                    ~doc:
                      "The query's name, as the table and every SDK spell it."
                    "name" ~ret:R.static_str
                    (List.map
                       (fun (q : Table.query) -> (query q.name, R.Str q.name))
                       t.queries);
                ];
            };
          R.Blank;
          R.Enum
            {
              doc =
                [
                  "What refreshes a cache: the events of a channel, or a \
                   trigger that is no channel's: `Reopened`, the stream open \
                   again after a drop, and `Unreadable`, an event that cannot \
                   be read.";
                ];
              attrs = [ derives ];
              vis = Pub;
              name = "RefreshTrigger";
              variants =
                List.map
                  (fun (tr : Table.trigger) ->
                    R.variant ~doc:[ docs tr.name ] (Text.pascal tr.name))
                  t.triggers;
            };
          R.Blank;
          R.Impl
            {
              generics = [];
              trait_ = None;
              for_ = R.named "RefreshTrigger";
              items =
                [
                  const ~doc:"Every trigger, in the table's order." "ALL"
                    (static_slice "RefreshTrigger")
                    (slice
                       (List.map
                          (fun (tr : Table.trigger) -> trigger tr.name)
                          t.triggers));
                  R.I_blank;
                  method_
                    ~doc:
                      "The channel whose events are this trigger; none of a \
                       trigger that is no channel."
                    "channel"
                    ~ret:(R.named "Option" ~args:[ R.static_str ])
                    (List.map
                       (fun (tr : Table.trigger) ->
                         ( trigger tr.name,
                           match tr.kind with
                           | Channel _ -> some (R.Str tr.name)
                           | Reopened | Unreadable -> R.p "None" ))
                       t.triggers);
                  R.I_blank;
                  method_
                    ~doc:
                      "What this trigger does: one row, or two for a channel \
                       whose events come two ways."
                    "rows"
                    ~ret:(static_slice "CacheRefresh")
                    (List.map
                       (fun (tr : Table.trigger) ->
                         (trigger tr.name, slice (List.map row tr.rows)))
                       t.triggers);
                ];
            };
        ];
  }

let live_kept (t : Table.t) =
  let persisted =
    List.filter (fun (q : Table.query) -> q.persisted) t.queries
  in
  {
    Output.path = "rust/sdk/src/generated/live_kept.rs";
    text =
      R.text
        ~header:(Banner.lines ~from_ __FILE__)
        [
          R.Impl
            {
              generics = [];
              trait_ = None;
              for_ = R.named "Live";
              items =
                [
                  R.I_fn
                    (R.fn_
                       ~doc:
                         [
                           "The cache of each query \
                            protocol/specs/src/client/refresh.json persists, \
                            in the table's order.";
                         ]
                       "kept" ~params:[ R.Self_ref ]
                       ~ret:
                         (R.Array_of
                            ( R.Tuple_of
                                [
                                  R.named "CacheQuery";
                                  R.Ref (None, R.Dyn (R.named "Kept"));
                                ],
                              List.length persisted ))
                       [
                         R.Tail
                           (R.Array
                              (List.map
                                 (fun (q : Table.query) ->
                                   R.Tuple
                                     [
                                       query q.name;
                                       R.Ref_of
                                         (R.Field (R.p "self", R.snake q.name));
                                     ])
                                 persisted));
                       ]);
                ];
            };
        ];
  }

let files (table : T.t) (t : Table.t) =
  match able t with
  | [] -> Ok [ cache_refresh table t; live_kept t ]
  | refusals -> Error refusals
