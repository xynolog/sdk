(* Every vocabulary of codes errors/codes.json states, as the OCaml SDK says
   it (ocaml/sdk/lib/error_codes.ml): a module per vocabulary, named by its
   member of the table ([signIn] is [Sign_in]); in it a value per code named
   by the code's last segment ([bus.not-found] is [Bus_request.not_found]),
   and [t], a constructor per code named as its value is
   ([Bus_request.Not_found]), with [code], the code each is. *)

let module_name (v : Table.vocabulary) =
  String.capitalize_ascii (Text.snake v.member)

let value_name code =
  let last = List.hd (List.rev (String.split_on_char '.' code)) in
  String.map (function '-' -> '_' | c -> c) last

let is_value name =
  name <> ""
  && (match name.[0] with 'a' .. 'z' -> true | _ -> false)
  && String.for_all
       (function 'a' .. 'z' | '0' .. '9' | '_' -> true | _ -> false)
       name

let file (t : Table.t) =
  let refusals = ref [] in
  let refuse message =
    refusals := { Decode.file = Table.file; pointer = ""; message } :: !refusals
  in
  let modules =
    List.map
      (fun (v : Table.vocabulary) ->
        let module_ = module_name v and named = Hashtbl.create 16 in
        let values =
          List.map
            (fun (c : Table.code) ->
              let n = value_name c.code in
              if not (is_value n) then
                refuse (Printf.sprintf "%s names no OCaml value" c.code);
              if Hashtbl.mem named n || n = "code" then
                refuse
                  (Printf.sprintf "two of %s's values are both named %s" module_
                     n);
              Hashtbl.replace named n ();
              (n, c.code))
            v.codes
        in
        let constructor n = String.capitalize_ascii n in
        Ocaml_syntax.module_ module_
          (Ocaml_syntax.type_item
             (Ocaml_syntax.type_declaration "t"
                (Variant
                   (List.map
                      (fun (n, _) -> Ocaml_syntax.constructor (constructor n))
                      values)))
          :: Ocaml_syntax.let_ "code"
               (Ocaml_syntax.function_
                  (List.map
                     (fun (n, code) ->
                       Ocaml_syntax.case
                         (Ocaml_syntax.Pattern.construct (constructor n))
                         (Ocaml_syntax.string code))
                     values))
          :: List.map
               (fun (n, code) -> Ocaml_syntax.let_ n (Ocaml_syntax.string code))
               values))
      ((t.bus :: t.transport :: t.others) @ [ t.control ])
  in
  match List.rev !refusals with
  | [] ->
      Ok
        (Ocaml_syntax.implementation ~path:"ocaml/sdk/lib/error_codes.ml"
           ~banner:
             (Banner.ocaml ~from_:("protocol/specs/src/" ^ Table.file) __FILE__)
           modules)
  | errors -> Error errors
