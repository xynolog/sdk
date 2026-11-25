(* A Python held job's members that are its record's
   (python/sdk/src/xynolog/_held_job.py, whose classes the held jobs of
   xynolog.claims are made of): for each handed, a class of a property per
   field of the class types.py declares of the record, which reads it from
   the record the held job holds as [record]. A list is read as a sequence
   and a dict as a mapping, which the held job's caller does not change. *)

module P = Python_syntax

let path = "python/sdk/src/xynolog/_held_job.py"

(* The Python SDK's class of a handed's record members. *)
let held = function "heldJob" -> Some "HeldJobRecordMembers" | _ -> None
let builtin = [ "str"; "int"; "float"; "bool"; "bytes"; "None" ]

let rec read_only = function
  | P.Subscript (P.Name "list", items) ->
      P.Subscript (P.Name "Sequence", read_only_items items)
  | P.Subscript (P.Name "dict", items) ->
      P.Subscript (P.Name "Mapping", read_only_items items)
  | P.Subscript (f, items) -> P.Subscript (f, read_only_items items)
  | P.Binary (a, op, b) -> P.Binary (read_only a, op, read_only b)
  | e -> e

and read_only_items (items : P.items) =
  {
    items with
    elements =
      List.map
        (fun (e : P.element) -> { e with value = read_only e.value })
        items.elements;
  }

let rec names = function
  | P.Name n -> [ n ]
  | P.Subscript (f, items) -> names f @ List.concat_map names (values items)
  | P.Binary (a, _, b) -> names a @ names b
  | _ -> []

and values (items : P.items) =
  List.map (fun (e : P.element) -> e.value) items.elements

let file spec (records : Table.t list) =
  let members (t : Table.t) =
    let name = Table.types ~sdk:"Python" held t in
    let fields =
      List.map
        (fun (field, type_, doc) -> (field, read_only type_, doc))
        (Python_types.fields spec t.record)
    in
    ( t.record :: List.concat_map (fun (_, type_, _) -> names type_) fields,
      P.Class
        {
          decorators = [];
          name;
          bases = [];
          doc =
            Some
              (Wrapped
                 ("The members of a held job that are its `" ^ t.record
                ^ "`'s: each is the property of its name."));
          spacing = P.Spaced;
          body =
            P.field "record" (P.Name t.record)
            :: List.map
                 (fun (field, returns, doc) ->
                   P.Property
                     {
                       name = field;
                       returns;
                       doc = Option.map (fun d -> P.Wrapped d) doc;
                       body = [ P.Return (P.Name ("self.record." ^ field)) ];
                     })
                 fields;
        } )
  in
  let written = List.map members records in
  let named =
    List.sort_uniq String.compare
      (List.filter
         (fun n -> not (List.mem n (builtin @ [ "Sequence"; "Mapping" ])))
         (List.concat_map fst written))
  in
  let homes =
    List.sort_uniq String.compare (List.map (Python_types.home spec) named)
  in
  let abstract =
    List.filter
      (fun n -> List.exists (fun (ns, _) -> List.mem n ns) written)
      [ "Mapping"; "Sequence" ]
  in
  {
    Output.path;
    text =
      P.text
        {
          header =
            Banner.python_lines
              ~from_:
                ("protocol/specs/src/" ^ Table.file ^ " and its client types")
              __FILE__;
          doc =
            As_is
              "The members of a held job that are its record's, as \
               client/surface.json names the record.";
          imports =
            [ [ P.From ("__future__", [ "annotations" ]) ] ]
            @ (if abstract = [] then []
               else [ [ P.From ("collections.abc", abstract) ] ])
            @ [ [ P.From ("typing", [ "TYPE_CHECKING" ]) ] ];
          body =
            P.If
              ( P.Name "TYPE_CHECKING",
                [
                  P.Imports
                    [
                      List.map
                        (fun home ->
                          P.From
                            ( home,
                              List.filter
                                (fun n -> Python_types.home spec n = home)
                                named ))
                        homes;
                    ];
                ] )
            :: List.map snd written;
        };
  }
