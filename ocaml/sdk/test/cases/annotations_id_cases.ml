(* Generated from protocol/specs/src/annotations/id-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type motivation = Assessing | Commenting | Highlighting | Linking | Tagging

let motivation_value = function
  | (Assessing : motivation) -> "assessing"
  | (Commenting : motivation) -> "commenting"
  | (Highlighting : motivation) -> "highlighting"
  | (Linking : motivation) -> "linking"
  | (Tagging : motivation) -> "tagging"

let motivation_json v = `String (motivation_value v)

type cases_item = {
  why : string;
  resource_id : string;
  motivation : motivation;
  anchor : string;
  body : Yojson.Safe.t option;
  id : string;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("resourceId", (fun s -> `String s) r.resource_id);
         Option.Some ("motivation", motivation_json r.motivation);
         Option.Some ("anchor", (fun s -> `String s) r.anchor);
         Option.map (fun v -> ("body", Fun.id v)) r.body;
         Option.Some ("id", (fun s -> `String s) r.id);
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
       "The id of an annotation a worker makes, as every implementation must \
        derive it. The id is not minted: it is worked out from what the \
        annotation is, so a worker that makes the same annotation again (a job \
        retried, a unit resumed, another worker taking the job over) gives it \
        the same id, and writing it a second time changes nothing. Two workers \
        that derive it differently write every annotation twice. The rule is \
        the annotation builders' own (builder-cases.json): `annotationOfSpan` \
        and `annotationOfResource` derive the id of what they build, and no \
        SDK exports a function for it. Each SDK runs every case against the \
        derivation its builders use, and fails on a difference. READING A \
        CASE. `resourceId`, `motivation`, `anchor` and, when the annotation \
        has one, `body` are what the annotation is, and `id` is its id. The \
        `anchor` is a string saying where on the resource the annotation is; \
        how a builder makes one is stated in builder-cases.json (the offsets \
        in it count Unicode code points), and here it is taken as given. An \
        annotation of a resource as a whole is nowhere on it, and its anchor \
        is the empty string. Nothing else goes into an id: not when the \
        annotation was made, not what made it, not the job it was made for. \
        THE RULE. Write what the annotation is as one JSON object with the \
        members `anchor`, `body`, `motivation` and `resourceId`, `body` being \
        left out when the annotation has none, in this canonical form. There \
        is no white space between tokens. An object is its members in the \
        order of their names by code point (so `@` before the capital letters, \
        and those before the small ones), at every depth, each member its \
        name, a colon and its value, with commas between members. An array is \
        its items in the order they have, with commas between. `true`, `false` \
        and `null` are those words, and a whole number is its decimal digits, \
        with a minus sign before them if it is below zero. A string is written \
        between double quotes, and inside them a double quote is written \\\" \
        and a backslash \\\\; the characters U+0008, U+0009, U+000A, U+000C \
        and U+000D are written \\b, \\t, \\n, \\f and \\r; every other \
        character below U+0020 is written \\u and its four hexadecimal digits, \
        the letters of them in lower case; and every other character is \
        written as itself: a slash is not escaped, U+007F is not, and no \
        character outside ASCII is. Take the SHA-256 of that text's UTF-8 \
        bytes, write its 32 bytes in base64url (RFC 4648 section 5, where the \
        last two digits are `-` and `_`), and the id is the first 21 \
        characters of that. WORKED: the canonical text of the first case is \
        {\"anchor\":\"0:12:Ada \
        Lovelace\",\"motivation\":\"highlighting\",\"resourceId\":\"res-1\"} \
        and the base64url of its SHA-256 is \
        8yQdnrBndVZasyRD7ORRXpeXVjZd6Y8rxRKmTzfUhSg, of which the id is the \
        first 21 characters. The bodies an annotation has carry no number that \
        is not whole, and no case states one. The order of names by code point \
        is also their order by UTF-8 byte, and it is not their order by UTF-16 \
        code unit: a name with a character outside the Basic Multilingual \
        Plane comes after one with a character from U+E000 to U+FFFF, where a \
        comparison of UTF-16 units puts it before, and one case has two such \
        names. A character outside that plane, which two cases have in a \
        value, is one character: written as itself, and four bytes of UTF-8. \
        Add a case here before changing an implementation.";
     cases =
       [
         ({
            why =
              "an annotation with no body, a highlight: three members go into \
               its id";
            resource_id = "res-1";
            motivation = (Highlighting : motivation);
            anchor = "0:12:Ada Lovelace";
            body = None;
            id = "8yQdnrBndVZasyRD7ORRX";
          }
           : cases_item);
         ({
            why =
              "an annotation with a body, a comment: the body goes in whole, \
               its members ordered by name (format, purpose, type, value)";
            resource_id = "res-1";
            motivation = (Commenting : motivation);
            anchor = "0:12:Ada Lovelace";
            body =
              Some
                (`List
                   [
                     `Assoc
                       [
                         ("type", `String "TextualBody");
                         ("value", `String "an author");
                         ("purpose", `String "commenting");
                         ("format", `String "text/plain");
                       ];
                   ]);
            id = "oQDVZSYutxZJn11upX1Bi";
          }
           : cases_item);
         ({
            why =
              "the same body with its members written in another order is the \
               same annotation, and has the same id";
            resource_id = "res-1";
            motivation = (Commenting : motivation);
            anchor = "0:12:Ada Lovelace";
            body =
              Some
                (`List
                   [
                     `Assoc
                       [
                         ("format", `String "text/plain");
                         ("value", `String "an author");
                         ("type", `String "TextualBody");
                         ("purpose", `String "commenting");
                       ];
                   ]);
            id = "oQDVZSYutxZJn11upX1Bi";
          }
           : cases_item);
         ({
            why =
              "another comment on the same span is another annotation: they \
               differ by their bodies alone";
            resource_id = "res-1";
            motivation = (Commenting : motivation);
            anchor = "0:12:Ada Lovelace";
            body =
              Some
                (`List
                   [
                     `Assoc
                       [
                         ("type", `String "TextualBody");
                         ("value", `String "a mathematician");
                         ("purpose", `String "commenting");
                         ("format", `String "text/plain");
                       ];
                   ]);
            id = "UJ1Yz_vXoqeLLcMgNezg2";
          }
           : cases_item);
         ({
            why =
              "the same span and the same body under another motivation are \
               another annotation";
            resource_id = "res-1";
            motivation = (Assessing : motivation);
            anchor = "0:12:Ada Lovelace";
            body =
              Some
                (`List
                   [
                     `Assoc
                       [
                         ("type", `String "TextualBody");
                         ("value", `String "an author");
                         ("purpose", `String "commenting");
                         ("format", `String "text/plain");
                       ];
                   ]);
            id = "uOJciMhD-aOC3rbDvwF1y";
          }
           : cases_item);
         ({
            why = "the same span of another resource is another annotation";
            resource_id = "res-2";
            motivation = (Highlighting : motivation);
            anchor = "0:12:Ada Lovelace";
            body = None;
            id = "BkQwb1GB6qRjTRR5u6Ctr";
          }
           : cases_item);
         ({
            why =
              "another span of the same resource is another annotation; and an \
               id may begin with `-`, the base64url digit that plain base64 \
               writes `+`";
            resource_id = "res-1";
            motivation = (Highlighting : motivation);
            anchor = "13:18:wrote";
            body = None;
            id = "-w7fftCFfzxXMMlUsSu4A";
          }
           : cases_item);
         ({
            why =
              "the same offsets over other words are another annotation: the \
               words are in the anchor, so a resource whose text has changed \
               does not keep the id";
            resource_id = "res-1";
            motivation = (Highlighting : motivation);
            anchor = "0:12:Grace Hopper";
            body = None;
            id = "7TqAQYZUPZZ1QxanaAQko";
          }
           : cases_item);
         ({
            why =
              "a body that is one object, a link to another resource; and an \
               id may end with `_`, the base64url digit that plain base64 \
               writes `/`";
            resource_id = "res-1";
            motivation = (Linking : motivation);
            anchor = "0:12:Ada Lovelace";
            body =
              Some
                (`Assoc
                   [
                     ("type", `String "SpecificResource");
                     ("source", `String "res-2");
                     ("purpose", `String "linking");
                   ]);
            id = "UT5aqFrOu4jBoarVpgXH_";
          }
           : cases_item);
         ({
            why =
              "the same body as a list of one is not the same: a list is \
               written as a list";
            resource_id = "res-1";
            motivation = (Linking : motivation);
            anchor = "0:12:Ada Lovelace";
            body =
              Some
                (`List
                   [
                     `Assoc
                       [
                         ("type", `String "SpecificResource");
                         ("source", `String "res-2");
                         ("purpose", `String "linking");
                       ];
                   ]);
            id = "sVEMYHBABNhlSkCzr2RAi";
          }
           : cases_item);
         ({
            why =
              "a tag's two bodies, its category and its schema, in the order \
               they have";
            resource_id = "res-1";
            motivation = (Tagging : motivation);
            anchor = "0:12:Ada Lovelace";
            body =
              Some
                (`List
                   [
                     `Assoc
                       [
                         ("type", `String "TextualBody");
                         ("value", `String "Person");
                         ("purpose", `String "tagging");
                       ];
                     `Assoc
                       [
                         ("type", `String "TextualBody");
                         ("value", `String "people-v1");
                         ("purpose", `String "classifying");
                       ];
                   ]);
            id = "UbT9OcbClBRLtrEK6ToM-";
          }
           : cases_item);
         ({
            why =
              "the order of a list is kept, unlike the order of an object's \
               members: the same two bodies the other way round have another \
               id";
            resource_id = "res-1";
            motivation = (Tagging : motivation);
            anchor = "0:12:Ada Lovelace";
            body =
              Some
                (`List
                   [
                     `Assoc
                       [
                         ("type", `String "TextualBody");
                         ("value", `String "people-v1");
                         ("purpose", `String "classifying");
                       ];
                     `Assoc
                       [
                         ("type", `String "TextualBody");
                         ("value", `String "Person");
                         ("purpose", `String "tagging");
                       ];
                   ]);
            id = "wcLvHzEjwN5OI5PRriWGe";
          }
           : cases_item);
         ({
            why =
              "what is escaped in a string and what is not: the double quotes, \
               the backslash, the line break and the tab are; U+0001 and \
               U+001F are, as \\u0001 and \\u001f; the slash and U+007F are \
               written as themselves";
            resource_id = "res-1";
            motivation = (Highlighting : motivation);
            anchor = "4:24:say \"a\\b\"\n\tor/not\001\031\127";
            body = None;
            id = "QQ0pHyP1zF61DaG1WgyWj";
          }
           : cases_item);
         ({
            why =
              "the other three characters with a short escape: backspace, form \
               feed and carriage return";
            resource_id = "res-1";
            motivation = (Highlighting : motivation);
            anchor = "0:3:\b\012\r";
            body = None;
            id = "vDpJvbu91ekm2YqnKHewI";
          }
           : cases_item);
         ({
            why =
              "characters outside ASCII are written as themselves and hashed \
               as their UTF-8 bytes, never as \\u escapes: an accented letter, \
               two ideographs, an em dash and curly quotation marks";
            resource_id = "res-1";
            motivation = (Commenting : motivation);
            anchor = "0:4:caf\195\169";
            body =
              Some
                (`List
                   [
                     `Assoc
                       [
                         ("type", `String "TextualBody");
                         ( "value",
                           `String
                             "\228\184\150\231\149\140 \226\128\148 \
                              \226\128\156monde\226\128\157" );
                       ];
                   ]);
            id = "x34YfjqVWVhx71aGiu9te";
          }
           : cases_item);
         ({
            why =
              "a body is any JSON, and the form holds at every depth: names \
               are ordered by code point (`@language`, `Value`, `detail`, \
               `type`, `value`), an object inside an object is ordered too \
               (`a` before `b`), and a number, `true`, `false` and `null` are \
               written as JSON writes them";
            resource_id = "res-1";
            motivation = (Commenting : motivation);
            anchor = "0:12:Ada Lovelace";
            body =
              Some
                (`Assoc
                   [
                     ("type", `String "TextualBody");
                     ("value", `String "seven");
                     ( "detail",
                       `Assoc
                         [
                           ("b", `Int (-1));
                           ("a", `List [ `Bool true; `Null; `Bool false ]);
                         ] );
                     ("Value", `Int 7);
                     ("@language", `String "en");
                   ]);
            id = "tRarqce6wzogJIm2zALL7";
          }
           : cases_item);
         ({
            why =
              "a span after a character outside the Basic Multilingual Plane: \
               the offsets in its anchor count code points (2 and 14, where a \
               count of UTF-16 code units would say 3 and 15), and a worker \
               that counts otherwise gives the annotation another id";
            resource_id = "res-1";
            motivation = (Highlighting : motivation);
            anchor = "2:14:Ada Lovelace";
            body = None;
            id = "KxmaWULQ3qhFn7N21Bk5r";
          }
           : cases_item);
         ({
            why =
              "a character outside the plane is one character, written as \
               itself and hashed as its four UTF-8 bytes, never as two \\u \
               escapes: two mathematical letters in the anchor and an emoji in \
               the body";
            resource_id = "res-1";
            motivation = (Commenting : motivation);
            anchor = "7:9:\240\157\145\165\240\157\145\166";
            body =
              Some
                (`List
                   [
                     `Assoc
                       [
                         ("type", `String "TextualBody");
                         ("value", `String "a product \240\159\142\137");
                         ("purpose", `String "commenting");
                         ("format", `String "text/plain");
                       ];
                   ]);
            id = "EC6ecBvKDj4WZEcB_2k2z";
          }
           : cases_item);
         ({
            why =
              "an annotation of a resource as a whole, the link from a \
               resource to one generated from it: its anchor is the empty \
               string, written as two double quotes, and it is a member like \
               any other";
            resource_id = "res-1";
            motivation = (Linking : motivation);
            anchor = "";
            body =
              Some
                (`Assoc
                   [
                     ("type", `String "SpecificResource");
                     ("source", `String "res-2");
                     ("purpose", `String "linking");
                   ]);
            id = "xdaSX40cMJa46S2JHwFtC";
          }
           : cases_item);
         ({
            why =
              "names are ordered by code point, not by UTF-16 code unit: the \
               fullwidth `\239\189\154` (U+FF5A) comes before the emoji \
               (U+1F600), whose first UTF-16 unit, D83D, is the lesser; \
               ordered by unit the id would be 2VS31GK5k_0lv4Pz-ei7o";
            resource_id = "res-1";
            motivation = (Commenting : motivation);
            anchor = "0:12:Ada Lovelace";
            body =
              Some
                (`Assoc
                   [
                     ("type", `String "TextualBody");
                     ("value", `String "an author");
                     ("\240\159\152\128", `Int 1);
                     ("\239\189\154", `Int 2);
                   ]);
            id = "ezkXvdosD9657eaaCQKLh";
          }
           : cases_item);
       ];
   }
    : t)
