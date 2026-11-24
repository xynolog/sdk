type t

val of_model : [ `Annotation ] Models.t -> t
val body_source : t -> string option
val is_body_resolved : t -> bool
val target_source : t -> string
val target_selector : t -> Yojson.Safe.t option
val is_highlight : t -> bool
val is_reference : t -> bool
val is_assessment : t -> bool
val is_comment : t -> bool
val is_tag : t -> bool
val is_stub_reference : t -> bool
val is_resolved_reference : t -> bool
val comment_text : t -> string option
val text_quote_selector : Yojson.Safe.t -> Selector.text_quote_selector option

val text_position_selector :
  Yojson.Safe.t -> Selector.text_position_selector option

val svg_selector : Yojson.Safe.t -> Selector.svg_selector option
val fragment_selector : Yojson.Safe.t -> Selector.fragment_selector option
val exact_text : Yojson.Safe.t option -> string
val annotation_exact_text : t -> string
val entity_types : t -> string list
val tag_category : t -> string option
val tag_schema_id : t -> string option

type spanned = Text of string | Pdf of [ `AnchoredText ] Models.t

type span_refusal =
  | Span_out_of_range
  | Item_out_of_range
  | Exact_mismatch
  | Nothing_located
  | Exact_not_covered
  | Prefix_mismatch
  | Suffix_mismatch

type span_refused_error = { code : span_refusal }

exception Span_refused of span_refused_error

val annotation_of_resource :
  created:string ->
  resource:Identifiers.Resource_id.t ->
  motivation:Enums.Motivation.t ->
  ?generator:Yojson.Safe.t ->
  ?body:Yojson.Safe.t ->
  unit ->
  ([ `Annotation ] Models.t, Models.decode_error) result

val annotation_of_span :
  created:string ->
  resource:Identifiers.Resource_id.t ->
  motivation:Enums.Motivation.t ->
  generator:Yojson.Safe.t ->
  ?body:Yojson.Safe.t ->
  spanned ->
  Records.Text_span.t ->
  ([ `Annotation ] Models.t, Models.decode_error) result

val reconcile :
  string -> Records.Quoted_text.t -> Records.Reconciled_span.t option

val locate_pdf :
  Records.Pdf_text_item.t list ->
  int ->
  int ->
  Records.Pdf_text_item.t list * Records.Pdf_coordinate.t list

val fragment : Records.Pdf_coordinate.t -> string
