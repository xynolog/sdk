(* Generated from Selector.json and its component branches. Do not edit.
   Regenerate: make generate (codegen/lib/ocaml_sdk/selector.ml) *)

open Selector_codec

type text_position_selector = { start : Z.t; end_ : Z.t }

type text_quote_selector = {
  exact : string;
  prefix : string option;
  suffix : string option;
}

type svg_selector = { value : string }
type fragment_selector = { value : string; conforms_to : string option }

type t =
  | TextPositionSelector of text_position_selector
  | TextQuoteSelector of text_quote_selector
  | SvgSelector of svg_selector
  | FragmentSelector of fragment_selector

type fault = Schema_codec.fault = {
  member : string;
  reason : Enums.Frame_refusal_reason.t;
}

let of_json : Yojson.Safe.t -> (t, fault) result = function
  | `Assoc fields -> (
      let reader = start fields in
      let* tag = required reader string "type" in
      match tag with
      | "TextPositionSelector" ->
          let* start = required reader (integer_at_least 0) "start" in
          let* end_ = required reader (integer_at_least 0) "end" in
          Ok (TextPositionSelector { start; end_ })
      | "TextQuoteSelector" ->
          let* exact = required reader string "exact" in
          let* prefix = optional reader string "prefix" in
          let* suffix = optional reader string "suffix" in
          Ok (TextQuoteSelector { exact; prefix; suffix })
      | "SvgSelector" ->
          let* value = required reader string "value" in
          Ok (SvgSelector { value })
      | "FragmentSelector" ->
          let* value = required reader string "value" in
          let* conforms_to = optional reader string "conformsTo" in
          Ok (FragmentSelector { value; conforms_to })
      | _ -> malformed "type")
  | _ -> malformed ""

let to_json : t -> Yojson.Safe.t = function
  | TextPositionSelector value ->
      write
        [
          ("type", Some (json_string "TextPositionSelector"));
          ("start", Some (json_integer value.start));
          ("end", Some (json_integer value.end_));
        ]
  | TextQuoteSelector value ->
      write
        [
          ("type", Some (json_string "TextQuoteSelector"));
          ("exact", Some (json_string value.exact));
          ("prefix", Option.map json_string value.prefix);
          ("suffix", Option.map json_string value.suffix);
        ]
  | SvgSelector value ->
      write
        [
          ("type", Some (json_string "SvgSelector"));
          ("value", Some (json_string value.value));
        ]
  | FragmentSelector value ->
      write
        [
          ("type", Some (json_string "FragmentSelector"));
          ("value", Some (json_string value.value));
          ("conformsTo", Option.map json_string value.conforms_to);
        ]
