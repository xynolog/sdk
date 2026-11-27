(* The client's surface (protocol/specs/src/client/surface.json) as each SDK's
   surface test calls it: every method, by its namespace and name, with its
   shape and the parameters it takes, each parameter's schema as the generator
   views it ([Definitions.view]). A parameter that is an object none of whose
   members is required is [Spread]: a writer may take its members one by one
   (S1), and a case may leave any of them out. A callback is no argument a
   case gives, so the test passes none, and one a caller must give is
   refused. *)

module S = Tables.Client_surface
module D = Definitions

let file = "client/surface.json"

(* A value as the generator views it, and where it is stated: the schema and
   the member of it, for one stated as a member of another; none for a whole
   schema, or a scalar the table states itself. *)
type value = { view : D.t; at : (string * string) option }

type taken =
  | Value of value
  | Spread of { owner : string; members : (string * value) list }
  | Callback

type parameter = { name : string; required : bool; taken : taken }

type method_ = {
  namespace : string;
  name : string;
  shape : S.shape;
  parameters : parameter list;
}

(* [schema] as [view] views a schema. A reference into a file is to a member
   of the schema the file states, by [/properties/<member>]. *)
let value ~ids ~view (schema : S.schema) =
  match schema with
  | Reference { ref } ->
      let at =
        match Decode.resolve ids ref with
        | _, "" -> None
        | file, pointer -> (
            match String.split_on_char '/' pointer with
            | [ ""; "properties"; member ] -> Some (D.stem file, member)
            | _ ->
                D.refuse "$ref %s points at no member of its schema" ref.target)
      in
      { view = view (Schema.Schema { Schema.empty with ref_ = Some ref }); at }
  | Scalar { type_; minimum; description } ->
      let type_ : Schema.type_name =
        match type_ with
        | Integer -> Integer
        | String -> String
        | Boolean -> Boolean
      in
      {
        view =
          view
            (Schema.Schema
               {
                 Schema.empty with
                 type_ = Some [ type_ ];
                 minimum = Option.map float_of_int minimum;
                 description = Some description;
               });
        at = None;
      }

(* The members of a named object none of whose members is required, [schema]
   giving each named schema's view. *)
let spread ~schema = function
  | { view = D.Ref { name; _ }; _ } -> (
      match D.meant (schema name) with
      | D.Node
          {
            type_ = Some (D.One Object);
            properties = Some (_ :: _ as members);
            required = None | Some [];
            _;
          } ->
          Some
            ( name,
              List.map
                (fun (member, view) ->
                  (member, { view; at = Some (name, member) }))
                members )
      | _ -> None)
  | _ -> None

(* The methods of [namespaces], [view] viewing a schema and [schema] giving
   each named schema's view. *)
let methods ~ids ~view ~schema (namespaces : S.namespaces_item list) =
  List.concat
    (List.mapi
       (fun n (ns : S.namespaces_item) ->
         List.mapi
           (fun i (m : S.methods_item) ->
             let parameters =
               List.mapi
                 (fun k (p : S.parameters_item) ->
                   match p with
                   | Value { parameter; schema = stated; required } ->
                       let v = value ~ids ~view stated in
                       {
                         name = parameter;
                         required;
                         taken =
                           (match spread ~schema v with
                           | Some (owner, members) -> Spread { owner; members }
                           | None -> Value v);
                       }
                   | Callback { parameter; required; _ } ->
                       if required then
                         D.refuse
                           "%s /namespaces/%d/methods/%d/parameters/%d: %s is \
                            a callback a caller must give, which a case cannot"
                           file n i k parameter;
                       { name = parameter; required; taken = Callback })
                 m.parameters
             in
             {
               namespace = ns.namespace;
               name = m.method_;
               shape = m.shape;
               parameters;
             })
           ns.methods)
       namespaces)

let derive (spec : Spec.t) =
  let bundle = D.bundle spec in
  methods ~ids:spec.ids ~view:(bundle.view ~at:None)
    ~schema:bundle.definitions.schema spec.tables.client_surface.namespaces
