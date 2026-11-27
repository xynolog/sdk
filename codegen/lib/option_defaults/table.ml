(* The client's option defaults (protocol/specs/src/client/option-defaults.json),
   each row's value of the type its option is: the type a member of the
   schema surface.json states for the parameter has, or the row's own schema's
   where surface.json states none. A value is a text, an integer, a boolean,
   a value of an enumeration, or a value of a named schema: its JSON, which a
   writer may read with its SDK's own reader of the type, and the value as
   the type's members and branches hold it, which a writer may write in
   place. A row of any other type is refused, as are two rows of the one
   name. *)

module O = Tables.Client_option_defaults
module D = Definitions
module M = Surface.Methods
module T = Typing

let file = "client/option-defaults.json"

(* A value of a named schema, as its type holds it. *)
type typed =
  | T_text of string
  | T_integer of int
  | T_boolean of bool
  | T_member of { enum : string; value : string }
  | T_record of { record : string; fields : field list }
  | T_branch of { union : string; variant : string; value : typed }
      (** The value of the union [union]'s branch [variant]. *)

(* A member of a record, in the order its schema states them: its value, if
   the JSON gives one, and whether its schema states its one value. *)
and field = { wire : string; fixed : bool; given : typed option }

type value =
  | Text of string
  | Integer of { value : int; minimum : float option; maximum : float option }
  | Boolean of bool
  | Member of { enum : string; value : string }
      (** The value [value] of the enumeration [enum]. *)
  | Read of { schema : string; json : Yojson.Safe.t; typed : typed }
      (** A value of the named schema [schema], as its JSON states it. *)

type entry = {
  name : string;
      (** The row's method, then its option or else its parameter, in camel
          case: [gather.resource]'s [depth] is [gatherResourceDepth]. *)
  method_ : string;  (** What takes it, as surface.json names it. *)
  docs : string;
  value : value;
}

type t = entry list

(* [gather.resource] and [depth] as [gatherResourceDepth]. *)
let name_of (row : O.defaults_item) =
  String.uncapitalize_ascii (Text.pascal row.method_)
  ^ Text.pascal (Option.value row.option ~default:row.parameter)

(* What [json] is as a value of [ty], at [at], member by member. *)
let rec typed (typing : T.t) ~at (ty : T.ty) (json : Yojson.Safe.t) =
  match (ty, json) with
  | T.Scalar (T.Text _), `String s -> T_text s
  | T.Scalar (T.Integer _), `Int n -> T_integer n
  | T.Scalar T.Boolean, `Bool b -> T_boolean b
  | T.Named name, _ -> of_form typing ~at name (typing.find name).form json
  | T.Inline { name; form; _ }, _ -> of_form typing ~at name form json
  | _ ->
      D.refuse "%s %s: holds %s, of a type no writer writes in place" file at
        (Yojson.Safe.to_string json)

and of_form typing ~at name (form : T.form) json =
  match (form, json) with
  | T.Record { members; _ }, `Assoc given ->
      List.iter
        (fun (key, _) ->
          if not (List.exists (fun (m : T.member) -> m.wire = key) members) then
            D.refuse "%s %s: gives %s, which %s has no member of" file at key
              name)
        given;
      T_record
        {
          record = name;
          fields =
            List.map
              (fun (m : T.member) ->
                let given =
                  Option.map
                    (typed typing ~at:(at ^ "/" ^ m.wire) m.ty)
                    (List.assoc_opt m.wire given)
                in
                if m.required && given = None then
                  D.refuse "%s %s: gives no %s, which %s requires" file at
                    m.wire name;
                { wire = m.wire; fixed = m.fixed <> None; given })
              members;
        }
  | T.Enum { values; _ }, `String s
    when List.mem (Schema.String_literal s) values ->
      T_member { enum = name; value = s }
  | T.Union { branches; tag = Some { property; _ } }, `Assoc given -> (
      let says =
        match List.assoc_opt property given with
        | Some (`String v) -> v
        | _ -> D.refuse "%s %s: gives %s no %s" file at name property
      in
      match
        List.find_opt
          (fun (b : T.branch) ->
            List.exists
              (fun (s : T.signature) ->
                List.exists
                  (fun (member, values) ->
                    member = property
                    && List.mem (Schema.String_literal says) values)
                  s.fixed)
              b.signature)
          branches
      with
      | Some b ->
          T_branch
            {
              union = name;
              variant = b.variant;
              value = typed typing ~at b.ty json;
            }
      | None ->
          D.refuse "%s %s: %s has no branch whose %s is %s" file at name
            property says)
  | T.Alias ty, _ -> typed typing ~at ty json
  | _ ->
      D.refuse "%s %s: holds %s, which no writer writes as a %s" file at
        (Yojson.Safe.to_string json)
        name

(* What [json] is as a value of [ty], at [at]. *)
let rec classify (typing : T.t) ~at (ty : T.ty) (json : Yojson.Safe.t) =
  let member enum values s =
    if List.mem (Schema.String_literal s) values then Member { enum; value = s }
    else D.refuse "%s %s: %s is no value of %s" file at s enum
  in
  match (ty, json) with
  | T.Scalar (T.Text _), `String s -> Text s
  | T.Scalar (T.Integer { minimum; maximum }), `Int value ->
      Integer { value; minimum; maximum }
  | T.Scalar T.Boolean, `Bool b -> Boolean b
  | T.Inline { name; form = T.Enum { values; _ }; _ }, `String s ->
      member name values s
  | T.Named name, _ -> (
      match ((typing.find name).form, json) with
      | T.Enum { values; _ }, `String s -> member name values s
      | (T.Record _ | T.Union _), `Assoc _ ->
          Read { schema = name; json; typed = typed typing ~at ty json }
      | T.Alias ty, _ -> classify typing ~at ty json
      | _ ->
          D.refuse "%s %s: is %s, which no writer writes as a %s" file at
            (Yojson.Safe.to_string json)
            name)
  | _ ->
      D.refuse "%s %s: is %s, of a type no writer writes" file at
        (Yojson.Safe.to_string json)

(* The type of the member [member] of the schema [owner]. *)
let member_type (typing : T.t) ~at owner member =
  match (typing.find owner).form with
  | T.Record { members; _ } -> (
      match List.find_opt (fun (m : T.member) -> m.wire = member) members with
      | Some m -> m.ty
      | None -> D.refuse "%s %s: %s has no member %s" file at owner member)
  | _ -> D.refuse "%s %s: %s is no object of members" file at owner

(* The type of a row's option: of the member of a schema surface.json states
   it as. *)
let surface_type typing ~at (m : M.method_) (row : O.defaults_item) =
  let stated (v : M.value) =
    match v.at with
    | Some (owner, member) -> member_type typing ~at owner member
    | None -> (
        match v.view with
        | D.Ref { name; _ } -> T.Named name
        | _ -> D.refuse "%s %s: states no schema a writer names" file at)
  in
  match
    ( List.find_opt
        (fun (p : M.parameter) -> p.name = row.parameter)
        m.parameters,
      row.option )
  with
  | None, _ ->
      D.refuse "%s %s: %s takes no parameter %s" file at row.method_
        row.parameter
  | Some { taken = Value v; _ }, None -> stated v
  | Some { taken = Value v; _ }, Some option -> (
      match stated v with
      | T.Named owner -> member_type typing ~at owner option
      | _ -> D.refuse "%s %s: %s is no object of options" file at row.parameter)
  | Some { taken = Spread { members; _ }; _ }, Some option -> (
      match List.assoc_opt option members with
      | Some v -> stated v
      | None ->
          D.refuse "%s %s: %s has no option %s" file at row.parameter option)
  | Some { taken = Spread { owner; _ }; _ }, None -> T.Named owner
  | Some { taken = Callback; _ }, _ ->
      D.refuse "%s %s: %s is a callback, which has no default" file at
        row.parameter

(* The type of a row's own schema, which a function of a module takes. *)
let own_type ~ids ~at (schema : O.client_surface_schema) =
  match schema with
  | Reference { ref; _ } -> (
      match Decode.resolve ids ref with
      | named, "" -> T.Named (D.stem named)
      | _ -> D.refuse "%s %s: $ref %s names no whole schema" file at ref.target)
  | Scalar { type_ = String; _ } ->
      T.Scalar (T.Text { binary = false; pattern = None })
  | Scalar { type_ = Integer; minimum; _ } ->
      T.Scalar
        (T.Integer { minimum = Option.map float_of_int minimum; maximum = None })
  | Scalar { type_ = Boolean; _ } -> T.Scalar T.Boolean
  | Type_parameter _ | Decided _ ->
      D.refuse "%s %s: is a state unit's schema, which no option has" file at

let derive (spec : Spec.t) =
  let typing = T.of_spec spec ~tables:(Roots.service_tables spec) in
  let methods = M.derive spec in
  let entries =
    List.mapi
      (fun i (row : O.defaults_item) ->
        let at = Printf.sprintf "/defaults/%d" i in
        let ty =
          match row.schema with
          | Some schema -> own_type ~ids:spec.ids ~at schema
          | None -> (
              match
                List.find_opt
                  (fun (m : M.method_) ->
                    m.namespace ^ "." ^ m.name = row.method_)
                  methods
              with
              | Some m -> surface_type typing ~at m row
              | None ->
                  D.refuse "%s %s: %s is no method of surface.json" file at
                    row.method_)
        in
        {
          name = name_of row;
          method_ = row.method_;
          docs = row.docs;
          value = classify typing ~at ty row.value;
        })
      spec.tables.client_option_defaults.defaults
  in
  List.iteri
    (fun i e ->
      if
        List.exists
          (fun (o : entry) -> o.name = e.name)
          (List.filteri (fun j _ -> j < i) entries)
      then
        D.refuse "%s /defaults/%d: is %s, which a row before it is" file i
          e.name)
    entries;
  entries

(* What a writer writes of [t]: every row but those [lacks] names, each with
   why its SDK takes no default of it. A name in [lacks] that is no row is
   refused, so a reason outlives no row. *)
let written ~language ~(lacks : (string * string) list) (t : t) =
  List.iter
    (fun (name, _) ->
      if not (List.exists (fun e -> e.name = name) t) then
        D.refuse "%s: %s lacks %s, which is no row" file language name)
    lacks;
  List.filter (fun e -> not (List.mem_assoc e.name lacks)) t

(* The module or namespace of what takes [e]: [testing] for
   [testing.createTestSession]. *)
let owner (e : entry) = List.hd (String.split_on_char '.' e.method_)
let value_named name (t : t) = (List.find (fun e -> e.name = name) t).value
