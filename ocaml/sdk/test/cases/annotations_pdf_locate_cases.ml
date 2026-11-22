(* Generated from protocol/specs/src/annotations/pdf-locate-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type span = { start : int; end_ : int }

let span_json (r : span) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("start", (fun n -> `Int n) r.start);
         Option.Some ("end", (fun n -> `Int n) r.end_);
       ])

type pdf_coordinate = {
  page : int;
  x : float;
  y : float;
  width : float;
  height : float;
}

let pdf_coordinate_json (r : pdf_coordinate) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("page", (fun n -> `Int n) r.page);
         Option.Some ("x", (fun f -> `Float f) r.x);
         Option.Some ("y", (fun f -> `Float f) r.y);
         Option.Some ("width", (fun f -> `Float f) r.width);
         Option.Some ("height", (fun f -> `Float f) r.height);
       ])

type cases_item = {
  why : string;
  anchored : Yojson.Safe.t;
  span : span;
  overlapping : Yojson.Safe.t list;
  rects : pdf_coordinate list;
  fragments : string list;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("anchored", Fun.id r.anchored);
         Option.Some ("span", span_json r.span);
         Option.Some
           ("overlapping", (fun l -> `List (List.map Fun.id l)) r.overlapping);
         Option.Some
           ("rects", (fun l -> `List (List.map pdf_coordinate_json l)) r.rects);
         Option.Some
           ( "fragments",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.fragments );
       ])

type claims_item = {
  why : string;
  text : string;
  claim : string;
  spans : span list;
}

let claims_item_json (r : claims_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("text", (fun s -> `String s) r.text);
         Option.Some ("claim", (fun s -> `String s) r.claim);
         Option.Some ("spans", (fun l -> `List (List.map span_json l)) r.spans);
       ])

type landed = { page : int; x : float; y : float }

let landed_json (r : landed) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("page", (fun n -> `Int n) r.page);
         Option.Some ("x", (fun f -> `Float f) r.x);
         Option.Some ("y", (fun f -> `Float f) r.y);
       ])

type landing_item = {
  why : string;
  text : string;
  items : Yojson.Safe.t list;
  claim : string;
  landed : landed;
  span : span option;
}

let landing_item_json (r : landing_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("text", (fun s -> `String s) r.text);
         Option.Some ("items", (fun l -> `List (List.map Fun.id l)) r.items);
         Option.Some ("claim", (fun s -> `String s) r.claim);
         Option.Some ("landed", landed_json r.landed);
         Option.Some
           ( "span",
             (function Option.None -> `Null | Option.Some v -> span_json v)
               r.span );
       ])

type t = {
  comment : string;
  cases : cases_item list;
  claims : claims_item list;
  landing : landing_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("cases", (fun l -> `List (List.map cases_item_json l)) r.cases);
         Option.Some
           ("claims", (fun l -> `List (List.map claims_item_json l)) r.claims);
         Option.Some
           ("landing", (fun l -> `List (List.map landing_item_json l)) r.landing);
       ])

let table : t =
  ({
     comment =
       "Where a span of a PDF's text is on its pages, as every implementation \
        must answer it. An annotation of a PDF is anchored by rectangles on \
        its pages, not by offsets, so a worker that has found a span of the \
        PDF's text must locate it; and a worker that cites a claim in a PDF it \
        has made must first find the claim again in the text as it was \
        rendered. Every SDK runs `cases` and fails on a difference: against a \
        locating of its own where it exports one, and otherwise against the \
        locating its `annotationOfSpan` does for a span of a PDF. `claims` and \
        `landing` are the rule of Xynolog's worker alone: every implementation \
        of that worker runs every case of both, in whatever language it is \
        written. ANCHORED TEXT is a `text` and its `items`. An item says which \
        code points of the text it is (`start` up to but not including `end`, \
        offsets that count Unicode code points from the start of the text), \
        the `page` it is on (the first page is 1) and its box there: `x`, `y`, \
        `width`, `height` in PDF points, measured from the bottom-left corner \
        of the page, `y` growing upward. `cases` LOCATE a `span` of \
        `anchored`, whose `start` and `end` are offsets of the same kind. \
        `overlapping` is the items the span overlaps, in the order `items` has \
        them: an item overlaps when it starts before the span ends and ends \
        after the span starts. An empty span, whose `start` is its `end`, \
        overlaps no item, wherever it falls. `rects` is one rectangle for each \
        line of each page the span touches. Take the overlapping items a page \
        at a time, the pages in the order their first overlapping item comes \
        in `items`. On a page, put the items in order, the greater `y` first \
        (the top of the page) and among items of one `y` the lesser `x` first, \
        and walk them: an item whose `y` is within 2 points of the `y` of the \
        first item of the line being made joins that line (2 points exactly is \
        within), and any other item begins a new line. A line's rectangle \
        spans its items: its `x` is their least left edge, and its `width` \
        their greatest right edge less that; its `y` is their least `y`, and \
        its `height` their greatest `y` + `height` less that. An item's left \
        edge is its `x` and its right edge its `x` + `width`, except where the \
        span cuts the item: an item that starts before the span has its left \
        edge at `x` + `width` x ((span's start - item's start) / the item's \
        number of code points), and an item that ends after the span has its \
        right edge at `x` + `width` x ((span's end - item's start) / the \
        item's number of code points). A span that no item overlaps has no \
        rectangles. `fragments` is the FragmentSelector value made from each \
        rectangle, in the same order: `page=P&viewrect=X,Y,W,H` (RFC 3778), \
        each number written as the shortest decimal that reads back as that \
        number, a whole number with no point and no fraction part; a number so \
        large or so small that it would be written with an exponent does not \
        arise among a page's coordinates, and no case states one. `claims` \
        FIND a `claim` in a `text`; `spans` is every place the text has it, as \
        two offsets each, in the text's order, and is empty where it has none. \
        Collapse the claim: every run of white space becomes one space, and \
        there is none at either end; an empty claim is found nowhere. Strict: \
        collapse the text the same way and take every place it has the \
        collapsed claim, each after the last ends; each span runs from the \
        character of the text that the match's first character came from to \
        just after the one its last character came from. Break-aware: take \
        every place in the text, as it is, where the collapsed claim's \
        characters come in their order with nothing between one and the next, \
        except that a line break (U+000A) may come between any two, with at \
        most one space (U+0020) before it and at most one after it, each after \
        the last ends; the span runs from the first of those characters to \
        just after the last. Every character of the claim is taken for itself, \
        except that a space of the claim is taken for exactly one space or for \
        one line break: a line the text breaks between two words, with no \
        space beside the break, is found as one broken inside a word is. The \
        places are both searches' together, each once. `landing` says WHICH \
        place a citation is anchored to: a worker that made the PDF asks the \
        renderer where each cited span ended, and `landed` is that point, a \
        `page` and an `x` and `y` in PDF points measured as the items are, `y` \
        on the baseline of the line the span ends on. Of the places `claims` \
        finds in `text`, one qualifies where the item that holds its last \
        character is on that page, that item's `y` is within half its `height` \
        of the landed `y`, and the landed `x` is no more than half a point \
        before that item's `x` and no more than half a point after its `x` \
        plus its `width`. Of the places that qualify, the span is the one \
        whose end is nearest the landed `x`, an end being placed along its \
        item by the share of the item's characters that come before it. Where \
        none qualifies, the span is `null`: a citation is never anchored in \
        the wrong place. NUMBERS are IEEE 754 doubles. Every step of the \
        arithmetic on the coordinates here comes out exact, whatever order the \
        steps are taken in, so rectangles are compared for equality; a runner \
        must read the numbers without loss. White space is what Unicode gives \
        the White_Space property; no case rests on U+0085 or U+FEFF, about \
        which implementations disagree. What an offset counts is held by a \
        table of its own, specs/src/text/offset-cases.json; some texts here \
        have a character outside the Basic Multilingual Plane, which is one \
        code point and two UTF-16 code units, so that a count of code units \
        fails them. Add a case here before changing an implementation.";
     cases =
       [
         ({
            why =
              "a span that is exactly one item is that item's box; its \
               neighbours, one ending before the span starts and one starting \
               after it ends, are not overlapped";
            anchored =
              `Assoc
                [
                  ("text", `String "Hello world again");
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 5);
                            ("page", `Int 1);
                            ("x", `Int 72);
                            ("y", `Int 700);
                            ("width", `Int 30);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 6);
                            ("end", `Int 11);
                            ("page", `Int 1);
                            ("x", `Int 106);
                            ("y", `Int 700);
                            ("width", `Int 32);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 12);
                            ("end", `Int 17);
                            ("page", `Int 1);
                            ("x", `Int 142);
                            ("y", `Int 700);
                            ("width", `Int 30);
                            ("height", `Int 12);
                          ];
                      ] );
                ];
            span = ({ start = 6; end_ = 11 } : span);
            overlapping =
              [
                `Assoc
                  [
                    ("start", `Int 6);
                    ("end", `Int 11);
                    ("page", `Int 1);
                    ("x", `Int 106);
                    ("y", `Int 700);
                    ("width", `Int 32);
                    ("height", `Int 12);
                  ];
              ];
            rects =
              [
                ({ page = 1; x = 106.; y = 700.; width = 32.; height = 12. }
                  : pdf_coordinate);
              ];
            fragments = [ "page=1&viewrect=106,700,32,12" ];
          }
           : cases_item);
         ({
            why =
              "the items of one line make one rectangle, from the left edge of \
               the first to the right edge of the last (142 + 30), not a \
               rectangle each";
            anchored =
              `Assoc
                [
                  ("text", `String "Hello world again");
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 5);
                            ("page", `Int 1);
                            ("x", `Int 72);
                            ("y", `Int 700);
                            ("width", `Int 30);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 6);
                            ("end", `Int 11);
                            ("page", `Int 1);
                            ("x", `Int 106);
                            ("y", `Int 700);
                            ("width", `Int 32);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 12);
                            ("end", `Int 17);
                            ("page", `Int 1);
                            ("x", `Int 142);
                            ("y", `Int 700);
                            ("width", `Int 30);
                            ("height", `Int 12);
                          ];
                      ] );
                ];
            span = ({ start = 0; end_ = 17 } : span);
            overlapping =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 5);
                    ("page", `Int 1);
                    ("x", `Int 72);
                    ("y", `Int 700);
                    ("width", `Int 30);
                    ("height", `Int 12);
                  ];
                `Assoc
                  [
                    ("start", `Int 6);
                    ("end", `Int 11);
                    ("page", `Int 1);
                    ("x", `Int 106);
                    ("y", `Int 700);
                    ("width", `Int 32);
                    ("height", `Int 12);
                  ];
                `Assoc
                  [
                    ("start", `Int 12);
                    ("end", `Int 17);
                    ("page", `Int 1);
                    ("x", `Int 142);
                    ("y", `Int 700);
                    ("width", `Int 30);
                    ("height", `Int 12);
                  ];
              ];
            rects =
              [
                ({ page = 1; x = 72.; y = 700.; width = 100.; height = 12. }
                  : pdf_coordinate);
              ];
            fragments = [ "page=1&viewrect=72,700,100,12" ];
          }
           : cases_item);
         ({
            why =
              "a span that touches no item is located nowhere: the one \
               character between two items is in neither, since an item's \
               `end` is not one of its characters";
            anchored =
              `Assoc
                [
                  ("text", `String "Hello world again");
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 5);
                            ("page", `Int 1);
                            ("x", `Int 72);
                            ("y", `Int 700);
                            ("width", `Int 30);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 6);
                            ("end", `Int 11);
                            ("page", `Int 1);
                            ("x", `Int 106);
                            ("y", `Int 700);
                            ("width", `Int 32);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 12);
                            ("end", `Int 17);
                            ("page", `Int 1);
                            ("x", `Int 142);
                            ("y", `Int 700);
                            ("width", `Int 30);
                            ("height", `Int 12);
                          ];
                      ] );
                ];
            span = ({ start = 5; end_ = 6 } : span);
            overlapping = [];
            rects = [];
            fragments = [];
          }
           : cases_item);
         ({
            why =
              "an empty span is located nowhere, though it falls inside an \
               item: it has no character for the item to hold";
            anchored =
              `Assoc
                [
                  ("text", `String "Hello world again");
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 5);
                            ("page", `Int 1);
                            ("x", `Int 72);
                            ("y", `Int 700);
                            ("width", `Int 30);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 6);
                            ("end", `Int 11);
                            ("page", `Int 1);
                            ("x", `Int 106);
                            ("y", `Int 700);
                            ("width", `Int 32);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 12);
                            ("end", `Int 17);
                            ("page", `Int 1);
                            ("x", `Int 142);
                            ("y", `Int 700);
                            ("width", `Int 30);
                            ("height", `Int 12);
                          ];
                      ] );
                ];
            span = ({ start = 3; end_ = 3 } : span);
            overlapping = [];
            rects = [];
            fragments = [];
          }
           : cases_item);
         ({
            why =
              "nor is it located where one item has ended and the next not \
               begun";
            anchored =
              `Assoc
                [
                  ("text", `String "Hello world again");
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 5);
                            ("page", `Int 1);
                            ("x", `Int 72);
                            ("y", `Int 700);
                            ("width", `Int 30);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 6);
                            ("end", `Int 11);
                            ("page", `Int 1);
                            ("x", `Int 106);
                            ("y", `Int 700);
                            ("width", `Int 32);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 12);
                            ("end", `Int 17);
                            ("page", `Int 1);
                            ("x", `Int 142);
                            ("y", `Int 700);
                            ("width", `Int 30);
                            ("height", `Int 12);
                          ];
                      ] );
                ];
            span = ({ start = 5; end_ = 5 } : span);
            overlapping = [];
            rects = [];
            fragments = [];
          }
           : cases_item);
         ({
            why =
              "a span that runs over a line break and a page break has a \
               rectangle for each line, each on its own page: the first and \
               third lines have the same `y`, and being on different pages are \
               not one line";
            anchored =
              `Assoc
                [
                  ("text", `String "Hello world again\nSecond line\nElsewhere");
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 5);
                            ("page", `Int 1);
                            ("x", `Int 72);
                            ("y", `Int 700);
                            ("width", `Int 30);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 6);
                            ("end", `Int 11);
                            ("page", `Int 1);
                            ("x", `Int 106);
                            ("y", `Int 700);
                            ("width", `Int 32);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 12);
                            ("end", `Int 17);
                            ("page", `Int 1);
                            ("x", `Int 142);
                            ("y", `Int 700);
                            ("width", `Int 30);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 18);
                            ("end", `Int 24);
                            ("page", `Int 1);
                            ("x", `Int 72);
                            ("y", `Int 680);
                            ("width", `Int 38);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 25);
                            ("end", `Int 29);
                            ("page", `Int 1);
                            ("x", `Int 114);
                            ("y", `Int 680);
                            ("width", `Int 22);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 30);
                            ("end", `Int 39);
                            ("page", `Int 2);
                            ("x", `Int 72);
                            ("y", `Int 700);
                            ("width", `Int 50);
                            ("height", `Int 12);
                          ];
                      ] );
                ];
            span = ({ start = 12; end_ = 39 } : span);
            overlapping =
              [
                `Assoc
                  [
                    ("start", `Int 12);
                    ("end", `Int 17);
                    ("page", `Int 1);
                    ("x", `Int 142);
                    ("y", `Int 700);
                    ("width", `Int 30);
                    ("height", `Int 12);
                  ];
                `Assoc
                  [
                    ("start", `Int 18);
                    ("end", `Int 24);
                    ("page", `Int 1);
                    ("x", `Int 72);
                    ("y", `Int 680);
                    ("width", `Int 38);
                    ("height", `Int 12);
                  ];
                `Assoc
                  [
                    ("start", `Int 25);
                    ("end", `Int 29);
                    ("page", `Int 1);
                    ("x", `Int 114);
                    ("y", `Int 680);
                    ("width", `Int 22);
                    ("height", `Int 12);
                  ];
                `Assoc
                  [
                    ("start", `Int 30);
                    ("end", `Int 39);
                    ("page", `Int 2);
                    ("x", `Int 72);
                    ("y", `Int 700);
                    ("width", `Int 50);
                    ("height", `Int 12);
                  ];
              ];
            rects =
              [
                ({ page = 1; x = 142.; y = 700.; width = 30.; height = 12. }
                  : pdf_coordinate);
                ({ page = 1; x = 72.; y = 680.; width = 64.; height = 12. }
                  : pdf_coordinate);
                ({ page = 2; x = 72.; y = 700.; width = 50.; height = 12. }
                  : pdf_coordinate);
              ];
            fragments =
              [
                "page=1&viewrect=142,700,30,12";
                "page=1&viewrect=72,680,64,12";
                "page=2&viewrect=72,700,50,12";
              ];
          }
           : cases_item);
         ({
            why =
              "the lines of a page come top first whatever order the text has \
               them in: here the text reads a note at the foot of the page \
               before the title at its head, and `overlapping` keeps the \
               text's order while `rects` does not";
            anchored =
              `Assoc
                [
                  ("text", `String "note below\nTitle above");
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 4);
                            ("page", `Int 1);
                            ("x", `Int 72);
                            ("y", `Int 100);
                            ("width", `Int 24);
                            ("height", `Int 10);
                          ];
                        `Assoc
                          [
                            ("start", `Int 5);
                            ("end", `Int 10);
                            ("page", `Int 1);
                            ("x", `Int 100);
                            ("y", `Int 100);
                            ("width", `Int 30);
                            ("height", `Int 10);
                          ];
                        `Assoc
                          [
                            ("start", `Int 11);
                            ("end", `Int 16);
                            ("page", `Int 1);
                            ("x", `Int 72);
                            ("y", `Int 700);
                            ("width", `Int 40);
                            ("height", `Int 16);
                          ];
                        `Assoc
                          [
                            ("start", `Int 17);
                            ("end", `Int 22);
                            ("page", `Int 1);
                            ("x", `Int 118);
                            ("y", `Int 700);
                            ("width", `Int 44);
                            ("height", `Int 16);
                          ];
                      ] );
                ];
            span = ({ start = 0; end_ = 22 } : span);
            overlapping =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 4);
                    ("page", `Int 1);
                    ("x", `Int 72);
                    ("y", `Int 100);
                    ("width", `Int 24);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 5);
                    ("end", `Int 10);
                    ("page", `Int 1);
                    ("x", `Int 100);
                    ("y", `Int 100);
                    ("width", `Int 30);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 11);
                    ("end", `Int 16);
                    ("page", `Int 1);
                    ("x", `Int 72);
                    ("y", `Int 700);
                    ("width", `Int 40);
                    ("height", `Int 16);
                  ];
                `Assoc
                  [
                    ("start", `Int 17);
                    ("end", `Int 22);
                    ("page", `Int 1);
                    ("x", `Int 118);
                    ("y", `Int 700);
                    ("width", `Int 44);
                    ("height", `Int 16);
                  ];
              ];
            rects =
              [
                ({ page = 1; x = 72.; y = 700.; width = 90.; height = 16. }
                  : pdf_coordinate);
                ({ page = 1; x = 72.; y = 100.; width = 58.; height = 10. }
                  : pdf_coordinate);
              ];
            fragments =
              [ "page=1&viewrect=72,700,90,16"; "page=1&viewrect=72,100,58,10" ];
          }
           : cases_item);
         ({
            why =
              "two items whose baselines are exactly 2 points apart are one \
               line, and its rectangle bounds both: from the lower `y` (698) \
               up to the higher top (712)";
            anchored =
              `Assoc
                [
                  ("text", `String "ab");
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 1);
                            ("page", `Int 1);
                            ("x", `Int 72);
                            ("y", `Int 700);
                            ("width", `Int 10);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 1);
                            ("end", `Int 2);
                            ("page", `Int 1);
                            ("x", `Int 90);
                            ("y", `Int 698);
                            ("width", `Int 10);
                            ("height", `Int 12);
                          ];
                      ] );
                ];
            span = ({ start = 0; end_ = 2 } : span);
            overlapping =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 1);
                    ("page", `Int 1);
                    ("x", `Int 72);
                    ("y", `Int 700);
                    ("width", `Int 10);
                    ("height", `Int 12);
                  ];
                `Assoc
                  [
                    ("start", `Int 1);
                    ("end", `Int 2);
                    ("page", `Int 1);
                    ("x", `Int 90);
                    ("y", `Int 698);
                    ("width", `Int 10);
                    ("height", `Int 12);
                  ];
              ];
            rects =
              [
                ({ page = 1; x = 72.; y = 698.; width = 28.; height = 14. }
                  : pdf_coordinate);
              ];
            fragments = [ "page=1&viewrect=72,698,28,14" ];
          }
           : cases_item);
         ({
            why =
              "a line is measured from its first item, not from the item \
               before: the third item is 1.5 below the second but 3 below the \
               first, so it begins a new line; and a number that is not whole \
               is written with its fraction";
            anchored =
              `Assoc
                [
                  ("text", `String "abc");
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 1);
                            ("page", `Int 1);
                            ("x", `Int 72);
                            ("y", `Int 700);
                            ("width", `Int 10);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 1);
                            ("end", `Int 2);
                            ("page", `Int 1);
                            ("x", `Int 90);
                            ("y", `Float 698.5);
                            ("width", `Int 10);
                            ("height", `Int 12);
                          ];
                        `Assoc
                          [
                            ("start", `Int 2);
                            ("end", `Int 3);
                            ("page", `Int 1);
                            ("x", `Int 108);
                            ("y", `Int 697);
                            ("width", `Int 10);
                            ("height", `Int 12);
                          ];
                      ] );
                ];
            span = ({ start = 0; end_ = 3 } : span);
            overlapping =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 1);
                    ("page", `Int 1);
                    ("x", `Int 72);
                    ("y", `Int 700);
                    ("width", `Int 10);
                    ("height", `Int 12);
                  ];
                `Assoc
                  [
                    ("start", `Int 1);
                    ("end", `Int 2);
                    ("page", `Int 1);
                    ("x", `Int 90);
                    ("y", `Float 698.5);
                    ("width", `Int 10);
                    ("height", `Int 12);
                  ];
                `Assoc
                  [
                    ("start", `Int 2);
                    ("end", `Int 3);
                    ("page", `Int 1);
                    ("x", `Int 108);
                    ("y", `Int 697);
                    ("width", `Int 10);
                    ("height", `Int 12);
                  ];
              ];
            rects =
              [
                ({ page = 1; x = 72.; y = 698.5; width = 28.; height = 13.5 }
                  : pdf_coordinate);
                ({ page = 1; x = 108.; y = 697.; width = 10.; height = 12. }
                  : pdf_coordinate);
              ];
            fragments =
              [
                "page=1&viewrect=72,698.5,28,13.5";
                "page=1&viewrect=108,697,10,12";
              ];
          }
           : cases_item);
         ({
            why =
              "a span inside one item, as when a renderer gives a whole line \
               as one item, is cut from it in proportion: characters 2 to 6 of \
               8 are from a quarter to three quarters of its width";
            anchored =
              `Assoc
                [
                  ("text", `String "abcdefgh");
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 8);
                            ("page", `Int 1);
                            ("x", `Int 100);
                            ("y", `Int 700);
                            ("width", `Int 80);
                            ("height", `Int 10);
                          ];
                      ] );
                ];
            span = ({ start = 2; end_ = 6 } : span);
            overlapping =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 8);
                    ("page", `Int 1);
                    ("x", `Int 100);
                    ("y", `Int 700);
                    ("width", `Int 80);
                    ("height", `Int 10);
                  ];
              ];
            rects =
              [
                ({ page = 1; x = 120.; y = 700.; width = 40.; height = 10. }
                  : pdf_coordinate);
              ];
            fragments = [ "page=1&viewrect=120,700,40,10" ];
          }
           : cases_item);
         ({
            why =
              "only the items at the span's two ends are cut: the first loses \
               its first six characters of eight (its left edge moves to 160), \
               the last keeps its first two (its right edge is 288), and the \
               item between them is whole";
            anchored =
              `Assoc
                [
                  ("text", `String "abcdefgh ijklmnop qrstuvwx");
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 8);
                            ("page", `Int 1);
                            ("x", `Int 100);
                            ("y", `Int 700);
                            ("width", `Int 80);
                            ("height", `Int 10);
                          ];
                        `Assoc
                          [
                            ("start", `Int 9);
                            ("end", `Int 17);
                            ("page", `Int 1);
                            ("x", `Int 184);
                            ("y", `Int 700);
                            ("width", `Int 80);
                            ("height", `Int 10);
                          ];
                        `Assoc
                          [
                            ("start", `Int 18);
                            ("end", `Int 26);
                            ("page", `Int 1);
                            ("x", `Int 268);
                            ("y", `Int 700);
                            ("width", `Int 80);
                            ("height", `Int 10);
                          ];
                      ] );
                ];
            span = ({ start = 6; end_ = 20 } : span);
            overlapping =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 8);
                    ("page", `Int 1);
                    ("x", `Int 100);
                    ("y", `Int 700);
                    ("width", `Int 80);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 9);
                    ("end", `Int 17);
                    ("page", `Int 1);
                    ("x", `Int 184);
                    ("y", `Int 700);
                    ("width", `Int 80);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 18);
                    ("end", `Int 26);
                    ("page", `Int 1);
                    ("x", `Int 268);
                    ("y", `Int 700);
                    ("width", `Int 80);
                    ("height", `Int 10);
                  ];
              ];
            rects =
              [
                ({ page = 1; x = 160.; y = 700.; width = 128.; height = 10. }
                  : pdf_coordinate);
              ];
            fragments = [ "page=1&viewrect=160,700,128,10" ];
          }
           : cases_item);
         ({
            why =
              "a span that starts inside one line and ends inside the next \
               cuts the first on its left only and the second on its right \
               only";
            anchored =
              `Assoc
                [
                  ("text", `String "abcdefgh\nijklmnop");
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 8);
                            ("page", `Int 1);
                            ("x", `Int 100);
                            ("y", `Int 700);
                            ("width", `Int 80);
                            ("height", `Int 10);
                          ];
                        `Assoc
                          [
                            ("start", `Int 9);
                            ("end", `Int 17);
                            ("page", `Int 1);
                            ("x", `Int 100);
                            ("y", `Int 686);
                            ("width", `Int 80);
                            ("height", `Int 10);
                          ];
                      ] );
                ];
            span = ({ start = 4; end_ = 11 } : span);
            overlapping =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 8);
                    ("page", `Int 1);
                    ("x", `Int 100);
                    ("y", `Int 700);
                    ("width", `Int 80);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 9);
                    ("end", `Int 17);
                    ("page", `Int 1);
                    ("x", `Int 100);
                    ("y", `Int 686);
                    ("width", `Int 80);
                    ("height", `Int 10);
                  ];
              ];
            rects =
              [
                ({ page = 1; x = 140.; y = 700.; width = 40.; height = 10. }
                  : pdf_coordinate);
                ({ page = 1; x = 100.; y = 686.; width = 20.; height = 10. }
                  : pdf_coordinate);
              ];
            fragments =
              [
                "page=1&viewrect=140,700,40,10"; "page=1&viewrect=100,686,20,10";
              ];
          }
           : cases_item);
         ({
            why =
              "an item that hangs off the page has coordinates below zero, and \
               they are written with their sign";
            anchored =
              `Assoc
                [
                  ("text", `String "margin note");
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 6);
                            ("page", `Int 3);
                            ("x", `Int (-5));
                            ("y", `Int (-12));
                            ("width", `Int 24);
                            ("height", `Int 18);
                          ];
                        `Assoc
                          [
                            ("start", `Int 7);
                            ("end", `Int 11);
                            ("page", `Int 3);
                            ("x", `Int 23);
                            ("y", `Int (-12));
                            ("width", `Int 16);
                            ("height", `Int 18);
                          ];
                      ] );
                ];
            span = ({ start = 0; end_ = 11 } : span);
            overlapping =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 6);
                    ("page", `Int 3);
                    ("x", `Int (-5));
                    ("y", `Int (-12));
                    ("width", `Int 24);
                    ("height", `Int 18);
                  ];
                `Assoc
                  [
                    ("start", `Int 7);
                    ("end", `Int 11);
                    ("page", `Int 3);
                    ("x", `Int 23);
                    ("y", `Int (-12));
                    ("width", `Int 16);
                    ("height", `Int 18);
                  ];
              ];
            rects =
              [
                ({ page = 3; x = -5.; y = -12.; width = 44.; height = 18. }
                  : pdf_coordinate);
              ];
            fragments = [ "page=3&viewrect=-5,-12,44,18" ];
          }
           : cases_item);
         ({
            why =
              "a coordinate is written as the shortest decimal that reads back \
               as it: 72.3 and 700.44, not their seventeen digits; and the \
               width and height, which come out whole, are written as 30 and \
               12";
            anchored =
              `Assoc
                [
                  ("text", `String "decimal");
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 7);
                            ("page", `Int 1);
                            ("x", `Float 72.3);
                            ("y", `Float 700.44);
                            ("width", `Int 30);
                            ("height", `Int 12);
                          ];
                      ] );
                ];
            span = ({ start = 0; end_ = 7 } : span);
            overlapping =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 7);
                    ("page", `Int 1);
                    ("x", `Float 72.3);
                    ("y", `Float 700.44);
                    ("width", `Int 30);
                    ("height", `Int 12);
                  ];
              ];
            rects =
              [
                ({ page = 1; x = 72.3; y = 700.44; width = 30.; height = 12. }
                  : pdf_coordinate);
              ];
            fragments = [ "page=1&viewrect=72.3,700.44,30,12" ];
          }
           : cases_item);
         ({
            why =
              "an item's offsets and its number of code points are counted in \
               code points: the first item is four mathematical letters, each \
               outside the Basic Multilingual Plane, and a span that starts \
               after two of them cuts it at half its width, not at a quarter \
               as its eight UTF-16 code units would";
            anchored =
              `Assoc
                [
                  ( "text",
                    `String
                      "\240\157\145\142\240\157\145\143\240\157\145\144\240\157\145\145 \
                       efgh" );
                  ( "items",
                    `List
                      [
                        `Assoc
                          [
                            ("start", `Int 0);
                            ("end", `Int 4);
                            ("page", `Int 1);
                            ("x", `Int 100);
                            ("y", `Int 700);
                            ("width", `Int 80);
                            ("height", `Int 10);
                          ];
                        `Assoc
                          [
                            ("start", `Int 5);
                            ("end", `Int 9);
                            ("page", `Int 1);
                            ("x", `Int 184);
                            ("y", `Int 700);
                            ("width", `Int 80);
                            ("height", `Int 10);
                          ];
                      ] );
                ];
            span = ({ start = 2; end_ = 7 } : span);
            overlapping =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 4);
                    ("page", `Int 1);
                    ("x", `Int 100);
                    ("y", `Int 700);
                    ("width", `Int 80);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 5);
                    ("end", `Int 9);
                    ("page", `Int 1);
                    ("x", `Int 184);
                    ("y", `Int 700);
                    ("width", `Int 80);
                    ("height", `Int 10);
                  ];
              ];
            rects =
              [
                ({ page = 1; x = 140.; y = 700.; width = 84.; height = 10. }
                  : pdf_coordinate);
              ];
            fragments = [ "page=1&viewrect=140,700,84,10" ];
          }
           : cases_item);
       ];
     claims =
       [
         ({
            why = "a claim that is on one line is found where it is";
            text = "The quick brown fox jumps over the lazy dog.";
            claim = "brown fox jumps";
            spans = [ ({ start = 10; end_ = 25 } : span) ];
          }
           : claims_item);
         ({
            why =
              "the rendered text breaks the line inside the claim, with a \
               space before the break: the strict search finds it, and the \
               span takes in the break as the text has it (`brown \\nfox`)";
            text = "The quick brown \nfox jumps high.";
            claim = "brown fox";
            spans = [ ({ start = 10; end_ = 20 } : span) ];
          }
           : claims_item);
         ({
            why =
              "the claim's own white space is collapsed and trimmed before it \
               is looked for";
            text = "The quick brown \nfox jumps high.";
            claim = "  brown\n\tfox ";
            spans = [ ({ start = 10; end_ = 20 } : span) ];
          }
           : claims_item);
         ({
            why =
              "the offsets are the text's own: the white space the text begins \
               with and the runs of it before and inside the claim are all \
               counted";
            text = " \n  Title:  the  quick\tbrown fox.";
            claim = "the quick brown";
            spans = [ ({ start = 12; end_ = 28 } : span) ];
          }
           : claims_item);
         ({
            why =
              "every place, in the text's order, and case matters: the capital \
               `A fox` that begins the text is not one of them";
            text = "A fox and a fox and a fox.";
            claim = "a fox";
            spans =
              [
                ({ start = 10; end_ = 15 } : span);
                ({ start = 20; end_ = 25 } : span);
              ];
          }
           : claims_item);
         ({
            why =
              "a word hyphenated at a line end is rendered as its two halves \
               with no hyphen: the strict search misses, and the break-aware \
               one finds the claim around the break";
            text = "It is extraor \ndinarily complicated today.";
            claim = "extraordinarily complicated";
            spans = [ ({ start = 6; end_ = 35 } : span) ];
          }
           : claims_item);
         ({
            why = "the break may have its one space after it instead of before";
            text = "An under\n standing was reached.";
            claim = "understanding";
            spans = [ ({ start = 3; end_ = 18 } : span) ];
          }
           : claims_item);
         ({
            why =
              "a claim hyphenated in one place and wrapped between words in \
               another: the claim's space is the text's space, and the break \
               comes after it";
            text = "It is extraor \ndinarily complicated \ntoday.";
            claim = "extraordinarily complicated today";
            spans = [ ({ start = 6; end_ = 42 } : span) ];
          }
           : claims_item);
         ({
            why =
              "the line may break between two words with no space beside the \
               break: the claim's space is then the break itself, and a claim \
               hyphenated elsewhere is found across it";
            text = "It is extraor \ndinarily complicated\ntoday.";
            claim = "extraordinarily complicated today";
            spans = [ ({ start = 6; end_ = 41 } : span) ];
          }
           : claims_item);
         ({
            why =
              "only a line break is taken for a space of the claim, and no \
               other white space: a tab between the two words is not";
            text = "It is extraor \ndinarily complicated\ttoday.";
            claim = "extraordinarily complicated today";
            spans = [];
          }
           : claims_item);
         ({
            why =
              "a place either search finds is a place of the claim: the word \
               broken at a line's end and the unbroken one later in the text \
               are both places, in the text's order";
            text = "The under \nstanding was that an understanding existed.";
            claim = "understanding";
            spans =
              [
                ({ start = 4; end_ = 19 } : span);
                ({ start = 32; end_ = 45 } : span);
              ];
          }
           : claims_item);
         ({
            why =
              "the claim's characters are taken for themselves in the \
               break-aware search: brackets, a full stop, a dollar sign and a \
               plus are not a pattern";
            text = "Total cost (est.) is $5.00+ per quar \nter [net].";
            claim = "cost (est.) is $5.00+ per quarter [net]";
            spans = [ ({ start = 6; end_ = 47 } : span) ];
          }
           : claims_item);
         ({
            why =
              "only a line break may come between two characters of the claim, \
               never a space on its own: `abc` is not `a b c`";
            text = "x a b c y";
            claim = "abc";
            spans = [];
          }
           : claims_item);
         ({
            why = "a claim the text does not have is not found";
            text = "Entirely unrelated text.";
            claim = "quantum entanglement";
            spans = [];
          }
           : claims_item);
         ({
            why = "an empty claim is not found";
            text = "Some text.";
            claim = "";
            spans = [];
          }
           : claims_item);
         ({
            why =
              "nor is one that is only white space, which collapses to an \
               empty one";
            text = "Some text.";
            claim = " \n\t ";
            spans = [];
          }
           : claims_item);
         ({
            why =
              "a character outside the Basic Multilingual Plane is one code \
               point: the claim after it starts at 12, where a count of UTF-16 \
               code units says 13";
            text =
              "\240\159\142\137 The quick brown fox jumps over the lazy dog.";
            claim = "brown fox jumps";
            spans = [ ({ start = 12; end_ = 27 } : span) ];
          }
           : claims_item);
         ({
            why =
              "a claim that ends with such a character ends just after it, \
               five code points on from its start";
            text = "We see \240\159\142\137 now.";
            claim = "see \240\159\142\137";
            spans = [ ({ start = 3; end_ = 8 } : span) ];
          }
           : claims_item);
         ({
            why =
              "the strict search over a line break, after such a character: \
               the span is counted in the text as it is, its code points and \
               its white space alike";
            text =
              "Result \240\157\145\165 holds: the quick brown \nfox jumps high.";
            claim = "brown fox";
            spans = [ ({ start = 26; end_ = 36 } : span) ];
          }
           : claims_item);
         ({
            why =
              "the break-aware search, with one such character before the \
               claim and one inside it: the span is in code points here too";
            text =
              "\240\159\147\132 It is extraor \n\
               dinarily \240\157\145\165-complicated today.";
            claim = "extraordinarily \240\157\145\165-complicated";
            spans = [ ({ start = 8; end_ = 39 } : span) ];
          }
           : claims_item);
         ({
            why =
              "a line broken between two words, after a character outside the \
               Basic Multilingual Plane and in a claim that ends with one: the \
               span is in code points";
            text =
              "\240\159\147\132 An under \n\
               standing was\n\
               reached \240\159\142\137 today.";
            claim = "understanding was reached \240\159\142\137";
            spans = [ ({ start = 5; end_ = 34 } : span) ];
          }
           : claims_item);
       ];
     landing =
       [
         ({
            why =
              "the citation landed at the end of the second of two places on \
               one line: the second is the span";
            text = "A fox ran. A fox sat.\n";
            items =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 1);
                    ("page", `Int 1);
                    ("x", `Int 10);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 2);
                    ("end", `Int 5);
                    ("page", `Int 1);
                    ("x", `Int 19);
                    ("y", `Int 100);
                    ("width", `Int 14);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 6);
                    ("end", `Int 10);
                    ("page", `Int 1);
                    ("x", `Int 36);
                    ("y", `Int 100);
                    ("width", `Int 18);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 11);
                    ("end", `Int 12);
                    ("page", `Int 1);
                    ("x", `Int 57);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 13);
                    ("end", `Int 16);
                    ("page", `Int 1);
                    ("x", `Int 66);
                    ("y", `Int 100);
                    ("width", `Int 14);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 17);
                    ("end", `Int 21);
                    ("page", `Int 1);
                    ("x", `Int 83);
                    ("y", `Int 100);
                    ("width", `Int 16);
                    ("height", `Int 10);
                  ];
              ];
            claim = "A fox";
            landed = ({ page = 1; x = 80.; y = 100. } : landed);
            span = Some ({ start = 11; end_ = 16 } : span);
          }
           : landing_item);
         ({
            why = "and where it landed at the end of the first, the first is";
            text = "A fox ran. A fox sat.\n";
            items =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 1);
                    ("page", `Int 1);
                    ("x", `Int 10);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 2);
                    ("end", `Int 5);
                    ("page", `Int 1);
                    ("x", `Int 19);
                    ("y", `Int 100);
                    ("width", `Int 14);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 6);
                    ("end", `Int 10);
                    ("page", `Int 1);
                    ("x", `Int 36);
                    ("y", `Int 100);
                    ("width", `Int 18);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 11);
                    ("end", `Int 12);
                    ("page", `Int 1);
                    ("x", `Int 57);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 13);
                    ("end", `Int 16);
                    ("page", `Int 1);
                    ("x", `Int 66);
                    ("y", `Int 100);
                    ("width", `Int 14);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 17);
                    ("end", `Int 21);
                    ("page", `Int 1);
                    ("x", `Int 83);
                    ("y", `Int 100);
                    ("width", `Int 16);
                    ("height", `Int 10);
                  ];
              ];
            claim = "A fox";
            landed = ({ page = 1; x = 33.; y = 100. } : landed);
            span = Some ({ start = 0; end_ = 5 } : span);
          }
           : landing_item);
         ({
            why = "the same text on two pages: the page it landed on decides";
            text = "Radiant Matter\nRadiant Matter\n";
            items =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 7);
                    ("page", `Int 1);
                    ("x", `Int 40);
                    ("y", `Int 700);
                    ("width", `Int 36);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 8);
                    ("end", `Int 14);
                    ("page", `Int 1);
                    ("x", `Int 79);
                    ("y", `Int 700);
                    ("width", `Int 32);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 15);
                    ("end", `Int 22);
                    ("page", `Int 2);
                    ("x", `Int 40);
                    ("y", `Int 700);
                    ("width", `Int 36);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 23);
                    ("end", `Int 29);
                    ("page", `Int 2);
                    ("x", `Int 79);
                    ("y", `Int 700);
                    ("width", `Int 32);
                    ("height", `Int 10);
                  ];
              ];
            claim = "Radiant Matter";
            landed = ({ page = 2; x = 111.; y = 700. } : landed);
            span = Some ({ start = 15; end_ = 29 } : span);
          }
           : landing_item);
         ({
            why =
              "a claim broken at a line's end is found where it landed, though \
               the unbroken word later on the line is a place of it too";
            text = "The under \nstanding was an understanding.\n";
            items =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 3);
                    ("page", `Int 1);
                    ("x", `Int 10);
                    ("y", `Int 100);
                    ("width", `Int 20);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 4);
                    ("end", `Int 9);
                    ("page", `Int 1);
                    ("x", `Int 34);
                    ("y", `Int 100);
                    ("width", `Int 30);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 11);
                    ("end", `Int 19);
                    ("page", `Int 1);
                    ("x", `Int 10);
                    ("y", `Int 86);
                    ("width", `Int 40);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 20);
                    ("end", `Int 23);
                    ("page", `Int 1);
                    ("x", `Int 54);
                    ("y", `Int 86);
                    ("width", `Int 18);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 24);
                    ("end", `Int 26);
                    ("page", `Int 1);
                    ("x", `Int 76);
                    ("y", `Int 86);
                    ("width", `Int 12);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 27);
                    ("end", `Int 41);
                    ("page", `Int 1);
                    ("x", `Int 92);
                    ("y", `Int 86);
                    ("width", `Int 70);
                    ("height", `Int 10);
                  ];
              ];
            claim = "understanding";
            landed = ({ page = 1; x = 50.; y = 86. } : landed);
            span = Some ({ start = 4; end_ = 19 } : span);
          }
           : landing_item);
         ({
            why =
              "and the unbroken one is found where it landed, inside its word: \
               the full stop after the claim is the word's, not the claim's";
            text = "The under \nstanding was an understanding.\n";
            items =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 3);
                    ("page", `Int 1);
                    ("x", `Int 10);
                    ("y", `Int 100);
                    ("width", `Int 20);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 4);
                    ("end", `Int 9);
                    ("page", `Int 1);
                    ("x", `Int 34);
                    ("y", `Int 100);
                    ("width", `Int 30);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 11);
                    ("end", `Int 19);
                    ("page", `Int 1);
                    ("x", `Int 10);
                    ("y", `Int 86);
                    ("width", `Int 40);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 20);
                    ("end", `Int 23);
                    ("page", `Int 1);
                    ("x", `Int 54);
                    ("y", `Int 86);
                    ("width", `Int 18);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 24);
                    ("end", `Int 26);
                    ("page", `Int 1);
                    ("x", `Int 76);
                    ("y", `Int 86);
                    ("width", `Int 12);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 27);
                    ("end", `Int 41);
                    ("page", `Int 1);
                    ("x", `Int 92);
                    ("y", `Int 86);
                    ("width", `Int 70);
                    ("height", `Int 10);
                  ];
              ];
            claim = "understanding";
            landed = ({ page = 1; x = 158.; y = 86. } : landed);
            span = Some ({ start = 27; end_ = 40 } : span);
          }
           : landing_item);
         ({
            why =
              "a claim that ends before a comma in its word: the citation \
               landed inside the word, before the comma";
            text = "described in On Radiant Matter, and more.\n";
            items =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 9);
                    ("page", `Int 1);
                    ("x", `Int 10);
                    ("y", `Int 100);
                    ("width", `Int 44);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 10);
                    ("end", `Int 12);
                    ("page", `Int 1);
                    ("x", `Int 57);
                    ("y", `Int 100);
                    ("width", `Int 10);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 13);
                    ("end", `Int 15);
                    ("page", `Int 1);
                    ("x", `Int 70);
                    ("y", `Int 100);
                    ("width", `Int 13);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 16);
                    ("end", `Int 23);
                    ("page", `Int 1);
                    ("x", `Int 86);
                    ("y", `Int 100);
                    ("width", `Int 36);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 24);
                    ("end", `Int 31);
                    ("page", `Int 1);
                    ("x", `Int 125);
                    ("y", `Int 100);
                    ("width", `Int 35);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 32);
                    ("end", `Int 35);
                    ("page", `Int 1);
                    ("x", `Int 163);
                    ("y", `Int 100);
                    ("width", `Int 17);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 36);
                    ("end", `Int 41);
                    ("page", `Int 1);
                    ("x", `Int 183);
                    ("y", `Int 100);
                    ("width", `Int 26);
                    ("height", `Int 10);
                  ];
              ];
            claim = "On Radiant Matter";
            landed = ({ page = 1; x = 157.5; y = 100. } : landed);
            span = Some ({ start = 13; end_ = 30 } : span);
          }
           : landing_item);
         ({
            why =
              "a landing a quarter of a point past the end of the word is at \
               the word: half a point is allowed either side";
            text = "A fox ran. A fox sat.\n";
            items =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 1);
                    ("page", `Int 1);
                    ("x", `Int 10);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 2);
                    ("end", `Int 5);
                    ("page", `Int 1);
                    ("x", `Int 19);
                    ("y", `Int 100);
                    ("width", `Int 14);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 6);
                    ("end", `Int 10);
                    ("page", `Int 1);
                    ("x", `Int 36);
                    ("y", `Int 100);
                    ("width", `Int 18);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 11);
                    ("end", `Int 12);
                    ("page", `Int 1);
                    ("x", `Int 57);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 13);
                    ("end", `Int 16);
                    ("page", `Int 1);
                    ("x", `Int 66);
                    ("y", `Int 100);
                    ("width", `Int 14);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 17);
                    ("end", `Int 21);
                    ("page", `Int 1);
                    ("x", `Int 83);
                    ("y", `Int 100);
                    ("width", `Int 16);
                    ("height", `Int 10);
                  ];
              ];
            claim = "A fox";
            landed = ({ page = 1; x = 80.25; y = 100. } : landed);
            span = Some ({ start = 11; end_ = 16 } : span);
          }
           : landing_item);
         ({
            why =
              "a landing two points past the end of every place's word is at \
               none of them: a citation is never anchored in the wrong place";
            text = "A fox ran. A fox sat.\n";
            items =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 1);
                    ("page", `Int 1);
                    ("x", `Int 10);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 2);
                    ("end", `Int 5);
                    ("page", `Int 1);
                    ("x", `Int 19);
                    ("y", `Int 100);
                    ("width", `Int 14);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 6);
                    ("end", `Int 10);
                    ("page", `Int 1);
                    ("x", `Int 36);
                    ("y", `Int 100);
                    ("width", `Int 18);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 11);
                    ("end", `Int 12);
                    ("page", `Int 1);
                    ("x", `Int 57);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 13);
                    ("end", `Int 16);
                    ("page", `Int 1);
                    ("x", `Int 66);
                    ("y", `Int 100);
                    ("width", `Int 14);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 17);
                    ("end", `Int 21);
                    ("page", `Int 1);
                    ("x", `Int 83);
                    ("y", `Int 100);
                    ("width", `Int 16);
                    ("height", `Int 10);
                  ];
              ];
            claim = "A fox";
            landed = ({ page = 1; x = 82.; y = 100. } : landed);
            span = None;
          }
           : landing_item);
         ({
            why =
              "a landing on the line of a place but at another word is at no \
               place";
            text = "A fox ran. A fox sat.\n";
            items =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 1);
                    ("page", `Int 1);
                    ("x", `Int 10);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 2);
                    ("end", `Int 5);
                    ("page", `Int 1);
                    ("x", `Int 19);
                    ("y", `Int 100);
                    ("width", `Int 14);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 6);
                    ("end", `Int 10);
                    ("page", `Int 1);
                    ("x", `Int 36);
                    ("y", `Int 100);
                    ("width", `Int 18);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 11);
                    ("end", `Int 12);
                    ("page", `Int 1);
                    ("x", `Int 57);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 13);
                    ("end", `Int 16);
                    ("page", `Int 1);
                    ("x", `Int 66);
                    ("y", `Int 100);
                    ("width", `Int 14);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 17);
                    ("end", `Int 21);
                    ("page", `Int 1);
                    ("x", `Int 83);
                    ("y", `Int 100);
                    ("width", `Int 16);
                    ("height", `Int 10);
                  ];
              ];
            claim = "A fox";
            landed = ({ page = 1; x = 45.; y = 100. } : landed);
            span = None;
          }
           : landing_item);
         ({
            why =
              "a landing on the line above, more than half the word's height \
               from its baseline, is at no place";
            text = "A fox ran. A fox sat.\n";
            items =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 1);
                    ("page", `Int 1);
                    ("x", `Int 10);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 2);
                    ("end", `Int 5);
                    ("page", `Int 1);
                    ("x", `Int 19);
                    ("y", `Int 100);
                    ("width", `Int 14);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 6);
                    ("end", `Int 10);
                    ("page", `Int 1);
                    ("x", `Int 36);
                    ("y", `Int 100);
                    ("width", `Int 18);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 11);
                    ("end", `Int 12);
                    ("page", `Int 1);
                    ("x", `Int 57);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 13);
                    ("end", `Int 16);
                    ("page", `Int 1);
                    ("x", `Int 66);
                    ("y", `Int 100);
                    ("width", `Int 14);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 17);
                    ("end", `Int 21);
                    ("page", `Int 1);
                    ("x", `Int 83);
                    ("y", `Int 100);
                    ("width", `Int 16);
                    ("height", `Int 10);
                  ];
              ];
            claim = "A fox";
            landed = ({ page = 1; x = 80.; y = 114. } : landed);
            span = None;
          }
           : landing_item);
         ({
            why =
              "a landing on a page where the text has no place of the claim is \
               at none";
            text = "Radiant Matter\nRadiant Matter\n";
            items =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 7);
                    ("page", `Int 1);
                    ("x", `Int 40);
                    ("y", `Int 700);
                    ("width", `Int 36);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 8);
                    ("end", `Int 14);
                    ("page", `Int 1);
                    ("x", `Int 79);
                    ("y", `Int 700);
                    ("width", `Int 32);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 15);
                    ("end", `Int 22);
                    ("page", `Int 2);
                    ("x", `Int 40);
                    ("y", `Int 700);
                    ("width", `Int 36);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 23);
                    ("end", `Int 29);
                    ("page", `Int 2);
                    ("x", `Int 79);
                    ("y", `Int 700);
                    ("width", `Int 32);
                    ("height", `Int 10);
                  ];
              ];
            claim = "Radiant Matter";
            landed = ({ page = 3; x = 111.; y = 700. } : landed);
            span = None;
          }
           : landing_item);
         ({
            why =
              "a claim the text does not have is found nowhere, wherever it \
               landed";
            text = "A fox ran. A fox sat.\n";
            items =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 1);
                    ("page", `Int 1);
                    ("x", `Int 10);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 2);
                    ("end", `Int 5);
                    ("page", `Int 1);
                    ("x", `Int 19);
                    ("y", `Int 100);
                    ("width", `Int 14);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 6);
                    ("end", `Int 10);
                    ("page", `Int 1);
                    ("x", `Int 36);
                    ("y", `Int 100);
                    ("width", `Int 18);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 11);
                    ("end", `Int 12);
                    ("page", `Int 1);
                    ("x", `Int 57);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 13);
                    ("end", `Int 16);
                    ("page", `Int 1);
                    ("x", `Int 66);
                    ("y", `Int 100);
                    ("width", `Int 14);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 17);
                    ("end", `Int 21);
                    ("page", `Int 1);
                    ("x", `Int 83);
                    ("y", `Int 100);
                    ("width", `Int 16);
                    ("height", `Int 10);
                  ];
              ];
            claim = "A cat";
            landed = ({ page = 1; x = 80.; y = 100. } : landed);
            span = None;
          }
           : landing_item);
         ({
            why =
              "a character outside the Basic Multilingual Plane is one code \
               point: the second place starts at 9, where a count of UTF-16 \
               code units says 10";
            text = "\240\159\142\137 A fox. A fox.\n";
            items =
              [
                `Assoc
                  [
                    ("start", `Int 0);
                    ("end", `Int 1);
                    ("page", `Int 1);
                    ("x", `Int 10);
                    ("y", `Int 100);
                    ("width", `Int 10);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 2);
                    ("end", `Int 3);
                    ("page", `Int 1);
                    ("x", `Int 23);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 4);
                    ("end", `Int 8);
                    ("page", `Int 1);
                    ("x", `Int 32);
                    ("y", `Int 100);
                    ("width", `Int 18);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 9);
                    ("end", `Int 10);
                    ("page", `Int 1);
                    ("x", `Int 53);
                    ("y", `Int 100);
                    ("width", `Int 6);
                    ("height", `Int 10);
                  ];
                `Assoc
                  [
                    ("start", `Int 11);
                    ("end", `Int 15);
                    ("page", `Int 1);
                    ("x", `Int 62);
                    ("y", `Int 100);
                    ("width", `Int 18);
                    ("height", `Int 10);
                  ];
              ];
            claim = "A fox";
            landed = ({ page = 1; x = 79.; y = 100. } : landed);
            span = Some ({ start = 9; end_ = 14 } : span);
          }
           : landing_item);
       ];
   }
    : t)
