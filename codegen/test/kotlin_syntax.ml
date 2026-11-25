(* What the Kotlin printer writes for what a writer states, and what it
   refuses to write. *)

open Xynolog_codegen
module K = Kotlin_syntax

let case name test = Alcotest.test_case name `Quick test
let writes expected text () = Alcotest.(check string) "text" expected (text ())

let refuses text () =
  match text () with
  | written -> Alcotest.failf "wrote %S" written
  | exception Invalid_argument _ -> ()

let expr e () = K.expr ~depth:0 e
let decl d () = K.decl ~depth:0 d
let public_val = K.Bound { visibility = K.Public; mutable_ = false }

let cases =
  [
    case
      "a string escapes a quote, a backslash, a dollar and a control \
       character, and keeps the rest"
      (writes {|"a\"\\\$\n\u0001é"|} (expr (K.Str "a\"\\$\n\001\195\169")));
    case "an ASCII string escapes every other character by its UTF-16 units"
      (writes {|"\u00e9\ud83d\ude00\$"|}
         (expr (K.Ascii "\195\169\240\159\152\128$")));
    case "a keyword is written in backquotes, in a qualified name too"
      (writes "a.`in`.b" (expr (K.Name "a.in.b")));
    case "a name that is none is refused" (refuses (expr (K.Name "not-a-name")));
    case
      "an operand that binds less is parenthesised, one that binds more is not"
      (writes "!(a || b) && c == d"
         (expr
            (K.Binary
               ( K.Not (K.Binary (K.Name "a", K.Or, K.Name "b")),
                 K.And,
                 K.Binary (K.Name "c", K.Eq, K.Name "d") ))));
    case "a left operand of the same rank is bare, a right one parenthesised"
      (writes "a || b || (c || d)"
         (expr
            (K.Binary
               ( K.Binary (K.Name "a", K.Or, K.Name "b"),
                 K.Or,
                 K.Binary (K.Name "c", K.Or, K.Name "d") ))));
    case "a throw stands bare as a right operand"
      (writes "a || throw E()"
         (expr (K.Binary (K.Name "a", K.Or, K.Throw (K.call (K.Name "E") [])))));
    case "a range is written close"
      (writes "c in 1..9"
         (expr
            (K.Binary (K.Name "c", K.In, K.Binary (K.Int 1, K.Range, K.Int 9)))));
    case "a call's arguments a line each carry trailing commas"
      (writes "f<T>(\n    a,\n    \"b\",\n)"
         (expr
            (K.call ~types:[ K.Type "T" ] ~layout:K.Lines (K.Name "f")
               [ K.Name "a"; K.Str "b" ])));
    case "a trailing lambda follows a call of no arguments without parentheses"
      (writes "xs.all { c -> c == 1 }"
         (expr
            (K.call
               ~lambda:
                 (K.Lambda ([ "c" ], K.Binary (K.Name "c", K.Eq, K.Int 1)))
               (K.Name "xs.all") [])));
    case "a lambda whose body spans lines is on lines of its own"
      (writes "{\n    f(\n        a,\n    )\n}"
         (expr
            (K.Lambda ([], K.call ~layout:K.Lines (K.Name "f") [ K.Name "a" ]))));
    case "a when's branches are a line each, its else last"
      (writes "when (x) {\n    \"a\", \"b\" -> 1\n    else -> 3\n}"
         (expr
            (K.When
               {
                 subject = Some (K.Name "x");
                 branches =
                   [
                     {
                       conditions = [ K.Equal (K.Str "a"); K.Equal (K.Str "b") ];
                       result = K.Int 1;
                     };
                     { conditions = []; result = K.Int 3 };
                   ];
               })));
    case
      "a doc's text writes neither marker of a block comment as itself, and a \
       blank line as a bare star"
      (writes "/**\n * a *&#47; b\n *\n * &#47;* c\n */\nval x = 1\n"
         (decl
            (K.property ~about:(K.Block "a */ b\n\n/* c\n")
               ~value:(K.Same_line (K.Int 1)) "x")));
    case "a one-line doc of two lines is refused"
      (refuses
         (decl
            (K.property ~about:(K.Doc "a\nb") ~value:(K.Same_line (K.Int 1)) "x")));
    case "a class with no members has no body"
      (writes "public data object A : B\n"
         (decl
            (K.class_ ~visibility:K.Public
               ~supers:[ K.super (K.Type "B") ]
               K.Data_object "A")));
    case
      "several supertypes after a constructor of a line each follow its \
       parenthesis, one a line"
      (writes "class A(\n    val x: Int,\n) : B,\n    C\n"
         (decl
            (K.class_
               ~constructor:
                 (K.constructor
                    [
                      K.param
                        ~binding:
                          (K.Bound { visibility = K.Default; mutable_ = false })
                        "x" (K.Type "Int");
                    ])
               ~supers:[ K.super (K.Type "B"); K.super (K.Type "C") ]
               K.Class "A")));
    case
      "several supertypes of a class with no constructor are a line each below \
       its name"
      (writes "object A :\n    B,\n    C\n"
         (decl
            (K.class_
               ~supers:[ K.super (K.Type "B"); K.super (K.Type "C") ]
               K.Object "A")));
    case "an enum's annotated entries are a blank line apart"
      (writes
         "enum class E(\n\
         \    public val v: String,\n\
          ) {\n\
         \    @N(\"a\")\n\
         \    A(\"a\"),\n\n\
         \    @N(\"b\")\n\
         \    B(\"b\"),\n\
          }\n"
         (decl
            (K.class_
               ~constructor:
                 (K.constructor
                    [ K.param ~binding:public_val "v" (K.Type "String") ])
               ~entries:
                 [
                   K.entry
                     ~annotations:
                       [ K.annotation ~args:[ K.arg (K.Str "a") ] "N" ]
                     ~args:[ K.Str "a" ] "A";
                   K.entry
                     ~annotations:
                       [ K.annotation ~args:[ K.arg (K.Str "b") ] "N" ]
                     ~args:[ K.Str "b" ] "B";
                 ]
               K.Enum_class "E")));
    case "an enum with members is refused"
      (refuses
         (decl
            (K.class_
               ~entries:[ K.entry "A" ]
               ~members:[ K.property ~value:(K.Same_line (K.Int 1)) "x" ]
               K.Enum_class "E")));
    case "members are a blank line apart, and a packed group's are not"
      (writes "class A {\n    var a = 1\n    var b = 2\n\n    fun f() = a\n}\n"
         (decl
            (K.class_
               ~members:
                 [
                   K.Packed
                     [
                       K.property ~mutable_:true ~value:(K.Same_line (K.Int 1))
                         "a";
                       K.property ~mutable_:true ~value:(K.Same_line (K.Int 2))
                         "b";
                     ];
                   K.function_ "f" (K.Same_line (K.Name "a"));
                 ]
               K.Class "A")));
    case "a packed member that is documented is refused"
      (refuses
         (decl
            (K.Packed
               [
                 K.property ~about:(K.Doc "x") ~value:(K.Same_line (K.Int 1))
                   "x";
               ])));
    case "a body below its signature, and a try over several lines"
      (writes
         "fun f(): Int =\n\
         \    try {\n\
         \        g()\n\
         \    } catch (e: E) {\n\
         \        throw F(e)\n\
         \    }\n"
         (decl
            (K.function_ ~returns:(K.Type "Int") "f"
               (K.Below
                  (K.Try
                     {
                       body = K.call (K.Name "g") [];
                       caught = ("e", K.Type "E");
                       handler = K.Throw (K.call (K.Name "F") [ K.Name "e" ]);
                     })))));
    case "a constructor of one line refuses a documented parameter"
      (refuses
         (decl
            (K.class_
               ~constructor:
                 (K.constructor ~layout:K.Inline
                    [
                      K.param ~about:(K.Doc "x") ~binding:public_val "x"
                        (K.Type "Int");
                    ])
               K.Data_class "A")));
    case "imports are in ktlint's order, java's, javax's and kotlin's last"
      (writes
         "// b\n\
          @file:OptIn(X::class)\n\n\
          package p\n\n\
          import a.B\n\
          import kotlinx.C\n\
          import java.D\n\
          import kotlin.E\n\n\
          val x = 1\n" (fun () ->
           K.text
             {
               banner = [ "b" ];
               file_annotations =
                 [ K.annotation ~args:[ K.arg (K.Class_literal "X") ] "OptIn" ];
               package = "p";
               imports = [ "kotlin.E"; "java.D"; "kotlinx.C"; "a.B" ];
               decls = [ K.property ~value:(K.Same_line (K.Int 1)) "x" ];
             }));
    case "an assignment is written as a lambda's body"
      (writes "x.apply { this.a = b }"
         (expr
            (K.call
               ~lambda:
                 (K.Lambda ([], K.Assigning (K.Member (K.This, "a"), K.Name "b")))
               (K.Name "x.apply") [])));
    case "an assignment anywhere else is refused"
      (refuses (expr (K.Assigning (K.Name "a", K.Name "b"))));
    case
      "what declarations reference: a qualified name's first part, a member, \
       an annotation, and the types they name" (fun () ->
        Alcotest.(check (list string))
          "names"
          [ "A"; "B"; "C"; "Json"; "N"; "jsonObject" ]
          (K.referenced
             [
               K.property
                 ~annotations:[ K.annotation "N" ]
                 ~type_:(K.Generic ("A", [ K.Nullable (K.Type "B") ]))
                 ~value:
                   (K.Same_line
                      (K.Member
                         ( K.call (K.Name "Json.parse") [ K.Name "C" ],
                           "jsonObject" )))
                 "x";
             ]));
    case "a name imported twice is refused"
      (refuses (fun () -> String.concat "," (K.import_order [ "a.B"; "a.B" ])));
  ]

let () = Alcotest.run "kotlin_syntax" [ ("the printer", cases) ]
