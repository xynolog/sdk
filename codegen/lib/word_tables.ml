(* The tables of words a schema's [x-xynolog-codes] may name by their file,
   besides errors/codes.json's vocabularies, and where each SDK declares the
   type of each one's words. A schema naming a file absent from here is read
   as a code of errors/codes.json, which Code_names refuses. *)

type t = {
  file : string;
  name : string;  (** The type's name, but Haskell's. *)
  rust_module : string;  (** The Rust module that declares it. *)
  haskell_member : string;
      (** The member Haskell names the type and its constructors by, as a
          failure vocabulary's are. *)
  haskell_module : string;
}

let discovery_absent =
  {
    file = "client/discovery-absent.json";
    name = "DiscoveryAbsentReason";
    rust_module = "crate::discovery";
    haskell_member = "discoveryAbsent";
    haskell_module = "Xynolog.Discovery.Reasons";
  }

let tables = [ discovery_absent ]
let is file = List.exists (fun t -> t.file = file) tables

(* The table [file] names. *)
let find file =
  match List.find_opt (fun t -> t.file = file) tables with
  | Some t -> t
  | None -> invalid_arg (file ^ " is no table of words")

let type_name file = (find file).name

(* The values a code of [member] may be: its codes, as [codes] gives them,
   or the words of the table it names, as [words] gives each by its file. *)
let enum ~codes ~words member =
  match codes member with
  | Some _ as values -> values
  | None -> List.assoc_opt member words
