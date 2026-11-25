(* What the OCaml SDK's HTTP transport says of a failure
   (ocaml/sdk/lib/http_facts.ml): the transport code each status becomes,
   and the bus code each of CommandError's codes becomes. The gateway's
   routes, media types, headers and upload members are the gateway HTTP
   group's (ocaml/sdk/lib/gateway_http.ml). *)

module O = Ocaml_syntax

let file (codes : Error_codes.Table.t) =
  let in_ (v : Error_codes.Table.vocabulary) (c : Error_codes.Table.code) =
    O.construct
      ("Error_codes."
      ^ Error_codes.Ocaml.module_name v
      ^ "."
      ^ Error_codes.Ocaml.constructor c.code)
  in
  let transport = in_ codes.transport and bus = in_ codes.bus in
  let refusals = ref [] in
  let refuse file pointer message =
    refusals := { Decode.file; pointer; message } :: !refusals
  in
  let status_code =
    List.map
      (fun (status, (c : Error_codes.Table.code)) ->
        O.case (O.Pattern.int status) (transport c))
      codes.exact
    @ (match codes.from with
      | None -> []
      | Some (status, c) ->
          [
            O.case (O.Pattern.var "status")
              ~guard:(O.infix ">=" (O.ident "status") (O.int status))
              (transport c);
          ])
    @ [ O.case O.Pattern.any (transport codes.unclassified) ]
  in
  let failures =
    List.map
      (fun (wire, (c : Error_codes.Table.code)) ->
        let constructor = Error_codes.Ocaml.constructor wire in
        if not (Error_codes.Ocaml.is_constructor constructor) then
          refuse "components/schemas/CommandError.json" "/properties/code/enum"
            (Printf.sprintf "states %s, which names no OCaml constructor" wire);
        (wire, c, constructor))
      codes.wire
  in
  let failure_code =
    O.module_ "Failure_code"
      [
        O.type_item
          (O.type_declaration "t"
             (Variant (List.map (fun (_, _, c) -> O.constructor c) failures)));
        O.let_ "of_wire"
          (O.function_
             (List.map
                (fun (w, _, c) -> O.case (O.Pattern.string w) (O.construct c))
                failures
             @ [
                 O.case (O.Pattern.var "code")
                   (O.apply (O.ident "invalid_arg")
                      [
                        O.infix "^"
                          (O.string "a failure's code \"")
                          (O.infix "^" (O.ident "code")
                             (O.string
                                "\" is none of CommandError's: the reader \
                                 leaves such a code out"));
                      ]);
               ]));
      ]
  in
  let bus_failure =
    O.let_ "bus_failure"
      (O.function_
         (O.case (O.Pattern.construct "None") (bus codes.unrecognized)
         :: List.map
              (fun (_, code, c) ->
                O.case
                  (O.Pattern.construct "Some"
                     ~arg:(O.Pattern.construct ("Failure_code." ^ c)))
                  (bus code))
              failures))
  in
  let items =
    [
      O.let_ "status_code" (O.function_ status_code); failure_code; bus_failure;
    ]
  in
  match List.rev !refusals with
  | [] ->
      Ok
        (O.implementation ~path:"ocaml/sdk/lib/http_facts.ml"
           ~banner:(Banner.ocaml ~from_:"error codes" __FILE__)
           items)
  | errors -> Error errors
