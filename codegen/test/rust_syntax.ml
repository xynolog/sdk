(* What the Rust printer writes for what a writer states, laid out as rustfmt
   lays it out, and what it refuses to write. *)

open Xynolog_codegen
module R = Rust_syntax

let case name test = Alcotest.test_case name `Quick test
let writes expected text () = Alcotest.(check string) "text" expected (text ())

let refuses text () =
  match text () with
  | written -> Alcotest.failf "wrote %S" written
  | exception Invalid_argument _ -> ()

let expr ?indent e () = R.expr_text ?indent e
let file items () = R.text ~header:[] items
let strs n = List.init n (fun i -> R.Str (Printf.sprintf "item-%02d" i))

let cases =
  [
    case "a string is quoted and escaped as Rust's Debug writes it"
      (writes {|"a\"\\\n\u{1}"|} (expr (R.Str "a\"\\\n\001")));
    case "a string that is not ASCII is refused"
      (refuses (expr (R.Str "caf\195\169")));
    case "a keyword is written raw" (writes "r#type" (expr (R.Path [ "type" ])));
    case "a path keyword is no name"
      (refuses (expr (R.Struct ([ "P" ], [ ("self", R.Int 1) ], None))));
    case "what is no name is refused" (refuses (expr (R.Path [ "not-a-name" ])));
    case "a call that fits is on one line"
      (writes {|f("a", "b")|} (expr (R.call "f" [ R.Str "a"; R.Str "b" ])));
    case
      "a call past fn_call_width is an argument a line, with a trailing comma"
      (writes
         "function_with_a_long_name(\n\
         \    \"the first argument\",\n\
         \    \"the second argument\",\n\
         \    \"the third argument\",\n\
          )"
         (expr
            (R.call "function_with_a_long_name"
               [
                 R.Str "the first argument";
                 R.Str "the second argument";
                 R.Str "the third argument";
               ])));
    case "a call's last argument overflows onto the lines below"
      (writes "f(Shape {\n    reference: Some(\"Annotation\"),\n    ..NONE\n})"
         (expr
            (R.call "f"
               [
                 R.Struct
                   ( [ "Shape" ],
                     [ ("reference", R.call "Some" [ R.Str "Annotation" ]) ],
                     Some (R.p "NONE") );
               ])));
    case "a struct literal within struct_lit_width is on one line"
      (writes "P { a: 1, b: 2 }"
         (expr (R.Struct ([ "P" ], [ ("a", R.Int 1); ("b", R.Int 2) ], None))));
    case "a struct literal past struct_lit_width is a field a line"
      (writes "P {\n    alpha: 10,\n    beta: 20,\n}"
         (expr
            (R.Struct
               ([ "P" ], [ ("alpha", R.Int 10); ("beta", R.Int 20) ], None))));
    case "a field whose value is its own name is shorthand"
      (writes "P { value, kind: 1 }"
         (expr
            (R.Struct
               ([ "P" ], [ ("value", R.p "value"); ("kind", R.Int 1) ], None))));
    case "an array of short simple items is as many a line as fit"
      (writes
         "[\n\
         \    \"item-00\", \"item-01\", \"item-02\", \"item-03\", \"item-04\", \
          \"item-05\", \"item-06\", \"item-07\",\n\
         \    \"item-08\", \"item-09\",\n\
          ]"
         (expr (R.Array (strs 10))));
    case "a chain that does not fit is a call a line below its receiver"
      (writes
         "receiver\n\
         \    .first_method(\"an argument of some length\")\n\
         \    .second_method(\"another argument of some length\")"
         (expr
            (R.Method
               ( R.Method
                   ( R.p "receiver",
                     "first_method",
                     [ R.Str "an argument of some length" ] ),
                 "second_method",
                 [ R.Str "another argument of some length" ] ))));
    case "a match's arms are a line each, a block's arm with no comma"
      (writes "match x {\n    A => 1,\n    _ => {\n        return 2;\n    }\n}"
         (expr
            (R.Match
               ( R.p "x",
                 [
                   (R.p "A", R.Int 1);
                   (R.Wild, R.Block [ R.Semi (R.Return (R.Int 2)) ]);
                 ] ))));
    case "an arm's body that does not fit beside its arrow is in a block below"
      (writes
         "match x {\n\
         \    Kind::Alpha => {\n\
         \        \"a string long enough that it cannot sit beside the arrow \
          of its arm, not at all\"\n\
         \    }\n\
          }"
         (expr
            (R.Match
               ( R.p "x",
                 [
                   ( R.Path [ "Kind"; "Alpha" ],
                     R.Str
                       "a string long enough that it cannot sit beside the \
                        arrow of its arm, not at all" );
                 ] ))));
    case "a match with an arm too wide to lay out is as written, an arm a line"
      (writes
         (Printf.sprintf "match self {\n    %s => \"a\",\n    B => \"b\",\n}"
            ("Kind::" ^ String.make 90 'A'))
         (expr
            (R.Match
               ( R.p "self",
                 [
                   (R.Path [ "Kind"; String.make 90 'A' ], R.Str "a");
                   (R.p "B", R.Str "b");
                 ] ))));
    case "an if-else that fits single_line_if_else_max_width is on one line"
      (writes "if ok { 1 } else { 2 }"
         (expr (R.If (R.p "ok", [ R.Tail (R.Int 1) ], [ R.Tail (R.Int 2) ]))));
    case "an if-else that does not is each branch a block"
      (writes
         "if ok {\n\
         \    Ok(\"a value long enough\")\n\
          } else {\n\
         \    Err(\"an error long enough\")\n\
          }"
         (expr
            (R.If
               ( R.p "ok",
                 [ R.Tail (R.call "Ok" [ R.Str "a value long enough" ]) ],
                 [ R.Tail (R.call "Err" [ R.Str "an error long enough" ]) ] ))));
    case "a pair that does not fit on one line is refused"
      (refuses
         (expr
            (R.Binary
               (R.Str (String.make 60 'a'), "==", R.Str (String.make 60 'b')))));
    case "a derive that does not fit is its paths a line below"
      (writes
         "#[derive(\n\
         \    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, \
          serde::Deserialize, serde::Serialize,\n\
          )]\n\
          pub enum E {\n\
         \    A,\n\
          }\n"
         (file
            [
              R.Enum
                {
                  doc = [];
                  attrs =
                    [
                      R.List
                        ( [ "derive" ],
                          List.map
                            (fun p ->
                              R.Word
                                (String.split_on_char ':' p
                                |> List.filter (( <> ) "")))
                            [
                              "Debug";
                              "Clone";
                              "Copy";
                              "PartialEq";
                              "Eq";
                              "PartialOrd";
                              "Ord";
                              "Hash";
                              "serde::Deserialize";
                              "serde::Serialize";
                            ] );
                    ];
                  vis = Pub;
                  name = "E";
                  variants = [ R.variant "A" ];
                };
            ]));
    case "a signature that does not fit is a parameter a line"
      (writes
         "pub fn new(\n\
         \    token: impl Into<String>,\n\
         \    obtained_at: impl Into<String>,\n\
         \    issuer: impl Into<String>,\n\
          ) -> Self {\n\
         \    Self::new()\n\
          }\n"
         (file
            [
              R.Fn
                (R.fn_ ~vis:Pub "new"
                   ~params:
                     (List.map
                        (fun n ->
                          R.Param
                            ( n,
                              R.Impl_of
                                (R.named ~args:[ R.named "String" ] "Into") ))
                        [ "token"; "obtained_at"; "issuer" ])
                   ~ret:(R.named "Self")
                   [ R.Tail (R.call "Self::new" []) ]);
            ]));
    case "a doc comment's lines are its own, a blank one bare"
      (writes "/// One.\n///\n/// Two.\npub type A = String;\n"
         (file
            [
              R.Type_alias
                {
                  doc = [ "One.\n\nTwo." ];
                  vis = Pub;
                  name = "A";
                  ty = R.named "String";
                };
            ]));
    case "a field's type too long for its line is an argument a line"
      (writes
         "pub struct A {\n\
         \    pub replies: std::collections::BTreeMap<\n\
         \        String,\n\
         \        std::collections::BTreeMap<String, \
          BusReplyBoundsRepliesValueValue>,\n\
         \    >,\n\
          }\n"
         (file
            [
              R.Struct_def
                {
                  doc = [];
                  attrs = [];
                  vis = Pub;
                  name = "A";
                  generics = [];
                  body =
                    Fields
                      [
                        R.field "replies"
                          (R.named "std::collections::BTreeMap"
                             ~args:
                               [
                                 R.named "String";
                                 R.named "std::collections::BTreeMap"
                                   ~args:
                                     [
                                       R.named "String";
                                       R.named "BusReplyBoundsRepliesValueValue";
                                     ];
                               ]);
                      ];
                };
            ]));
    case "a blank ending the file is none"
      (writes "pub struct A;\n"
         (file
            [
              R.Unit_struct { doc = []; attrs = []; vis = Pub; name = "A" };
              R.Blank;
              R.Blank;
            ]));
    case "names are spelled as the SDK spells them" (fun () ->
        Alcotest.(check (list string))
          "names"
          [ "JobCreate"; "subject_claim"; "id"; "BUS_REQUEST_TIMEOUT_MS" ]
          [
            Text.pascal "job:create";
            R.snake "subjectClaim";
            R.snake "@id";
            R.screaming "busRequestTimeoutMs";
          ]);
  ]

let () = Alcotest.run "rust_syntax" [ ("printer", cases) ]
