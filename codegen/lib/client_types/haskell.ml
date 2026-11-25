(* The Haskell SDK's client types. The schemas of each it generates, which
   the haskell-sdk group writes models of into Xynolog.Types; and four
   modules: the records of a pending annotation and of a search's state, the
   events a delegation and an upload report, and the form a client secret
   proves an account with.

   Haskell's own choices are this writer's rules: a scalar's type, a record's
   field names (the type's name, then the member's), an open list's items as
   the record's one type variable, a member that names a union of branches
   as the type variable each operation instantiates at its own branch, the
   refused frame a report names as the transport's FrameRefusal, and the
   upload's events named UploadEvent, which leaves UploadProgress to be one of
   them. *)

module H = Haskell_syntax
open Model

let generated = "haskell/sdk/generated/Xynolog/Internal/Generated/"
let from_type name = "protocol/specs/src/" ^ types ^ name ^ ".json"

let refusal name message =
  { Decode.file = types ^ name ^ ".json"; pointer = ""; message }

let ( let* ) = Result.bind

let found ~shape name =
  match shape name with
  | Some (Ok s) -> Ok s
  | Some (Error refusals) -> Error refusals
  | None ->
      Error [ refusal name "is no client type, and a Haskell writer reads it" ]

(* A client type as the haskell-sdk group models one, beside the types it
   brings: words; an object, as [whole] reads it; or a union of its
   branches, each its own type named for the word that tags it, an object of
   that word and its members, each a scalar or another type's schema. Each
   branch states no member but its own. *)
let adapter ~whole name =
  let object_ members =
    let* properties =
      Spec.all
        (List.map
           (fun m ->
             match m.held with
             | Scalar t ->
                 Ok
                   ( m.name,
                     Schema.Schema { Schema.empty with type_ = Some [ t ] } )
             | Named { name = n; union = false } ->
                 Ok
                   ( m.name,
                     Schema.Schema
                       {
                         Schema.empty with
                         ref_ =
                           Some
                             {
                               Decode.target = n ^ ".json";
                               file = "";
                               pointer = "";
                             };
                       } )
             | _ -> Error [ refusal name (m.name ^ " is no scalar or type") ])
           members)
    in
    Ok
      {
        Schema.empty with
        type_ = Some [ Object ];
        properties = Some properties;
        additional_properties = Some (Schema.Boolean_schema false);
        required =
          Some
            (List.filter_map
               (fun m -> if m.required then Some m.name else None)
               members);
      }
  in
  let words words =
    {
      Schema.empty with
      type_ = Some [ String ];
      enum = Some (List.map (fun w -> Schema.String_literal w) words);
    }
  in
  let titled title (s : Schema.schema) =
    Schema.Schema { s with title = Some title }
  in
  function
  | Words w -> Ok [ (name, titled name (words w)) ]
  | Fields _ -> (
      let* s = whole name in
      match s with
      | Schema.Schema s -> Ok [ (name, titled name s) ]
      | Schema.Boolean_schema _ -> Error [ refusal name "is no object" ])
  | Items _ ->
      Error [ refusal name "is a list, which the group models as none" ]
  | Union { tag; branches } ->
      let* branches =
        Spec.all
          (List.map
             (fun (word, members) ->
               let branch = name ^ Text.pascal word in
               let* o = object_ members in
               Ok
                 ( branch,
                   titled branch
                     {
                       o with
                       properties =
                         Some
                           ((tag, Schema.Schema (words [ word ]))
                           :: Option.value o.properties ~default:[]);
                       required =
                         Some (tag :: Option.value o.required ~default:[]);
                     } ))
             branches)
      in
      let named branch =
        Schema.Schema
          {
            Schema.empty with
            ref_ =
              Some { Decode.target = branch ^ ".json"; file = ""; pointer = "" };
          }
      in
      Ok
        (( name,
           titled name
             {
               Schema.empty with
               one_of = Some (List.map (fun (b, _) -> named b) branches);
             } )
        :: branches)

(* The client types the Haskell SDK models as their group states them: each
   it generates but PendingAnnotation, which [pending_annotation] writes, and
   UploadProgress, which [operation_reports] writes. *)
let adapted spec =
  List.filter
    (fun n -> not (List.mem n [ "PendingAnnotation"; "UploadProgress" ]))
    (Definitions.generated_client_types spec)

(* A client type of [spec] as a writer of types reads it ([Definitions.typed]), by its name. *)
let whole (spec : Spec.t) =
  let written = Definitions.typed spec in
  fun name ->
    let file = Roots.client_types ^ name ^ ".json" in
    Result.map_error
      (fun message -> [ { Decode.file; pointer = ""; message } ])
      (written (List.assoc file spec.schemas))

(* The client types [names] the Haskell SDK models: an object as [whole]
   reads it, its bounds and what is said of it kept, and so any type the
   group's model holds none of. *)
let adapters ~names ~shape ~whole =
  Spec.all
    (List.map
       (fun name ->
         match shape name with
         | Some (Ok s) -> adapter ~whole name s
         | Some (Error _) -> (
             let* s = whole name in
             match s with
             | Schema.Schema s ->
                 Ok [ (name, Schema.Schema { s with title = Some name }) ]
             | Schema.Boolean_schema _ -> Error [ refusal name "is no schema" ])
         | None -> Error [ refusal name "is no client type" ])
       names)
  |> Result.map List.concat

let scalar name : Schema.type_name -> (H.type_, Decode.error list) result =
  function
  | String -> Ok (T_name "Text")
  | Integer -> Ok (T_name "Integer")
  | Number -> Ok (T_name "Scientific")
  | Boolean -> Ok (T_name "Bool")
  | Object | Array -> Error [ refusal name "holds an open object or list" ]
  | Null -> Error [ refusal name "is null alone" ]

let lower name = String.uncapitalize_ascii name
let accessor type_name member = lower type_name ^ String.capitalize_ascii member

let aeson_records =
  H.import "Data.Aeson" ~items:[ All "ToJSON"; Plain "object"; Op ".=" ]

(* A record of a client type, written to its JSON: every member required,
   and an open list's items the record's one type variable. *)
let record_module ~shape name =
  let* s = found ~shape name in
  let* members =
    match s with
    | Fields members -> Ok members
    | _ -> Error [ refusal name "is no record" ]
  in
  let variable = "value" in
  let* fields =
    Spec.all
      (List.map
         (fun m ->
           let field t = Ok (accessor name m.name, t) in
           if not m.required then
             Error
               [ refusal name (m.name ^ " is optional, and a record's is not") ]
           else
             match m.held with
             | Scalar t -> Result.bind (scalar name t) field
             | Named { name = n; _ } -> field (H.T_name n)
             | Open_list -> field (H.T_list (H.T_name variable))
             | _ ->
                 Error [ refusal name (m.name ^ " is no scalar, type or list") ])
         members)
  in
  let params =
    if List.exists (fun m -> m.held = Open_list) members then [ variable ]
    else []
  in
  let instance class_ =
    H.instance class_
      ~context:(List.map (fun v -> (class_, v)) params)
      (match params with
      | [] -> H.T_name name
      | vs -> H.T_apply (name, List.map (fun v -> H.T_name v) vs))
  in
  let named =
    List.sort_uniq compare
      (List.filter_map
         (fun m ->
           match m.held with Named { name = n; _ } -> Some n | _ -> None)
         members)
  in
  let module_ = "Xynolog.Internal.Generated." ^ name in
  Ok
    {
      Output.path = generated ^ name ^ ".hs";
      text =
        H.text
          {
            banner = Banner.lines ~from_:(from_type name) __FILE__;
            extensions = [ "OverloadedStrings" ];
            name = module_;
            imports =
              aeson_records
              ::
              (if named = [] then []
               else
                 [
                   H.import "Xynolog.Types"
                     ~items:(List.map (fun n -> H.Plain n) named);
                 ]);
            body =
              [
                H.record name ~constructor:name ~params
                  ~deriving:[ "Eq"; "Show" ] fields;
                instance "ToJSON"
                  [
                    ( "toJSON",
                      {
                        patterns = [ Var "record" ];
                        body =
                          Apply
                            ( Name "object",
                              [
                                List
                                  (List.map
                                     (fun (m, (field, _)) ->
                                       H.Infix
                                         ( Str m.name,
                                           [
                                             ( ".=",
                                               Apply
                                                 (Name field, [ Name "record" ])
                                             );
                                           ] ))
                                     (List.combine members fields));
                              ] );
                      } );
                  ];
              ];
          };
    }

let pending_annotation ~shape = record_module ~shape "PendingAnnotation"
let search_state ~shape = record_module ~shape "SearchState"

(* How the transport's FrameRefusal states each member of a refused frame's
   report. *)
let refused_member value = function
  | "channel" -> Some (H.Apply (Name "refusedChannel", [ value ]))
  | "member" ->
      Some (H.Apply (Name "member", [ Apply (Name "fault", [ value ]) ]))
  | "reason" ->
      Some (H.Apply (Name "reason", [ Apply (Name "fault", [ value ]) ]))
  | _ -> None

(* The reports' sums: each branch a constructor holding its members but the
   tag, in order, and written back to the branch's JSON; and the types of
   Xynolog.Types they hold. *)
let report ~shape ~native ~prefix name =
  let* s = found ~shape name in
  let* tag, branches =
    match s with
    | Union { tag; branches } -> Ok (tag, branches)
    | _ -> Error [ refusal name "is no union" ]
  in
  let completion = "completion" in
  let held branch (m : member) :
      (H.type_ * (H.expr -> H.expr), Decode.error list) result =
    let plain t = Ok (t, fun v -> v) in
    match m.held with
    | Scalar t -> Result.bind (scalar name t) plain
    | Named { name = _; union = true } -> plain (H.T_name completion)
    | Named { name = n; union = false } -> plain (H.T_name n)
    | Inline refused -> (
        let encoded =
          List.map
            (fun (r : member) -> (r.name, refused_member (H.Name "v") r.name))
            refused
        in
        match List.find_opt (fun (_, e) -> e = None) encoded with
        | Some (unknown, _) ->
            Error
              [
                refusal name
                  (branch ^ "'s " ^ m.name ^ " reports " ^ unknown
                 ^ ", which no FrameRefusal states");
              ]
        | None ->
            Ok
              ( T_name "FrameRefusal",
                fun value ->
                  Apply
                    ( Name "object",
                      [
                        List
                          (List.map
                             (fun (r : member) ->
                               H.Infix
                                 ( Str r.name,
                                   [
                                     ( ".=",
                                       Option.get (refused_member value r.name)
                                     );
                                   ] ))
                             refused);
                      ] ) ))
    | _ ->
        Error
          [ refusal name (branch ^ "'s " ^ m.name ^ " is no report member") ]
  in
  let* rows =
    Spec.all
      (List.map
         (fun (word, members) ->
           let* fields = Spec.all (List.map (held word) members) in
           Ok (word, prefix ^ String.capitalize_ascii word, members, fields))
         branches)
  in
  let generic =
    List.exists
      (fun (_, _, _, fields) ->
        List.exists (fun (t, _) -> t = H.T_name completion) fields)
      rows
  in
  let params = if generic then [ completion ] else [] in
  let value i = Printf.sprintf "value%d" i in
  let named =
    List.concat_map
      (fun (_, members) ->
        List.filter_map
          (fun (m : member) ->
            match m.held with
            | Named { name = n; union = false } -> Some n
            | _ -> None)
          members)
      branches
  in
  Ok
    ( named,
      [
        H.data native ~params ~deriving:[ "Eq"; "Show" ]
          (List.map
             (fun (_, constructor, _, fields) ->
               H.constructor constructor ~fields:(List.map fst fields))
             rows);
        H.instance "ToJSON"
          ~context:(List.map (fun v -> ("ToJSON", v)) params)
          (match params with
          | [] -> H.T_name native
          | vs -> H.T_apply (native, List.map (fun v -> H.T_name v) vs))
          (List.map
             (fun (word, constructor, members, fields) ->
               ( "toJSON",
                 {
                   H.patterns =
                     [
                       Constructor
                         ( constructor,
                           List.mapi (fun i _ -> H.Var (value i)) fields );
                     ];
                   body =
                     Apply
                       ( Name "object",
                         [
                           List
                             (H.Infix
                                ( Str tag,
                                  [ (".=", Typed (Str word, T_name "Text")) ] )
                             :: List.mapi
                                  (fun i ((m : member), (_, encode)) ->
                                    H.Infix
                                      ( Str m.name,
                                        [ (".=", encode (H.Name (value i))) ] ))
                                  (List.combine members fields));
                         ] );
                 } ))
             rows);
      ] )

let operation_reports ~shape =
  let* jobs_named, jobs =
    report ~shape ~native:"JobEvent" ~prefix:"" "JobEvent"
  in
  let* uploads_named, uploads =
    report ~shape ~native:"UploadEvent" ~prefix:"Upload" "UploadProgress"
  in
  Ok
    {
      Output.path = generated ^ "OperationReports.hs";
      text =
        H.text
          {
            banner =
              Banner.lines
                ~from_:
                  (from_type "JobEvent" ^ " and " ^ from_type "UploadProgress")
                __FILE__;
            extensions = [ "OverloadedStrings" ];
            name = "Xynolog.Internal.Generated.OperationReports";
            imports =
              [
                H.import "Data.Aeson"
                  ~items:[ All "ToJSON"; Plain "object"; Op ".=" ];
                H.import "Data.Text" ~items:[ Plain "Text" ];
                H.import "Xynolog.Types"
                  ~items:
                    (List.map
                       (fun n -> H.Plain n)
                       (List.sort_uniq compare (jobs_named @ uploads_named)));
                H.import "Xynolog.Internal.Transport"
                  ~items:[ All "FrameRefusal" ];
                H.import "Xynolog.Internal.Required" ~items:[ All "Fault" ];
              ];
            body = jobs @ uploads;
          };
    }

(* The client secret form, as the account's id and secret make it: its grant
   the client assertion's, by the constant ClientAssertion states. *)
let service_proof ~grant_type (form : member list) =
  let refused message =
    Error [ { Decode.file = Model.form; pointer = ""; message } ]
  in
  let* pairs =
    Spec.all
      (List.map
         (fun (m : member) ->
           match (m.name, m.held) with
           | "grant_type", Word [ word ] when word = grant_type ->
               Ok (H.Tuple [ Str m.name; Name "Policy.grantType" ])
           | "grant_type", _ ->
               refused "grant_type is not the client assertion's grant"
           | "client_id", Scalar String ->
               Ok (H.Tuple [ Str m.name; Name "identity" ])
           | "client_secret", Scalar String ->
               Ok (H.Tuple [ Str m.name; Name "secret" ])
           | name, _ ->
               refused (name ^ " is no member a secret proof is made of"))
         form)
  in
  Ok
    {
      Output.path = generated ^ "ServiceProof.hs";
      text =
        H.text
          {
            banner =
              Banner.lines ~from_:("protocol/specs/src/" ^ Model.form) __FILE__;
            extensions = [ "OverloadedStrings" ];
            name = "Xynolog.Internal.Generated.ServiceProof";
            imports =
              [
                H.import "Data.Text" ~items:[ Plain "Text" ];
                H.import "Xynolog.Internal.Generated.ClientAssertion"
                  ~qualified:"Policy";
              ];
            body =
              [
                H.Value
                  {
                    about = [];
                    name = "secretProof";
                    type_ =
                      T_fun
                        ( T_name "Text",
                          T_fun
                            ( T_name "Text",
                              T_list (T_tuple [ T_name "Text"; T_name "Text" ])
                            ) );
                    clauses =
                      [
                        {
                          patterns = [ Var "identity"; Var "secret" ];
                          body = List pairs;
                        };
                      ];
                  };
              ];
          };
    }
