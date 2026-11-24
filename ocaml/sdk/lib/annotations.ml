module J = Yojson.Safe.Util

type t = {
  body : Yojson.Safe.t;
  target : Yojson.Safe.t;
  motivation : Enums.Motivation.t;
}

let of_model model =
  let json = Yojson.Safe.from_string (Models.encode model) in
  {
    body = J.member "body" json;
    target = J.member "target" json;
    motivation =
      J.member "motivation" json |> J.to_string |> Enums.Motivation.of_string
      |> Option.get;
  }

let many = function `Null -> [] | `List values -> values | value -> [ value ]
let text name json = J.member name json |> J.to_string_option

let body_source annotation =
  List.find_map (fun value -> text "source" value) (many annotation.body)

let is_body_resolved annotation = Option.is_some (body_source annotation)

let target_source annotation =
  match annotation.target with
  | `String source -> source
  | target -> J.member "source" target |> J.to_string

let target_selector annotation =
  match annotation.target with
  | `Assoc fields -> List.assoc_opt "selector" fields
  | _ -> None

let is_highlight annotation =
  annotation.motivation = Enums.Motivation.Highlighting

let is_reference annotation = annotation.motivation = Enums.Motivation.Linking

let is_assessment annotation =
  annotation.motivation = Enums.Motivation.Assessing

let is_comment annotation = annotation.motivation = Enums.Motivation.Commenting
let is_tag annotation = annotation.motivation = Enums.Motivation.Tagging

let is_stub_reference annotation =
  is_reference annotation && not (is_body_resolved annotation)

let is_resolved_reference annotation =
  is_reference annotation && is_body_resolved annotation

let comment_text annotation =
  if is_comment annotation then
    Option.bind (List.nth_opt (many annotation.body) 0) (text "value")
  else None

let selectors value =
  List.filter_map
    (fun item -> Result.to_option (Selector.of_json item))
    (many value)

let text_quote_selector value =
  List.find_map
    (function Selector.TextQuoteSelector s -> Some s | _ -> None)
    (selectors value)

let text_position_selector value =
  List.find_map
    (function Selector.TextPositionSelector s -> Some s | _ -> None)
    (selectors value)

let svg_selector value =
  List.find_map
    (function Selector.SvgSelector s -> Some s | _ -> None)
    (selectors value)

let fragment_selector value =
  List.find_map
    (function Selector.FragmentSelector s -> Some s | _ -> None)
    (selectors value)

let exact_text selection =
  match Option.bind selection text_quote_selector with
  | Some selector -> selector.exact
  | None -> ""

let annotation_exact_text annotation = exact_text (target_selector annotation)

let texts_for purpose annotation =
  let purpose = Enums.Body_purpose.to_string purpose in
  many annotation.body
  |> List.filter_map (fun value ->
      if text "purpose" value = Some purpose then text "value" value else None)

let entity_types annotation =
  List.filter
    (fun name -> name <> "")
    (texts_for Enums.Body_purpose.Tagging annotation)

let tag_category annotation =
  if is_tag annotation then
    List.nth_opt (texts_for Enums.Body_purpose.Tagging annotation) 0
  else None

let tag_schema_id annotation =
  if is_tag annotation then
    List.nth_opt (texts_for Enums.Body_purpose.Classifying annotation) 0
  else None

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

let refuse code = raise (Span_refused { code })

let points text =
  Uutf.String.fold_utf_8
    (fun points _ value ->
      match value with
      | `Uchar char -> char :: points
      | `Malformed _ -> invalid_arg "invalid UTF-8")
    [] text
  |> List.rev |> Array.of_list

let between points start end_ =
  let buffer = Buffer.create (end_ - start) in
  for index = start to end_ - 1 do
    Uutf.Buffer.add_utf_8 buffer points.(index)
  done;
  Buffer.contents buffer

let collapse text =
  let buffer = Buffer.create (String.length text) in
  let space = ref false in
  Array.iter
    (fun char ->
      if Uucp.White.is_white_space char then space := Buffer.length buffer > 0
      else (
        if !space then Buffer.add_char buffer ' ';
        space := false;
        Uutf.Buffer.add_utf_8 buffer char))
    (points text);
  Buffer.contents buffer

let contains haystack needle =
  let limit = String.length haystack - String.length needle in
  let rec find at =
    at <= limit
    && (String.sub haystack at (String.length needle) = needle || find (at + 1))
  in
  find 0

let optional name value =
  Option.to_list (Option.map (fun value -> (name, value)) value)

let text value = `String value
let nonempty = function Some "" -> None | value -> value

let build ~created ~resource ~motivation ~anchor ~target ~generator ~body =
  let resource_id = Identifiers.Resource_id.to_string resource in
  let motivation = Enums.Motivation.to_string motivation in
  let id = Annotation_id.derive ~resource_id ~motivation ~anchor body in
  let fields =
    [
      ("@context", text "http://www.w3.org/ns/anno.jsonld");
      ("type", text "Annotation");
      ("id", text id);
      ("motivation", text motivation);
      ("target", target);
      ("created", text created);
    ]
    @ optional "generator" generator
    @ optional "body" body
  in
  Models.decode Models.annotation (Yojson.Safe.to_string (`Assoc fields))

let annotation_of_resource ~created ~resource ~motivation ?generator ?body () =
  let target =
    `Assoc [ ("source", text (Identifiers.Resource_id.to_string resource)) ]
  in
  build ~created ~resource ~motivation ~anchor:"" ~target ~generator ~body

let locate_pdf (items : Records.Pdf_text_item.t list) start end_ =
  let open Records.Pdf_text_item in
  let overlap =
    if start = end_ then []
    else List.filter (fun item -> item.start < end_ && item.end_ > start) items
  in
  let pages =
    List.fold_left
      (fun pages item ->
        if List.mem item.page pages then pages else pages @ [ item.page ])
      [] overlap
  in
  let rectangle page items =
    let cut item offset =
      item.x
      +. item.width
         *. float (offset - item.start)
         /. float (item.end_ - item.start)
    in
    let edges (left, bottom, right, top) item =
      let x = if item.start < start then cut item start else item.x in
      let far =
        if item.end_ > end_ then cut item end_ else item.x +. item.width
      in
      ( min left x,
        min bottom item.y,
        max right far,
        max top (item.y +. item.height) )
    in
    let x, y, right, top =
      List.fold_left edges
        (infinity, infinity, neg_infinity, neg_infinity)
        items
    in
    { Records.Pdf_coordinate.page; x; y; width = right -. x; height = top -. y }
  in
  let on_page page =
    List.filter (fun item -> item.page = page) overlap
    |> List.sort (fun a b -> compare (-.a.y, a.x) (-.b.y, b.x))
    |> List.fold_left
         (fun lines item ->
           match lines with
           | (first, items) :: rest when abs_float (item.y -. first.y) <= 2. ->
               (first, item :: items) :: rest
           | _ -> (item, [ item ]) :: lines)
         []
    |> List.rev_map (fun (_, items) -> rectangle page items)
  in
  (overlap, List.concat_map on_page pages)

let fragment (rectangle : Records.Pdf_coordinate.t) =
  let decimal value =
    let rec shortest precision =
      let rendered = Printf.sprintf "%.*g" precision value in
      if float_of_string rendered = value || precision = 17 then rendered
      else shortest (precision + 1)
    in
    if Float.is_integer value then
      Printf.sprintf "%.0f" (if value = 0. then 0. else value)
    else shortest 1
  in
  Printf.sprintf "page=%d&viewrect=%s" rectangle.page
    (String.concat ","
       (List.map decimal
          [ rectangle.x; rectangle.y; rectangle.width; rectangle.height ]))

let annotation_of_span ~created ~resource ~motivation ~generator ?body content
    (span : Records.Text_span.t) =
  let source, items =
    match content with
    | Text source -> (source, None)
    | Pdf model ->
        let anchored = Records.Anchored_text.of_model model in
        (anchored.text, Some anchored.items)
  in
  let source = points source in
  let length = Array.length source in
  let valid start end_ = start >= 0 && end_ >= start && end_ <= length in
  Option.iter
    (List.iter (fun (item : Records.Pdf_text_item.t) ->
         if not (valid item.start item.end_) then refuse Item_out_of_range))
    items;
  let { Records.Text_span.start; end_; exact; prefix; suffix } = span in
  if not (valid start end_) then refuse Span_out_of_range;
  let places =
    match items with
    | None ->
        if between source start end_ <> exact then refuse Exact_mismatch;
        [
          Selector.TextPositionSelector
            { start = Z.of_int start; end_ = Z.of_int end_; extra = [] };
        ]
    | Some items ->
        let overlap, rectangles = locate_pdf items start end_ in
        if rectangles = [] then refuse Nothing_located;
        let left, right =
          List.fold_left
            (fun (left, right) (item : Records.Pdf_text_item.t) ->
              (min left item.start, max right item.end_))
            (length, 0) overlap
        in
        if
          not (contains (collapse (between source left right)) (collapse exact))
        then refuse Exact_not_covered;
        List.map
          (fun rectangle ->
            Selector.FragmentSelector
              {
                value = fragment rectangle;
                conforms_to = Some "http://tools.ietf.org/rfc/rfc3778";
                extra = [];
              })
          rectangles
  in
  Option.iter
    (fun prefix ->
      if not (String.ends_with ~suffix:prefix (between source 0 start)) then
        refuse Prefix_mismatch)
    prefix;
  Option.iter
    (fun suffix ->
      if not (String.starts_with ~prefix:suffix (between source end_ length))
      then refuse Suffix_mismatch)
    suffix;
  let quote_selector =
    Selector.TextQuoteSelector
      { exact; prefix = nonempty prefix; suffix = nonempty suffix; extra = [] }
  in
  let target =
    `Assoc
      [
        ("type", text "SpecificResource");
        ("source", text (Identifiers.Resource_id.to_string resource));
        ( "selector",
          `List (List.map Selector.to_json (places @ [ quote_selector ])) );
      ]
  in
  let anchor = Printf.sprintf "%d:%d:%s" start end_ exact in
  build ~created ~resource ~motivation ~anchor ~target
    ~generator:(Some generator) ~body

let occurrences source needle =
  let size = Array.length needle in
  let limit = Array.length source - size in
  let rec matches at index =
    index = size
    || (Uchar.equal source.(at + index) needle.(index) && matches at (index + 1))
  in
  let rec collect at places =
    if at > limit then List.rev places
    else
      collect (at + 1)
        (if matches at 0 then (at, at + size) :: places else places)
  in
  if size = 0 then [] else collect 0 []

let transform mapping source =
  let values = mapping source in
  (Array.of_list (List.map fst values), Array.of_list (List.map snd values))

let normalized source =
  let values = ref [] and pending_space = ref None in
  Array.iteri
    (fun offset char ->
      if Uucp.White.is_white_space char then (
        if !values <> [] && !pending_space = None then
          pending_space := Some offset)
      else (
        Option.iter
          (fun at -> values := (Uchar.of_char ' ', at) :: !values)
          !pending_space;
        pending_space := None;
        let add c = values := (c, offset) :: !values in
        match Uchar.to_int char with
        | 0x2018 | 0x2019 -> add (Uchar.of_char '\'')
        | 0x201c | 0x201d -> add (Uchar.of_char '"')
        | 0x2014 ->
            add (Uchar.of_char '-');
            add (Uchar.of_char '-')
        | 0x2013 -> add (Uchar.of_char '-')
        | _ -> add char))
    source;
  List.rev !values

let lowered source =
  let following = Array.make (Array.length source) false in
  let cased = ref false in
  for index = Array.length source - 1 downto 0 do
    following.(index) <- !cased;
    let char = source.(index) in
    if not (Uucp.Case.is_case_ignorable char) then
      cased := Uucp.Case.is_cased char
  done;
  let before = ref false and output = ref [] in
  Array.iteri
    (fun index char ->
      let lower =
        if Uchar.to_int char = 0x03a3 && !before && not following.(index) then
          [ Uchar.of_int 0x03c2 ]
        else
          match Uucp.Case.Map.to_lower char with
          | `Self -> [ char ]
          | `Uchars chars -> chars
      in
      List.iter (fun value -> output := (value, index) :: !output) lower;
      if not (Uucp.Case.is_case_ignorable char) then
        before := Uucp.Case.is_cased char)
    source;
  List.rev !output

let mapped source wanted mapping =
  let source, origins = transform mapping source in
  let wanted, _ = transform mapping wanted in
  List.map
    (fun (start, end_) -> (origins.(start), origins.(end_ - 1) + 1))
    (occurrences source wanted)

let fuzzy source wanted =
  let size = Array.length wanted in
  let allowance = size / 20 in
  let length = Array.length source in
  let best = ref None in
  let update score start count =
    let rank = (score, start, abs (count - size), count) in
    if Option.fold ~none:true ~some:(fun prior -> rank < prior) !best then
      best := Some rank
  in
  if allowance > 0 then
    for start = 0 to length - (size - allowance) do
      let longest = min (size + allowance) (length - start) in
      let beyond = allowance + 1 in
      let width = (2 * allowance) + 3 in
      let at count row = count - row + allowance + 1 in
      let initial = Array.make width beyond in
      for count = 0 to min longest allowance do
        initial.(at count 0) <- count
      done;
      let rec scan taken above =
        if taken > size then
          for count = size - allowance to longest do
            let score = above.(at count size) in
            if score <= allowance then update score start count
          done
        else
          let row = Array.make width beyond in
          let minimum = ref beyond in
          for
            count = max 0 (taken - allowance) to min longest (taken + allowance)
          do
            let index = at count taken in
            let score =
              if count = 0 then taken
              else
                min beyond
                  (min
                     (above.(index + 1) + 1)
                     (min
                        (row.(index - 1) + 1)
                        (above.(index)
                        + Bool.to_int
                            (not
                               (Uchar.equal
                                  wanted.(taken - 1)
                                  source.(start + count - 1))))))
            in
            row.(index) <- score;
            minimum := min !minimum score
          done;
          if !minimum <= allowance then scan (taken + 1) row
      in
      scan 1 initial
    done;
  Option.map (fun (_, start, _, count) -> (start, start + count)) !best

let trim_space text =
  let value = points text in
  let length = Array.length value in
  let rec left i =
    if i < length && Uucp.White.is_white_space value.(i) then left (i + 1)
    else i
  in
  let start = left 0 in
  let rec right i =
    if i > start && Uucp.White.is_white_space value.(i - 1) then right (i - 1)
    else i
  in
  between value start (right length)

let reconcile text (quote : Records.Quoted_text.t) =
  let source = points text in
  let length = Array.length source in
  let wanted = points quote.exact in
  let hint value =
    Option.bind value (fun value ->
        let trimmed = trim_space value in
        if trimmed = "" then None
        else Some (trimmed, max 32 (Array.length (points value))))
  in
  let prefix = hint quote.prefix and suffix = hint quote.suffix in
  let hinted places =
    if prefix = None && suffix = None then None
    else
      List.find_opt
        (fun (start, end_) ->
          Option.fold ~none:true
            ~some:(fun (value, window) ->
              contains (between source (max 0 (start - window)) start) value)
            prefix
          && Option.fold ~none:true
               ~some:(fun (value, window) ->
                 contains
                   (between source end_ (min length (end_ + window)))
                   value)
               suffix)
        places
  in
  let boundary char =
    Uucp.White.is_white_space char
    || Uchar.to_int char < 128
       && String.contains ".,;:!?'\"()[]{}<>/\\" (Char.chr (Uchar.to_int char))
  in
  let own (start, end_) : Records.Text_span.t =
    let before = max 0 (start - 64) and after = min length (end_ + 64) in
    let rec extend_left i =
      if i > max 0 (before - 32) && not (boundary source.(i - 1)) then
        extend_left (i - 1)
      else i
    in
    let rec extend_right i =
      if i < min length (after + 32) && not (boundary source.(i)) then
        extend_right (i + 1)
      else i
    in
    {
      start;
      end_;
      exact = between source start end_;
      prefix =
        (if start = 0 then None
         else Some (between source (extend_left before) start));
      suffix =
        (if end_ = length then None
         else Some (between source end_ (extend_right after)));
    }
  in
  let module R = Records.Reconciled_span in
  if trim_space quote.exact = "" then None
  else
    match occurrences source wanted with
    | [ place ] ->
        let { Records.Text_span.start; end_; exact; prefix; suffix } =
          own place
        in
        Some (R.UniqueMatch { start; end_; exact; prefix; suffix })
    | first :: _ as places ->
        Some
          (match hinted places with
          | Some place ->
              let { Records.Text_span.start; end_; exact; prefix; suffix } =
                own place
              in
              R.ContextRecovered { start; end_; exact; prefix; suffix }
          | None ->
              let { Records.Text_span.start; end_; exact; prefix; suffix } =
                own first
              in
              R.FirstOfMany { start; end_; exact; prefix; suffix })
    | [] ->
        let places, quality =
          match mapped source wanted normalized with
          | _ :: _ as places -> (places, Enums.Match_quality.Normalized)
          | [] -> (
              match mapped source wanted lowered with
              | _ :: _ as places ->
                  (places, Enums.Match_quality.Case_insensitive)
              | [] ->
                  ( Option.to_list (fuzzy source wanted),
                    Enums.Match_quality.Fuzzy ))
        in
        Option.map
          (fun place ->
            let { Records.Text_span.start; end_; exact; prefix; suffix } =
              own place
            in
            R.FuzzyMatch
              { start; end_; exact; prefix; suffix; match_quality = quality })
          (match hinted places with
          | Some _ as found -> found
          | None -> List.nth_opt places 0)
