(* A C# held job's members that are its record's
   (csharp/sdk/src/Xynolog/Generated/HeldJobRecordMembers.g.cs): for each
   handed, a property per property of the record's C# model, declared on the
   handed's partial interface and read from [Record] on its partial class,
   saying what the model or the schema says of it. *)

module C = Csharp_syntax
module T = Typing

let path = "csharp/sdk/src/Xynolog/Generated/HeldJobRecordMembers.g.cs"

(* The C# SDK's partial interface and partial class of a handed. *)
let held = function "heldJob" -> Some ("IHeldJob", "HeldJob") | _ -> None

let file spec (records : Table.t list) =
  let typing = Typing.of_spec spec ~tables:(Roots.service_tables spec) in
  let decls (t : Table.t) =
    let interface, class_ = Table.types ~sdk:"C#" held t in
    let said =
      match (typing.find t.record).form with
      | T.Record { members; _ } ->
          List.filter_map
            (fun (m : T.member) ->
              Option.map
                (fun d -> (Csharp_sdk.Models.field_name t.record m.wire, d))
                m.description)
            members
      | _ -> Definitions.refuse "%s: no record" t.record
    in
    let properties =
      List.map
        (fun (name, type_, doc) ->
          ( name,
            type_,
            match doc with Some _ -> doc | None -> List.assoc_opt name said ))
        (Csharp_sdk.properties spec t.record)
    in
    let partial kind modifiers name members =
      C.Type
        {
          attributes = [];
          modifiers = modifiers @ [ C.Partial ];
          kind;
          name;
          params = None;
          base = None;
          body = Some (C.Packed, members);
        }
    in
    [
      partial C.Interface [ C.Public ] interface
        (List.map
           (fun (name, type_, doc) ->
             let property =
               C.Property
                 {
                   attributes = [];
                   modifiers = [ C.Public ];
                   type_;
                   name;
                   accessors = [ C.Get ];
                   value = None;
                 }
             in
             match doc with
             | Some doc -> C.Documented (doc, property)
             | None -> property)
           properties);
      partial C.Class [ C.Public; C.Abstract ] class_
        (List.map
           (fun (name, type_, _) ->
             C.Inherited
               (C.Expression_property
                  {
                    attributes = [];
                    modifiers = [ C.Public ];
                    type_;
                    name;
                    value = C.Member (C.Name "Record", name);
                  }))
           properties);
    ]
  in
  {
    Output.path;
    text =
      C.text
        {
          header =
            Banner.lines
              ~from_:
                ("protocol/specs/src/" ^ Table.file ^ " and its client types")
              __FILE__;
          nullable = true;
          usings = [];
          namespace = "Xynolog";
          decls = List.concat_map decls records;
        };
  }
