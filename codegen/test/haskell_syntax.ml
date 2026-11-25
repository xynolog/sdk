(* What the Haskell printer writes for what a writer states, and what it
   refuses to write. *)

open Xynolog_codegen
module H = Haskell_syntax

let case name test = Alcotest.test_case name `Quick test
let writes expected text () = Alcotest.(check string) "text" expected (text ())

let refuses text () =
  match text () with
  | written -> Alcotest.failf "wrote %S" written
  | exception Invalid_argument _ -> ()

let expr e () = H.expr ~depth:0 e
let decl d () = String.concat "\n" (H.decl d)

let cases =
  [
    case "a string literal escapes what is not printable ASCII"
      (writes {|"a\"\\\xe9\&\x1f600\&\xa\&"|}
         (expr (Str "a\"\\\195\169\240\159\152\128\n")));
    case "an application's argument that is one is parenthesised"
      (writes {|Row "x" (Just ["a"]) Nothing|}
         (expr
            (Apply
               ( Name "Row",
                 [
                   Str "x";
                   Apply (Name "Just", [ List [ Str "a" ] ]);
                   Name "Nothing";
                 ] ))));
    case "a name that is none is refused" (refuses (expr (Name "not-a-name")));
    case "a type's argument that is applied is parenthesised"
      (writes "x :: Map.Map Text (Vector.Vector Int)\nx = y"
         (decl
            (H.value "x"
               (T_apply
                  ( "Map.Map",
                    [
                      T_name "Text"; T_apply ("Vector.Vector", [ T_name "Int" ]);
                    ] ))
               (Name "y"))));
    case
      "a function's clauses are a line each, a constructor's held patterns \
       bracketed with it"
      (writes
         "name :: Kind -> Text\n\
          name A = \"a\"\n\
          name (C _ \"x\") = \"c\"\n\
          name B = \"b\""
         (decl
            (Value
               {
                 about = [];
                 name = "name";
                 type_ = T_fun (T_name "Kind", T_name "Text");
                 clauses =
                   [
                     { patterns = [ Constructor ("A", []) ]; body = Str "a" };
                     {
                       patterns =
                         [ Constructor ("C", [ Otherwise; Literal "x" ]) ];
                       body = Str "c";
                     };
                     { patterns = [ Constructor ("B", []) ]; body = Str "b" };
                   ];
               })));
    case "an instance of one line is written on its own line"
      (writes "instance ToJSON K where toJSON = String . name"
         (decl
            (H.instance "ToJSON" (T_name "K")
               [ H.method_ "toJSON" (Compose (Name "String", Name "name")) ])));
    case "a case puts each alternative on a line of its own"
      (writes
         "instance FromJSON K where\n\
         \  parseJSON = withText \"K\" $ \\value -> case value of\n\
         \    \"a\" -> pure A\n\
         \    _ -> fail \"no\""
         (decl
            (H.instance "FromJSON" (T_name "K")
               [
                 H.method_ "parseJSON"
                   (Dollar
                      ( Apply (Name "withText", [ Str "K" ]),
                        Lambda
                          ( "value",
                            Case
                              ( Name "value",
                                [
                                  ( Literal "a",
                                    Apply (Name "pure", [ Name "A" ]) );
                                  (Otherwise, Apply (Name "fail", [ Str "no" ]));
                                ] ) ) ));
               ])));
    case
      "an instance's context and head come before its clauses, a method's \
       patterns after its name"
      (writes
         "instance (ToJSON c) => ToJSON (Event c) where\n\
         \  toJSON (Done v) = object [\"kind\" .= (\"done\" :: Text), \"data\" \
          .= v]\n\
         \  toJSON Begun = object []"
         (decl
            (H.instance
               ~context:[ ("ToJSON", "c") ]
               "ToJSON"
               (T_apply ("Event", [ T_name "c" ]))
               [
                 ( "toJSON",
                   {
                     patterns = [ Constructor ("Done", [ Var "v" ]) ];
                     body =
                       Apply
                         ( Name "object",
                           [
                             List
                               [
                                 Infix
                                   ( Str "kind",
                                     [
                                       (".=", Typed (Str "done", T_name "Text"));
                                     ] );
                                 Infix (Str "data", [ (".=", Name "v") ]);
                               ];
                           ] );
                   } );
                 ( "toJSON",
                   {
                     patterns = [ Constructor ("Begun", []) ];
                     body = Apply (Name "object", [ List [] ]);
                   } );
               ])));
    case "an operand that is an operation is parenthesised"
      (writes {|R <$> (o .: "a") <*> (o .: "b")|}
         (expr
            (Infix
               ( Name "R",
                 [
                   ("<$>", Infix (Name "o", [ (".:", Str "a") ]));
                   ("<*>", Infix (Name "o", [ (".:", Str "b") ]));
                 ] ))));
    case "an operator that is none is refused"
      (refuses (expr (Infix (Name "a", [ ("plus", Name "b") ]))));
    case
      "a record writes a field a line, under its type's variables, and its \
       deriving clause after"
      (writes
         "data State v = State\n\
         \  { stateResults :: [v],\n\
         \    stateBusy :: Bool\n\
         \  }\n\
         \  deriving (Eq, Show)"
         (decl
            (H.record "State" ~constructor:"State" ~params:[ "v" ]
               ~deriving:[ "Eq"; "Show" ]
               [
                 ("stateResults", T_list (T_name "v"));
                 ("stateBusy", T_name "Bool");
               ])));
    case "a record is made by the constructor it names"
      (writes "data Line = MkLine\n  { lineText :: Text\n  }"
         (decl
            (H.record "Line" ~constructor:"MkLine"
               [ ("lineText", T_name "Text") ])));
    case "a newtype is made by the constructor it names"
      (writes "newtype Name = MkName Text"
         (decl
            (H.Newtype
               {
                 about = [];
                 name = "Name";
                 constructor = "MkName";
                 field = None;
                 type_ = T_name "Text";
                 opaque = false;
                 deriving = [];
               })));
    case "a record of no fields is refused"
      (refuses (decl (H.record "Empty" ~constructor:"Empty" [])));
    case "a doc comment's line is one line"
      (refuses (decl (H.alias ~about:[ "two\nlines" ] "A" (T_name "B"))));
    case
      "a module exports what it declares, in order, a blank line between its \
       parts"
      (writes
         "-- Generated from x; do not edit.\n\
          {-# LANGUAGE OverloadedStrings #-}\n\n\
          module M (K (..), k) where\n\n\
          import Data.Text (Text)\n\n\
          data K = A deriving (Eq)\n\n\
          k :: Text\n\
          k = \"a\"\n" (fun () ->
           H.text
             {
               banner = [ "Generated from x; do not edit." ];
               extensions = [ "OverloadedStrings" ];
               name = "M";
               imports = [ H.import "Data.Text" ~items:[ Plain "Text" ] ];
               body =
                 [
                   H.data "K" [ H.constructor "A" ] ~deriving:[ "Eq" ];
                   H.value "k" (T_name "Text") (Str "a");
                 ];
             }));
    case "a do block writes a statement a line, past the line it opens on"
      (writes
         "parseJSON = withObject \"R\" $ \\o -> do\n\
         \    v <- R <$> (o .: \"a\")\n\
         \    unless (all (`elem` [\"a\"]) (KM.keys o)) (fail \"x\")\n\
         \    pure v" (fun () ->
           "parseJSON = "
           ^ H.expr ~depth:1
               (Dollar
                  ( Apply (Name "withObject", [ Str "R" ]),
                    Lambda
                      ( "o",
                        Do
                          [
                            Bind
                              ( "v",
                                Infix
                                  ( Name "R",
                                    [
                                      ( "<$>",
                                        Infix (Name "o", [ (".:", Str "a") ]) );
                                    ] ) );
                            Run
                              (Apply
                                 ( Name "unless",
                                   [
                                     Apply
                                       ( Name "all",
                                         [
                                           Section ("elem", List [ Str "a" ]);
                                           Apply (Name "KM.keys", [ Name "o" ]);
                                         ] );
                                     Apply (Name "fail", [ Str "x" ]);
                                   ] ));
                            Run (Apply (Name "pure", [ Name "v" ]));
                          ] ) ))));
    case "a section of an operator waits for its left operand"
      (writes "(>= 0)" (expr (Section (">=", Int 0))));
    case "a record is built by its fields' names"
      (writes "f (R {a = 1, b = g x})"
         (expr
            (Apply
               ( Name "f",
                 [
                   Construct
                     ( "R",
                       [ ("a", Int 1); ("b", Apply (Name "g", [ Name "x" ])) ]
                     );
                 ] ))));
    case "a conditional's branches are expressions"
      (writes "f (if s == 1 then A else if s >= 5 then B else C)"
         (expr
            (Apply
               ( Name "f",
                 [
                   If
                     ( Infix (Name "s", [ ("==", Int 1) ]),
                       Name "A",
                       If
                         ( Infix (Name "s", [ (">=", Int 5) ]),
                           Name "B",
                           Name "C" ) );
                 ] ))));
    case "a GADT states each constructor's type, under its variables' kinds"
      (writes "data R (s :: Scope) a where\n  A :: R 'Global Text"
         (decl
            (Gadt
               {
                 about = [];
                 name = "R";
                 params = [ ("s", Some "Scope"); ("a", None) ];
                 constructors =
                   [
                     ("A", T_apply ("R", [ T_promoted "Global"; T_name "Text" ]));
                   ];
               })));
    case "a GADT of no constructors is refused"
      (refuses
         (decl
            (Gadt { about = []; name = "R"; params = []; constructors = [] })));
    case "an opaque newtype is exported without its constructor"
      (writes
         "module M (Id, Name (..)) where\n\n\
          newtype Id = Id Text deriving (Eq)\n\n\
          newtype Name = Name {nameText :: Text}\n" (fun () ->
           H.text
             {
               banner = [];
               extensions = [];
               name = "M";
               imports = [];
               body =
                 [
                   Newtype
                     {
                       about = [];
                       name = "Id";
                       constructor = "Id";
                       field = None;
                       type_ = T_name "Text";
                       opaque = true;
                       deriving = [ "Eq" ];
                     };
                   Newtype
                     {
                       about = [];
                       name = "Name";
                       constructor = "Name";
                       field = Some "nameText";
                       type_ = T_name "Text";
                       opaque = false;
                       deriving = [];
                     };
                 ];
             }));
    case "a private declaration is written but not exported"
      (writes "module P (f) where\n\nf :: Int\nf = g\n\ng :: Int\ng = 1\n"
         (fun () ->
           H.text
             {
               banner = [];
               extensions = [];
               name = "P";
               imports = [];
               body =
                 [
                   H.value "f" (T_name "Int") (Name "g");
                   Private (H.value "g" (T_name "Int") (Int 1));
                 ];
             }));
    case "a module re-exports what it imports whole"
      (writes "module T (module A) where\n\nimport A\n" (fun () ->
           H.text
             {
               banner = [];
               extensions = [];
               name = "T";
               imports = [ H.import "A" ];
               body = [ Reexport "A" ];
             }));
    case
      "imports are in ormolu's order: by module, and what each names by its \
       spelling, operators last"
      (writes
         "module O () where\n\n\
          import Data.Aeson (FromJSON (..), Value (Null, String), object, (.=))\n\
          import Data.Map qualified as Map\n" (fun () ->
           H.text
             {
               banner = [];
               extensions = [];
               name = "O";
               imports =
                 [
                   H.import "Data.Map" ~qualified:"Map";
                   H.import "Data.Aeson"
                     ~items:
                       [
                         Op ".=";
                         Plain "object";
                         With ("Value", [ "String"; "Null" ]);
                         All "FromJSON";
                       ];
                 ];
               body = [];
             }));
    case "what a module uses is told by namespace" (fun () ->
        let used =
          H.uses
            [
              H.value "f"
                (T_fun (T_name "String", T_name "Value"))
                (Apply (Name "String", [ Section ("<>", Name "x") ]));
            ]
        in
        Alcotest.(check (list string)) "types" [ "String"; "Value" ] used.types;
        Alcotest.(check (list string))
          "values" [ "<>"; "String"; "x" ] used.values);
  ]

let () = Alcotest.run "haskell_syntax" [ ("the printer", cases) ]
