(* Every vocabulary of codes errors/codes.json states, as the OCaml SDK says
   it (ocaml/sdk/lib/error_codes.ml): a module per vocabulary, named by its
   member of the table ([signIn] is [Sign_in]); in it [t], a constructor per
   code named by the code's last segment ([bus.not-found] is
   [Bus_request.Not_found]), with [code], the code each is, and [of_code], the
   constructor a code is, if any. Its test
   (ocaml/sdk/test/error_codes_cases.ml) holds each constructor to the code
   Protocol states for it. *)

(* The module of the vocabulary [member] names, as a schema's
   [x-xynolog-codes] names it. *)
let module_of member = String.capitalize_ascii (Text.snake member)
let module_name (v : Table.vocabulary) = module_of v.member

(* The constructor of [code] in its vocabulary's [t]. *)
let constructor code =
  let last = List.hd (List.rev (String.split_on_char '.' code)) in
  String.capitalize_ascii (String.map (function '-' -> '_' | c -> c) last)

let is_constructor name =
  name <> ""
  && (match name.[0] with 'A' .. 'Z' -> true | _ -> false)
  && String.for_all
       (function 'a' .. 'z' | '0' .. '9' | '_' -> true | _ -> false)
       (String.sub name 1 (String.length name - 1))

(* Each of a vocabulary's constructors is the code Protocol states, and the
   code reads as it, with [rest] after. *)
let test (module_, values) rest =
  Ocaml_syntax.let_module "Model"
    ("Xynolog.Error_codes." ^ module_)
    (Ocaml_syntax.sequence
       (List.concat_map
          (fun (n, code) ->
            [
              Ocaml_syntax.apply
                (Ocaml_syntax.ident "Alcotest.check")
                [
                  Ocaml_syntax.ident "Alcotest.string";
                  Ocaml_syntax.string (module_ ^ " code");
                  Ocaml_syntax.string code;
                  Ocaml_syntax.apply
                    (Ocaml_syntax.ident "Model.code")
                    [ Ocaml_syntax.construct ("Model." ^ n) ];
                ];
              Ocaml_syntax.apply
                (Ocaml_syntax.ident "Alcotest.check")
                [
                  Ocaml_syntax.ident "Alcotest.bool";
                  Ocaml_syntax.string (module_ ^ " of_code");
                  Ocaml_syntax.construct "true";
                  Ocaml_syntax.infix "="
                    (Ocaml_syntax.apply
                       (Ocaml_syntax.ident "Model.of_code")
                       [ Ocaml_syntax.string code ])
                    (Ocaml_syntax.some (Ocaml_syntax.construct ("Model." ^ n)));
                ];
            ])
          values
       @ [ rest ]))

(* The JSON-RPC codes the control API answers with, a value each of
   [Control_rpc] named by its name, and the one each control code is answered
   under ([control_rpc]), with whether it is retryable ([control_retryable]). *)
let control_answers (t : Table.t) =
  let module O = Ocaml_syntax in
  let rpc_value r = Text.snake (Table.rpc_pascal r) in
  let control = module_name t.control in
  let answering name value =
    O.let_ name
      (O.function_
         (List.map
            (fun (a : Table.answered) ->
              O.case
                (O.Pattern.construct
                   (control ^ "." ^ constructor a.control_code.code))
                (value a))
            t.answered))
  in
  [
    O.module_ "Control_rpc"
      (List.map
         (fun (r : Tables.Control_rpc_codes.codes_item) ->
           O.let_ (rpc_value r) (O.int r.number))
         t.rpc_codes);
    answering "control_rpc" (fun a ->
        O.ident ("Control_rpc." ^ rpc_value a.rpc));
    answering "control_retryable" (fun a ->
        O.construct (string_of_bool a.retryable));
  ]

let files (t : Table.t) =
  let refusals = ref [] in
  let refuse message =
    refusals := { Decode.file = Table.file; pointer = ""; message } :: !refusals
  in
  let vocabularies =
    List.map
      (fun (v : Table.vocabulary) ->
        let module_ = module_name v and named = Hashtbl.create 16 in
        let values =
          List.map
            (fun (c : Table.code) ->
              let n = constructor c.code in
              if not (is_constructor n) then
                refuse (Printf.sprintf "%s names no OCaml constructor" c.code);
              if Hashtbl.mem named n then
                refuse
                  (Printf.sprintf "two of %s's constructors are both named %s"
                     module_ n);
              Hashtbl.replace named n ();
              (n, c.code))
            v.codes
        in
        (module_, values))
      ((t.bus :: t.transport :: t.others) @ [ t.control ])
  in
  let modules =
    List.map
      (fun (module_, values) ->
        Ocaml_syntax.module_ module_
          [
            Ocaml_syntax.type_item
              (Ocaml_syntax.type_declaration "t"
                 (Variant
                    (List.map (fun (n, _) -> Ocaml_syntax.constructor n) values)));
            Ocaml_syntax.let_ "code"
              (Ocaml_syntax.function_
                 (List.map
                    (fun (n, code) ->
                      Ocaml_syntax.case
                        (Ocaml_syntax.Pattern.construct n)
                        (Ocaml_syntax.string code))
                    values));
            Ocaml_syntax.let_ "of_code"
              (Ocaml_syntax.function_
                 (List.map
                    (fun (n, code) ->
                      Ocaml_syntax.case
                        (Ocaml_syntax.Pattern.string code)
                        (Ocaml_syntax.some (Ocaml_syntax.construct n)))
                    values
                 @ [
                     Ocaml_syntax.case Ocaml_syntax.Pattern.any
                       (Ocaml_syntax.construct "None");
                   ]));
          ])
      vocabularies
  in
  let banner =
    Banner.ocaml ~from_:("protocol/specs/src/" ^ Table.file) __FILE__
  in
  match List.rev !refusals with
  | [] ->
      Ok
        [
          Ocaml_syntax.implementation ~path:"ocaml/sdk/lib/error_codes.ml"
            ~banner
            (modules
            @ [
                (* Each gateway refusal of a limit that is a transport code
                   too: its status, its LimitRefusal code, and the transport
                   code it is. *)
                Ocaml_syntax.let_ "limit_refusal_transport_codes"
                  (Ocaml_syntax.list
                     (List.map
                        (fun (status, limit, (c : Table.code)) ->
                          Ocaml_syntax.tuple
                            [
                              Ocaml_syntax.int status;
                              Ocaml_syntax.string limit;
                              Ocaml_syntax.construct
                                (module_name t.transport ^ "."
                               ^ constructor c.code);
                            ])
                        t.limit_refusals));
              ]
            @ control_answers t);
          Ocaml_syntax.implementation
            ~path:"ocaml/sdk/test/error_codes_cases.ml" ~banner
            [
              Ocaml_syntax.let_unit
                (List.fold_right test vocabularies Ocaml_syntax.unit);
            ];
        ]
  | errors -> Error errors
