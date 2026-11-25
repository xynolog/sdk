(* A Go held job's members that are its record's (go/held_job_gen.go): for
   each handed, an interface of a method per field of the struct package api
   declares of the record, which the handed's interface embeds, and that
   method on the handed's struct, which reads the field from the record the
   struct holds. A slice or a map is returned as a copy, so that what a
   caller does to it is not the held job's. *)

module G = Go_syntax

let path = "go/held_job_gen.go"

(* The Go SDK's names of a handed: the interface of its record's members, and
   the struct that holds its record, as [record]. *)
let held = function
  | "heldJob" -> Some ("HeldJobRecordMembers", "heldJob")
  | _ -> None

let rec qualified ~declared = function
  | G.Named name when List.mem name declared -> G.Named ("api." ^ name)
  | G.Named _ as t -> t
  | G.Slice t -> G.Slice (qualified ~declared t)
  | G.Map (k, v) -> G.Map (qualified ~declared k, qualified ~declared v)
  | G.Pointer t -> G.Pointer (qualified ~declared t)
  | _ ->
      Definitions.refuse
        "a record field of a type the held job writer does not know"

let file spec (records : Table.t list) =
  let declared = List.map fst (Go_types.declared spec) in
  let uses = ref [] in
  let use package =
    if not (List.mem package !uses) then uses := package :: !uses
  in
  let members (t : Table.t) =
    let interface, struct_ = Table.types ~sdk:"Go" held t in
    let fields = Go_types.fields spec t.record in
    let field (f : G.field) =
      match f.names with
      | [ name ] -> (name, qualified ~declared f.type_, f.doc)
      | _ -> Definitions.refuse "%s: a field of more than one name" t.record
    in
    let fields = List.map field fields in
    let read name type_ =
      let field = G.Name ("h.record." ^ name) in
      match type_ with
      | G.Slice _ ->
          use "slices";
          G.call "slices.Clone" [ field ]
      | G.Map _ ->
          use "maps";
          G.call "maps.Clone" [ field ]
      | _ -> field
    in
    [
      G.Type
        {
          doc =
            G.prose
              (interface ^ " is the members of a held job that are its "
             ^ t.record ^ "'s: each is the property of its name.");
          name = interface;
          def =
            G.Interface
              (List.map
                 (fun (name, type_, doc) ->
                   G.method_ ~doc ~results:(Unnamed [ type_ ]) name [])
                 fields);
        };
      G.Adjacent
        (List.map
           (fun (name, type_, _) ->
             G.func
               ~receiver:("h", G.Pointer (G.Named struct_))
               ~results:(Unnamed [ type_ ]) name
               (One_line (G.Return [ read name type_ ])))
           fields);
    ]
  in
  let decls = List.concat_map members records in
  {
    Output.path;
    text =
      G.text
        {
          header =
            G.verbatim
              ("Code generated from protocol/specs/src/" ^ Table.file
             ^ " and its client types; DO NOT EDIT.\n\n\
                Regenerate: make generate (codegen/lib/held_job/go.ml)");
          package = "xynolog";
          imports =
            List.filter
              (fun group -> group <> [])
              [
                List.sort String.compare !uses;
                [ "github.com/xynolog/sdk/go/api" ];
              ];
          decls;
        };
  }
