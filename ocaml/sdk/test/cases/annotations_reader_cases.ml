(* Generated from protocol/specs/src/annotations/reader-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type reads = {
  body_source : string option;
  is_body_resolved : bool;
  target_source : string;
  target_selector : Yojson.Safe.t option;
  is_highlight : bool;
  is_reference : bool;
  is_assessment : bool;
  is_comment : bool;
  is_tag : bool;
  comment_text : string option;
  is_stub_reference : bool;
  is_resolved_reference : bool;
  exact_text : string;
  annotation_exact_text : string;
  text_quote_selector : Yojson.Safe.t option;
  entity_types : string list;
  tag_category : string option;
  tag_schema_id : string option;
}

let reads_json (r : reads) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some
           ( "bodySource",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.body_source );
         Option.Some ("isBodyResolved", (fun b -> `Bool b) r.is_body_resolved);
         Option.Some ("targetSource", (fun s -> `String s) r.target_source);
         Option.Some
           ( "targetSelector",
             (function Option.None -> `Null | Option.Some v -> Fun.id v)
               r.target_selector );
         Option.Some ("isHighlight", (fun b -> `Bool b) r.is_highlight);
         Option.Some ("isReference", (fun b -> `Bool b) r.is_reference);
         Option.Some ("isAssessment", (fun b -> `Bool b) r.is_assessment);
         Option.Some ("isComment", (fun b -> `Bool b) r.is_comment);
         Option.Some ("isTag", (fun b -> `Bool b) r.is_tag);
         Option.Some
           ( "commentText",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.comment_text );
         Option.Some ("isStubReference", (fun b -> `Bool b) r.is_stub_reference);
         Option.Some
           ("isResolvedReference", (fun b -> `Bool b) r.is_resolved_reference);
         Option.Some ("exactText", (fun s -> `String s) r.exact_text);
         Option.Some
           ("annotationExactText", (fun s -> `String s) r.annotation_exact_text);
         Option.Some
           ( "textQuoteSelector",
             (function Option.None -> `Null | Option.Some v -> Fun.id v)
               r.text_quote_selector );
         Option.Some
           ( "entityTypes",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.entity_types
           );
         Option.Some
           ( "tagCategory",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.tag_category );
         Option.Some
           ( "tagSchemaId",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.tag_schema_id );
       ])

type cases_item = { why : string; annotation : Yojson.Safe.t; reads : reads }

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("annotation", Fun.id r.annotation);
         Option.Some ("reads", reads_json r.reads);
       ])

type t = { comment : string; readers : string list; cases : cases_item list }

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ( "readers",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.readers );
         Option.Some
           ("cases", (fun l -> `List (List.map cases_item_json l)) r.cases);
       ])

let table : t =
  ({
     comment =
       "What each annotation reader answers, as every implementation must \
        answer it: Every SDK runs every case and fails on a difference. An \
        `annotation` is as the wire carries it. `reads` names each reader that \
        applies to it, by the name every SDK spells in its own convention \
        (`bodySource` is getBodySource, body_source), and what it answers: \
        `null` for nothing. A reader of a part is given that part: bodySource \
        and isBodyResolved the body, targetSource and targetSelector the \
        target, exactText and textQuoteSelector the target's selector. Every \
        case states every reader, and textQuoteSelector is null where the \
        target has no selector to give it. Add a case here before changing an \
        implementation.";
     readers =
       [
         "bodySource";
         "isBodyResolved";
         "targetSource";
         "targetSelector";
         "isHighlight";
         "isReference";
         "isAssessment";
         "isComment";
         "isTag";
         "commentText";
         "isStubReference";
         "isResolvedReference";
         "exactText";
         "annotationExactText";
         "textQuoteSelector";
         "entityTypes";
         "tagCategory";
         "tagSchemaId";
       ];
     cases =
       [
         ({
            why =
              "a highlight has no body, and the passage it marks is its quote \
               selector's exact text";
            annotation =
              `Assoc
                [
                  ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                  ("type", `String "Annotation");
                  ("id", `String "ann-1");
                  ("motivation", `String "highlighting");
                  ( "target",
                    `Assoc
                      [
                        ("source", `String "res-1");
                        ( "selector",
                          `Assoc
                            [
                              ("type", `String "TextQuoteSelector");
                              ("exact", `String "the quoted words");
                              ("prefix", `String "before ");
                              ("suffix", `String " after");
                            ] );
                      ] );
                  ("created", `String "2026-01-01T00:00:00.000Z");
                ];
            reads =
              ({
                 body_source = None;
                 is_body_resolved = false;
                 target_source = "res-1";
                 target_selector =
                   Some
                     (`Assoc
                        [
                          ("type", `String "TextQuoteSelector");
                          ("exact", `String "the quoted words");
                          ("prefix", `String "before ");
                          ("suffix", `String " after");
                        ]);
                 is_highlight = true;
                 is_reference = false;
                 is_assessment = false;
                 is_comment = false;
                 is_tag = false;
                 comment_text = None;
                 is_stub_reference = false;
                 is_resolved_reference = false;
                 exact_text = "the quoted words";
                 annotation_exact_text = "the quoted words";
                 text_quote_selector =
                   Some
                     (`Assoc
                        [
                          ("type", `String "TextQuoteSelector");
                          ("exact", `String "the quoted words");
                          ("prefix", `String "before ");
                          ("suffix", `String " after");
                        ]);
                 entity_types = [];
                 tag_category = None;
                 tag_schema_id = None;
               }
                : reads);
          }
           : cases_item);
         ({
            why =
              "a target that is only a resource's id names that resource and \
               has no selector: it quotes nothing; and a comment's text is its \
               one body's";
            annotation =
              `Assoc
                [
                  ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                  ("type", `String "Annotation");
                  ("id", `String "ann-2");
                  ("motivation", `String "commenting");
                  ("target", `String "res-1");
                  ( "body",
                    `Assoc
                      [
                        ("type", `String "TextualBody");
                        ("value", `String "A comment");
                        ("purpose", `String "commenting");
                      ] );
                  ("created", `String "2026-01-01T00:00:00.000Z");
                ];
            reads =
              ({
                 body_source = None;
                 is_body_resolved = false;
                 target_source = "res-1";
                 target_selector = None;
                 is_highlight = false;
                 is_reference = false;
                 is_assessment = false;
                 is_comment = true;
                 is_tag = false;
                 comment_text = Some "A comment";
                 is_stub_reference = false;
                 is_resolved_reference = false;
                 exact_text = "";
                 annotation_exact_text = "";
                 text_quote_selector = None;
                 entity_types = [];
                 tag_category = None;
                 tag_schema_id = None;
               }
                : reads);
          }
           : cases_item);
         ({
            why =
              "of several selectors, the quoted text is the quote selector's, \
               wherever in the list it is; and only a comment has comment text";
            annotation =
              `Assoc
                [
                  ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                  ("type", `String "Annotation");
                  ("id", `String "ann-3");
                  ("motivation", `String "assessing");
                  ( "target",
                    `Assoc
                      [
                        ("source", `String "res-1");
                        ( "selector",
                          `List
                            [
                              `Assoc
                                [
                                  ("type", `String "TextPositionSelector");
                                  ("start", `Int 4);
                                  ("end", `Int 20);
                                ];
                              `Assoc
                                [
                                  ("type", `String "TextQuoteSelector");
                                  ("exact", `String "the quoted words");
                                  ("prefix", `String "before ");
                                  ("suffix", `String " after");
                                ];
                            ] );
                      ] );
                  ( "body",
                    `List
                      [
                        `Assoc
                          [
                            ("type", `String "TextualBody");
                            ("value", `String "Unsupported claim");
                            ("purpose", `String "assessing");
                          ];
                      ] );
                  ("created", `String "2026-01-01T00:00:00.000Z");
                ];
            reads =
              ({
                 body_source = None;
                 is_body_resolved = false;
                 target_source = "res-1";
                 target_selector =
                   Some
                     (`List
                        [
                          `Assoc
                            [
                              ("type", `String "TextPositionSelector");
                              ("start", `Int 4);
                              ("end", `Int 20);
                            ];
                          `Assoc
                            [
                              ("type", `String "TextQuoteSelector");
                              ("exact", `String "the quoted words");
                              ("prefix", `String "before ");
                              ("suffix", `String " after");
                            ];
                        ]);
                 is_highlight = false;
                 is_reference = false;
                 is_assessment = true;
                 is_comment = false;
                 is_tag = false;
                 comment_text = None;
                 is_stub_reference = false;
                 is_resolved_reference = false;
                 exact_text = "the quoted words";
                 annotation_exact_text = "the quoted words";
                 text_quote_selector =
                   Some
                     (`Assoc
                        [
                          ("type", `String "TextQuoteSelector");
                          ("exact", `String "the quoted words");
                          ("prefix", `String "before ");
                          ("suffix", `String " after");
                        ]);
                 entity_types = [];
                 tag_category = None;
                 tag_schema_id = None;
               }
                : reads);
          }
           : cases_item);
         ({
            why =
              "a selector that quotes nothing has no exact text: a region of a \
               page is not a passage";
            annotation =
              `Assoc
                [
                  ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                  ("type", `String "Annotation");
                  ("id", `String "ann-4");
                  ("motivation", `String "highlighting");
                  ( "target",
                    `Assoc
                      [
                        ("source", `String "res-1");
                        ( "selector",
                          `Assoc
                            [
                              ("type", `String "FragmentSelector");
                              ("value", `String "page=1&viewrect=100,200,50,30");
                              ( "conformsTo",
                                `String "http://tools.ietf.org/rfc/rfc3778" );
                            ] );
                      ] );
                  ("created", `String "2026-01-01T00:00:00.000Z");
                ];
            reads =
              ({
                 body_source = None;
                 is_body_resolved = false;
                 target_source = "res-1";
                 target_selector =
                   Some
                     (`Assoc
                        [
                          ("type", `String "FragmentSelector");
                          ("value", `String "page=1&viewrect=100,200,50,30");
                          ( "conformsTo",
                            `String "http://tools.ietf.org/rfc/rfc3778" );
                        ]);
                 is_highlight = true;
                 is_reference = false;
                 is_assessment = false;
                 is_comment = false;
                 is_tag = false;
                 comment_text = None;
                 is_stub_reference = false;
                 is_resolved_reference = false;
                 exact_text = "";
                 annotation_exact_text = "";
                 text_quote_selector = None;
                 entity_types = [];
                 tag_category = None;
                 tag_schema_id = None;
               }
                : reads);
          }
           : cases_item);
         ({
            why =
              "a reference that links to nothing yet is a stub: it states its \
               entity types, in the order its body has them, and a body that \
               tags with no text states none; it is no tag, so it has no \
               category";
            annotation =
              `Assoc
                [
                  ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                  ("type", `String "Annotation");
                  ("id", `String "ann-5");
                  ("motivation", `String "linking");
                  ( "target",
                    `Assoc
                      [
                        ("source", `String "res-1");
                        ( "selector",
                          `Assoc
                            [
                              ("type", `String "TextQuoteSelector");
                              ("exact", `String "the quoted words");
                              ("prefix", `String "before ");
                              ("suffix", `String " after");
                            ] );
                      ] );
                  ( "body",
                    `List
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
                            ("value", `String "");
                            ("purpose", `String "tagging");
                          ];
                        `Assoc
                          [
                            ("type", `String "TextualBody");
                            ("value", `String "Scientist");
                            ("purpose", `String "tagging");
                          ];
                      ] );
                  ("created", `String "2026-01-01T00:00:00.000Z");
                ];
            reads =
              ({
                 body_source = None;
                 is_body_resolved = false;
                 target_source = "res-1";
                 target_selector =
                   Some
                     (`Assoc
                        [
                          ("type", `String "TextQuoteSelector");
                          ("exact", `String "the quoted words");
                          ("prefix", `String "before ");
                          ("suffix", `String " after");
                        ]);
                 is_highlight = false;
                 is_reference = true;
                 is_assessment = false;
                 is_comment = false;
                 is_tag = false;
                 comment_text = None;
                 is_stub_reference = true;
                 is_resolved_reference = false;
                 exact_text = "the quoted words";
                 annotation_exact_text = "the quoted words";
                 text_quote_selector =
                   Some
                     (`Assoc
                        [
                          ("type", `String "TextQuoteSelector");
                          ("exact", `String "the quoted words");
                          ("prefix", `String "before ");
                          ("suffix", `String " after");
                        ]);
                 entity_types = [ "Person"; "Scientist" ];
                 tag_category = None;
                 tag_schema_id = None;
               }
                : reads);
          }
           : cases_item);
         ({
            why =
              "a bound reference links to the FIRST resource its body names, \
               which is what the graph draws; a later one is not the link";
            annotation =
              `Assoc
                [
                  ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                  ("type", `String "Annotation");
                  ("id", `String "ann-6");
                  ("motivation", `String "linking");
                  ( "target",
                    `Assoc
                      [
                        ("source", `String "res-1");
                        ( "selector",
                          `Assoc
                            [
                              ("type", `String "TextQuoteSelector");
                              ("exact", `String "the quoted words");
                              ("prefix", `String "before ");
                              ("suffix", `String " after");
                            ] );
                      ] );
                  ( "body",
                    `List
                      [
                        `Assoc
                          [
                            ("type", `String "TextualBody");
                            ("value", `String "Person");
                            ("purpose", `String "tagging");
                          ];
                        `Assoc
                          [
                            ("type", `String "SpecificResource");
                            ("source", `String "res-2");
                            ("purpose", `String "linking");
                          ];
                        `Assoc
                          [
                            ("type", `String "SpecificResource");
                            ("source", `String "res-3");
                            ("purpose", `String "linking");
                          ];
                      ] );
                  ("created", `String "2026-01-01T00:00:00.000Z");
                ];
            reads =
              ({
                 body_source = Some "res-2";
                 is_body_resolved = true;
                 target_source = "res-1";
                 target_selector =
                   Some
                     (`Assoc
                        [
                          ("type", `String "TextQuoteSelector");
                          ("exact", `String "the quoted words");
                          ("prefix", `String "before ");
                          ("suffix", `String " after");
                        ]);
                 is_highlight = false;
                 is_reference = true;
                 is_assessment = false;
                 is_comment = false;
                 is_tag = false;
                 comment_text = None;
                 is_stub_reference = false;
                 is_resolved_reference = true;
                 exact_text = "the quoted words";
                 annotation_exact_text = "the quoted words";
                 text_quote_selector =
                   Some
                     (`Assoc
                        [
                          ("type", `String "TextQuoteSelector");
                          ("exact", `String "the quoted words");
                          ("prefix", `String "before ");
                          ("suffix", `String " after");
                        ]);
                 entity_types = [ "Person" ];
                 tag_category = None;
                 tag_schema_id = None;
               }
                : reads);
          }
           : cases_item);
         ({
            why =
              "a body that is one item and not a list is read as that item: \
               one linked resource";
            annotation =
              `Assoc
                [
                  ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                  ("type", `String "Annotation");
                  ("id", `String "ann-7");
                  ("motivation", `String "linking");
                  ("target", `String "res-1");
                  ( "body",
                    `Assoc
                      [
                        ("type", `String "SpecificResource");
                        ("source", `String "res-2");
                        ("purpose", `String "linking");
                      ] );
                  ("created", `String "2026-01-01T00:00:00.000Z");
                ];
            reads =
              ({
                 body_source = Some "res-2";
                 is_body_resolved = true;
                 target_source = "res-1";
                 target_selector = None;
                 is_highlight = false;
                 is_reference = true;
                 is_assessment = false;
                 is_comment = false;
                 is_tag = false;
                 comment_text = None;
                 is_stub_reference = false;
                 is_resolved_reference = true;
                 exact_text = "";
                 annotation_exact_text = "";
                 text_quote_selector = None;
                 entity_types = [];
                 tag_category = None;
                 tag_schema_id = None;
               }
                : reads);
          }
           : cases_item);
         ({
            why =
              "a body that is one tagging item and not a list states that \
               entity type";
            annotation =
              `Assoc
                [
                  ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                  ("type", `String "Annotation");
                  ("id", `String "ann-8");
                  ("motivation", `String "linking");
                  ("target", `String "res-1");
                  ( "body",
                    `Assoc
                      [
                        ("type", `String "TextualBody");
                        ("value", `String "Organization");
                        ("purpose", `String "tagging");
                      ] );
                  ("created", `String "2026-01-01T00:00:00.000Z");
                ];
            reads =
              ({
                 body_source = None;
                 is_body_resolved = false;
                 target_source = "res-1";
                 target_selector = None;
                 is_highlight = false;
                 is_reference = true;
                 is_assessment = false;
                 is_comment = false;
                 is_tag = false;
                 comment_text = None;
                 is_stub_reference = true;
                 is_resolved_reference = false;
                 exact_text = "";
                 annotation_exact_text = "";
                 text_quote_selector = None;
                 entity_types = [ "Organization" ];
                 tag_category = None;
                 tag_schema_id = None;
               }
                : reads);
          }
           : cases_item);
         ({
            why =
              "a tag's category is the body that tags and its schema the body \
               that classifies; and a body that tags is read as an entity type \
               whatever the annotation's motivation";
            annotation =
              `Assoc
                [
                  ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                  ("type", `String "Annotation");
                  ("id", `String "ann-9");
                  ("motivation", `String "tagging");
                  ( "target",
                    `Assoc
                      [
                        ("source", `String "res-1");
                        ( "selector",
                          `Assoc
                            [
                              ("type", `String "TextQuoteSelector");
                              ("exact", `String "the quoted words");
                              ("prefix", `String "before ");
                              ("suffix", `String " after");
                            ] );
                      ] );
                  ( "body",
                    `List
                      [
                        `Assoc
                          [
                            ("type", `String "TextualBody");
                            ("value", `String "Issue");
                            ("purpose", `String "tagging");
                          ];
                        `Assoc
                          [
                            ("type", `String "TextualBody");
                            ("value", `String "legal-irac");
                            ("purpose", `String "classifying");
                          ];
                      ] );
                  ("created", `String "2026-01-01T00:00:00.000Z");
                ];
            reads =
              ({
                 body_source = None;
                 is_body_resolved = false;
                 target_source = "res-1";
                 target_selector =
                   Some
                     (`Assoc
                        [
                          ("type", `String "TextQuoteSelector");
                          ("exact", `String "the quoted words");
                          ("prefix", `String "before ");
                          ("suffix", `String " after");
                        ]);
                 is_highlight = false;
                 is_reference = false;
                 is_assessment = false;
                 is_comment = false;
                 is_tag = true;
                 comment_text = None;
                 is_stub_reference = false;
                 is_resolved_reference = false;
                 exact_text = "the quoted words";
                 annotation_exact_text = "the quoted words";
                 text_quote_selector =
                   Some
                     (`Assoc
                        [
                          ("type", `String "TextQuoteSelector");
                          ("exact", `String "the quoted words");
                          ("prefix", `String "before ");
                          ("suffix", `String " after");
                        ]);
                 entity_types = [ "Issue" ];
                 tag_category = Some "Issue";
                 tag_schema_id = Some "legal-irac";
               }
                : reads);
          }
           : cases_item);
         ({
            why =
              "a comment whose body is a list says its first item's text; and \
               a body with no purpose states no entity type";
            annotation =
              `Assoc
                [
                  ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                  ("type", `String "Annotation");
                  ("id", `String "ann-10");
                  ("motivation", `String "commenting");
                  ( "target",
                    `Assoc
                      [
                        ("source", `String "res-1");
                        ( "selector",
                          `Assoc
                            [
                              ("type", `String "TextQuoteSelector");
                              ("exact", `String "the quoted words");
                              ("prefix", `String "before ");
                              ("suffix", `String " after");
                            ] );
                      ] );
                  ( "body",
                    `List
                      [
                        `Assoc
                          [
                            ("type", `String "TextualBody");
                            ("value", `String "First");
                          ];
                      ] );
                  ("created", `String "2026-01-01T00:00:00.000Z");
                ];
            reads =
              ({
                 body_source = None;
                 is_body_resolved = false;
                 target_source = "res-1";
                 target_selector =
                   Some
                     (`Assoc
                        [
                          ("type", `String "TextQuoteSelector");
                          ("exact", `String "the quoted words");
                          ("prefix", `String "before ");
                          ("suffix", `String " after");
                        ]);
                 is_highlight = false;
                 is_reference = false;
                 is_assessment = false;
                 is_comment = true;
                 is_tag = false;
                 comment_text = Some "First";
                 is_stub_reference = false;
                 is_resolved_reference = false;
                 exact_text = "the quoted words";
                 annotation_exact_text = "the quoted words";
                 text_quote_selector =
                   Some
                     (`Assoc
                        [
                          ("type", `String "TextQuoteSelector");
                          ("exact", `String "the quoted words");
                          ("prefix", `String "before ");
                          ("suffix", `String " after");
                        ]);
                 entity_types = [];
                 tag_category = None;
                 tag_schema_id = None;
               }
                : reads);
          }
           : cases_item);
       ];
   }
    : t)
