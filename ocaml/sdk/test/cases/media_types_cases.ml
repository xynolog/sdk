(* Generated from protocol/specs/src/media-types/cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type clone_format_item = {
  why : string;
  source : string option;
  format : string;
}

let clone_format_item_json (r : clone_format_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some
           ( "source",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.source );
         Option.Some ("format", (fun s -> `String s) r.format);
       ])

type storage_file_name_item = {
  why : string;
  name : string;
  format : string;
  file_name : string;
}

let storage_file_name_item_json (r : storage_file_name_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("format", (fun s -> `String s) r.format);
         Option.Some ("fileName", (fun s -> `String s) r.file_name);
       ])

type text_source_item = {
  why : string;
  format : string;
  text_source : string;
  yields_geometry : bool;
  derives_text : bool;
}

let text_source_item_json (r : text_source_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("format", (fun s -> `String s) r.format);
         Option.Some ("textSource", (fun s -> `String s) r.text_source);
         Option.Some ("yieldsGeometry", (fun b -> `Bool b) r.yields_geometry);
         Option.Some ("derivesText", (fun b -> `Bool b) r.derives_text);
       ])

type t = {
  comment : string;
  clone_format : clone_format_item list;
  storage_file_name : storage_file_name_item list;
  text_source : text_source_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ( "cloneFormat",
             (fun l -> `List (List.map clone_format_item_json l)) r.clone_format
           );
         Option.Some
           ( "storageFileName",
             (fun l -> `List (List.map storage_file_name_item_json l))
               r.storage_file_name );
         Option.Some
           ( "textSource",
             (fun l -> `List (List.map text_source_item_json l)) r.text_source
           );
       ])

let table : t =
  ({
     comment =
       "The rules every SDK reads from registry.json, as cases each SDK runs. \
        `cloneFormat`: the format a clone of a resource takes: its source's \
        base media type when that is one a person can author, and text/plain \
        otherwise, since a clone opens where a person writes. \
        `storageFileName`: the name a resource's content is stored under: its \
        title in lower case, every run of characters that are not a to z or 0 \
        to 9 made one hyphen, none at either end, and then the format's \
        extension. A `file://` storage URI is that name behind the scheme. \
        `textSource`: where the text of a resource of a format comes from, and \
        the two things that follow from it. A format's parameters and its \
        letter case are not part of its type. A type the registry lists \
        answers as its row says: `decode`, its bytes are its text; \
        `pdf-text-layer`, its text is derived by reading its bytes; `none`, it \
        has no text. A type the registry does not list is `decode` when it is \
        a `text/` type, and `none` otherwise. `yieldsGeometry` is whether that \
        text comes with where each run of it is on a page: a text derived from \
        a PDF does, and a decoded one does not. `derivesText` is whether the \
        text is derived from the bytes, and not decoded from them. Every case \
        states all three: `textSourceOf`, `yieldsGeometryOf` and \
        `derivesTextOf`, each spelled in its SDK's convention (`textSourceOf` \
        is text_source_of).";
     clone_format =
       [
         ({
            why = "an authorable source keeps its type";
            source = Some "text/markdown";
            format = "text/markdown";
          }
           : clone_format_item);
         ({
            why = "parameters are not part of the type";
            source = Some "text/html; charset=iso-8859-1";
            format = "text/html";
          }
           : clone_format_item);
         ({
            why = "case is not part of the type";
            source = Some "Text/HTML";
            format = "text/html";
          }
           : clone_format_item);
         ({
            why = "a type nobody authors falls back to plain text";
            source = Some "application/pdf";
            format = "text/plain";
          }
           : clone_format_item);
         ({
            why = "so does a stored type that is text but not authorable";
            source = Some "text/csv";
            format = "text/plain";
          }
           : clone_format_item);
         ({
            why = "so does a type the registry does not have";
            source = Some "application/x-unheard-of";
            format = "text/plain";
          }
           : clone_format_item);
         ({
            why = "and a source that states none";
            source = None;
            format = "text/plain";
          }
           : clone_format_item);
       ];
     storage_file_name =
       [
         ({
            why = "lower case, spaces to hyphens, the format's extension";
            name = "My Document";
            format = "text/markdown";
            file_name = "my-document.md";
          }
           : storage_file_name_item);
         ({
            why =
              "a run of anything else is one hyphen, and none is left at \
               either end";
            name = "  Hello, World!  ";
            format = "text/plain";
            file_name = "hello-world.txt";
          }
           : storage_file_name_item);
         ({
            why = "letters outside a to z are not kept";
            name = "Caf\195\169 \195\156ber 2";
            format = "text/html";
            file_name = "caf-ber-2.html";
          }
           : storage_file_name_item);
         ({
            why = "digits are";
            name = "2026 Q3";
            format = "application/pdf";
            file_name = "2026-q3.pdf";
          }
           : storage_file_name_item);
         ({
            why = "a name with nothing to keep is the extension alone";
            name = "***";
            format = "text/markdown";
            file_name = ".md";
          }
           : storage_file_name_item);
         ({
            why =
              "a hyphen in the name is a character like any other that is not \
               kept";
            name = "-a--b-";
            format = "text/plain";
            file_name = "a-b.txt";
          }
           : storage_file_name_item);
         ({
            why = "lower case is Unicode's: the Kelvin sign is a k";
            name = "\226\132\1702";
            format = "text/plain";
            file_name = "k2.txt";
          }
           : storage_file_name_item);
       ];
     text_source =
       [
         ({
            why = "a text type the registry lists: its bytes are its text";
            format = "text/markdown";
            text_source = "decode";
            yields_geometry = false;
            derives_text = false;
          }
           : text_source_item);
         ({
            why =
              "a type the registry lists as decoded need not be a text/ type";
            format = "application/json";
            text_source = "decode";
            yields_geometry = false;
            derives_text = false;
          }
           : text_source_item);
         ({
            why =
              "a PDF's text is derived by reading its bytes, and comes with \
               where each run of it is on a page";
            format = "application/pdf";
            text_source = "pdf-text-layer";
            yields_geometry = true;
            derives_text = true;
          }
           : text_source_item);
         ({
            why = "an image has no text";
            format = "image/png";
            text_source = "none";
            yields_geometry = false;
            derives_text = false;
          }
           : text_source_item);
         ({
            why = "nor has an archive, which the registry lists too";
            format = "application/zip";
            text_source = "none";
            yields_geometry = false;
            derives_text = false;
          }
           : text_source_item);
         ({
            why = "parameters are not part of the type";
            format = "application/pdf; version=1.7";
            text_source = "pdf-text-layer";
            yields_geometry = true;
            derives_text = true;
          }
           : text_source_item);
         ({
            why = "case is not part of the type";
            format = "APPLICATION/PDF";
            text_source = "pdf-text-layer";
            yields_geometry = true;
            derives_text = true;
          }
           : text_source_item);
         ({
            why =
              "a text/ type the registry does not list is decoded: the type \
               says of itself that it is text";
            format = "text/x-unheard-of";
            text_source = "decode";
            yields_geometry = false;
            derives_text = false;
          }
           : text_source_item);
         ({
            why =
              "and so is one written in capitals and with parameters, which \
               are not part of that type either";
            format = "TEXT/X-Unheard-Of; charset=iso-8859-1";
            text_source = "decode";
            yields_geometry = false;
            derives_text = false;
          }
           : text_source_item);
         ({
            why = "any other type the registry does not list has no text";
            format = "application/x-unheard-of";
            text_source = "none";
            yields_geometry = false;
            derives_text = false;
          }
           : text_source_item);
         ({
            why = "an empty format is no type, and has no text";
            format = "";
            text_source = "none";
            yields_geometry = false;
            derives_text = false;
          }
           : text_source_item);
       ];
   }
    : t)
