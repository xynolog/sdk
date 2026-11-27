(* OCaml as the generator writes it: compiler-libs' Parsetree, built with
   Ast_helper, so a writer states values, types and modules and never a line
   of OCaml. Pprintast prints the tree and owns escaping and bracketing;
   ocamlformat-lib then lays the module out as the OCaml SDK's pinned
   ocamlformat does, so a generated file is its fixed point, and refuses one
   that does not parse. A module's banner is a comment, which a Parsetree
   cannot hold, so it is written before what Pprintast prints. *)

open Ast_helper

let named text = Location.mknoloc text

(* A name or a dotted path, such as [Telemetry.Server] or [Types.presence]. *)
let lid path =
  match Longident.unflatten (String.split_on_char '.' path) with
  | Some name -> Location.mknoloc name
  | None -> invalid_arg "Ocaml_syntax: a path of no name"

(** {1 Expressions} *)

let ident path = Exp.ident (lid path)
let string text = Exp.constant (Const.string text)
let int n = Exp.constant (Const.int n)

(* An int as [literal] spells it, such as [0o700]. *)
let integer literal = Exp.constant (Const.integer literal)
let construct ?arg path = Exp.construct (lid path) arg
let bool b = construct (if b then "true" else "false")
let none = construct "None"
let some value = construct "Some" ~arg:value
let variant ?arg tag = Exp.variant tag arg
let tuple values = Exp.tuple (List.map (fun value -> (None, value)) values)

let list values =
  List.fold_right
    (fun value tail -> construct "::" ~arg:(tuple [ value; tail ]))
    values (construct "[]")

(* A record of [fields], or, [with_] a base, that base with them in place. *)
let record ?with_ fields =
  Exp.record (List.map (fun (field, value) -> (lid field, value)) fields) with_

let apply f args =
  Exp.apply f (List.map (fun arg -> (Asttypes.Nolabel, arg)) args)

(* [f path] applied to [args]. *)
let call path args = apply (ident path) args

(* [left op right], as [Model.of_string "x" = Some Model.X]. *)
let infix op left right = apply (ident op) [ left; right ]
let unit = construct "()"

(* Each of [values] in turn, the last one's value its value. *)
let rec sequence = function
  | [] -> invalid_arg "Ocaml_syntax: a sequence of nothing"
  | [ last ] -> last
  | first :: rest -> Exp.sequence first (sequence rest)

(* [let name = value in body]. *)
let let_in name value body =
  Exp.let_ Asttypes.Nonrecursive [ Vb.mk (Pat.var (named name)) value ] body

(* [let* pattern = value in body], for whichever [let*] is in scope. *)
let let_star pattern value body =
  Exp.letop (Exp.binding_op (named "let*") pattern value Location.none) [] body

let field value name = Exp.field value (lid name)

(* [body] with [name] bound to the module at [path]. *)
let let_module name path body =
  Exp.struct_item
    (Str.module_ (Mb.mk (named (Some name)) (Mod.ident (lid path))))
    body

(** {1 Patterns} *)

module Pattern = struct
  let any = Pat.any ()
  let var name = Pat.var (named name)
  let unit = Pat.construct (lid "()") None
  let string text = Pat.constant (Const.string text)
  let int n = Pat.constant (Const.int n)
  let variant ?arg tag = Pat.variant tag arg
  let tuple patterns = Pat.tuple (List.map (fun p -> (None, p)) patterns) Closed
  let or_ left right = Pat.or_ left right

  (* [(pattern : type_)]. *)
  let constraint_ pattern type_ = Pat.constraint_ pattern type_

  (* A record of [fields], each a pattern; [open_], it may have more. *)
  let record ?(open_ = false) fields =
    Pat.record
      (List.map (fun (field, p) -> (lid field, p)) fields)
      (if open_ then Open else Closed)

  let construct ?arg path =
    Pat.construct (lid path) (Option.map (fun p -> ([], p)) arg)
end

let parameters params =
  List.map
    (fun (label, pattern) ->
      {
        Parsetree.pparam_loc = Location.none;
        pparam_desc = Pparam_val (label, None, pattern);
      })
    params

let unlabeled params = List.map (fun p -> (Asttypes.Nolabel, p)) params

(* [fun params -> body], each parameter behind its label. *)
let fun_labeled params body =
  Exp.function_ (parameters params) None (Pfunction_body body)

let fun_ params body = fun_labeled (unlabeled params) body

(* [let open path in body]. *)
let open_in path body =
  Exp.struct_item (Str.open_ (Opn.mk (Mod.ident (lid path)))) body

let if_ condition then_ else_ = Exp.ifthenelse condition then_ (Some else_)

(* A case of a [match] or a [function]: [pattern], and when [guard] holds of
   it, [value]. *)
let case ?guard pattern value = Exp.case pattern ?guard value

let function_ cases =
  Exp.function_ [] None (Pfunction_cases (cases, Location.none, []))

(* [fun params -> function cases], one function as [let f x = function ...]
   states it. *)
let fun_function params cases =
  Exp.function_
    (parameters (unlabeled params))
    None
    (Pfunction_cases (cases, Location.none, []))

let match_ value cases = Exp.match_ value cases
let assert_false = Exp.assert_ (bool false)

(** {1 Types} *)

let type_ ?(args = []) path = Typ.constr (lid path) args
let arrow from into = Typ.arrow Asttypes.Nolabel from into
let type_tuple types = Typ.tuple (List.map (fun t -> (None, t)) types)
let type_var name = Typ.var name

(* A closed polymorphic variant of [tags], none of them carrying a value. *)
let tags names =
  Typ.variant
    (List.map (fun tag -> Rf.tag (named tag) true []) names)
    Closed None

(* A constructor of a variant, carrying [args] or a record of [fields], and
   of type [result] when it is a GADT's. *)
let constructor ?(args = []) ?result name =
  Type.constructor (named name) ~args:(Pcstr_tuple args) ?res:result

let labels fields =
  List.map (fun (field, t) -> Type.field (named field) t) fields

let record_constructor name fields =
  Type.constructor (named name) ~args:(Pcstr_record (labels fields))

(* What a declared type is: abstract, a record of fields and their types, or
   a variant of constructors. *)
type kind =
  | Abstract
  | Record of (string * Parsetree.core_type) list
  | Variant of Parsetree.constructor_declaration list

(* A type [name] of [params], equal to [manifest] when there is one. *)
let type_declaration ?(params = []) ?manifest name kind =
  Type.mk (named name)
    ~params:
      (List.map
         (fun p -> (Typ.var p, (Asttypes.NoVariance, Asttypes.NoInjectivity)))
         params)
    ?manifest
    ~kind:
      (match kind with
      | Abstract -> Ptype_abstract
      | Record fields -> Ptype_record (labels fields)
      | Variant constructors -> Ptype_variant constructors)

(** {1 Items} *)

(* [let name = value], or [let name : type_ = value]. *)
let let_ ?type_ name value =
  let value_constraint =
    Option.map
      (fun typ ->
        Parsetree.Pvc_constraint { locally_abstract_univars = []; typ })
      type_
  in
  Str.value Asttypes.Nonrecursive
    [ Vb.mk ?value_constraint (Pat.var (named name)) value ]

(* [let () = value]: a module's effect when it loads. *)
let let_unit value =
  Str.value Asttypes.Nonrecursive
    [ Vb.mk (Pat.construct (lid "()") None) value ]

(* [let name params = body], each parameter a name. *)
let define name params body =
  let_ name (fun_ (List.map Pattern.var params) body)

let val_ name type_ = Sig.value (Val.mk (named name) type_)
let open_ path = Str.open_ (Opn.mk (Mod.ident (lid path)))
let type_item declaration = Str.type_ Asttypes.Recursive [ declaration ]
let type_spec declaration = Sig.type_ Asttypes.Recursive [ declaration ]

let module_ name items =
  Str.module_ (Mb.mk (named (Some name)) (Mod.structure items))

let module_alias name path =
  Str.module_ (Mb.mk (named (Some name)) (Mod.ident (lid path)))

let module_spec name items =
  Sig.module_ (Md.mk (named (Some name)) (Mty.signature items))

(* [module type name = sig items end]. *)
let module_type name items =
  Str.modtype (Mtd.mk ~typ:(Mty.signature items) (named name))

(* [path with type type_ := by]. *)
let substituted path ~type_ ~by =
  Mty.with_
    (Mty.ident (lid path))
    [ Pwith_typesubst (lid type_, Type.mk ~manifest:by (named type_)) ]

(* [module name (param : sig needs end) : result = struct items end]. *)
let functor_ name ~param ~needs ~result items =
  Str.module_
    (Mb.mk (named (Some name))
       (Mod.functor_
          (Named (named (Some param), Mty.signature needs))
          (Mod.constraint_ (Mod.structure items) result)))

(** {1 Files} *)

let format ~syntax ~path ~banner printed =
  match
    Ocamlformat_lib.Translation_unit.parse_and_format syntax ~input_name:path
      ~source:(banner ^ "\n\n" ^ printed)
      Ocamlformat_lib.Conf.default
  with
  | Ok text -> { Output.path; text }
  | Error error ->
      invalid_arg
        (Format.asprintf "Ocaml_syntax: %s is not OCaml ocamlformat reads: %a"
           path
           (fun f e -> Ocamlformat_lib.Translation_unit.Error.print f e)
           error)

(* A module's implementation, at [path] in the sdk checkout. *)
let implementation ~path ~banner items =
  format ~syntax:Ocamlformat_lib.Syntax.Structure ~path ~banner
    (Format.asprintf "%a@." Pprintast.structure items)

(* A module's interface, at [path] in the sdk checkout. *)
let interface ~path ~banner items =
  format ~syntax:Ocamlformat_lib.Syntax.Signature ~path ~banner
    (Format.asprintf "%a@." Pprintast.signature items)
