(* Generated from protocol/specs/src/text/offset-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type spans_item = { exact : string; occurrence : int; start : int; end_ : int }

let spans_item_json (r : spans_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("exact", (fun s -> `String s) r.exact);
         Option.Some ("occurrence", (fun n -> `Int n) r.occurrence);
         Option.Some ("start", (fun n -> `Int n) r.start);
         Option.Some ("end", (fun n -> `Int n) r.end_);
       ])

type cases_item = {
  why : string;
  text : string;
  code_points : int;
  spans : spans_item list;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("text", (fun s -> `String s) r.text);
         Option.Some ("codePoints", (fun n -> `Int n) r.code_points);
         Option.Some
           ("spans", (fun l -> `List (List.map spans_item_json l)) r.spans);
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
       "What a text offset counts: Unicode code points from the start of the \
        text, on the wire, in the record and in every store. A case is a text \
        and some spans of it. `codePoints` is how many code points the text \
        is: an offset may equal it and may not exceed it. A span is named by \
        its words, `exact`, and by which occurrence of them it is \
        (`occurrence`, 1 for the first); `start` and `end` are the offsets it \
        must be given, which are the number of code points before its first \
        and before the one after its last. An implementation runs every span \
        both ways. It finds the span by its own search, in its own string's \
        count, converts where it found it to offsets, and must get `start` and \
        `end`. And it takes `start` and `end`, converts them to its own \
        string's count, and the text there must be `exact`. Its texts have \
        characters outside the Basic Multilingual Plane, because they are what \
        tell the counts apart: a string indexed in UTF-16 code units \
        (JavaScript, Java, C#) counts each of them as two, and one indexed in \
        UTF-8 bytes as four. A combining mark and a joiner are each a code \
        point of their own, so what a reader sees as one character can be \
        several. Every implementation that makes or applies an offset runs it, \
        in whatever language it is written, through what makes and applies its \
        offsets: a conversion they all go through, or its annotation builders.";
     cases =
       [
         ({
            why =
              "a text of the basic plane: every count agrees, and the offset \
               is the position";
            text = "The quick brown fox";
            code_points = 19;
            spans =
              [
                ({ exact = "The"; occurrence = 1; start = 0; end_ = 3 }
                  : spans_item);
                ({ exact = "quick"; occurrence = 1; start = 4; end_ = 9 }
                  : spans_item);
                ({ exact = "fox"; occurrence = 1; start = 16; end_ = 19 }
                  : spans_item);
              ];
          }
           : cases_item);
         ({
            why =
              "one character outside the basic plane is one code point: what \
               follows it is one further on, not two";
            text = "a\240\159\152\128b";
            code_points = 3;
            spans =
              [
                ({ exact = "a"; occurrence = 1; start = 0; end_ = 1 }
                  : spans_item);
                ({
                   exact = "\240\159\152\128";
                   occurrence = 1;
                   start = 1;
                   end_ = 2;
                 }
                  : spans_item);
                ({ exact = "b"; occurrence = 1; start = 2; end_ = 3 }
                  : spans_item);
              ];
          }
           : cases_item);
         ({
            why =
              "a span long after such a character: every offset after it is \
               counted the same way";
            text = "\240\159\152\128 first, then words";
            code_points = 19;
            spans =
              [
                ({ exact = "first"; occurrence = 1; start = 2; end_ = 7 }
                  : spans_item);
                ({ exact = "words"; occurrence = 1; start = 14; end_ = 19 }
                  : spans_item);
              ];
          }
           : cases_item);
         ({
            why =
              "a span that holds such a character: it adds one to the span's \
               length, and a span may begin or end on it";
            text = "let \240\157\145\165 be";
            code_points = 8;
            spans =
              [
                ({
                   exact = "let \240\157\145\165";
                   occurrence = 1;
                   start = 0;
                   end_ = 5;
                 }
                  : spans_item);
                ({
                   exact = "\240\157\145\165 be";
                   occurrence = 1;
                   start = 4;
                   end_ = 8;
                 }
                  : spans_item);
                ({
                   exact = "\240\157\145\165";
                   occurrence = 1;
                   start = 4;
                   end_ = 5;
                 }
                  : spans_item);
              ];
          }
           : cases_item);
         ({
            why =
              "several such characters, among characters of the basic plane \
               that are not Latin: each is one, wherever it is";
            text =
              "\240\160\174\183\233\135\142\229\174\182 \227\129\168 \
               \240\160\174\183\231\148\176";
            code_points = 8;
            spans =
              [
                ({
                   exact = "\240\160\174\183";
                   occurrence = 1;
                   start = 0;
                   end_ = 1;
                 }
                  : spans_item);
                ({
                   exact = "\233\135\142\229\174\182";
                   occurrence = 1;
                   start = 1;
                   end_ = 3;
                 }
                  : spans_item);
                ({
                   exact = "\240\160\174\183";
                   occurrence = 2;
                   start = 6;
                   end_ = 7;
                 }
                  : spans_item);
                ({ exact = "\231\148\176"; occurrence = 1; start = 7; end_ = 8 }
                  : spans_item);
              ];
          }
           : cases_item);
         ({
            why =
              "a combining mark is a code point of its own, in the basic \
               plane: the accented letter here is two";
            text = "cafe\204\129 au lait";
            code_points = 13;
            spans =
              [
                ({ exact = "cafe\204\129"; occurrence = 1; start = 0; end_ = 5 }
                  : spans_item);
                ({ exact = "au"; occurrence = 1; start = 6; end_ = 8 }
                  : spans_item);
                ({ exact = "lait"; occurrence = 1; start = 9; end_ = 13 }
                  : spans_item);
              ];
          }
           : cases_item);
         ({
            why =
              "a joined sequence a reader sees as one picture is five code \
               points: three people and two joiners";
            text =
              "\240\159\145\169\226\128\141\240\159\145\169\226\128\141\240\159\145\167 \
               family";
            code_points = 12;
            spans =
              [
                ({
                   exact =
                     "\240\159\145\169\226\128\141\240\159\145\169\226\128\141\240\159\145\167";
                   occurrence = 1;
                   start = 0;
                   end_ = 5;
                 }
                  : spans_item);
                ({ exact = "family"; occurrence = 1; start = 6; end_ = 12 }
                  : spans_item);
              ];
          }
           : cases_item);
         ({
            why = "a flag is two code points, each outside the basic plane";
            text = "\240\159\135\171\240\159\135\183 Paris";
            code_points = 8;
            spans =
              [
                ({
                   exact = "\240\159\135\171\240\159\135\183";
                   occurrence = 1;
                   start = 0;
                   end_ = 2;
                 }
                  : spans_item);
                ({ exact = "Paris"; occurrence = 1; start = 3; end_ = 8 }
                  : spans_item);
              ];
          }
           : cases_item);
         ({
            why =
              "a span that ends the text ends at the text's count of code \
               points";
            text = "end \240\159\153\130";
            code_points = 5;
            spans =
              [
                ({
                   exact = "\240\159\153\130";
                   occurrence = 1;
                   start = 4;
                   end_ = 5;
                 }
                  : spans_item);
              ];
          }
           : cases_item);
         ({
            why =
              "the same words twice, with such a character between: the second \
               occurrence is counted past it";
            text = "ab \240\159\142\137 ab";
            code_points = 7;
            spans =
              [
                ({ exact = "ab"; occurrence = 1; start = 0; end_ = 2 }
                  : spans_item);
                ({ exact = "ab"; occurrence = 2; start = 5; end_ = 7 }
                  : spans_item);
              ];
          }
           : cases_item);
       ];
   }
    : t)
