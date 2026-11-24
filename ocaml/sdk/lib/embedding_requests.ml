(* Generated from protocol/specs/src/embedding/requests.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type providers_value = { texts_per_request : int; at_once : int }

let providers_value_json (r : providers_value) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("textsPerRequest", (fun n -> `Int n) r.texts_per_request);
         Option.Some ("atOnce", (fun n -> `Int n) r.at_once);
       ])

type busy = { statuses : int list; again_after_seconds : int list }

let busy_json (r : busy) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some
           ( "statuses",
             (fun l -> `List (List.map (fun n -> `Int n) l)) r.statuses );
         Option.Some
           ( "againAfterSeconds",
             (fun l -> `List (List.map (fun n -> `Int n) l))
               r.again_after_seconds );
       ])

type t = {
  comment : string;
  providers : (string * providers_value) list;
  request_seconds : int;
  busy : busy;
  start_again : int;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ( "providers",
             (fun l ->
               `Assoc (List.map (fun (k, v) -> (k, providers_value_json v)) l))
               r.providers );
         Option.Some ("requestSeconds", (fun n -> `Int n) r.request_seconds);
         Option.Some ("busy", busy_json r.busy);
         Option.Some ("startAgain", (fun n -> `Int n) r.start_again);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for how a service asks its embedding provider for vectors \
        (SMELTER.md \194\167 The embedding provider), as `xynolog-vectors` \
        asks for every service that embeds. `providers` states, for each kind \
        of provider, how many texts a request carries and how many requests \
        are made of it at once. `requestSeconds` is each request's own time. \
        `busy` is which statuses say a provider is busy, and how long a \
        request for documents waits before each asking again. `startAgain` is \
        how many times a starting service asks again a provider that is still \
        fetching its model, or still starting.";
     providers =
       [
         ("ollama", ({ texts_per_request = 128; at_once = 1 } : providers_value));
         ("voyage", ({ texts_per_request = 128; at_once = 4 } : providers_value));
       ];
     request_seconds = 15;
     busy =
       ({ statuses = [ 429; 503 ]; again_after_seconds = [ 1; 2; 4 ] } : busy);
     start_again = 12;
   }
    : t)
