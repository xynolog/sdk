(* What a writer of types reads of a schema in [Definitions]' view, whatever
   language it writes: the schema a [$ref] names, a union's members, the one
   value a schema admits, and the schema without its [null]. An [allOf] is
   read as [Definitions.meant] has it. *)

module D = Definitions

let refuse = D.refuse

let reference (s : D.t) =
  match s with D.Ref { name; _ } -> Some name | _ -> None

let union (s : D.t) =
  match s with
  | D.Node { one_of = Some members; _ } -> Some members
  | D.Node { any_of = Some members; _ } -> Some members
  | _ -> None

let node (s : D.t) = match s with D.Node n -> Some n | _ -> None

(* The one string a schema admits, when it admits exactly one. *)
let only_value (s : D.t) =
  match s with
  | D.Node { enum = Some [ Schema.String_literal v ]; _ } -> Some v
  | _ -> None

(* A schema that also admits null, as the schema without it. *)
let without_null (s : D.t) =
  match union s with
  | Some members -> (
      let others = List.filter (fun m -> m <> D.Null) members in
      if List.length others = List.length members then None
      else
        match others with
        | [ only ] -> Some only
        | _ -> Some (D.Node { (D.node [ "anyOf" ]) with any_of = Some others }))
  | None -> (
      match s with
      | D.Node ({ type_ = Some (D.Or_null t); _ } as n) ->
          Some (D.Node { n with type_ = Some (D.One t) })
      | _ -> None)

(* The single value an object's discriminating property takes: the first of
   its properties that admits exactly one string. *)
let discriminant (s : D.t) =
  match s with
  | D.Node { properties = Some ps; _ } ->
      List.find_map (fun (_, p) -> only_value p) ps
  | _ -> None

(* What [s] says of itself, or, when it only admits null beside another
   schema, what that schema says: never what a schema its [allOf] names says,
   which the view gives a schema that states one. *)
let rec description (s : D.t) =
  let own (n : D.node) =
    if List.mem "description" n.keys then n.description else None
  in
  match s with
  | D.Ref { description; _ } -> description
  | D.Node n when own n <> None -> own n
  | D.Node { any_of = Some [ D.Null; inner ]; _ } -> description inner
  | _ -> None

(* [s], or the component schema it names. *)
let resolved (definitions : D.definitions) (s : D.t) =
  match reference s with Some name -> definitions.schema name | None -> s

(* Whether a schema is a string, following [$ref]s and unions of strings. *)
let rec is_string definitions (s : D.t) =
  match reference s with
  | Some _ -> is_string definitions (resolved definitions s)
  | None -> (
      match union s with
      | Some members -> List.for_all (is_string definitions) members
      | None -> (
          match s with
          | D.Node { type_ = Some (D.One String); enum = None; _ } -> true
          | _ -> false))

(* The value of [property] each member of a union states, when every member
   is an object that must state it, each admits one value, and no two admit
   the same: the property then says which member a value is. *)
let tags definitions property members =
  let rec go acc = function
    | [] -> Some (List.rev acc)
    | member :: rest -> (
        match D.meant (resolved definitions member) with
        | D.Node { required = Some required; properties = Some ps; _ }
          when List.mem property required -> (
            match Option.bind (List.assoc_opt property ps) only_value with
            | Some tag when not (List.mem tag acc) -> go (tag :: acc) rest
            | _ -> None)
        | _ -> None)
  in
  go [] members
