(* Generated from protocol/specs/src/annotations/reconcile-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type cases_item = {
  why : string;
  text : string;
  quoted : Yojson.Safe.t;
  reconciled : Yojson.Safe.t option;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("text", (fun s -> `String s) r.text);
         Option.Some ("quoted", Fun.id r.quoted);
         Option.Some
           ( "reconciled",
             (function Option.None -> `Null | Option.Some v -> Fun.id v)
               r.reconciled );
       ])

type t = { comment : string; cases : cases_item list }

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("cases", (fun l -> `List (List.map cases_item_json l)) r.cases);
       ])

let table : t =
  ({
     comment =
       "Where a quoted span is in a text, as every implementation must answer \
        it. A model asked to mark a text quotes it: the words (`exact`), and \
        maybe some of what comes before and after them (`prefix`, `suffix`). \
        None of that is trusted. It is reconciled against the text into a \
        position and a quote that are the text's own, or it is refused, and \
        only what is reconciled is built into an annotation. It is what \
        `reconcile` does, one of the three annotation builders \
        (builder-cases.json): Every SDK runs every case and fails on a \
        difference. READING A CASE. `text` is the real text, `quoted` what the \
        model said, and `reconciled` the answer: `null` when the span is \
        refused, otherwise `start` and `end` (offsets, which count Unicode \
        code points from the start of the text: the span is the code points \
        from `start` up to but not including `end`), `exact` (the text between \
        them, never the model's spelling of it), `prefix` and `suffix` (taken \
        from the text as CONTEXT says, each left out when there is nothing to \
        take), `anchorMethod` (how the place was found) and, only when that is \
        `fuzzy-match`, `matchQuality` (which of the three looser searches \
        found it). THE RULE. An `exact` that is empty, or only white space, is \
        refused. A prefix or a suffix the model gave is a hint; one that is \
        empty, or only white space, is none. A place is a span of the text. It \
        fits the prefix when the text just before it ends with the prefix, or \
        when the prefix, with the white space at its two ends removed, is \
        anywhere in the code points before the place: as many of them as the \
        prefix has, and at least 32. It fits the suffix when the text just \
        after it starts with the suffix, or when the suffix, trimmed the same \
        way, is anywhere in the code points after the place: as many as the \
        suffix has, and at least 32. Find every place the text has `exact`, \
        character for character; places may overlap one another. Exactly one \
        place: it is the span, `unique-match`, whatever the model's prefix and \
        suffix say. More than one: if there is a hint, the span is the first \
        place, in the text's order, that fits every hint given, \
        `context-recovered`; with no hint, or no place that fits, the span is \
        the first place, `first-of-many`. No place at all: three looser \
        searches are tried in this order, and the first that finds a span \
        answers `fuzzy-match` with its own name as `matchQuality`. The first \
        two find places, which may overlap, and the span is chosen among them \
        as it is among the places the text has `exact`: the first place that \
        fits every hint given, and the first place of all when there is no \
        hint or none fits; the answer does not say which. (1) `normalized`. \
        Normalize the text and `exact` alike: every run of white space becomes \
        one space, the single quotation marks U+2018 and U+2019 become an \
        apostrophe, the double ones U+201C and U+201D become a straight double \
        quote, an em dash U+2014 becomes two hyphens and an en dash U+2013 \
        one, and white space at the two ends is dropped. A place is where the \
        normalized text has the normalized `exact`. It starts at the character \
        of the text that its first character came from, and ends just after \
        the character of the text that its last came from: white space the \
        text has after the match is no part of it. (2) `case-insensitive`. \
        Lower-case the text and `exact` by Unicode's own rule, of no \
        particular language, each as a whole: a capital sigma that ends a word \
        becomes the final one. A place is where the lower-cased text has the \
        lower-cased `exact`, and it is a span of the text, not of the \
        lower-cased text. A character may lower-case to more than one code \
        point (U+0130, a capital I with a dot, becomes two), so the place \
        starts at the character of the text that its first code point came \
        from and ends just after the character that its last came from, and \
        need not have as many code points as `exact`. A match that begins or \
        ends between the code points one character became takes that character \
        whole. (3) `fuzzy`. The hints play no part. The allowance is a \
        twentieth of the number of code points in `exact`, rounded down, with \
        no minimum: an `exact` of fewer than twenty code points has none, and \
        is found by what comes before this search or refused. Compare `exact` \
        with every stretch of the text, of whatever length, by edit distance: \
        the least number of single code points inserted, deleted or replaced \
        that turns one into the other. A stretch within the allowance is at \
        most the allowance longer or shorter than `exact`, and need not have \
        as many code points. The span is the stretch at the least distance, \
        provided that distance is within the allowance. Of several at the \
        least distance it is the first in the text; of those that begin at the \
        same place, the one nearest `exact` in length; and of two as near, the \
        shorter. If no stretch is within the allowance, the span is refused. \
        CONTEXT. The `prefix` is the 64 code points of the text before the \
        span, or all of them if there are fewer. If it would begin part of the \
        way through a word it is lengthened backwards a code point at a time, \
        by at most 32 more, until the character before it is a boundary or the \
        text begins. The `suffix` is the 64 code points after the span, or all \
        there are, lengthened forwards in the same way until the character \
        after it is a boundary or the text ends. A boundary is white space or \
        one of these eighteen and nothing else: . , ; : ! ? ' \" ( ) [ ] { } < \
        > / \\ (so not a hyphen, and not a curly quotation mark). White space \
        is what Unicode gives the White_Space property; no case rests on \
        U+0085 or U+FEFF, about which implementations disagree. Code points \
        are compared as they are, with no Unicode normalization: a letter \
        followed by a combining mark is not the one accented letter. What an \
        offset counts is held by a table of its own, \
        specs/src/text/offset-cases.json; some texts here have a character \
        outside the Basic Multilingual Plane, which is one code point and two \
        UTF-16 code units, so that a count of code units fails them. Add a \
        case here before changing an implementation.";
     cases =
       [
         ({
            why =
              "words the text has once are the span, and the context is the \
               text's: all of it on either side when there are fewer than 64 \
               characters";
            text = "The United States Congress passed the bill yesterday.";
            quoted = `Assoc [ ("exact", `String "United States") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 4);
                     ("end", `Int 17);
                     ("exact", `String "United States");
                     ("prefix", `String "The ");
                     ("suffix", `String " Congress passed the bill yesterday.");
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "where the words are once, what the model says surrounds them is \
               neither consulted nor kept";
            text = "The United States Congress passed the bill yesterday.";
            quoted =
              `Assoc
                [
                  ("exact", `String "United States");
                  ("prefix", `String "In ");
                  ("suffix", `String " Senate");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 4);
                     ("end", `Int 17);
                     ("exact", `String "United States");
                     ("prefix", `String "The ");
                     ("suffix", `String " Congress passed the bill yesterday.");
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why = "a span that begins the text has no prefix";
            text = "Hello World";
            quoted = `Assoc [ ("exact", `String "Hello") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 5);
                     ("exact", `String "Hello");
                     ("suffix", `String " World");
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why = "a span that ends the text has no suffix";
            text = "Hello World";
            quoted = `Assoc [ ("exact", `String "World") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 6);
                     ("end", `Int 11);
                     ("exact", `String "World");
                     ("prefix", `String "Hello ");
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "64 characters back from the span is the space before `The`, and \
               64 on from it is the space after `rent.`: the context is \
               exactly 64 characters each way, with nothing to lengthen";
            text =
              "Item 4. The treasurer reported a surplus for the third year \
               running and the members agreed that the reserve should be \
               raised to cover a full year of rent. Item 5 followed.";
            quoted = `Assoc [ ("exact", `String "the members agreed") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 72);
                     ("end", `Int 90);
                     ("exact", `String "the members agreed");
                     ( "prefix",
                       `String
                         "The treasurer reported a surplus for the third year \
                          running and " );
                     ( "suffix",
                       `String
                         " that the reserve should be raised to cover a full \
                          year of rent." );
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "64 characters back lands inside `room`: the prefix is \
               lengthened back through the hyphen, which is no boundary, to \
               the slash, which is one (72 characters); 64 on lands inside \
               `noted`, and the suffix is lengthened to the semicolon (66)";
            text =
              "Minutes: the committee met in the library/reading-room on \
               Tuesday afternoon to consider the revised proposal, and the \
               members agreed after a long discussion in which every objection \
               was heard, noted; then the meeting closed.";
            quoted = `Assoc [ ("exact", `String "the members agreed") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 114);
                     ("end", `Int 132);
                     ("exact", `String "the members agreed");
                     ( "prefix",
                       `String
                         "reading-room on Tuesday afternoon to consider the \
                          revised proposal, and " );
                     ( "suffix",
                       `String
                         " after a long discussion in which every objection \
                          was heard, noted" );
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "64 characters back and 64 on both land inside checksums with no \
               boundary for 32 characters more: the lengthening stops there, \
               and the context is 96 characters each way, beginning and ending \
               inside a word";
            text =
              "The archive \
               e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 \
               was verified against the register, and the members agreed that \
               the copy held in the vault under seal was \
               9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08 \
               too.";
            quoted = `Assoc [ ("exact", `String "the members agreed") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 116);
                     ("end", `Int 134);
                     ("exact", `String "the members agreed");
                     ( "prefix",
                       `String
                         "98fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 \
                          was verified against the register, and " );
                     ( "suffix",
                       `String
                         " that the copy held in the vault under seal was \
                          9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822c" );
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "offsets count code points, not bytes and not what a reader sees \
               as letters: before the span are an e with a combining acute \
               accent (two code points), and two ideographs (one each, three \
               bytes each)";
            text = "Cafe\204\129 \228\184\150\231\149\140 opened in 1876.";
            quoted = `Assoc [ ("exact", `String "opened") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 9);
                     ("end", `Int 15);
                     ("exact", `String "opened");
                     ("prefix", `String "Cafe\204\129 \228\184\150\231\149\140 ");
                     ("suffix", `String " in 1876.");
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "of three places, the model's prefix picks the second: only \
               there does the text before end with it";
            text =
              "Section A: the parties agree to terms. Section B: the parties \
               agree to conditions. Section C: the parties agree to schedule.";
            quoted =
              `Assoc
                [
                  ("exact", `String "the parties agree");
                  ("prefix", `String "Section B: ");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 50);
                     ("end", `Int 67);
                     ("exact", `String "the parties agree");
                     ( "prefix",
                       `String
                         "Section A: the parties agree to terms. Section B: " );
                     ( "suffix",
                       `String
                         " to conditions. Section C: the parties agree to \
                          schedule." );
                     ("anchorMethod", `String "context-recovered");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the model's suffix picks the third; its 64 characters of prefix \
               would begin inside `to`, and are lengthened by one";
            text =
              "Section A: the parties agree to terms. Section B: the parties \
               agree to conditions. Section C: the parties agree to schedule.";
            quoted =
              `Assoc
                [
                  ("exact", `String "the parties agree");
                  ("suffix", `String " to schedule");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 94);
                     ("end", `Int 111);
                     ("exact", `String "the parties agree");
                     ( "prefix",
                       `String
                         "to terms. Section B: the parties agree to \
                          conditions. Section C: " );
                     ("suffix", `String " to schedule.");
                     ("anchorMethod", `String "context-recovered");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a prefix given without the space that follows it does not end \
               the text before any place, but it is among the 32 characters \
               before the second, and that fits";
            text =
              "Section A: the parties agree to terms. Section B: the parties \
               agree to conditions. Section C: the parties agree to schedule.";
            quoted =
              `Assoc
                [
                  ("exact", `String "the parties agree");
                  ("prefix", `String "Section B:");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 50);
                     ("end", `Int 67);
                     ("exact", `String "the parties agree");
                     ( "prefix",
                       `String
                         "Section A: the parties agree to terms. Section B: " );
                     ( "suffix",
                       `String
                         " to conditions. Section C: the parties agree to \
                          schedule." );
                     ("anchorMethod", `String "context-recovered");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a hint that fits every place picks the first of them, and the \
               answer still says the context chose it";
            text =
              "Section A: the parties agree to terms. Section B: the parties \
               agree to conditions. Section C: the parties agree to schedule.";
            quoted =
              `Assoc
                [
                  ("exact", `String "the parties agree");
                  ("prefix", `String ": ");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 11);
                     ("end", `Int 28);
                     ("exact", `String "the parties agree");
                     ("prefix", `String "Section A: ");
                     ( "suffix",
                       `String
                         " to terms. Section B: the parties agree to \
                          conditions. Section C" );
                     ("anchorMethod", `String "context-recovered");
                   ]);
          }
           : cases_item);
         ({
            why =
              "both hints must fit the one place: the prefix alone would pick \
               the second and the suffix alone the third, no place has both, \
               and the span falls back to the first";
            text =
              "Section A: the parties agree to terms. Section B: the parties \
               agree to conditions. Section C: the parties agree to schedule.";
            quoted =
              `Assoc
                [
                  ("exact", `String "the parties agree");
                  ("prefix", `String "Section B: ");
                  ("suffix", `String " to schedule");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 11);
                     ("end", `Int 28);
                     ("exact", `String "the parties agree");
                     ("prefix", `String "Section A: ");
                     ( "suffix",
                       `String
                         " to terms. Section B: the parties agree to \
                          conditions. Section C" );
                     ("anchorMethod", `String "first-of-many");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a prefix of 65 characters is looked for in the 65 before each \
               place, not in 32: only so can it tell the second `Paris` from \
               the others, whose last 32 characters before are the same";
            text =
              "In the cold and rainy spring of the difficult year the \
               delegation arrived in Paris and stayed. In the warm and \
               pleasant summer of the prosperous year the delegation arrived \
               in Paris and stayed. In the crisp and golden autumn of the \
               uneventful year the delegation arrived in Paris and stayed.";
            quoted =
              `Assoc
                [
                  ("exact", `String "Paris");
                  ( "prefix",
                    `String
                      "pleasant summer of the prosperous year the delegation \
                       arrived in " );
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 176);
                     ("end", `Int 181);
                     ("exact", `String "Paris");
                     ( "prefix",
                       `String
                         "pleasant summer of the prosperous year the \
                          delegation arrived in " );
                     ( "suffix",
                       `String
                         " and stayed. In the crisp and golden autumn of the \
                          uneventful year" );
                     ("anchorMethod", `String "context-recovered");
                   ]);
          }
           : cases_item);
         ({
            why =
              "several places and no hint: the first, and the answer says it \
               was one of many";
            text = "foo foo foo";
            quoted = `Assoc [ ("exact", `String "foo") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 3);
                     ("exact", `String "foo");
                     ("suffix", `String " foo foo");
                     ("anchorMethod", `String "first-of-many");
                   ]);
          }
           : cases_item);
         ({
            why = "an empty prefix and an empty suffix are no hints at all";
            text = "X foo Y foo Z foo W";
            quoted =
              `Assoc
                [
                  ("exact", `String "foo");
                  ("prefix", `String "");
                  ("suffix", `String "");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 2);
                     ("end", `Int 5);
                     ("exact", `String "foo");
                     ("prefix", `String "X ");
                     ("suffix", `String " Y foo Z foo W");
                     ("anchorMethod", `String "first-of-many");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a hint that is only white space is no hint either: a prefix of \
               one space would fit every place, and the answer says that none \
               was chosen by its context";
            text = "X foo Y foo Z foo W";
            quoted =
              `Assoc [ ("exact", `String "foo"); ("prefix", `String " ") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 2);
                     ("end", `Int 5);
                     ("exact", `String "foo");
                     ("prefix", `String "X ");
                     ("suffix", `String " Y foo Z foo W");
                     ("anchorMethod", `String "first-of-many");
                   ]);
          }
           : cases_item);
         ({
            why =
              "nor is it a hint that fits no place: beside a prefix of only \
               white space, the suffix alone picks the third";
            text =
              "Section A: the parties agree to terms. Section B: the parties \
               agree to conditions. Section C: the parties agree to schedule.";
            quoted =
              `Assoc
                [
                  ("exact", `String "the parties agree");
                  ("prefix", `String "\n\t");
                  ("suffix", `String " to schedule");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 94);
                     ("end", `Int 111);
                     ("exact", `String "the parties agree");
                     ( "prefix",
                       `String
                         "to terms. Section B: the parties agree to \
                          conditions. Section C: " );
                     ("suffix", `String " to schedule.");
                     ("anchorMethod", `String "context-recovered");
                   ]);
          }
           : cases_item);
         ({
            why =
              "places may overlap: `ana` is in `banana` twice, at 1 and at 3, \
               so it is one of many and not unique";
            text = "banana";
            quoted = `Assoc [ ("exact", `String "ana") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 1);
                     ("end", `Int 4);
                     ("exact", `String "ana");
                     ("prefix", `String "b");
                     ("suffix", `String "na");
                     ("anchorMethod", `String "first-of-many");
                   ]);
          }
           : cases_item);
         ({
            why = "an empty quote is refused";
            text = "Some content";
            quoted = `Assoc [ ("exact", `String "") ];
            reconciled = None;
          }
           : cases_item);
         ({
            why =
              "a quote that is only white space is refused too: it is no words \
               to find";
            text = "Some content";
            quoted = `Assoc [ ("exact", `String " \n\t ") ];
            reconciled = None;
          }
           : cases_item);
         ({
            why =
              "and it is refused where the text has it, character for \
               character: the one space between the two words is not a span to \
               mark";
            text = "Hello World";
            quoted = `Assoc [ ("exact", `String " ") ];
            reconciled = None;
          }
           : cases_item);
         ({
            why =
              "the text has two spaces and a line break where the model wrote \
               one space each: found once both are normalized, and the quote \
               that is kept is the text's, white space and all";
            text = "The quick  brown\nfox jumps.";
            quoted = `Assoc [ ("exact", `String "quick brown fox") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 4);
                     ("end", `Int 20);
                     ("exact", `String "quick  brown\nfox");
                     ("prefix", `String "The ");
                     ("suffix", `String " jumps.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the text has curly quotation marks where the model wrote \
               straight ones; the span starts at 14, each run of white space \
               before it having been counted as the characters it really is";
            text =
              "Kenison, C.J.\n\
               The question for decision to \226\128\156any person\226\128\157 \
               today and more.";
            quoted =
              `Assoc
                [
                  ( "exact",
                    `String "The question for decision to \"any person\" today"
                  );
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 14);
                     ("end", `Int 61);
                     ( "exact",
                       `String
                         "The question for decision to \226\128\156any \
                          person\226\128\157 today" );
                     ("prefix", `String "Kenison, C.J.\n");
                     ("suffix", `String " and more.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "an en dash is one hyphen and an em dash two: the model's 20 \
               characters are 19 of the text, and the span ends where the \
               text's match ends, not 20 on from its start";
            text =
              "The years 1914\226\128\1471918 \226\128\148 the war \
               \226\128\148 changed everything.";
            quoted = `Assoc [ ("exact", `String "1914-1918 -- the war") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 10);
                     ("end", `Int 29);
                     ( "exact",
                       `String "1914\226\128\1471918 \226\128\148 the war" );
                     ("prefix", `String "The years ");
                     ("suffix", `String " \226\128\148 changed everything.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "it is the same the other way about: the model wrote the curly \
               marks and the em dash, the text has the plain ones";
            text = "He said \"no\" -- twice, and left.";
            quoted =
              `Assoc
                [
                  ( "exact",
                    `String "\226\128\156no\226\128\157 \226\128\148 twice" );
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 8);
                     ("end", `Int 21);
                     ("exact", `String "\"no\" -- twice");
                     ("prefix", `String "He said ");
                     ("suffix", `String ", and left.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a match found by normalizing that is the end of the text ends \
               where the text does, and has no suffix";
            text = "They called it the \226\128\156Great War\226\128\157";
            quoted = `Assoc [ ("exact", `String "the \"Great War\"") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 15);
                     ("end", `Int 30);
                     ("exact", `String "the \226\128\156Great War\226\128\157");
                     ("prefix", `String "They called it ");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "white space the text has after the match is no part of the \
               span: it ends just after the closing mark, the last character \
               the match came from, and the white space the text ends with is \
               its suffix";
            text = "They called it the \226\128\156Great War\226\128\157  \n";
            quoted = `Assoc [ ("exact", `String "the \"Great War\"") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 15);
                     ("end", `Int 30);
                     ("exact", `String "the \226\128\156Great War\226\128\157");
                     ("prefix", `String "They called it ");
                     ("suffix", `String "  \n");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the model ended with one hyphen where the text has an em dash, \
               which normalizes to two: the dash the match ends in is in the \
               span whole, and the span does not stop at the space before it";
            text =
              "The years 1914\226\128\1471918 \226\128\148 the war \
               \226\128\148 changed everything.";
            quoted = `Assoc [ ("exact", `String "the war -") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 22);
                     ("end", `Int 31);
                     ("exact", `String "the war \226\128\148");
                     ( "prefix",
                       `String "The years 1914\226\128\1471918 \226\128\148 " );
                     ("suffix", `String " changed everything.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a hint chooses among the places a looser search finds, as it \
               does among the places the text has `exact`: the text has two \
               spaces where the model wrote one, in three places, and the \
               model's prefix picks the second";
            text =
              "Section A: the  parties agree to terms. Section B: the  parties \
               agree to conditions. Section C: the  parties agree to schedule.";
            quoted =
              `Assoc
                [
                  ("exact", `String "the parties agree");
                  ("prefix", `String "Section B: ");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 51);
                     ("end", `Int 69);
                     ("exact", `String "the  parties agree");
                     ( "prefix",
                       `String
                         "Section A: the  parties agree to terms. Section B: "
                     );
                     ( "suffix",
                       `String
                         " to conditions. Section C: the  parties agree to \
                          schedule." );
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a suffix is looked for after the place as the text has it, \
               which here is a code point longer than the model's words: it \
               picks the third";
            text =
              "Section A: the  parties agree to terms. Section B: the  parties \
               agree to conditions. Section C: the  parties agree to schedule.";
            quoted =
              `Assoc
                [
                  ("exact", `String "the parties agree");
                  ("suffix", `String " to schedule");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 96);
                     ("end", `Int 114);
                     ("exact", `String "the  parties agree");
                     ( "prefix",
                       `String
                         "to terms. Section B: the  parties agree to \
                          conditions. Section C: " );
                     ("suffix", `String " to schedule.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a hint that fits none of the places a looser search finds \
               chooses none: the span is the first of them";
            text =
              "Section A: the  parties agree to terms. Section B: the  parties \
               agree to conditions. Section C: the  parties agree to schedule.";
            quoted =
              `Assoc
                [
                  ("exact", `String "the parties agree");
                  ("prefix", `String "Section D: ");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 11);
                     ("end", `Int 29);
                     ("exact", `String "the  parties agree");
                     ("prefix", `String "Section A: ");
                     ( "suffix",
                       `String
                         " to terms. Section B: the  parties agree to \
                          conditions. Section C" );
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the model lower-cased the words: found without regard to case, \
               and the quote that is kept is the text's";
            text = "The United States Congress passed the bill yesterday.";
            quoted = `Assoc [ ("exact", `String "united states") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 4);
                     ("end", `Int 17);
                     ("exact", `String "United States");
                     ("prefix", `String "The ");
                     ("suffix", `String " Congress passed the bill yesterday.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "case is Unicode's, not only that of the 26 letters: a small e \
               with an acute accent finds the capital";
            text =
              "Elle entra \195\160 l\226\128\153\195\137cole normale en 1924.";
            quoted = `Assoc [ ("exact", `String "\195\169cole normale") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 15);
                     ("end", `Int 28);
                     ("exact", `String "\195\137cole normale");
                     ("prefix", `String "Elle entra \195\160 l\226\128\153");
                     ("suffix", `String " en 1924.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the text and the quote are each lower-cased whole, not a \
               character at a time: the capital sigma that ends a word becomes \
               the final sigma, which is what the model wrote";
            text =
              "\206\151 \206\159\206\148\206\159\206\163 \
               \206\149\206\161\206\156\206\159\206\165 \
               \206\181\206\175\206\189\206\177\206\185 \
               \206\186\206\181\206\189\207\132\207\129\206\185\206\186\206\174.";
            quoted =
              `Assoc
                [
                  ( "exact",
                    `String
                      "\206\191\206\180\206\191\207\130 \
                       \206\181\207\129\206\188\206\191\207\133" );
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 2);
                     ("end", `Int 12);
                     ( "exact",
                       `String
                         "\206\159\206\148\206\159\206\163 \
                          \206\149\206\161\206\156\206\159\206\165" );
                     ("prefix", `String "\206\151 ");
                     ( "suffix",
                       `String
                         " \206\181\206\175\206\189\206\177\206\185 \
                          \206\186\206\181\206\189\207\132\207\129\206\185\206\186\206\174."
                     );
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the place is a position in the text, not in the lower-cased \
               text: the capital I with a dot before it (U+0130) lower-cases \
               to two code points, and the span is not a code point further on \
               for that";
            text = "\196\176stanbul and ANKARA are cities.";
            quoted = `Assoc [ ("exact", `String "ankara") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 13);
                     ("end", `Int 19);
                     ("exact", `String "ANKARA");
                     ("prefix", `String "\196\176stanbul and ");
                     ("suffix", `String " are cities.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "nor is the span as long as the quote where lower-casing changes \
               the count inside it: the model's nine code points, an i and a \
               combining dot (U+0307) the first two, are eight of the text";
            text = "They met in \196\176STANBUL in May.";
            quoted = `Assoc [ ("exact", `String "i\204\135stanbul") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 12);
                     ("end", `Int 20);
                     ("exact", `String "\196\176STANBUL");
                     ("prefix", `String "They met in ");
                     ("suffix", `String " in May.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a match that ends between the two code points a character \
               became takes that character whole: the model's plain i is the \
               first of the two that the capital I with a dot (U+0130) \
               lower-cases to, and the span ends after that letter";
            text = "They took a TAKS\196\176 to the airport.";
            quoted = `Assoc [ ("exact", `String "taksi") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 12);
                     ("end", `Int 17);
                     ("exact", `String "TAKS\196\176");
                     ("prefix", `String "They took a ");
                     ("suffix", `String " to the airport.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "so does one that begins between them: a quote that begins with \
               the combining dot (U+0307), the second of the two, starts at \
               the letter";
            text = "They met in \196\176STANBUL in May.";
            quoted = `Assoc [ ("exact", `String "\204\135stanbul") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 12);
                     ("end", `Int 20);
                     ("exact", `String "\196\176STANBUL");
                     ("prefix", `String "They met in ");
                     ("suffix", `String " in May.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a hint chooses among the places found without regard to case \
               too: the model's suffix picks the third";
            text =
              "Section A: The Parties Agree to terms. Section B: The Parties \
               Agree to conditions. Section C: The Parties Agree to schedule.";
            quoted =
              `Assoc
                [
                  ("exact", `String "the parties agree");
                  ("suffix", `String " to schedule");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 94);
                     ("end", `Int 111);
                     ("exact", `String "The Parties Agree");
                     ( "prefix",
                       `String
                         "to terms. Section B: The Parties Agree to \
                          conditions. Section C: " );
                     ("suffix", `String " to schedule.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "one wrong letter (`Vienma`) in a quote of 29 code points, which \
               allow one edit: no search by spelling finds it, and the stretch \
               one replacement away does";
            text = "The treaty was signed in Vienna on the ninth of June.";
            quoted =
              `Assoc [ ("exact", `String "signed in Vienma on the ninth") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 15);
                     ("end", `Int 44);
                     ("exact", `String "signed in Vienna on the ninth");
                     ("prefix", `String "The treaty was ");
                     ("suffix", `String " of June.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "twenty code points are the fewest that allow an edit: one wrong \
               letter in a quote of twenty is found";
            text = "The treaty was signed in Vienna on the ninth of June.";
            quoted = `Assoc [ ("exact", `String "was signed in Vienma") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 11);
                     ("end", `Int 31);
                     ("exact", `String "was signed in Vienna");
                     ("prefix", `String "The treaty ");
                     ("suffix", `String " on the ninth of June.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "nineteen allow none: the same wrong letter in a quote of \
               nineteen is refused, though a stretch of the text is one \
               replacement away";
            text = "The treaty was signed in Vienna on the ninth of June.";
            quoted = `Assoc [ ("exact", `String "signed in Vienma on") ];
            reconciled = None;
          }
           : cases_item);
         ({
            why =
              "the allowance has no minimum: a quote of 37 code points is \
               allowed a twentieth of them, rounded down, which is 1, and five \
               wrong letters are refused";
            text = "The treaty was signed in Vienna on the ninth of June.";
            quoted =
              `Assoc
                [ ("exact", `String "sigmed im Viemma om the ninth of June") ];
            reconciled = None;
          }
           : cases_item);
         ({
            why =
              "a short quote that is nowhere in the text is refused, not \
               anchored to whichever stretch of its length is nearest";
            text = "The quick brown fox jumps over the lazy dog.";
            quoted = `Assoc [ ("exact", `String "zebra") ];
            reconciled = None;
          }
           : cases_item);
         ({
            why =
              "a quote of 120 characters is allowed a twentieth of them, 6: \
               six wrong letters (each an x) are found";
            text =
              "The council resolved that the bridge over the river should be \
               rebuilt in stone before the winter, and that the cost should be \
               met from the harbour dues of the year.";
            quoted =
              `Assoc
                [
                  ( "exact",
                    `String
                      "the bridgx over the rivxr should be rxbuilt in stonx \
                       before the wintxr, and that the cxst should be met from \
                       the harbour" );
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 26);
                     ("end", `Int 146);
                     ( "exact",
                       `String
                         "the bridge over the river should be rebuilt in stone \
                          before the winter, and that the cost should be met \
                          from the harbour" );
                     ("prefix", `String "The council resolved that ");
                     ("suffix", `String " dues of the year.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the same quote one character shorter is 119, a twentieth of \
               which rounds down to 5: the same six wrong letters are refused";
            text =
              "The council resolved that the bridge over the river should be \
               rebuilt in stone before the winter, and that the cost should be \
               met from the harbour dues of the year.";
            quoted =
              `Assoc
                [
                  ( "exact",
                    `String
                      "the bridgx over the rivxr should be rxbuilt in stonx \
                       before the wintxr, and that the cxst should be met from \
                       the harbou" );
                ];
            reconciled = None;
          }
           : cases_item);
         ({
            why =
              "two stretches are each one letter away (`cat` at 5, `bat` at \
               34): the first of them is the span";
            text = "Then the cat sat on the mat while the bat sat on the mat.";
            quoted = `Assoc [ ("exact", `String "the rat sat on the mat") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 5);
                     ("end", `Int 27);
                     ("exact", `String "the cat sat on the mat");
                     ("prefix", `String "Then ");
                     ("suffix", `String " while the bat sat on the mat.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the hints play no part in this search: the model's prefix is \
               before the second of those two stretches, and the span is still \
               the first";
            text = "Then the cat sat on the mat while the bat sat on the mat.";
            quoted =
              `Assoc
                [
                  ("exact", `String "the rat sat on the mat");
                  ("prefix", `String "while ");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 5);
                     ("end", `Int 27);
                     ("exact", `String "the cat sat on the mat");
                     ("prefix", `String "Then ");
                     ("suffix", `String " while the bat sat on the mat.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "of the nearest stretches that begin at the same place, the one \
               nearest the quote in length is the span: the model wrote the \
               last letter wrong (`nintx`), which is one edit from the 28 code \
               points without that letter and one from the 29 with the text's \
               letter in its place, and the quote is 29";
            text = "The treaty was signed in Vienna on the ninth of June.";
            quoted =
              `Assoc [ ("exact", `String "signed in Vienna on the nintx") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 15);
                     ("end", `Int 44);
                     ("exact", `String "signed in Vienna on the ninth");
                     ("prefix", `String "The treaty was ");
                     ("suffix", `String " of June.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "and of two as near, the shorter: `baana` is one edit from \
               `bana` and one from `banana`, a code point shorter than the \
               quote and a code point longer, and two from `banan`, which is \
               as long as it";
            text = "They sold the last ripe banana at the market.";
            quoted = `Assoc [ ("exact", `String "sold the last ripe baana") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 5);
                     ("end", `Int 28);
                     ("exact", `String "sold the last ripe bana");
                     ("prefix", `String "They ");
                     ("suffix", `String "na at the market.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the nearest stretch is the span, not the first within the \
               allowance: a quote of 45 code points is allowed 2, the stretch \
               at 6 is 2 away and the one at 59 is 1 away";
            text =
              "Then: the colour and flavor of the wine were praised. Now: the \
               color and flavor of the wine were praised.";
            quoted =
              `Assoc
                [
                  ( "exact",
                    `String "the colox and flavor of the wine were praised" );
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 59);
                     ("end", `Int 104);
                     ( "exact",
                       `String "the color and flavor of the wine were praised"
                     );
                     ( "prefix",
                       `String
                         "Then: the colour and flavor of the wine were \
                          praised. Now: " );
                     ("suffix", `String ".");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the model dropped a letter (`Viena`): the stretch one edit away \
               is a code point longer than the quote, and it is the span, the \
               words the text really has";
            text = "The treaty was signed in Vienna on the ninth of June.";
            quoted =
              `Assoc [ ("exact", `String "signed in Viena on the ninth") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 15);
                     ("end", `Int 44);
                     ("exact", `String "signed in Vienna on the ninth");
                     ("prefix", `String "The treaty was ");
                     ("suffix", `String " of June.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the model added a letter (`Viennna`): the stretch one edit away \
               is a code point shorter than the quote";
            text = "The treaty was signed in Vienna on the ninth of June.";
            quoted =
              `Assoc [ ("exact", `String "signed in Viennna on the ninth") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 15);
                     ("end", `Int 44);
                     ("exact", `String "signed in Vienna on the ninth");
                     ("prefix", `String "The treaty was ");
                     ("suffix", `String " of June.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a text may be shorter than the quote, by no more than the \
               allowance: here the whole text is the stretch, one edit away, \
               and the span has neither prefix nor suffix";
            text = "signed in Vienna on the ninth";
            quoted =
              `Assoc [ ("exact", `String "signed in Viennna on the ninth") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 29);
                     ("exact", `String "signed in Vienna on the ninth");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a text shorter than the quote by more than the allowance has no \
               stretch near enough: refused";
            text = "A short note.";
            quoted =
              `Assoc [ ("exact", `String "a considerably longer quotation") ];
            reconciled = None;
          }
           : cases_item);
         ({
            why =
              "words that are nowhere in the text, and nothing like any \
               stretch of it (the nearest, of whatever length, is 27 away), \
               are refused";
            text = "The quick brown fox jumps over the lazy dog.";
            quoted =
              `Assoc
                [ ("exact", `String "Nonexistent Text That Does Not Appear") ];
            reconciled = None;
          }
           : cases_item);
         ({
            why =
              "a character outside the Basic Multilingual Plane is one code \
               point: the span after it starts at 6, where a count of UTF-16 \
               code units says 7";
            text =
              "\240\159\142\137 The United States Congress passed the bill \
               yesterday.";
            quoted = `Assoc [ ("exact", `String "United States") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 6);
                     ("end", `Int 19);
                     ("exact", `String "United States");
                     ("prefix", `String "\240\159\142\137 The ");
                     ("suffix", `String " Congress passed the bill yesterday.");
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a span that holds such a character is as long as its code \
               points: seven here, so it ends at 21";
            text = "\240\159\152\128 first, then \240\159\142\137 party words";
            quoted = `Assoc [ ("exact", `String "\240\159\142\137 party") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 14);
                     ("end", `Int 21);
                     ("exact", `String "\240\159\142\137 party");
                     ("prefix", `String "\240\159\152\128 first, then ");
                     ("suffix", `String " words");
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the 64 of the context are code points: the 64 before the span \
               begin with the space after `4.` and the 64 after it end with \
               the full stop after `rent`, and neither is lengthened, the \
               character beyond each being a boundary; 64 UTF-16 code units \
               either way are one character short of each";
            text =
              "Item 4. The treasurer \240\159\146\176 reports a surplus for a \
               third year running and the members agreed that the reserve \
               \240\159\143\166 must be raised to cover a full year of rent. \
               Item 5 followed.";
            quoted = `Assoc [ ("exact", `String "the members agreed") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 71);
                     ("end", `Int 89);
                     ("exact", `String "the members agreed");
                     ( "prefix",
                       `String
                         " The treasurer \240\159\146\176 reports a surplus \
                          for a third year running and " );
                     ( "suffix",
                       `String
                         " that the reserve \240\159\143\166 must be raised to \
                          cover a full year of rent." );
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "so are the 32 of the lengthening: in a text with no white space \
               and none of the eighteen marks the context is 96 code points \
               each way, 64 and 32 more, however many UTF-16 code units they \
               are (127 here, a third of the characters being outside the \
               Basic Multilingual Plane)";
            text =
              "\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\227\129\167\231\137\155\228\184\188\227\130\146\233\163\159\227\129\185\227\130\139\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182";
            quoted = `Assoc [ ("exact", `String "\231\137\155\228\184\188") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 103);
                     ("end", `Int 105);
                     ("exact", `String "\231\137\155\228\184\188");
                     ( "prefix",
                       `String
                         "\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\227\129\167"
                     );
                     ( "suffix",
                       `String
                         "\227\130\146\233\163\159\227\129\185\227\130\139\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142\229\174\182\240\160\174\183\233\135\142"
                     );
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "so are the 32 before a place that a hint is looked for in: \
               `Lemma 2` ends 25 code points before the second `holds`, and is \
               among the 32 before it, though eleven of the 25 are outside the \
               Basic Multilingual Plane and it is not among the 32 UTF-16 code \
               units before it";
            text =
              "Lemma 1: \240\157\145\147(\240\157\145\165) = \
               \240\157\145\142\240\157\145\165\240\157\145\165 + \
               \240\157\145\143\240\157\145\165\240\157\145\166 + \
               \240\157\145\144\240\157\145\166\240\157\145\166 holds. Lemma \
               2: \240\157\145\148(\240\157\145\165) = \
               \240\157\145\142\240\157\145\165\240\157\145\165 + \
               \240\157\145\143\240\157\145\165\240\157\145\166 + \
               \240\157\145\144\240\157\145\166\240\157\145\166 holds.";
            quoted =
              `Assoc
                [ ("exact", `String "holds"); ("prefix", `String "Lemma 2") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 71);
                     ("end", `Int 76);
                     ("exact", `String "holds");
                     ( "prefix",
                       `String
                         "1: \240\157\145\147(\240\157\145\165) = \
                          \240\157\145\142\240\157\145\165\240\157\145\165 + \
                          \240\157\145\143\240\157\145\165\240\157\145\166 + \
                          \240\157\145\144\240\157\145\166\240\157\145\166 \
                          holds. Lemma 2: \240\157\145\148(\240\157\145\165) = \
                          \240\157\145\142\240\157\145\165\240\157\145\165 + \
                          \240\157\145\143\240\157\145\165\240\157\145\166 + \
                          \240\157\145\144\240\157\145\166\240\157\145\166 " );
                     ("suffix", `String ".");
                     ("anchorMethod", `String "context-recovered");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a span found by normalizing, after such a character and \
               beginning with another: the offsets it is given are the text's, \
               in code points, and it is as long as its code points";
            text =
              "\240\159\142\137 The \240\159\166\138 quick  brown\nfox jumps.";
            quoted =
              `Assoc [ ("exact", `String "\240\159\166\138 quick brown fox") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 6);
                     ("end", `Int 24);
                     ("exact", `String "\240\159\166\138 quick  brown\nfox");
                     ("prefix", `String "\240\159\142\137 The ");
                     ("suffix", `String " jumps.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a span found without regard to case, after such a character and \
               beginning with another: its offsets are the text's too, and it \
               has as many code points as `exact`";
            text =
              "\240\159\142\137 The \240\159\166\138 United States Congress \
               passed the bill yesterday.";
            quoted =
              `Assoc [ ("exact", `String "\240\159\166\138 united states") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 6);
                     ("end", `Int 21);
                     ("exact", `String "\240\159\166\138 United States");
                     ("prefix", `String "\240\159\142\137 The ");
                     ("suffix", `String " Congress passed the bill yesterday.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "an edit is of one code point: the model wrote the common form \
               (U+5409) of a character the text has in a rare one (U+20BB7, \
               outside the Basic Multilingual Plane), which is one replacement \
               in a quote of 21, and 21 allow one";
            text =
              "\230\152\168\230\151\165\227\129\174\229\164\156\227\129\175\229\143\139\233\129\148\227\129\168\228\184\128\231\183\146\227\129\171\240\160\174\183\233\135\142\229\174\182\227\129\174\231\137\155\228\184\188\227\130\146\233\163\159\227\129\185\227\129\159\227\128\130";
            quoted =
              `Assoc
                [
                  ( "exact",
                    `String
                      "\230\152\168\230\151\165\227\129\174\229\164\156\227\129\175\229\143\139\233\129\148\227\129\168\228\184\128\231\183\146\227\129\171\229\144\137\233\135\142\229\174\182\227\129\174\231\137\155\228\184\188\227\130\146\233\163\159\227\129\185\227\129\159"
                  );
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 21);
                     ( "exact",
                       `String
                         "\230\152\168\230\151\165\227\129\174\229\164\156\227\129\175\229\143\139\233\129\148\227\129\168\228\184\128\231\183\146\227\129\171\240\160\174\183\233\135\142\229\174\182\227\129\174\231\137\155\228\184\188\227\130\146\233\163\159\227\129\185\227\129\159"
                     );
                     ("suffix", `String "\227\128\130");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a quote that holds such a character is as long as its code \
               points: 24 here, which allow one edit, and the first stretch of \
               the text is one replacement away";
            text = "the \240\159\152\128 cat sat on the mat today";
            quoted =
              `Assoc
                [ ("exact", `String "the \240\159\152\128 bat sat on the mat") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 24);
                     ("exact", `String "the \240\159\152\128 cat sat on the mat");
                     ("suffix", `String " today");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a prefix is looked for in as many code points before a place as \
               the prefix has: this one is 34, with a space at its end that \
               the text does not have there, so it is looked for whole in the \
               34 before the second `holds`, which reach back only into the \
               middle of it; it fits neither place, and the span is the first. \
               Its twelve characters outside the Basic Multilingual Plane make \
               it 46 UTF-16 code units, which would reach all of it";
            text =
              "The bound holds. For \240\157\145\148(\240\157\145\165) = \
               \240\157\145\142\240\157\145\165\240\157\145\165 + \
               \240\157\145\143\240\157\145\165\240\157\145\166 + \
               \240\157\145\144\240\157\145\166\240\157\145\166 with \
               \240\157\145\142 > 0, it also holds.";
            quoted =
              `Assoc
                [
                  ("exact", `String "holds");
                  ( "prefix",
                    `String
                      "\240\157\145\148(\240\157\145\165) = \
                       \240\157\145\142\240\157\145\165\240\157\145\165 + \
                       \240\157\145\143\240\157\145\165\240\157\145\166 + \
                       \240\157\145\144\240\157\145\166\240\157\145\166 with \
                       \240\157\145\142 > 0 " );
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 10);
                     ("end", `Int 15);
                     ("exact", `String "holds");
                     ("prefix", `String "The bound ");
                     ( "suffix",
                       `String
                         ". For \240\157\145\148(\240\157\145\165) = \
                          \240\157\145\142\240\157\145\165\240\157\145\165 + \
                          \240\157\145\143\240\157\145\165\240\157\145\166 + \
                          \240\157\145\144\240\157\145\166\240\157\145\166 \
                          with \240\157\145\142 > 0, it also holds." );
                     ("anchorMethod", `String "first-of-many");
                   ]);
          }
           : cases_item);
         ({
            why =
              "and a suffix in as many code points after a place as the suffix \
               has: the same words with a space before them are 34, and the 34 \
               after the second `holds` stop short of their end";
            text =
              "It holds. It also holds for \240\157\145\148(\240\157\145\165) \
               = \240\157\145\142\240\157\145\165\240\157\145\165 + \
               \240\157\145\143\240\157\145\165\240\157\145\166 + \
               \240\157\145\144\240\157\145\166\240\157\145\166 with \
               \240\157\145\142 > 0.";
            quoted =
              `Assoc
                [
                  ("exact", `String "holds");
                  ( "suffix",
                    `String
                      " \240\157\145\148(\240\157\145\165) = \
                       \240\157\145\142\240\157\145\165\240\157\145\165 + \
                       \240\157\145\143\240\157\145\165\240\157\145\166 + \
                       \240\157\145\144\240\157\145\166\240\157\145\166 with \
                       \240\157\145\142 > 0" );
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 3);
                     ("end", `Int 8);
                     ("exact", `String "holds");
                     ("prefix", `String "It ");
                     ( "suffix",
                       `String
                         ". It also holds for \
                          \240\157\145\148(\240\157\145\165) = \
                          \240\157\145\142\240\157\145\165\240\157\145\165 + \
                          \240\157\145\143\240\157\145\165\240\157\145\166 + \
                          \240\157\145\144\240\157\145\166\240\157\145\166 \
                          with \240\157\145\142 > 0." );
                     ("anchorMethod", `String "first-of-many");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the allowance is a twentieth of the quote's code points: this \
               quote is 119 of them, which allow 5, and its six wrong letters \
               are refused, though it is 120 UTF-16 code units, which would \
               allow 6";
            text =
              "The council resolved that the bridge over the river should be \
               rebuilt in stone before the winter \240\159\140\168 and that \
               the cost should be met from the harbour dues of the year.";
            quoted =
              `Assoc
                [
                  ( "exact",
                    `String
                      "the bridgx over the rivxr should be rxbuilt in stonx \
                       before the wintxr \240\159\140\168 and that the cxst \
                       should be met from the harbo" );
                ];
            reconciled = None;
          }
           : cases_item);
         ({
            why =
              "the allowance is counted in code points at its least as at its \
               greatest: this quote is 19 of them, which allow none, and its \
               one wrong letter is refused, though it is 20 UTF-16 code units, \
               which would allow one";
            text = "Then the \240\159\166\138 jumped over a log and ran.";
            quoted =
              `Assoc [ ("exact", `String "\240\159\166\138 jumped ovex a log") ];
            reconciled = None;
          }
           : cases_item);
         ({
            why =
              "a stretch longer than the quote is longer in code points: the \
               model dropped a letter (`lzy`) from words that begin with a \
               character outside the Basic Multilingual Plane, after another, \
               and the span is the 26 code points the text has";
            text =
              "\240\159\142\137 The \240\159\166\138 jumped over the lazy dog \
               and ran.";
            quoted =
              `Assoc
                [
                  ("exact", `String "\240\159\166\138 jumped over the lzy dog");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 6);
                     ("end", `Int 32);
                     ( "exact",
                       `String "\240\159\166\138 jumped over the lazy dog" );
                     ("prefix", `String "\240\159\142\137 The ");
                     ("suffix", `String " and ran.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "such a character that the model dropped is one code point, and \
               so one edit: the span takes it in";
            text = "Then the \240\159\152\128 cat sat on the mat.";
            quoted = `Assoc [ ("exact", `String "the  cat sat on the mat") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 5);
                     ("end", `Int 29);
                     ("exact", `String "the \240\159\152\128 cat sat on the mat");
                     ("prefix", `String "Then ");
                     ("suffix", `String ".");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "fuzzy");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a span found without regard to case, after a capital I with a \
               dot and two characters outside the Basic Multilingual Plane, \
               and beginning with one of them: every one is a single code \
               point of the text, whatever it is lower-cased or in UTF-16";
            text =
              "\240\159\142\137 \196\176stanbul and \240\159\166\138 ANKARA \
               are cities.";
            quoted = `Assoc [ ("exact", `String "\240\159\166\138 ankara") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 15);
                     ("end", `Int 23);
                     ("exact", `String "\240\159\166\138 ANKARA");
                     ("prefix", `String "\240\159\142\137 \196\176stanbul and ");
                     ("suffix", `String " are cities.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a span found by normalizing that ends with such a character \
               ends just after it, and the white space the text ends with is \
               its suffix";
            text =
              "\240\159\142\137 Result: \226\128\156done\226\128\157 \
               \240\159\166\138 \n\n";
            quoted = `Assoc [ ("exact", `String "\"done\" \240\159\166\138") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 10);
                     ("end", `Int 18);
                     ( "exact",
                       `String "\226\128\156done\226\128\157 \240\159\166\138"
                     );
                     ("prefix", `String "\240\159\142\137 Result: ");
                     ("suffix", `String " \n\n");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a suffix of 64 characters is looked for in the 64 after each \
               place, not in 32: only so can it tell the second `Paris` from \
               the others, whose first 32 characters after are the same";
            text =
              "Paris, the city on the river Seine in the north of France, in \
               spring. Paris, the city on the river Seine in the north of \
               France, in autumn. Paris, the city on the river Seine in the \
               north of France, in winter.";
            quoted =
              `Assoc
                [
                  ("exact", `String "Paris");
                  ( "suffix",
                    `String
                      ", the city on the river Seine in the north of France, \
                       in autumn." );
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 70);
                     ("end", `Int 75);
                     ("exact", `String "Paris");
                     ( "prefix",
                       `String
                         " the city on the river Seine in the north of France, \
                          in spring. " );
                     ( "suffix",
                       `String
                         ", the city on the river Seine in the north of \
                          France, in autumn." );
                     ("anchorMethod", `String "context-recovered");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a suffix given with a space after it that the text does not \
               have there does not start the text after any place, but trimmed \
               it is among the 32 characters after the second, and that fits";
            text =
              "Paris is very large today. Paris, it is said, was Roman. Paris \
               is old.";
            quoted =
              `Assoc
                [ ("exact", `String "Paris"); ("suffix", `String "was Roman ") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 27);
                     ("end", `Int 32);
                     ("exact", `String "Paris");
                     ("prefix", `String "Paris is very large today. ");
                     ("suffix", `String ", it is said, was Roman. Paris is old.");
                     ("anchorMethod", `String "context-recovered");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the single quotation marks are apostrophes once normalized: the \
               text has U+2018 and U+2019 where the model wrote the plain \
               mark, three times, and the quote that is kept has the text's \
               own marks";
            text =
              "He called it \226\128\152the engine\226\128\153 and it \
               wasn\226\128\153t built.";
            quoted = `Assoc [ ("exact", `String "'the engine' and it wasn't") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 13);
                     ("end", `Int 39);
                     ( "exact",
                       `String
                         "\226\128\152the engine\226\128\153 and it \
                          wasn\226\128\153t" );
                     ("prefix", `String "He called it ");
                     ("suffix", `String " built.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "it is the same the other way about: the model wrote U+2018 and \
               U+2019, the text has the plain apostrophe";
            text = "It's Ada's 'engine', isn't it?";
            quoted =
              `Assoc
                [
                  ( "exact",
                    `String "Ada\226\128\153s \226\128\152engine\226\128\153" );
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 5);
                     ("end", `Int 19);
                     ("exact", `String "Ada's 'engine'");
                     ("prefix", `String "It's ");
                     ("suffix", `String ", isn't it?");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a run of white space is one space in the quote as it is in the \
               text: the model wrote two spaces, and a line break and a tab, \
               where the text has one space each";
            text = "The quick brown fox jumps.";
            quoted = `Assoc [ ("exact", `String "quick  brown\n\tfox") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 4);
                     ("end", `Int 19);
                     ("exact", `String "quick brown fox");
                     ("prefix", `String "The ");
                     ("suffix", `String " jumps.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "an en dash the model wrote is one hyphen, as one the text has \
               is: the text has the hyphen";
            text = "See pages 10-12 of the report.";
            quoted = `Assoc [ ("exact", `String "pages 10\226\128\14712") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 4);
                     ("end", `Int 15);
                     ("exact", `String "pages 10-12");
                     ("prefix", `String "See ");
                     ("suffix", `String " of the report.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "white space at the two ends of the quote is dropped before it \
               is looked for: the model began with a space and ended with a \
               line break, the text has a full stop after the words, and the \
               span is the words alone";
            text = "Ada wrote the notes.";
            quoted = `Assoc [ ("exact", `String " wrote the notes\n") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 4);
                     ("end", `Int 19);
                     ("exact", `String "wrote the notes");
                     ("prefix", `String "Ada ");
                     ("suffix", `String ".");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a comma and an exclamation mark are boundaries: 64 characters \
               back lands inside `westward` and the prefix is lengthened back \
               to the mark before it, not through it to `north`; 64 on lands \
               inside `eastward` and the suffix is lengthened to the mark \
               after it, not through it to `south`";
            text =
              "north,westward the surveyors walked by the old canal that \
               morning and at noon they sat down on the towpath wall to eat \
               and later turned eastward!south";
            quoted = `Assoc [ ("exact", `String "noon") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 73);
                     ("end", `Int 77);
                     ("exact", `String "noon");
                     ( "prefix",
                       `String
                         "westward the surveyors walked by the old canal that \
                          morning and at " );
                     ( "suffix",
                       `String
                         " they sat down on the towpath wall to eat and later \
                          turned eastward" );
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a question mark and an apostrophe are boundaries: 64 characters \
               back lands inside `westward` and the prefix is lengthened back \
               to the mark before it, not through it to `north`; 64 on lands \
               inside `eastward` and the suffix is lengthened to the mark \
               after it, not through it to `south`";
            text =
              "north?westward the surveyors walked by the old canal that \
               morning and at noon they sat down on the towpath wall to eat \
               and later turned eastward'south";
            quoted = `Assoc [ ("exact", `String "noon") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 73);
                     ("end", `Int 77);
                     ("exact", `String "noon");
                     ( "prefix",
                       `String
                         "westward the surveyors walked by the old canal that \
                          morning and at " );
                     ( "suffix",
                       `String
                         " they sat down on the towpath wall to eat and later \
                          turned eastward" );
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a double quotation mark and an opening parenthesis are \
               boundaries: 64 characters back lands inside `westward` and the \
               prefix is lengthened back to the mark before it, not through it \
               to `north`; 64 on lands inside `eastward` and the suffix is \
               lengthened to the mark after it, not through it to `south`";
            text =
              "north\"westward the surveyors walked by the old canal that \
               morning and at noon they sat down on the towpath wall to eat \
               and later turned eastward(south";
            quoted = `Assoc [ ("exact", `String "noon") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 73);
                     ("end", `Int 77);
                     ("exact", `String "noon");
                     ( "prefix",
                       `String
                         "westward the surveyors walked by the old canal that \
                          morning and at " );
                     ( "suffix",
                       `String
                         " they sat down on the towpath wall to eat and later \
                          turned eastward" );
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a closing parenthesis and an opening square bracket are \
               boundaries: 64 characters back lands inside `westward` and the \
               prefix is lengthened back to the mark before it, not through it \
               to `north`; 64 on lands inside `eastward` and the suffix is \
               lengthened to the mark after it, not through it to `south`";
            text =
              "north)westward the surveyors walked by the old canal that \
               morning and at noon they sat down on the towpath wall to eat \
               and later turned eastward[south";
            quoted = `Assoc [ ("exact", `String "noon") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 73);
                     ("end", `Int 77);
                     ("exact", `String "noon");
                     ( "prefix",
                       `String
                         "westward the surveyors walked by the old canal that \
                          morning and at " );
                     ( "suffix",
                       `String
                         " they sat down on the towpath wall to eat and later \
                          turned eastward" );
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a closing square bracket and an opening brace are boundaries: \
               64 characters back lands inside `westward` and the prefix is \
               lengthened back to the mark before it, not through it to \
               `north`; 64 on lands inside `eastward` and the suffix is \
               lengthened to the mark after it, not through it to `south`";
            text =
              "north]westward the surveyors walked by the old canal that \
               morning and at noon they sat down on the towpath wall to eat \
               and later turned eastward{south";
            quoted = `Assoc [ ("exact", `String "noon") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 73);
                     ("end", `Int 77);
                     ("exact", `String "noon");
                     ( "prefix",
                       `String
                         "westward the surveyors walked by the old canal that \
                          morning and at " );
                     ( "suffix",
                       `String
                         " they sat down on the towpath wall to eat and later \
                          turned eastward" );
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a closing brace and a less-than sign are boundaries: 64 \
               characters back lands inside `westward` and the prefix is \
               lengthened back to the mark before it, not through it to \
               `north`; 64 on lands inside `eastward` and the suffix is \
               lengthened to the mark after it, not through it to `south`";
            text =
              "north}westward the surveyors walked by the old canal that \
               morning and at noon they sat down on the towpath wall to eat \
               and later turned eastward<south";
            quoted = `Assoc [ ("exact", `String "noon") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 73);
                     ("end", `Int 77);
                     ("exact", `String "noon");
                     ( "prefix",
                       `String
                         "westward the surveyors walked by the old canal that \
                          morning and at " );
                     ( "suffix",
                       `String
                         " they sat down on the towpath wall to eat and later \
                          turned eastward" );
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a greater-than sign and a backslash are boundaries: 64 \
               characters back lands inside `westward` and the prefix is \
               lengthened back to the mark before it, not through it to \
               `north`; 64 on lands inside `eastward` and the suffix is \
               lengthened to the mark after it, not through it to `south`";
            text =
              "north>westward the surveyors walked by the old canal that \
               morning and at noon they sat down on the towpath wall to eat \
               and later turned eastward\\south";
            quoted = `Assoc [ ("exact", `String "noon") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 73);
                     ("end", `Int 77);
                     ("exact", `String "noon");
                     ( "prefix",
                       `String
                         "westward the surveyors walked by the old canal that \
                          morning and at " );
                     ( "suffix",
                       `String
                         " they sat down on the towpath wall to eat and later \
                          turned eastward" );
                     ("anchorMethod", `String "unique-match");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a prefix is trimmed too before it is looked for among the \
               characters before a place: given with a line break after it \
               that the text does not have there, it is among the 32 before \
               the second place once trimmed, and that fits";
            text =
              "Paris is very large today. It was Roman, they say, Paris. And \
               then again Paris is old.";
            quoted =
              `Assoc
                [
                  ("exact", `String "Paris"); ("prefix", `String "was Roman\n");
                ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 51);
                     ("end", `Int 56);
                     ("exact", `String "Paris");
                     ( "prefix",
                       `String
                         "Paris is very large today. It was Roman, they say, "
                     );
                     ("suffix", `String ". And then again Paris is old.");
                     ("anchorMethod", `String "context-recovered");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the quote is lower-cased as the text is: the model wrote the \
               words in capitals, and they are found without regard to case";
            text = "The United States Congress passed the bill yesterday.";
            quoted = `Assoc [ ("exact", `String "UNITED STATES") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 4);
                     ("end", `Int 17);
                     ("exact", `String "United States");
                     ("prefix", `String "The ");
                     ("suffix", `String " Congress passed the bill yesterday.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a no-break space (U+00A0) is white space: the text has one \
               where the model wrote a space, twice, and the quote that is \
               kept is the text's";
            text = "It cost 10\194\160000\194\160francs then.";
            quoted = `Assoc [ ("exact", `String "10 000 francs") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 8);
                     ("end", `Int 21);
                     ("exact", `String "10\194\160000\194\160francs");
                     ("prefix", `String "It cost ");
                     ("suffix", `String " then.");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a line separator (U+2028) is white space: the text has one \
               where the model wrote a space";
            text = "The first line\226\128\168and the second.";
            quoted = `Assoc [ ("exact", `String "first line and the second") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 4);
                     ("end", `Int 29);
                     ("exact", `String "first line\226\128\168and the second");
                     ("prefix", `String "The ");
                     ("suffix", `String ".");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "normalized");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a capital sigma ends a word when a cased letter is before it \
               and none after it, past what is case-ignorable, as Unicode's \
               Case_Ignorable property has it, which is more than marks and \
               apostrophes: a full stop is case-ignorable, so this sigma, with \
               a capital beta beyond the full stop, does not end a word, and \
               lower-cases to the sigma that is not final, which the model \
               wrote";
            text = "\206\145\206\163.\206\146";
            quoted = `Assoc [ ("exact", `String "\206\177\207\131.\206\178") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 4);
                     ("exact", `String "\206\145\206\163.\206\146");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a colon is case-ignorable too: the capital sigma, with a \
               capital beta beyond the colon, does not end a word, and \
               lower-cases to the sigma that is not final";
            text = "\206\145\206\163:\206\146";
            quoted = `Assoc [ ("exact", `String "\206\177\207\131:\206\178") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 4);
                     ("exact", `String "\206\145\206\163:\206\146");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a middle dot (U+00B7) is case-ignorable too: the capital sigma, \
               with a capital beta beyond the dot, does not end a word, and \
               lower-cases to the sigma that is not final";
            text = "\206\145\206\163\194\183\206\146";
            quoted =
              `Assoc [ ("exact", `String "\206\177\207\131\194\183\206\178") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 4);
                     ("exact", `String "\206\145\206\163\194\183\206\146");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a left single quotation mark (U+2018) is case-ignorable too, \
               and the case-insensitive search lower-cases the text as it is, \
               not the apostrophe the normalized search makes of the mark: the \
               capital sigma, with a capital beta beyond the mark, does not \
               end a word, and lower-cases to the sigma that is not final";
            text = "\206\145\206\163\226\128\152\206\146";
            quoted =
              `Assoc
                [ ("exact", `String "\206\177\207\131\226\128\152\206\178") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 4);
                     ("exact", `String "\206\145\206\163\226\128\152\206\146");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a character is cased as Unicode's Cased property has it, not \
               only when it is a capital, small or title-case letter: the \
               feminine ordinal indicator (U+00AA), which is none of those, is \
               cased, so the capital sigma after it ends a word, and \
               lower-cases to the final sigma, which the model wrote";
            text = "\194\170\206\163";
            quoted = `Assoc [ ("exact", `String "\194\170\207\130") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 2);
                     ("exact", `String "\194\170\206\163");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a circled capital A (U+24B6), a symbol, is cased too, and \
               lower-cases to the circled small a (U+24D0): the capital sigma \
               after it ends a word, and lower-cases to the final sigma";
            text = "\226\146\182\206\163";
            quoted = `Assoc [ ("exact", `String "\226\147\144\207\130") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 2);
                     ("exact", `String "\226\146\182\206\163");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "the Roman numeral one (U+2160), a number, is cased too, and \
               lower-cases to the small Roman numeral one (U+2170): the \
               capital sigma after it ends a word, and lower-cases to the \
               final sigma";
            text = "\226\133\160\206\163";
            quoted = `Assoc [ ("exact", `String "\226\133\176\207\130") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 2);
                     ("exact", `String "\226\133\160\206\163");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "a character that is both cased and case-ignorable is \
               case-ignorable first, as Unicode's rule has it (the Standard, \
               3.13: its repetition takes as many as it can, with no backup): \
               the modifier letter small h (U+02B0) is both, so the capital \
               sigma after it has no cased letter before it once the \
               case-ignorable are passed, does not end a word, and lower-cases \
               to the sigma that is not final, which the model wrote";
            text = "\202\176\206\163";
            quoted = `Assoc [ ("exact", `String "\202\176\207\131") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 2);
                     ("exact", `String "\202\176\206\163");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
         ({
            why =
              "after a capital sigma too, a character that is both cased and \
               case-ignorable is case-ignorable first: the modifier letter \
               small h (U+02B0) after this sigma is passed over, no cased \
               letter is beyond it, and the sigma, with a capital alpha before \
               it, ends a word and lower-cases to the final sigma";
            text = "\206\145\206\163\202\176";
            quoted = `Assoc [ ("exact", `String "\206\177\207\130\202\176") ];
            reconciled =
              Some
                (`Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 3);
                     ("exact", `String "\206\145\206\163\202\176");
                     ("anchorMethod", `String "fuzzy-match");
                     ("matchQuality", `String "case-insensitive");
                   ]);
          }
           : cases_item);
       ];
   }
    : t)
