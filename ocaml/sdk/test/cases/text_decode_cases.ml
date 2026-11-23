(* Generated from protocol/specs/src/text/decode-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type text = {
  why : string;
  content_type : string;
  bytes : string;
  text : string;
}

let text_json (r : text) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("contentType", (fun s -> `String s) r.content_type);
         Option.Some ("bytes", (fun s -> `String s) r.bytes);
         Option.Some ("text", (fun s -> `String s) r.text);
       ])

type refused = {
  why : string;
  content_type : string;
  bytes : string;
  refused : string;
}

let refused_json (r : refused) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("contentType", (fun s -> `String s) r.content_type);
         Option.Some ("bytes", (fun s -> `String s) r.bytes);
         Option.Some ("refused", (fun s -> `String s) r.refused);
       ])

type cases_item = Text of text | Refused of refused

let cases_item_json = function
  | (Text v : cases_item) -> text_json v
  | (Refused v : cases_item) -> refused_json v

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
       "What text a resource's bytes are, as every reader of one must read \
        them: the cases of the rule contract/W3C-SELECTORS.md states of a \
        resource's text, which is the MIME Sniffing Standard's reading of a \
        content type and the Encoding Standard's reading of the bytes, as a \
        browser follows the two. An offset counts the code points of this text \
        (offset-cases.json), so two readers that make different texts of the \
        same bytes put one annotation in two places. THE RULE, IN SHORT; the \
        document has it whole. (1) The charset is the content type's `charset` \
        parameter as the MIME Sniffing Standard parses a MIME type: the name \
        whole and in any case, the first of several, a quoted value's content. \
        A parameter with no value is no parameter, and a content type that is \
        no MIME type has none. No charset, or an empty one, is UTF-8. (2) The \
        charset is a label of the Encoding Standard, in any case and with \
        ASCII white space around it dropped. Anything else is refused, and so \
        is a label of the standard's `replacement` encoding or of one of its \
        seven legacy multi-byte encodings (Big5, EUC-JP, EUC-KR, gb18030, GBK, \
        ISO-2022-JP, Shift_JIS), whose bytes each platform's own decoder reads \
        otherwise than the standard and than the others: the refusal names the \
        label, and is made whatever the bytes are. (3) Bytes that begin with \
        the byte-order mark of UTF-8 (EF BB BF), of UTF-16BE (FE FF) or of \
        UTF-16LE (FF FE) are in that encoding, whatever charset was stated, \
        and the mark is not part of the text. A mark anywhere else is U+FEFF, \
        a character like any other. (4) The bytes are decoded by the \
        standard's decoder for the encoding: what the encoding does not have \
        is U+FFFD, as many as that decoder emits and no more. (5) A refusal is \
        the reader's own failure, of the kind its other failures are. (6) Only \
        a media type whose bytes are its text is read. The media type is the \
        content type without its parameters, in lower case. One the media-type \
        registry lists (specs/src/media-types/registry.json) is read where its \
        `textSource` there is `decode`, and one the registry does not list is \
        read where it is a `text/` type. Any other is refused, before its \
        charset is read and whatever its bytes are: a type whose text is \
        derived from its bytes (a PDF), and a type with no text (an image). \
        The refusal names the media type. A CASE is the `contentType` the \
        bytes came with, the `bytes` in hexadecimal, two digits to a byte and \
        a space between bytes, and either the `text` they are or `refused`, \
        what the refusal names: the label of a charset that is refused, or a \
        media type whose bytes are not its text. In this file a control \
        character, U+FEFF, U+FFFD and a private-use character are written as \
        escapes, so that each can be seen. THE OTHER TABLE. \
        encoding-cases.json, beside this one, is generated: it holds every \
        label of the standard and every byte of each of its single-byte \
        encodings. This one holds what is said of a content type, of a label, \
        of a mark, of malformed UTF-8 and UTF-16, and of a media type whose \
        text is not its bytes. NOT HELD. Which of the encodings the rule reads \
        a reader decodes: it may decode fewer, and refuses what it does not \
        decode by name, so an SDK may be built to decode UTF-8 alone. HOW IT \
        IS RUN. Every SDK runs every case through what its client reads a \
        resource's content with, by which a worker reads the text it counts \
        offsets in: it keeps (6), and then reads by (1) to (5). A reader of \
        UTF-8 alone reads each case as it is here or refuses it. A reader in \
        another language runs them too. Add a case here before changing a \
        reader.";
     cases =
       [
         (Text
            ({
               why =
                 "no charset is stated: the bytes are UTF-8, and a character \
                  outside the basic plane is one character";
               content_type = "text/plain";
               bytes = "63 61 66 c3 a9 20 f0 9f 98 80";
               text = "caf\195\169 \240\159\152\128";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "a charset is read in any case";
               content_type = "text/markdown; charset=UTF-8";
               bytes = "6e 61 c3 af 76 65";
               text = "na\195\175ve";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "the parameter needs no space before it";
               content_type = "text/plain;charset=latin1";
               bytes = "80 20 35";
               text = "\226\130\172 5";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "the parameter's name is read in any case, and other \
                  parameters may follow it";
               content_type = "text/html; Charset=ISO-8859-1; boundary=x";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "other parameters may come before it";
               content_type = "text/plain; format=flowed; charset=iso-8859-1";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "white space after the semicolon is not part of the name, and \
                  a tab and a line feed are white space";
               content_type = "text/plain;\t\n charset=iso-8859-1";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "white space around the whole content type is not part of it";
               content_type = "  text/plain; charset=iso-8859-1 \t";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "white space after the subtype is not part of it";
               content_type = "text/plain ; charset=iso-8859-1";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "a quoted value is what is between the quotation marks";
               content_type = "text/plain; charset=\"iso-8859-1\"";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "in a quoted value a backslash gives the character after it";
               content_type = "text/plain; charset=\"iso-8859-\\1\"";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "a quoted value that is never closed runs to the end";
               content_type = "text/plain; charset=\"iso-8859-1";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "what follows a quoted value, up to the next semicolon, is \
                  not read";
               content_type =
                 "text/plain; charset=\"iso-8859-1\"junk; format=flowed";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "white space between the equals sign and an unquoted value, \
                  and after the value, is dropped with the label";
               content_type = "text/plain; charset= iso-8859-1 ; format=flowed";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "white space within the quotation marks is dropped with the \
                  label";
               content_type = "text/plain; charset=\" iso-8859-1\t\"";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "white space before the equals sign is part of the name, \
                  which is then not charset: none is stated";
               content_type = "text/plain; charset =iso-8859-1";
               bytes = "e9";
               text = "\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "a name that only ends in charset is another parameter";
               content_type = "text/plain; xcharset=iso-8859-1";
               bytes = "e9";
               text = "\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "and so is a name that only begins with it";
               content_type = "text/plain; charsets=iso-8859-1";
               bytes = "e9";
               text = "\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "of two charsets the first is the one stated";
               content_type = "text/plain; charset=iso-8859-1; charset=utf-8";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "of two charsets the first is the one stated, the other way \
                  round";
               content_type = "text/plain; charset=utf-8; charset=iso-8859-1";
               bytes = "e9";
               text = "\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "a charset with nothing after its equals sign is no \
                  parameter: none is stated";
               content_type = "text/plain; charset=";
               bytes = "c3 a9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "a charset with nothing after its equals sign is no \
                  parameter: of two, the next is the one stated";
               content_type = "text/plain; charset=; charset=iso-8859-1";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "a charset with no equals sign is no parameter either";
               content_type = "text/plain; charset; charset=iso-8859-1";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "a value with a character a parameter's value cannot have is \
                  no parameter: the next charset is the one stated";
               content_type =
                 "text/plain; charset=\197\171tf-8; charset=iso-8859-1";
               bytes = "e9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "an empty quoted value is a charset that states none: UTF-8";
               content_type = "text/plain; charset=\"\"";
               bytes = "c3 a9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "an empty quoted value is a parameter, and so the first of \
                  two: none is stated";
               content_type = "text/plain; charset=\"\"; charset=iso-8859-1";
               bytes = "e9";
               text = "\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "a content type with no subtype is no MIME type, and states \
                  nothing";
               content_type = "text/; charset=iso-8859-1";
               bytes = "e9";
               text = "\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "nor is one whose subtype has a space in it";
               content_type = "text/pl ain; charset=iso-8859-1";
               bytes = "e9";
               text = "\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "iso-8859-1 is a label of windows-1252: 93 and 94 are \
                  quotation marks, not controls";
               content_type = "text/plain; charset=iso-8859-1";
               bytes = "63 61 66 e9 20 93 71 94";
               text = "caf\195\169 \226\128\156q\226\128\157";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "the five bytes windows-1252 gives no character of its own \
                  are the controls of the same number, not U+FFFD";
               content_type = "text/plain; charset=windows-1252";
               bytes = "81 8d 8f 90 9d";
               text = "\194\129\194\141\194\143\194\144\194\157";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "iso-8859-9 is a label of windows-1254";
               content_type = "text/plain; charset=iso-8859-9";
               bytes = "80 d0";
               text = "\226\130\172\196\158";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "utf-16 is a label of UTF-16LE";
               content_type = "text/plain; charset=utf-16";
               bytes = "68 00 69 00";
               text = "hi";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "unicode is a label of UTF-16LE";
               content_type = "text/plain; charset=unicode";
               bytes = "e9 00";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "another charset, stated in capitals: KOI8-R";
               content_type = "text/plain;charset=KOI8-R";
               bytes = "d0 d2 c9 d7 c5 d4";
               text = "\208\191\209\128\208\184\208\178\208\181\209\130";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "x-user-defined: a byte from 80 up is the private-use \
                  character from U+F780 up";
               content_type = "text/plain; charset=x-user-defined";
               bytes = "41 80 ff";
               text = "A\239\158\128\239\159\191";
             }
              : text)
           : cases_item);
         (Refused
            ({
               why =
                 "a charset that is no label of the standard is refused, and \
                  nothing is read as UTF-8 in its place";
               content_type = "text/plain; charset=x-no-such-charset";
               bytes = "68 69";
               refused = "x-no-such-charset";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "it is refused whatever the bytes begin with: a mark does not \
                  decide for a label the standard lacks";
               content_type = "text/plain; charset=x-no-such-charset";
               bytes = "ef bb bf 68 69";
               refused = "x-no-such-charset";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "a label is matched whole: an underscore for a hyphen makes \
                  another name";
               content_type = "text/plain; charset=utf_8";
               bytes = "68 69";
               refused = "utf_8";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why = "latin1 is a label and latin-1 is not";
               content_type = "text/plain; charset=latin-1";
               bytes = "e9";
               refused = "latin-1";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why = "utf-7 is no label of the standard";
               content_type = "text/plain; charset=utf-7";
               bytes = "2b 41 47 67 2d";
               refused = "utf-7";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "utf-32 is no label of the standard, though its bytes begin \
                  as UTF-16LE's mark does";
               content_type = "text/plain; charset=utf-32";
               bytes = "ff fe 00 00 68 00 00 00";
               refused = "utf-32";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why = "cp437 is no label of the standard";
               content_type = "text/plain; charset=cp437";
               bytes = "80";
               refused = "cp437";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why = "utf-8-sig is no label of the standard";
               content_type = "text/plain; charset=utf-8-sig";
               bytes = "ef bb bf 68 69";
               refused = "utf-8-sig";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "a name some library has a codec under, and that is no \
                  charset at all, is refused like any other: hex";
               content_type = "text/plain; charset=hex";
               bytes = "36 38";
               refused = "hex";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why = "and base64";
               content_type = "text/plain; charset=base64";
               bytes = "61 47 6b 3d";
               refused = "base64";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why = "and rot13";
               content_type = "text/plain; charset=rot13";
               bytes = "68 69";
               refused = "rot13";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why = "and unicode_escape";
               content_type = "text/plain; charset=unicode_escape";
               bytes = "5c 75 30 30 34 31";
               refused = "unicode_escape";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "a label of the standard's replacement encoding is refused: \
                  iso-2022-kr";
               content_type = "text/plain; charset=iso-2022-kr";
               bytes = "68 69";
               refused = "iso-2022-kr";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why = "and hz-gb-2312";
               content_type = "text/plain; charset=hz-gb-2312";
               bytes = "68 69";
               refused = "hz-gb-2312";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why = "and replacement itself";
               content_type = "text/plain; charset=replacement";
               bytes = "68 69";
               refused = "replacement";
             }
              : refused)
           : cases_item);
         (Text
            ({
               why = "UTF-8's mark under UTF-8: it is not part of the text";
               content_type = "text/plain; charset=utf-8";
               bytes = "ef bb bf 68 65 6c 6c 6f";
               text = "hello";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-8's mark under no charset";
               content_type = "text/markdown";
               bytes = "ef bb bf 68 69";
               text = "hi";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-8's mark under windows-1252: the bytes are UTF-8";
               content_type = "text/plain; charset=windows-1252";
               bytes = "ef bb bf c3 a9";
               text = "\195\169";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-8's mark under UTF-16LE: the bytes are UTF-8";
               content_type = "text/plain; charset=utf-16le";
               bytes = "ef bb bf 68 69";
               text = "hi";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-16LE's mark under UTF-16LE";
               content_type = "text/plain; charset=utf-16le";
               bytes = "ff fe 68 00 69 00";
               text = "hi";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-16LE's mark under no charset: the bytes are UTF-16LE";
               content_type = "text/plain";
               bytes = "ff fe 68 00 69 00";
               text = "hi";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-16LE's mark under UTF-8: the bytes are UTF-16LE";
               content_type = "text/plain; charset=utf-8";
               bytes = "ff fe 68 00 69 00";
               text = "hi";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-16LE's mark under UTF-16BE: the bytes are UTF-16LE";
               content_type = "text/plain; charset=utf-16be";
               bytes = "ff fe 68 00 69 00";
               text = "hi";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-16BE's mark under UTF-16BE";
               content_type = "text/plain; charset=utf-16be";
               bytes = "fe ff 00 68 00 69";
               text = "hi";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-16BE's mark under no charset: the bytes are UTF-16BE";
               content_type = "text/plain";
               bytes = "fe ff 00 68 00 69";
               text = "hi";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "UTF-16BE's mark under utf-16, which alone is UTF-16LE: the \
                  bytes are UTF-16BE";
               content_type = "text/plain; charset=utf-16";
               bytes = "fe ff 00 68 00 69";
               text = "hi";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-16BE's mark under iso-8859-1: the bytes are UTF-16BE";
               content_type = "text/plain; charset=iso-8859-1";
               bytes = "fe ff 00 68 00 69";
               text = "hi";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "a mark that is not leading is a character of the text";
               content_type = "text/plain";
               bytes = "61 ef bb bf 62";
               text = "a\239\187\191b";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "a mark that is not leading is a character of the text, in \
                  UTF-16LE";
               content_type = "text/plain; charset=utf-16le";
               bytes = "68 00 ff fe 69 00";
               text = "h\239\187\191i";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "two marks at the start: the first is left out, and the \
                  second is a character of the text";
               content_type = "text/plain";
               bytes = "ef bb bf ef bb bf 78";
               text = "\239\187\191x";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "nothing but a mark is the empty text";
               content_type = "text/plain";
               bytes = "ef bb bf";
               text = "";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "nothing but UTF-16LE's mark is the empty text";
               content_type = "text/plain";
               bytes = "ff fe";
               text = "";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "after one encoding's mark, another's is no mark: these two \
                  bytes are nothing UTF-8 has";
               content_type = "text/plain";
               bytes = "ef bb bf ff fe";
               text = "\239\191\189\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "two of the three bytes of UTF-8's mark are no mark: a \
                  sequence cut short";
               content_type = "text/plain";
               bytes = "ef bb 68";
               text = "\239\191\189h";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "with no mark and no charset the bytes are UTF-8, whatever \
                  they look like";
               content_type = "text/plain";
               bytes = "68 00 69 00";
               text = "h\000i\000";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "UTF-8: a byte that can begin nothing is one U+FFFD, and the \
                  reading goes on";
               content_type = "text/plain; charset=utf-8";
               bytes = "61 ff 62";
               text = "a\239\191\189b";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "UTF-8: a sequence cut short by the next character is one \
                  U+FFFD, not one for each of its bytes";
               content_type = "text/plain; charset=utf-8";
               bytes = "61 e2 82 62";
               text = "a\239\191\189b";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-8: a sequence cut short by the end is one U+FFFD";
               content_type = "text/plain";
               bytes = "61 f0 9f 98";
               text = "a\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-8: what is whole after a sequence cut short is read";
               content_type = "text/plain";
               bytes = "e2 82 e2 82 ac";
               text = "\239\191\189\226\130\172";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "UTF-8: a continuation byte with nothing to continue is one \
                  U+FFFD each";
               content_type = "text/plain";
               bytes = "61 80 bf 62";
               text = "a\239\191\189\239\191\189b";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "UTF-8: an overlong form of two bytes is two U+FFFD, and not \
                  the character it spells";
               content_type = "text/plain";
               bytes = "c0 af";
               text = "\239\191\189\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-8: an overlong form of three bytes is three";
               content_type = "text/plain";
               bytes = "e0 80 af";
               text = "\239\191\189\239\191\189\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-8: a surrogate is three U+FFFD";
               content_type = "text/plain";
               bytes = "ed a0 80";
               text = "\239\191\189\239\191\189\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-8: a code point past U+10FFFF is four";
               content_type = "text/plain";
               bytes = "f4 90 80 80";
               text = "\239\191\189\239\191\189\239\191\189\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-8: a five-byte form is five";
               content_type = "text/plain";
               bytes = "f8 88 80 80 80";
               text =
                 "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-8: every kind of fault in one text";
               content_type = "text/plain";
               bytes = "61 f1 80 80 e1 80 c2 62 80 63 80 bf 64";
               text =
                 "a\239\191\189\239\191\189\239\191\189b\239\191\189c\239\191\189\239\191\189d";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "UTF-16LE: a character outside the basic plane is two units \
                  and one character";
               content_type = "text/plain; charset=utf-16le";
               bytes = "3d d8 00 de";
               text = "\240\159\152\128";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-16LE: an odd last byte is one U+FFFD";
               content_type = "text/plain; charset=utf-16le";
               bytes = "68 00 69";
               text = "h\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "UTF-16LE: a leading surrogate with no trailing one is one \
                  U+FFFD, and the unit after it is read";
               content_type = "text/plain; charset=utf-16le";
               bytes = "3d d8 68 00";
               text = "\239\191\189h";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "UTF-16LE: a trailing surrogate with no leading one is one \
                  U+FFFD";
               content_type = "text/plain; charset=utf-16le";
               bytes = "00 dc 68 00";
               text = "\239\191\189h";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-16LE: a leading surrogate at the end is one U+FFFD";
               content_type = "text/plain; charset=utf-16le";
               bytes = "68 00 3d d8";
               text = "h\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "UTF-16LE: a leading surrogate and then an odd last byte are \
                  one U+FFFD between them";
               content_type = "text/plain; charset=utf-16le";
               bytes = "3d d8 41";
               text = "\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "UTF-16LE: a leading surrogate before a whole pair is one \
                  U+FFFD, and the pair is read";
               content_type = "text/plain; charset=utf-16le";
               bytes = "3d d8 3d d8 00 de";
               text = "\239\191\189\240\159\152\128";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "UTF-16BE: a leading surrogate with no trailing one is one \
                  U+FFFD, and the unit after it is read";
               content_type = "text/plain; charset=utf-16be";
               bytes = "d8 3d 00 68";
               text = "\239\191\189h";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "UTF-16BE: an odd last byte is one U+FFFD";
               content_type = "text/plain; charset=utf-16be";
               bytes = "00 68 00";
               text = "h\239\191\189";
             }
              : text)
           : cases_item);
         (Text
            ({
               why =
                 "a media type the registry lists as decoded is read, though \
                  it is no text/ type: JSON";
               content_type = "application/json";
               bytes = "7b 22 61 22 3a 22 c3 a9 22 7d";
               text = "{\"a\":\"\195\169\"}";
             }
              : text)
           : cases_item);
         (Text
            ({
               why = "a text/ type the registry does not list is read";
               content_type = "text/x-unheard-of";
               bytes = "63 61 66 c3 a9";
               text = "caf\195\169";
             }
              : text)
           : cases_item);
         (Refused
            ({
               why =
                 "a PDF's text is derived from its bytes and is not them: its \
                  media type is refused, though these bytes would read as \
                  UTF-8";
               content_type = "application/pdf";
               bytes = "25 50 44 46 2d 31 2e 37";
               refused = "application/pdf";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why = "a charset does not make a PDF's bytes its text";
               content_type = "application/pdf; charset=utf-8";
               bytes = "25 50 44 46 2d 31 2e 37";
               refused = "application/pdf";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why = "an image has no text: its media type is refused";
               content_type = "image/png";
               bytes = "89 50 4e 47 0d 0a 1a 0a";
               refused = "image/png";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "the media type is held before the charset is read: of a type \
                  with no text and a charset the standard lacks, the refusal \
                  names the type";
               content_type = "image/png; charset=x-no-such-charset";
               bytes = "89 50 4e 47 0d 0a 1a 0a";
               refused = "image/png";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "a type the registry does not list, and that is no text/ \
                  type, has no text either";
               content_type = "application/x-unheard-of";
               bytes = "68 69";
               refused = "application/x-unheard-of";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "nor has a content type that is no MIME type and does not \
                  begin text/: the charset it would state is never read";
               content_type = "te xt/plain; charset=iso-8859-1";
               bytes = "e9";
               refused = "te xt/plain";
             }
              : refused)
           : cases_item);
         (Refused
            ({
               why =
                 "an empty content type names no media type whose bytes are \
                  its text: it is refused, and there is no name for the \
                  refusal to give";
               content_type = "";
               bytes = "c3 a9";
               refused = "";
             }
              : refused)
           : cases_item);
       ];
   }
    : t)
