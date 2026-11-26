(* Every vocabulary of codes errors/codes.json states, as the OCaml SDK says
   it (ocaml/sdk/lib/error_codes.ml): a module per vocabulary, named by its
   member of the table ([signIn] is [Sign_in]); in it [t], a constructor per
   code named by the code's last segment ([bus.not-found] is
   [Bus_request.Not_found]), with [code], the code each is, and [of_code], the
   constructor a code is, if any. Its test
   (ocaml/sdk/test/error_codes_cases.ml) holds each constructor to the code
   Protocol states for it. *)

let module_name (v : Table.vocabulary) =
  String.capitalize_ascii (Text.snake v.member)

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
   code reads as it; a text that is no code reads as none; with [rest]
   after. *)
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
       @ [
           Ocaml_syntax.apply
             (Ocaml_syntax.ident "Alcotest.check")
             [
               Ocaml_syntax.ident "Alcotest.bool";
               Ocaml_syntax.string (module_ ^ " of_code of no code");
               Ocaml_syntax.construct "true";
               Ocaml_syntax.infix "="
                 (Ocaml_syntax.apply
                    (Ocaml_syntax.ident "Model.of_code")
                    [ Ocaml_syntax.string "" ])
                 (Ocaml_syntax.construct "None");
             ];
           rest;
         ]))

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
            ~banner modules;
          Ocaml_syntax.implementation
            ~path:"ocaml/sdk/test/error_codes_cases.ml" ~banner
            [
              Ocaml_syntax.let_unit
                (List.fold_right test vocabularies Ocaml_syntax.unit);
            ];
        ]
  | errors -> Error errors
