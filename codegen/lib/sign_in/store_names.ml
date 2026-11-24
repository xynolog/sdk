(* The names the sign-in store's contract (sign-in-store/README.md) gives its
   files, and the byte a Windows writer locks, as each SDK that writes the
   store reads them: only what that SDK names, so a writer that takes the
   store's path from its caller, or locks the whole file, states nothing it
   does not read. *)

let from_ = "protocol/specs/src/" ^ Contract.file
let offset (names : Contract.t) = int_of_string ("0x" ^ names.offset_high)

let document_about =
  "The store's file in the launcher's state home, beside its lock."

let lock_about = "The file every writer of the store locks, beside the store."

let offset_about =
  "The high word of the offset of the one byte of the lock a Windows writer \
   locks, far past anything a lock file holds; a writer that locks the whole \
   file holds it too."

let go (names : Contract.t) =
  let module G = Go_syntax in
  let constant doc name value =
    G.Const (G.spec ~doc:(G.prose doc) name value)
  in
  {
    Output.path = "go/signinstore_gen.go";
    text =
      G.text
        {
          header =
            G.verbatim
              ("Code generated from " ^ from_
             ^ " — DO NOT EDIT.\n\nRegenerate: make generate ("
             ^ Banner.writer __FILE__ ^ ")");
          package = "xynolog";
          imports = [];
          decls =
            [
              constant
                ("SignInFile: " ^ document_about)
                "SignInFile" (G.Quoted names.document);
              constant
                ("signInLock: " ^ lock_about)
                "signInLock" (G.Quoted names.lock);
              constant
                ("signInLockOffsetHigh: " ^ offset_about)
                "signInLockOffsetHigh"
                (G.Hex (offset names));
            ];
        };
  }

let python (names : Contract.t) =
  let module P = Python_syntax in
  let constant about name value =
    P.assign ~about:[ Prose about ] ~annotation:(P.Name "Final") ~value name
  in
  {
    Output.path = "python/sdk/src/xynolog/_sign_in_store_names.py";
    text =
      P.text
        {
          header = Banner.python_lines ~from_ __FILE__;
          doc =
            As_is
              "The names the sign-in store's contract gives its files, and the \
               byte a Windows\n\
               writer locks.";
          imports = [ [ P.From ("typing", [ "Final" ]) ] ];
          body =
            [
              P.assign "__all__"
                ~value:
                  (P.List
                     (P.items
                        (List.map
                           (fun n -> P.item (P.Str n))
                           [ "FILE_NAME"; "LOCK_NAME"; "LOCK_OFFSET_HIGH" ])));
              constant document_about "FILE_NAME" (P.Str names.document);
              constant lock_about "LOCK_NAME" (P.Str names.lock);
              constant offset_about "LOCK_OFFSET_HIGH" (P.Hex names.offset_high);
            ];
        };
  }

let kotlin (names : Contract.t) =
  let module K = Kotlin_syntax in
  let constant ~visibility about name type_ value =
    K.property ~about:(K.Block about) ~visibility ~const:true
      ~type_:(K.Type type_) ~value:(K.Same_line value) name
  in
  Kotlin_sdk.table ~from_:Contract.file __FILE__ ~package:"xynolog.signin"
    ~name:"SignInStoreNames" ~imports:[]
    [
      constant ~visibility:K.Public document_about "FILE_NAME" "String"
        (K.Str names.document);
      constant ~visibility:K.Internal lock_about "LOCK_NAME" "String"
        (K.Str names.lock);
      constant ~visibility:K.Internal offset_about "LOCK_OFFSET_HIGH" "Long"
        (K.Hex names.offset_high);
    ]

(* The Rust SDK's writer locks the whole lock file, named for the store's
   own path, so it names only the store's file. *)
let rust (names : Contract.t) =
  let module R = Rust_syntax in
  {
    Output.path = "rust/sdk/src/generated/sign_in_store_names.rs";
    text =
      R.text
        ~header:(Banner.lines ~from_ __FILE__)
        [
          R.Const
            {
              doc = [ document_about ];
              attrs = [];
              vis = Pub;
              name = "FILE_NAME";
              ty = R.str_ty;
              value = R.Str names.document;
            };
        ];
  }

(* The Swift SDK's writer takes the store's path from its caller and keeps no
   Windows lock, so it names only the lock. *)
let swift (names : Contract.t) =
  let module S = Swift_syntax in
  {
    Output.path = "swift/sdk/Sources/Xynolog/Generated/SignInStoreNames.swift";
    text =
      S.print
        {
          S.banner = Banner.lines ~from_ __FILE__;
          imports = [ { S.module_ = "Foundation"; testable = false } ];
          decls =
            [
              ( S.Blank,
                {
                  S.doc = Text.wrapped ~lead:"/// " ~width:100 lock_about;
                  modifiers = [ "public" ];
                  body =
                    S.Property
                      {
                        var = false;
                        name = "signInLockName";
                        type_ = None;
                        value = Some (S.String names.lock);
                      };
                } );
            ];
        };
  }

(* The OCaml SDK's writer locks with flock alone, so it names the two
   files. *)
let ocaml (names : Contract.t) =
  let module O = Ocaml_syntax in
  O.implementation ~path:"ocaml/sdk/lib/sign_in_store_names.ml"
    ~banner:(Banner.ocaml ~from_:Contract.file __FILE__)
    [
      O.let_ "document" (O.string names.document);
      O.let_ "lock" (O.string names.lock);
    ]

let files names =
  [ go names; python names; kotlin names; rust names; swift names; ocaml names ]
