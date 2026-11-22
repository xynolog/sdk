(* Generated from protocol/specs/src/annotations/builder-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type unstated = { cases : string list; resources : string list }

let unstated_json (r : unstated) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some
           ("cases", (fun l -> `List (List.map (fun s -> `String s) l)) r.cases);
         Option.Some
           ( "resources",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.resources );
       ])

type generator = {
  type_ : string;
  id : string option;
  provider : string option;
  model : string option;
  parameters : Yojson.Safe.t option;
}

let generator_json (r : generator) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("@type", (fun s -> `String s) r.type_);
         Option.map (fun v -> ("@id", (fun s -> `String s) v)) r.id;
         Option.map (fun v -> ("provider", (fun s -> `String s) v)) r.provider;
         Option.map (fun v -> ("model", (fun s -> `String s) v)) r.model;
         Option.map (fun v -> ("parameters", Fun.id v)) r.parameters;
       ])

type motivation = Assessing | Commenting | Highlighting | Linking | Tagging

let motivation_value = function
  | (Assessing : motivation) -> "assessing"
  | (Commenting : motivation) -> "commenting"
  | (Highlighting : motivation) -> "highlighting"
  | (Linking : motivation) -> "linking"
  | (Tagging : motivation) -> "tagging"

let motivation_json v = `String (motivation_value v)

type text_built = {
  why : string;
  text : string;
  resource_id : string;
  generator : generator;
  motivation : motivation;
  span : Yojson.Safe.t;
  body : Yojson.Safe.t option;
  annotation : Yojson.Safe.t;
}

let text_built_json (r : text_built) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("text", (fun s -> `String s) r.text);
         Option.Some ("resourceId", (fun s -> `String s) r.resource_id);
         Option.Some ("generator", generator_json r.generator);
         Option.Some ("motivation", motivation_json r.motivation);
         Option.Some ("span", Fun.id r.span);
         Option.map (fun v -> ("body", Fun.id v)) r.body;
         Option.Some ("annotation", Fun.id r.annotation);
       ])

type span = {
  start : float;
  end_ : float;
  exact : string;
  prefix : string option;
  suffix : string option;
}

let span_json (r : span) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("start", (fun f -> `Float f) r.start);
         Option.Some ("end", (fun f -> `Float f) r.end_);
         Option.Some ("exact", (fun s -> `String s) r.exact);
         Option.map (fun v -> ("prefix", (fun s -> `String s) v)) r.prefix;
         Option.map (fun v -> ("suffix", (fun s -> `String s) v)) r.suffix;
       ])

type text_refused = {
  why : string;
  text : string;
  resource_id : string;
  generator : generator;
  motivation : motivation;
  span : span;
  body : Yojson.Safe.t option;
  refused : string;
}

let text_refused_json (r : text_refused) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("text", (fun s -> `String s) r.text);
         Option.Some ("resourceId", (fun s -> `String s) r.resource_id);
         Option.Some ("generator", generator_json r.generator);
         Option.Some ("motivation", motivation_json r.motivation);
         Option.Some ("span", span_json r.span);
         Option.map (fun v -> ("body", Fun.id v)) r.body;
         Option.Some ("refused", (fun s -> `String s) r.refused);
       ])

type pdf_built = {
  why : string;
  anchored : Yojson.Safe.t;
  resource_id : string;
  generator : generator;
  motivation : motivation;
  span : Yojson.Safe.t;
  body : Yojson.Safe.t option;
  annotation : Yojson.Safe.t;
}

let pdf_built_json (r : pdf_built) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("anchored", Fun.id r.anchored);
         Option.Some ("resourceId", (fun s -> `String s) r.resource_id);
         Option.Some ("generator", generator_json r.generator);
         Option.Some ("motivation", motivation_json r.motivation);
         Option.Some ("span", Fun.id r.span);
         Option.map (fun v -> ("body", Fun.id v)) r.body;
         Option.Some ("annotation", Fun.id r.annotation);
       ])

type pdf_refused = {
  why : string;
  anchored : Yojson.Safe.t;
  resource_id : string;
  generator : generator;
  motivation : motivation;
  span : span;
  body : Yojson.Safe.t option;
  refused : string;
}

let pdf_refused_json (r : pdf_refused) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("anchored", Fun.id r.anchored);
         Option.Some ("resourceId", (fun s -> `String s) r.resource_id);
         Option.Some ("generator", generator_json r.generator);
         Option.Some ("motivation", motivation_json r.motivation);
         Option.Some ("span", span_json r.span);
         Option.map (fun v -> ("body", Fun.id v)) r.body;
         Option.Some ("refused", (fun s -> `String s) r.refused);
       ])

type cases_item =
  | Text_built of text_built
  | Text_refused of text_refused
  | Pdf_built of pdf_built
  | Pdf_refused of pdf_refused

let cases_item_json = function
  | (Text_built v : cases_item) -> text_built_json v
  | (Text_refused v : cases_item) -> text_refused_json v
  | (Pdf_built v : cases_item) -> pdf_built_json v
  | (Pdf_refused v : cases_item) -> pdf_refused_json v

type resources_item = {
  why : string;
  resource_id : string;
  motivation : motivation;
  generator : generator option;
  body : Yojson.Safe.t option;
  annotation : Yojson.Safe.t;
}

let resources_item_json (r : resources_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("resourceId", (fun s -> `String s) r.resource_id);
         Option.Some ("motivation", motivation_json r.motivation);
         Option.map (fun v -> ("generator", generator_json v)) r.generator;
         Option.map (fun v -> ("body", Fun.id v)) r.body;
         Option.Some ("annotation", Fun.id r.annotation);
       ])

type t = {
  comment : string;
  unstated : unstated;
  builders : string list;
  cases : cases_item list;
  resources : resources_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some ("unstated", unstated_json r.unstated);
         Option.Some
           ( "builders",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.builders );
         Option.Some
           ("cases", (fun l -> `List (List.map cases_item_json l)) r.cases);
         Option.Some
           ( "resources",
             (fun l -> `List (List.map resources_item_json l)) r.resources );
       ])

let table : t =
  ({
     comment =
       "The annotation a worker commits, whole, as every implementation must \
        build it. What a job leaves in the knowledge base is these \
        annotations, so two workers that build them differently leave \
        different records of the same work. Every SDK runs every case and \
        fails on a difference: `annotationOfSpan` runs `cases`, and \
        `annotationOfResource` runs `resources`. `cases` BUILD the annotation \
        of a span found in a resource's text. A case gives `text` when the \
        resource is a text, or `anchored`, a PDF's anchored text as \
        pdf-locate-cases.json describes it, when it is a PDF. With it come the \
        `resourceId`; the `generator`, which says what made the annotation; \
        the `motivation`; the `span`, which is its `start` and `end`, the \
        `exact` words, and maybe the `prefix` and `suffix` (as \
        reconcile-cases.json reconciles one), `start` and `end` being offsets, \
        which count the text's Unicode code points; and maybe a `body`, one \
        body or a list of them. The answer is the `annotation`, or `refused` \
        and which refusal. EVERY BUILT ANNOTATION has `@context` \
        \"http://www.w3.org/ns/anno.jsonld\" and `type` \"Annotation\"; the \
        `motivation`; the `generator` as given; the `body` as given, and no \
        `body` member when none was; a `target` whose `type` is \
        \"SpecificResource\", whose `source` is the resource id and whose \
        `selector` is a list; and an `id` derived as id-cases.json says from \
        the resource id, the motivation, the body if there is one, and this \
        anchor: the span's `start` in decimal, a colon, its `end` in decimal, \
        a colon, and its `exact`. The anchor is made the same way for a text \
        and for a PDF. An annotation of a resource as a whole has no span, and \
        its anchor is the empty string: the link a worker commits from a \
        resource to the one it generated from it is such an annotation. \
        Nothing in the annotation says who asked for it: that is derived where \
        the annotation is recorded. The last selector is a TextQuoteSelector \
        with the span's `exact`, and with its `prefix` and its `suffix` when \
        they are given and not empty. A SPAN IS CHECKED before anything is \
        built, and the first check that fails is the refusal. Its `start` and \
        `end` must be two whole numbers, with `start` at least 0, `end` at \
        least `start`, and `end` at most the length in code points of the text \
        (for a PDF, of the anchored text): a span given backwards, one that \
        runs past the end, one that starts below zero and one stated in \
        fractions are each refused (`span-out-of-range`), whatever words lie \
        between. FOR A TEXT the selector before the quote is a \
        TextPositionSelector with the span's `start` and `end`. The annotation \
        is then refused if the text from `start` to `end` is not `exact` \
        (`exact-mismatch`); or a prefix is given and is not the text just \
        before `start`, as many code points of it as the prefix has, or all \
        there are if fewer (`prefix-mismatch`); or a suffix is given and is \
        not the text just after `end`, in the same way (`suffix-mismatch`). \
        FOR A PDF the anchored text is held to itself before the span is held \
        to it. Every item's `start` and `end` must be two whole numbers, with \
        `start` at least 0, `end` at least `start`, and `end` at most the \
        length in code points of the anchored text. An item that is not, \
        whether the span touches it or not, refuses the span \
        (`item-out-of-range`), and this check comes before every other: the \
        items are what say where the text is on a page, and one that is no \
        stretch of the text shows that they do not index it, so that a \
        rectangle made from any of them may be drawn in the wrong place. There \
        is no TextPositionSelector. The span is located as \
        pdf-locate-cases.json says, and before the quote comes one \
        FragmentSelector for each rectangle, in their order, with `conformsTo` \
        \"http://tools.ietf.org/rfc/rfc3778\" and the rectangle's fragment as \
        its `value`. The annotation is then refused if the span is located \
        nowhere (`nothing-located`), or if `exact` is not in the covered text \
        (`exact-not-covered`): the covered text is the anchored text from the \
        least `start` to the greatest `end` of the items the span overlaps, \
        and both it and `exact` have every run of white space made one space, \
        and the white space at their ends dropped, before the one is looked \
        for in the other. Its prefix and its suffix are then checked against \
        the anchored text exactly as a text span's are against its text, with \
        the same two refusals. `resources` BUILD an annotation of a resource \
        as a whole, which has no span: the link from a resource to the one \
        generated from it is one. A case gives the `resourceId`, the \
        `motivation`, and maybe a `generator` and a `body`. The `annotation` \
        has `@context` and `type` as above; the `motivation`; the `generator` \
        if one was given; the `body` as given, and no `body` member when none \
        was; a `target` that is the resource's id as its `source`, and nothing \
        else; and an `id` derived as id-cases.json says, with the anchor the \
        empty string. `builders` names what builds: `reconcile`, which finds \
        the words a model quoted in a text and is held by \
        reconcile-cases.json; `annotationOfSpan`, which `cases` hold; and \
        `annotationOfResource`, which `resources` hold. Every SDK has the \
        three, each spelled in its own convention (`annotationOfSpan` is \
        annotation_of_span), and no other builder. `unstated` names, for \
        `cases` and for `resources`, the member every built annotation has and \
        no case can state: `created`, the moment it was built, an RFC 3339 \
        date-time in UTC to the millisecond. A runner checks that each is \
        there and compares everything else. White space is what Unicode gives \
        the White_Space property; no case rests on U+0085 or U+FEFF, about \
        which implementations disagree. What an offset counts is stated in a \
        table of its own (specs/src/text/offset-cases.json): code points, and \
        so does every length here. The cases whose text has a character \
        outside the Basic Multilingual Plane are the ones that tell that count \
        from a count of UTF-16 code units. Add a case here before changing an \
        implementation.";
     unstated =
       ({ cases = [ "created" ]; resources = [ "created" ] } : unstated);
     builders = [ "reconcile"; "annotationOfSpan"; "annotationOfResource" ];
     cases =
       [
         (Text_built
            ({
               why =
                 "a highlight of a text: no body, a position and a quote, and \
                  the id of the anchor `0:12:Ada Lovelace` (the first case of \
                  id-cases.json)";
               text = "Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 12);
                     ("exact", `String "Ada Lovelace");
                   ];
               body = None;
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "8yQdnrBndVZasyRD7ORRX");
                     ("motivation", `String "highlighting");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "TextPositionSelector");
                                     ("start", `Int 0);
                                     ("end", `Int 12);
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ("exact", `String "Ada Lovelace");
                                   ];
                               ] );
                         ] );
                   ];
             }
              : text_built)
           : cases_item);
         (Text_built
            ({
               why =
                 "a comment on a text: the body is carried as given and goes \
                  into the id; the prefix and suffix, which are what the text \
                  has on either side, are written into the quote and are no \
                  part of the id";
               text = "Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Commenting : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 13);
                     ("end", `Int 18);
                     ("exact", `String "wrote");
                     ("prefix", `String "Ada Lovelace ");
                     ("suffix", `String " the first algorithm.");
                   ];
               body =
                 Some
                   (`List
                      [
                        `Assoc
                          [
                            ("type", `String "TextualBody");
                            ("value", `String "a verb");
                            ("purpose", `String "commenting");
                            ("format", `String "text/plain");
                          ];
                      ]);
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "eTgxnCP0D9xM17AZIl7S_");
                     ("motivation", `String "commenting");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "TextPositionSelector");
                                     ("start", `Int 13);
                                     ("end", `Int 18);
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ("exact", `String "wrote");
                                     ("prefix", `String "Ada Lovelace ");
                                     ("suffix", `String " the first algorithm.");
                                   ];
                               ] );
                         ] );
                     ( "body",
                       `List
                         [
                           `Assoc
                             [
                               ("type", `String "TextualBody");
                               ("value", `String "a verb");
                               ("purpose", `String "commenting");
                               ("format", `String "text/plain");
                             ];
                         ] );
                   ];
             }
              : text_built)
           : cases_item);
         (Text_built
            ({
               why =
                 "a span that is the whole text has nothing before or after \
                  it: its empty prefix and suffix pass the check and are not \
                  written into the quote";
               text = "Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 39);
                     ("exact", `String "Ada Lovelace wrote the first algorithm.");
                     ("prefix", `String "");
                     ("suffix", `String "");
                   ];
               body = None;
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "lBxliU73D1-YYmKhQhYbf");
                     ("motivation", `String "highlighting");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "TextPositionSelector");
                                     ("start", `Int 0);
                                     ("end", `Int 39);
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ( "exact",
                                       `String
                                         "Ada Lovelace wrote the first \
                                          algorithm." );
                                   ];
                               ] );
                         ] );
                   ];
             }
              : text_built)
           : cases_item);
         (Text_built
            ({
               why =
                 "a reference found in a text, whose body is the one object \
                  naming its entity type: carried as one object, not made a \
                  list; and a generator that states the parameters it ran with \
                  is carried with them";
               text = "Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters =
                      Some
                        (`Assoc
                           [ ("temperature", `Int 0); ("maxTokens", `Int 2048) ]);
                  }
                   : generator);
               motivation = (Linking : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 12);
                     ("exact", `String "Ada Lovelace");
                   ];
               body =
                 Some
                   (`Assoc
                      [
                        ("type", `String "TextualBody");
                        ("value", `String "Person");
                        ("purpose", `String "tagging");
                      ]);
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "xvw-OmqM0xvv7bmfSzDrA");
                     ("motivation", `String "linking");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                           ( "parameters",
                             `Assoc
                               [
                                 ("temperature", `Int 0);
                                 ("maxTokens", `Int 2048);
                               ] );
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "TextPositionSelector");
                                     ("start", `Int 0);
                                     ("end", `Int 12);
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ("exact", `String "Ada Lovelace");
                                   ];
                               ] );
                         ] );
                     ( "body",
                       `Assoc
                         [
                           ("type", `String "TextualBody");
                           ("value", `String "Person");
                           ("purpose", `String "tagging");
                         ] );
                   ];
             }
              : text_built)
           : cases_item);
         (Text_refused
            ({
               why =
                 "the text at the span is not the words it is said to be: \
                  refused, not built";
               text = "Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 0.;
                    end_ = 12.;
                    exact = "Grace Hopper";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "exact-mismatch";
             }
              : text_refused)
           : cases_item);
         (Text_refused
            ({
               why =
                 "a prefix that is not what the text has just before the span: \
                  the eight characters before `wrote` are `ovelace ` with its \
                  space, not `Lovelace`";
               text = "Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 13.;
                    end_ = 18.;
                    exact = "wrote";
                    prefix = Some "Lovelace";
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "prefix-mismatch";
             }
              : text_refused)
           : cases_item);
         (Text_refused
            ({
               why =
                 "a prefix longer than all the text there is before the span \
                  cannot be that text";
               text = "Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 4.;
                    end_ = 12.;
                    exact = "Lovelace";
                    prefix = Some "Countess Ada ";
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "prefix-mismatch";
             }
              : text_refused)
           : cases_item);
         (Text_refused
            ({
               why =
                 "a suffix that is not what the text has just after the span";
               text = "Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 13.;
                    end_ = 18.;
                    exact = "wrote";
                    prefix = None;
                    suffix = Some " a first";
                  }
                   : span);
               body = None;
               refused = "suffix-mismatch";
             }
              : text_refused)
           : cases_item);
         (Text_refused
            ({
               why =
                 "a suffix is the text just after the span, not text somewhere \
                  after it: ` the first` comes after `Lovelace`, and not next \
                  to it";
               text = "Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 4.;
                    end_ = 12.;
                    exact = "Lovelace";
                    prefix = None;
                    suffix = Some " the first";
                  }
                   : span);
               body = None;
               refused = "suffix-mismatch";
             }
              : text_refused)
           : cases_item);
         (Text_refused
            ({
               why =
                 "a suffix longer than all the text there is after the span \
                  cannot be that text";
               text = "Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 29.;
                    end_ = 38.;
                    exact = "algorithm";
                    prefix = None;
                    suffix = Some ". The end";
                  }
                   : span);
               body = None;
               refused = "suffix-mismatch";
             }
              : text_refused)
           : cases_item);
         (Text_built
            ({
               why =
                 "a span after a character outside the Basic Multilingual \
                  Plane: its offsets count code points, so `Ada Lovelace` is \
                  from 2 to 14, the emoji before it being one; and the id is \
                  of the anchor `2:14:Ada Lovelace`";
               text = "\240\159\152\128 Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 2);
                     ("end", `Int 14);
                     ("exact", `String "Ada Lovelace");
                   ];
               body = None;
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "KxmaWULQ3qhFn7N21Bk5r");
                     ("motivation", `String "highlighting");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "TextPositionSelector");
                                     ("start", `Int 2);
                                     ("end", `Int 14);
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ("exact", `String "Ada Lovelace");
                                   ];
                               ] );
                         ] );
                   ];
             }
              : text_built)
           : cases_item);
         (Text_refused
            ({
               why =
                 "the same words stated where a count of UTF-16 code units \
                  would put them, from 3 to 15, are not the words the text has \
                  there: refused";
               text = "\240\159\152\128 Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 3.;
                    end_ = 15.;
                    exact = "Ada Lovelace";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "exact-mismatch";
             }
              : text_refused)
           : cases_item);
         (Text_built
            ({
               why =
                 "a span that is itself of characters outside the plane is two \
                  code points long, and they are written into the quote and \
                  the anchor as themselves";
               text =
                 "\240\159\152\128 said \240\157\145\165\240\157\145\166 holds";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Commenting : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 7);
                     ("end", `Int 9);
                     ("exact", `String "\240\157\145\165\240\157\145\166");
                     ("prefix", `String "\240\159\152\128 said ");
                     ("suffix", `String " holds");
                   ];
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
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "EC6ecBvKDj4WZEcB_2k2z");
                     ("motivation", `String "commenting");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "TextPositionSelector");
                                     ("start", `Int 7);
                                     ("end", `Int 9);
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ( "exact",
                                       `String
                                         "\240\157\145\165\240\157\145\166" );
                                     ("prefix", `String "\240\159\152\128 said ");
                                     ("suffix", `String " holds");
                                   ];
                               ] );
                         ] );
                     ( "body",
                       `List
                         [
                           `Assoc
                             [
                               ("type", `String "TextualBody");
                               ("value", `String "a product \240\159\142\137");
                               ("purpose", `String "commenting");
                               ("format", `String "text/plain");
                             ];
                         ] );
                   ];
             }
              : text_built)
           : cases_item);
         (Text_built
            ({
               why =
                 "a prefix is as many code points of the text as it has \
                  itself: nine, of which two are emoji, and the text before \
                  them is no part of it";
               text =
                 "Intro. Rated \240\159\142\137\240\159\142\137 good, then \
                  \240\159\152\128 bad. Outro.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 16);
                     ("end", `Int 20);
                     ("exact", `String "good");
                     ( "prefix",
                       `String "Rated \240\159\142\137\240\159\142\137 " );
                   ];
               body = None;
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "qEMILkz17tkjk3SmlwRU_");
                     ("motivation", `String "highlighting");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "TextPositionSelector");
                                     ("start", `Int 16);
                                     ("end", `Int 20);
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ("exact", `String "good");
                                     ( "prefix",
                                       `String
                                         "Rated \
                                          \240\159\142\137\240\159\142\137 " );
                                   ];
                               ] );
                         ] );
                   ];
             }
              : text_built)
           : cases_item);
         (Text_built
            ({
               why =
                 "a suffix is counted the same way: eight code points, the \
                  emoji one of them, and the text after them is no part of it";
               text =
                 "Intro. Rated \240\159\142\137\240\159\142\137 good, then \
                  \240\159\152\128 bad. Outro.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 16);
                     ("end", `Int 20);
                     ("exact", `String "good");
                     ("suffix", `String ", then \240\159\152\128");
                   ];
               body = None;
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "qEMILkz17tkjk3SmlwRU_");
                     ("motivation", `String "highlighting");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "TextPositionSelector");
                                     ("start", `Int 16);
                                     ("end", `Int 20);
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ("exact", `String "good");
                                     ( "suffix",
                                       `String ", then \240\159\152\128" );
                                   ];
                               ] );
                         ] );
                   ];
             }
              : text_built)
           : cases_item);
         (Text_refused
            ({
               why =
                 "a suffix longer than all the text there is after the span \
                  cannot be that text, where the text is shorter in code \
                  points than a string of it is in UTF-16 code units";
               text = "\240\159\152\128 Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 31.;
                    end_ = 40.;
                    exact = "algorithm";
                    prefix = None;
                    suffix = Some ". The end";
                  }
                   : span);
               body = None;
               refused = "suffix-mismatch";
             }
              : text_refused)
           : cases_item);
         (Text_refused
            ({
               why =
                 "a span given backwards is refused, though the words between \
                  its two offsets are the words it states";
               text = "Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 12.;
                    end_ = 0.;
                    exact = "Ada Lovelace";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "span-out-of-range";
             }
              : text_refused)
           : cases_item);
         (Text_refused
            ({
               why =
                 "a span that runs past the end of the text is refused, though \
                  the text from its start to the end is the words it states: \
                  the text is 39 code points long";
               text = "Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 29.;
                    end_ = 45.;
                    exact = "algorithm.";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "span-out-of-range";
             }
              : text_refused)
           : cases_item);
         (Text_refused
            ({
               why =
                 "a span that starts below zero is refused, though the text \
                  from 0 to its end is the words it states";
               text = "Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = -3.;
                    end_ = 12.;
                    exact = "Ada Lovelace";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "span-out-of-range";
             }
              : text_refused)
           : cases_item);
         (Text_refused
            ({
               why =
                 "an offset is a whole number: a span stated in fractions is \
                  refused";
               text = "Ada Lovelace wrote the first algorithm.";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 0.5;
                    end_ = 12.;
                    exact = "Ada Lovelace";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "span-out-of-range";
             }
              : text_refused)
           : cases_item);
         (Text_refused
            ({
               why =
                 "the length a span must end within is the text's in code \
                  points: this text is 14 of them, the emoji being one, and a \
                  span that ends at 15, the length of a string of it in UTF-16 \
                  code units, runs past the end";
               text = "\240\159\152\128 Ada Lovelace";
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 2.;
                    end_ = 15.;
                    exact = "Ada Lovelace";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "span-out-of-range";
             }
              : text_refused)
           : cases_item);
         (Pdf_built
            ({
               why =
                 "a highlight of a PDF, on one line: one rectangle and the \
                  quote, no position; its id is of the anchor `0:10:alpha \
                  beta`, made as a text's is";
               anchored =
                 `Assoc
                   [
                     ("text", `String "alpha beta\ngamma delta");
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 5);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 6);
                               ("end", `Int 10);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 11);
                               ("end", `Int 16);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 45);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 17);
                               ("end", `Int 22);
                               ("page", `Int 1);
                               ("x", `Int 125);
                               ("y", `Int 700);
                               ("width", `Int 42);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 0);
                     ("end", `Int 10);
                     ("exact", `String "alpha beta");
                   ];
               body = None;
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "8mzsO4oS88lXiAeLOZ1ER");
                     ("motivation", `String "highlighting");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "FragmentSelector");
                                     ( "conformsTo",
                                       `String
                                         "http://tools.ietf.org/rfc/rfc3778" );
                                     ( "value",
                                       `String "page=1&viewrect=72,720,80,12" );
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ("exact", `String "alpha beta");
                                   ];
                               ] );
                         ] );
                   ];
             }
              : pdf_built)
           : cases_item);
         (Pdf_built
            ({
               why =
                 "a comment on a PDF span that runs over two lines: a \
                  rectangle for each, the upper first, then the quote with the \
                  line break in it as the anchored text has it; the body and \
                  the context are carried as for a text";
               anchored =
                 `Assoc
                   [
                     ("text", `String "alpha beta\ngamma delta");
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 5);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 6);
                               ("end", `Int 10);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 11);
                               ("end", `Int 16);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 45);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 17);
                               ("end", `Int 22);
                               ("page", `Int 1);
                               ("x", `Int 125);
                               ("y", `Int 700);
                               ("width", `Int 42);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Commenting : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 6);
                     ("end", `Int 16);
                     ("exact", `String "beta\ngamma");
                     ("prefix", `String "alpha ");
                     ("suffix", `String " delta");
                   ];
               body =
                 Some
                   (`List
                      [
                        `Assoc
                          [
                            ("type", `String "TextualBody");
                            ("value", `String "a note");
                            ("purpose", `String "commenting");
                            ("format", `String "text/plain");
                          ];
                      ]);
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "p2dUyK-07YuB-QXSOiLeI");
                     ("motivation", `String "commenting");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "FragmentSelector");
                                     ( "conformsTo",
                                       `String
                                         "http://tools.ietf.org/rfc/rfc3778" );
                                     ( "value",
                                       `String "page=1&viewrect=118,720,34,12"
                                     );
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "FragmentSelector");
                                     ( "conformsTo",
                                       `String
                                         "http://tools.ietf.org/rfc/rfc3778" );
                                     ( "value",
                                       `String "page=1&viewrect=72,700,45,12" );
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ("exact", `String "beta\ngamma");
                                     ("prefix", `String "alpha ");
                                     ("suffix", `String " delta");
                                   ];
                               ] );
                         ] );
                     ( "body",
                       `List
                         [
                           `Assoc
                             [
                               ("type", `String "TextualBody");
                               ("value", `String "a note");
                               ("purpose", `String "commenting");
                               ("format", `String "text/plain");
                             ];
                         ] );
                   ];
             }
              : pdf_built)
           : cases_item);
         (Pdf_built
            ({
               why =
                 "a PDF span's words need only be in the covered text once \
                  white space is collapsed: `beta gamma` with a space is in \
                  `beta`, a line break, `gamma`; the quote and the anchor keep \
                  the words as they were given";
               anchored =
                 `Assoc
                   [
                     ("text", `String "alpha beta\ngamma delta");
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 5);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 6);
                               ("end", `Int 10);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 11);
                               ("end", `Int 16);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 45);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 17);
                               ("end", `Int 22);
                               ("page", `Int 1);
                               ("x", `Int 125);
                               ("y", `Int 700);
                               ("width", `Int 42);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 6);
                     ("end", `Int 16);
                     ("exact", `String "beta gamma");
                   ];
               body = None;
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "1Aqkd45MCQ6e-tkvEeO3f");
                     ("motivation", `String "highlighting");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "FragmentSelector");
                                     ( "conformsTo",
                                       `String
                                         "http://tools.ietf.org/rfc/rfc3778" );
                                     ( "value",
                                       `String "page=1&viewrect=118,720,34,12"
                                     );
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "FragmentSelector");
                                     ( "conformsTo",
                                       `String
                                         "http://tools.ietf.org/rfc/rfc3778" );
                                     ( "value",
                                       `String "page=1&viewrect=72,700,45,12" );
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ("exact", `String "beta gamma");
                                   ];
                               ] );
                         ] );
                   ];
             }
              : pdf_built)
           : cases_item);
         (Pdf_built
            ({
               why =
                 "a citation in a generated PDF: a link whose body is the one \
                  object naming the resource cited";
               anchored =
                 `Assoc
                   [
                     ("text", `String "alpha beta\ngamma delta");
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 5);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 6);
                               ("end", `Int 10);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 11);
                               ("end", `Int 16);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 45);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 17);
                               ("end", `Int 22);
                               ("page", `Int 1);
                               ("x", `Int 125);
                               ("y", `Int 700);
                               ("width", `Int 42);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Linking : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 11);
                     ("end", `Int 22);
                     ("exact", `String "gamma delta");
                   ];
               body =
                 Some
                   (`Assoc
                      [
                        ("type", `String "SpecificResource");
                        ("source", `String "res-2");
                        ("purpose", `String "linking");
                      ]);
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "fnGCAyZpliTKBHb049emL");
                     ("motivation", `String "linking");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "FragmentSelector");
                                     ( "conformsTo",
                                       `String
                                         "http://tools.ietf.org/rfc/rfc3778" );
                                     ( "value",
                                       `String "page=1&viewrect=72,700,95,12" );
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ("exact", `String "gamma delta");
                                   ];
                               ] );
                         ] );
                     ( "body",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-2");
                           ("purpose", `String "linking");
                         ] );
                   ];
             }
              : pdf_built)
           : cases_item);
         (Pdf_refused
            ({
               why =
                 "a PDF span that no item overlaps has no rectangle to anchor \
                  it: the line break between `beta` and `gamma` is in the \
                  anchored text and in no item";
               anchored =
                 `Assoc
                   [
                     ("text", `String "alpha beta\ngamma delta");
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 5);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 6);
                               ("end", `Int 10);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 11);
                               ("end", `Int 16);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 45);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 17);
                               ("end", `Int 22);
                               ("page", `Int 1);
                               ("x", `Int 125);
                               ("y", `Int 700);
                               ("width", `Int 42);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 10.;
                    end_ = 11.;
                    exact = "\n";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "nothing-located";
             }
              : pdf_refused)
           : cases_item);
         (Pdf_refused
            ({
               why =
                 "a PDF span whose rectangles would be drawn round other words \
                  than it quotes: the covered text is `alpha`, which does not \
                  have `gamma` in it";
               anchored =
                 `Assoc
                   [
                     ("text", `String "alpha beta\ngamma delta");
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 5);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 6);
                               ("end", `Int 10);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 11);
                               ("end", `Int 16);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 45);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 17);
                               ("end", `Int 22);
                               ("page", `Int 1);
                               ("x", `Int 125);
                               ("y", `Int 700);
                               ("width", `Int 42);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 0.;
                    end_ = 5.;
                    exact = "gamma";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "exact-not-covered";
             }
              : pdf_refused)
           : cases_item);
         (Pdf_built
            ({
               why =
                 "a highlight of a PDF whose text has an emoji before the \
                  span: the items count code points, so `beta` is the item \
                  from 8 to 12 and the covered text is that word";
               anchored =
                 `Assoc
                   [
                     ( "text",
                       `String
                         "\240\159\152\128 alpha beta\n\
                          gamma \240\157\145\165 delta" );
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 1);
                               ("page", `Int 1);
                               ("x", `Int 60);
                               ("y", `Int 720);
                               ("width", `Int 10);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 2);
                               ("end", `Int 7);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 8);
                               ("end", `Int 12);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 13);
                               ("end", `Int 18);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 45);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 19);
                               ("end", `Int 20);
                               ("page", `Int 1);
                               ("x", `Int 121);
                               ("y", `Int 700);
                               ("width", `Int 8);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 21);
                               ("end", `Int 26);
                               ("page", `Int 1);
                               ("x", `Int 133);
                               ("y", `Int 700);
                               ("width", `Int 42);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 8);
                     ("end", `Int 12);
                     ("exact", `String "beta");
                   ];
               body = None;
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "DYs4fnZVhO9IPwCRFg2hG");
                     ("motivation", `String "highlighting");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "FragmentSelector");
                                     ( "conformsTo",
                                       `String
                                         "http://tools.ietf.org/rfc/rfc3778" );
                                     ( "value",
                                       `String "page=1&viewrect=118,720,34,12"
                                     );
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ("exact", `String "beta");
                                   ];
                               ] );
                         ] );
                   ];
             }
              : pdf_built)
           : cases_item);
         (Pdf_built
            ({
               why =
                 "a PDF span over two lines with a character outside the plane \
                  inside it: the covered text runs from the least `start` to \
                  the greatest `end` of the items it overlaps, in code points";
               anchored =
                 `Assoc
                   [
                     ( "text",
                       `String
                         "\240\159\152\128 alpha beta\n\
                          gamma \240\157\145\165 delta" );
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 1);
                               ("page", `Int 1);
                               ("x", `Int 60);
                               ("y", `Int 720);
                               ("width", `Int 10);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 2);
                               ("end", `Int 7);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 8);
                               ("end", `Int 12);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 13);
                               ("end", `Int 18);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 45);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 19);
                               ("end", `Int 20);
                               ("page", `Int 1);
                               ("x", `Int 121);
                               ("y", `Int 700);
                               ("width", `Int 8);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 21);
                               ("end", `Int 26);
                               ("page", `Int 1);
                               ("x", `Int 133);
                               ("y", `Int 700);
                               ("width", `Int 42);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Commenting : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 8);
                     ("end", `Int 20);
                     ("exact", `String "beta\ngamma \240\157\145\165");
                     ("prefix", `String "alpha ");
                     ("suffix", `String " delta");
                   ];
               body =
                 Some
                   (`List
                      [
                        `Assoc
                          [
                            ("type", `String "TextualBody");
                            ("value", `String "a note");
                            ("purpose", `String "commenting");
                            ("format", `String "text/plain");
                          ];
                      ]);
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "Fe453bZz37I_t1ZATKfiq");
                     ("motivation", `String "commenting");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "FragmentSelector");
                                     ( "conformsTo",
                                       `String
                                         "http://tools.ietf.org/rfc/rfc3778" );
                                     ( "value",
                                       `String "page=1&viewrect=118,720,34,12"
                                     );
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "FragmentSelector");
                                     ( "conformsTo",
                                       `String
                                         "http://tools.ietf.org/rfc/rfc3778" );
                                     ( "value",
                                       `String "page=1&viewrect=72,700,57,12" );
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ( "exact",
                                       `String "beta\ngamma \240\157\145\165" );
                                     ("prefix", `String "alpha ");
                                     ("suffix", `String " delta");
                                   ];
                               ] );
                         ] );
                     ( "body",
                       `List
                         [
                           `Assoc
                             [
                               ("type", `String "TextualBody");
                               ("value", `String "a note");
                               ("purpose", `String "commenting");
                               ("format", `String "text/plain");
                             ];
                         ] );
                   ];
             }
              : pdf_built)
           : cases_item);
         (Pdf_refused
            ({
               why =
                 "a PDF span is held to the anchored text's length as a text \
                  span is to its text's: one that runs past the end, 22 code \
                  points, is refused, though the item it overlaps covers the \
                  words it states";
               anchored =
                 `Assoc
                   [
                     ("text", `String "alpha beta\ngamma delta");
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 5);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 6);
                               ("end", `Int 10);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 11);
                               ("end", `Int 16);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 45);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 17);
                               ("end", `Int 22);
                               ("page", `Int 1);
                               ("x", `Int 125);
                               ("y", `Int 700);
                               ("width", `Int 42);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 17.;
                    end_ = 30.;
                    exact = "delta";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "span-out-of-range";
             }
              : pdf_refused)
           : cases_item);
         (Pdf_refused
            ({
               why =
                 "a PDF span wholly past the end of the anchored text is out \
                  of range, and is not looked for";
               anchored =
                 `Assoc
                   [
                     ("text", `String "alpha beta\ngamma delta");
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 5);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 6);
                               ("end", `Int 10);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 11);
                               ("end", `Int 16);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 45);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 17);
                               ("end", `Int 22);
                               ("page", `Int 1);
                               ("x", `Int 125);
                               ("y", `Int 700);
                               ("width", `Int 42);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 30.;
                    end_ = 35.;
                    exact = "omega";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "span-out-of-range";
             }
              : pdf_refused)
           : cases_item);
         (Pdf_refused
            ({
               why =
                 "a PDF span's prefix is checked against the anchored text as \
                  a text span's is: the six code points before `beta` are \
                  `alpha ` and not `omega `";
               anchored =
                 `Assoc
                   [
                     ("text", `String "alpha beta\ngamma delta");
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 5);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 6);
                               ("end", `Int 10);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 11);
                               ("end", `Int 16);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 45);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 17);
                               ("end", `Int 22);
                               ("page", `Int 1);
                               ("x", `Int 125);
                               ("y", `Int 700);
                               ("width", `Int 42);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 6.;
                    end_ = 16.;
                    exact = "beta\ngamma";
                    prefix = Some "omega ";
                    suffix = Some " delta";
                  }
                   : span);
               body = None;
               refused = "prefix-mismatch";
             }
              : pdf_refused)
           : cases_item);
         (Pdf_refused
            ({
               why =
                 "a PDF span's suffix is checked the same way: what follows \
                  `gamma` is ` delta`";
               anchored =
                 `Assoc
                   [
                     ("text", `String "alpha beta\ngamma delta");
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 5);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 6);
                               ("end", `Int 10);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 11);
                               ("end", `Int 16);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 45);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 17);
                               ("end", `Int 22);
                               ("page", `Int 1);
                               ("x", `Int 125);
                               ("y", `Int 700);
                               ("width", `Int 42);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 6.;
                    end_ = 16.;
                    exact = "beta\ngamma";
                    prefix = Some "alpha ";
                    suffix = Some " omega";
                  }
                   : span);
               body = None;
               refused = "suffix-mismatch";
             }
              : pdf_refused)
           : cases_item);
         (Pdf_built
            ({
               why =
                 "a PDF span's prefix and suffix are each as many code points \
                  of the anchored text as they have themselves: eight, of \
                  which one is outside the Basic Multilingual Plane, and they \
                  are written into the quote and are no part of the id";
               anchored =
                 `Assoc
                   [
                     ( "text",
                       `String
                         "\240\159\152\128 alpha beta\n\
                          gamma \240\157\145\165 delta" );
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 1);
                               ("page", `Int 1);
                               ("x", `Int 60);
                               ("y", `Int 720);
                               ("width", `Int 10);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 2);
                               ("end", `Int 7);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 8);
                               ("end", `Int 12);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 13);
                               ("end", `Int 18);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 45);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 19);
                               ("end", `Int 20);
                               ("page", `Int 1);
                               ("x", `Int 121);
                               ("y", `Int 700);
                               ("width", `Int 8);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 21);
                               ("end", `Int 26);
                               ("page", `Int 1);
                               ("x", `Int 133);
                               ("y", `Int 700);
                               ("width", `Int 42);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 `Assoc
                   [
                     ("start", `Int 8);
                     ("end", `Int 12);
                     ("exact", `String "beta");
                     ("prefix", `String "\240\159\152\128 alpha ");
                     ("suffix", `String "\ngamma \240\157\145\165");
                   ];
               body = None;
               annotation =
                 `Assoc
                   [
                     ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                     ("type", `String "Annotation");
                     ("id", `String "DYs4fnZVhO9IPwCRFg2hG");
                     ("motivation", `String "highlighting");
                     ( "generator",
                       `Assoc
                         [
                           ("@type", `String "Software");
                           ( "@id",
                             `String "did:web:kb.example:agents:xynolog-worker"
                           );
                           ("provider", `String "ollama");
                           ("model", `String "gemma3");
                         ] );
                     ( "target",
                       `Assoc
                         [
                           ("type", `String "SpecificResource");
                           ("source", `String "res-1");
                           ( "selector",
                             `List
                               [
                                 `Assoc
                                   [
                                     ("type", `String "FragmentSelector");
                                     ( "conformsTo",
                                       `String
                                         "http://tools.ietf.org/rfc/rfc3778" );
                                     ( "value",
                                       `String "page=1&viewrect=118,720,34,12"
                                     );
                                   ];
                                 `Assoc
                                   [
                                     ("type", `String "TextQuoteSelector");
                                     ("exact", `String "beta");
                                     ( "prefix",
                                       `String "\240\159\152\128 alpha " );
                                     ( "suffix",
                                       `String "\ngamma \240\157\145\165" );
                                   ];
                               ] );
                         ] );
                   ];
             }
              : pdf_built)
           : cases_item);
         (Pdf_refused
            ({
               why =
                 "an item that is no stretch of the anchored text: the text is \
                  24 code points, its emoji one of them, and the second line's \
                  item ends at 25, as it would for a producer that counted \
                  UTF-16 code units. The span's words are in the text, and \
                  nothing is built on an anchored text that does not hold \
                  together";
               anchored =
                 `Assoc
                   [
                     ("text", `String "\240\159\152\128 alpha beta\ngamma delta");
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 13);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 110);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 14);
                               ("end", `Int 25);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 95);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 19.;
                    end_ = 24.;
                    exact = "delta";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "item-out-of-range";
             }
              : pdf_refused)
           : cases_item);
         (Pdf_refused
            ({
               why =
                 "every item is held to the text, not only those the span \
                  touches: this span is on the first line, whose item is a \
                  stretch of the text, and the second line's is not";
               anchored =
                 `Assoc
                   [
                     ("text", `String "\240\159\152\128 alpha beta\ngamma delta");
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 13);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 110);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 14);
                               ("end", `Int 25);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 95);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 2.;
                    end_ = 7.;
                    exact = "alpha";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "item-out-of-range";
             }
              : pdf_refused)
           : cases_item);
         (Pdf_refused
            ({
               why = "an item given backwards is no stretch of the text either";
               anchored =
                 `Assoc
                   [
                     ("text", `String "alpha beta\ngamma delta");
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 5);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 10);
                               ("end", `Int 6);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 11);
                               ("end", `Int 16);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 700);
                               ("width", `Int 45);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 17);
                               ("end", `Int 22);
                               ("page", `Int 1);
                               ("x", `Int 125);
                               ("y", `Int 700);
                               ("width", `Int 42);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 0.;
                    end_ = 5.;
                    exact = "alpha";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "item-out-of-range";
             }
              : pdf_refused)
           : cases_item);
         (Pdf_refused
            ({
               why =
                 "the anchored text is held to itself before the span is held \
                  to it: this span runs past the end of the text, and so does \
                  an item, and the item is what is named";
               anchored =
                 `Assoc
                   [
                     ("text", `String "alpha beta");
                     ( "items",
                       `List
                         [
                           `Assoc
                             [
                               ("start", `Int 0);
                               ("end", `Int 5);
                               ("page", `Int 1);
                               ("x", `Int 72);
                               ("y", `Int 720);
                               ("width", `Int 40);
                               ("height", `Int 12);
                             ];
                           `Assoc
                             [
                               ("start", `Int 6);
                               ("end", `Int 11);
                               ("page", `Int 1);
                               ("x", `Int 118);
                               ("y", `Int 720);
                               ("width", `Int 34);
                               ("height", `Int 12);
                             ];
                         ] );
                   ];
               resource_id = "res-1";
               generator =
                 ({
                    type_ = "Software";
                    id = Some "did:web:kb.example:agents:xynolog-worker";
                    provider = Some "ollama";
                    model = Some "gemma3";
                    parameters = None;
                  }
                   : generator);
               motivation = (Highlighting : motivation);
               span =
                 ({
                    start = 6.;
                    end_ = 11.;
                    exact = "beta";
                    prefix = None;
                    suffix = None;
                  }
                   : span);
               body = None;
               refused = "item-out-of-range";
             }
              : pdf_refused)
           : cases_item);
       ];
     resources =
       [
         ({
            why =
              "the link from a resource to the one generated from it: its \
               target is the resource and nothing else, and its id is the id \
               of that resource, motivation and body with the anchor the empty \
               string";
            resource_id = "res-1";
            motivation = (Linking : motivation);
            generator =
              Some
                ({
                   type_ = "Software";
                   id = Some "did:web:kb.example:agents:xynolog-worker";
                   provider = Some "ollama";
                   model = Some "gemma3";
                   parameters = None;
                 }
                  : generator);
            body =
              Some
                (`Assoc
                   [
                     ("type", `String "SpecificResource");
                     ("source", `String "res-2");
                     ("purpose", `String "linking");
                   ]);
            annotation =
              `Assoc
                [
                  ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                  ("type", `String "Annotation");
                  ("id", `String "xdaSX40cMJa46S2JHwFtC");
                  ("motivation", `String "linking");
                  ( "generator",
                    `Assoc
                      [
                        ("@type", `String "Software");
                        ( "@id",
                          `String "did:web:kb.example:agents:xynolog-worker" );
                        ("provider", `String "ollama");
                        ("model", `String "gemma3");
                      ] );
                  ("target", `Assoc [ ("source", `String "res-1") ]);
                  ( "body",
                    `Assoc
                      [
                        ("type", `String "SpecificResource");
                        ("source", `String "res-2");
                        ("purpose", `String "linking");
                      ] );
                ];
          }
           : resources_item);
         ({
            why =
              "a body that is a list is carried as that list; with no \
               generator given the annotation has none";
            resource_id = "res-1";
            motivation = (Tagging : motivation);
            generator = None;
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
            annotation =
              `Assoc
                [
                  ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                  ("type", `String "Annotation");
                  ("id", `String "ccRy_oB48bnFAt_H-QOFJ");
                  ("motivation", `String "tagging");
                  ("target", `Assoc [ ("source", `String "res-1") ]);
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
                            ("value", `String "people-v1");
                            ("purpose", `String "classifying");
                          ];
                      ] );
                ];
          }
           : resources_item);
         ({
            why =
              "with no body given the annotation has no `body` member, and \
               three members go into its id";
            resource_id = "res-1";
            motivation = (Highlighting : motivation);
            generator =
              Some
                ({
                   type_ = "Software";
                   id = Some "did:web:kb.example:agents:xynolog-worker";
                   provider = Some "ollama";
                   model = Some "gemma3";
                   parameters = None;
                 }
                  : generator);
            body = None;
            annotation =
              `Assoc
                [
                  ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                  ("type", `String "Annotation");
                  ("id", `String "EqaovAwF9KTh47GpsGdT9");
                  ("motivation", `String "highlighting");
                  ( "generator",
                    `Assoc
                      [
                        ("@type", `String "Software");
                        ( "@id",
                          `String "did:web:kb.example:agents:xynolog-worker" );
                        ("provider", `String "ollama");
                        ("model", `String "gemma3");
                      ] );
                  ("target", `Assoc [ ("source", `String "res-1") ]);
                ];
          }
           : resources_item);
         ({
            why =
              "neither a body nor a generator: the annotation is its context, \
               its type, its id, its motivation and its target";
            resource_id = "res-7";
            motivation = (Assessing : motivation);
            generator = None;
            body = None;
            annotation =
              `Assoc
                [
                  ("@context", `String "http://www.w3.org/ns/anno.jsonld");
                  ("type", `String "Annotation");
                  ("id", `String "_7b1fkq1dFOuoXWcTVZV0");
                  ("motivation", `String "assessing");
                  ("target", `Assoc [ ("source", `String "res-7") ]);
                ];
          }
           : resources_item);
       ];
   }
    : t)
