(* The client types group: the shapes an SDK hands its callers that no wire
   message carries (protocol/specs/src/client/types), and the form a service
   account posts with a client secret (session/ClientSecretForm.json), for the
   Haskell SDK. Each is read once into a model of its members, refusing a
   keyword the model does not know: a type's refusals are its own, and stop
   the run where a writer reads its members. *)

let types = "client/types/"
let form = "session/ClientSecretForm.json"

(* What a member holds: a scalar by its JSON Schema type, a file's bytes, one
   of some words, another schema by its name (and whether that is a union of
   branches), a list whose items the schema leaves open or states, or an object
   stated in place. A member a schema states elsewhere ([$ref] to a member of
   another schema) holds what that member holds. *)
type held =
  | Scalar of Schema.type_name
  | Binary
  | Word of string list
  | Named of { name : string; union : bool }
  | Open_list
  | List of held
  | Inline of member list

and member = { name : string; held : held; required : bool }

(* A type: words, an object's members, a list of what each item holds, or a
   union told apart by one member whose value names each branch. *)
type shape =
  | Words of string list
  | Fields of member list
  | Items of held
  | Union of { tag : string; branches : (string * member list) list }

type t = {
  shapes : (string * (shape, Decode.error list) result) list;
      (** Each client type, by its name, or why the model holds none of it. *)
  form : member list;  (** The client secret form's members, in order. *)
  grant_type : string;  (** The client assertion's grant. *)
}

let name_of file = Filename.remove_extension (Filename.basename file)

let words_of literals =
  List.fold_right
    (fun literal rest ->
      match (literal, rest) with
      | Schema.String_literal w, Some rest -> Some (w :: rest)
      | _ -> None)
    literals (Some [])

let derive (spec : Spec.t) =
  let refusals : Decode.error list ref = ref [] in
  let refuse file pointer message =
    refusals := { Decode.file; pointer; message } :: !refusals
  in
  let schema file = List.assoc_opt file spec.schemas in
  (* The keywords a member's schema may state beyond what it holds: what is
     said of it. A scalar's bounds and pattern and a list's least length no writer reads. *)
  let described s =
    List.filter (fun k -> k <> "description") (Schema.keywords s)
  in
  (* Whether a whole schema is bytes and nothing more (Binary, ByteStream):
     what a member that refers to it holds, and no shape of its own. *)
  let bytes = function
    | Schema.Schema ({ type_ = Some [ String ]; format = Some Binary; _ } as l)
      ->
        List.for_all
          (fun k -> List.mem k [ "$schema"; "$id"; "title"; "type"; "format" ])
          (described l)
    | _ -> false
  in
  let rec held (member : Schema.t) : string -> string -> held option =
    Schema.para
      ~boolean:(fun _ file pointer ->
        refuse file pointer "holds what no client type's member is stated as";
        None)
      ~schema:(fun l file pointer ->
        match l with
        | { ref_ = Some ref_; _ } when described l = [ "$ref" ] -> (
            match Decode.resolve spec.Spec.ids ref_ with
            | target, ""
              when Option.fold ~none:false ~some:bytes (schema target) ->
                Some Binary
            | target, "" ->
                let union =
                  match schema target with
                  | Some (Schema.Schema { one_of = Some _; _ }) -> true
                  | _ -> false
                in
                Some (Named { name = name_of target; union })
            | target, at -> (
                match
                  Option.bind (schema target) (fun s -> Pointer.schema s at)
                with
                | Some member -> held member target at
                | None ->
                    refuse file pointer
                      ("refers to " ^ ref_.target ^ ", which is no schema");
                    None))
        | { type_ = Some [ Array ]; items = None; _ }
          when described l = [ "type" ] ->
            Some Open_list
        | { type_ = Some [ Array ]; items = Some (_, items); _ }
          when List.for_all
                 (fun k -> List.mem k [ "type"; "items"; "minItems" ])
                 (described l) ->
            Option.map (fun item -> List item) (items file (pointer ^ "/items"))
        | { type_ = Some [ String ]; format = Some Binary; _ }
          when described l = [ "type"; "format" ] ->
            Some Binary
        | { type_ = Some [ String ]; enum = Some literals; _ }
          when described l = [ "type"; "enum" ] -> (
            match words_of literals with
            | Some words -> Some (Word words)
            | None ->
                refuse file pointer "is no enum of words";
                None)
        | { type_ = Some [ Object ]; _ } ->
            Option.map (fun members -> Inline members) (fields file pointer l)
        | { type_ = Some [ t ]; _ }
          when List.for_all
                 (fun k ->
                   List.mem k
                     [
                       "type";
                       "minimum";
                       "maximum";
                       "minLength";
                       "maxLength";
                       "pattern";
                     ])
                 (described l)
               && t <> Schema.Array ->
            Some (Scalar t)
        | _ ->
            refuse file pointer
              "holds what no client type's member is stated as";
            None)
      member
  (* [s]'s members, each member's schema beside what it holds. *)
  and fields file pointer s =
    let closed =
      match s.additional_properties with
      | None | Some (Schema.Boolean_schema false, _) -> true
      | Some _ -> false
    in
    match (s.properties, described s) with
    | Some properties, keywords
      when closed
           && List.for_all
                (fun k ->
                  List.mem k
                    [
                      "title";
                      "type";
                      "properties";
                      "required";
                      "additionalProperties";
                    ])
                keywords ->
        let required = Option.value s.required ~default:[] in
        List.iter
          (fun r ->
            if not (List.mem_assoc r properties) then
              refuse file (pointer ^ "/required")
                ("requires " ^ r ^ ", which it has not"))
          required;
        Some
          (List.filter_map
             (fun (name, (_, held)) ->
               Option.map
                 (fun held -> { name; held; required = List.mem name required })
                 (held file (pointer ^ "/properties/" ^ Decode.escape name)))
             properties)
    | _ ->
        refuse file pointer "is no object of named members";
        None
  in
  (* The members of an object stated in place. *)
  let members file pointer s =
    fields file pointer (Schema.map (fun member -> (member, held member)) s)
  in
  let find (r : Decode.reference) =
    let file, pointer = Decode.resolve spec.Spec.ids r in
    match Option.bind (schema file) (fun s -> Pointer.schema s pointer) with
    | Some s -> Ok s
    | None -> Error ("refers to " ^ r.target ^ ", which is no schema")
  in
  let whole = Definitions.typed spec in
  (* An object's members: one that is all of some schemas, those of what they
     merge to ([Normalize]), in the order they state them. *)
  let object_ file pointer : Schema.t -> member list option = function
    | Schema.Schema ({ all_of = Some _; _ } as s) as t
      when List.for_all (fun k -> List.mem k [ "title"; "allOf" ]) (described s)
      -> (
        match Normalize.normalize spec.Spec.ids ~find t with
        | Ok merged -> members file pointer merged
        | Error message ->
            refuse file pointer message;
            None)
    | Schema.Schema s when s.type_ = Some [ Object ] -> members file pointer s
    | _ ->
        refuse file pointer "is no object";
        None
  in
  let shape file = function
    | Schema.Schema ({ type_ = Some [ String ]; enum = Some literals; _ } as s)
      when List.for_all
             (fun k -> List.mem k [ "title"; "type"; "enum" ])
             (described s) -> (
        match words_of literals with
        | Some words -> Some (Words words)
        | None ->
            refuse file "/enum" "is no enum of words";
            None)
    | Schema.Schema ({ one_of = Some branches; discriminator = Some d; _ } as s)
      when d.mapping = None
           && List.for_all
                (fun k -> List.mem k [ "title"; "oneOf"; "discriminator" ])
                (described s) ->
        let tag = d.property_name in
        let branches =
          List.filter_map Fun.id
            (List.mapi
               (fun i branch ->
                 let at = Printf.sprintf "/oneOf/%d" i in
                 match branch with
                 | Schema.Schema
                     ({ type_ = Some [ Object ]; properties = Some p; _ } as b)
                   -> (
                     match List.assoc_opt tag p with
                     | Some
                         (Schema.Schema
                            ({ enum = Some [ Schema.String_literal word ]; _ }
                             as e))
                       when described e = [ "type"; "enum" ]
                            && List.mem tag
                                 (Option.value b.required ~default:[]) ->
                         Option.map
                           (fun members ->
                             (word, List.filter (fun m -> m.name <> tag) members))
                           (members file at b)
                     | _ ->
                         refuse file at
                           ("is no branch whose required " ^ tag
                          ^ " is one word");
                         None)
                 | _ ->
                     refuse file at "is no object stated in place";
                     None)
               branches)
        in
        let words = List.map fst branches in
        if List.length (List.sort_uniq compare words) <> List.length words then
          refuse file "/oneOf" ("names two branches by one " ^ tag);
        Some (Union { tag; branches })
    | Schema.Schema ({ type_ = Some [ Array ]; items = Some item; _ } as s)
      when List.for_all
             (fun k -> List.mem k [ "title"; "type"; "items" ])
             (described s) ->
        Option.map (fun item -> Items item) (held item file "/items")
    | s -> Option.map (fun members -> Fields members) (object_ file "" s)
  in
  let shapes =
    List.filter_map
      (fun (file, s) ->
        if String.starts_with ~prefix:types file && not (bytes s) then (
          let before = !refusals in
          refusals := [];
          let found =
            match whole s with
            | Ok s -> shape file s
            | Error message ->
                refuse file "" message;
                None
          in
          let own = List.rev !refusals in
          refusals := before;
          Some
            ( name_of file,
              match (found, own) with
              | Some shape, [] -> Ok shape
              | _, own -> Error own ))
        else None)
      spec.schemas
  in
  let form =
    match schema form with
    | Some (Schema.Schema s) -> Option.value (members form "" s) ~default:[]
    | _ ->
        refuse form "" "is no JSON Schema";
        []
  in
  let grant_type = spec.tables.session_client_assertion_cases.grant_type in
  match List.rev !refusals with
  | [] -> Ok { shapes; form; grant_type }
  | errors -> Error errors

let shape t name = List.assoc_opt name t.shapes
