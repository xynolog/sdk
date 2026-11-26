(* Protocol's schemas as the type writers of every SDK read them, decided once:
   the schemas a generation is rooted on and every one they reach, each a
   declaration of one [form]; each schema written in place within them, read
   as what it holds ([ty]), and named where it is a type of its own; and each
   union's members told apart by what each admits ([signature]), proved to
   admit no value in common. A writer spells what this says; it decides no
   shape of its own. What a writer still decides differently is a named
   deviation of [Deviations].

   It reads [Definitions]' view of a schema: references resolved, null and
   [allOf] read as [Definitions] reads them. *)

module D = Definitions

let refuse = D.refuse

type literal = Schema.literal

type scalar =
  | Text of { binary : bool; pattern : string option }
  | Code of string
      (** A code of the errors/codes.json vocabulary it names, which each SDK's
          error codes declare. *)
  | Word of string
      (** A word of the table of words ([Word_tables]) it names by its file. *)
  | Integer of { minimum : float option; maximum : float option }
  | Number
  | Boolean

(* Where a schema written in place is: the schema whose member it is, and the
   part of that schema it is ([member], [memberItem], [memberValue], or a
   union's member by its variant). A member an [allOf] child inherits is the
   parent's ([Definitions.owners]), so the one schema has the one place. *)
type place = { owner : string; part : string }

(* What an object holds beside the members it names. One that says nothing
   of them ([Unstated]) holds none: they are read past, not refused as
   [Closed] refuses them, and never written back. JSON Schema reads it as
   holding any, but Protocol states an object that holds any ([Open]) where
   it means one. *)
type rest = Closed | Unstated | Open | Of of ty

(* What a value holds where it is stated. *)
and ty =
  | Named of string  (** A schema of the generation, by its name. *)
  | Inline of inline  (** An object, enumeration, union or [allOf] in place. *)
  | Scalar of scalar
  | Null
  | List of ty option  (** What it holds, if it says. *)
  | Nullable of ty  (** [ty], or null. *)
  | Any  (** Any value: a schema that constrains nothing. *)
  | Nothing  (** No value: [false]. *)

and inline = {
  name : string;
      (** The name a writer declares it by ([Naming.inline] of its place), where
          it is a type of its own: an object of members, an enumeration, a union
          or an [allOf], no two of which in place share a name. *)
  place : place;
  description : string option;  (** As [member.description]. *)
  node_description : string option;  (** As [member.node_description]. *)
  form : form;
  composition : composition option;
}

and form =
  | Record of { members : member list; rest : rest }
      (** An object that names its members, in the schema's order. *)
  | Empty of { rest : rest; none : bool }
      (** An object that names no member: it holds none when it says
          [maxProperties: 0] ([none]) or is [Closed], and any otherwise. *)
  | Map of { key : string option; value : ty }
      (** An object of no named member, each other member of [value], its names
          of the schema [key] names ([Definitions.map_keys]). *)
  | Enum of { base : scalar option; values : literal list }
  | Alias of ty  (** A schema that is another, or a scalar or a list. *)
  | Identifier of { pattern : string option }  (** A kind of id. *)
  | Union of union
  | Json  (** A schema that constrains nothing: any value. *)

and member = {
  wire : string;
  ty : ty;
  required : bool;
  fixed : literal option;  (** The one value its schema states in place. *)
  owner : string;  (** The schema that states it ([Definitions.owners]). *)
  description : string option;
      (** What its schema says of itself, or, beside null, what the schema
          beside null says. *)
  node_description : string option;
      (** What its schema's node says, its [allOf]'s merge included, and nothing
          of a schema beside null; [Deviations.node_description]. *)
}

and union = {
  branches : branch list;
  tag : tag option;
      (** The member its [discriminator] names, which each branch requires and
          states values of. *)
}

and branch = {
  variant : string;
      (** Its name within the union: the schema's it names, else what it is
          ([Text], [List], [Empty], [Integer], [Number], [Boolean]), or an
          object's one value of the member its discriminant is, or its title, or
          [Object]. *)
  ty : ty;
  signature : signature list;
      (** What it admits; several where it is a union itself. *)
}

and tag = { property : string; values : string list list }

and signature = {
  kind : kind;
  required : string list;
  allowed : string list option;  (** Every member it admits, if closed. *)
  fixed : (string * literal list) list;  (** The values a member may take. *)
  pattern : string option;
  values : literal list option;  (** Every value it admits, if it says. *)
}

and kind =
  | Text_kind
  | Integer_kind
  | Number_kind
  | Boolean_kind
  | List_kind
  | Object_kind
  | Null_kind
  | Any_kind

(* What an [allOf] states as it states it: its parts, and what it states
   beside them. Its [form] is what they merge to. *)
and composition = { parts : ty list; beside : beside }

and beside = {
  members : member list;
  rest : rest;
  values : literal list option;
}

type declaration = {
  name : string;
  description : string option;  (** As [member.description]. *)
  node_description : string option;  (** As [member.node_description]. *)
  form : form;
  composition : composition option;
}

type t = {
  names : string list;
      (** Every schema of the generation: its roots, and every schema they
          reach, in the order of their names. *)
  find : string -> declaration;
  defined : string -> bool;
      (** Whether a schema of the bundle has the name, which no invented name
          takes ([Naming.inline]). *)
  gateway : string list;
      (** The schemas the gateway's document reaches ([Definitions.bundle]), by
          name: the others are the client's own, and the tables'. *)
  place : place -> D.t -> ty;
      (** The type of a value a schema of none of its declarations holds at a
          place: a member a writer reads outside them. *)
}

(* The keywords a schema may state, as this reads each: for what a value
   holds, as what is said of it, or as a rule the validators hold a value to
   ([Required]), which says nothing of its type. The census holds every
   keyword Protocol states to one of them. *)
type reading = Shape | Said | Rule

let keywords =
  [
    ("$schema", Said);
    ("$id", Said);
    ("$ref", Shape);
    ("$comment", Said);
    ("title", Said);
    ("description", Said);
    ("type", Shape);
    ("format", Shape);
    ("enum", Shape);
    ("const", Shape);
    ("default", Said);
    ("examples", Said);
    ("properties", Shape);
    ("required", Shape);
    ("additionalProperties", Shape);
    ("unevaluatedProperties", Shape);
    ("propertyNames", Shape);
    ("minProperties", Rule);
    ("maxProperties", Shape);
    ("items", Shape);
    ("minItems", Rule);
    ("maxItems", Rule);
    ("uniqueItems", Rule);
    ("minLength", Rule);
    ("maxLength", Rule);
    ("pattern", Shape);
    ("minimum", Shape);
    ("maximum", Shape);
    ("allOf", Shape);
    ("anyOf", Shape);
    ("oneOf", Shape);
    ("not", Rule);
    ("discriminator", Shape);
    ("$defs", Said);
    ("x-xynolog-codes", Shape);
  ]

(* A keyword that constrains nothing, so a schema of these alone, as
   JsonSchema.json written in place is, admits any value. *)
let annotation key =
  List.mem key [ "$schema"; "$id"; "$comment"; "title"; "description" ]

let union_members (s : D.t) =
  match s with
  | D.Node { one_of = Some members; _ } | D.Node { any_of = Some members; _ } ->
      Some members
  | _ -> None

(* A schema that also admits null, as the schema without it. *)
let without_null (s : D.t) =
  match union_members s with
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

(* What [s] says of itself, or, when it only admits null beside another
   schema, what that schema says: never what a schema its [allOf] names
   says. *)
let rec description (s : D.t) =
  let own (n : D.node) =
    if List.mem "description" n.keys then n.description else None
  in
  match s with
  | D.Ref { description; _ } -> description
  | D.Node n when own n <> None -> own n
  | D.Node { any_of = Some [ D.Null; inner ]; _ } -> description inner
  | _ -> None

let node_description (s : D.t) =
  match s with
  | D.Node { description; _ } | D.Ref { description; _ } -> description
  | _ -> None

let only_text (s : D.t) =
  match s with
  | D.Node { enum = Some [ Schema.String_literal v ]; _ } -> Some v
  | _ -> None

(* What an object in place of a union is named by: the one value the first
   of its members that admits one text takes, else its title. *)
let member_name (s : D.t) =
  let discriminant =
    match s with
    | D.Node { properties = Some ps; _ } ->
        List.find_map (fun (_, p) -> only_text p) ps
    | _ -> None
  in
  match (discriminant, s) with
  | Some d, _ -> Some (Text.pascal d)
  | None, D.Node { title = Some title; _ } -> Some (Text.pascal title)
  | None, _ -> None

let scalar (n : D.node) (t : Schema.type_name) =
  match t with
  | String -> (
      match n.codes with
      | Some table when Word_tables.is table -> Some (Word table)
      | Some vocabulary -> Some (Code vocabulary)
      | None ->
          Some
            (Text
               { binary = n.format = Some Schema.Binary; pattern = n.pattern }))
  | Integer -> Some (Integer { minimum = n.minimum; maximum = n.maximum })
  | Number -> Some Number
  | Boolean -> Some Boolean
  | Null | Array | Object -> None

let rest_of = function
  | None -> `Unstated
  | Some (D.Bool false) -> `Closed
  | Some (D.Bool true) -> `Open
  | Some s -> `Of s

type state = {
  definitions : D.definitions;
  identifiers : string list;
  keys : (string * string) list;
  declared : (string, declaration option) Hashtbl.t;
      (** Every declaration read, by name: none while it is being read. *)
  inlines : (string, inline) Hashtbl.t;
}

let defined st name = List.mem name st.definitions.names

(* An [inline] at [place], each one a writer declares held to be the one
   schema its name names. *)
let rec inline st ~register (place : place) (s : D.t) =
  let name = Naming.inline ~defined:(defined st) place.owner place.part in
  let form, composition = form_of st ~register ~name s in
  let i =
    {
      name;
      place;
      description = description s;
      node_description = node_description s;
      form;
      composition;
    }
  in
  let own =
    match (form, composition) with
    | (Record _ | Enum _ | Union _), _ | _, Some _ -> true
    | _ -> false
  in
  (if register && own then
     match Hashtbl.find_opt st.inlines name with
     | Some other when other <> i ->
         refuse "two schemas written in place would both be named %s" name
     | _ -> Hashtbl.replace st.inlines name i);
  Inline i

(* The type of a value [place] holds. *)
and classify st ~register (place : place) (s : D.t) : ty =
  match s with
  | D.Ref { name; _ } -> Named name
  | D.Null -> Null
  | D.Bool true -> Any
  | D.Bool false -> Nothing
  | D.Node { keys; _ } when List.for_all annotation keys -> Any
  | D.Node n -> (
      match without_null s with
      | Some inner -> Nullable (classify st ~register place inner)
      | None -> (
          let at part = { place with part = place.part ^ part } in
          match (n.all_of, union_members s, n.enum, n.type_) with
          | Some _, _, _, _ | None, Some _, _, _ | None, None, Some _, _ ->
              inline st ~register place s
          | None, None, None, Some (D.One t) -> (
              match (scalar n t, t) with
              | Some sc, _ -> Scalar sc
              | None, Null -> Null
              | None, Array ->
                  List (Option.map (classify st ~register (at "Item")) n.items)
              | None, _ -> inline st ~register place s)
          | None, None, None, None when n.properties <> None ->
              inline st ~register place s
          | None, None, None, None -> Any
          | None, None, None, Some (D.Or_null _) ->
              refuse "%s.%s: null beside null" place.owner place.part))

(* The form of [name]'s schema [s], and what it composes. *)
and form_of st ~register ~name (s : D.t) : form * composition option =
  let place = { owner = name; part = "" } in
  match s with
  | D.Ref { name = other; _ } -> (Alias (Named other), None)
  | D.Null -> (Alias Null, None)
  | D.Bool true -> (Json, None)
  | D.Bool false -> (Alias Nothing, None)
  | D.Node { keys; _ } when List.for_all annotation keys -> (Json, None)
  | D.Node n -> (
      match without_null s with
      | Some inner ->
          (Alias (Nullable (classify st ~register place inner)), None)
      | None -> (
          match (n.all_of, union_members s) with
          | Some parts, _ ->
              let owners = D.owners st.definitions name s in
              let composition =
                {
                  parts = List.map (classify st ~register:false place) parts;
                  beside =
                    {
                      members =
                        members st ~register:false ~owners:(fun _ -> name) n;
                      rest = rest st ~register:false place n;
                      values = n.enum;
                    };
                }
              in
              (merged st ~register ~name ~owners (D.meant s), Some composition)
          | None, Some members ->
              (Union (union st ~register ~name n members), None)
          | None, None ->
              let owners = D.owners st.definitions name s in
              (merged st ~register ~name ~owners s, None)))

(* The form of what [name]'s schema means, [s] being no union, its members
   stated by [owners]. *)
and merged st ~register ~name ~owners (s : D.t) : form =
  let place = { owner = name; part = "" } in
  match s with
  | D.Node n when without_null s = None && union_members s = None -> (
      match (n.enum, n.type_) with
      | Some values, types ->
          (* An enum's values are what it is: one of codes is text. *)
          let base =
            match types with
            | Some (D.One t) -> scalar { n with codes = None } t
            | _ -> None
          in
          Enum { base; values }
      | None, _ when List.mem name st.identifiers -> (
          match n.type_ with
          | Some (D.One String) -> Identifier { pattern = n.pattern }
          | _ -> refuse "%s: a kind of id whose schema is not a string" name)
      | None, Some (D.One t) -> (
          match (scalar n t, t) with
          | Some sc, _ -> Alias (Scalar sc)
          | None, Null -> Alias Null
          | None, Array ->
              Alias
                (List
                   (Option.map
                      (classify st ~register { place with part = "Item" })
                      n.items))
          | None, _ -> object_form st ~register ~name ~owners n)
      | None, None when n.properties <> None ->
          object_form st ~register ~name ~owners n
      | None, _ -> Json)
  | s -> fst (form_of st ~register ~name s)

and rest st ~register (place : place) (n : D.node) =
  match rest_of n.additional_properties with
  | `Unstated -> Unstated
  | `Closed -> Closed
  | `Open -> Open
  | `Of v ->
      Of (classify st ~register { place with part = place.part ^ "Value" } v)

and members st ~register ~owners (n : D.node) =
  let required = Option.value n.required ~default:[] in
  List.map
    (fun (wire, ps) ->
      let owner = owners wire in
      {
        wire;
        ty = classify st ~register { owner; part = wire } ps;
        required = List.mem wire required;
        fixed =
          (match D.meant ps with
          | D.Node { enum = Some [ v ]; _ } -> Some v
          | _ -> None);
        owner;
        description = description ps;
        node_description = node_description ps;
      })
    (Option.value n.properties ~default:[])

and object_form st ~register ~name ~owners (n : D.node) =
  let place = { owner = name; part = "" } in
  let members = members st ~register ~owners n in
  match (members, rest st ~register place n) with
  | [], Of value -> Map { key = List.assoc_opt name st.keys; value }
  | [], rest -> Empty { rest; none = n.max_properties = Some 0 }
  | members, rest -> Record { members; rest }

and union st ~register ~name (n : D.node) members =
  let at part = { owner = name; part } in
  let branch (m : D.t) =
    let variant, ty =
      match m with
      | D.Ref { name = target; _ } -> (target, Named target)
      | D.Node { type_ = Some (D.One Object); max_properties = Some 0; _ } ->
          ("Empty", classify st ~register (at "Empty") m)
      | _ when is_text st m -> ("Text", classify st ~register (at "Text") m)
      | D.Node { type_ = Some (D.One Array); _ } ->
          ("List", classify st ~register (at "") m)
      | D.Node { type_ = Some (D.One Object); _ } ->
          let variant = Option.value (member_name m) ~default:"Object" in
          (variant, classify st ~register (at variant) m)
      | D.Node { type_ = Some (D.One Integer); _ } ->
          ("Integer", classify st ~register (at "Integer") m)
      | D.Node { type_ = Some (D.One Number); _ } ->
          ("Number", classify st ~register (at "Number") m)
      | D.Node { type_ = Some (D.One Boolean); _ } ->
          ("Boolean", classify st ~register (at "Boolean") m)
      | _ -> refuse "%s: a union member the generator does not know" name
    in
    (variant, ty)
  in
  let pairs =
    List.fold_left
      (fun acc m ->
        let variant, ty = branch m in
        if List.mem_assoc variant acc then
          refuse "%s: two union members would both be the variant %s" name
            variant;
        acc @ [ (variant, ty) ])
      [] members
  in
  let tag =
    Option.map
      (fun property ->
        let values =
          List.map (fun m -> tag_values st ~name property m) members
        in
        let all = List.concat values in
        List.iteri
          (fun i v ->
            if List.mem v (List.filteri (fun j _ -> j < i) all) then
              refuse "%s: two members state the `%s` %s" name property v)
          all;
        { property; values })
      n.discriminator
  in
  let branches =
    List.map
      (fun (variant, ty) -> { variant; ty; signature = signatures st [] ty })
      pairs
  in
  List.iteri
    (fun i a ->
      List.iteri
        (fun j b ->
          if
            j > i
            && not
                 (List.for_all
                    (fun x -> List.for_all (disjoint x) b.signature)
                    a.signature)
          then
            refuse
              "%s: its members %s and %s may be one value, and nothing tells \
               them apart"
              name a.variant b.variant)
        branches)
    branches;
  { branches; tag }

(* Whether a schema is text, through what it names and unions of text. *)
and is_text st (s : D.t) =
  match s with
  | D.Ref { name; _ } -> is_text st (st.definitions.schema name)
  | _ -> (
      match union_members s with
      | Some members -> List.for_all (is_text st) members
      | None -> (
          match s with
          | D.Node { type_ = Some (D.One String); enum = None; _ } -> true
          | _ -> false))

(* The values of [property] a member of [name] states: the ones its schema's
   enumeration of it admits. *)
and tag_values st ~name property (m : D.t) =
  let resolved =
    match m with D.Ref { name; _ } -> st.definitions.schema name | m -> m
  in
  match D.meant resolved with
  | D.Node { required = Some required; properties = Some ps; _ }
    when List.mem property required -> (
      match List.assoc_opt property ps with
      | Some (D.Node { enum = Some values; _ }) ->
          List.map
            (function
              | Schema.String_literal v -> v
              | _ -> refuse "%s: a member's `%s` is no text" name property)
            values
      | _ -> refuse "%s: a member states no values of `%s`" name property)
  | _ -> refuse "%s: a member does not require `%s`" name property

(* What a value of [ty] may be, [seen] the schemas already followed. *)
and signatures st seen (ty : ty) : signature list =
  let one ?(required = []) ?allowed ?(fixed = []) ?pattern ?values kind =
    [ { kind; required; allowed; fixed; pattern; values } ]
  in
  match ty with
  | Named name
    when List.mem name seen || Hashtbl.find_opt st.declared name = Some None ->
      one Any_kind
  | Named name -> form_signatures st (name :: seen) (declaration st name).form
  | Inline i -> form_signatures st seen i.form
  | Scalar (Text { pattern; _ }) -> one ?pattern Text_kind
  | Scalar (Code _ | Word _) -> one Text_kind
  | Scalar (Integer _) -> one Integer_kind
  | Scalar Number -> one Number_kind
  | Scalar Boolean -> one Boolean_kind
  | Null -> one Null_kind
  | List _ -> one List_kind
  | Nullable ty -> one Null_kind @ signatures st seen ty
  | Any -> one Any_kind
  | Nothing -> []

and form_signatures st seen (form : form) =
  let one ?(required = []) ?allowed ?(fixed = []) ?pattern ?values kind =
    [ { kind; required; allowed; fixed; pattern; values } ]
  in
  match form with
  | Record { members; rest } ->
      let wires = List.map (fun (m : member) -> m.wire) members in
      one Object_kind
        ~required:
          (List.filter_map
             (fun (m : member) -> if m.required then Some m.wire else None)
             members)
        ?allowed:(if rest = Closed then Some wires else None)
        ~fixed:
          (List.filter_map
             (fun (m : member) ->
               Option.map (fun v -> (m.wire, v)) (values_of st seen m.ty))
             members)
  | Empty { rest; none } ->
      one Object_kind ?allowed:(if none || rest = Closed then Some [] else None)
  | Map _ -> one Object_kind
  | Enum { base; values } ->
      let kind =
        match base with
        | Some (Text _ | Code _ | Word _) -> Text_kind
        | Some (Integer _) -> Integer_kind
        | Some Number -> Number_kind
        | Some Boolean -> Boolean_kind
        | None -> Any_kind
      in
      one kind ~values
  | Alias ty -> signatures st seen ty
  | Identifier { pattern } -> one ?pattern Text_kind
  | Union { branches; _ } -> List.concat_map (fun b -> b.signature) branches
  | Json -> one Any_kind

(* The values a member of [ty] may take, where its schema says. *)
and values_of st seen (ty : ty) =
  match ty with
  | Inline { form = Enum { values; _ }; _ } -> Some values
  | Named name
    when not
           (List.mem name seen || Hashtbl.find_opt st.declared name = Some None)
    -> (
      match (declaration st name).form with
      | Enum { values; _ } -> Some values
      | _ -> None)
  | _ -> None

and declaration st name =
  match Hashtbl.find_opt st.declared name with
  | Some (Some d) -> d
  | Some None -> refuse "%s reaches itself before it is read" name
  | None ->
      Hashtbl.replace st.declared name None;
      let s = st.definitions.schema name in
      let form, composition = form_of st ~register:true ~name s in
      let d =
        {
          name;
          description = description s;
          node_description = node_description s;
          form;
          composition;
        }
      in
      Hashtbl.replace st.declared name (Some d);
      d

(* Whether no value is admitted by both. *)
and disjoint (a : signature) (b : signature) =
  let kinds_meet =
    match (a.kind, b.kind) with
    | Any_kind, _ | _, Any_kind -> true
    | Integer_kind, Number_kind | Number_kind, Integer_kind -> true
    | x, y -> x = y
  in
  let apart va vb = not (List.exists (fun v -> List.mem v vb) va) in
  let refused_by pattern values =
    List.for_all
      (function
        | Schema.String_literal v -> Text_patterns.refuses pattern v | _ -> true)
      values
  in
  let excludes (a : signature) (b : signature) =
    match b.allowed with
    | Some allowed -> List.exists (fun p -> not (List.mem p allowed)) a.required
    | None -> false
  in
  let fixed_apart (a : signature) (b : signature) =
    List.exists
      (fun (p, va) ->
        match List.assoc_opt p b.fixed with
        | Some vb ->
            (List.mem p a.required || List.mem p b.required) && apart va vb
        | None -> false)
      a.fixed
  in
  (not kinds_meet)
  || (match (a.values, b.values, a.pattern, b.pattern) with
    | Some va, Some vb, _, _ -> apart va vb
    | Some va, None, _, Some p | None, Some va, Some p, _ -> refused_by p va
    | None, None, Some p, Some q -> Text_patterns.disjoint p q
    | _ -> false)
  || a.kind = Object_kind && b.kind = Object_kind
     && (excludes a b || excludes b a || fixed_apart a b)

(* Two members of [u] that only a pattern tells apart, by their variants:
   what a reader of the values a union's members admit, that reads no
   pattern, cannot tell apart. *)
let apart_by_pattern_only (u : union) =
  let unpatterned (s : signature) = { s with pattern = None } in
  let rec pairs = function
    | [] -> []
    | b :: rest -> List.map (fun other -> (b, other)) rest @ pairs rest
  in
  List.find_map
    (fun ((a : branch), (b : branch)) ->
      if
        List.exists
          (fun sa ->
            List.exists
              (fun sb -> not (disjoint (unpatterned sa) (unpatterned sb)))
              b.signature)
          a.signature
      then Some (a.variant, b.variant)
      else None)
    (pairs u.branches)

(* Every name and scalar a type holds, through what it holds in place: a
   map's key is the name of the schema its keys are. *)
let rec leaves_of_ty (ty : ty) =
  match ty with
  | Named _ | Scalar _ -> [ ty ]
  | Inline i -> leaves_of_inline i
  | List (Some ty) | Nullable ty -> leaves_of_ty ty
  | Null | List None | Any | Nothing -> []

and leaves_of_inline (i : inline) =
  leaves_of_form i.form
  @
  match i.composition with
  | Some c -> List.concat_map leaves_of_ty c.parts
  | None -> []

and leaves_of_form (form : form) =
  let of_rest = function Of ty -> leaves_of_ty ty | _ -> [] in
  match form with
  | Record { members; rest } ->
      List.concat_map (fun (m : member) -> leaves_of_ty m.ty) members
      @ of_rest rest
  | Empty _ | Enum _ | Identifier _ | Json -> []
  | Map { key; value } ->
      List.map (fun k -> Named k) (Option.to_list key) @ leaves_of_ty value
  | Alias ty -> leaves_of_ty ty
  | Union { branches; _ } ->
      List.concat_map (fun (b : branch) -> leaves_of_ty b.ty) branches

(* Every name and scalar a declaration holds, through what it holds in place
   and what its [allOf] composes. *)
let leaves (d : declaration) =
  leaves_of_form d.form
  @
  match d.composition with
  | Some c -> List.concat_map leaves_of_ty c.parts
  | None -> []

(* Every schema a declaration names. *)
let references (d : declaration) =
  List.filter_map (function Named name -> Some name | _ -> None) (leaves d)

(* [names], and every schema they reach, [find] giving each its
   declaration, in the order of their names. *)
let reached find names =
  let rec reach seen = function
    | [] -> seen
    | name :: rest when List.mem name seen -> reach seen rest
    | name :: rest -> reach (name :: seen) (references (find name) @ rest)
  in
  List.sort String.compare (reach [] names)

let make (definitions : D.definitions) ~roots ~identifiers ~keys =
  let st =
    {
      definitions;
      identifiers;
      keys;
      declared = Hashtbl.create 1024;
      inlines = Hashtbl.create 512;
    }
  in
  let names = reached (declaration st) roots in
  {
    names;
    find = declaration st;
    defined = defined st;
    gateway = definitions.names;
    place = classify st ~register:false;
  }

(* Whether an object of [form] holds no member: one that names none, and
   says [maxProperties: 0] or holds no other. *)
let holds_none (form : form) =
  match form with
  | Empty { none = true; _ } | Empty { rest = Closed; _ } -> true
  | _ -> false

(* Whether a branch admits text alone, of no values it names: a string
   wherever it is held. *)
let admits_only_text (b : branch) =
  List.for_all
    (fun (s : signature) -> s.kind = Text_kind && s.values = None)
    b.signature

(* The generation of [spec]: every schema Protocol states ([Roots.all]), the
   kinds of id, the client types the SDKs generate, the records its tables
   state, and the schema of each of [tables], named as its file is
   ([Places.schema_of]), each a table an SDK carries as a value. *)
let of_spec (spec : Spec.t) ~tables =
  let bundle = D.bundle spec in
  let declared name =
    match bundle.definitions.schema name with
    | _ -> true
    | exception D.Refused _ -> false
  in
  let schemas =
    List.map
      (fun table ->
        let file = Places.schema_of table in
        let name = D.stem file in
        if declared name then
          refuse "%s, the schema of %s, is named as a schema already is" file
            table;
        match List.assoc_opt file spec.schemas with
        | Some s -> (name, bundle.view (Normalize.shape_only s))
        | None -> refuse "%s has no schema %s" table file)
      tables
  in
  let identifiers =
    List.map
      (fun (k : Tables.Identifiers_kinds.kinds_item) -> k.schema)
      spec.tables.identifiers_kinds.kinds
  in
  let t =
    make
      {
        D.names = bundle.definitions.names @ List.map fst schemas;
        schema =
          (fun name ->
            match List.assoc_opt name schemas with
            | Some s -> s
            | None -> bundle.definitions.schema name);
      }
      ~roots:
        (List.map fst (Roots.all spec)
        @ identifiers
        @ D.generated_client_types spec
        @ List.map (fun (_, name, _) -> name) (D.records spec)
        @ List.map fst schemas)
      ~identifiers ~keys:(D.map_keys spec)
  in
  { t with gateway = bundle.definitions.names }

(* The vocabularies of errors/codes.json [t]'s declarations hold a code of
   ([Code]), each once, in order. *)
let codes (t : t) =
  List.sort_uniq String.compare
    (List.concat_map
       (fun name ->
         List.filter_map
           (function Scalar (Code vocabulary) -> Some vocabulary | _ -> None)
           (leaves (t.find name)))
       t.names)
