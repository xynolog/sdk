(* The Python SDK's surface test's calls (python/sdk/tests/surface_calls.py):
   for every method, a function that calls it with a case's arguments, each
   by its keyword and as its parameter's type, so a method the client lacks,
   or one that takes a parameter under another name or as another type, fails
   the type checkers. A [Spread] parameter is taken member by member, each by
   its own keyword; whatever a case leaves out is given as None. A callback
   is given none. What each call returns is the test's to drive: a query's
   fresh read, a worker's first claim, a channel's first event.

   The test's own helpers (tests/surface_arguments.py) read each argument,
   and hold the reader of each client type the SDK writes by hand
   ([Definitions.hand_written_client_types]). *)

module M = Methods
module P = Python_syntax
module S = Tables.Client_surface

let path = "python/sdk/tests/surface_calls.py"
let refuse = Definitions.refuse

let builtins =
  [ "str"; "int"; "float"; "bool"; "bytes"; "None"; "list"; "dict" ]

(* A name the client gives a namespace, a method or a parameter. *)
let python name =
  let n = Text.snake name in
  if List.mem n Python_types.keywords then n ^ "_" else n

(* The name of the adapter that reads a value of type [t]: the type's words,
   in capitals. *)
let rec words = function
  | P.Name n -> [ Text.snake n ]
  | P.Str s -> [ Text.snake s ]
  | P.Subscript (f, items) ->
      words f
      @ ("of" :: List.concat_map (fun e -> words e.P.value) items.elements)
  | P.Binary (a, P.Or, b) -> words a @ ("or" :: words b)
  | t ->
      refuse "the surface reads a value of a type it cannot name: %s" (P.flat t)

let adapter_name t = String.uppercase_ascii (String.concat "_" (words t))

let file ~kinds (typing : Typing.t) methods =
  let adapters = ref [] and hand_read = ref [] in
  let adapter (v : M.value) =
    let t = Python_types.held typing ?at:v.at v.view in
    let name = adapter_name t in
    (match t with
    | P.Name n when List.mem n Definitions.hand_written_client_types ->
        if not (List.mem name !hand_read) then hand_read := name :: !hand_read
    | _ -> (
        match List.assoc_opt name !adapters with
        | Some other when other <> t ->
            refuse "two types the surface reads would both be read by %s" name
        | Some _ -> ()
        | None -> adapters := (name, t) :: !adapters));
    P.Name name
  in
  let call (m : M.method_) =
    let stem = Text.snake (m.namespace ^ "_" ^ m.name) in
    let seen = Hashtbl.create 8 in
    let keyword name value =
      let k = python name in
      if Hashtbl.mem seen k then
        refuse "%s.%s takes two arguments Python would both name %s" m.namespace
          m.name k;
      Hashtbl.replace seen k ();
      [ P.keyword k value ]
    in
    let arguments =
      List.concat_map
        (fun (p : M.parameter) ->
          match p.taken with
          | M.Callback -> []
          | M.Value v ->
              keyword p.name
                (P.call
                   (if p.required then "given" else "maybe")
                   [
                     P.item (P.Name "args");
                     P.item (P.Str p.name);
                     P.item (adapter v);
                   ])
          | M.Spread { members; _ } ->
              List.concat_map
                (fun (member, v) ->
                  keyword member
                    (P.call "member"
                       [
                         P.item (P.Name "args");
                         P.item (P.Str p.name);
                         P.item (P.Str member);
                         P.item (adapter v);
                       ]))
                members)
        m.parameters
    in
    let invoked =
      P.Call
        ( P.Name
            (String.concat "." [ "client"; python m.namespace; python m.name ]),
          P.items arguments )
    in
    let def ~params ~returns body =
      P.Def { name = stem; params; returns; doc = None; body }
    in
    let calling = [ ("client", P.Name "Client"); ("args", P.Name "Args") ] in
    let awaited =
      P.Binary
        (P.sub "Awaitable" [ P.item (P.Name "object") ], P.Or, P.Name "None")
    in
    match m.shape with
    | S.Events ->
        `Events
          (def
             ~params:[ ("client", P.Name "Client") ]
             ~returns:(P.sub "Awaitable" [ P.item (P.Name "JsonObject") ])
             [ P.Return (P.call "first_payload" [ P.item invoked ]) ])
    | S.Signal ->
        `Calls
          (def ~params:calling ~returns:awaited
             [ P.Do invoked; P.Return (P.Name "None") ])
    | S.Cache ->
        `Calls
          (def ~params:calling ~returns:awaited
             [ P.Return (P.call "fresh" [ P.item invoked ]) ])
    | S.Claims ->
        `Calls
          (def ~params:calling ~returns:awaited
             [ P.Return (P.call "anext" [ P.item invoked ]) ])
    | S.Promise | S.Stream | S.Delegation | S.Upload | S.Count ->
        `Calls (def ~params:calling ~returns:awaited [ P.Return invoked ])
  in
  let made = List.map (fun (m : M.method_) -> (m, call m)) methods in
  let table name ~type_ pick =
    P.assign name
      ~annotation:
        (P.sub "Final"
           [
             P.item
               (P.sub "dict"
                  [
                    P.item
                      (P.sub "tuple"
                         [ P.item (P.Name "str"); P.item (P.Name "str") ]);
                    P.item type_;
                  ]);
           ])
      ~value:
        (P.Dict
           (P.items ~magic:true
              (List.filter_map
                 (fun ((m : M.method_), made) ->
                   Option.map
                     (fun () ->
                       P.entry
                         (P.tuple
                            [
                              P.item (P.Str m.namespace); P.item (P.Str m.name);
                            ])
                         (P.Name (Text.snake (m.namespace ^ "_" ^ m.name))))
                     (pick made))
                 made)))
  in
  let defs = List.map (function _, (`Calls d | `Events d) -> d) made in
  let adapters = List.sort compare !adapters in
  let named =
    List.sort_uniq compare
      (List.concat_map (fun (_, t) -> Python_types.names_in t) adapters)
  in
  let from_types =
    List.filter
      (fun n ->
        not
          (List.mem n builtins || List.mem n kinds || n = "Literal"
         || n = "JsonValue"))
      named
  in
  let listed names = List.filter (fun n -> List.mem n named) names in
  {
    Output.path;
    text =
      P.text
        {
          header =
            Banner.python_lines ~from_:"protocol/specs/src/client/surface.json"
              __FILE__;
          doc =
            As_is
              "Every method of the client's surface, called with a case's \
               arguments: each by its\n\
               keyword and as its parameter's type, so a method the client \
               lacks, or one that\n\
               takes a parameter under another name or as another type, fails \
               the type checkers.\n";
          imports =
            [
              [
                P.From ("collections.abc", [ "Awaitable"; "Callable" ]);
                P.From ("typing", "Final" :: listed [ "Literal" ]);
              ];
              [ P.From ("pydantic", "TypeAdapter" :: listed [ "JsonValue" ]) ];
              ([
                 P.From ("spec", [ "JsonObject" ]);
                 P.From
                   ( "surface_arguments",
                     [
                       "Args";
                       "Client";
                       "first_payload";
                       "fresh";
                       "given";
                       "maybe";
                       "member";
                     ]
                     @ List.sort compare !hand_read );
               ]
              @ (match listed (List.sort compare kinds) with
                | [] -> []
                | ids -> [ P.From ("xynolog.identifiers", ids) ])
              @
              match from_types with
              | [] -> []
              | types -> [ P.From ("xynolog.types", types) ]);
            ];
          body =
            P.Adjacent
              (List.map
                 (fun (name, t) ->
                   P.assign name ~annotation:(P.Name "Final")
                     ~value:
                       (P.Call
                          ( P.sub "TypeAdapter" [ P.item t ],
                            P.items [ P.item t ] )))
                 adapters)
            :: defs
            @ [
                table "CALLS"
                  ~type_:
                    (P.sub "Callable"
                       [
                         P.item
                           (P.List
                              (P.items
                                 [
                                   P.item (P.Name "Client");
                                   P.item (P.Name "Args");
                                 ]));
                         P.item
                           (P.Binary
                              ( P.sub "Awaitable" [ P.item (P.Name "object") ],
                                P.Or,
                                P.Name "None" ));
                       ])
                  (function `Calls _ -> Some () | `Events _ -> None);
                table "EVENTS"
                  ~type_:
                    (P.sub "Callable"
                       [
                         P.item (P.List (P.items [ P.item (P.Name "Client") ]));
                         P.item
                           (P.sub "Awaitable" [ P.item (P.Name "JsonObject") ]);
                       ])
                  (function `Events _ -> Some () | `Calls _ -> None);
              ];
        };
  }
