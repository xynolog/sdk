(* ocaml_raw_census.exe SDK: every value the OCaml SDK's records hold as its
   raw JSON is one [Typing] gives no type: a schema that constrains nothing,
   or an object that names no member. A writer that keeps a value raw that
   Typing types fails this. It names each record's member so held, which is
   what the SDK leaves untyped. SDK is the checkout's root. *)

open Xynolog_codegen
module T = Typing
module R = Ocaml_sdk.Records

let root = Sys.argv.(1)

let refused errors =
  List.iter (fun e -> prerr_endline (Decode.error_to_string e)) errors;
  exit 1

let spec =
  match Spec_shapes.load (Filename.concat root "protocol/specs/src") with
  | Ok spec -> spec
  | Error errors -> refused errors

let typing = Typing.of_spec spec ~tables:(Roots.service_tables spec)

let entries =
  match Table_records.all spec with
  | Error message -> failwith message
  | Ok table -> (
      match R.derive spec typing table with
      | Ok (entries, _) -> entries
      | Error errors -> refused errors)

let rec resolved (ty : T.ty) =
  match ty with
  | Named name -> (
      match (typing.find name).form with Alias ty -> resolved ty | _ -> ty)
  | Inline { form = Alias ty; _ } -> resolved ty
  | ty -> ty

let untyped_form (form : T.form) =
  match form with
  | Json | Empty _ | Enum { base = None; _ } | Record { members = []; _ } ->
      true
  | Record _ | Map _ | Enum _ | Alias _ | Identifier _ | Union _ -> false

let untyped ty =
  match resolved ty with
  | Any | Null | Nothing -> true
  | Named name -> untyped_form (typing.find name).form
  | Inline i -> untyped_form i.form
  | Scalar _ | List _ | Nullable _ -> false

(* The type of a map's every member, as Typing states the map. *)
let map_value ty =
  match resolved ty with
  | Named name -> (
      match (typing.find name).form with
      | Map { value; _ } -> Some value
      | _ -> None)
  | Inline { form = Map { value; _ }; _ } -> Some value
  | _ -> None

(* Whether each place [held] keeps raw is one [ty] leaves untyped. *)
let rec agrees (held : R.held) ty =
  match (held, resolved ty) with
  | Raw, _ -> untyped ty
  | Nullable held, Nullable ty -> agrees held ty
  | List_of Raw, List None -> true
  | List_of held, List (Some ty) -> agrees held ty
  | Map_of held, _ -> (
      match map_value ty with
      | Some value -> agrees held value
      | None -> held = Raw && untyped ty)
  | _ -> true

let rec holds_raw (held : R.held) =
  match held with
  | Raw -> true
  | List_of held | Map_of held | Nullable held -> holds_raw held
  | Text | Bool | Int | Float | Enum _ | Stated _ | Record _ | Union _
  | Tabled _ ->
      false

let () =
  let raw = ref [] and wrong = ref [] in
  let held ~place (held : R.held) ty =
    if not (agrees held ty) then wrong := place :: !wrong
    else if holds_raw held then raw := place :: !raw
  in
  List.iter
    (fun (e : R.entry) ->
      match e.shape with
      | Object fields ->
          List.iter
            (fun (f : R.held_member) ->
              let ty =
                match f.member.ty with
                | Nullable ty when f.nullable -> ty
                | ty -> ty
              in
              held ~place:(e.module_ ^ "." ^ f.member.wire) f.held ty)
            fields
      | Members branches ->
          List.iter
            (fun (b : R.held_branch) ->
              held
                ~place:(e.module_ ^ "." ^ b.branch.variant)
                b.held b.branch.ty)
            branches)
    entries;
  match List.rev !wrong with
  | [] ->
      let raw = List.rev !raw in
      Printf.printf "The OCaml SDK holds %d values as their raw JSON:\n"
        (List.length raw);
      List.iter (Printf.printf "  %s\n") raw
  | wrong ->
      List.iter
        (Printf.eprintf "%s is held as raw JSON, which Typing types\n")
        wrong;
      exit 1
