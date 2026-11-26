(* The sign-in group: one entry of the sign-in store (sign-in-store/SignIn.json),
   how a writer keeps the store's directory and files to their owner
   (sign-in-store/owner-only.json), and the names the contract gives the
   store's files and the byte a Windows writer locks
   (sign-in-store/README.md). Programs in several languages read and write
   <stateDir>/tokens.json, so each of these is the contract's to state. *)

module Flat = Flat
module Owner_only = Owner_only
module Contract = Contract
module Kotlin = Kotlin
module Rust = Rust
module Store_names = Store_names

let snake name = String.lowercase_ascii (Text.upper_snake name)
let regenerate = "make generate (" ^ Banner.writer __FILE__ ^ ")"

module G = Go_syntax

let go_header ~from_ ~also =
  G.verbatim
    ("Code generated from protocol/specs/src/" ^ from_
   ^ " — DO NOT EDIT.\n\nRegenerate: " ^ regenerate ^ "\n" ^ also)

let go_entry (entry : Flat.t) =
  let field (f : Flat.field) =
    (* An absent optional property is the zero value: "" for a string, the
       zero time for a date-time. Neither is written. *)
    let omit =
      if f.required then "" else if f.is_time then ",omitzero" else ",omitempty"
    in
    {
      G.doc = G.prose f.description;
      names = [ String.capitalize_ascii f.name ];
      type_ = G.Named (if f.is_time then "time.Time" else "string");
      tag = Some ("json:\"" ^ f.name ^ omit ^ "\"");
    }
  in
  let required = String.uncapitalize_ascii entry.title ^ "Required" in
  {
    Output.path = "go/signin_gen.go";
    text =
      G.text
        {
          header =
            go_header ~from_:Roots.sign_in_entry
              ~also:
                "The Rust (xynolog::sign_in_store) and Python \
                 (xynolog.sign_in) SDKs generate\n\
                 their entries from the same schema.";
          package = "xynolog";
          imports =
            (if List.exists (fun (f : Flat.field) -> f.is_time) entry.fields
             then [ [ "time" ] ]
             else []);
          decls =
            [
              G.Type
                {
                  doc = G.prose (entry.title ^ ": " ^ entry.description);
                  name = entry.title;
                  def =
                    G.Struct
                      {
                        fields = List.map field entry.fields;
                        spacing = G.Spaced;
                      };
                };
              G.Var
                (G.spec
                   ~doc:
                     (G.verbatim
                        (required ^ ": the properties every " ^ entry.title
                       ^ " states. A member of the\n\
                          document that lacks one is not a " ^ entry.title ^ "."
                        ))
                   required
                   (G.inline ~of_:(G.Slice (G.Named "string"))
                      (List.map (fun r -> G.item (G.Quoted r)) entry.required)));
            ];
        };
  }

let go_owner_only (o : Owner_only.t) =
  let mode name (m : Owner_only.mode) =
    G.Const
      (G.spec
         ~doc:(G.prose (name ^ ": " ^ m.docs))
         ~type_:(G.Named "os.FileMode") name (G.Octal m.octal))
  in
  let access_list name (l : Owner_only.access_list) =
    G.func
      ~doc:(G.prose (name ^ ": " ^ l.docs))
      ~params:[ ("owner", G.Named "string") ]
      ~results:(G.Unnamed [ G.Named "string" ]) name
      (G.Block
         [
           G.Return
             [
               G.Binary
                 ( G.Binary (G.Quoted l.before, G.Add, G.Name "owner"),
                   G.Add,
                   G.Quoted l.after );
             ];
         ])
  in
  {
    Output.path = "go/owneronly_gen.go";
    text =
      G.text
        {
          header =
            go_header ~from_:Owner_only.file
              ~also:
                "The Rust, Python and Kotlin SDKs generate theirs from the \
                 same file.";
          package = "xynolog";
          imports = [ [ "os" ] ];
          decls =
            [
              mode "OwnerOnlyDirMode" o.directory;
              mode "OwnerOnlyFileMode" o.file;
              access_list "OwnerOnlyDirAccessList" o.directory_access_list;
              access_list "OwnerOnlyFileAccessList" o.file_access_list;
            ];
        };
  }

module P = Python_syntax

(* [plain], or Annotated with the pydantic Field that states [said]. *)
let python_annotated plain said =
  match said with
  | [] -> plain
  | said -> P.sub "Annotated" [ P.item plain; P.item (P.call "Field" said) ]

let python_entry (entry : Flat.t) =
  (* A time stays the text it is written as: what this SDK reads it writes
     back as it came. The wire's name is beside the type, where both type
     checkers leave the Python name as the one an entry is built by. *)
  let field (f : Flat.field) =
    let python = snake f.name in
    let plain =
      if f.required then P.Name "str"
      else P.Binary (P.Name "str", P.Or, P.Name "None")
    in
    P.assign ~about:[ Prose f.description ]
      ~annotation:
        (python_annotated plain
           (if python = f.name then [] else [ P.keyword "alias" (P.Str f.name) ]))
      ?value:(if f.required then None else Some (P.Name "None"))
      python
  in
  let aliased =
    List.exists (fun (f : Flat.field) -> snake f.name <> f.name) entry.fields
  in
  {
    Output.path = "python/sdk/src/xynolog/sign_in.py";
    text =
      P.text
        {
          header =
            Banner.python_lines
              ~from_:("protocol/specs/src/" ^ Roots.sign_in_entry)
              __FILE__;
          doc =
            As_is
              "One entry of the sign-in store \
               (`protocol/specs/src/sign-in-store`): the file where\n\
               `xynolog login` keeps the sign-in to each stack, and where an \
               application\n\
               finds it.\n";
          imports =
            [
              [
                P.From
                  ( "typing",
                    (if aliased then [ "Annotated" ] else []) @ [ "final" ] );
              ];
            ]
            @ (if aliased then [ [ P.From ("pydantic", [ "Field" ]) ] ] else [])
            @ [ [ P.From ("xynolog.model", [ "WireModel" ]) ] ];
          body =
            [
              P.assign "__all__"
                ~value:(P.List (P.items [ P.item (P.Str entry.title) ]));
              P.Class
                {
                  decorators = [ P.Name "final" ];
                  name = entry.title;
                  bases =
                    [
                      P.item (P.Name "WireModel");
                      P.keyword "frozen" (P.Name "True");
                    ];
                  doc = Some (Wrapped entry.description);
                  spacing = Spaced;
                  body = List.map field entry.fields;
                };
            ];
        };
  }

let python_owner_only (o : Owner_only.t) =
  let constant name (m : Owner_only.mode) =
    P.assign ~about:[ Prose m.docs ] ~annotation:(P.Name "Final")
      ~value:(P.Octal m.octal) name
  in
  let access_list name (l : Owner_only.access_list) =
    P.Def
      {
        name;
        params = [ ("owner", P.Name "str") ];
        returns = P.Name "str";
        doc = Some (Wrapped l.docs);
        body =
          [
            P.Return
              (P.Binary
                 ( P.Binary (P.Str l.before, P.Add, P.Name "owner"),
                   P.Add,
                   P.Str l.after ));
          ];
      }
  in
  {
    Output.path = "python/sdk/src/xynolog/_owner_only_table.py";
    text =
      P.text
        {
          header =
            Banner.python_lines
              ~from_:("protocol/specs/src/" ^ Owner_only.file)
              __FILE__;
          doc =
            As_is
              "How a writer of the sign-in store keeps its directory and its \
               files to their owner, as the launcher keeps its state home.";
          imports = [ [ P.From ("typing", [ "Final" ]) ] ];
          body =
            [
              P.assign "__all__"
                ~value:
                  (P.List
                     (P.items
                        (List.map
                           (fun n -> P.item (P.Str n))
                           [
                             "DIRECTORY_MODE";
                             "FILE_MODE";
                             "directory_access_list";
                             "file_access_list";
                           ])));
              constant "DIRECTORY_MODE" o.directory;
              constant "FILE_MODE" o.file;
              access_list "directory_access_list" o.directory_access_list;
              access_list "file_access_list" o.file_access_list;
            ];
        };
  }

let typescript (entry : Flat.t) (o : Owner_only.t) (names : Contract.t) =
  let module S = Typescript_syntax in
  let field (f : Flat.field) =
    S.member ~about:[ Doc f.description ] ~optional:(not f.required)
      (Ident f.name) (T_name "string")
  in
  let check (f : Flat.field) =
    let member = S.Index (Name "value", Str f.name) in
    let is_string = S.Call (Name "isString", [ member ]) in
    if f.required then is_string
    else Paren (Binary (Binary (member, Strict_eq, Undefined), Or, is_string))
  in
  let constant name about value = S.const name ~about:[ Doc about ] value in
  let access_list name (l : Owner_only.access_list) =
    S.Function
      {
        about = [ Doc l.docs ];
        export = true;
        name;
        params = [ { name = "owner"; type_ = T_name "string" } ];
        returns = T_name "string";
        body =
          [
            Return
              (Binary
                 (Binary (Str l.before, Plus, Name "owner"), Plus, Str l.after));
          ];
      }
  in
  {
    Output.path = "typescript/core/src/sign-in.ts";
    text =
      S.text
        {
          banner =
            Banner.typescript_lines
              ~authority:
                [
                  "protocol/specs/src/sign-in-store (SignIn.json, \
                   owner-only.json, README.md)";
                ]
              __FILE__;
          body =
            [
              S.import [ "isObject"; "isString" ] "./type-guards";
              S.Interface
                {
                  about = [ Doc entry.description ];
                  export = true;
                  name = entry.title;
                  members = List.map field entry.fields;
                };
              S.Function
                {
                  about =
                    [
                      Doc
                        ("Whether `value` is a " ^ entry.title
                       ^ ": what it requires is there, and every member it has \
                          is text.");
                    ];
                  export = true;
                  name = "is" ^ entry.title;
                  params = [ { name = "value"; type_ = T_name "unknown" } ];
                  returns = T_predicate ("value", T_name entry.title);
                  body =
                    [
                      Return
                        (Chain
                           ( And,
                             Call (Name "isObject", [ Name "value" ])
                             :: List.map check entry.fields ));
                    ];
                };
              constant "OWNER_ONLY_DIRECTORY_MODE" o.directory.docs
                (Octal o.directory.octal);
              constant "OWNER_ONLY_FILE_MODE" o.file.docs (Octal o.file.octal);
              access_list "ownerOnlyDirectoryAccessList" o.directory_access_list;
              access_list "ownerOnlyFileAccessList" o.file_access_list;
              constant "SIGN_IN_STORE_FILE"
                "The document's name in the state home: one sign-in per stack."
                (Str names.document);
              constant "SIGN_IN_STORE_LOCK"
                "The name, beside the document, of the file every writer locks \
                 from before its read until after its rename."
                (Str names.lock);
              constant "SIGN_IN_STORE_WINDOWS_OFFSET_HIGH"
                "On Windows, the high 32 bits of the offset of the one byte of \
                 the lock file that is locked: far past anything the file \
                 holds."
                (Hex names.offset_high);
            ];
        };
  }

(* The owner-only modes as the OCaml SDK and its storage probe hold them
   (ocaml/sdk/lib/store_policy.ml, ocaml/sdk/probes/store_policy.ml). *)
let ocaml_owner_only (o : Owner_only.t) =
  List.map
    (fun dir ->
      Ocaml_syntax.implementation
        ~path:("ocaml/sdk/" ^ dir ^ "/store_policy.ml")
        ~banner:(Banner.ocaml ~from_:"sign-in-store/owner-only.json" __FILE__)
        [
          Ocaml_syntax.let_ "directory_mode"
            (Ocaml_syntax.integer ("0o" ^ o.directory.octal));
          Ocaml_syntax.let_ "file_mode"
            (Ocaml_syntax.integer ("0o" ^ o.file.octal));
        ])
    [ "lib"; "probes" ]

(* What the Haskell SDK's native store binding holds the store to
   (generated/.../xynolog_store_policy.h): the owner-only modes, the
   directory's and a file's access lists, each with the owner's SID in its
   place, and the one byte of the lock file a Windows writer locks; and the
   names of the store's files (generated/.../SignInStore.hs). *)
let haskell (o : Owner_only.t) (names : Contract.t) =
  let module H = Haskell_syntax in
  let generated = "haskell/sdk/generated/Xynolog/Internal/Generated/" in
  let written (l : Owner_only.access_list) =
    l.before ^ Owner_only.owner ^ l.after
  in
  let directory_access = written o.directory_access_list in
  let file_access = written o.file_access_list in
  let c_string text =
    "\""
    ^ String.concat ""
        (List.map
           (function '"' -> "\\\"" | '\\' -> "\\\\" | c -> String.make 1 c)
           (List.of_seq (String.to_seq text)))
    ^ "\""
  in
  let not_ascii (pointer, access) =
    if String.for_all (fun c -> Char.code c < 128) access then None
    else
      Some
        {
          Decode.file = Owner_only.file;
          pointer;
          message = "is not ASCII, which the native binding's access list is";
        }
  in
  match
    List.filter_map not_ascii
      [
        ("/directoryAccessList/value", directory_access);
        ("/fileAccessList/value", file_access);
      ]
  with
  | _ :: _ as refusals -> Error refusals
  | [] ->
      Ok
        [
          {
            Output.path = generated ^ "xynolog_store_policy.h";
            text =
              String.concat "\n"
                [
                  "/* Generated from " ^ Contract.file ^ " and "
                  ^ Owner_only.file ^ "; do not edit.";
                  "   Regenerate: " ^ regenerate ^ " */";
                  "#define XYNOLOG_DIRECTORY_MODE 0" ^ o.directory.octal;
                  "#define XYNOLOG_FILE_MODE 0" ^ o.file.octal;
                  "#define XYNOLOG_DIRECTORY_ACCESS_LIST "
                  ^ c_string directory_access;
                  "#define XYNOLOG_FILE_ACCESS_LIST " ^ c_string file_access;
                  "#define XYNOLOG_LOCK_HIGH 0x" ^ names.offset_high;
                  "#define XYNOLOG_LOCK_BYTES 1";
                ]
              ^ "\n";
          };
          {
            Output.path = generated ^ "SignInStore.hs";
            text =
              H.text
                {
                  banner = Banner.lines ~from_:Contract.file __FILE__;
                  extensions = [];
                  name = "Xynolog.Internal.Generated.SignInStore";
                  imports = [];
                  body =
                    [
                      Values
                        {
                          about = [];
                          type_ = T_name "FilePath";
                          values =
                            [
                              ("signInFileName", Str names.document);
                              ("signInLockName", Str names.lock);
                            ];
                        };
                    ];
                };
          };
        ]

let files ~root (spec : Spec.t) =
  let entry =
    match Definitions.sign_in spec with
    | schema -> Flat.read ~file:Roots.sign_in_entry schema
    | exception Definitions.Refused message ->
        Error [ { Decode.file = Roots.sign_in_entry; pointer = ""; message } ]
  in
  let owner_only = Owner_only.derive spec.tables.sign_in_store_owner_only in
  let names = Contract.read ~root in
  match (entry, owner_only, names) with
  | Ok entry, Ok o, Ok names ->
      Result.map
        (fun haskell_files ->
          [
            go_entry entry;
            go_owner_only o;
            python_entry entry;
            python_owner_only o;
            typescript entry o names;
            Rust.file o;
            Kotlin.file o;
          ]
          @ ocaml_owner_only o @ Store_names.files names @ haskell_files)
        (haskell o names)
  | _ ->
      let errors = function Ok _ -> [] | Error e -> e in
      Error (errors entry @ errors owner_only @ errors names)
