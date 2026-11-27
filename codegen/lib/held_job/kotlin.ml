(* A Kotlin held job's members that are its record's (xynolog.jobs, in
   generated code beside the types): for each handed, an abstract class the
   handed's class extends, which holds the record as [record] and has a
   property per property of the data class declared of the record, read
   from it. A property Java reads boxed is boxed here too. *)

module K = Kotlin_syntax

let package = "xynolog.jobs"

(* The Kotlin SDK's class of a handed's record members. *)
let held = function "heldJob" -> Some "HeldJobRecordMembers" | _ -> None
let public_val = K.Bound { visibility = K.Public; mutable_ = false }

let file spec (t : Table.t) =
  let types =
    match Kotlin_sdk.spec_of spec with
    | Ok types -> types
    | Error message -> Definitions.refuse "%s" message
  in
  let name = Table.types ~sdk:"Kotlin" held t in
  let properties = Kotlin_sdk.Types.properties types t.record in
  let record = K.Type t.record in
  let imports =
    List.sort_uniq String.compare
      (List.concat_map
         (Kotlin_sdk.Types.imports_of types)
         (record :: List.map (fun (_, type_, _, _) -> type_) properties))
  in
  let decls =
    [
      K.class_
        ~about:
          (K.Doc
             ("The members of a held job that are its `" ^ t.record
            ^ "`'s: each is the property of its name."))
        ~visibility:K.Public
        ~constructor:
          (K.constructor ~visibility:K.Internal
             [
               K.param ~about:(K.Doc "The job as its claim handed it.")
                 ~binding:public_val "record" record;
             ])
        ~members:
          (List.map
             (fun (property, type_, about, boxed) ->
               K.property ?about
                 ~annotations:
                   (if boxed then
                      [ K.annotation ~target:"get" "JvmExposeBoxed" ]
                    else [])
                 ~visibility:K.Public ~type_
                 ~value:(K.Getter (K.Member (K.Name "record", property)))
                 property)
             properties)
        K.Abstract_class name;
    ]
  in
  let named = K.referenced decls in
  {
    Output.path = Kotlin_sdk.path package name;
    text =
      K.text
        {
          banner =
            Banner.lines
              ~from_:
                ("protocol/specs/src/" ^ Table.file ^ " and its client types")
              __FILE__;
          file_annotations = Kotlin_sdk.opt_in named;
          package;
          imports;
          decls;
        };
  }
