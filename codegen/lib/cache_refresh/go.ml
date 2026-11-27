(* The refresh table as the Go SDK reads it (go/refresh_gen.go): the queries,
   the type of the value each one's cache holds as a type of package api, the
   triggers, how each channel of them reads a frame (by its typed value in
   package bus), the interface the client's refresher implements, a method per
   query a row acts on each way, and how the client keeps the queries the table
   persists. A query a row comes to act on, or one the table comes to persist,
   is a method or a cache the client lacks, so Go does not compile until it is
   answered. *)

module G = Go_syntax

let path = "go/refresh_gen.go"
let name = Bus.Go.name
let query_const name' = "CacheQuery" ^ name name'
let trigger_const on = "CacheRefresh" ^ name on

let queries names =
  G.inline ~of_:(G.Slice (G.Named "CacheQuery"))
    (List.map (fun q -> G.item (G.Name (query_const q))) names)

let rec go_type : Table.value_type -> G.type_ = function
  | Component name -> G.Named ("api." ^ name)
  | List t -> G.Slice (go_type t)
  | Text -> G.Named "string"

let way parts =
  G.inline ~of_:(G.Named "CacheRefreshWay")
    (List.map (fun p -> G.item (G.Quoted p)) parts)

let row (r : Table.row) =
  G.inline
    (List.concat
       [
         (match r.when_ with
         | Some Enriched ->
             [ G.keyed "When" (G.Name "CacheRefreshWhenEnriched") ]
         | Some Unenriched ->
             [ G.keyed "When" (G.Name "CacheRefreshWhenUnenriched") ]
         | None -> []);
         [
           G.keyed "Reach"
             (G.Name
                (match r.reach with
                | Subject -> "CacheRefreshReachSubject"
                | Held -> "CacheRefreshReachHeld"));
         ];
         (match
            List.filter_map
              (fun (field, w) -> Option.map (fun w -> G.keyed field (way w)) w)
              [ ("Resource", r.resource); ("Annotation", r.annotation) ]
          with
         | [] -> []
         | names ->
             [
               G.keyed "Names"
                 (G.inline ~of_:(G.Named "CacheRefreshNames") names);
             ]);
         Option.to_list
           (Option.map (fun w -> G.keyed "Carries" (way w)) r.carries);
         List.filter_map
           (fun (field, qs) ->
             if qs = [] then None else Some (G.keyed field (queries qs)))
           [
             ("Refetches", r.refetches);
             ("Writes", r.writes);
             ("Removes", r.removes);
           ];
       ])

(* The queries some row acts on: by [act], in the table's order. *)
let acted (t : Table.t) act =
  List.filter_map
    (fun (q : Table.query) ->
      if
        List.exists
          (fun (trigger : Table.trigger) ->
            List.exists (fun r -> List.mem q.name (act r)) trigger.rows)
          t.triggers
      then Some q.name
      else None)
    t.queries

let refetched t = acted t (fun (r : Table.row) -> r.refetches)
let written t = acted t (fun (r : Table.row) -> r.writes)
let removed t = acted t (fun (r : Table.row) -> r.removes)
let subject = ("subject", G.Named "cacheSubject")
let reach = ("reach", G.Named "CacheRefreshReach")

(* For each query of [row]'s [field], the act of [verb] on it. *)
let applying ~field verb ~reach names =
  G.Range
    {
      key = "_";
      value = "query";
      over = G.Name ("row." ^ field);
      body =
        [
          G.Switch
            {
              tag = Some (G.Name "query");
              cases =
                List.map
                  (fun q ->
                    ( [ G.Name (query_const q) ],
                      [
                        G.Do
                          (G.call
                             ("acts." ^ verb ^ name q)
                             ((if reach then [ G.Name "row.Reach" ] else [])
                             @ [ G.Name "subject" ]));
                      ] ))
                  names;
              default = None;
            };
        ];
    }

let text (t : Table.t) =
  let channels =
    List.filter_map
      (fun (trigger : Table.trigger) ->
        match trigger.kind with
        | Channel { scoped } -> Some (trigger.name, scoped)
        | Reopened | Unreadable -> None)
      t.triggers
  in
  let persisted =
    List.filter_map
      (fun (q : Table.query) -> if q.persisted then Some q.name else None)
      t.queries
  in
  let trigger = G.Named "CacheRefreshTrigger" in
  G.text
    {
      header =
        G.verbatim
          "Code generated from protocol/specs/src/client/refresh.json; DO NOT \
           EDIT.\n\n\
           Regenerate: make generate (codegen/lib/cache_refresh/go.ml)";
      package = "xynolog";
      imports =
        [ [ "github.com/xynolog/sdk/go/api"; "github.com/xynolog/sdk/go/bus" ] ];
      decls =
        [
          G.Consts
            {
              doc = [ G.Line "The live queries a client's cache answers." ];
              spacing = G.Spaced;
              specs =
                List.map
                  (fun (q : Table.query) ->
                    G.spec ~doc:(G.prose q.docs) ~type_:(G.Named "CacheQuery")
                      (query_const q.name) (G.Quoted q.name))
                  t.queries;
            };
          G.Var
            (G.spec
               ~doc:
                 [
                   G.Line
                     "CacheQueries is every live query, in the table's order.";
                 ]
               "CacheQueries"
               (queries (List.map (fun (q : Table.query) -> q.name) t.queries)));
          G.Var
            (G.spec
               ~doc:
                 (G.verbatim
                    "PersistedCacheQueries is every live query a client keeps \
                     in its storage,\n\
                     in the table's order: each under its name (CacheKey).")
               "PersistedCacheQueries" (queries persisted));
          G.Aliases
            {
              doc =
                G.verbatim
                  "The type of the value each live query's cache holds for a \
                   key: the table's\n\
                   `value`, a component or a member within one.";
              specs =
                List.map
                  (fun (q : Table.query) ->
                    (q.name ^ "Value", go_type q.value.type_))
                  t.queries;
            };
          G.Consts
            {
              doc = [ G.Line "The triggers of the table." ];
              spacing = G.Packed;
              specs =
                List.map
                  (fun (tr : Table.trigger) ->
                    G.spec ~type_:trigger (trigger_const tr.name)
                      (G.Quoted tr.name))
                  t.triggers;
            };
          G.Var
            (G.spec
               ~doc:
                 (G.verbatim
                    "CacheRefreshChannels is each trigger of the table that is \
                     a channel of the\n\
                     bus, in the table's order.")
               "CacheRefreshChannels"
               (G.inline ~of_:(G.Slice trigger)
                  (List.map
                     (fun (on, _) -> G.item (G.Name (trigger_const on)))
                     channels)));
          G.Var
            (G.spec
               ~doc:[ G.Line "CacheRefreshTable is each trigger's rows." ]
               "CacheRefreshTable"
               (G.lines ~spacing:G.Spaced
                  ~of_:(G.Map (trigger, G.Slice (G.Named "CacheRefresh")))
                  (List.map
                     (fun (tr : Table.trigger) ->
                       G.element ~about:(G.prose tr.docs)
                         ~key:(G.Name (trigger_const tr.name))
                         (G.lines (List.map (fun r -> G.item (row r)) tr.rows)))
                     t.triggers)));
          G.Var
            (G.spec
               ~doc:
                 (G.verbatim
                    "cacheRefreshReadings is how each channel of the table \
                     reads a frame:\n\
                     whether its payload is one of the channel's.")
               "cacheRefreshReadings"
               (G.lines
                  ~of_:
                    (G.Map
                       ( trigger,
                         G.Func_type ([ G.Named "Frame" ], [ G.Named "bool" ])
                       ))
                  (List.map
                     (fun (on, scoped) ->
                       G.keyed (trigger_const on)
                         (G.call
                            (if scoped then "scopedReadingOf" else "readingOf")
                            [ G.Name ("bus." ^ name on) ]))
                     channels)));
          G.Type
            {
              doc =
                G.verbatim
                  "cacheActs is what the client's refresher does to each live \
                   query a row acts\n\
                   on. A query a row comes to act on is a method it lacks.";
              name = "cacheActs";
              def =
                G.Interface
                  (List.concat
                     [
                       List.map
                         (fun q ->
                           G.method_ ("refetch" ^ name q) [ reach; subject ])
                         (refetched t);
                       List.map
                         (fun q -> G.method_ ("write" ^ name q) [ subject ])
                         (written t);
                       List.map
                         (fun q -> G.method_ ("remove" ^ name q) [ subject ])
                         (removed t);
                     ]);
            };
          G.func
            ~doc:
              (G.verbatim
                 "applyRefresh applies row to what subject names, by acts: its \
                  writes, its\n\
                  removes, then its refetches.")
            ~params:
              [
                ("acts", G.Named "cacheActs");
                ("row", G.Named "CacheRefresh");
                subject;
              ]
            "applyRefresh"
            (G.Block
               [
                 applying ~field:"Writes" "write" ~reach:false (written t);
                 applying ~field:"Removes" "remove" ~reach:false (removed t);
                 applying ~field:"Refetches" "refetch" ~reach:true (refetched t);
               ]);
          G.func
            ~doc:
              (G.verbatim
                 "attach has the caches of the queries the table persists keep \
                  their values\n\
                  in persistence from now on, each beginning with what it kept.")
            ~receiver:("v", G.Pointer (G.Named "live"))
            ~params:[ ("persistence", G.Pointer (G.Named "CachePersistence")) ]
            "attach"
            (G.Block
               (List.map
                  (fun q ->
                    G.Do
                      (G.call "keepIn"
                         [
                           G.Name ("v." ^ q);
                           G.Name "persistence";
                           G.Name (query_const q);
                         ]))
                  persisted));
        ];
    }

let file t = { Output.path; text = text t }
