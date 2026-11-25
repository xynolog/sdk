(* What an [allOf] means: its parts, a reference expanded, merged keyword by
   keyword into the one schema they describe, then the schema's own keywords
   on top. Every writer reads an [allOf] through this merge, and decides
   nothing of it itself. Bounds tighten, [required] and [enum] combine, a
   closed object stays closed, and keywords that must agree are refused when
   they don't; any other keyword is the last part's. A property two parts
   state differently is the [allOf] of both, in the place the first states
   it, so properties keep the order the parts state them in. *)

type 'a outcome = ('a, string) result

let ( let* ) = Result.bind

(* A schema as two compare it: each reference as the place it names, not
   where it is written, so two files that refer to one schema state it
   alike. *)
let placed ids : Schema.t -> Schema.t =
  Schema.cata
    ~boolean:(fun b -> Schema.Boolean_schema b)
    ~schema:(fun s ->
      Schema.Schema
        {
          s with
          ref_ =
            Option.map
              (fun r ->
                let file, pointer = Decode.resolve ids r in
                { Decode.target = file; file = ""; pointer })
              s.ref_;
        })

let alike ids left right = placed ids left = placed ids right

let same_place ids left right =
  Decode.resolve ids left = Decode.resolve ids right

let agree what same left right =
  if same left right then Ok right
  else Error ("unsupported intersection of " ^ what)

let merge_option combine old next =
  match (old, next) with
  | None, next -> Ok next
  | old, None -> Ok old
  | Some old, Some next -> Result.map Option.some (combine old next)

let union_properties ids old next =
  let intersection left right =
    if alike ids left right then left
    else Schema.Schema { Schema.empty with all_of = Some [ left; right ] }
  in
  let keys =
    List.map fst old
    @ List.filter (fun key -> not (List.mem_assoc key old)) (List.map fst next)
  in
  Ok
    (List.map
       (fun key ->
         match (List.assoc_opt key old, List.assoc_opt key next) with
         | Some l, Some r -> (key, intersection l r)
         | Some s, None | None, Some s -> (key, s)
         | None, None -> assert false)
       keys)

let distinct names =
  List.rev
    (List.fold_left
       (fun kept n -> if List.mem n kept then kept else n :: kept)
       [] names)

(* Whether [member] of [owner]'s [oneOf] or [anyOf] only holds the object to
   its own members ([shape_only]). *)
let constrains (owner : Schema.t Schema.layer) (member : Schema.t) =
  let narrows = function
    | Schema.Schema l ->
        List.for_all
          (fun k -> List.mem k [ "const"; "enum"; "description" ])
          (Schema.keywords l)
    | Schema.Boolean_schema _ -> false
  in
  match member with
  | Schema.Boolean_schema _ -> false
  | Schema.Schema l ->
      List.for_all
        (fun k -> List.mem k [ "required"; "not"; "properties"; "description" ])
        (Schema.keywords l)
      && List.for_all
           (fun (name, value) ->
             narrows value
             && List.mem_assoc name (Option.value owner.properties ~default:[]))
           (Option.value l.properties ~default:[])

let only_constraints owner = function
  | Some members -> List.for_all (constrains owner) members
  | None -> false

(* Each part [s] states beside the others, where it is no more than an
   [anyOf] of them. *)
let disjuncts = function
  | Schema.Schema ({ any_of = Some parts; _ } as l)
    when Schema.keywords l = [ "anyOf" ] ->
      parts
  | s -> [ s ]

(* Each part [s] states beside the others, where it is no more than an
   [allOf] of them. *)
let conjuncts = function
  | Schema.Schema ({ all_of = Some parts; _ } as l)
    when Schema.keywords l = [ "allOf" ] ->
      parts
  | s -> [ s ]

let layer : Schema.t -> Schema.schema outcome = function
  | Schema s -> Ok s
  | Boolean_schema _ -> Error "expected a schema object"

(* Each outcome's value, or the first refusal. *)
let all outcomes =
  Result.map List.rev
    (List.fold_left
       (fun kept outcome ->
         let* kept = kept in
         let* value = outcome in
         Ok (value :: kept))
       (Ok []) outcomes)

(* [next]'s keywords merged onto [old]'s. *)
let rec merge ids (old : Schema.schema) (next : Schema.schema) :
    Schema.schema outcome =
  let last old next = Ok (match next with None -> old | Some _ -> next) in
  let bound pick = merge_option (fun l r -> Ok (pick l r)) in
  let* properties =
    merge_option (union_properties ids) old.properties next.properties
  in
  let* required =
    merge_option (fun l r -> Ok (distinct (l @ r))) old.required next.required
  in
  let* enum =
    merge_option
      (fun l r ->
        match List.filter (fun v -> List.mem v r) l with
        | [] -> Error "empty enum intersection"
        | common -> Ok common)
      old.enum next.enum
  in
  let* type_ =
    merge_option
      (fun l r ->
        if l = r then Ok r else Error "incompatible intersection types")
      old.type_ next.type_
  in
  let* additional_properties =
    match old.additional_properties with
    | Some (Boolean_schema false) -> Ok old.additional_properties
    | _ -> last old.additional_properties next.additional_properties
  in
  let* unevaluated_properties =
    match old.unevaluated_properties with
    | Some (Boolean_schema false) -> Ok old.unevaluated_properties
    | _ -> last old.unevaluated_properties next.unevaluated_properties
  in
  let* unique_items =
    match old.unique_items with
    | Some true -> Ok old.unique_items
    | _ -> last old.unique_items next.unique_items
  in
  let* pattern =
    merge_option (agree "\"pattern\"" String.equal) old.pattern next.pattern
  in
  (* Two [oneOf]s, or two [anyOf]s, each of which only holds the object to
     its own members ([constrains]), are the one of each member of the one
     beside each of the other: a value is exactly one, or at least one, of
     those pairs when it is so of each. *)
  let owner = { Schema.empty with properties } in
  let composed what =
    merge_option (fun l r ->
        if List.equal (alike ids) l r then Ok r
        else if
          only_constraints owner (Some l) && only_constraints owner (Some r)
        then
          all
            (List.concat_map
               (fun a ->
                 List.map
                   (fun b ->
                     let* a = layer a in
                     let* b = layer b in
                     Result.map (fun m -> Schema.Schema m) (merge ids a b))
                   r)
               l)
        else Error ("unsupported intersection of " ^ what))
  in
  let* one_of = composed "\"oneOf\"" old.one_of next.one_of in
  let* any_of = composed "\"anyOf\"" old.any_of next.any_of in
  let* items =
    merge_option (agree "\"items\"" (alike ids)) old.items next.items
  in
  let* ref_ =
    merge_option (agree "\"$ref\"" (same_place ids)) old.ref_ next.ref_
  in
  let* minimum = bound Float.max old.minimum next.minimum in
  let* maximum = bound Float.min old.maximum next.maximum in
  let* min_length = bound Int.max old.min_length next.min_length in
  let* min_items = bound Int.max old.min_items next.min_items in
  let* max_length = bound Int.min old.max_length next.max_length in
  let* max_items = bound Int.min old.max_items next.max_items in
  let* max_properties = bound Int.min old.max_properties next.max_properties in
  let* schema = last old.schema next.schema in
  let* id = last old.id next.id in
  let* defs = last old.defs next.defs in
  let* comment = last old.comment next.comment in
  let* title = last old.title next.title in
  let* description = last old.description next.description in
  let* format = last old.format next.format in
  let* codes = last old.codes next.codes in
  let* const = merge_option (agree "\"const\"" ( = )) old.const next.const in
  let* default = last old.default next.default in
  let* examples = last old.examples next.examples in
  (* The parts of [l] and of [r] that [split] finds, each once, as [joined]
     joins them: one part is itself. *)
  let joined split join l r =
    let parts =
      List.rev
        (List.fold_left
           (fun kept part ->
             if List.exists (alike ids part) kept then kept else part :: kept)
           []
           (split l @ split r))
    in
    Ok
      (match parts with
      | [ part ] -> part
      | parts -> Schema.Schema (join parts))
  in
  let* property_names =
    merge_option
      (joined conjuncts (fun parts -> { Schema.empty with all_of = Some parts }))
      old.property_names next.property_names
  in
  let* min_properties = bound Int.max old.min_properties next.min_properties in
  let* all_of = last old.all_of next.all_of in
  (* A value is neither of two when it is not one of either. *)
  let* not_ =
    merge_option
      (joined disjuncts (fun parts -> { Schema.empty with any_of = Some parts }))
      old.not_ next.not_
  in
  let* discriminator = last old.discriminator next.discriminator in
  Ok
    {
      Schema.schema;
      id;
      ref_;
      comment;
      title;
      description;
      type_;
      format;
      codes;
      enum;
      const;
      default;
      examples;
      properties;
      required;
      additional_properties;
      unevaluated_properties;
      property_names;
      min_properties;
      max_properties;
      items;
      min_items;
      max_items;
      unique_items;
      min_length;
      max_length;
      pattern;
      minimum;
      maximum;
      all_of;
      any_of;
      one_of;
      not_;
      discriminator;
      defs;
    }

(* A schema a part refers to, as the part takes it: its keywords, without
   the definitions it holds for references into it ([$defs]), which the
   schema the part is in does not hold. A reference within it still names its
   own file, so they are still found. *)
let resource (s : Schema.schema) = { s with defs = None }

(* A schema expanded as the whole that is normalized, and as a part of an
   [allOf]: a part that refers to a schema is that schema expanded, with the
   part's own keywords on top. Each is given the places ([Decode.resolve])
   the expansion is within, so a schema that is a part of itself is refused. *)
type expansion = {
  whole : (string * string) list -> Schema.schema outcome;
  part : (string * string) list -> Schema.schema outcome;
}

(* [schema] with its [allOf] merged, the schema each reference in it names
   found by [find]. *)
let normalize ids ~find schema =
  let rec expand schema =
    Schema.para
      ~boolean:(fun b ->
        let refused _ = layer (Schema.Boolean_schema b) in
        { whole = refused; part = refused })
      ~schema:(fun l ->
        let s = Schema.map fst l in
        let whole trail =
          match l.all_of with
          | None -> Ok s
          | Some parts ->
              let* merged =
                List.fold_left
                  (fun merged (_, p) ->
                    let* merged = merged in
                    let* p = p.part trail in
                    merge ids merged p)
                  (Ok Schema.empty) parts
              in
              merge ids merged { s with all_of = None }
        in
        let part trail =
          match s.ref_ with
          | Some r ->
              let named = Decode.resolve ids r in
              let* () =
                if List.mem named trail then
                  Error ("cyclic schema intersection: " ^ r.target)
                else Ok ()
              in
              let* target = find r in
              let* expanded = (expand target).whole (named :: trail) in
              merge ids (resource expanded) { s with ref_ = None }
          | None -> whole trail
        in
        { whole; part })
      schema
  in
  (expand schema).whole []

(* Each schema [find] names, by its name, with every [allOf] in it merged:
   what each node holds is merged first, then the node's own [allOf], each
   part that refers to a schema given that schema merged, and then what that
   merge makes, which states a property two parts state differently as the
   [allOf] of both. [referenced] is the name of the schema a reference names.
   A schema whose merge needs its own is refused: written merged, it would
   never end. *)
let everywhere ids ~referenced ~find =
  let written = Hashtbl.create 64 in
  let rec named within name =
    match Hashtbl.find_opt written name with
    | Some s -> Ok s
    | None ->
        let* () =
          if List.mem name within then
            Error ("recursive schema intersection: " ^ name)
          else Ok ()
        in
        let* s = find name in
        let* s = merged (name :: within) s in
        Hashtbl.replace written name s;
        Ok s
  and merged within = function
    | Schema.Boolean_schema _ as b -> Ok b
    | Schema l -> (
        let each l =
          Result.map
            (fun l -> Schema.Schema l)
            (Schema.traverse (merged within) l)
        in
        let* s = each l in
        match s with
        | Schema { all_of = Some _; _ } ->
            let* l =
              normalize ids ~find:(fun r -> named within (referenced r)) s
            in
            each l
        | s -> Ok s)
  in
  named []

(* A schema that closes what it composes ([unevaluatedProperties]), as the
   one object it means: what its [$ref] and its [allOf] merge to, with its own
   keywords on top. Every member they state is one it evaluates, so over the
   merge [unevaluatedProperties] is [additionalProperties]. A merge that
   still composes, by a [oneOf], an [anyOf] or a [not], is no one object, and
   one that states [additionalProperties] itself would be closed twice: both
   are refused. *)
let closed ids ~find (s : Schema.schema) =
  let parts =
    Option.to_list
      (Option.map
         (fun r -> Schema.Schema { Schema.empty with ref_ = Some r })
         s.ref_)
    @ Option.value s.all_of ~default:[]
  in
  let* merged =
    normalize ids ~find
      (Schema.Schema
         {
           (resource s) with
           ref_ = None;
           all_of = Some parts;
           unevaluated_properties = None;
         })
  in
  match merged with
  | { one_of = Some _; _ } | { any_of = Some _; _ } | { not_ = Some _; _ } ->
      Error "unevaluatedProperties over a schema that is no one object"
  | { additional_properties = Some _; _ } ->
      Error "unevaluatedProperties beside additionalProperties"
  | merged ->
      Ok { merged with additional_properties = s.unevaluated_properties }

(* [s], each schema within it that closes what it composes read as the one
   object it means ([closed]). *)
let rec closed_within ids ~find = function
  | Schema.Boolean_schema _ as b -> Ok b
  | Schema.Schema l -> (
      let* l = Schema.traverse (closed_within ids ~find) l in
      match l with
      | { unevaluated_properties = Some _; _ } ->
          Result.map (fun s -> Schema.Schema s) (closed ids ~find l)
      | l -> Ok (Schema.Schema l))

(* [s] as a writer of types reads it: what a value's type is, without what
   only holds a value to its rules, which the required table states
   ([Required.Shape]). A [const] is an [enum] of its one value (JSON Schema
   2020-12). [not], [minProperties] and [propertyNames] say which values of a
   type are allowed, not what the type is, and go. So does a [oneOf] or
   [anyOf] each of whose members only holds an object to its own members:
   each states no more than which members it carries ([required]), which it
   does not ([not]), and the one value or values ([const], [enum]) a member
   the object states takes. *)
(* A schema of several types but null and nothing else, as the [anyOf] of a
   schema of each: a value of it is a value of one of them. *)
let several_types = function
  | Schema.Schema ({ type_ = Some types; _ } as l)
    when List.length (List.filter (fun t -> t <> Schema.Null) types) > 1
         && List.for_all
              (fun k ->
                List.mem k [ "type"; "description"; "title"; "$schema"; "$id" ])
              (Schema.keywords l) ->
      Schema.Schema
        {
          l with
          type_ = None;
          any_of =
            Some
              (List.map
                 (fun t ->
                   Schema.Schema { Schema.empty with type_ = Some [ t ] })
                 types);
        }
  | s -> s

(* [several_types] at every place of a schema: a schema that validates as it
   does. *)
let several_types_throughout : Schema.t -> Schema.t =
  Schema.cata
    ~boolean:(fun b -> Schema.Boolean_schema b)
    ~schema:(fun l -> several_types (Schema.Schema l))

(* What [shape_only] drops of a schema that a validator reads: each keyword,
   at any place. *)
let rec dropped = function
  | Schema.Boolean_schema _ -> []
  | Schema.Schema l ->
      List.filter
        (fun k -> List.mem k [ "not"; "minProperties"; "propertyNames" ])
        (Schema.keywords l)
      @ (if only_constraints l l.one_of then [ "oneOf" ] else [])
      @ (if only_constraints l l.any_of then [ "anyOf" ] else [])
      @ List.concat_map dropped (Schema.children l)

let shape_only : Schema.t -> Schema.t =
  Schema.cata
    ~boolean:(fun b -> Schema.Boolean_schema b)
    ~schema:(fun l ->
      Schema.Schema
        {
          l with
          comment = None;
          const = None;
          enum =
            (match (l.const, l.enum) with
            | Some value, None -> Some [ value ]
            | Some value, Some values when List.mem value values ->
                Some [ value ]
            | _, enum -> enum);
          not_ = None;
          min_properties = None;
          property_names = None;
          one_of = (if only_constraints l l.one_of then None else l.one_of);
          any_of = (if only_constraints l l.any_of then None else l.any_of);
        }
      |> several_types)
