(* The failure vocabularies as the Kotlin SDK writes them (xynolog.errors):
   an enum per vocabulary, named as Go names its type, each value as the wire
   spells it; the transport code each HTTP status becomes; and the bus code
   each of the wire's own codes (CommandError.code, in its enum's order,
   [Table.wire_codes]) becomes, as an exhaustive [when] over the type the Kotlin
   types give CommandError's code. *)

module K = Kotlin_syntax
module Names = Kotlin_sdk.Names

(* A code's constant: its part after its first dot. *)
let variant code =
  Names.variant_of
    (match String.index_opt code '.' with
    | Some i -> String.sub code (i + 1) (String.length code - i - 1)
    | None -> code)

let vocabulary ~docs (v : Table.vocabulary) =
  let taken = Hashtbl.create 16 in
  K.class_ ~about:(K.Doc docs)
    ~annotations:[ K.annotation "Generated" ]
    ~visibility:K.Public
    ~constructor:
      (K.constructor
         [
           K.param ~about:(K.Doc "The code as the wire and every SDK spell it.")
             ~binding:(K.Bound { visibility = K.Public; mutable_ = false })
             "code" (K.Type "String");
         ])
    ~entries:
      (List.map
         (fun (c : Table.code) ->
           let constant = variant c.code in
           if Hashtbl.mem taken constant then
             Names.refuse "%s: two codes would both be %s" v.go_name constant;
           Hashtbl.replace taken constant ();
           K.entry ~about:(K.Block c.docs) ~args:[ K.Str c.code ] constant)
         v.codes)
    K.Enum_class v.go_name

let member type_ (c : Table.code) = K.Member (K.Name type_, variant c.code)

let file ~(types : Kotlin_sdk.Types.spec) (t : Table.t) =
  let code_type =
    Kotlin_sdk.Types.value_type_of types ~component:"CommandError"
      ~member:(Some "code")
  in
  let code_name =
    match code_type with
    | K.Type name -> name
    | _ -> Names.refuse "CommandError's code is no enum the Kotlin types name"
  in
  let transport = t.transport.go_name and bus = t.bus.go_name in
  let status op n = K.Binary (K.Name "status", op, K.Int n) in
  Kotlin_sdk.table ~from_:Table.file __FILE__ ~package:"xynolog.errors"
    ~name:"ErrorCodes"
    ~imports:
      (List.sort_uniq String.compare
         ("xynolog.Generated" :: Kotlin_sdk.Types.imports_of types code_type))
    ([
       vocabulary
         ~docs:
           "Why a transport failed a request: what a server refused, or that \
            none answered."
         t.transport;
       vocabulary ~docs:"Why a bus request did not resolve." t.bus;
     ]
    @ List.map
        (fun (v : Table.vocabulary) -> vocabulary ~docs:v.docs v)
        (t.others @ [ t.control ])
    @ [
        K.function_ ~about:(K.Doc "The code a refusal of `status` fails with.")
          ~visibility:K.Internal
          ~params:[ ("status", K.Type "Int") ]
          ~returns:(K.Type transport) "transportErrorCodeFor"
          (K.Same_line
             (K.When
                {
                  subject = None;
                  branches =
                    List.map
                      (fun (n, code) ->
                        {
                          K.conditions = [ K.Equal (status K.Eq n) ];
                          result = member transport code;
                        })
                      t.exact
                    @ List.map
                        (fun (n, code) ->
                          {
                            K.conditions = [ K.Equal (status K.Ge n) ];
                            result = member transport code;
                          })
                        (Option.to_list t.from)
                    @ [
                        {
                          K.conditions = [];
                          result = member transport t.unclassified;
                        };
                      ];
                }));
        K.function_
          ~about:
            (K.Doc
               "The client code each of CommandError's codes, a failure's own \
                code, becomes.")
          ~visibility:K.Internal
          ~params:[ ("code", code_type) ]
          ~returns:(K.Type bus) "busRequestCodeOf"
          (K.Same_line
             (K.When
                {
                  subject = Some (K.Name "code");
                  branches =
                    List.map
                      (fun wire ->
                        {
                          K.conditions =
                            [
                              K.Equal
                                (K.Member
                                   (K.Name code_name, Names.variant_of wire));
                            ];
                          result = member bus (List.assoc wire t.wire);
                        })
                      Table.wire_codes;
                }));
        K.property
          ~about:
            (K.Doc
               "The client code of a failure that states no code: one whose \
                code the required table does not recognize is read as stating \
                none.")
          ~visibility:K.Internal ~type_:(K.Type bus)
          ~value:(K.Same_line (member bus t.unrecognized))
          "UNRECOGNIZED_FAILURE";
      ])
