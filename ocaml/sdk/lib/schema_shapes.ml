(* Generated from every schema Protocol roots (codegen/lib/roots.ml), each record its tables state, each client type every SDK generates, and protocol/specs/src/client/discovery-absent.json, through codegen/lib/required/shape.ml. Do not edit.
   Regenerate: make generate (codegen/lib/required/ocaml.ml) *)

open Schema_shape

let shape_0 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion" ];
    members = [ ("apiVersion", { any with reference = Some "ApiVersion" }) ];
    closed = Some [ "apiVersion" ];
  }

let shape_1 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "development"; "apiVersions"; "imageRegistry"; "runtimes" ];
    members =
      [
        ( "apiVersions",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("built", { any with kinds = Some [ String ] });
        ("commit", { any with kinds = Some [ String ] });
        ("development", { any with kinds = Some [ Boolean ] });
        ("imageRegistry", { any with kinds = Some [ String ] });
        ( "runtimes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "RuntimeState" };
          } );
        ("version", { any with kinds = Some [ String ] });
      ];
    closed =
      Some
        [
          "apiVersions";
          "built";
          "commit";
          "development";
          "imageRegistry";
          "runtimes";
          "version";
        ];
  }

let shape_2 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "AgentPerson" };
        { any with reference = Some "AgentOrganization" };
        { any with reference = Some "AgentSoftware" };
      ];
    discriminator =
      Some ("@type", [ ("Person", 0); ("Organization", 1); ("Software", 2) ]);
  }

let shape_3 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "@type"; "name" ];
    members =
      [
        ("@id", { any with kinds = Some [ String ] });
        ( "@type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"Organization\"" ];
          } );
        ("homepage", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
      ];
  }

let shape_4 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "@type" ];
    members =
      [
        ("@id", { any with kinds = Some [ String ] });
        ( "@type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"Person\"" ];
          } );
        ("email", { any with kinds = Some [ String ] });
        ("email_sha1", { any with kinds = Some [ String ] });
        ("homepage", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
        ("nickname", { any with kinds = Some [ String ] });
      ];
  }

let shape_5 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "@type" ];
    members =
      [
        ("@id", { any with kinds = Some [ String ] });
        ( "@type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"Software\"" ];
          } );
        ("model", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
        ("parameters", { any with kinds = Some [ Object ] });
        ("provider", { any with kinds = Some [ String ] });
      ];
  }

let shape_6 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"unique-match\"";
          `Stringlit "\"context-recovered\"";
          `Stringlit "\"first-of-many\"";
          `Stringlit "\"fuzzy-match\"";
        ];
  }

let shape_7 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "x"; "y"; "width"; "height"; "top"; "right"; "bottom"; "left" ];
    members =
      [
        ("bottom", { any with kinds = Some [ Number ] });
        ("height", { any with kinds = Some [ Number ] });
        ("left", { any with kinds = Some [ Number ] });
        ("right", { any with kinds = Some [ Number ] });
        ("top", { any with kinds = Some [ Number ] });
        ("width", { any with kinds = Some [ Number ] });
        ("x", { any with kinds = Some [ Number ] });
        ("y", { any with kinds = Some [ Number ] });
      ];
  }

let shape_8 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "text"; "items" ];
    members =
      [
        ( "items",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "PdfTextItem" };
          } );
        ("text", { any with kinds = Some [ String ] });
      ];
  }

let shape_9 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "kind" ];
    members =
      [
        ( "kind",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"not-yet\"";
                  `Stringlit "\"no-map\"";
                  `Stringlit "\"unknown\"";
                ];
          } );
      ];
  }

let shape_10 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "ExtractedText" };
        { any with reference = Some "ExtractionDeclined" };
        { any with reference = Some "AnchoredTextAbsent" };
      ];
    discriminator =
      Some
        ( "kind",
          [
            ("extracted", 0);
            ("declined", 1);
            ("not-yet", 2);
            ("no-map", 2);
            ("unknown", 2);
          ] );
  }

let shape_11 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "v"; "stamp"; "declined" ];
    members =
      [
        ("declined", { any with reference = Some "ExtractionDeclinedReason" });
        ("stamp", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("v", { any with kinds = Some [ Integer ]; enum = Some [ `Intlit "3" ] });
      ];
    closed = Some [ "declined"; "stamp"; "v" ];
  }

let shape_12 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "checksums" ];
    members =
      [
        ( "checksums",
          {
            any with
            kinds = Some [ Array ];
            items =
              Some
                {
                  any with
                  kinds = Some [ String ];
                  pattern = Some [ Step ([ (48, 57); (97, 102) ], 64, Some 64) ];
                };
          } );
      ];
    closed = Some [ "checksums" ];
  }

let shape_13 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "AnchoredTextExtractedEntry" };
        { any with reference = Some "AnchoredTextDeclinedEntry" };
      ];
  }

let shape_14 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "v"; "stamp"; "text"; "lines"; "method" ];
    members =
      [
        ( "lines",
          {
            any with
            kinds = Some [ Array ];
            items =
              Some
                {
                  any with
                  kinds = Some [ Object ];
                  required = [ "p"; "y"; "h"; "words" ];
                  members =
                    [
                      ("h", { any with kinds = Some [ Number ] });
                      ("p", { any with kinds = Some [ Integer ] });
                      ( "words",
                        {
                          any with
                          kinds = Some [ Array ];
                          items =
                            Some
                              {
                                any with
                                kinds = Some [ Array ];
                                min_items = Some 4;
                                max_items = Some 4;
                                items =
                                  Some { any with kinds = Some [ Number ] };
                              };
                        } );
                      ("y", { any with kinds = Some [ Number ] });
                    ];
                  closed = Some [ "h"; "p"; "words"; "y" ];
                };
          } );
        ("method", { any with reference = Some "ExtractionMethod" });
        ("ocrConfidence", { any with reference = Some "OcrConfidence" });
        ("pdfClass", { any with reference = Some "PdfClass" });
        ("stamp", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("text", { any with kinds = Some [ String ] });
        ( "unreadPages",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ Integer ] };
          } );
        ("v", { any with kinds = Some [ Integer ]; enum = Some [ `Intlit "3" ] });
      ];
    closed =
      Some
        [
          "lines";
          "method";
          "ocrConfidence";
          "pdfClass";
          "stamp";
          "text";
          "unreadPages";
          "v";
        ];
  }

let shape_15 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "stamp" ];
    members =
      [
        ( "stamp",
          {
            any with
            kinds = Some [ String ];
            pattern =
              Some
                [
                  Step
                    ( [
                        (0, 8);
                        (14, 31);
                        (33, 159);
                        (161, 5759);
                        (5761, 8191);
                        (8203, 8231);
                        (8234, 8238);
                        (8240, 8286);
                        (8288, 12287);
                        (12289, 65278);
                        (65280, 1114111);
                      ],
                      1,
                      None );
                ];
            min_length = Some 1;
          } );
      ];
    closed = Some [ "stamp" ];
  }

let shape_16 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "contentChecksum"; "entry" ];
    members =
      [
        ( "contentChecksum",
          {
            any with
            kinds = Some [ String ];
            pattern = Some [ Step ([ (48, 57); (97, 102) ], 64, Some 64) ];
          } );
        ("entry", { any with reference = Some "AnchoredTextEntry" });
      ];
    closed = Some [ "contentChecksum"; "entry" ];
  }

let shape_17 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "@context"; "type"; "id"; "motivation"; "target"; "created" ];
    members =
      [
        ( "@context",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"http://www.w3.org/ns/anno.jsonld\"" ];
          } );
        ("body", { any with reference = Some "AnnotationBodies" });
        ("created", { any with kinds = Some [ String ] });
        ("creator", { any with reference = Some "Agent" });
        ("generator", { any with reference = Some "OneOrMoreAgents" });
        ("id", { any with reference = Some "AnnotationId" });
        ("modified", { any with kinds = Some [ String ] });
        ("motivation", { any with reference = Some "Motivation" });
        ( "target",
          {
            any with
            kinds = Some [ Object; String ];
            variants =
              [
                { any with reference = Some "ResourceId" };
                { any with reference = Some "AnnotationTarget" };
              ];
          } );
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"Annotation\"" ];
          } );
        ("wasAttributedTo", { any with reference = Some "OneOrMoreAgents" });
      ];
  }

let shape_18 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotation" ];
    members =
      [
        ("annotation", { any with reference = Some "Annotation" });
        ("contentChecksum", { any with kinds = Some [ String ] });
      ];
  }

let shape_19 () =
  {
    any with
    kinds = Some [ Object; Array ];
    variants =
      [
        { any with reference = Some "AnnotationBody" };
        {
          any with
          kinds = Some [ Array ];
          min_items = Some 1;
          items = Some { any with reference = Some "AnnotationBody" };
        };
      ];
  }

let shape_20 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "TextualBody" };
        { any with reference = Some "SpecificResource" };
      ];
    discriminator =
      Some ("type", [ ("TextualBody", 0); ("SpecificResource", 1) ]);
  }

let shape_21 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotationId"; "operations" ];
    members =
      [
        ("annotationId", { any with reference = Some "AnnotationId" });
        ( "operations",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "BodyOperation" };
          } );
      ];
  }

let shape_22 () =
  {
    any with
    kinds = Some [ String ];
    pattern =
      Some
        [
          Step
            ([ (45, 45); (48, 57); (65, 90); (95, 95); (97, 122) ], 1, Some 128);
        ];
  }

let shape_23 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotationId" ];
    members = [ ("annotationId", { any with reference = Some "AnnotationId" }) ];
  }

let shape_24 () =
  {
    any with
    kinds = Some [ Object; Array ];
    variants =
      [
        { any with reference = Some "Selector" };
        {
          any with
          kinds = Some [ Array ];
          items = Some { any with reference = Some "Selector" };
        };
      ];
  }

let shape_25 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "source" ];
    members =
      [
        ("selector", { any with reference = Some "AnnotationSelector" });
        ("source", { any with reference = Some "ResourceId" });
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"SpecificResource\"" ];
          } );
      ];
  }

let shape_26 () =
  {
    any with
    kinds = Some [ String ];
    enum = Some [ `Stringlit "\"control.xynolog.org/v1alpha1\"" ];
  }

let shape_27 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [
        "gatewayUrl";
        "identity";
        "root";
        "stateHome";
        "anchoredTextDir";
        "engines";
        "port";
        "skipRebuild";
        "staging";
        "logLevel";
        "logFormat";
      ];
    members =
      [
        ( "anchoredTextDir",
          { any with kinds = Some [ String ]; min_length = Some 1 } );
        ("engines", { any with reference = Some "ArchivistEngines" });
        ("gatewayUrl", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("identity", { any with reference = Some "ServiceIdentity" });
        ("logFormat", { any with reference = Some "LogFormat" });
        ("logLevel", { any with reference = Some "LogLevel" });
        ( "port",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "65535";
          } );
        ("root", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("skipRebuild", { any with kinds = Some [ Boolean ] });
        ( "staging",
          {
            any with
            kinds = Some [ Object ];
            required = [ "flushMs"; "maxWaitMs" ];
            members =
              [
                ( "flushMs",
                  { any with kinds = Some [ Integer ]; minimum = Some "1" } );
                ( "maxWaitMs",
                  { any with kinds = Some [ Integer ]; minimum = Some "1" } );
              ];
            closed = Some [ "flushMs"; "maxWaitMs" ];
          } );
        ("stateHome", { any with kinds = Some [ String ]; min_length = Some 1 });
      ];
    closed =
      Some
        [
          "anchoredTextDir";
          "engines";
          "gatewayUrl";
          "identity";
          "logFormat";
          "logLevel";
          "port";
          "root";
          "skipRebuild";
          "staging";
          "stateHome";
        ];
  }

let shape_28 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobs"; "actors" ];
    members =
      [
        ( "actors",
          {
            any with
            kinds = Some [ Object ];
            members =
              [
                ("gatherer", { any with reference = Some "Engine" });
                ("matcher", { any with reference = Some "Engine" });
              ];
            closed = Some [ "gatherer"; "matcher" ];
          } );
        ( "jobs",
          {
            any with
            kinds = Some [ Object ];
            members =
              [
                ( "mark",
                  {
                    any with
                    kinds = Some [ Object ];
                    members =
                      [
                        ("assessing", { any with reference = Some "Engine" });
                        ("commenting", { any with reference = Some "Engine" });
                        ("highlighting", { any with reference = Some "Engine" });
                        ("linking", { any with reference = Some "Engine" });
                        ("tagging", { any with reference = Some "Engine" });
                      ];
                    closed =
                      Some
                        [
                          "assessing";
                          "commenting";
                          "highlighting";
                          "linking";
                          "tagging";
                        ];
                  } );
                ("yield", { any with reference = Some "Engine" });
              ];
            closed = Some [ "mark"; "yield" ];
          } );
      ];
    closed = Some [ "actors"; "jobs" ];
  }

let shape_29 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "events"; "lastSequence" ];
    members =
      [
        ( "events",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "StoredEventResponse" };
          } );
        ( "lastSequence",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
      ];
  }

let shape_30 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "status"; "actors" ];
    members =
      [
        ( "actors",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 3;
            max_items = Some 3;
            items =
              Some
                {
                  any with
                  kinds = Some [ String ];
                  enum =
                    Some
                      [
                        `Stringlit "\"stower\"";
                        `Stringlit "\"browser\"";
                        `Stringlit "\"cloneTokenManager\"";
                      ];
                };
          } );
        ( "status",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"ok\"" ];
          } );
      ];
  }

let shape_31 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "lastSequence" ];
    members =
      [
        ( "lastSequence",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
    closed = Some [ "lastSequence"; "resourceId" ];
  }

let shape_32 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "streams" ];
    members =
      [
        ( "streams",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "ArchivistStream" };
          } );
      ];
    closed = Some [ "streams" ];
  }

let shape_33 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "motivation" ];
    members =
      [
        ("density", { any with kinds = Some [ Number ] });
        ("instructions", { any with kinds = Some [ String ] });
        ("language", { any with kinds = Some [ String ] });
        ( "motivation",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"assessing\"" ];
          } );
        ("sourceLanguage", { any with kinds = Some [ String ] });
        ( "tone",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"analytical\"";
                  `Stringlit "\"critical\"";
                  `Stringlit "\"balanced\"";
                  `Stringlit "\"constructive\"";
                ];
          } );
      ];
    closed =
      Some
        [
          "density";
          "instructions";
          "language";
          "motivation";
          "sourceLanguage";
          "tone";
        ];
  }

let shape_34 () =
  {
    any with
    kinds = Some [ Object ];
    all_of =
      [
        { any with reference = Some "StoredEventResponse" };
        {
          any with
          kinds = Some [ Object ];
          required = [ "agent" ];
          members = [ ("agent", { any with reference = Some "Agent" }) ];
        };
      ];
  }

let shape_35 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("runtime", { any with reference = Some "Runtime" });
        ("target", { any with reference = Some "Target" });
      ];
    closed = Some [ "apiVersion"; "runtime"; "target" ];
  }

let shape_36 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "key"; "who"; "issuer" ];
    members =
      [
        ("issuer", { any with kinds = Some [ String ] });
        ("key", { any with kinds = Some [ String ] });
        ("who", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "issuer"; "key"; "who" ];
  }

let shape_37 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("runtime", { any with reference = Some "Runtime" });
        ("target", { any with reference = Some "Target" });
      ];
    closed = Some [ "apiVersion"; "runtime"; "target" ];
  }

let shape_38 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "wasSignedIn"; "revoked" ];
    members =
      [
        ("key", { any with kinds = Some [ String ] });
        ("revoked", { any with kinds = Some [ Boolean ] });
        ("wasSignedIn", { any with kinds = Some [ Boolean ] });
      ];
    closed = Some [ "key"; "revoked"; "wasSignedIn" ];
  }

let shape_39 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId" ];
    members =
      [
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_40 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotationId" ];
    members =
      [
        ( "annotationId",
          {
            any with
            kinds = Some [ String; Null ];
            variants =
              [
                { any with kinds = Some [ Null ] };
                { any with reference = Some "AnnotationId" };
              ];
          } );
      ];
  }

let shape_41 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotationId" ];
    members = [ ("annotationId", { any with reference = Some "AnnotationId" }) ];
  }

let shape_42 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "target"; "redirectUri" ];
    members =
      [
        ("expectedDid", { any with kinds = Some [ String ] });
        ("expectedName", { any with kinds = Some [ String ] });
        ("kbId", { any with kinds = Some [ String ] });
        ("redirectUri", { any with kinds = Some [ String ] });
        ("target", { any with reference = Some "HttpEndpoint" });
      ];
    closed =
      Some [ "expectedDid"; "expectedName"; "kbId"; "redirectUri"; "target" ];
  }

let shape_43 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "op" ];
    members =
      [
        ("item", { any with reference = Some "AnnotationBody" });
        ("newItem", { any with reference = Some "AnnotationBody" });
        ("oldItem", { any with reference = Some "AnnotationBody" });
        ( "op",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"add\"";
                  `Stringlit "\"remove\"";
                  `Stringlit "\"replace\"";
                ];
          } );
      ];
  }

let shape_44 () = { any with kinds = Some [ Object ] }

let shape_45 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotationId"; "resourceId"; "defaultTitle"; "entityTypes" ];
    members =
      [
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("defaultTitle", { any with kinds = Some [ String ] });
        ( "entityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_46 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotationId"; "resourceId"; "operations" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("annotationId", { any with reference = Some "AnnotationId" });
        ( "operations",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "BindBodyOperation" };
          } );
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_47 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "BodyOperationAdd" };
        { any with reference = Some "BodyOperationRemove" };
        { any with reference = Some "BodyOperationReplace" };
      ];
  }

let shape_48 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "op"; "item" ];
    members =
      [
        ("item", { any with reference = Some "AnnotationBody" });
        ( "op",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"add\"" ];
          } );
      ];
  }

let shape_49 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "op"; "item" ];
    members =
      [
        ("item", { any with reference = Some "AnnotationBody" });
        ( "op",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"remove\"" ];
          } );
      ];
  }

let shape_50 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "op"; "oldItem"; "newItem" ];
    members =
      [
        ("newItem", { any with reference = Some "AnnotationBody" });
        ("oldItem", { any with reference = Some "AnnotationBody" });
        ( "op",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"replace\"" ];
          } );
      ];
  }

let shape_51 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"assessing\"";
          `Stringlit "\"bookmarking\"";
          `Stringlit "\"classifying\"";
          `Stringlit "\"commenting\"";
          `Stringlit "\"describing\"";
          `Stringlit "\"editing\"";
          `Stringlit "\"highlighting\"";
          `Stringlit "\"identifying\"";
          `Stringlit "\"linking\"";
          `Stringlit "\"moderating\"";
          `Stringlit "\"questioning\"";
          `Stringlit "\"replying\"";
          `Stringlit "\"tagging\"";
        ];
  }

let shape_52 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "annotationId" ];
    members =
      [
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_53 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [
        ( "response",
          { any with reference = Some "GetAnnotationHistoryResponse" } );
      ];
  }

let shape_54 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "annotationId" ];
    members =
      [
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_55 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [ ("response", { any with reference = Some "GetAnnotationResponse" }) ];
  }

let shape_56 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotationId" ];
    members =
      [
        ("anchorRect", { any with reference = Some "AnchorRect" });
        ("annotationId", { any with reference = Some "AnnotationId" });
      ];
  }

let shape_57 () =
  {
    any with
    kinds = Some [ Object ];
    all_of =
      [
        { any with reference = Some "CommandError" };
        {
          any with
          kinds = Some [ Object ];
          required = [ "path" ];
          members = [ ("path", { any with kinds = Some [ String ] }) ];
        };
      ];
  }

let shape_58 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "path" ];
    members =
      [
        ("path", { any with kinds = Some [ String ] });
        ( "sort",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"name\"";
                  `Stringlit "\"mtime\"";
                  `Stringlit "\"annotationCount\"";
                ];
          } );
      ];
  }

let shape_59 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [
        ( "response",
          { any with reference = Some "BrowseDirectoryResultResponse" } );
      ];
  }

let shape_60 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "path"; "entries" ];
    members =
      [
        ( "entries",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "DirectoryEntry" };
          } );
        ("path", { any with kinds = Some [ String ] });
      ];
  }

let shape_61 () = { any with kinds = Some [ Object ] }

let shape_62 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [
        ( "response",
          {
            any with
            kinds = Some [ Object ];
            required = [ "engines" ];
            members =
              [
                ( "engines",
                  {
                    any with
                    kinds = Some [ Array ];
                    items = Some { any with reference = Some "EngineEntry" };
                  } );
              ];
          } );
      ];
  }

let shape_63 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "entityType" ];
    members = [ ("entityType", { any with kinds = Some [ String ] }) ];
  }

let shape_64 () = { any with kinds = Some [ Object ] }

let shape_65 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [ ("response", { any with reference = Some "GetEntityTypesResponse" }) ];
  }

let shape_66 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId" ];
    members =
      [
        ("limit", { any with kinds = Some [ Integer ] });
        ("resourceId", { any with reference = Some "ResourceId" });
        ("type", { any with kinds = Some [ String ] });
        ("userId", { any with reference = Some "UserId" });
      ];
  }

let shape_67 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [ ("response", { any with reference = Some "GetEventsResponse" }) ];
  }

let shape_68 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "url" ];
    members =
      [
        ("resourceId", { any with reference = Some "ResourceId" });
        ("url", { any with kinds = Some [ String ] });
      ];
  }

let shape_69 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "path"; "entries" ];
    members =
      [
        ( "entries",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "DirectoryEntry" };
          } );
        ("path", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "entries"; "path" ];
  }

let shape_70 () = { any with kinds = Some [ Object ] }

let shape_71 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members = [ ("response", { any with reference = Some "KbDescription" }) ];
  }

let shape_72 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "href" ];
    members =
      [
        ("href", { any with kinds = Some [ String ] });
        ("label", { any with kinds = Some [ String ] });
      ];
  }

let shape_73 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "panel" ];
    members =
      [
        ("motivation", { any with reference = Some "Motivation" });
        ("panel", { any with kinds = Some [ String ] });
        ("scrollToAnnotationId", { any with reference = Some "AnnotationId" });
      ];
  }

let shape_74 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "panel" ];
    members = [ ("panel", { any with kinds = Some [ String ] }) ];
  }

let shape_75 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "dids" ];
    members =
      [
        ( "dids",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            max_items = Some 500;
            items = Some { any with reference = Some "UserId" };
          } );
      ];
    closed = Some [ "dids" ];
  }

let shape_76 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [
        ( "response",
          {
            any with
            kinds = Some [ Object ];
            required = [ "profiles" ];
            members =
              [
                ( "profiles",
                  {
                    any with
                    kinds = Some [ Object ];
                    values = Some { any with reference = Some "Profile" };
                  } );
              ];
            closed = Some [ "profiles" ];
          } );
      ];
  }

let shape_77 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId" ];
    members = [ ("resourceId", { any with reference = Some "ResourceId" }) ];
  }

let shape_78 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId" ];
    members = [ ("resourceId", { any with reference = Some "ResourceId" }) ];
  }

let shape_79 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "oldIndex"; "newIndex" ];
    members =
      [
        ("newIndex", { any with kinds = Some [ Integer ] });
        ("oldIndex", { any with kinds = Some [ Integer ] });
      ];
  }

let shape_80 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId" ];
    members = [ ("resourceId", { any with reference = Some "ResourceId" }) ];
  }

let shape_81 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [
        ( "response",
          {
            any with
            kinds = Some [ Object ];
            required = [ "resource"; "lastSequence" ];
            members =
              [
                ( "lastSequence",
                  { any with kinds = Some [ Integer ]; minimum = Some "1" } );
                ("resource", { any with reference = Some "ResourceDescriptor" });
              ];
            closed = Some [ "lastSequence"; "resource" ];
          } );
      ];
  }

let shape_82 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId" ];
    members = [ ("resourceId", { any with reference = Some "ResourceId" }) ];
  }

let shape_83 () =
  {
    any with
    kinds = Some [ Object ];
    members =
      [
        ("archived", { any with kinds = Some [ Boolean ] });
        ("entityType", { any with kinds = Some [ String ] });
        ("limit", { any with kinds = Some [ Integer ]; minimum = Some "1" });
        ("offset", { any with kinds = Some [ Integer ]; minimum = Some "0" });
      ];
  }

let shape_84 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [ ("response", { any with reference = Some "ListResourcesResponse" }) ];
  }

let shape_85 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "path" ];
    members =
      [
        ("path", { any with kinds = Some [ String ] });
        ("reason", { any with kinds = Some [ String ] });
      ];
  }

let shape_86 () = { any with kinds = Some [ Object ] }

let shape_87 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [ ("response", { any with reference = Some "GetTagSchemasResponse" }) ];
  }

let shape_88 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "kind"; "metadata"; "spec" ];
    members =
      [
        ("apiVersion", { any with reference = Some "StackApiVersion" });
        ( "kind",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"Browser\"" ];
          } );
        ("metadata", { any with reference = Some "Metadata" });
        ( "spec",
          {
            any with
            kinds = Some [ Object ];
            required = [ "image"; "resources"; "port" ];
            members =
              [
                ("image", { any with reference = Some "Image" });
                ( "port",
                  {
                    any with
                    kinds = Some [ Integer ];
                    minimum = Some "1";
                    maximum = Some "65535";
                  } );
                ("resources", { any with reference = Some "Resources" });
              ];
            closed = Some [ "image"; "port"; "resources" ];
          } );
      ];
    closed = Some [ "apiVersion"; "kind"; "metadata"; "spec" ];
  }

let shape_89 () =
  {
    any with
    kinds = Some [ Object ];
    members =
      [
        ( "subscribers",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
      ];
  }

let shape_90 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "channel"; "payload" ];
    members =
      [
        ("channel", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("clientId", { any with kinds = Some [ String ] });
        ( "correlationId",
          { any with kinds = Some [ String ]; min_length = Some 1 } );
        ("payload", { any with kinds = Some [ Object ] });
        ("scope", { any with reference = Some "ResourceId" });
      ];
  }

let shape_91 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "event"; "id"; "data" ];
    members =
      [
        ("data", { any with reference = Some "BusFrame" });
        ( "event",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"bus-event\"" ];
          } );
        ( "id",
          {
            any with
            kinds = Some [ String ];
            variants =
              [
                { any with reference = Some "PersistedEventId" };
                { any with reference = Some "ReplyEventId" };
                { any with reference = Some "EphemeralEventId" };
              ];
          } );
      ];
    closed = Some [ "data"; "event"; "id" ];
  }

let shape_92 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "channel"; "payload" ];
    members =
      [
        ("channel", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "correlationId",
          { any with kinds = Some [ String ]; min_length = Some 1 } );
        ("payload", { any with kinds = Some [ Object ] });
        ("scope", { any with reference = Some "ResourceId" });
      ];
    closed = Some [ "channel"; "correlationId"; "payload"; "scope" ];
  }

let shape_93 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "event"; "data" ];
    members =
      [
        ("data", { any with kinds = Some [ String ]; max_length = Some 0 });
        ( "event",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"ping\"" ];
          } );
      ];
    closed = Some [ "data"; "event" ];
  }

let shape_94 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "scope"; "lastSeenId"; "reason" ];
    members =
      [
        ("lastSeenId", { any with kinds = Some [ String ] });
        ( "reason",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"unparseable-last-event-id\"";
                  `Stringlit "\"scope-mismatch\"";
                  `Stringlit "\"retention-exceeded\"";
                  `Stringlit "\"query-error\"";
                ];
          } );
        ("scope", { any with reference = Some "ResourceId" });
      ];
    closed = Some [ "lastSeenId"; "reason"; "scope" ];
  }

let shape_95 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "BusEventMessage" };
        { any with reference = Some "BusPingMessage" };
      ];
  }

let shape_96 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "clientId" ];
    members =
      [
        ("clientId", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "global",
          {
            any with
            kinds = Some [ Array ];
            items =
              Some { any with kinds = Some [ String ]; min_length = Some 1 };
          } );
        ( "pendingReplies",
          {
            any with
            kinds = Some [ Array ];
            max_items = Some 256;
            items =
              Some { any with kinds = Some [ String ]; min_length = Some 1 };
          } );
        ( "scoped",
          {
            any with
            kinds = Some [ Array ];
            max_items = Some 512;
            items =
              Some
                {
                  any with
                  kinds = Some [ Object ];
                  required = [ "scope"; "channels" ];
                  members =
                    [
                      ( "channels",
                        {
                          any with
                          kinds = Some [ Array ];
                          min_items = Some 1;
                          items =
                            Some
                              {
                                any with
                                kinds = Some [ String ];
                                min_length = Some 1;
                              };
                        } );
                      ("lastEventId", { any with kinds = Some [ String ] });
                      ("scope", { any with reference = Some "ResourceId" });
                    ];
                  closed = Some [ "channels"; "lastEventId"; "scope" ];
                };
          } );
      ];
    closed = Some [ "clientId"; "global"; "pendingReplies"; "scoped" ];
  }

let shape_97 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "requestId" ];
    members =
      [
        ("reason", { any with kinds = Some [ String ] });
        ("requestId", { any with reference = Some "RequestId" });
      ];
    closed = Some [ "reason"; "requestId" ];
  }

let shape_98 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "accepts" ];
    members =
      [
        ( "accepts",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            items = Some { any with reference = Some "JobFilter" };
          } );
        ( "heldJobStallCheckMs",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ( "heldJobStallMs",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ( "jobClaimTimeoutMs",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ( "markCommitTimeoutMs",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
      ];
    closed =
      Some
        [
          "accepts";
          "heldJobStallCheckMs";
          "heldJobStallMs";
          "jobClaimTimeoutMs";
          "markCommitTimeoutMs";
        ];
  }

let shape_99 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "grant_type"; "client_id"; "client_secret" ];
    members =
      [
        ("client_id", { any with kinds = Some [ String ] });
        ("client_secret", { any with kinds = Some [ String ] });
        ( "grant_type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"client_credentials\"" ];
          } );
      ];
  }

let shape_100 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "token"; "expiresAt"; "resource" ];
    members =
      [
        ("expiresAt", { any with kinds = Some [ String ] });
        ("resource", { any with reference = Some "ResourceDescriptor" });
        ("token", { any with kinds = Some [ String ] });
      ];
  }

let shape_101 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "message" ];
    members =
      [
        ( "code",
          {
            any with
            kinds = Some [ String ];
            recognized =
              Some
                [
                  "peer-unavailable";
                  "not-found";
                  "unauthorized";
                  "none-pending";
                ];
          } );
        ("details", { any with kinds = Some [ String ] });
        ("message", { any with kinds = Some [ String ] });
      ];
  }

let shape_102 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "motivation" ];
    members =
      [
        ("density", { any with kinds = Some [ Number ] });
        ("instructions", { any with kinds = Some [ String ] });
        ("language", { any with kinds = Some [ String ] });
        ( "motivation",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"commenting\"" ];
          } );
        ("sourceLanguage", { any with kinds = Some [ String ] });
        ( "tone",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"scholarly\"";
                  `Stringlit "\"explanatory\"";
                  `Stringlit "\"conversational\"";
                  `Stringlit "\"technical\"";
                ];
          } );
      ];
    closed =
      Some
        [
          "density";
          "instructions";
          "language";
          "motivation";
          "sourceLanguage";
          "tone";
        ];
  }

let shape_103 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "fetch"; "as" ];
    members =
      [
        ( "as",
          {
            any with
            kinds = Some [ String ];
            pattern =
              Some
                [
                  Step ([ (65, 90); (97, 122) ], 1, Some 1);
                  Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                ];
          } );
        ( "fetch",
          {
            any with
            kinds = Some [ String ];
            pattern =
              Some
                [
                  Step ([ (97, 122) ], 1, None);
                  Step ([ (58, 58) ], 1, Some 1);
                  Step ([ (45, 45); (97, 122) ], 1, None);
                ];
          } );
      ];
    closed = Some [ "as"; "fetch"; "payload" ];
  }

let shape_104 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "about"; "source"; "steps" ];
    members =
      [
        ("about", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "planes",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            items =
              Some
                {
                  any with
                  kinds = Some [ String ];
                  enum =
                    Some [ `Stringlit "\"in-process\""; `Stringlit "\"nats\"" ];
                };
          } );
        ("source", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "steps",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            items = Some { any with reference = Some "ConformanceStep" };
          } );
        ( "telemetry",
          { any with kinds = Some [ Boolean ]; enum = Some [ `Bool true ] } );
        ( "tier",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"fleet\""; `Stringlit "\"parity\"" ];
          } );
      ];
    closed = Some [ "about"; "planes"; "source"; "steps"; "telemetry"; "tier" ];
  }

let shape_105 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        {
          any with
          kinds = Some [ Object ];
          required = [ "ready" ];
          members =
            [
              ( "ready",
                {
                  any with
                  kinds = Some [ Boolean ];
                  enum = Some [ `Bool true ];
                } );
            ];
          closed = Some [ "ready" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "id"; "ok" ];
          members =
            [
              ("id", { any with kinds = Some [ Integer ]; minimum = Some "1" });
            ];
          closed = Some [ "id"; "ok" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "id"; "error" ];
          members =
            [
              ("error", { any with reference = Some "ConformanceFailure" });
              ("id", { any with kinds = Some [ Integer ]; minimum = Some "1" });
            ];
          closed = Some [ "error"; "id" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "id"; "abandoned" ];
          members =
            [
              ( "abandoned",
                {
                  any with
                  kinds = Some [ Boolean ];
                  enum = Some [ `Bool true ];
                } );
              ("id", { any with kinds = Some [ Integer ]; minimum = Some "1" });
            ];
          closed = Some [ "abandoned"; "id" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "id"; "unsupported" ];
          members =
            [
              ("id", { any with kinds = Some [ Integer ]; minimum = Some "1" });
              ( "unsupported",
                {
                  any with
                  kinds = Some [ Boolean ];
                  enum = Some [ `Bool true ];
                } );
            ];
          closed = Some [ "id"; "unsupported" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "id"; "misuse" ];
          members =
            [
              ("id", { any with kinds = Some [ Integer ]; minimum = Some "1" });
              ("misuse", { any with kinds = Some [ String ] });
            ];
          closed = Some [ "id"; "misuse" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "state" ];
          members = [ ("state", { any with kinds = Some [ String ] }) ];
          closed = Some [ "state" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "frame" ];
          members =
            [
              ( "frame",
                {
                  any with
                  kinds = Some [ Object ];
                  required = [ "channel" ];
                  members =
                    [
                      ("channel", { any with kinds = Some [ String ] });
                      ("correlationId", { any with kinds = Some [ String ] });
                      ("scope", { any with reference = Some "ResourceId" });
                    ];
                  closed =
                    Some [ "channel"; "correlationId"; "payload"; "scope" ];
                } );
            ];
          closed = Some [ "frame" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "error" ];
          members =
            [ ("error", { any with reference = Some "ConformanceFailure" }) ];
          closed = Some [ "error" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "progress" ];
          members =
            [
              ( "progress",
                {
                  any with
                  kinds = Some [ Object ];
                  required = [ "upload"; "bytesUploaded"; "totalBytes" ];
                  members =
                    [
                      ( "bytesUploaded",
                        {
                          any with
                          kinds = Some [ Integer ];
                          minimum = Some "0";
                        } );
                      ( "totalBytes",
                        {
                          any with
                          kinds = Some [ Integer ];
                          minimum = Some "0";
                        } );
                      ( "upload",
                        {
                          any with
                          kinds = Some [ Integer ];
                          minimum = Some "1";
                        } );
                    ];
                  closed = Some [ "bytesUploaded"; "totalBytes"; "upload" ];
                } );
            ];
          closed = Some [ "progress" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "emission" ];
          members =
            [
              ( "emission",
                {
                  any with
                  kinds = Some [ Object ];
                  required = [ "observer"; "state" ];
                  members =
                    [
                      ("observer", { any with kinds = Some [ String ] });
                      ( "state",
                        {
                          any with
                          kinds = Some [ Object ];
                          variants =
                            [
                              {
                                any with
                                kinds = Some [ Object ];
                                required = [ "status" ];
                                members =
                                  [
                                    ( "status",
                                      {
                                        any with
                                        kinds = Some [ String ];
                                        enum = Some [ `Stringlit "\"pending\"" ];
                                      } );
                                  ];
                                closed = Some [ "status" ];
                              };
                              {
                                any with
                                kinds = Some [ Object ];
                                required = [ "status"; "value" ];
                                members =
                                  [
                                    ( "status",
                                      {
                                        any with
                                        kinds = Some [ String ];
                                        enum = Some [ `Stringlit "\"ready\"" ];
                                      } );
                                  ];
                                closed = Some [ "status"; "value" ];
                              };
                              {
                                any with
                                kinds = Some [ Object ];
                                required = [ "status"; "error" ];
                                members =
                                  [
                                    ( "error",
                                      {
                                        any with
                                        reference = Some "ConformanceFailure";
                                      } );
                                    ( "status",
                                      {
                                        any with
                                        kinds = Some [ String ];
                                        enum = Some [ `Stringlit "\"failed\"" ];
                                      } );
                                  ];
                                closed = Some [ "error"; "status" ];
                              };
                            ];
                        } );
                    ];
                  closed = Some [ "observer"; "state" ];
                } );
            ];
          closed = Some [ "emission" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "completed" ];
          members = [ ("completed", { any with kinds = Some [ String ] }) ];
          closed = Some [ "completed" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "claimed" ];
          members = [ ("claimed", { any with kinds = Some [ Object ] }) ];
          closed = Some [ "claimed" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "refused" ];
          members =
            [ ("refused", { any with reference = Some "ConformanceFailure" }) ];
          closed = Some [ "refused" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "signalled" ];
          members = [ ("signalled", { any with kinds = Some [ String ] }) ];
          closed = Some [ "signalled" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "stalled" ];
          members = [ ("stalled", { any with kinds = Some [ String ] }) ];
          closed = Some [ "stalled" ];
        };
      ];
  }

let shape_106 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "detail" ];
    members =
      [
        ("code", { any with kinds = Some [ String ] });
        ("detail", { any with kinds = Some [ String ] });
        ("failureClass", { any with reference = Some "FailureClass" });
        ("status", { any with kinds = Some [ Integer ] });
      ];
    closed = Some [ "code"; "detail"; "failureClass"; "status" ];
  }

let shape_107 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "fetch" ];
    members =
      [
        ( "fetch",
          {
            any with
            kinds = Some [ String ];
            pattern =
              Some
                [
                  Step ([ (71, 71) ], 1, Some 1);
                  Step ([ (69, 69) ], 1, Some 1);
                  Step ([ (84, 84) ], 1, Some 1);
                  Step ([ (32, 32) ], 1, Some 1);
                  Step ([ (47, 47) ], 1, Some 1);
                  Step ([ (0, 1114111) ], 0, None);
                ];
          } );
      ];
    closed = Some [ "fetch"; "params" ];
  }

let shape_108 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "launcher"; "target"; "sdks" ];
    members =
      [
        ( "launcher",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            items =
              Some { any with kinds = Some [ String ]; min_length = Some 1 };
          } );
        ( "modelCatalogue",
          { any with kinds = Some [ String ]; min_length = Some 1 } );
        ( "sdks",
          {
            any with
            kinds = Some [ Object ];
            values =
              Some
                {
                  any with
                  kinds = Some [ Object ];
                  members =
                    [
                      ( "exempt",
                        {
                          any with
                          kinds = Some [ Object ];
                          values =
                            Some
                              {
                                any with
                                kinds = Some [ String ];
                                min_length = Some 1;
                              };
                        } );
                      ( "live",
                        {
                          any with
                          kinds = Some [ Object ];
                          required = [ "command"; "tier" ];
                          members =
                            [
                              ( "command",
                                {
                                  any with
                                  kinds = Some [ Array ];
                                  min_items = Some 1;
                                  items =
                                    Some
                                      {
                                        any with
                                        kinds = Some [ String ];
                                        min_length = Some 1;
                                      };
                                } );
                              ( "tier",
                                {
                                  any with
                                  kinds = Some [ String ];
                                  enum =
                                    Some
                                      [
                                        `Stringlit "\"fleet\"";
                                        `Stringlit "\"parity\"";
                                      ];
                                } );
                            ];
                          closed = Some [ "command"; "tier" ];
                        } );
                      ( "wire",
                        {
                          any with
                          kinds = Some [ Array ];
                          min_items = Some 1;
                          items =
                            Some
                              {
                                any with
                                kinds = Some [ String ];
                                min_length = Some 1;
                              };
                        } );
                      ( "worker",
                        {
                          any with
                          kinds = Some [ Array ];
                          min_items = Some 1;
                          items =
                            Some
                              {
                                any with
                                kinds = Some [ String ];
                                min_length = Some 1;
                              };
                        } );
                    ];
                  closed = Some [ "exempt"; "live"; "wire"; "worker" ];
                };
          } );
        ("target", { any with reference = Some "LocalTarget" });
      ];
    closed = Some [ "launcher"; "modelCatalogue"; "sdks"; "target" ];
  }

let shape_109 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        {
          any with
          kinds = Some [ Object ];
          required = [ "let" ];
          members =
            [
              ("let", { any with kinds = Some [ Object ]; min_members = Some 1 });
            ];
          closed = Some [ "let" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "driver" ];
          members =
            [
              ( "as",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (65, 90); (97, 122) ], 1, Some 1);
                        Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                      ];
                } );
              ( "driver",
                { any with kinds = Some [ String ]; min_length = Some 1 } );
              ("with", { any with kinds = Some [ Object ] });
            ];
          closed = Some [ "as"; "driver"; "fails"; "returns"; "with" ];
          not_all = [ [ "returns"; "fails" ] ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "abandon" ];
          members =
            [
              ( "abandon",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (65, 90); (97, 122) ], 1, Some 1);
                        Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                      ];
                } );
            ];
          closed = Some [ "abandon" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "settles" ];
          members =
            [
              ( "abandoned",
                {
                  any with
                  kinds = Some [ Boolean ];
                  enum = Some [ `Bool true ];
                } );
              ( "settles",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (65, 90); (97, 122) ], 1, Some 1);
                        Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                      ];
                } );
            ];
          closed = Some [ "abandoned"; "fails"; "returns"; "settles" ];
          not_all =
            [
              [ "returns"; "fails" ];
              [ "returns"; "abandoned" ];
              [ "fails"; "abandoned" ];
            ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "wire" ];
          members =
            [
              ( "as",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (65, 90); (97, 122) ], 1, Some 1);
                        Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                      ];
                } );
              ( "at",
                {
                  any with
                  kinds = Some [ String ];
                  enum =
                    Some
                      [
                        `Stringlit "\"arrival\"";
                        `Stringlit "\"answer\"";
                        `Stringlit "\"live\"";
                      ];
                } );
              ( "follows",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (65, 90); (97, 122) ], 1, Some 1);
                        Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                      ];
                } );
              ("headers", { any with kinds = Some [ Object ] });
              ("status", { any with kinds = Some [ Integer ] });
              ( "waited",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (65, 90); (97, 122) ], 1, Some 1);
                        Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                      ];
                } );
              ( "wire",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Group
                          ( [
                              [
                                Step ([ (71, 71) ], 1, Some 1);
                                Step ([ (69, 69) ], 1, Some 1);
                                Step ([ (84, 84) ], 1, Some 1);
                              ];
                              [
                                Step ([ (80, 80) ], 1, Some 1);
                                Step ([ (79, 79) ], 1, Some 1);
                                Step ([ (83, 83) ], 1, Some 1);
                                Step ([ (84, 84) ], 1, Some 1);
                              ];
                              [
                                Step ([ (80, 80) ], 1, Some 1);
                                Step ([ (85, 85) ], 1, Some 1);
                                Step ([ (84, 84) ], 1, Some 1);
                              ];
                              [
                                Step ([ (68, 68) ], 1, Some 1);
                                Step ([ (69, 69) ], 1, Some 1);
                                Step ([ (76, 76) ], 1, Some 1);
                                Step ([ (69, 69) ], 1, Some 1);
                                Step ([ (84, 84) ], 1, Some 1);
                                Step ([ (69, 69) ], 1, Some 1);
                              ];
                              [
                                Step ([ (80, 80) ], 1, Some 1);
                                Step ([ (65, 65) ], 1, Some 1);
                                Step ([ (84, 84) ], 1, Some 1);
                                Step ([ (67, 67) ], 1, Some 1);
                                Step ([ (72, 72) ], 1, Some 1);
                              ];
                            ],
                            1,
                            Some 1 );
                        Step ([ (32, 32) ], 1, Some 1);
                        Step ([ (47, 47) ], 1, Some 1);
                        Step ([ (0, 1114111) ], 0, None);
                      ];
                } );
            ];
          closed =
            Some
              [
                "answer";
                "as";
                "at";
                "body";
                "follows";
                "headers";
                "params";
                "status";
                "token";
                "waited";
                "wire";
              ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "carried"; "is" ];
          members =
            [
              ( "carried",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (65, 90); (97, 122) ], 1, Some 1);
                        Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                      ];
                } );
            ];
          closed = Some [ "carried"; "is" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "closed" ];
          members =
            [
              ( "closed",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (65, 90); (97, 122) ], 1, Some 1);
                        Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                      ];
                } );
            ];
          closed = Some [ "closed" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "progress" ];
          members =
            [
              ( "progress",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (65, 90); (97, 122) ], 1, Some 1);
                        Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                      ];
                } );
            ];
          closed = Some [ "progress" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "state" ];
          members =
            [
              ( "state",
                {
                  any with
                  kinds = Some [ String ];
                  enum =
                    Some
                      [
                        `Stringlit "\"initial\"";
                        `Stringlit "\"connecting\"";
                        `Stringlit "\"open\"";
                        `Stringlit "\"reconnecting\"";
                        `Stringlit "\"degraded\"";
                        `Stringlit "\"unauthenticated\"";
                        `Stringlit "\"closed\"";
                      ];
                } );
            ];
          closed = Some [ "state" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "stays" ];
          members =
            [
              ( "stays",
                {
                  any with
                  kinds = Some [ String ];
                  enum =
                    Some
                      [
                        `Stringlit "\"initial\"";
                        `Stringlit "\"connecting\"";
                        `Stringlit "\"open\"";
                        `Stringlit "\"reconnecting\"";
                        `Stringlit "\"degraded\"";
                        `Stringlit "\"unauthenticated\"";
                        `Stringlit "\"closed\"";
                      ];
                } );
            ];
          closed = Some [ "stays" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "frame"; "is" ];
          members =
            [
              ( "frame",
                { any with kinds = Some [ String ]; min_length = Some 1 } );
            ];
          closed = Some [ "frame"; "is" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "frames"; "count" ];
          members =
            [
              ( "count",
                { any with kinds = Some [ Integer ]; minimum = Some "1" } );
              ( "frames",
                { any with kinds = Some [ String ]; min_length = Some 1 } );
            ];
          closed = Some [ "count"; "frames" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "error" ];
          closed = Some [ "error" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "backend" ];
          members =
            [
              ( "backend",
                {
                  any with
                  kinds = Some [ String ];
                  enum =
                    Some
                      [
                        `Stringlit "\"listen\"";
                        `Stringlit "\"emit\"";
                        `Stringlit "\"record\"";
                        `Stringlit "\"content\"";
                        `Stringlit "\"description\"";
                        `Stringlit "\"annotations\"";
                        `Stringlit "\"anchored-text\"";
                        `Stringlit "\"uploaded\"";
                        `Stringlit "\"refuse\"";
                        `Stringlit "\"unanswered\"";
                        `Stringlit "\"answer-lost\"";
                        `Stringlit "\"hold\"";
                        `Stringlit "\"release\"";
                        `Stringlit "\"rechunk\"";
                        `Stringlit "\"carry\"";
                        `Stringlit "\"cut\"";
                        `Stringlit "\"down\"";
                        `Stringlit "\"up\"";
                        `Stringlit "\"archivist\"";
                      ];
                } );
              ("with", { any with kinds = Some [ Object ] });
            ];
          closed = Some [ "backend"; "with" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "quiet" ];
          members =
            [
              ( "quiet",
                { any with kinds = Some [ Integer ]; minimum = Some "1" } );
            ];
          closed = Some [ "quiet" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "observe"; "as" ];
          members =
            [
              ( "as",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (65, 90); (97, 122) ], 1, Some 1);
                        Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                      ];
                } );
              ( "observe",
                {
                  any with
                  kinds = Some [ Object ];
                  required = [ "query" ];
                  members =
                    [
                      ( "query",
                        {
                          any with
                          kinds = Some [ String ];
                          min_length = Some 1;
                        } );
                    ];
                  closed =
                    Some
                      [ "annotation"; "filters"; "query"; "resource"; "search" ];
                } );
            ];
          closed = Some [ "as"; "observe" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "leave" ];
          members =
            [
              ( "leave",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (65, 90); (97, 122) ], 1, Some 1);
                        Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                      ];
                } );
            ];
          closed = Some [ "leave" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "reaches"; "state" ];
          members =
            [
              ( "reaches",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (65, 90); (97, 122) ], 1, Some 1);
                        Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                      ];
                } );
            ];
          closed = Some [ "reaches"; "state" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "holds"; "state" ];
          members =
            [
              ( "holds",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (65, 90); (97, 122) ], 1, Some 1);
                        Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                      ];
                } );
            ];
          closed = Some [ "holds"; "state" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "completes" ];
          members =
            [
              ( "completes",
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (65, 90); (97, 122) ], 1, Some 1);
                        Step ([ (48, 57); (65, 90); (97, 122) ], 0, None);
                      ];
                } );
            ];
          closed = Some [ "completes" ];
        };
        { any with reference = Some "ConformanceBusFetch" };
        { any with reference = Some "ConformanceHttpFetch" };
        {
          any with
          kinds = Some [ Object ];
          required = [ "fetches" ];
          members =
            [
              ( "fetches",
                {
                  any with
                  kinds = Some [ Array ];
                  min_items = Some 2;
                  items =
                    Some
                      {
                        any with
                        kinds = Some [ Object ];
                        variants =
                          [
                            { any with reference = Some "ConformanceBusFetch" };
                            { any with reference = Some "ConformanceHttpFetch" };
                          ];
                      };
                } );
            ];
          closed = Some [ "fetches" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "scopes" ];
          members = [ ("scopes", { any with kinds = Some [ Array ] }) ];
          closed = Some [ "scopes" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "claimed" ];
          closed = Some [ "claimed" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "refused" ];
          closed = Some [ "refused" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "signalled" ];
          closed = Some [ "signalled" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "stalled" ];
          closed = Some [ "stalled" ];
        };
      ];
  }

let shape_110 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "did"; "description" ];
    members =
      [
        ("description", { any with reference = Some "KbDescription" });
        ("did", { any with reference = Some "UserId" });
      ];
    closed = Some [ "description"; "did" ];
  }

let shape_111 () = { any with kinds = Some [ String ] }

let shape_112 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "summary"; "relevantFields"; "context" ];
    members =
      [
        ( "context",
          {
            any with
            kinds = Some [ Object ];
            required = [ "selected" ];
            members =
              [
                ("after", { any with kinds = Some [ String ] });
                ("before", { any with kinds = Some [ String ] });
                ("selected", { any with kinds = Some [ String ] });
              ];
          } );
        ( "relevantFields",
          {
            any with
            kinds = Some [ Object ];
            required = [ "resourceId"; "resourceName"; "entityTypes" ];
            members =
              [
                ( "entityTypes",
                  {
                    any with
                    kinds = Some [ Array ];
                    items = Some { any with kinds = Some [ String ] };
                  } );
                ("resourceId", { any with reference = Some "ResourceId" });
                ("resourceName", { any with kinds = Some [ String ] });
              ];
            closed = Some [ "entityTypes"; "resourceId"; "resourceName" ];
          } );
        ("summary", { any with kinds = Some [ String ] });
      ];
  }

let shape_113 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "target"; "motivation" ];
    members =
      [
        ("body", { any with reference = Some "AnnotationBodies" });
        ("motivation", { any with reference = Some "Motivation" });
        ("target", { any with reference = Some "AnnotationTarget" });
      ];
  }

let shape_114 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "token"; "name"; "content" ];
    members =
      [
        ("archiveOriginal", { any with kinds = Some [ Boolean ] });
        ("content", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
        ("token", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "archiveOriginal"; "content"; "name"; "token" ];
  }

let shape_115 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId" ];
    members = [ ("resourceId", { any with reference = Some "ResourceId" }) ];
  }

let shape_116 () = { any with kinds = Some [ String ]; min_length = Some 1 }

let shape_117 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "userCode"; "verificationUri"; "expiresIn" ];
    members =
      [
        ("expiresIn", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("userCode", { any with kinds = Some [ String ] });
        ("verificationUri", { any with kinds = Some [ String ] });
        ("verificationUriComplete", { any with kinds = Some [ String ] });
      ];
    closed =
      Some
        [
          "expiresIn"; "userCode"; "verificationUri"; "verificationUriComplete";
        ];
  }

let shape_118 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type"; "name"; "path"; "mtime" ];
    members =
      [
        ("mtime", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
        ("path", { any with kinds = Some [ String ] });
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"dir\"" ];
          } );
      ];
    closed = Some [ "mtime"; "name"; "path"; "type" ];
  }

let shape_119 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "FileEntry" };
        { any with reference = Some "DirEntry" };
      ];
    discriminator = Some ("type", [ ("file", 0); ("dir", 1) ]);
  }

let shape_120 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "host"; "port"; "placement"; "did"; "managedBy" ];
    members =
      [
        ("did", { any with kinds = Some [ String ] });
        ("host", { any with kinds = Some [ String ] });
        ("managedBy", { any with kinds = Some [ String ] });
        ( "placement",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"local\""; `Stringlit "\"codespace\"" ];
          } );
        ("port", { any with kinds = Some [ Integer ] });
        ("repo", { any with kinds = Some [ String ] });
        ("siteName", { any with kinds = Some [ String ] });
      ];
  }

let shape_121 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"not-found\"";
          `Stringlit "\"not-json\"";
          `Stringlit "\"invalid\"";
          `Stringlit "\"unsupported-version\"";
          `Stringlit "\"unreadable\"";
        ];
  }

let shape_122 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "version"; "kbs" ];
    members =
      [
        ( "kbs",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "DiscoveredKB" };
          } );
        ( "version",
          { any with kinds = Some [ Integer ]; enum = Some [ `Intlit "1" ] } );
      ];
  }

let shape_123 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [
        "kb";
        "gatewayUrl";
        "identity";
        "queue";
        "port";
        "timing";
        "logLevel";
        "logFormat";
      ];
    members =
      [
        ("gatewayUrl", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("identity", { any with reference = Some "ServiceIdentity" });
        ("kb", { any with reference = Some "KbIdentity" });
        ("logFormat", { any with reference = Some "LogFormat" });
        ("logLevel", { any with reference = Some "LogLevel" });
        ( "port",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "65535";
          } );
        ( "queue",
          {
            any with
            kinds = Some [ Object ];
            required = [ "servers" ];
            members =
              [
                ( "passwordEnv",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
                ( "servers",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
                ( "userEnv",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
              ];
            closed = Some [ "passwordEnv"; "servers"; "userEnv" ];
          } );
        ( "timing",
          {
            any with
            kinds = Some [ Object ];
            required =
              [
                "tickMs";
                "staleRunningMs";
                "ackWaitMs";
                "retentionMs";
                "retentionSweepMs";
                "progressWriteIntervalMs";
                "bootDeadlineMs";
              ];
            members =
              [
                ( "ackWaitMs",
                  { any with kinds = Some [ Integer ]; minimum = Some "1" } );
                ( "bootDeadlineMs",
                  { any with kinds = Some [ Integer ]; minimum = Some "1" } );
                ( "progressWriteIntervalMs",
                  { any with kinds = Some [ Integer ]; minimum = Some "1" } );
                ( "retentionMs",
                  { any with kinds = Some [ Integer ]; minimum = Some "1" } );
                ( "retentionSweepMs",
                  { any with kinds = Some [ Integer ]; minimum = Some "1" } );
                ( "staleRunningMs",
                  { any with kinds = Some [ Integer ]; minimum = Some "1" } );
                ( "tickMs",
                  { any with kinds = Some [ Integer ]; minimum = Some "1" } );
              ];
            closed =
              Some
                [
                  "ackWaitMs";
                  "bootDeadlineMs";
                  "progressWriteIntervalMs";
                  "retentionMs";
                  "retentionSweepMs";
                  "staleRunningMs";
                  "tickMs";
                ];
          } );
      ];
    closed =
      Some
        [
          "gatewayUrl";
          "identity";
          "kb";
          "logFormat";
          "logLevel";
          "port";
          "queue";
          "timing";
        ];
  }

let shape_124 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "status"; "queue" ];
    members =
      [
        ( "queue",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"jetstream\"" ];
          } );
        ( "status",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"ok\"" ];
          } );
      ];
    closed = Some [ "queue"; "status" ];
  }

let shape_125 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"acknowledged\"";
          `Stringlit "\"probe-confirmed\"";
          `Stringlit "\"probe-refused\"";
          `Stringlit "\"probe-unreachable\"";
        ];
  }

let shape_126 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "OllamaEmbeddingConfig" };
        { any with reference = Some "VoyageEmbeddingConfig" };
      ];
    discriminator = Some ("type", [ ("ollama", 0); ("voyage", 1) ]);
  }

let shape_127 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "provider"; "model" ];
    members =
      [
        ("model", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "provider",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"anthropic\"";
                  `Stringlit "\"google\"";
                  `Stringlit "\"llamacpp\"";
                  `Stringlit "\"ollama\"";
                  `Stringlit "\"openai\"";
                  `Stringlit "\"together\"";
                  `Stringlit "\"vllm\"";
                ];
          } );
      ];
    closed = Some [ "model"; "provider" ];
  }

let shape_128 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "engine" ];
    members =
      [
        ("engine", { any with reference = Some "Engine" });
        ( "jobs",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "JobFilter" };
          } );
      ];
    closed = Some [ "engine"; "jobs" ];
  }

let shape_129 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "engine"; "limits" ];
    members =
      [
        ("engine", { any with reference = Some "Engine" });
        ("limits", { any with reference = Some "InferenceLimits" });
      ];
    closed = Some [ "engine"; "limits" ];
  }

let shape_130 () =
  {
    any with
    kinds = Some [ Object ];
    all_of =
      [
        { any with reference = Some "StoredEventResponse" };
        {
          any with
          kinds = Some [ Object ];
          members =
            [ ("annotation", { any with reference = Some "Annotation" }) ];
        };
      ];
  }

let shape_131 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "entityType" ];
    members = [ ("entityType", { any with kinds = Some [ String ] }) ];
  }

let shape_132 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "entityType" ];
    members = [ ("entityType", { any with kinds = Some [ String ] }) ];
  }

let shape_133 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "entityTypes" ];
    members =
      [
        ( "entityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
      ];
    closed = Some [ "entityTypes" ];
  }

let shape_134 () =
  {
    any with
    kinds = Some [ String ];
    pattern =
      Some
        [
          Step ([ (101, 101) ], 1, Some 1);
          Step ([ (45, 45) ], 1, Some 1);
          Step ([ (0, 57); (59, 1114111) ], 1, None);
        ];
  }

let shape_135 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "code"; "retryable" ];
    members =
      [
        ( "choices",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "Target" };
          } );
        ( "code",
          {
            any with
            kinds = Some [ String ];
            pattern =
              Some
                [
                  Step ([ (99, 99) ], 1, Some 1);
                  Step ([ (111, 111) ], 1, Some 1);
                  Step ([ (110, 110) ], 1, Some 1);
                  Step ([ (116, 116) ], 1, Some 1);
                  Step ([ (114, 114) ], 1, Some 1);
                  Step ([ (111, 111) ], 1, Some 1);
                  Step ([ (108, 108) ], 1, Some 1);
                  Step ([ (46, 46) ], 1, Some 1);
                  Step ([ (97, 122) ], 1, None);
                  Group
                    ( [
                        [
                          Step ([ (45, 45) ], 1, Some 1);
                          Step ([ (97, 122) ], 1, None);
                        ];
                      ],
                      0,
                      None );
                ];
          } );
        ( "fields",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "FieldFault" };
          } );
        ("mayStillRun", { any with kinds = Some [ Boolean ] });
        ("retryable", { any with kinds = Some [ Boolean ] });
        ( "supported",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
      ];
    closed =
      Some
        [ "choices"; "code"; "fields"; "mayStillRun"; "retryable"; "supported" ];
  }

let shape_136 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "error" ];
    members =
      [
        ("code", { any with kinds = Some [ String ] });
        ("error", { any with kinds = Some [ String ] });
        ("hint", { any with kinds = Some [ String ] });
      ];
  }

let shape_137 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "sequenceNumber" ];
    members = [ ("sequenceNumber", { any with kinds = Some [ Integer ] }) ];
  }

let shape_138 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "did" ];
    members =
      [
        ("did", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "did"; "name" ];
  }

let shape_139 () =
  {
    any with
    kinds = Some [ Object ];
    all_of =
      [
        { any with reference = Some "AnchoredText" };
        {
          any with
          kinds = Some [ Object ];
          required = [ "kind"; "method" ];
          members =
            [
              ( "kind",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"extracted\"" ];
                } );
              ("method", { any with reference = Some "ExtractionMethod" });
              ("ocrConfidence", { any with reference = Some "OcrConfidence" });
              ("pdfClass", { any with reference = Some "PdfClass" });
              ( "unreadPages",
                {
                  any with
                  kinds = Some [ Array ];
                  items = Some { any with kinds = Some [ Integer ] };
                } );
            ];
        };
      ];
  }

let shape_140 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "kind"; "declined" ];
    members =
      [
        ("declined", { any with reference = Some "ExtractionDeclinedReason" });
        ( "kind",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"declined\"" ];
          } );
      ];
  }

let shape_141 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"no-text-layer\"";
          `Stringlit "\"encrypted\"";
          `Stringlit "\"corrupt\"";
          `Stringlit "\"too-large\"";
        ];
  }

let shape_142 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"text-passthrough\"";
          `Stringlit "\"pdf-text-layer\"";
          `Stringlit "\"table\"";
          `Stringlit "\"form\"";
          `Stringlit "\"ocr\"";
        ];
  }

let shape_143 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "ExtractedText" };
        { any with reference = Some "ExtractionDeclined" };
      ];
    discriminator = Some ("kind", [ ("extracted", 0); ("declined", 1) ]);
  }

let shape_144 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"transient\"";
          `Stringlit "\"deterministic\"";
          `Stringlit "\"withheld\"";
        ];
  }

let shape_145 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "field"; "message" ];
    members =
      [
        ("field", { any with kinds = Some [ String ] });
        ("message", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "field"; "message" ];
  }

let shape_146 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type"; "name"; "path"; "size"; "mtime"; "tracked" ];
    members =
      [
        ("annotationCount", { any with kinds = Some [ Integer ] });
        ("creator", { any with kinds = Some [ String ] });
        ( "entityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("mtime", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
        ("path", { any with kinds = Some [ String ] });
        ("resourceId", { any with reference = Some "ResourceId" });
        ("size", { any with kinds = Some [ Integer ] });
        ("tracked", { any with kinds = Some [ Boolean ] });
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"file\"" ];
          } );
      ];
    closed =
      Some
        [
          "annotationCount";
          "creator";
          "entityTypes";
          "mtime";
          "name";
          "path";
          "resourceId";
          "size";
          "tracked";
          "type";
        ];
  }

let shape_147 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "sweep"; "stopped"; "refused"; "streamDrops" ];
    members =
      [
        ("refused", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("stopped", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ( "streamDrops",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ( "sweep",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"pending\"";
                  `Stringlit "\"running\"";
                  `Stringlit "\"done\"";
                  `Stringlit "\"due\"";
                ];
          } );
      ];
    closed = Some [ "refused"; "stopped"; "streamDrops"; "sweep" ];
  }

let shape_148 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type"; "value" ];
    members =
      [
        ("conformsTo", { any with kinds = Some [ String ] });
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"FragmentSelector\"" ];
          } );
        ("value", { any with kinds = Some [ String ] });
      ];
  }

let shape_149 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "tag" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("tag", { any with kinds = Some [ String ] });
      ];
  }

let shape_150 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "schema" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("schema", { any with reference = Some "TagSchema" });
      ];
  }

let shape_151 () =
  {
    any with
    kinds = Some [ String ];
    enum = Some [ `Stringlit "\"lacks\""; `Stringlit "\"malformed\"" ];
  }

let shape_152 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [
        "kb";
        "port";
        "publicUrl";
        "identity";
        "archivist";
        "signal";
        "logLevel";
        "logFormat";
        "capacity";
      ];
    members =
      [
        ("archivist", { any with reference = Some "ServiceAddress" });
        ( "capacity",
          {
            any with
            kinds = Some [ Object ];
            required = [ "queuedBytes"; "connections" ];
            members =
              [
                ( "connections",
                  { any with kinds = Some [ Integer ]; minimum = Some "1" } );
                ( "queuedBytes",
                  { any with kinds = Some [ Integer ]; minimum = Some "1" } );
              ];
            closed = Some [ "connections"; "queuedBytes" ];
          } );
        ( "identity",
          {
            any with
            kinds = Some [ Object ];
            required = [ "issuer"; "subjectClaim" ];
            members =
              [
                ( "issuer",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
                ( "subjectClaim",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
              ];
            closed = Some [ "issuer"; "subjectClaim" ];
          } );
        ("kb", { any with reference = Some "KbIdentity" });
        ("logFormat", { any with reference = Some "LogFormat" });
        ("logLevel", { any with reference = Some "LogLevel" });
        ( "port",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "65535";
          } );
        ("publicUrl", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "signal",
          {
            any with
            kinds = Some [ Object ];
            required = [ "type" ];
            members =
              [
                ( "passwordEnv",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
                ( "servers",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
                ( "type",
                  {
                    any with
                    kinds = Some [ String ];
                    enum =
                      Some
                        [ `Stringlit "\"in-process\""; `Stringlit "\"nats\"" ];
                  } );
                ( "userEnv",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
              ];
            closed = Some [ "passwordEnv"; "servers"; "type"; "userEnv" ];
          } );
      ];
    closed =
      Some
        [
          "archivist";
          "capacity";
          "identity";
          "kb";
          "logFormat";
          "logLevel";
          "port";
          "publicUrl";
          "signal";
        ];
  }

let shape_153 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotationId"; "response" ];
    members =
      [
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("response", { any with reference = Some "GatheredContext" });
      ];
  }

let shape_154 () =
  {
    any with
    kinds = Some [ Object ];
    members =
      [
        ( "contextWindow",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "100";
            maximum = Some "5000";
          } );
        ("includeSourceContext", { any with kinds = Some [ Boolean ] });
        ("includeTargetContext", { any with kinds = Some [ Boolean ] });
      ];
  }

let shape_155 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotationId"; "resourceId" ];
    members =
      [
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("options", { any with reference = Some "GatherAnnotationOptions" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_156 () =
  {
    any with
    kinds = Some [ Object ];
    all_of =
      [
        { any with reference = Some "CommandError" };
        {
          any with
          kinds = Some [ Object ];
          required = [ "annotationId" ];
          members =
            [ ("annotationId", { any with reference = Some "AnnotationId" }) ];
        };
      ];
  }

let shape_157 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId" ];
    members =
      [
        ("motivation", { any with reference = Some "Motivation" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_158 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [ ("response", { any with reference = Some "GetReferencedByResponse" }) ];
  }

let shape_159 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "response" ];
    members =
      [
        ("resourceId", { any with reference = Some "ResourceId" });
        ("response", { any with reference = Some "GatheredContext" });
      ];
  }

let shape_160 () =
  {
    any with
    kinds = Some [ Object ];
    all_of =
      [
        { any with reference = Some "CommandError" };
        {
          any with
          kinds = Some [ Object ];
          required = [ "resourceId" ];
          members =
            [ ("resourceId", { any with reference = Some "ResourceId" }) ];
        };
      ];
  }

let shape_161 () =
  {
    any with
    kinds = Some [ Object ];
    members =
      [
        ( "depth",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "3";
          } );
        ( "excludeEntityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("includeContent", { any with kinds = Some [ Boolean ] });
        ("includeSummary", { any with kinds = Some [ Boolean ] });
        ( "maxResources",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "200";
          } );
      ];
    closed =
      Some
        [
          "depth";
          "excludeEntityTypes";
          "includeContent";
          "includeSummary";
          "maxResources";
        ];
  }

let shape_162 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "options" ];
    members =
      [
        ("options", { any with reference = Some "GatherResourceRequestOptions" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_163 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "depth"; "maxResources"; "includeContent"; "includeSummary" ];
    members =
      [
        ( "depth",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "3";
          } );
        ( "excludeEntityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("includeContent", { any with kinds = Some [ Boolean ] });
        ("includeSummary", { any with kinds = Some [ Boolean ] });
        ( "maxResources",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "200";
          } );
      ];
  }

let shape_164 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotationId"; "resourceId" ];
    members =
      [
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_165 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "focus"; "graph"; "metadata" ];
    members =
      [
        ( "focus",
          {
            any with
            kinds = Some [ Object ];
            variants =
              [
                {
                  any with
                  kinds = Some [ Object ];
                  required = [ "kind"; "annotation"; "sourceResource" ];
                  members =
                    [
                      ("annotation", { any with reference = Some "Annotation" });
                      ( "kind",
                        {
                          any with
                          kinds = Some [ String ];
                          enum = Some [ `Stringlit "\"annotation\"" ];
                        } );
                      ( "selected",
                        {
                          any with
                          kinds = Some [ Object ];
                          required = [ "text" ];
                          members =
                            [
                              ("after", { any with kinds = Some [ String ] });
                              ("before", { any with kinds = Some [ String ] });
                              ("text", { any with kinds = Some [ String ] });
                            ];
                        } );
                      ( "sourceResource",
                        { any with reference = Some "ResourceDescriptor" } );
                      ( "targetContext",
                        {
                          any with
                          kinds = Some [ Object ];
                          required = [ "content" ];
                          members =
                            [
                              ("content", { any with kinds = Some [ String ] });
                              ("summary", { any with kinds = Some [ String ] });
                            ];
                        } );
                      ( "targetResource",
                        { any with reference = Some "ResourceDescriptor" } );
                      ("userHint", { any with kinds = Some [ String ] });
                    ];
                };
                {
                  any with
                  kinds = Some [ Object ];
                  required = [ "kind"; "resource" ];
                  members =
                    [
                      ( "content",
                        {
                          any with
                          kinds = Some [ Object ];
                          members =
                            [
                              ("main", { any with kinds = Some [ String ] });
                              ( "related",
                                {
                                  any with
                                  kinds = Some [ Object ];
                                  values =
                                    Some { any with kinds = Some [ String ] };
                                } );
                            ];
                        } );
                      ( "kind",
                        {
                          any with
                          kinds = Some [ String ];
                          enum = Some [ `Stringlit "\"resource\"" ];
                        } );
                      ( "resource",
                        { any with reference = Some "ResourceDescriptor" } );
                      ( "suggestedReferences",
                        {
                          any with
                          kinds = Some [ Array ];
                          items = Some { any with kinds = Some [ String ] };
                        } );
                      ("summary", { any with kinds = Some [ String ] });
                    ];
                };
              ];
          } );
        ("graph", { any with reference = Some "KnowledgeGraph" });
        ("inferredRelationshipSummary", { any with kinds = Some [ String ] });
        ( "metadata",
          {
            any with
            kinds = Some [ Object ];
            members =
              [
                ( "entityTypeFrequencies",
                  {
                    any with
                    kinds = Some [ Object ];
                    values = Some { any with kinds = Some [ Integer ] };
                  } );
                ( "entityTypes",
                  {
                    any with
                    kinds = Some [ Array ];
                    items = Some { any with kinds = Some [ String ] };
                  } );
                ("language", { any with kinds = Some [ String ] });
                ("resourceType", { any with kinds = Some [ String ] });
              ];
          } );
        ( "semanticContext",
          {
            any with
            kinds = Some [ Object ];
            required = [ "similar" ];
            members =
              [
                ( "excludedEntityTypes",
                  {
                    any with
                    kinds = Some [ Array ];
                    items = Some { any with kinds = Some [ String ] };
                  } );
                ( "similar",
                  {
                    any with
                    kinds = Some [ Array ];
                    items = Some { any with reference = Some "SemanticMatch" };
                  } );
              ];
          } );
      ];
  }

let shape_166 () =
  {
    any with
    kinds = Some [ Object ];
    all_of =
      [
        { any with reference = Some "GenerationJobRequest" };
        {
          any with
          kinds = Some [ Object ];
          required = [ "context" ];
          members =
            [ ("context", { any with reference = Some "GatheredContext" }) ];
        };
      ];
  }

let shape_167 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "title"; "storageUri" ];
    members =
      [
        ("cite", { any with kinds = Some [ Boolean ] });
        ( "entityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("language", { any with kinds = Some [ String ] });
        ("maxTokens", { any with kinds = Some [ Number ] });
        ("outputMediaType", { any with reference = Some "SupportedMediaType" });
        ("prompt", { any with kinds = Some [ String ] });
        ("sourceLanguage", { any with kinds = Some [ String ] });
        ("storageUri", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("structure", { any with kinds = Some [ String ] });
        ("task", { any with kinds = Some [ String ] });
        ("temperature", { any with kinds = Some [ Number ] });
        ("title", { any with kinds = Some [ String ]; min_length = Some 1 });
      ];
  }

let shape_168 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "events"; "total"; "annotationId"; "resourceId" ];
    members =
      [
        ("annotationId", { any with reference = Some "AnnotationId" });
        ( "events",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "AttributedEvent" };
          } );
        ("resourceId", { any with reference = Some "ResourceId" });
        ("total", { any with kinds = Some [ Number ] });
      ];
  }

let shape_169 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotation"; "resource"; "resolvedResource" ];
    members =
      [
        ("annotation", { any with reference = Some "Annotation" });
        ( "resolvedResource",
          {
            any with
            kinds = Some [ Object; Null ];
            variants =
              [
                { any with kinds = Some [ Null ] };
                { any with reference = Some "ResourceDescriptor" };
              ];
          } );
        ( "resource",
          {
            any with
            kinds = Some [ Object; Null ];
            variants =
              [
                { any with kinds = Some [ Null ] };
                { any with reference = Some "ResourceDescriptor" };
              ];
          } );
      ];
  }

let shape_170 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotations"; "total" ];
    members =
      [
        ( "annotations",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "Annotation" };
          } );
        ("motivation", { any with reference = Some "Motivation" });
        ("total", { any with kinds = Some [ Number ] });
      ];
  }

let shape_171 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "entityTypes" ];
    members =
      [
        ( "entityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
      ];
  }

let shape_172 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "events"; "total"; "resourceId" ];
    members =
      [
        ( "events",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "AttributedEvent" };
          } );
        ("resourceId", { any with reference = Some "ResourceId" });
        ("total", { any with kinds = Some [ Number ] });
      ];
  }

let shape_173 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "referencedBy" ];
    members =
      [
        ( "referencedBy",
          {
            any with
            kinds = Some [ Array ];
            items =
              Some
                {
                  any with
                  reference = Some "GetReferencedByResponseReferencedByItem";
                };
          } );
      ];
  }

let shape_174 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "id"; "target" ];
    members =
      [
        ("id", { any with reference = Some "AnnotationId" });
        ( "resourceName",
          { any with kinds = Some [ String ]; min_length = Some 1 } );
        ( "target",
          {
            any with
            kinds = Some [ Object ];
            required = [ "source"; "selector" ];
            members =
              [
                ( "selector",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "exact" ];
                    members =
                      [ ("exact", { any with kinds = Some [ String ] }) ];
                  } );
                ("source", { any with reference = Some "ResourceId" });
              ];
          } );
      ];
  }

let shape_175 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "sourceResource"; "expiresAt" ];
    members =
      [
        ("expiresAt", { any with kinds = Some [ String ] });
        ("sourceResource", { any with reference = Some "ResourceDescriptor" });
      ];
  }

let shape_176 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resource"; "annotations" ];
    members =
      [
        ( "annotations",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "Annotation" };
          } );
        ("resource", { any with reference = Some "ResourceDescriptor" });
      ];
  }

let shape_177 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "tagSchemas" ];
    members =
      [
        ( "tagSchemas",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "TagSchema" };
          } );
      ];
  }

let shape_178 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "id"; "type"; "label"; "annotation" ];
    members =
      [
        ("annotation", { any with reference = Some "Annotation" });
        ( "entityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("id", { any with reference = Some "AnnotationId" });
        ("label", { any with kinds = Some [ String ] });
        ("metadata", { any with kinds = Some [ Object ] });
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"annotation\"" ];
          } );
      ];
  }

let shape_179 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "Neo4jGraphConfig" };
        { any with reference = Some "JanusGraphConfig" };
        { any with reference = Some "NeptuneGraphConfig" };
        { any with reference = Some "MemoryGraphConfig" };
      ];
    discriminator =
      Some
        ( "type",
          [ ("neo4j", 0); ("janusgraph", 1); ("neptune", 2); ("memory", 3) ] );
  }

let shape_180 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "id"; "type"; "label" ];
    members =
      [
        ( "entityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("id", { any with reference = Some "ResourceId" });
        ("label", { any with kinds = Some [ String ] });
        ("metadata", { any with kinds = Some [ Object ] });
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"resource\"" ];
          } );
      ];
  }

let shape_181 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "status"; "message"; "version"; "timestamp" ];
    members =
      [
        ("message", { any with kinds = Some [ String ] });
        ("status", { any with kinds = Some [ String ] });
        ("timestamp", { any with kinds = Some [ String ] });
        ("version", { any with kinds = Some [ String ] });
      ];
  }

let shape_182 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "motivation" ];
    members =
      [
        ("density", { any with kinds = Some [ Number ] });
        ("instructions", { any with kinds = Some [ String ] });
        ( "motivation",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"highlighting\"" ];
          } );
        ("sourceLanguage", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "density"; "instructions"; "motivation"; "sourceLanguage" ];
  }

let shape_183 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "host"; "port" ];
    members =
      [
        ("host", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "port",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "65535";
          } );
      ];
    closed = Some [ "host"; "port" ];
  }

let shape_184 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "kind"; "host"; "port"; "protocol" ];
    members =
      [
        ("host", { any with kinds = Some [ String ] });
        ( "kind",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"http\"" ];
          } );
        ( "port",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "65535";
          } );
        ( "protocol",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"http\""; `Stringlit "\"https\"" ];
          } );
      ];
  }

let shape_185 () =
  {
    any with
    kinds = Some [ Integer ];
    minimum = Some "100";
    maximum = Some "599";
  }

let shape_186 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "email"; "identity"; "enabled" ];
    members =
      [
        ("email", { any with kinds = Some [ String ] });
        ("enabled", { any with kinds = Some [ Boolean ] });
        ("identity", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "email"; "enabled"; "identity" ];
  }

let shape_187 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "target"; "email"; "generatePassword" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("email", { any with kinds = Some [ String ]; min_length = Some 3 });
        ("generatePassword", { any with kinds = Some [ Boolean ] });
        ("password", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("target", { any with reference = Some "LocalTarget" });
      ];
    closed =
      Some [ "apiVersion"; "email"; "generatePassword"; "password"; "target" ];
    variants =
      [
        {
          any with
          kinds = Some [ Object ];
          required = [ "password" ];
          members =
            [
              ( "generatePassword",
                {
                  any with
                  kinds = Some [ Boolean ];
                  enum = Some [ `Bool false ];
                } );
            ];
        };
        {
          any with
          kinds = Some [ Object ];
          members =
            [
              ( "generatePassword",
                {
                  any with
                  kinds = Some [ Boolean ];
                  enum = Some [ `Bool true ];
                } );
            ];
          not_all = [ [ "password" ] ];
        };
      ];
  }

let shape_188 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "email"; "identity"; "created" ];
    members =
      [
        ("created", { any with kinds = Some [ Boolean ] });
        ("email", { any with kinds = Some [ String ] });
        ("generatedPassword", { any with kinds = Some [ String ] });
        ("identity", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "created"; "email"; "generatedPassword"; "identity" ];
  }

let shape_189 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "target" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("target", { any with reference = Some "LocalTarget" });
      ];
    closed = Some [ "apiVersion"; "target" ];
  }

let shape_190 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "users" ];
    members =
      [
        ( "users",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "IdentityUser" };
          } );
      ];
    closed = Some [ "users" ];
  }

let shape_191 () = { any with kinds = Some [ String ]; min_length = Some 1 }

let shape_192 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "kind"; "metadata"; "spec" ];
    members =
      [
        ("apiVersion", { any with reference = Some "StackApiVersion" });
        ( "kind",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"Inference\"" ];
          } );
        ("metadata", { any with reference = Some "Metadata" });
        ( "spec",
          {
            any with
            kinds = Some [ Object ];
            required = [ "providers"; "engines" ];
            members =
              [
                ("engines", { any with reference = Some "ArchivistEngines" });
                ( "providers",
                  {
                    any with
                    kinds = Some [ Object ];
                    values = Some { any with reference = Some "Provider" };
                    min_members = Some 1;
                    names =
                      Some
                        {
                          any with
                          kinds = Some [ String ];
                          enum =
                            Some
                              [
                                `Stringlit "\"anthropic\"";
                                `Stringlit "\"google\"";
                                `Stringlit "\"llamacpp\"";
                                `Stringlit "\"ollama\"";
                                `Stringlit "\"openai\"";
                                `Stringlit "\"together\"";
                                `Stringlit "\"vllm\"";
                              ];
                        };
                  } );
              ];
            closed = Some [ "engines"; "providers" ];
          } );
      ];
    closed = Some [ "apiVersion"; "kind"; "metadata"; "spec" ];
  }

let shape_193 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "contextTokens"; "maxOutputTokens" ];
    members =
      [
        ("acceptsTemperature", { any with kinds = Some [ Boolean ] });
        ("contextTokens", { any with kinds = Some [ Number ] });
        ("maxOutputTokens", { any with kinds = Some [ Number ] });
      ];
  }

let shape_194 () = { any with kinds = Some [ Object ] }

let shape_195 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [
        ( "response",
          {
            any with
            kinds = Some [ Object ];
            required = [ "limits" ];
            members =
              [
                ( "limits",
                  {
                    any with
                    kinds = Some [ Array ];
                    items = Some { any with reference = Some "EngineLimits" };
                  } );
              ];
          } );
      ];
  }

let shape_196 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "access"; "refresh" ];
    members =
      [
        ("access", { any with kinds = Some [ String ] });
        ("refresh", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "access"; "refresh" ];
  }

let shape_197 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "kind"; "metadata"; "spec" ];
    members =
      [
        ("apiVersion", { any with reference = Some "StackApiVersion" });
        ( "kind",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"Issuer\"" ];
          } );
        ("metadata", { any with reference = Some "Metadata" });
        ( "spec",
          {
            any with
            kinds = Some [ Object ];
            required = [ "type"; "image"; "resources"; "port"; "database" ];
            members =
              [
                ( "database",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "type"; "name"; "user" ];
                    members =
                      [
                        ( "external",
                          {
                            any with
                            kinds = Some [ Object ];
                            required = [ "host"; "port"; "password" ];
                            members =
                              [
                                ( "host",
                                  {
                                    any with
                                    kinds = Some [ String ];
                                    min_length = Some 1;
                                  } );
                                ( "password",
                                  { any with reference = Some "SecretRef" } );
                                ( "port",
                                  {
                                    any with
                                    kinds = Some [ Integer ];
                                    minimum = Some "1";
                                    maximum = Some "65535";
                                  } );
                              ];
                            closed = Some [ "host"; "password"; "port" ];
                          } );
                        ("image", { any with reference = Some "Image" });
                        ( "name",
                          {
                            any with
                            kinds = Some [ String ];
                            pattern =
                              Some
                                [
                                  Step ([ (95, 95); (97, 122) ], 1, Some 1);
                                  Step
                                    ( [ (48, 57); (95, 95); (97, 122) ],
                                      0,
                                      Some 62 );
                                ];
                          } );
                        ( "port",
                          {
                            any with
                            kinds = Some [ Integer ];
                            minimum = Some "1";
                            maximum = Some "65535";
                          } );
                        ("resources", { any with reference = Some "Resources" });
                        ( "type",
                          {
                            any with
                            kinds = Some [ String ];
                            min_length = Some 1;
                          } );
                        ( "user",
                          {
                            any with
                            kinds = Some [ String ];
                            min_length = Some 1;
                          } );
                      ];
                    closed =
                      Some
                        [
                          "external";
                          "image";
                          "name";
                          "port";
                          "resources";
                          "type";
                          "user";
                        ];
                    all_of =
                      [
                        { any with reference = Some "Runner" };
                        {
                          any with
                          kinds = Some [ Object ];
                          variants =
                            [
                              {
                                any with
                                kinds = Some [ Object ];
                                required = [ "port" ];
                                not_all = [ [ "external" ] ];
                              };
                              {
                                any with
                                kinds = Some [ Object ];
                                required = [ "external" ];
                                not_all = [ [ "port" ] ];
                              };
                            ];
                        };
                      ];
                  } );
                ("image", { any with reference = Some "Image" });
                ( "port",
                  {
                    any with
                    kinds = Some [ Integer ];
                    minimum = Some "1";
                    maximum = Some "65535";
                  } );
                ("resources", { any with reference = Some "Resources" });
                ( "type",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
              ];
            closed = Some [ "database"; "image"; "port"; "resources"; "type" ];
          } );
      ];
    closed = Some [ "apiVersion"; "kind"; "metadata"; "spec" ];
  }

let shape_198 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type"; "host"; "port" ];
    members =
      [
        ("host", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "port",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "65535";
          } );
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"janusgraph\"" ];
          } );
      ];
    closed = Some [ "host"; "port"; "type" ];
  }

let shape_199 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "JobPending" };
        { any with reference = Some "JobRunning" };
        { any with reference = Some "JobComplete" };
        { any with reference = Some "JobFailed" };
        { any with reference = Some "JobCancelled" };
      ];
    discriminator =
      Some
        ( "status",
          [
            ("pending", 0);
            ("running", 1);
            ("complete", 2);
            ("failed", 3);
            ("cancelled", 4);
          ] );
  }

let shape_200 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobId"; "jobType"; "resourceId"; "holder"; "requester" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("holder", { any with reference = Some "UserId" });
        ("jobId", { any with reference = Some "JobId" });
        ("jobType", { any with reference = Some "JobType" });
        ("requester", { any with reference = Some "UserId" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_201 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobId"; "jobType"; "resourceId"; "holder"; "requester" ];
    members =
      [
        ("holder", { any with reference = Some "UserId" });
        ("jobId", { any with reference = Some "JobId" });
        ("jobType", { any with reference = Some "JobType" });
        ("requester", { any with reference = Some "UserId" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_202 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "jobId"; "jobType" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("annotationId", { any with reference = Some "AnnotationId" });
        ( "completedUnits",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("jobId", { any with reference = Some "JobId" });
        ("jobType", { any with reference = Some "JobType" });
        ("resourceId", { any with reference = Some "ResourceId" });
        ( "unitCursors",
          {
            any with
            kinds = Some [ Object ];
            values = Some { any with reference = Some "UnitCursor" };
          } );
      ];
  }

let shape_203 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobId" ];
    members = [ ("jobId", { any with reference = Some "JobId" }) ];
  }

let shape_204 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "cancelled" ];
    members = [ ("cancelled", { any with kinds = Some [ Boolean ] }) ];
  }

let shape_205 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "status"; "metadata"; "params"; "completedAt" ];
    members =
      [
        ("completedAt", { any with kinds = Some [ String ] });
        ("metadata", { any with reference = Some "JobMetadata" });
        ("params", { any with reference = Some "JobParams" });
        ("startedAt", { any with kinds = Some [ String ] });
        ( "status",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"cancelled\"" ];
          } );
      ];
    closed = Some [ "completedAt"; "metadata"; "params"; "startedAt"; "status" ];
  }

let shape_206 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobId"; "completedUnits" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ( "completedUnits",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("jobId", { any with reference = Some "JobId" });
        ( "unitCursors",
          {
            any with
            kinds = Some [ Object ];
            values = Some { any with reference = Some "UnitCursor" };
          } );
      ];
  }

let shape_207 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "accepts" ];
    members =
      [
        ( "_roles",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("_userId", { any with reference = Some "UserId" });
        ( "accepts",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            items = Some { any with reference = Some "JobFilter" };
          } );
      ];
  }

let shape_208 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members = [ ("response", { any with reference = Some "JobRunning" }) ];
    closed = Some [ "response" ];
  }

let shape_209 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [ "status"; "metadata"; "params"; "startedAt"; "completedAt"; "result" ];
    members =
      [
        ("completedAt", { any with kinds = Some [ String ] });
        ("metadata", { any with reference = Some "JobMetadata" });
        ("params", { any with reference = Some "JobParams" });
        ("result", { any with reference = Some "JobStoredResult" });
        ("startedAt", { any with kinds = Some [ String ] });
        ( "status",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"complete\"" ];
          } );
      ];
    closed =
      Some
        [ "completedAt"; "metadata"; "params"; "result"; "startedAt"; "status" ];
  }

let shape_210 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "MarkJobCompleteCommand" };
        { any with reference = Some "YieldJobCompleteCommand" };
      ];
    discriminator = Some ("jobType", [ ("mark", 0); ("yield", 1) ]);
  }

let shape_211 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobId"; "jobType" ];
    members =
      [
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("annotationUri", { any with kinds = Some [ String ] });
        ("attempt", { any with kinds = Some [ Integer ] });
        ("durability", { any with reference = Some "DurabilityEvidence" });
        ("foundCount", { any with kinds = Some [ Integer ] });
        ("jobId", { any with reference = Some "JobId" });
        ("jobType", { any with reference = Some "JobType" });
        ("result", { any with kinds = Some [ Object ] });
        ("resultResourceId", { any with reference = Some "ResourceId" });
        ("totalSteps", { any with kinds = Some [ Integer ] });
      ];
  }

let shape_212 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "MarkJobCreateCommand" };
        { any with reference = Some "YieldJobCreateCommand" };
      ];
    discriminator = Some ("jobType", [ ("mark", 0); ("yield", 1) ]);
  }

let shape_213 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [ ("response", { any with reference = Some "JobCreatedResultResponse" }) ];
  }

let shape_214 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobId" ];
    members = [ ("jobId", { any with reference = Some "JobId" }) ];
  }

let shape_215 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "declined"; "reason" ];
    members =
      [
        ( "declined",
          { any with kinds = Some [ Boolean ]; enum = Some [ `Bool true ] } );
        ( "reason",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"no-text-layer\"";
                  `Stringlit "\"encrypted\"";
                  `Stringlit "\"corrupt\"";
                  `Stringlit "\"too-large\"";
                  `Stringlit "\"empty\"";
                ];
          } );
      ];
    closed = Some [ "declined"; "reason" ];
  }

let shape_216 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "jobId"; "jobType"; "error" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("attempt", { any with kinds = Some [ Integer ] });
        ( "completedUnits",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("durability", { any with reference = Some "DurabilityEvidence" });
        ("error", { any with kinds = Some [ String ] });
        ("failureClass", { any with reference = Some "FailureClass" });
        ("jobId", { any with reference = Some "JobId" });
        ("jobType", { any with reference = Some "JobType" });
        ("resourceId", { any with reference = Some "ResourceId" });
        ( "unitCursors",
          {
            any with
            kinds = Some [ Object ];
            values = Some { any with reference = Some "UnitCursor" };
          } );
        ("willRetry", { any with kinds = Some [ Boolean ] });
      ];
  }

let shape_217 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "status"; "metadata"; "params"; "completedAt"; "error" ];
    members =
      [
        ("completedAt", { any with kinds = Some [ String ] });
        ("error", { any with kinds = Some [ String ] });
        ("failureClass", { any with reference = Some "FailureClass" });
        ("metadata", { any with reference = Some "JobMetadata" });
        ("params", { any with reference = Some "JobParams" });
        ("startedAt", { any with kinds = Some [ String ] });
        ( "status",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"failed\"" ];
          } );
      ];
    closed =
      Some
        [
          "completedAt";
          "error";
          "failureClass";
          "metadata";
          "params";
          "startedAt";
          "status";
        ];
  }

let shape_218 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobId"; "jobType"; "error" ];
    members =
      [
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("attempt", { any with kinds = Some [ Integer ] });
        ("durability", { any with reference = Some "DurabilityEvidence" });
        ("error", { any with kinds = Some [ String ] });
        ("failureClass", { any with reference = Some "FailureClass" });
        ("jobId", { any with reference = Some "JobId" });
        ("jobType", { any with reference = Some "JobType" });
        ("willRetry", { any with kinds = Some [ Boolean ] });
      ];
  }

let shape_219 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "MarkJobFilter" };
        { any with reference = Some "YieldJobFilter" };
      ];
    discriminator = Some ("jobType", [ ("mark", 0); ("yield", 1) ]);
  }

let shape_220 () =
  {
    any with
    kinds = Some [ String ];
    pattern =
      Some
        [
          Step
            ([ (45, 45); (48, 57); (65, 90); (95, 95); (97, 122) ], 1, Some 128);
        ];
  }

let shape_221 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "id"; "type"; "userId"; "created"; "retryCount"; "maxRetries" ];
    members =
      [
        ( "completedUnits",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("created", { any with kinds = Some [ String ] });
        ("id", { any with reference = Some "JobId" });
        ("maxRetries", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("retryCount", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("type", { any with reference = Some "JobType" });
        ( "unitCursors",
          {
            any with
            kinds = Some [ Object ];
            values = Some { any with reference = Some "UnitCursor" };
          } );
        ("userId", { any with reference = Some "UserId" });
      ];
    closed =
      Some
        [
          "completedUnits";
          "created";
          "id";
          "maxRetries";
          "retryCount";
          "type";
          "unitCursors";
          "userId";
        ];
  }

let shape_222 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId" ];
    members =
      [
        ("resourceId", { any with reference = Some "ResourceId" });
        ("schema", { any with reference = Some "TagSchema" });
      ];
  }

let shape_223 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "status"; "metadata"; "params" ];
    members =
      [
        ("metadata", { any with reference = Some "JobMetadata" });
        ("params", { any with reference = Some "JobParams" });
        ( "status",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"pending\"" ];
          } );
      ];
    closed = Some [ "metadata"; "params"; "status" ];
  }

let shape_224 () =
  {
    any with
    kinds = Some [ Object ];
    members =
      [
        ("everyMs", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("withinMs", { any with kinds = Some [ Integer ]; minimum = Some "0" });
      ];
    closed = Some [ "everyMs"; "withinMs" ];
  }

let shape_225 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "percentage" ];
    members =
      [
        ("annotationId", { any with reference = Some "AnnotationId" });
        ( "completedItems",
          {
            any with
            kinds = Some [ Array ];
            items =
              Some
                {
                  any with
                  kinds = Some [ Object ];
                  required = [ "value"; "foundCount" ];
                  members =
                    [
                      ("foundCount", { any with kinds = Some [ Integer ] });
                      ("persistedCount", { any with kinds = Some [ Integer ] });
                      ( "underReported",
                        {
                          any with
                          kinds = Some [ Object ];
                          required = [ "pieces"; "found"; "counted" ];
                          members =
                            [
                              ("counted", { any with kinds = Some [ Integer ] });
                              ("found", { any with kinds = Some [ Integer ] });
                              ("pieces", { any with kinds = Some [ Integer ] });
                            ];
                        } );
                      ("value", { any with kinds = Some [ String ] });
                    ];
                };
          } );
        ( "current",
          {
            any with
            kinds = Some [ Object ];
            required = [ "kind"; "value" ];
            members =
              [
                ( "kind",
                  {
                    any with
                    kinds = Some [ String ];
                    enum =
                      Some
                        [
                          `Stringlit "\"entity-type\"";
                          `Stringlit "\"category\"";
                        ];
                  } );
                ("value", { any with kinds = Some [ String ] });
              ];
          } );
        ("entitiesEmitted", { any with kinds = Some [ Integer ] });
        ("entitiesExpected", { any with kinds = Some [ Integer ] });
        ("entitiesFound", { any with kinds = Some [ Integer ] });
        ("message", { any with reference = Some "JobProgressMessage" });
        ("percentage", { any with kinds = Some [ Number ] });
        ("processed", { any with kinds = Some [ Integer ] });
        ( "requestParams",
          {
            any with
            kinds = Some [ Array ];
            items =
              Some
                {
                  any with
                  kinds = Some [ Object ];
                  required = [ "label"; "value" ];
                  members =
                    [
                      ( "label",
                        {
                          any with
                          kinds = Some [ String ];
                          enum =
                            Some
                              [
                                `Stringlit "\"entity-types\"";
                                `Stringlit "\"instructions\"";
                                `Stringlit "\"tone\"";
                                `Stringlit "\"density\"";
                              ];
                        } );
                      ("value", { any with kinds = Some [ String ] });
                    ];
                };
          } );
        ("total", { any with kinds = Some [ Integer ] });
      ];
  }

let shape_226 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "code" ];
    members =
      [
        ( "code",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"analyzing\"" ];
          } );
      ];
  }

let shape_227 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "code" ];
    members =
      [
        ( "code",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"analyzing-tags\"" ];
          } );
      ];
  }

let shape_228 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "code"; "count"; "motivation" ];
    members =
      [
        ( "code",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"complete-created\"" ];
          } );
        ("count", { any with kinds = Some [ Integer ] });
        ("motivation", { any with reference = Some "Motivation" });
      ];
  }

let shape_229 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "code"; "truncated" ];
    members =
      [
        ( "code",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"complete-generated\"" ];
          } );
        ("truncated", { any with kinds = Some [ Boolean ] });
      ];
  }

let shape_230 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "code"; "count" ];
    members =
      [
        ( "code",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"creating-annotations\"" ];
          } );
        ("count", { any with kinds = Some [ Integer ] });
      ];
  }

let shape_231 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "code" ];
    members =
      [
        ( "code",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"creating-resource\"" ];
          } );
      ];
  }

let shape_232 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "code"; "count" ];
    members =
      [
        ( "code",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"creating-tag-annotations\"" ];
          } );
        ("count", { any with kinds = Some [ Integer ] });
      ];
  }

let shape_233 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "code"; "entityType" ];
    members =
      [
        ( "code",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"detecting-entities\"" ];
          } );
        ("entityType", { any with kinds = Some [ String ] });
      ];
  }

let shape_234 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "code" ];
    members =
      [
        ( "code",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"generating-resource\"" ];
          } );
      ];
  }

let shape_235 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "code" ];
    members =
      [
        ( "code",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"loading\"" ];
          } );
      ];
  }

let shape_236 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "JobProgressLoading" };
        { any with reference = Some "JobProgressAnalyzing" };
        { any with reference = Some "JobProgressAnalyzingTags" };
        { any with reference = Some "JobProgressGeneratingResource" };
        { any with reference = Some "JobProgressCreatingResource" };
        { any with reference = Some "JobProgressCompleteGenerated" };
        { any with reference = Some "JobProgressDetectingEntities" };
        { any with reference = Some "JobProgressCreatingAnnotations" };
        { any with reference = Some "JobProgressCreatingTagAnnotations" };
        { any with reference = Some "JobProgressCompleteCreated" };
      ];
    discriminator =
      Some
        ( "code",
          [
            ("loading", 0);
            ("analyzing", 1);
            ("analyzing-tags", 2);
            ("generating-resource", 3);
            ("creating-resource", 4);
            ("complete-generated", 5);
            ("detecting-entities", 6);
            ("creating-annotations", 7);
            ("creating-tag-annotations", 8);
            ("complete-created", 9);
          ] );
  }

let shape_237 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "MarkJobQueuedEvent" };
        { any with reference = Some "YieldJobQueuedEvent" };
      ];
    discriminator = Some ("jobType", [ ("mark", 0); ("yield", 1) ]);
  }

let shape_238 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "job"; "lastProgressAt" ];
    members =
      [
        ("job", { any with reference = Some "Job" });
        ("lastProgressAt", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "job"; "lastProgressAt" ];
  }

let shape_239 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "jobId"; "jobType"; "percentage" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("attempt", { any with kinds = Some [ Integer ] });
        ("jobId", { any with reference = Some "JobId" });
        ("jobType", { any with reference = Some "JobType" });
        ("percentage", { any with kinds = Some [ Number ] });
        ("progress", { any with reference = Some "JobProgress" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_240 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "MarkJobDone" };
        { any with reference = Some "YieldJobDone" };
        { any with reference = Some "JobDeclined" };
      ];
  }

let shape_241 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "status"; "metadata"; "params"; "startedAt"; "progress" ];
    members =
      [
        ("metadata", { any with reference = Some "JobMetadata" });
        ("params", { any with reference = Some "JobParams" });
        ("progress", { any with reference = Some "JobStoredProgress" });
        ("startedAt", { any with kinds = Some [ String ] });
        ( "status",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"running\"" ];
          } );
      ];
    closed = Some [ "metadata"; "params"; "progress"; "startedAt"; "status" ];
  }

let shape_242 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "jobId"; "jobType" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("attempt", { any with kinds = Some [ Integer ] });
        ("jobId", { any with reference = Some "JobId" });
        ("jobType", { any with reference = Some "JobType" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_243 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobId"; "jobType" ];
    members =
      [
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("jobId", { any with reference = Some "JobId" });
        ("jobType", { any with reference = Some "JobType" });
        ("totalSteps", { any with kinds = Some [ Integer ] });
      ];
  }

let shape_244 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobId" ];
    members = [ ("jobId", { any with reference = Some "JobId" }) ];
  }

let shape_245 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobId"; "type"; "status"; "userId"; "created" ];
    members =
      [
        ("completedAt", { any with kinds = Some [ String ] });
        ("created", { any with kinds = Some [ String ] });
        ("error", { any with kinds = Some [ String ] });
        ("failureClass", { any with reference = Some "FailureClass" });
        ("jobId", { any with reference = Some "JobId" });
        ("progress", { any with reference = Some "JobStoredProgress" });
        ("result", { any with reference = Some "JobStoredResult" });
        ("startedAt", { any with kinds = Some [ String ] });
        ( "status",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"pending\"";
                  `Stringlit "\"running\"";
                  `Stringlit "\"complete\"";
                  `Stringlit "\"failed\"";
                  `Stringlit "\"cancelled\"";
                ];
          } );
        ("type", { any with reference = Some "JobType" });
        ("userId", { any with reference = Some "UserId" });
      ];
  }

let shape_246 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [ ("response", { any with reference = Some "JobStatusResponse" }) ];
  }

let shape_247 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "JobProgress" };
        { any with kinds = Some [ Object ]; closed = Some [] };
      ];
  }

let shape_248 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "JobResult" };
        { any with kinds = Some [ Object ]; closed = Some [] };
      ];
  }

let shape_249 () =
  {
    any with
    kinds = Some [ String ];
    enum = Some [ `Stringlit "\"mark\""; `Stringlit "\"yield\"" ];
  }

let shape_250 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "name"; "domain" ];
    members =
      [
        ("domain", { any with kinds = Some [ String ] });
        ("gitBranch", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
      ];
  }

let shape_251 () =
  {
    any with
    kinds = Some [ String ];
    pattern =
      Some
        [
          Step ([ (100, 100) ], 1, Some 1);
          Step ([ (105, 105) ], 1, Some 1);
          Step ([ (100, 100) ], 1, Some 1);
          Step ([ (58, 58) ], 1, Some 1);
          Step ([ (119, 119) ], 1, Some 1);
          Step ([ (101, 101) ], 1, Some 1);
          Step ([ (98, 98) ], 1, Some 1);
          Step ([ (58, 58) ], 1, Some 1);
          Step
            ( [
                (0, 8);
                (14, 31);
                (33, 159);
                (161, 5759);
                (5761, 8191);
                (8203, 8231);
                (8234, 8238);
                (8240, 8286);
                (8288, 12287);
                (12289, 65278);
                (65280, 1114111);
              ],
              1,
              None );
        ];
  }

let shape_252 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "HttpEndpoint" };
        { any with reference = Some "LocalEndpoint" };
      ];
    discriminator = Some ("kind", [ ("http", 0); ("local", 1) ]);
  }

let shape_253 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "name"; "domain" ];
    members =
      [
        ( "domain",
          {
            any with
            kinds = Some [ String ];
            pattern =
              Some
                [
                  Step
                    ( [
                        (0, 8);
                        (14, 31);
                        (33, 159);
                        (161, 5759);
                        (5761, 8191);
                        (8203, 8231);
                        (8234, 8238);
                        (8240, 8286);
                        (8288, 12287);
                        (12289, 65278);
                        (65280, 1114111);
                      ],
                      1,
                      None );
                ];
            min_length = Some 1;
          } );
        ("name", { any with kinds = Some [ String ]; min_length = Some 1 });
      ];
    closed = Some [ "domain"; "name" ];
  }

let shape_254 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "expectedDid"; "observedDid" ];
    members =
      [
        ("expectedDid", { any with kinds = Some [ String ] });
        ("observedDid", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "expectedDid"; "observedDid" ];
  }

let shape_255 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "at" ];
    members =
      [
        ("at", { any with kinds = Some [ String ] });
        ("gitBranch", { any with kinds = Some [ String ] });
      ];
  }

let shape_256 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"recorded\"";
          `Stringlit "\"conflict\"";
          `Stringlit "\"no-verdict\"";
        ];
  }

let shape_257 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        {
          any with
          kinds = Some [ Object ];
          required = [ "kind" ];
          members =
            [
              ( "kind",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"recorded\"" ];
                  all_of = [ { any with reference = Some "KbReadKind" } ];
                } );
            ];
          closed = Some [ "kind" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "kind"; "observedDid"; "observedName" ];
          members =
            [
              ( "kind",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"conflict\"" ];
                  all_of = [ { any with reference = Some "KbReadKind" } ];
                } );
              ("observedDid", { any with kinds = Some [ String ] });
              ("observedName", { any with kinds = Some [ String ] });
            ];
          closed = Some [ "kind"; "observedDid"; "observedName" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "kind" ];
          members =
            [
              ( "kind",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"no-verdict\"" ];
                  all_of = [ { any with reference = Some "KbReadKind" } ];
                } );
            ];
          closed = Some [ "kind" ];
        };
      ];
    discriminator =
      Some ("kind", [ ("recorded", 0); ("conflict", 1); ("no-verdict", 2) ]);
  }

let shape_258 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"authenticated\"";
          `Stringlit "\"expired\"";
          `Stringlit "\"signed-out\"";
        ];
  }

let shape_259 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "id"; "label"; "endpoint" ];
    members =
      [
        ("endpoint", { any with reference = Some "KbEndpoint" });
        ("id", { any with kinds = Some [ String ] });
        ("label", { any with kinds = Some [ String ] });
      ];
  }

let shape_260 () =
  {
    any with
    kinds = Some [ Object ];
    all_of =
      [
        { any with reference = Some "KbTarget" };
        { any with reference = Some "NewKnowledgeBase" };
      ];
  }

let shape_261 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [
        "name";
        "key";
        "recorded";
        "placement";
        "starting";
        "healthy";
        "services";
      ];
    members =
      [
        ("did", { any with kinds = Some [ String ] });
        ("gateway", { any with kinds = Some [ String ] });
        ("healthy", { any with kinds = Some [ Boolean ] });
        ("identityError", { any with kinds = Some [ String ] });
        ("kb", { any with reference = Some "DiscoveredKB" });
        ("key", { any with kinds = Some [ String ] });
        ("lan", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
        ( "placement",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"local\""; `Stringlit "\"codespace\"" ];
          } );
        ("recorded", { any with kinds = Some [ Boolean ] });
        ("repo", { any with kinds = Some [ String ] });
        ("root", { any with kinds = Some [ String ] });
        ("runtime", { any with reference = Some "Runtime" });
        ("secretStore", { any with kinds = Some [ String ] });
        ( "services",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "ServiceStatus" };
          } );
        ("session", { any with reference = Some "Session" });
        ("siteName", { any with kinds = Some [ String ] });
        ("starting", { any with kinds = Some [ Boolean ] });
        ("workload", { any with reference = Some "WorkloadStatus" });
      ];
    closed =
      Some
        [
          "did";
          "gateway";
          "healthy";
          "identityError";
          "kb";
          "key";
          "lan";
          "name";
          "placement";
          "recorded";
          "repo";
          "root";
          "runtime";
          "secretStore";
          "services";
          "session";
          "siteName";
          "starting";
          "workload";
        ];
  }

let shape_262 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "nodes"; "edges" ];
    members =
      [
        ( "edges",
          {
            any with
            kinds = Some [ Array ];
            items =
              Some
                {
                  any with
                  kinds = Some [ Object ];
                  required = [ "source"; "target"; "type" ];
                  members =
                    [
                      ("bidirectional", { any with kinds = Some [ Boolean ] });
                      ("metadata", { any with kinds = Some [ Object ] });
                      ("source", { any with kinds = Some [ String ] });
                      ("target", { any with kinds = Some [ String ] });
                      ("type", { any with kinds = Some [ String ] });
                    ];
                };
          } );
        ( "nodes",
          {
            any with
            kinds = Some [ Array ];
            items =
              Some
                {
                  any with
                  kinds = Some [ Object ];
                  variants =
                    [
                      { any with reference = Some "GraphResourceNode" };
                      { any with reference = Some "GraphAnnotationNode" };
                    ];
                  discriminator =
                    Some ("type", [ ("resource", 0); ("annotation", 1) ]);
                };
          } );
        ("truncated", { any with kinds = Some [ Boolean ] });
      ];
  }

let shape_263 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "kind"; "metadata"; "spec" ];
    members =
      [
        ("apiVersion", { any with reference = Some "StackApiVersion" });
        ( "kind",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"KnowledgeIndex\"" ];
          } );
        ("metadata", { any with reference = Some "Metadata" });
        ( "spec",
          {
            any with
            kinds = Some [ Object ];
            required =
              [
                "knowledgeBase";
                "logLevel";
                "graph";
                "vectors";
                "embedding";
                "librarian";
                "smelter";
                "weaver";
              ];
            members =
              [
                ( "embedding",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "type"; "model"; "chunking" ];
                    members =
                      [
                        ("apiKey", { any with reference = Some "SecretRef" });
                        ( "chunking",
                          {
                            any with
                            kinds = Some [ Object ];
                            required = [ "chunkSize"; "overlap" ];
                            members =
                              [
                                ( "chunkSize",
                                  {
                                    any with
                                    kinds = Some [ Integer ];
                                    minimum = Some "1";
                                  } );
                                ( "overlap",
                                  {
                                    any with
                                    kinds = Some [ Integer ];
                                    minimum = Some "0";
                                  } );
                              ];
                            closed = Some [ "chunkSize"; "overlap" ];
                          } );
                        ( "endpoint",
                          {
                            any with
                            kinds = Some [ String ];
                            min_length = Some 1;
                          } );
                        ( "model",
                          {
                            any with
                            kinds = Some [ String ];
                            min_length = Some 1;
                          } );
                        ( "type",
                          {
                            any with
                            kinds = Some [ String ];
                            min_length = Some 1;
                          } );
                      ];
                    closed =
                      Some [ "apiKey"; "chunking"; "endpoint"; "model"; "type" ];
                  } );
                ( "graph",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "type"; "username" ];
                    members =
                      [
                        ( "external",
                          {
                            any with
                            kinds = Some [ Object ];
                            required = [ "uri"; "password" ];
                            members =
                              [
                                ( "password",
                                  { any with reference = Some "SecretRef" } );
                                ( "uri",
                                  {
                                    any with
                                    kinds = Some [ String ];
                                    min_length = Some 1;
                                  } );
                              ];
                            closed = Some [ "password"; "uri" ];
                          } );
                        ("image", { any with reference = Some "Image" });
                        ("resources", { any with reference = Some "Resources" });
                        ( "type",
                          {
                            any with
                            kinds = Some [ String ];
                            min_length = Some 1;
                          } );
                        ( "username",
                          {
                            any with
                            kinds = Some [ String ];
                            min_length = Some 1;
                          } );
                      ];
                    closed =
                      Some
                        [ "external"; "image"; "resources"; "type"; "username" ];
                    all_of = [ { any with reference = Some "Runner" } ];
                  } );
                ( "knowledgeBase",
                  {
                    any with
                    kinds = Some [ String ];
                    pattern =
                      Some
                        [
                          Step ([ (48, 57); (97, 122) ], 1, Some 1);
                          Group
                            ( [
                                [
                                  Step
                                    ([ (45, 45); (48, 57); (97, 122) ], 0, None);
                                  Step ([ (48, 57); (97, 122) ], 1, Some 1);
                                ];
                              ],
                              0,
                              Some 1 );
                        ];
                  } );
                ( "librarian",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "image"; "resources"; "gather"; "search" ];
                    members =
                      [
                        ( "gather",
                          {
                            any with
                            kinds = Some [ Object ];
                            required = [ "settleTimeoutMs" ];
                            members =
                              [
                                ( "settleTimeoutMs",
                                  {
                                    any with
                                    kinds = Some [ Integer ];
                                    minimum = Some "1";
                                  } );
                              ];
                            closed = Some [ "settleTimeoutMs" ];
                          } );
                        ("image", { any with reference = Some "Image" });
                        ("resources", { any with reference = Some "Resources" });
                        ( "search",
                          {
                            any with
                            kinds = Some [ Object ];
                            required = [ "semanticFloor" ];
                            members =
                              [
                                ( "semanticFloor",
                                  {
                                    any with
                                    kinds = Some [ Number ];
                                    minimum = Some "0";
                                    maximum = Some "1";
                                  } );
                              ];
                            closed = Some [ "semanticFloor" ];
                          } );
                      ];
                    closed = Some [ "gather"; "image"; "resources"; "search" ];
                  } );
                ("logLevel", { any with reference = Some "LogLevel" });
                ( "smelter",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "image"; "resources"; "pdfsAtOnce" ];
                    members =
                      [
                        ("image", { any with reference = Some "Image" });
                        ( "pdfsAtOnce",
                          {
                            any with
                            kinds = Some [ Integer ];
                            minimum = Some "1";
                          } );
                        ("resources", { any with reference = Some "Resources" });
                      ];
                    closed = Some [ "image"; "pdfsAtOnce"; "resources" ];
                  } );
                ( "vectors",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "type" ];
                    members =
                      [
                        ( "external",
                          {
                            any with
                            kinds = Some [ Object ];
                            required =
                              [
                                "host"; "port"; "smelterToken"; "librarianToken";
                              ];
                            members =
                              [
                                ( "host",
                                  {
                                    any with
                                    kinds = Some [ String ];
                                    min_length = Some 1;
                                  } );
                                ( "librarianToken",
                                  { any with reference = Some "SecretRef" } );
                                ( "port",
                                  {
                                    any with
                                    kinds = Some [ Integer ];
                                    minimum = Some "1";
                                    maximum = Some "65535";
                                  } );
                                ( "smelterToken",
                                  { any with reference = Some "SecretRef" } );
                              ];
                            closed =
                              Some
                                [
                                  "host";
                                  "librarianToken";
                                  "port";
                                  "smelterToken";
                                ];
                          } );
                        ("image", { any with reference = Some "Image" });
                        ("resources", { any with reference = Some "Resources" });
                        ( "shared",
                          { any with kinds = Some [ Object ]; closed = Some [] }
                        );
                        ( "type",
                          {
                            any with
                            kinds = Some [ String ];
                            min_length = Some 1;
                          } );
                      ];
                    closed =
                      Some
                        [ "external"; "image"; "resources"; "shared"; "type" ];
                    variants =
                      [
                        {
                          any with
                          kinds = Some [ Object ];
                          required = [ "shared" ];
                          not_all =
                            [ [ "image" ]; [ "resources" ]; [ "external" ] ];
                        };
                        {
                          any with
                          kinds = Some [ Object ];
                          required = [ "image"; "resources" ];
                          not_all = [ [ "shared" ]; [ "external" ] ];
                        };
                        {
                          any with
                          kinds = Some [ Object ];
                          required = [ "external" ];
                          not_all =
                            [ [ "shared" ]; [ "image" ]; [ "resources" ] ];
                        };
                      ];
                  } );
                ( "weaver",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "image"; "resources" ];
                    members =
                      [
                        ("image", { any with reference = Some "Image" });
                        ("resources", { any with reference = Some "Resources" });
                      ];
                    closed = Some [ "image"; "resources" ];
                  } );
              ];
            closed =
              Some
                [
                  "embedding";
                  "graph";
                  "knowledgeBase";
                  "librarian";
                  "logLevel";
                  "smelter";
                  "vectors";
                  "weaver";
                ];
          } );
      ];
    closed = Some [ "apiVersion"; "kind"; "metadata"; "spec" ];
  }

let shape_264 () =
  {
    any with
    kinds = Some [ Object ];
    values = Some { any with reference = Some "PersistedEventId" };
    names = Some { any with reference = Some "ResourceId" };
  }

let shape_265 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [
        "kb";
        "gatewayUrl";
        "identity";
        "archivist";
        "graph";
        "vectors";
        "embedding";
        "matcher";
        "gatherer";
        "modelCatalogue";
        "gather";
        "search";
        "port";
        "logLevel";
        "logFormat";
      ];
    members =
      [
        ("archivist", { any with reference = Some "ServiceAddress" });
        ("embedding", { any with reference = Some "EmbeddingConfig" });
        ("gatewayUrl", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "gather",
          {
            any with
            kinds = Some [ Object ];
            required = [ "settleTimeoutMs" ];
            members =
              [
                ( "settleTimeoutMs",
                  { any with kinds = Some [ Integer ]; minimum = Some "1" } );
              ];
            closed = Some [ "settleTimeoutMs" ];
          } );
        ("gatherer", { any with reference = Some "LibrarianEngineConfig" });
        ("graph", { any with reference = Some "GraphConfig" });
        ("identity", { any with reference = Some "ServiceIdentity" });
        ("kb", { any with reference = Some "KbIdentity" });
        ("logFormat", { any with reference = Some "LogFormat" });
        ("logLevel", { any with reference = Some "LogLevel" });
        ("matcher", { any with reference = Some "LibrarianEngineConfig" });
        ( "modelCatalogue",
          { any with kinds = Some [ String ]; min_length = Some 1 } );
        ( "port",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "65535";
          } );
        ( "search",
          {
            any with
            kinds = Some [ Object ];
            required = [ "semanticFloor" ];
            members =
              [
                ( "semanticFloor",
                  {
                    any with
                    kinds = Some [ Number ];
                    minimum = Some "0";
                    maximum = Some "1";
                  } );
              ];
            closed = Some [ "semanticFloor" ];
          } );
        ("vectors", { any with reference = Some "VectorsConfig" });
      ];
    closed =
      Some
        [
          "archivist";
          "embedding";
          "gatewayUrl";
          "gather";
          "gatherer";
          "graph";
          "identity";
          "kb";
          "logFormat";
          "logLevel";
          "matcher";
          "modelCatalogue";
          "port";
          "search";
          "vectors";
        ];
  }

let shape_266 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "engine"; "baseUrl" ];
    members =
      [
        ("apiKeyEnv", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("baseUrl", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("engine", { any with reference = Some "Engine" });
      ];
    closed = Some [ "apiKeyEnv"; "baseUrl"; "engine" ];
  }

let shape_267 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "status"; "kb"; "actors" ];
    members =
      [
        ( "actors",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 2;
            items =
              Some
                {
                  any with
                  kinds = Some [ String ];
                  enum =
                    Some [ `Stringlit "\"matcher\""; `Stringlit "\"gatherer\"" ];
                };
          } );
        ("kb", { any with reference = Some "KbDid" });
        ( "status",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"ok\"" ];
          } );
      ];
    closed = Some [ "actors"; "kb"; "status" ];
  }

let shape_268 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "candidate"; "score" ];
    members =
      [
        ("candidate", { any with kinds = Some [ Number ] });
        ("score", { any with kinds = Some [ Number ] });
      ];
    closed = Some [ "candidate"; "score" ];
  }

let shape_269 () =
  {
    any with
    kinds = Some [ Object ];
    all_of =
      [
        { any with reference = Some "ErrorResponse" };
        {
          any with
          kinds = Some [ Object ];
          required = [ "code" ];
          members =
            [
              ( "code",
                {
                  any with
                  kinds = Some [ String ];
                  enum =
                    Some
                      [
                        `Stringlit "\"streams\"";
                        `Stringlit "\"emit-rate\"";
                        `Stringlit "\"unanswered-requests\"";
                        `Stringlit "\"capacity\"";
                        `Stringlit "\"refusal-rate\"";
                      ];
                } );
            ];
        };
      ];
  }

let shape_270 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "motivation"; "entityTypes" ];
    members =
      [
        ( "entityTypes",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            items = Some { any with kinds = Some [ String ] };
          } );
        ("includeDescriptiveReferences", { any with kinds = Some [ Boolean ] });
        ("language", { any with kinds = Some [ String ] });
        ( "motivation",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"linking\"" ];
          } );
        ("sourceLanguage", { any with kinds = Some [ String ] });
      ];
    closed =
      Some
        [
          "entityTypes";
          "includeDescriptiveReferences";
          "language";
          "motivation";
          "sourceLanguage";
        ];
  }

let shape_271 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resources"; "total"; "offset"; "limit" ];
    members =
      [
        ("limit", { any with kinds = Some [ Number ] });
        ("offset", { any with kinds = Some [ Number ] });
        ( "resources",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "ResourceDescriptor" };
          } );
        ("total", { any with kinds = Some [ Number ] });
      ];
  }

let shape_272 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "kind"; "kbId" ];
    members =
      [
        ("kbId", { any with kinds = Some [ String ] });
        ( "kind",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"local\"" ];
          } );
      ];
  }

let shape_273 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "kind"; "root" ];
    members =
      [
        ( "kind",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"local\"" ];
          } );
        ("root", { any with kinds = Some [ String ]; min_length = Some 1 });
      ];
    closed = Some [ "kind"; "root" ];
  }

let shape_274 () =
  {
    any with
    kinds = Some [ String ];
    enum = Some [ `Stringlit "\"json\""; `Stringlit "\"simple\"" ];
  }

let shape_275 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"error\"";
          `Stringlit "\"warn\"";
          `Stringlit "\"info\"";
          `Stringlit "\"http\"";
          `Stringlit "\"debug\"";
        ];
  }

let shape_276 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "requestId"; "service"; "stream"; "line"; "receivedAt" ];
    members =
      [
        ("line", { any with kinds = Some [ String ] });
        ("receivedAt", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("requestId", { any with reference = Some "RequestId" });
        ("service", { any with kinds = Some [ String ] });
        ("stream", { any with reference = Some "OutputStream" });
      ];
    closed = Some [ "line"; "receivedAt"; "requestId"; "service"; "stream" ];
  }

let shape_277 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("runtime", { any with reference = Some "Runtime" });
        ("service", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("target", { any with reference = Some "Target" });
      ];
    closed = Some [ "apiVersion"; "runtime"; "service"; "target" ];
  }

let shape_278 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "services" ];
    members =
      [
        ( "services",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
      ];
    closed = Some [ "services" ];
  }

let shape_279 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("keepFile", { any with kinds = Some [ Boolean ] });
        ("resourceId", { any with reference = Some "ResourceId" });
        ("storageUri", { any with kinds = Some [ String ] });
      ];
  }

let shape_280 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "annotations" ];
    members =
      [
        ( "_roles",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("_userId", { any with reference = Some "UserId" });
        ( "annotations",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "Annotation" };
          } );
        ("jobId", { any with reference = Some "JobId" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_281 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [
        ( "response",
          {
            any with
            kinds = Some [ Object ];
            required = [ "persisted"; "annotationIds" ];
            members =
              [
                ( "annotationIds",
                  {
                    any with
                    kinds = Some [ Array ];
                    items = Some { any with reference = Some "AnnotationId" };
                  } );
                ("persisted", { any with kinds = Some [ Integer ] });
              ];
          } );
      ];
  }

let shape_282 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [ ("response", { any with reference = Some "MarkCreateOkResponse" }) ];
  }

let shape_283 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotationId" ];
    members = [ ("annotationId", { any with reference = Some "AnnotationId" }) ];
  }

let shape_284 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "request" ];
    members =
      [
        ("request", { any with reference = Some "CreateAnnotationRequest" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_285 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "motivation" ];
    members =
      [
        ("motivation", { any with reference = Some "Motivation" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_286 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotationId" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_287 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [
        ( "response",
          {
            any with
            kinds = Some [ Object ];
            required = [ "annotationId" ];
            members =
              [ ("annotationId", { any with reference = Some "AnnotationId" }) ];
          } );
      ];
  }

let shape_288 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "jobId"; "jobType" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("attempt", { any with kinds = Some [ Integer ] });
        ("durability", { any with reference = Some "DurabilityEvidence" });
        ("jobId", { any with reference = Some "JobId" });
        ( "jobType",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"mark\"" ];
          } );
        ("resourceId", { any with reference = Some "ResourceId" });
        ("result", { any with reference = Some "MarkJobResult" });
      ];
  }

let shape_289 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobType"; "resourceId"; "params" ];
    members =
      [
        ( "_roles",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("_userId", { any with reference = Some "UserId" });
        ( "jobType",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"mark\"" ];
          } );
        ("params", { any with reference = Some "MarkJobParams" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
    closed = Some [ "_roles"; "_userId"; "jobType"; "params"; "resourceId" ];
  }

let shape_290 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "found"; "persisted" ];
    members =
      [
        ( "byCategory",
          {
            any with
            kinds = Some [ Object ];
            values = Some { any with kinds = Some [ Integer ] };
          } );
        ("errors", { any with kinds = Some [ Integer ]; minimum = Some "1" });
        ("found", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("persisted", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ( "uncheckedPieces",
          { any with kinds = Some [ Integer ]; minimum = Some "1" } );
        ("underReportedPieces", { any with kinds = Some [ Integer ] });
      ];
    closed =
      Some
        [
          "byCategory";
          "errors";
          "found";
          "persisted";
          "uncheckedPieces";
          "underReportedPieces";
        ];
  }

let shape_291 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobType"; "params" ];
    members =
      [
        ( "jobType",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"mark\"" ];
          } );
        ( "params",
          {
            any with
            kinds = Some [ Object ];
            required = [ "motivation" ];
            members =
              [ ("motivation", { any with reference = Some "Motivation" }) ];
            closed = Some [ "motivation" ];
          } );
      ];
    closed = Some [ "jobType"; "params" ];
  }

let shape_292 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "HighlightingJobParams" };
        { any with reference = Some "CommentingJobParams" };
        { any with reference = Some "AssessingJobParams" };
        { any with reference = Some "LinkingJobParams" };
        { any with reference = Some "TaggingJobParams" };
      ];
    discriminator =
      Some
        ( "motivation",
          [
            ("highlighting", 0);
            ("commenting", 1);
            ("assessing", 2);
            ("linking", 3);
            ("tagging", 4);
          ] );
  }

let shape_293 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobId"; "jobType"; "resourceId"; "userId"; "params" ];
    members =
      [
        ("jobId", { any with reference = Some "JobId" });
        ( "jobType",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"mark\"" ];
          } );
        ("params", { any with reference = Some "MarkJobParams" });
        ("resourceId", { any with reference = Some "ResourceId" });
        ("userId", { any with reference = Some "UserId" });
      ];
  }

let shape_294 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "MarkJobDone" };
        { any with reference = Some "JobDeclined" };
      ];
  }

let shape_295 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "source"; "selector"; "motivation" ];
    members =
      [
        ("motivation", { any with reference = Some "Motivation" });
        ("selector", { any with reference = Some "AnnotationSelector" });
        ("source", { any with reference = Some "ResourceId" });
      ];
  }

let shape_296 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "source"; "motivation"; "selector" ];
    members =
      [
        ("body", { any with reference = Some "AnnotationBodies" });
        ("motivation", { any with reference = Some "Motivation" });
        ("selector", { any with reference = Some "AnnotationSelector" });
        ("source", { any with reference = Some "ResourceId" });
      ];
  }

let shape_297 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("resourceId", { any with reference = Some "ResourceId" });
        ("storageUri", { any with kinds = Some [ String ] });
      ];
  }

let shape_298 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "annotationId"; "resourceId"; "operations" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("annotationId", { any with reference = Some "AnnotationId" });
        ( "operations",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "BodyOperation" };
          } );
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_299 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "currentEntityTypes"; "updatedEntityTypes" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ( "currentEntityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("resourceId", { any with reference = Some "ResourceId" });
        ( "updatedEntityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
      ];
  }

let shape_300 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"normalized\"";
          `Stringlit "\"case-insensitive\"";
          `Stringlit "\"fuzzy\"";
        ];
  }

let shape_301 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "search" ];
    members =
      [
        ("archived", { any with kinds = Some [ Boolean ] });
        ("entityType", { any with kinds = Some [ String ] });
        ( "limit",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "200";
          } );
        ("offset", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("search", { any with kinds = Some [ String ] });
      ];
  }

let shape_302 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resources"; "total"; "offset"; "limit"; "matchKind" ];
    members =
      [
        ("limit", { any with kinds = Some [ Integer ]; minimum = Some "1" });
        ( "matchKind",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"lexical\""; `Stringlit "\"semantic\"" ];
          } );
        ("offset", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ( "resources",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "ResourceDescriptor" };
          } );
        ("total", { any with kinds = Some [ Integer ]; minimum = Some "0" });
      ];
  }

let shape_303 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members =
      [ ("response", { any with reference = Some "MatchResourcesResponse" }) ];
  }

let shape_304 () =
  {
    any with
    kinds = Some [ Object ];
    all_of =
      [
        { any with reference = Some "CommandError" };
        {
          any with
          kinds = Some [ Object ];
          required = [ "referenceId" ];
          members =
            [ ("referenceId", { any with reference = Some "AnnotationId" }) ];
        };
      ];
  }

let shape_305 () =
  {
    any with
    kinds = Some [ Object ];
    members =
      [
        ( "limit",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "200";
          } );
        ("useSemanticScoring", { any with kinds = Some [ Boolean ] });
      ];
    closed = Some [ "limit"; "useSemanticScoring" ];
  }

let shape_306 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "referenceId"; "context" ];
    members =
      [
        ("context", { any with reference = Some "GatheredContext" });
        ( "limit",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "200";
          } );
        ("referenceId", { any with reference = Some "AnnotationId" });
        ("resourceId", { any with reference = Some "ResourceId" });
        ("useSemanticScoring", { any with kinds = Some [ Boolean ] });
      ];
  }

let shape_307 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "referenceId"; "response" ];
    members =
      [
        ("referenceId", { any with reference = Some "AnnotationId" });
        ( "response",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "ScoredResource" };
          } );
      ];
  }

let shape_308 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId" ];
    members = [ ("resourceId", { any with reference = Some "ResourceId" }) ];
  }

let shape_309 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "token" ];
    members = [ ("token", { any with kinds = Some [ String ] }) ];
  }

let shape_310 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type" ];
    members =
      [
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"memory\"" ];
          } );
      ];
    closed = Some [ "type" ];
  }

let shape_311 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type" ];
    members =
      [
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"memory\"" ];
          } );
      ];
    closed = Some [ "type" ];
  }

let shape_312 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "name" ];
    members =
      [
        ( "annotations",
          {
            any with
            kinds = Some [ Object ];
            values = Some { any with kinds = Some [ String ] };
          } );
        ( "labels",
          {
            any with
            kinds = Some [ Object ];
            values = Some { any with kinds = Some [ String ] };
          } );
        ( "name",
          {
            any with
            kinds = Some [ String ];
            pattern =
              Some
                [
                  Step ([ (48, 57); (97, 122) ], 1, Some 1);
                  Group
                    ( [
                        [
                          Step ([ (45, 45); (48, 57); (97, 122) ], 0, None);
                          Step ([ (48, 57); (97, 122) ], 1, Some 1);
                        ];
                      ],
                      0,
                      Some 1 );
                ];
            max_length = Some 63;
          } );
        ( "namespace",
          {
            any with
            kinds = Some [ String ];
            pattern =
              Some
                [
                  Step ([ (48, 57); (97, 122) ], 1, Some 1);
                  Group
                    ( [
                        [
                          Step ([ (45, 45); (48, 57); (97, 122) ], 0, None);
                          Step ([ (48, 57); (97, 122) ], 1, Some 1);
                        ];
                      ],
                      0,
                      Some 1 );
                ];
            max_length = Some 63;
          } );
      ];
    closed = Some [ "annotations"; "labels"; "name"; "namespace" ];
  }

let shape_313 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"assessing\"";
          `Stringlit "\"commenting\"";
          `Stringlit "\"highlighting\"";
          `Stringlit "\"linking\"";
          `Stringlit "\"tagging\"";
        ];
  }

let shape_314 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type"; "uri"; "username"; "passwordEnv"; "database" ];
    members =
      [
        ("database", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "passwordEnv",
          { any with kinds = Some [ String ]; min_length = Some 1 } );
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"neo4j\"" ];
          } );
        ("uri", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("username", { any with kinds = Some [ String ]; min_length = Some 1 });
      ];
    closed = Some [ "database"; "passwordEnv"; "type"; "uri"; "username" ];
  }

let shape_315 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type"; "endpoint"; "port" ];
    members =
      [
        ("endpoint", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "port",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "65535";
          } );
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"neptune\"" ];
          } );
      ];
    closed = Some [ "endpoint"; "port"; "type" ];
  }

let shape_316 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "label"; "endpoint"; "did" ];
    members =
      [
        ("did", { any with kinds = Some [ String ] });
        ("endpoint", { any with reference = Some "KbEndpoint" });
        ("label", { any with kinds = Some [ String ] });
        ("lastRead", { any with reference = Some "KbRead" });
      ];
  }

let shape_317 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "mean"; "lowConfidenceWords"; "totalWords" ];
    members =
      [
        ("lowConfidenceWords", { any with kinds = Some [ Integer ] });
        ("mean", { any with kinds = Some [ Number ] });
        ("totalWords", { any with kinds = Some [ Integer ] });
      ];
  }

let shape_318 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type"; "model"; "baseUrl" ];
    members =
      [
        ("baseUrl", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("model", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"ollama\"" ];
          } );
      ];
    closed = Some [ "baseUrl"; "model"; "type" ];
  }

let shape_319 () =
  {
    any with
    kinds = Some [ Object; Array ];
    variants =
      [
        { any with reference = Some "Agent" };
        {
          any with
          kinds = Some [ Array ];
          min_items = Some 1;
          items = Some { any with reference = Some "Agent" };
        };
      ];
  }

let shape_320 () =
  {
    any with
    kinds = Some [ Array; String ];
    variants =
      [
        { any with kinds = Some [ String ] };
        {
          any with
          kinds = Some [ Array ];
          min_items = Some 1;
          items = Some { any with kinds = Some [ String ] };
        };
      ];
  }

let shape_321 () =
  {
    any with
    kinds = Some [ Array; String ];
    variants =
      [
        { any with kinds = Some [ String ] };
        {
          any with
          kinds = Some [ Array ];
          min_items = Some 1;
          items = Some { any with kinds = Some [ String ] };
        };
      ];
  }

let shape_322 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "id"; "name"; "openedAt"; "order" ];
    members =
      [
        ("id", { any with reference = Some "ResourceId" });
        ("mediaType", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
        ("openedAt", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("order", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("storageUri", { any with kinds = Some [ String ] });
      ];
  }

let shape_323 () =
  {
    any with
    kinds = Some [ String ];
    enum = Some [ `Stringlit "\"stdout\""; `Stringlit "\"stderr\"" ];
  }

let shape_324 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"A\"";
          `Stringlit "\"B\"";
          `Stringlit "\"C\"";
          `Stringlit "\"D\"";
          `Stringlit "\"E\"";
          `Stringlit "\"F\"";
          `Stringlit "\"G\"";
        ];
  }

let shape_325 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "page"; "x"; "y"; "width"; "height" ];
    members =
      [
        ("height", { any with kinds = Some [ Number ] });
        ("page", { any with kinds = Some [ Integer ] });
        ("width", { any with kinds = Some [ Number ] });
        ("x", { any with kinds = Some [ Number ] });
        ("y", { any with kinds = Some [ Number ] });
      ];
    closed = Some [ "height"; "page"; "width"; "x"; "y" ];
  }

let shape_326 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "start"; "end"; "page"; "x"; "y"; "width"; "height" ];
    members =
      [
        ("end", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("height", { any with kinds = Some [ Number ] });
        ("page", { any with kinds = Some [ Integer ] });
        ("start", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("width", { any with kinds = Some [ Number ] });
        ("x", { any with kinds = Some [ Number ] });
        ("y", { any with kinds = Some [ Number ] });
      ];
  }

let shape_327 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "selector"; "motivation" ];
    members =
      [
        ("motivation", { any with reference = Some "Motivation" });
        ("selector", { any with reference = Some "AnnotationSelector" });
      ];
    closed = Some [ "motivation"; "selector" ];
  }

let shape_328 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "state"; "verifier"; "redirectUri"; "target"; "issuer" ];
    members =
      [
        ("expectedDid", { any with kinds = Some [ String ] });
        ("expectedName", { any with kinds = Some [ String ] });
        ( "issuer",
          {
            any with
            kinds = Some [ Object ];
            required = [ "issuer"; "authorization"; "token" ];
            members =
              [
                ("authorization", { any with kinds = Some [ String ] });
                ("device", { any with kinds = Some [ String ] });
                ("issuer", { any with kinds = Some [ String ] });
                ("revocation", { any with kinds = Some [ String ] });
                ("token", { any with kinds = Some [ String ] });
              ];
          } );
        ("kbId", { any with kinds = Some [ String ] });
        ("redirectUri", { any with kinds = Some [ String ] });
        ("state", { any with kinds = Some [ String ] });
        ("target", { any with reference = Some "HttpEndpoint" });
        ("verifier", { any with kinds = Some [ String ] });
      ];
  }

let shape_329 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "detail" ];
    members = [ ("detail", { any with kinds = Some [ String; Null ] }) ];
    closed = Some [ "detail" ];
  }

let shape_330 () =
  {
    any with
    kinds = Some [ String ];
    pattern =
      Some
        [
          Step ([ (112, 112) ], 1, Some 1);
          Step ([ (45, 45) ], 1, Some 1);
          Step ([ (0, 9); (11, 12); (14, 8231); (8234, 1114111) ], 1, None);
          Step ([ (45, 45) ], 1, Some 1);
          Step ([ (48, 57) ], 1, None);
        ];
  }

let shape_331 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "name" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("name", { any with kinds = Some [ String ] });
      ];
  }

let shape_332 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "name" ];
    members = [ ("name", { any with kinds = Some [ String ] }) ];
  }

let shape_333 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "name"; "since" ];
    members =
      [
        ("name", { any with kinds = Some [ String ] });
        ("since", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "name"; "since" ];
  }

let shape_334 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "profiles" ];
    members =
      [
        ( "profiles",
          {
            any with
            kinds = Some [ Object ];
            values = Some { any with reference = Some "Profile" };
          } );
      ];
    closed = Some [ "profiles" ];
  }

let shape_335 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "requestId"; "kind"; "text" ];
    members =
      [
        ( "kind",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"log\"";
                  `Stringlit "\"note\"";
                  `Stringlit "\"ok\"";
                  `Stringlit "\"warn\"";
                  `Stringlit "\"fail\"";
                  `Stringlit "\"banner\"";
                  `Stringlit "\"section\"";
                  `Stringlit "\"stamp\"";
                  `Stringlit "\"command\"";
                  `Stringlit "\"output\"";
                ];
          } );
        ("requestId", { any with reference = Some "RequestId" });
        ("text", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "kind"; "requestId"; "text" ];
  }

let shape_336 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "project"; "git"; "site" ];
    members =
      [
        ( "git",
          {
            any with
            kinds = Some [ Object ];
            required = [ "sync" ];
            members = [ ("sync", { any with kinds = Some [ Boolean ] }) ];
            closed = Some [ "sync" ];
          } );
        ( "project",
          {
            any with
            kinds = Some [ Object ];
            required = [ "name" ];
            members =
              [
                ( "name",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
                ( "version",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
              ];
            closed = Some [ "name"; "version" ];
          } );
        ( "site",
          {
            any with
            kinds = Some [ Object ];
            required = [ "domain"; "siteName" ];
            members =
              [
                ( "domain",
                  {
                    any with
                    kinds = Some [ String ];
                    pattern =
                      Some
                        [
                          Step
                            ( [
                                (0, 8);
                                (14, 31);
                                (33, 159);
                                (161, 5759);
                                (5761, 8191);
                                (8203, 8231);
                                (8234, 8238);
                                (8240, 8286);
                                (8288, 12287);
                                (12289, 65278);
                                (65280, 1114111);
                              ],
                              1,
                              None );
                        ];
                    min_length = Some 1;
                  } );
                ( "siteName",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
              ];
            closed = Some [ "domain"; "siteName" ];
          } );
      ];
    closed = Some [ "git"; "project"; "site" ];
  }

let shape_337 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [ "resource"; "authorization_servers"; "bearer_methods_supported" ];
    members =
      [
        ( "authorization_servers",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ( "bearer_methods_supported",
          {
            any with
            kinds = Some [ Array ];
            items =
              Some
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"header\"" ];
                };
          } );
        ("resource", { any with kinds = Some [ String ] });
        ("resource_name", { any with kinds = Some [ String ] });
      ];
    closed =
      Some
        [
          "authorization_servers";
          "bearer_methods_supported";
          "resource";
          "resource_name";
        ];
  }

let shape_338 () =
  {
    any with
    kinds = Some [ Object ];
    members =
      [
        ("apiKey", { any with reference = Some "SecretRef" });
        ("baseURL", { any with kinds = Some [ String ]; min_length = Some 1 });
      ];
    closed = Some [ "apiKey"; "baseURL" ];
  }

let shape_339 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type"; "host"; "port"; "tokenEnv" ];
    members =
      [
        ("host", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "port",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "65535";
          } );
        ("tokenEnv", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"qdrant\"" ];
          } );
      ];
    closed = Some [ "host"; "port"; "tokenEnv"; "type" ];
  }

let shape_340 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "exact" ];
    members =
      [
        ("exact", { any with kinds = Some [ String ] });
        ("prefix", { any with kinds = Some [ String ] });
        ("suffix", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "exact"; "prefix"; "suffix" ];
  }

let shape_341 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        {
          any with
          kinds = Some [ Object ];
          required = [ "start"; "end"; "exact"; "anchorMethod" ];
          members =
            [
              ( "anchorMethod",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"unique-match\"" ];
                } );
              ("end", { any with kinds = Some [ Integer ]; minimum = Some "0" });
              ("exact", { any with kinds = Some [ String ] });
              ("prefix", { any with kinds = Some [ String ] });
              ( "start",
                { any with kinds = Some [ Integer ]; minimum = Some "0" } );
              ("suffix", { any with kinds = Some [ String ] });
            ];
          closed =
            Some [ "anchorMethod"; "end"; "exact"; "prefix"; "start"; "suffix" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "start"; "end"; "exact"; "anchorMethod" ];
          members =
            [
              ( "anchorMethod",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"context-recovered\"" ];
                } );
              ("end", { any with kinds = Some [ Integer ]; minimum = Some "0" });
              ("exact", { any with kinds = Some [ String ] });
              ("prefix", { any with kinds = Some [ String ] });
              ( "start",
                { any with kinds = Some [ Integer ]; minimum = Some "0" } );
              ("suffix", { any with kinds = Some [ String ] });
            ];
          closed =
            Some [ "anchorMethod"; "end"; "exact"; "prefix"; "start"; "suffix" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "start"; "end"; "exact"; "anchorMethod" ];
          members =
            [
              ( "anchorMethod",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"first-of-many\"" ];
                } );
              ("end", { any with kinds = Some [ Integer ]; minimum = Some "0" });
              ("exact", { any with kinds = Some [ String ] });
              ("prefix", { any with kinds = Some [ String ] });
              ( "start",
                { any with kinds = Some [ Integer ]; minimum = Some "0" } );
              ("suffix", { any with kinds = Some [ String ] });
            ];
          closed =
            Some [ "anchorMethod"; "end"; "exact"; "prefix"; "start"; "suffix" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "start"; "end"; "exact"; "anchorMethod"; "matchQuality" ];
          members =
            [
              ( "anchorMethod",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"fuzzy-match\"" ];
                } );
              ("end", { any with kinds = Some [ Integer ]; minimum = Some "0" });
              ("exact", { any with kinds = Some [ String ] });
              ("matchQuality", { any with reference = Some "MatchQuality" });
              ("prefix", { any with kinds = Some [ String ] });
              ( "start",
                { any with kinds = Some [ Integer ]; minimum = Some "0" } );
              ("suffix", { any with kinds = Some [ String ] });
            ];
          closed =
            Some
              [
                "anchorMethod";
                "end";
                "exact";
                "matchQuality";
                "prefix";
                "start";
                "suffix";
              ];
        };
      ];
    discriminator =
      Some
        ( "anchorMethod",
          [
            ("unique-match", 0);
            ("context-recovered", 1);
            ("first-of-many", 2);
            ("fuzzy-match", 3);
          ] );
  }

let shape_342 () =
  {
    any with
    kinds = Some [ String ];
    pattern =
      Some
        [
          Step ([ (101, 101) ], 1, Some 1);
          Step ([ (45, 45) ], 1, Some 1);
          Step ([ (0, 57); (59, 1114111) ], 1, None);
          Step ([ (58, 58) ], 1, Some 1);
          Step ([ (0, 57); (59, 1114111) ], 1, None);
          Step ([ (58, 58) ], 1, Some 1);
          Step ([ (0, 9); (11, 12); (14, 8231); (8234, 1114111) ], 1, None);
        ];
  }

let shape_343 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "mediaType" ];
    members =
      [
        ("@id", { any with kinds = Some [ String ] });
        ("@type", { any with reference = Some "OneOrMoreStrings" });
        ("byteSize", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("checksum", { any with kinds = Some [ String ] });
        ("conformsTo", { any with reference = Some "OneOrMoreUris" });
        ("created", { any with kinds = Some [ String ] });
        ("duration", { any with kinds = Some [ Number ]; minimum = Some "0" });
        ("encoding", { any with kinds = Some [ String ] });
        ("filename", { any with kinds = Some [ String ] });
        ("height", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("language", { any with kinds = Some [ String ] });
        ("mediaType", { any with kinds = Some [ String ] });
        ("modified", { any with kinds = Some [ String ] });
        ( "rel",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"original\"";
                  `Stringlit "\"thumbnail\"";
                  `Stringlit "\"preview\"";
                  `Stringlit "\"optimized\"";
                  `Stringlit "\"derived\"";
                  `Stringlit "\"other\"";
                ];
          } );
        ("storageUri", { any with kinds = Some [ String ] });
        ( "tags",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("width", { any with kinds = Some [ Integer ]; minimum = Some "0" });
      ];
  }

let shape_344 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "representation" ];
    members =
      [ ("representation", { any with reference = Some "Representation" }) ];
  }

let shape_345 () =
  {
    any with
    kinds = Some [ Object ];
    all_of =
      [
        { any with reference = Some "ErrorResponse" };
        {
          any with
          kinds = Some [ Object ];
          required = [ "code" ];
          members =
            [
              ( "code",
                {
                  any with
                  kinds = Some [ String ];
                  enum =
                    Some
                      [
                        `Stringlit "\"resource\"";
                        `Stringlit "\"representation\"";
                      ];
                } );
            ];
        };
      ];
  }

let shape_346 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "checksum" ];
    members = [ ("checksum", { any with kinds = Some [ String ] }) ];
  }

let shape_347 () = { any with kinds = Some [ String; Integer ] }

let shape_348 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "annotations"; "version"; "updatedAt" ];
    members =
      [
        ( "annotations",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "Annotation" };
          } );
        ("resourceId", { any with reference = Some "ResourceId" });
        ("updatedAt", { any with kinds = Some [ String ] });
        ("version", { any with kinds = Some [ Integer ]; minimum = Some "0" });
      ];
    closed = Some [ "annotations"; "resourceId"; "updatedAt"; "version" ];
  }

let shape_349 () =
  {
    any with
    kinds = Some [ Object ];
    members = [ ("reason", { any with kinds = Some [ String ] }) ];
  }

let shape_350 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "name"; "format"; "contentChecksum"; "parentResourceId" ];
    members =
      [
        ("contentByteSize", { any with kinds = Some [ Integer ] });
        ("contentChecksum", { any with kinds = Some [ String ] });
        ("creator", { any with reference = Some "Agent" });
        ( "entityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("format", { any with reference = Some "ContentFormat" });
        ("language", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
        ("parentResourceId", { any with reference = Some "ResourceId" });
        ("storageUri", { any with kinds = Some [ String ] });
        ("wasAttributedTo", { any with reference = Some "OneOrMoreAgents" });
      ];
  }

let shape_351 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "name"; "format"; "contentChecksum" ];
    members =
      [
        ("contentByteSize", { any with kinds = Some [ Integer ] });
        ("contentChecksum", { any with kinds = Some [ String ] });
        ("creator", { any with reference = Some "Agent" });
        ( "entityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("format", { any with reference = Some "ContentFormat" });
        ( "generatedFrom",
          {
            any with
            kinds = Some [ Object ];
            required = [ "resourceId" ];
            members =
              [
                ("annotationId", { any with reference = Some "AnnotationId" });
                ("resourceId", { any with reference = Some "ResourceId" });
              ];
          } );
        ("generationPrompt", { any with kinds = Some [ String ] });
        ("generator", { any with reference = Some "OneOrMoreAgents" });
        ("isDraft", { any with kinds = Some [ Boolean ] });
        ("jobId", { any with reference = Some "JobId" });
        ("language", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
        ("storageUri", { any with kinds = Some [ String ] });
        ("wasAttributedTo", { any with reference = Some "OneOrMoreAgents" });
      ];
  }

let shape_352 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "@context"; "@id"; "name"; "representations" ];
    members =
      [
        ( "@context",
          {
            any with
            kinds = Some [ Object; Array; String ];
            variants =
              [
                { any with kinds = Some [ String ] };
                { any with kinds = Some [ Object ] };
                {
                  any with
                  kinds = Some [ Array ];
                  items =
                    Some
                      {
                        any with
                        kinds = Some [ Object; String ];
                        variants =
                          [
                            { any with kinds = Some [ String ] };
                            { any with kinds = Some [ Object ] };
                          ];
                      };
                };
              ];
          } );
        ("@id", { any with reference = Some "ResourceId" });
        ("@type", { any with reference = Some "OneOrMoreStrings" });
        ("about", { any with reference = Some "OneOrMoreStrings" });
        ("archived", { any with kinds = Some [ Boolean ] });
        ( "availableFormats",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("conformsTo", { any with reference = Some "OneOrMoreUris" });
        ("dateCreated", { any with kinds = Some [ String ] });
        ("dateModified", { any with kinds = Some [ String ] });
        ("description", { any with kinds = Some [ String ] });
        ( "entityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("generator", { any with reference = Some "OneOrMoreAgents" });
        ( "hasPart",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ( "identifier",
          {
            any with
            kinds = Some [ Object; Array; String ];
            variants =
              [
                { any with kinds = Some [ String ] };
                {
                  any with
                  kinds = Some [ Array ];
                  min_items = Some 1;
                  items = Some { any with kinds = Some [ String ] };
                };
                {
                  any with
                  kinds = Some [ Object ];
                  members =
                    [
                      ("@id", { any with kinds = Some [ String ] });
                      ("scheme", { any with kinds = Some [ String ] });
                      ("value", { any with kinds = Some [ String ] });
                    ];
                };
              ];
          } );
        ("isDraft", { any with kinds = Some [ Boolean ] });
        ( "isPartOf",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("license", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
        ("originatedFrom", { any with kinds = Some [ String ] });
        ( "representations",
          {
            any with
            kinds = Some [ Object; Array ];
            variants =
              [
                { any with reference = Some "Representation" };
                {
                  any with
                  kinds = Some [ Array ];
                  items = Some { any with reference = Some "Representation" };
                };
              ];
          } );
        ( "sameAs",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("sourceAnnotationId", { any with reference = Some "AnnotationId" });
        ("sourceResourceId", { any with reference = Some "ResourceId" });
        ("version", { any with kinds = Some [ String ] });
        ("wasAttributedTo", { any with reference = Some "OneOrMoreAgents" });
        ( "wasDerivedFrom",
          {
            any with
            kinds = Some [ Array; String ];
            variants =
              [
                { any with reference = Some "ResourceId" };
                {
                  any with
                  kinds = Some [ Array ];
                  items = Some { any with reference = Some "ResourceId" };
                };
              ];
          } );
      ];
  }

let shape_353 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "message" ];
    members =
      [
        ("message", { any with kinds = Some [ String ] });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_354 () =
  {
    any with
    kinds = Some [ String ];
    pattern =
      Some
        [
          Step
            ([ (45, 45); (48, 57); (65, 90); (95, 95); (97, 122) ], 1, Some 128);
        ];
  }

let shape_355 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "fromUri"; "toUri" ];
    members =
      [
        ("fromUri", { any with kinds = Some [ String ] });
        ("toUri", { any with kinds = Some [ String ] });
      ];
  }

let shape_356 () =
  {
    any with
    kinds = Some [ Object ];
    members =
      [
        ("archived", { any with kinds = Some [ Boolean ] });
        ("entityType", { any with kinds = Some [ String ] });
        ( "limit",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "200";
          } );
        ("offset", { any with kinds = Some [ Integer ]; minimum = Some "0" });
      ];
    closed = Some [ "archived"; "entityType"; "limit"; "offset" ];
  }

let shape_357 () = { any with kinds = Some [ Object ] }

let shape_358 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "contentChecksum" ];
    members =
      [
        ("contentByteSize", { any with kinds = Some [ Integer ] });
        ("contentChecksum", { any with kinds = Some [ String ] });
      ];
  }

let shape_359 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "name"; "file"; "format"; "storageUri" ];
    members =
      [
        ("archiveOriginal", { any with kinds = Some [ String ] });
        ("cloneToken", { any with kinds = Some [ String ] });
        ("entityTypes", { any with kinds = Some [ String ] });
        ("file", { any with kinds = Some [ String ] });
        ("format", { any with kinds = Some [ String ] });
        ("generationPrompt", { any with kinds = Some [ String ] });
        ("generator", { any with kinds = Some [ String ] });
        ("isDraft", { any with kinds = Some [ String ] });
        ("jobId", { any with reference = Some "JobId" });
        ("language", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
        ("sourceAnnotationId", { any with reference = Some "AnnotationId" });
        ("sourceResourceId", { any with reference = Some "ResourceId" });
        ("storageUri", { any with kinds = Some [ String ] });
      ];
  }

let shape_360 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resource"; "annotations"; "lastSequence" ];
    members =
      [
        ("annotations", { any with reference = Some "ResourceAnnotations" });
        ( "lastSequence",
          { any with kinds = Some [ Integer ]; minimum = Some "1" } );
        ("resource", { any with reference = Some "ResourceDescriptor" });
      ];
    closed = Some [ "annotations"; "lastSequence"; "resource" ];
  }

let shape_361 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "limits" ];
    members =
      [
        ( "limits",
          {
            any with
            kinds = Some [ Object ];
            required = [ "memory" ];
            members =
              [
                ( "memory",
                  {
                    any with
                    kinds = Some [ String ];
                    pattern =
                      Some
                        [
                          Step ([ (49, 57) ], 1, Some 1);
                          Step ([ (48, 57) ], 0, None);
                          Step ([ (71, 71); (77, 77) ], 1, Some 1);
                        ];
                  } );
              ];
            closed = Some [ "memory" ];
          } );
      ];
    closed = Some [ "limits" ];
  }

let shape_362 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "placement"; "registered"; "running" ];
    members =
      [
        ("codespace", { any with kinds = Some [ String ] });
        ("codespaceState", { any with kinds = Some [ String ] });
        ("config", { any with kinds = Some [ String ] });
        ( "configs",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ( "current",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"cwd\""; `Stringlit "\"xynolog-root\"" ];
          } );
        ("did", { any with kinds = Some [ String ] });
        ("forwardPort", { any with kinds = Some [ Integer ] });
        ("forwarded", { any with kinds = Some [ Boolean ] });
        ("identityError", { any with kinds = Some [ String ] });
        ("lastUsed", { any with kinds = Some [ String ] });
        ("path", { any with kinds = Some [ String ] });
        ( "placement",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"local\""; `Stringlit "\"codespace\"" ];
          } );
        ("present", { any with kinds = Some [ Boolean ] });
        ("reachable", { any with kinds = Some [ Boolean ] });
        ("registered", { any with kinds = Some [ Boolean ] });
        ("repo", { any with kinds = Some [ String ] });
        ("running", { any with kinds = Some [ Boolean ] });
        ("siteName", { any with kinds = Some [ String ] });
      ];
    closed =
      Some
        [
          "codespace";
          "codespaceState";
          "config";
          "configs";
          "current";
          "did";
          "forwardPort";
          "forwarded";
          "identityError";
          "lastUsed";
          "path";
          "placement";
          "present";
          "reachable";
          "registered";
          "repo";
          "running";
          "siteName";
        ];
  }

let shape_363 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "root" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("root", { any with kinds = Some [ String ]; min_length = Some 1 });
      ];
    closed = Some [ "apiVersion"; "root" ];
  }

let shape_364 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "path"; "directoryMissing" ];
    members =
      [
        ("directoryMissing", { any with kinds = Some [ Boolean ] });
        ("path", { any with kinds = Some [ String ] });
        ("persistentState", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "directoryMissing"; "path"; "persistentState" ];
  }

let shape_365 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "path"; "domain" ];
    members =
      [
        ( "anthropicEndpoint",
          { any with kinds = Some [ String ]; min_length = Some 1 } );
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("configName", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("domain", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("embedding", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "inference",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"anthropic\""; `Stringlit "\"ollama\"" ];
          } );
        ("model", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("modelLight", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("name", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("ollamaBase", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "ollamaRegistry",
          { any with kinds = Some [ String ]; min_length = Some 1 } );
        ("path", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("siteName", { any with kinds = Some [ String ]; min_length = Some 1 });
      ];
    closed =
      Some
        [
          "anthropicEndpoint";
          "apiVersion";
          "configName";
          "domain";
          "embedding";
          "inference";
          "model";
          "modelLight";
          "name";
          "ollamaBase";
          "ollamaRegistry";
          "path";
          "siteName";
        ];
  }

let shape_366 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "path" ];
    members =
      [ ("path", { any with kinds = Some [ String ]; min_length = Some 1 }) ];
    closed = Some [ "path" ];
  }

let shape_367 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion" ];
    members = [ ("apiVersion", { any with reference = Some "ApiVersion" }) ];
    closed = Some [ "apiVersion" ];
  }

let shape_368 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "roots" ];
    members =
      [
        ( "roots",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "Root" };
          } );
        ( "warnings",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
      ];
    closed = Some [ "roots"; "warnings" ];
  }

let shape_369 () =
  {
    any with
    kinds = Some [ String ];
    pattern =
      Some
        [
          Step ([ (48, 57); (97, 122) ], 1, None);
          Group
            ( [
                [
                  Step ([ (45, 45) ], 1, Some 1);
                  Step ([ (48, 57); (97, 122) ], 1, None);
                ];
              ],
              0,
              None );
        ];
  }

let shape_370 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"archivist\"";
          `Stringlit "\"dispatcher\"";
          `Stringlit "\"gateway\"";
          `Stringlit "\"librarian\"";
          `Stringlit "\"smelter\"";
          `Stringlit "\"weaver\"";
          `Stringlit "\"worker\"";
        ];
  }

let shape_371 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        {
          any with
          kinds = Some [ Object ];
          required = [ "image"; "resources" ];
          not_all = [ [ "external" ] ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "external" ];
          not_all = [ [ "image" ]; [ "resources" ] ];
        };
      ];
  }

let shape_372 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"container\"";
          `Stringlit "\"docker\"";
          `Stringlit "\"podman\"";
        ];
  }

let shape_373 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "name"; "found" ];
    members =
      [
        ("found", { any with kinds = Some [ Boolean ] });
        ("name", { any with reference = Some "Runtime" });
      ];
    closed = Some [ "found"; "name" ];
  }

let shape_374 () =
  {
    any with
    kinds = Some [ Object ];
    all_of =
      [
        { any with reference = Some "ResourceDescriptor" };
        {
          any with
          kinds = Some [ Object ];
          members =
            [
              ("matchReason", { any with kinds = Some [ String ] });
              ("score", { any with kinds = Some [ Number ] });
            ];
        };
      ];
  }

let shape_375 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "fromEnv" ];
    members =
      [
        ( "fromEnv",
          {
            any with
            kinds = Some [ String ];
            pattern =
              Some
                [
                  Step ([ (65, 90); (95, 95); (97, 122) ], 1, Some 1);
                  Step ([ (48, 57); (65, 90); (95, 95); (97, 122) ], 0, None);
                ];
          } );
      ];
    closed = Some [ "fromEnv" ];
  }

let shape_376 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "TextPositionSelector" };
        { any with reference = Some "TextQuoteSelector" };
        { any with reference = Some "SvgSelector" };
        { any with reference = Some "FragmentSelector" };
      ];
    discriminator =
      Some
        ( "type",
          [
            ("TextPositionSelector", 0);
            ("TextQuoteSelector", 1);
            ("SvgSelector", 2);
            ("FragmentSelector", 3);
          ] );
  }

let shape_377 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "text"; "resourceId"; "resourceName"; "score" ];
    members =
      [
        ("annotationId", { any with reference = Some "AnnotationId" });
        ( "entityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("machineRead", { any with kinds = Some [ Boolean ] });
        ("resourceId", { any with reference = Some "ResourceId" });
        ("resourceName", { any with kinds = Some [ String ] });
        ("score", { any with kinds = Some [ Number ] });
        ("text", { any with kinds = Some [ String ] });
      ];
  }

let shape_378 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "host"; "port" ];
    members =
      [
        ("host", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "port",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "65535";
          } );
      ];
    closed = Some [ "host"; "port" ];
  }

let shape_379 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"record\"";
          `Stringlit "\"index\"";
          `Stringlit "\"issuer\"";
          `Stringlit "\"knowledge-workers\"";
          `Stringlit "\"providers\"";
          `Stringlit "\"telemetry\"";
        ];
  }

let shape_380 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("runtime", { any with reference = Some "Runtime" });
      ];
    closed = Some [ "apiVersion"; "runtime" ];
  }

let shape_381 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "runtime"; "address" ];
    members =
      [
        ("address", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("runtime", { any with reference = Some "Runtime" });
      ];
    closed = Some [ "address"; "runtime" ];
  }

let shape_382 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "issuer" ];
    members =
      [ ("issuer", { any with kinds = Some [ String ]; min_length = Some 1 }) ];
    closed = Some [ "issuer" ];
  }

let shape_383 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "requestId"; "instance"; "stream"; "line" ];
    members =
      [
        ("instance", { any with reference = Some "RunInstance" });
        ("line", { any with kinds = Some [ String ] });
        ("requestId", { any with reference = Some "RequestId" });
        ("stream", { any with reference = Some "OutputStream" });
      ];
    closed = Some [ "instance"; "line"; "requestId"; "stream" ];
  }

let shape_384 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [
        "apiVersion";
        "target";
        "service";
        "instance";
        "environment";
        "mounts";
        "pathFirst";
        "ports";
      ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ( "args",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("document", { any with kinds = Some [ String ] });
        ( "environment",
          {
            any with
            kinds = Some [ Object ];
            values = Some { any with kinds = Some [ String ] };
          } );
        ("instance", { any with reference = Some "RunInstance" });
        ( "mounts",
          {
            any with
            kinds = Some [ Array ];
            items =
              Some
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (47, 47) ], 1, Some 1);
                        Step ([ (0, 1114111) ], 0, None);
                      ];
                };
          } );
        ( "pathFirst",
          {
            any with
            kinds = Some [ Array ];
            items =
              Some
                {
                  any with
                  kinds = Some [ String ];
                  pattern =
                    Some
                      [
                        Step ([ (47, 47) ], 1, Some 1);
                        Step ([ (0, 1114111) ], 0, None);
                      ];
                };
          } );
        ( "ports",
          {
            any with
            kinds = Some [ Array ];
            items =
              Some { any with kinds = Some [ Integer ]; minimum = Some "1" };
          } );
        ("runtime", { any with reference = Some "Runtime" });
        ("service", { any with reference = Some "RunService" });
        ("target", { any with reference = Some "LocalTarget" });
      ];
    closed =
      Some
        [
          "apiVersion";
          "args";
          "document";
          "environment";
          "instance";
          "mounts";
          "pathFirst";
          "ports";
          "runtime";
          "service";
          "target";
        ];
  }

let shape_385 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "instance"; "exitCode"; "ranMs" ];
    members =
      [
        ("exitCode", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("instance", { any with reference = Some "RunInstance" });
        ("ranMs", { any with kinds = Some [ Integer ]; minimum = Some "0" });
      ];
    closed = Some [ "exitCode"; "instance"; "ranMs" ];
  }

let shape_386 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "target"; "instance"; "signal" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("instance", { any with reference = Some "RunInstance" });
        ("runtime", { any with reference = Some "Runtime" });
        ( "signal",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"term\""; `Stringlit "\"kill\"" ];
          } );
        ("target", { any with reference = Some "LocalTarget" });
      ];
    closed = Some [ "apiVersion"; "instance"; "runtime"; "signal"; "target" ];
  }

let shape_387 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "delivered" ];
    members = [ ("delivered", { any with kinds = Some [ Boolean ] }) ];
    closed = Some [ "delivered" ];
  }

let shape_388 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "requestId"; "instance"; "container"; "address" ];
    members =
      [
        ("address", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("container", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "documentPath",
          {
            any with
            kinds = Some [ String ];
            pattern =
              Some
                [
                  Step ([ (47, 47) ], 1, Some 1);
                  Step ([ (0, 1114111) ], 0, None);
                ];
          } );
        ("instance", { any with reference = Some "RunInstance" });
        ("requestId", { any with reference = Some "RequestId" });
      ];
    closed =
      Some [ "address"; "container"; "documentPath"; "instance"; "requestId" ];
  }

let shape_389 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "role"; "group"; "state"; "healthy"; "counted" ];
    members =
      [
        ("containerState", { any with kinds = Some [ String ] });
        ("counted", { any with kinds = Some [ Boolean ] });
        ("group", { any with reference = Some "ServiceGroup" });
        ("healthy", { any with kinds = Some [ Boolean ] });
        ("page", { any with kinds = Some [ String ] });
        ("probe", { any with kinds = Some [ String ] });
        ("product", { any with kinds = Some [ String ] });
        ("realm", { any with kinds = Some [ String ] });
        ("role", { any with kinds = Some [ String ] });
        ("runsOn", { any with kinds = Some [ String ] });
        ( "serves",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ( "state",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"running\"";
                  `Stringlit "\"stopped\"";
                  `Stringlit "\"reachable\"";
                  `Stringlit "\"unreachable\"";
                  `Stringlit "\"absent\"";
                  `Stringlit "\"not-configured\"";
                ];
          } );
      ];
    closed =
      Some
        [
          "containerState";
          "counted";
          "group";
          "healthy";
          "page";
          "probe";
          "product";
          "realm";
          "role";
          "runsOn";
          "serves";
          "state";
        ];
  }

let shape_390 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "state" ];
    members =
      [
        ("email", { any with kinds = Some [ String ] });
        ( "state",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"valid\"";
                  `Stringlit "\"expired\"";
                  `Stringlit "\"unverified\"";
                  `Stringlit "\"none\"";
                ];
          } );
      ];
    closed = Some [ "email"; "state" ];
  }

let shape_391 () =
  {
    any with
    kinds = Some [ String ];
    enum = Some [ `Stringlit "\"expired\""; `Stringlit "\"refused\"" ];
  }

let shape_392 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "reason" ];
    members = [ ("reason", { any with reference = Some "SessionEndReason" }) ];
    closed = Some [ "reason" ];
  }

let shape_393 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "participant"; "connectionId" ];
    members =
      [
        ("connectionId", { any with kinds = Some [ String ] });
        ("participant", { any with reference = Some "UserId" });
      ];
  }

let shape_394 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "participant"; "connectionId" ];
    members =
      [
        ("connectionId", { any with kinds = Some [ String ] });
        ("participant", { any with reference = Some "UserId" });
      ];
  }

let shape_395 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "name"; "default"; "appliesTo"; "values"; "settable" ];
    members =
      [
        ( "appliesTo",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some [ `Stringlit "\"machine\""; `Stringlit "\"knowledge-base\"" ];
          } );
        ("changedBy", { any with kinds = Some [ String ] });
        ("default", { any with kinds = Some [ Boolean ] });
        ("name", { any with kinds = Some [ String ] });
        ("settable", { any with kinds = Some [ Boolean ] });
        ( "values",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "SettingLine" };
          } );
      ];
    closed =
      Some [ "appliesTo"; "changedBy"; "default"; "name"; "settable"; "values" ];
  }

let shape_396 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "value"; "source" ];
    members =
      [
        ("source", { any with kinds = Some [ String ] });
        ("value", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "source"; "value" ];
  }

let shape_397 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "name" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("default", { any with kinds = Some [ Boolean ] });
        ("name", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("root", { any with kinds = Some [ String ]; min_length = Some 1 });
      ];
    closed = Some [ "apiVersion"; "default"; "name"; "root" ];
  }

let shape_398 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "hoverDelayMs" ];
    members = [ ("hoverDelayMs", { any with kinds = Some [ Integer ] }) ];
  }

let shape_399 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("root", { any with kinds = Some [ String ]; min_length = Some 1 });
      ];
    closed = Some [ "apiVersion"; "root" ];
  }

let shape_400 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "settings" ];
    members =
      [
        ("root", { any with kinds = Some [ String ] });
        ( "settings",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "Setting" };
          } );
        ("unresolved", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "root"; "settings"; "unresolved" ];
  }

let shape_401 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "locale" ];
    members = [ ("locale", { any with kinds = Some [ String ] }) ];
  }

let shape_402 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "document" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ( "document",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"browser\"";
                  `Stringlit "\"worker\"";
                  `Stringlit "\"issuer\"";
                  `Stringlit "\"vectors\"";
                ];
          } );
      ];
    closed = Some [ "apiVersion"; "document" ];
  }

let shape_403 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "path" ];
    members = [ ("path", { any with kinds = Some [ String ] }) ];
    closed = Some [ "path" ];
  }

let shape_404 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "name"; "value" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("default", { any with kinds = Some [ Boolean ] });
        ("name", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("root", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("value", { any with kinds = Some [ String ]; min_length = Some 1 });
      ];
    closed = Some [ "apiVersion"; "default"; "name"; "root"; "value" ];
  }

let shape_405 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "theme" ];
    members =
      [
        ( "theme",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"light\"";
                  `Stringlit "\"dark\"";
                  `Stringlit "\"system\"";
                ];
          } );
      ];
  }

let shape_406 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "name" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("default", { any with kinds = Some [ Boolean ] });
        ("name", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("root", { any with kinds = Some [ String ]; min_length = Some 1 });
      ];
    closed = Some [ "apiVersion"; "default"; "name"; "root" ];
  }

let shape_407 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "kb" ];
    members =
      [
        ("expected", { any with reference = Some "Expected" });
        ("kb", { any with reference = Some "KnowledgeBase" });
      ];
    closed = Some [ "expected"; "kb" ];
  }

let shape_408 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "endpoint"; "description"; "session" ];
    members =
      [
        ("description", { any with reference = Some "KbDescription" });
        ("endpoint", { any with reference = Some "KbEndpoint" });
        ("expectedDid", { any with kinds = Some [ String ] });
        ("expectedName", { any with kinds = Some [ String ] });
        ("kbId", { any with kinds = Some [ String ] });
        ("session", { any with reference = Some "StoredSession" });
      ];
    closed =
      Some
        [
          "description";
          "endpoint";
          "expectedDid";
          "expectedName";
          "kbId";
          "session";
        ];
  }

let shape_409 () =
  {
    any with
    kinds = Some [ Object ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_410 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "contentChecksum"; "outcome" ];
    members =
      [
        ("contentChecksum", { any with kinds = Some [ String ] });
        ( "outcome",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"indexed\""; `Stringlit "\"skipped\"" ];
          } );
        ( "reason",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"no-extractor\"";
                  `Stringlit "\"empty\"";
                  `Stringlit "\"no-text-layer\"";
                  `Stringlit "\"encrypted\"";
                  `Stringlit "\"corrupt\"";
                  `Stringlit "\"too-large\"";
                ];
          } );
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_411 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "chunkSize"; "overlap" ];
    members =
      [
        ("chunkSize", { any with kinds = Some [ Integer ]; minimum = Some "1" });
        ("overlap", { any with kinds = Some [ Integer ]; minimum = Some "0" });
      ];
    closed = Some [ "chunkSize"; "overlap" ];
  }

let shape_412 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [
        "kb";
        "gatewayUrl";
        "identity";
        "archivist";
        "embedding";
        "vectors";
        "chunking";
        "pdfsAtOnce";
        "cursorsPath";
        "port";
        "logLevel";
        "logFormat";
      ];
    members =
      [
        ("archivist", { any with reference = Some "ServiceAddress" });
        ("chunking", { any with reference = Some "SmelterChunking" });
        ("cursorsPath", { any with reference = Some "CursorsPath" });
        ("embedding", { any with reference = Some "EmbeddingConfig" });
        ("gatewayUrl", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("identity", { any with reference = Some "ServiceIdentity" });
        ("kb", { any with reference = Some "KbIdentity" });
        ("logFormat", { any with reference = Some "LogFormat" });
        ("logLevel", { any with reference = Some "LogLevel" });
        ("pdfsAtOnce", { any with kinds = Some [ Integer ]; minimum = Some "1" });
        ( "port",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "65535";
          } );
        ("vectors", { any with reference = Some "VectorsConfig" });
      ];
    closed =
      Some
        [
          "archivist";
          "chunking";
          "cursorsPath";
          "embedding";
          "gatewayUrl";
          "identity";
          "kb";
          "logFormat";
          "logLevel";
          "pdfsAtOnce";
          "port";
          "vectors";
        ];
  }

let shape_413 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [
        "status";
        "kb";
        "stream";
        "following";
        "eventsProcessed";
        "reconcile";
        "index";
      ];
    members =
      [
        ( "eventsProcessed",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ("following", { any with reference = Some "FollowerFollowing" });
        ( "index",
          {
            any with
            kinds = Some [ Object ];
            required = [ "stamp"; "madeAnew" ];
            members =
              [
                ("madeAnew", { any with kinds = Some [ Boolean ] });
                ( "stamp",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "embedding"; "chunking" ];
                    members =
                      [
                        ( "chunking",
                          { any with reference = Some "SmelterChunking" } );
                        ( "embedding",
                          {
                            any with
                            kinds = Some [ Object ];
                            required = [ "type"; "model" ];
                            members =
                              [
                                ( "model",
                                  {
                                    any with
                                    kinds = Some [ String ];
                                    min_length = Some 1;
                                  } );
                                ( "type",
                                  {
                                    any with
                                    kinds = Some [ String ];
                                    min_length = Some 1;
                                  } );
                              ];
                            closed = Some [ "model"; "type" ];
                          } );
                      ];
                    closed = Some [ "chunking"; "embedding" ];
                  } );
              ];
            closed = Some [ "madeAnew"; "stamp" ];
          } );
        ("kb", { any with reference = Some "KbDid" });
        ( "reconcile",
          {
            any with
            kinds = Some [ Object ];
            required = [ "phase" ];
            members =
              [
                ("error", { any with kinds = Some [ String ] });
                ( "phase",
                  {
                    any with
                    kinds = Some [ String ];
                    enum =
                      Some
                        [
                          `Stringlit "\"pending\"";
                          `Stringlit "\"running\"";
                          `Stringlit "\"done\"";
                          `Stringlit "\"failed\"";
                        ];
                  } );
                ( "summary",
                  { any with reference = Some "SmelterReconcileSummary" } );
              ];
            closed = Some [ "error"; "phase"; "summary" ];
          } );
        ( "status",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"ok\"" ];
          } );
        ( "stream",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"initial\"";
                  `Stringlit "\"connecting\"";
                  `Stringlit "\"open\"";
                  `Stringlit "\"reconnecting\"";
                  `Stringlit "\"degraded\"";
                  `Stringlit "\"unauthenticated\"";
                  `Stringlit "\"closed\"";
                ];
          } );
      ];
    closed =
      Some
        [
          "eventsProcessed";
          "following";
          "index";
          "kb";
          "reconcile";
          "status";
          "stream";
        ];
  }

let shape_414 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [
        "resourcesEmbedded";
        "resourcesSkipped";
        "resourcesUnavailable";
        "resourcesFailed";
        "resourcesRestamped";
        "resourcesReanchored";
        "resourceVectorsDeleted";
        "annotationsEmbedded";
        "annotationsRestamped";
        "annotationVectorsDeleted";
        "resourcesEligible";
        "resourcesIndexed";
      ];
    members =
      [
        ( "annotationVectorsDeleted",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ( "annotationsEmbedded",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ( "annotationsRestamped",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ( "resourceVectorsDeleted",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ( "resourcesEligible",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ( "resourcesEmbedded",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ( "resourcesFailed",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ( "resourcesIndexed",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ( "resourcesReanchored",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ( "resourcesRestamped",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ( "resourcesSkipped",
          {
            any with
            kinds = Some [ Object ];
            values =
              Some { any with kinds = Some [ Integer ]; minimum = Some "0" };
          } );
        ( "resourcesUnavailable",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
      ];
    closed =
      Some
        [
          "annotationVectorsDeleted";
          "annotationsEmbedded";
          "annotationsRestamped";
          "resourceVectorsDeleted";
          "resourcesEligible";
          "resourcesEmbedded";
          "resourcesFailed";
          "resourcesIndexed";
          "resourcesReanchored";
          "resourcesRestamped";
          "resourcesSkipped";
          "resourcesUnavailable";
        ];
  }

let shape_415 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type"; "source" ];
    members =
      [
        ("purpose", { any with reference = Some "BodyPurpose" });
        ("source", { any with reference = Some "ResourceId" });
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"SpecificResource\"" ];
          } );
      ];
  }

let shape_416 () =
  {
    any with
    kinds = Some [ String ];
    enum = Some [ `Stringlit "\"xynolog.org/v1alpha1\"" ];
  }

let shape_417 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "kind"; "metadata"; "spec" ];
    members =
      [
        ("apiVersion", { any with reference = Some "StackApiVersion" });
        ( "kind",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"KnowledgeBase\"" ];
          } );
        ("metadata", { any with reference = Some "Metadata" });
        ( "spec",
          {
            any with
            kinds = Some [ Object ];
            required =
              [
                "logLevel";
                "gateway";
                "dispatcher";
                "archivist";
                "messaging";
                "issuer";
              ];
            members =
              [
                ( "archivist",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "image"; "resources" ];
                    members =
                      [
                        ("address", { any with reference = Some "HostPort" });
                        ("image", { any with reference = Some "Image" });
                        ("resources", { any with reference = Some "Resources" });
                      ];
                    closed = Some [ "address"; "image"; "resources" ];
                  } );
                ( "dispatcher",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "image"; "resources" ];
                    members =
                      [
                        ("image", { any with reference = Some "Image" });
                        ("resources", { any with reference = Some "Resources" });
                      ];
                    closed = Some [ "image"; "resources" ];
                  } );
                ( "gateway",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "image"; "resources"; "port"; "publicURL" ];
                    members =
                      [
                        ("image", { any with reference = Some "Image" });
                        ( "port",
                          {
                            any with
                            kinds = Some [ Integer ];
                            minimum = Some "1";
                            maximum = Some "65535";
                          } );
                        ( "publicURL",
                          {
                            any with
                            kinds = Some [ String ];
                            min_length = Some 1;
                          } );
                        ("resources", { any with reference = Some "Resources" });
                      ];
                    closed = Some [ "image"; "port"; "publicURL"; "resources" ];
                  } );
                ( "issuer",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "subjectClaim" ];
                    members =
                      [
                        ( "external",
                          {
                            any with
                            kinds = Some [ Object ];
                            required = [ "type"; "url" ];
                            members =
                              [
                                ( "type",
                                  {
                                    any with
                                    kinds = Some [ String ];
                                    min_length = Some 1;
                                  } );
                                ( "url",
                                  {
                                    any with
                                    kinds = Some [ String ];
                                    min_length = Some 1;
                                  } );
                              ];
                            closed = Some [ "type"; "url" ];
                          } );
                        ( "shared",
                          {
                            any with
                            kinds = Some [ Object ];
                            required = [ "accessTokenLifespan" ];
                            members =
                              [
                                ( "accessTokenLifespan",
                                  {
                                    any with
                                    kinds = Some [ Integer ];
                                    minimum = Some "1";
                                  } );
                              ];
                            closed = Some [ "accessTokenLifespan" ];
                          } );
                        ( "subjectClaim",
                          {
                            any with
                            kinds = Some [ String ];
                            min_length = Some 1;
                          } );
                      ];
                    closed = Some [ "external"; "shared"; "subjectClaim" ];
                    variants =
                      [
                        {
                          any with
                          kinds = Some [ Object ];
                          required = [ "shared" ];
                        };
                        {
                          any with
                          kinds = Some [ Object ];
                          required = [ "external" ];
                        };
                      ];
                  } );
                ("logLevel", { any with reference = Some "LogLevel" });
                ( "messaging",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "jobs"; "signal" ];
                    members =
                      [
                        ( "external",
                          {
                            any with
                            kinds = Some [ Object ];
                            required = [ "servers"; "user"; "password" ];
                            members =
                              [
                                ( "password",
                                  { any with reference = Some "SecretRef" } );
                                ( "servers",
                                  {
                                    any with
                                    kinds = Some [ String ];
                                    min_length = Some 1;
                                  } );
                                ( "user",
                                  { any with reference = Some "SecretRef" } );
                              ];
                            closed = Some [ "password"; "servers"; "user" ];
                          } );
                        ("image", { any with reference = Some "Image" });
                        ( "jobs",
                          {
                            any with
                            kinds = Some [ Object ];
                            required = [ "type" ];
                            members =
                              [
                                ( "type",
                                  {
                                    any with
                                    kinds = Some [ String ];
                                    min_length = Some 1;
                                  } );
                              ];
                            closed = Some [ "type" ];
                          } );
                        ("resources", { any with reference = Some "Resources" });
                        ( "signal",
                          {
                            any with
                            kinds = Some [ Object ];
                            required = [ "type" ];
                            members =
                              [
                                ( "type",
                                  {
                                    any with
                                    kinds = Some [ String ];
                                    min_length = Some 1;
                                  } );
                              ];
                            closed = Some [ "type" ];
                          } );
                      ];
                    closed =
                      Some
                        [ "external"; "image"; "jobs"; "resources"; "signal" ];
                    all_of = [ { any with reference = Some "Runner" } ];
                  } );
              ];
            closed =
              Some
                [
                  "archivist";
                  "dispatcher";
                  "gateway";
                  "issuer";
                  "logLevel";
                  "messaging";
                ];
          } );
      ];
    closed = Some [ "apiVersion"; "kind"; "metadata"; "spec" ];
  }

let shape_418 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ( "codespaceName",
          { any with kinds = Some [ String ]; min_length = Some 1 } );
        ("config", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("dryRun", { any with kinds = Some [ Boolean ] });
        ("group", { any with reference = Some "ServiceGroup" });
        ( "idleTimeout",
          { any with kinds = Some [ String ]; min_length = Some 1 } );
        ("machine", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("observe", { any with kinds = Some [ Boolean ] });
        ( "ollamaCache",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"host\""; `Stringlit "\"volume\"" ];
          } );
        ( "retentionPeriod",
          { any with kinds = Some [ String ]; min_length = Some 1 } );
        ("runtime", { any with reference = Some "Runtime" });
        ("service", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("target", { any with reference = Some "Target" });
      ];
    closed =
      Some
        [
          "apiVersion";
          "codespaceName";
          "config";
          "dryRun";
          "group";
          "idleTimeout";
          "machine";
          "observe";
          "ollamaCache";
          "retentionPeriod";
          "runtime";
          "service";
          "target";
        ];
  }

let shape_419 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "dryRun" ];
    members =
      [
        ("dryRun", { any with kinds = Some [ Boolean ] });
        ("knowledgeBase", { any with reference = Some "KnowledgeBaseStatus" });
        ( "shared",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "ServiceStatus" };
          } );
      ];
    closed = Some [ "dryRun"; "knowledgeBase"; "shared" ];
  }

let shape_420 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("delete", { any with kinds = Some [ Boolean ] });
        ("deleteConfirmed", { any with kinds = Some [ Boolean ] });
        ("dryRun", { any with kinds = Some [ Boolean ] });
        ("group", { any with reference = Some "ServiceGroup" });
        ("runtime", { any with reference = Some "Runtime" });
        ("service", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("target", { any with reference = Some "Target" });
      ];
    closed =
      Some
        [
          "apiVersion";
          "delete";
          "deleteConfirmed";
          "dryRun";
          "group";
          "runtime";
          "service";
          "target";
        ];
  }

let shape_421 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "dryRun" ];
    members =
      [
        ("dryRun", { any with kinds = Some [ Boolean ] });
        ( "knowledgeBases",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "KnowledgeBaseStatus" };
          } );
        ( "shared",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "ServiceStatus" };
          } );
      ];
    closed = Some [ "dryRun"; "knowledgeBases"; "shared" ];
  }

let shape_422 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "status"; "version"; "features"; "message" ];
    members =
      [
        ("authenticatedAs", { any with kinds = Some [ String ] });
        ( "features",
          {
            any with
            kinds = Some [ Object ];
            required = [ "semanticContent"; "collaboration" ];
            members =
              [
                ("collaboration", { any with kinds = Some [ String ] });
                ("semanticContent", { any with kinds = Some [ String ] });
              ];
          } );
        ("message", { any with kinds = Some [ String ] });
        ("status", { any with kinds = Some [ String ] });
        ("version", { any with kinds = Some [ String ] });
      ];
  }

let shape_423 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion" ];
    members =
      [
        ("apiVersion", { any with reference = Some "ApiVersion" });
        ("runtime", { any with reference = Some "Runtime" });
        ("target", { any with reference = Some "Target" });
      ];
    closed = Some [ "apiVersion"; "runtime"; "target" ];
  }

let shape_424 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "knowledgeBases"; "shared" ];
    members =
      [
        ( "knowledgeBases",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "KnowledgeBaseStatus" };
          } );
        ( "shared",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "ServiceStatus" };
          } );
      ];
    closed = Some [ "knowledgeBases"; "shared" ];
  }

let shape_425 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "uri"; "resourceId" ];
    members =
      [
        ("resourceId", { any with reference = Some "ResourceId" });
        ("uri", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "resourceId"; "uri" ];
  }

let shape_426 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [ "id"; "type"; "timestamp"; "userId"; "version"; "payload"; "metadata" ];
    members =
      [
        ("id", { any with kinds = Some [ String ] });
        ("metadata", { any with reference = Some "EventMetadata" });
        ("payload", { any with kinds = Some [ Object ] });
        ("resourceId", { any with reference = Some "ResourceId" });
        ("timestamp", { any with kinds = Some [ String ] });
        ("type", { any with kinds = Some [ String ] });
        ("userId", { any with reference = Some "UserId" });
        ("version", { any with kinds = Some [ Integer ] });
      ];
  }

let shape_427 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "access"; "refresh"; "clientId"; "tokenEndpoint" ];
    members =
      [
        ("access", { any with kinds = Some [ String ] });
        ("clientId", { any with kinds = Some [ String ] });
        ("personKey", { any with kinds = Some [ String ] });
        ("refresh", { any with kinds = Some [ String ] });
        ("revocationEndpoint", { any with kinds = Some [ String ] });
        ("tokenEndpoint", { any with kinds = Some [ String ] });
      ];
  }

let shape_428 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"text/plain\"";
          `Stringlit "\"text/markdown\"";
          `Stringlit "\"text/html\"";
          `Stringlit "\"text/css\"";
          `Stringlit "\"text/csv\"";
          `Stringlit "\"text/xml\"";
          `Stringlit "\"application/json\"";
          `Stringlit "\"application/xml\"";
          `Stringlit "\"application/yaml\"";
          `Stringlit "\"application/x-yaml\"";
          `Stringlit "\"application/pdf\"";
          `Stringlit "\"application/msword\"";
          `Stringlit
            "\"application/vnd.openxmlformats-officedocument.wordprocessingml.document\"";
          `Stringlit "\"application/vnd.ms-excel\"";
          `Stringlit
            "\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\"";
          `Stringlit "\"application/vnd.ms-powerpoint\"";
          `Stringlit
            "\"application/vnd.openxmlformats-officedocument.presentationml.presentation\"";
          `Stringlit "\"application/zip\"";
          `Stringlit "\"application/gzip\"";
          `Stringlit "\"application/x-tar\"";
          `Stringlit "\"application/x-7z-compressed\"";
          `Stringlit "\"application/octet-stream\"";
          `Stringlit "\"application/wasm\"";
          `Stringlit "\"image/png\"";
          `Stringlit "\"image/jpeg\"";
          `Stringlit "\"image/gif\"";
          `Stringlit "\"image/webp\"";
          `Stringlit "\"image/svg+xml\"";
          `Stringlit "\"image/bmp\"";
          `Stringlit "\"image/tiff\"";
          `Stringlit "\"image/x-icon\"";
          `Stringlit "\"video/mp4\"";
          `Stringlit "\"video/mpeg\"";
          `Stringlit "\"video/webm\"";
          `Stringlit "\"video/ogg\"";
          `Stringlit "\"video/quicktime\"";
          `Stringlit "\"video/x-msvideo\"";
          `Stringlit "\"audio/mpeg\"";
          `Stringlit "\"audio/wav\"";
          `Stringlit "\"audio/ogg\"";
          `Stringlit "\"audio/webm\"";
          `Stringlit "\"audio/aac\"";
          `Stringlit "\"audio/flac\"";
          `Stringlit "\"text/javascript\"";
          `Stringlit "\"application/javascript\"";
          `Stringlit "\"text/x-typescript\"";
          `Stringlit "\"application/typescript\"";
          `Stringlit "\"text/x-python\"";
          `Stringlit "\"text/x-java\"";
          `Stringlit "\"text/x-c\"";
          `Stringlit "\"text/x-c++\"";
          `Stringlit "\"text/x-csharp\"";
          `Stringlit "\"text/x-go\"";
          `Stringlit "\"text/x-rust\"";
          `Stringlit "\"text/x-ruby\"";
          `Stringlit "\"text/x-php\"";
          `Stringlit "\"text/x-swift\"";
          `Stringlit "\"text/x-kotlin\"";
          `Stringlit "\"text/x-shell\"";
          `Stringlit "\"font/woff\"";
          `Stringlit "\"font/woff2\"";
          `Stringlit "\"font/ttf\"";
          `Stringlit "\"font/otf\"";
        ];
  }

let shape_429 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type"; "value" ];
    members =
      [
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"SvgSelector\"" ];
          } );
        ("value", { any with kinds = Some [ String ] });
      ];
  }

let shape_430 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        {
          any with
          kinds = Some [ Object ];
          required = [ "verdict" ];
          members =
            [
              ( "verdict",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"gone\"" ];
                  all_of = [ { any with reference = Some "TabVerdict" } ];
                } );
            ];
          closed = Some [ "verdict" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "verdict"; "name" ];
          members =
            [
              ("mediaType", { any with kinds = Some [ String ] });
              ("name", { any with kinds = Some [ String ] });
              ( "verdict",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"ready\"" ];
                  all_of = [ { any with reference = Some "TabVerdict" } ];
                } );
            ];
          closed = Some [ "mediaType"; "name"; "verdict" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "verdict" ];
          members =
            [
              ( "verdict",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"unknown\"" ];
                  all_of = [ { any with reference = Some "TabVerdict" } ];
                } );
            ];
          closed = Some [ "verdict" ];
        };
      ];
    discriminator =
      Some ("verdict", [ ("gone", 0); ("ready", 1); ("unknown", 2) ]);
  }

let shape_431 () =
  {
    any with
    kinds = Some [ String ];
    enum =
      Some
        [
          `Stringlit "\"gone\"";
          `Stringlit "\"ready\"";
          `Stringlit "\"unknown\"";
        ];
  }

let shape_432 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "name"; "description"; "examples" ];
    members =
      [
        ("description", { any with kinds = Some [ String ] });
        ( "examples",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("name", { any with kinds = Some [ String ] });
      ];
  }

let shape_433 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "id"; "name"; "description"; "domain"; "tags" ];
    members =
      [
        ("description", { any with kinds = Some [ String ] });
        ("domain", { any with kinds = Some [ String ] });
        ("id", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
        ( "tags",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "TagCategory" };
          } );
      ];
  }

let shape_434 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "schema" ];
    members = [ ("schema", { any with reference = Some "TagSchema" }) ];
  }

let shape_435 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "tagSchemas" ];
    members =
      [
        ( "tagSchemas",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with reference = Some "TagSchema" };
          } );
      ];
    closed = Some [ "tagSchemas" ];
  }

let shape_436 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "motivation"; "schemaId"; "categories" ];
    members =
      [
        ( "categories",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            items = Some { any with kinds = Some [ String ] };
          } );
        ("language", { any with kinds = Some [ String ] });
        ( "motivation",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"tagging\"" ];
          } );
        ("schemaId", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("sourceLanguage", { any with kinds = Some [ String ] });
      ];
    closed =
      Some
        [ "categories"; "language"; "motivation"; "schemaId"; "sourceLanguage" ];
  }

let shape_437 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "kind" ];
    members =
      [
        ( "kind",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"local\""; `Stringlit "\"codespace\"" ];
          } );
        ( "repo",
          {
            any with
            kinds = Some [ String ];
            pattern =
              Some
                [
                  Step
                    ( [
                        (0, 8);
                        (14, 31);
                        (33, 46);
                        (48, 159);
                        (161, 5759);
                        (5761, 8191);
                        (8203, 8231);
                        (8234, 8238);
                        (8240, 8286);
                        (8288, 12287);
                        (12289, 65278);
                        (65280, 1114111);
                      ],
                      1,
                      None );
                  Step ([ (47, 47) ], 1, Some 1);
                  Step
                    ( [
                        (0, 8);
                        (14, 31);
                        (33, 46);
                        (48, 159);
                        (161, 5759);
                        (5761, 8191);
                        (8203, 8231);
                        (8234, 8238);
                        (8240, 8286);
                        (8288, 12287);
                        (12289, 65278);
                        (65280, 1114111);
                      ],
                      1,
                      None );
                ];
          } );
        ("root", { any with kinds = Some [ String ]; min_length = Some 1 });
      ];
    closed = Some [ "kind"; "repo"; "root" ];
    variants =
      [
        {
          any with
          kinds = Some [ Object ];
          members =
            [
              ( "kind",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"local\"" ];
                } );
            ];
          not_all = [ [ "repo" ] ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "repo" ];
          members =
            [
              ( "kind",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"codespace\"" ];
                } );
            ];
          not_all = [ [ "root" ] ];
        };
      ];
  }

let shape_438 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type"; "start"; "end" ];
    members =
      [
        ("end", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("start", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"TextPositionSelector\"" ];
          } );
      ];
  }

let shape_439 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type"; "exact" ];
    members =
      [
        ("exact", { any with kinds = Some [ String ] });
        ("prefix", { any with kinds = Some [ String ] });
        ("suffix", { any with kinds = Some [ String ] });
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"TextQuoteSelector\"" ];
          } );
      ];
  }

let shape_440 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "start"; "end"; "exact" ];
    members =
      [
        ("end", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("exact", { any with kinds = Some [ String ] });
        ("prefix", { any with kinds = Some [ String ] });
        ("start", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("suffix", { any with kinds = Some [ String ] });
      ];
    closed = Some [ "end"; "exact"; "prefix"; "start"; "suffix" ];
  }

let shape_441 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type"; "value" ];
    members =
      [
        ("format", { any with kinds = Some [ String ] });
        ("language", { any with kinds = Some [ String ] });
        ("purpose", { any with reference = Some "BodyPurpose" });
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"TextualBody\"" ];
          } );
        ("value", { any with kinds = Some [ String ] });
      ];
  }

let shape_442 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "next"; "size"; "found"; "emitted"; "errors" ];
    members =
      [
        ("emitted", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("errors", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("found", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("next", { any with kinds = Some [ Integer ]; minimum = Some "0" });
        ("size", { any with kinds = Some [ Integer ]; minimum = Some "1" });
      ];
  }

let shape_443 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "operations" ];
    members =
      [
        ( "operations",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            items = Some { any with reference = Some "BodyOperation" };
          } );
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_444 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        {
          any with
          kinds = Some [ Object ];
          required = [ "phase"; "totalBytes" ];
          members =
            [
              ( "phase",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"started\"" ];
                } );
              ( "totalBytes",
                { any with kinds = Some [ Integer ]; minimum = Some "0" } );
            ];
          closed = Some [ "phase"; "totalBytes" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "phase"; "bytesUploaded"; "totalBytes" ];
          members =
            [
              ( "bytesUploaded",
                { any with kinds = Some [ Integer ]; minimum = Some "0" } );
              ( "phase",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"progress\"" ];
                } );
              ( "totalBytes",
                { any with kinds = Some [ Integer ]; minimum = Some "0" } );
            ];
          closed = Some [ "bytesUploaded"; "phase"; "totalBytes" ];
        };
        {
          any with
          kinds = Some [ Object ];
          required = [ "phase"; "resourceId" ];
          members =
            [
              ( "phase",
                {
                  any with
                  kinds = Some [ String ];
                  enum = Some [ `Stringlit "\"finished\"" ];
                } );
              ("resourceId", { any with reference = Some "ResourceId" });
            ];
          closed = Some [ "phase"; "resourceId" ];
        };
      ];
    discriminator =
      Some ("phase", [ ("started", 0); ("progress", 1); ("finished", 2) ]);
  }

let shape_445 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [ "requestId"; "verificationUri"; "userCode"; "expiresInSeconds" ];
    members =
      [
        ( "expiresInSeconds",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ("requestId", { any with reference = Some "RequestId" });
        ("userCode", { any with kinds = Some [ String ] });
        ("verificationUri", { any with kinds = Some [ String ] });
        ("verificationUriComplete", { any with kinds = Some [ String ] });
      ];
    closed =
      Some
        [
          "expiresInSeconds";
          "requestId";
          "userCode";
          "verificationUri";
          "verificationUriComplete";
        ];
  }

let shape_446 () =
  {
    any with
    kinds = Some [ String ];
    pattern =
      Some
        [
          Step ([ (100, 100) ], 1, Some 1);
          Step ([ (105, 105) ], 1, Some 1);
          Step ([ (100, 100) ], 1, Some 1);
          Step ([ (58, 58) ], 1, Some 1);
          Step
            ( [
                (0, 8);
                (14, 31);
                (33, 159);
                (161, 5759);
                (5761, 8191);
                (8203, 8231);
                (8234, 8238);
                (8240, 8286);
                (8288, 12287);
                (12289, 65278);
                (65280, 1114111);
              ],
              1,
              None );
        ];
  }

let shape_447 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "did"; "email"; "name"; "image"; "domain" ];
    members =
      [
        ("did", { any with reference = Some "UserId" });
        ("domain", { any with kinds = Some [ String ] });
        ("email", { any with kinds = Some [ String; Null ] });
        ("image", { any with kinds = Some [ String; Null ] });
        ("name", { any with kinds = Some [ String; Null ] });
      ];
  }

let shape_448 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "kind"; "metadata"; "spec" ];
    members =
      [
        ("apiVersion", { any with reference = Some "StackApiVersion" });
        ( "kind",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"VectorStore\"" ];
          } );
        ("metadata", { any with reference = Some "Metadata" });
        ( "spec",
          {
            any with
            kinds = Some [ Object ];
            required = [ "type"; "image"; "resources"; "port" ];
            members =
              [
                ("image", { any with reference = Some "Image" });
                ( "port",
                  {
                    any with
                    kinds = Some [ Integer ];
                    minimum = Some "1";
                    maximum = Some "65535";
                  } );
                ("resources", { any with reference = Some "Resources" });
                ( "type",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
              ];
            closed = Some [ "image"; "port"; "resources"; "type" ];
          } );
      ];
    closed = Some [ "apiVersion"; "kind"; "metadata"; "spec" ];
  }

let shape_449 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "QdrantVectorsConfig" };
        { any with reference = Some "MemoryVectorsConfig" };
      ];
    discriminator = Some ("type", [ ("qdrant", 0); ("memory", 1) ]);
  }

let shape_450 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "type"; "model"; "endpoint"; "apiKeyEnv" ];
    members =
      [
        ("apiKeyEnv", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("endpoint", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("model", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "type",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"voyage\"" ];
          } );
      ];
    closed = Some [ "apiKeyEnv"; "endpoint"; "model"; "type" ];
  }

let shape_451 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "sequenceNumber" ];
    members =
      [
        ("resourceId", { any with reference = Some "ResourceId" });
        ("sequenceNumber", { any with kinds = Some [ Integer ] });
      ];
  }

let shape_452 () =
  {
    any with
    kinds = Some [ Object ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("resourceId", { any with reference = Some "ResourceId" });
      ];
  }

let shape_453 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [
        "kb";
        "gatewayUrl";
        "identity";
        "archivist";
        "graph";
        "cursorsPath";
        "port";
        "logLevel";
        "logFormat";
      ];
    members =
      [
        ("archivist", { any with reference = Some "ServiceAddress" });
        ("cursorsPath", { any with reference = Some "CursorsPath" });
        ("gatewayUrl", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("graph", { any with reference = Some "GraphConfig" });
        ("identity", { any with reference = Some "ServiceIdentity" });
        ("kb", { any with reference = Some "KbIdentity" });
        ("logFormat", { any with reference = Some "LogFormat" });
        ("logLevel", { any with reference = Some "LogLevel" });
        ( "port",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "65535";
          } );
      ];
    closed =
      Some
        [
          "archivist";
          "cursorsPath";
          "gatewayUrl";
          "graph";
          "identity";
          "kb";
          "logFormat";
          "logLevel";
          "port";
        ];
  }

let shape_454 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "status"; "kb"; "following"; "reconcile" ];
    members =
      [
        ("following", { any with reference = Some "FollowerFollowing" });
        ("kb", { any with reference = Some "KbDid" });
        ( "reconcile",
          {
            any with
            kinds = Some [ Object ];
            required = [ "phase" ];
            members =
              [
                ("error", { any with kinds = Some [ String ] });
                ( "phase",
                  {
                    any with
                    kinds = Some [ String ];
                    enum =
                      Some
                        [
                          `Stringlit "\"pending\"";
                          `Stringlit "\"running\"";
                          `Stringlit "\"done\"";
                          `Stringlit "\"failed\"";
                        ];
                  } );
                ( "summary",
                  {
                    any with
                    kinds = Some [ Object ];
                    required =
                      [
                        "resourcesChecked";
                        "divergent";
                        "healed";
                        "healFailures";
                        "orphaned";
                      ];
                    members =
                      [
                        ( "divergent",
                          {
                            any with
                            kinds = Some [ Integer ];
                            minimum = Some "0";
                          } );
                        ( "healFailures",
                          {
                            any with
                            kinds = Some [ Integer ];
                            minimum = Some "0";
                          } );
                        ( "healed",
                          {
                            any with
                            kinds = Some [ Integer ];
                            minimum = Some "0";
                          } );
                        ( "orphaned",
                          {
                            any with
                            kinds = Some [ Integer ];
                            minimum = Some "0";
                          } );
                        ( "resourcesChecked",
                          {
                            any with
                            kinds = Some [ Integer ];
                            minimum = Some "0";
                          } );
                      ];
                    closed =
                      Some
                        [
                          "divergent";
                          "healFailures";
                          "healed";
                          "orphaned";
                          "resourcesChecked";
                        ];
                  } );
              ];
            closed = Some [ "error"; "phase"; "summary" ];
          } );
        ( "status",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"ok\"" ];
          } );
      ];
    closed = Some [ "following"; "kb"; "reconcile"; "status" ];
  }

let shape_455 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [ "knowledgeBases"; "modelCatalogue"; "port"; "logLevel"; "logFormat" ];
    members =
      [
        ( "knowledgeBases",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            items =
              Some { any with reference = Some "WorkerKnowledgeBaseConfig" };
          } );
        ("logFormat", { any with reference = Some "LogFormat" });
        ("logLevel", { any with reference = Some "LogLevel" });
        ( "modelCatalogue",
          { any with kinds = Some [ String ]; min_length = Some 1 } );
        ( "port",
          {
            any with
            kinds = Some [ Integer ];
            minimum = Some "1";
            maximum = Some "65535";
          } );
      ];
    closed =
      Some
        [ "knowledgeBases"; "logFormat"; "logLevel"; "modelCatalogue"; "port" ];
  }

let shape_456 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "engine"; "jobs"; "baseUrl" ];
    members =
      [
        ("apiKeyEnv", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("baseUrl", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("engine", { any with reference = Some "Engine" });
        ( "jobs",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            items = Some { any with reference = Some "JobFilter" };
          } );
      ];
    closed = Some [ "apiKeyEnv"; "baseUrl"; "engine"; "jobs" ];
  }

let shape_457 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [
        "engine";
        "jobs";
        "lastQueuedEventAt";
        "lastClaimAt";
        "lastFinishedAt";
        "lastActivityAt";
        "activeJob";
        "jobsCompleted";
      ];
    members =
      [
        ( "activeJob",
          {
            any with
            kinds = Some [ Object; Null ];
            required = [ "jobId"; "type"; "since" ];
            members =
              [
                ("jobId", { any with reference = Some "JobId" });
                ("since", { any with kinds = Some [ String ] });
                ("type", { any with reference = Some "JobType" });
              ];
            closed = Some [ "jobId"; "since"; "type" ];
          } );
        ("engine", { any with reference = Some "Engine" });
        ( "jobs",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            items = Some { any with reference = Some "JobFilter" };
          } );
        ( "jobsCompleted",
          { any with kinds = Some [ Integer ]; minimum = Some "0" } );
        ("lastActivityAt", { any with kinds = Some [ String; Null ] });
        ("lastClaimAt", { any with kinds = Some [ String; Null ] });
        ("lastFinishedAt", { any with kinds = Some [ String; Null ] });
        ("lastQueuedEventAt", { any with kinds = Some [ String; Null ] });
      ];
    closed =
      Some
        [
          "activeJob";
          "engine";
          "jobs";
          "jobsCompleted";
          "lastActivityAt";
          "lastClaimAt";
          "lastFinishedAt";
          "lastQueuedEventAt";
        ];
  }

let shape_458 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "status"; "knowledgeBases" ];
    members =
      [
        ( "knowledgeBases",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            items =
              Some { any with reference = Some "WorkerKnowledgeBaseHealth" };
          } );
        ( "status",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"ok\"" ];
          } );
      ];
    closed = Some [ "knowledgeBases"; "status" ];
  }

let shape_459 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "domain"; "gatewayUrl"; "identity"; "engines" ];
    members =
      [
        ("domain", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "engines",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            items = Some { any with reference = Some "WorkerEngineConfig" };
          } );
        ("gatewayUrl", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "identity",
          {
            any with
            kinds = Some [ Object ];
            required = [ "issuer"; "clientId" ];
            members =
              [
                ( "clientId",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
                ( "issuer",
                  { any with kinds = Some [ String ]; min_length = Some 1 } );
              ];
            closed = Some [ "clientId"; "issuer" ];
          } );
      ];
    closed = Some [ "domain"; "engines"; "gatewayUrl"; "identity" ];
  }

let shape_460 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "domain"; "state" ];
    members =
      [
        ("did", { any with kinds = Some [ String ]; min_length = Some 1 });
        ("domain", { any with kinds = Some [ String ]; min_length = Some 1 });
        ( "engines",
          {
            any with
            kinds = Some [ Array ];
            min_items = Some 1;
            items = Some { any with reference = Some "WorkerEngineHealth" };
          } );
        ( "state",
          {
            any with
            kinds = Some [ String ];
            enum =
              Some
                [
                  `Stringlit "\"starting\"";
                  `Stringlit "\"working\"";
                  `Stringlit "\"refused\"";
                ];
          } );
      ];
    closed = Some [ "did"; "domain"; "engines"; "state" ];
  }

let shape_461 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "apiVersion"; "kind"; "metadata"; "spec" ];
    members =
      [
        ("apiVersion", { any with reference = Some "StackApiVersion" });
        ( "kind",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"WorkerPool\"" ];
          } );
        ("metadata", { any with reference = Some "Metadata" });
        ( "spec",
          {
            any with
            kinds = Some [ Object ];
            required = [ "logLevel"; "worker" ];
            members =
              [
                ("logLevel", { any with reference = Some "LogLevel" });
                ( "worker",
                  {
                    any with
                    kinds = Some [ Object ];
                    required = [ "image"; "resources" ];
                    members =
                      [
                        ("image", { any with reference = Some "Image" });
                        ("resources", { any with reference = Some "Resources" });
                      ];
                    closed = Some [ "image"; "resources" ];
                  } );
              ];
            closed = Some [ "logLevel"; "worker" ];
          } );
      ];
    closed = Some [ "apiVersion"; "kind"; "metadata"; "spec" ];
  }

let shape_462 () =
  {
    any with
    kinds = Some [ Object ];
    members =
      [
        ( "ledger",
          {
            any with
            kinds = Some [ Object ];
            required = [ "claims"; "capacity" ];
            members =
              [
                ( "capacity",
                  { any with kinds = Some [ Integer ]; minimum = Some "1" } );
                ( "claims",
                  { any with kinds = Some [ Integer ]; minimum = Some "0" } );
              ];
            closed = Some [ "capacity"; "claims" ];
          } );
        ( "queue",
          {
            any with
            kinds = Some [ Object ];
            required = [ "pending"; "running" ];
            members =
              [
                ( "completed",
                  { any with kinds = Some [ Integer ]; minimum = Some "0" } );
                ( "failed",
                  { any with kinds = Some [ Integer ]; minimum = Some "0" } );
                ( "pending",
                  { any with kinds = Some [ Integer ]; minimum = Some "0" } );
                ( "running",
                  { any with kinds = Some [ Integer ]; minimum = Some "0" } );
              ];
            closed = Some [ "completed"; "failed"; "pending"; "running" ];
          } );
      ];
    closed = Some [ "ledger"; "queue" ];
  }

let shape_463 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [ "token"; "name"; "storageUri"; "contentChecksum"; "byteSize"; "format" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("archiveOriginal", { any with kinds = Some [ Boolean ] });
        ("byteSize", { any with kinds = Some [ Integer ] });
        ("contentChecksum", { any with kinds = Some [ String ] });
        ("format", { any with reference = Some "ContentFormat" });
        ("name", { any with kinds = Some [ String ] });
        ("storageUri", { any with kinds = Some [ String ] });
        ("token", { any with kinds = Some [ String ] });
      ];
  }

let shape_464 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members = [ ("response", { any with reference = Some "YieldedResource" }) ];
  }

let shape_465 () =
  {
    any with
    kinds = Some [ Object ];
    required =
      [
        "name";
        "storageUri";
        "contentChecksum";
        "byteSize";
        "format";
        "parentResourceId";
      ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("byteSize", { any with kinds = Some [ Integer ] });
        ("contentChecksum", { any with kinds = Some [ String ] });
        ( "entityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("format", { any with reference = Some "ContentFormat" });
        ("language", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
        ("parentResourceId", { any with reference = Some "ResourceId" });
        ("storageUri", { any with kinds = Some [ String ] });
      ];
  }

let shape_466 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members = [ ("response", { any with reference = Some "YieldedResource" }) ];
  }

let shape_467 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "token" ];
    members = [ ("token", { any with kinds = Some [ String ] }) ];
  }

let shape_468 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId" ];
    members = [ ("resourceId", { any with reference = Some "ResourceId" }) ];
  }

let shape_469 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "name"; "storageUri"; "contentChecksum"; "byteSize"; "format" ];
    members =
      [
        ( "_roles",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("_userId", { any with reference = Some "UserId" });
        ("byteSize", { any with kinds = Some [ Integer ] });
        ("contentChecksum", { any with kinds = Some [ String ] });
        ( "entityTypes",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("format", { any with reference = Some "ContentFormat" });
        ( "generatedFrom",
          {
            any with
            kinds = Some [ Object ];
            members =
              [
                ("annotationId", { any with reference = Some "AnnotationId" });
                ("resourceId", { any with reference = Some "ResourceId" });
              ];
          } );
        ("generationPrompt", { any with kinds = Some [ String ] });
        ("generator", { any with reference = Some "OneOrMoreAgents" });
        ("isDraft", { any with kinds = Some [ Boolean ] });
        ("jobId", { any with reference = Some "JobId" });
        ("language", { any with kinds = Some [ String ] });
        ("name", { any with kinds = Some [ String ] });
        ("storageUri", { any with kinds = Some [ String ] });
      ];
  }

let shape_470 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members = [ ("response", { any with reference = Some "YieldedResource" }) ];
  }

let shape_471 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "jobId"; "jobType" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("annotationId", { any with reference = Some "AnnotationId" });
        ("attempt", { any with kinds = Some [ Integer ] });
        ("durability", { any with reference = Some "DurabilityEvidence" });
        ("jobId", { any with reference = Some "JobId" });
        ( "jobType",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"yield\"" ];
          } );
        ("resourceId", { any with reference = Some "ResourceId" });
        ("result", { any with reference = Some "YieldJobResult" });
      ];
  }

let shape_472 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobType"; "params" ];
    members =
      [
        ( "_roles",
          {
            any with
            kinds = Some [ Array ];
            items = Some { any with kinds = Some [ String ] };
          } );
        ("_userId", { any with reference = Some "UserId" });
        ( "jobType",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"yield\"" ];
          } );
        ("params", { any with reference = Some "GenerationJobParams" });
      ];
    closed = Some [ "_roles"; "_userId"; "jobType"; "params" ];
  }

let shape_473 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "resourceName"; "truncated" ];
    members =
      [
        ("resourceId", { any with reference = Some "ResourceId" });
        ("resourceName", { any with kinds = Some [ String ] });
        ("truncated", { any with kinds = Some [ Boolean ] });
      ];
    closed = Some [ "resourceId"; "resourceName"; "truncated" ];
  }

let shape_474 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobType" ];
    members =
      [
        ( "jobType",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"yield\"" ];
          } );
      ];
    closed = Some [ "jobType" ];
  }

let shape_475 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "jobId"; "jobType"; "resourceId"; "userId"; "params" ];
    members =
      [
        ("jobId", { any with reference = Some "JobId" });
        ( "jobType",
          {
            any with
            kinds = Some [ String ];
            enum = Some [ `Stringlit "\"yield\"" ];
          } );
        ("params", { any with reference = Some "GenerationJobRequest" });
        ("resourceId", { any with reference = Some "ResourceId" });
        ("userId", { any with reference = Some "UserId" });
      ];
  }

let shape_476 () =
  {
    any with
    kinds = Some [ Object ];
    variants =
      [
        { any with reference = Some "YieldJobDone" };
        { any with reference = Some "JobDeclined" };
      ];
  }

let shape_477 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId"; "storageUri"; "contentChecksum"; "byteSize" ];
    members =
      [
        ("_userId", { any with reference = Some "UserId" });
        ("byteSize", { any with kinds = Some [ Integer ] });
        ("contentChecksum", { any with kinds = Some [ String ] });
        ("resourceId", { any with reference = Some "ResourceId" });
        ("storageUri", { any with kinds = Some [ String ] });
      ];
  }

let shape_478 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "response" ];
    members = [ ("response", { any with reference = Some "YieldedResource" }) ];
  }

let shape_479 () =
  {
    any with
    kinds = Some [ Object ];
    required = [ "resourceId" ];
    members = [ ("resourceId", { any with reference = Some "ResourceId" }) ];
  }

let all =
  [
    ("AboutParams", shape_0);
    ("AboutResult", shape_1);
    ("Agent", shape_2);
    ("AgentOrganization", shape_3);
    ("AgentPerson", shape_4);
    ("AgentSoftware", shape_5);
    ("AnchorMethod", shape_6);
    ("AnchorRect", shape_7);
    ("AnchoredText", shape_8);
    ("AnchoredTextAbsent", shape_9);
    ("AnchoredTextAnswer", shape_10);
    ("AnchoredTextDeclinedEntry", shape_11);
    ("AnchoredTextEntries", shape_12);
    ("AnchoredTextEntry", shape_13);
    ("AnchoredTextExtractedEntry", shape_14);
    ("AnchoredTextStamp", shape_15);
    ("AnchoredTextWrite", shape_16);
    ("Annotation", shape_17);
    ("AnnotationAddedPayload", shape_18);
    ("AnnotationBodies", shape_19);
    ("AnnotationBody", shape_20);
    ("AnnotationBodyUpdatedPayload", shape_21);
    ("AnnotationId", shape_22);
    ("AnnotationRemovedPayload", shape_23);
    ("AnnotationSelector", shape_24);
    ("AnnotationTarget", shape_25);
    ("ApiVersion", shape_26);
    ("ArchivistConfig", shape_27);
    ("ArchivistEngines", shape_28);
    ("ArchivistEventsResponse", shape_29);
    ("ArchivistHealth", shape_30);
    ("ArchivistStream", shape_31);
    ("ArchivistStreamsResponse", shape_32);
    ("AssessingJobParams", shape_33);
    ("AttributedEvent", shape_34);
    ("AuthLoginParams", shape_35);
    ("AuthLoginResult", shape_36);
    ("AuthLogoutParams", shape_37);
    ("AuthLogoutResult", shape_38);
    ("BeckonFocusEvent", shape_39);
    ("BeckonHoverEvent", shape_40);
    ("BeckonSparkleEvent", shape_41);
    ("BeginAuthorizationOptions", shape_42);
    ("BindBodyOperation", shape_43);
    ("BindBodyUpdated", shape_44);
    ("BindInitiateCommand", shape_45);
    ("BindUpdateBodyCommand", shape_46);
    ("BodyOperation", shape_47);
    ("BodyOperationAdd", shape_48);
    ("BodyOperationRemove", shape_49);
    ("BodyOperationReplace", shape_50);
    ("BodyPurpose", shape_51);
    ("BrowseAnnotationHistoryRequest", shape_52);
    ("BrowseAnnotationHistoryResult", shape_53);
    ("BrowseAnnotationRequest", shape_54);
    ("BrowseAnnotationResult", shape_55);
    ("BrowseClickEvent", shape_56);
    ("BrowseDirectoryFailed", shape_57);
    ("BrowseDirectoryRequest", shape_58);
    ("BrowseDirectoryResult", shape_59);
    ("BrowseDirectoryResultResponse", shape_60);
    ("BrowseEnginesRequest", shape_61);
    ("BrowseEnginesResult", shape_62);
    ("BrowseEntityTypeClickedEvent", shape_63);
    ("BrowseEntityTypesRequest", shape_64);
    ("BrowseEntityTypesResult", shape_65);
    ("BrowseEventsRequest", shape_66);
    ("BrowseEventsResult", shape_67);
    ("BrowseExternalNavigateEvent", shape_68);
    ("BrowseFilesResponse", shape_69);
    ("BrowseKbRequest", shape_70);
    ("BrowseKbResult", shape_71);
    ("BrowseLinkClickedEvent", shape_72);
    ("BrowsePanelOpenEvent", shape_73);
    ("BrowsePanelToggleEvent", shape_74);
    ("BrowseProfilesRequest", shape_75);
    ("BrowseProfilesResult", shape_76);
    ("BrowseResourceCloseEvent", shape_77);
    ("BrowseResourceOpenEvent", shape_78);
    ("BrowseResourceReorderEvent", shape_79);
    ("BrowseResourceRequest", shape_80);
    ("BrowseResourceResult", shape_81);
    ("BrowseResourceViewedEvent", shape_82);
    ("BrowseResourcesRequest", shape_83);
    ("BrowseResourcesResult", shape_84);
    ("BrowseRouterPushEvent", shape_85);
    ("BrowseTagSchemasRequest", shape_86);
    ("BrowseTagSchemasResult", shape_87);
    ("Browser", shape_88);
    ("BusEmitAccepted", shape_89);
    ("BusEmitRequest", shape_90);
    ("BusEventMessage", shape_91);
    ("BusFrame", shape_92);
    ("BusPingMessage", shape_93);
    ("BusResumeGap", shape_94);
    ("BusStreamMessage", shape_95);
    ("BusSubscribeRequest", shape_96);
    ("Cancelled", shape_97);
    ("ClaimOptions", shape_98);
    ("ClientSecretForm", shape_99);
    ("CloneResourceWithTokenResponse", shape_100);
    ("CommandError", shape_101);
    ("CommentingJobParams", shape_102);
    ("ConformanceBusFetch", shape_103);
    ("ConformanceCase", shape_104);
    ("ConformanceDriverLine", shape_105);
    ("ConformanceFailure", shape_106);
    ("ConformanceHttpFetch", shape_107);
    ("ConformanceImplementations", shape_108);
    ("ConformanceStep", shape_109);
    ("ConnectionIdentity", shape_110);
    ("ContentFormat", shape_111);
    ("ContextualSummaryResponse", shape_112);
    ("CreateAnnotationRequest", shape_113);
    ("CreateFromTokenOptions", shape_114);
    ("CreateResourceResponse", shape_115);
    ("CursorsPath", shape_116);
    ("DeviceCode", shape_117);
    ("DirEntry", shape_118);
    ("DirectoryEntry", shape_119);
    ("DiscoveredKB", shape_120);
    ("DiscoveryAbsentReason", shape_121);
    ("DiscoveryDocument", shape_122);
    ("DispatcherConfig", shape_123);
    ("DispatcherHealth", shape_124);
    ("DurabilityEvidence", shape_125);
    ("EmbeddingConfig", shape_126);
    ("Engine", shape_127);
    ("EngineEntry", shape_128);
    ("EngineLimits", shape_129);
    ("EnrichedResourceEvent", shape_130);
    ("EntityTagChangedPayload", shape_131);
    ("EntityTypeAddedPayload", shape_132);
    ("EntityTypesProjection", shape_133);
    ("EphemeralEventId", shape_134);
    ("ErrorData", shape_135);
    ("ErrorResponse", shape_136);
    ("EventMetadata", shape_137);
    ("Expected", shape_138);
    ("ExtractedText", shape_139);
    ("ExtractionDeclined", shape_140);
    ("ExtractionDeclinedReason", shape_141);
    ("ExtractionMethod", shape_142);
    ("ExtractionOutcome", shape_143);
    ("FailureClass", shape_144);
    ("FieldFault", shape_145);
    ("FileEntry", shape_146);
    ("FollowerFollowing", shape_147);
    ("FragmentSelector", shape_148);
    ("FrameAddEntityTypeCommand", shape_149);
    ("FrameAddTagSchemaCommand", shape_150);
    ("FrameRefusalReason", shape_151);
    ("GatewayConfig", shape_152);
    ("GatherAnnotationComplete", shape_153);
    ("GatherAnnotationOptions", shape_154);
    ("GatherAnnotationRequest", shape_155);
    ("GatherFailed", shape_156);
    ("GatherReferencedByRequest", shape_157);
    ("GatherReferencedByResult", shape_158);
    ("GatherResourceComplete", shape_159);
    ("GatherResourceFailed", shape_160);
    ("GatherResourceOptions", shape_161);
    ("GatherResourceRequest", shape_162);
    ("GatherResourceRequestOptions", shape_163);
    ("GatherSummaryRequest", shape_164);
    ("GatheredContext", shape_165);
    ("GenerationJobParams", shape_166);
    ("GenerationJobRequest", shape_167);
    ("GetAnnotationHistoryResponse", shape_168);
    ("GetAnnotationResponse", shape_169);
    ("GetAnnotationsResponse", shape_170);
    ("GetEntityTypesResponse", shape_171);
    ("GetEventsResponse", shape_172);
    ("GetReferencedByResponse", shape_173);
    ("GetReferencedByResponseReferencedByItem", shape_174);
    ("GetResourceByTokenResponse", shape_175);
    ("GetResourceResponse", shape_176);
    ("GetTagSchemasResponse", shape_177);
    ("GraphAnnotationNode", shape_178);
    ("GraphConfig", shape_179);
    ("GraphResourceNode", shape_180);
    ("HealthResponse", shape_181);
    ("HighlightingJobParams", shape_182);
    ("HostPort", shape_183);
    ("HttpEndpoint", shape_184);
    ("HttpStatus", shape_185);
    ("IdentityUser", shape_186);
    ("IdentityUseraddParams", shape_187);
    ("IdentityUseraddResult", shape_188);
    ("IdentityUsersListParams", shape_189);
    ("IdentityUsersListResult", shape_190);
    ("Image", shape_191);
    ("Inference", shape_192);
    ("InferenceLimits", shape_193);
    ("InferenceLimitsRequest", shape_194);
    ("InferenceLimitsResult", shape_195);
    ("IssuedTokens", shape_196);
    ("Issuer", shape_197);
    ("JanusGraphConfig", shape_198);
    ("Job", shape_199);
    ("JobAssignCommand", shape_200);
    ("JobAssignedPayload", shape_201);
    ("JobCancelCommand", shape_202);
    ("JobCancelRequest", shape_203);
    ("JobCancelResult", shape_204);
    ("JobCancelled", shape_205);
    ("JobCheckpointCommand", shape_206);
    ("JobClaimCommand", shape_207);
    ("JobClaimedResult", shape_208);
    ("JobComplete", shape_209);
    ("JobCompleteCommand", shape_210);
    ("JobCompletedPayload", shape_211);
    ("JobCreateCommand", shape_212);
    ("JobCreatedResult", shape_213);
    ("JobCreatedResultResponse", shape_214);
    ("JobDeclined", shape_215);
    ("JobFailCommand", shape_216);
    ("JobFailed", shape_217);
    ("JobFailedPayload", shape_218);
    ("JobFilter", shape_219);
    ("JobId", shape_220);
    ("JobMetadata", shape_221);
    ("JobParams", shape_222);
    ("JobPending", shape_223);
    ("JobPollOptions", shape_224);
    ("JobProgress", shape_225);
    ("JobProgressAnalyzing", shape_226);
    ("JobProgressAnalyzingTags", shape_227);
    ("JobProgressCompleteCreated", shape_228);
    ("JobProgressCompleteGenerated", shape_229);
    ("JobProgressCreatingAnnotations", shape_230);
    ("JobProgressCreatingResource", shape_231);
    ("JobProgressCreatingTagAnnotations", shape_232);
    ("JobProgressDetectingEntities", shape_233);
    ("JobProgressGeneratingResource", shape_234);
    ("JobProgressLoading", shape_235);
    ("JobProgressMessage", shape_236);
    ("JobQueuedEvent", shape_237);
    ("JobRecord", shape_238);
    ("JobReportProgressCommand", shape_239);
    ("JobResult", shape_240);
    ("JobRunning", shape_241);
    ("JobStartCommand", shape_242);
    ("JobStartedPayload", shape_243);
    ("JobStatusRequest", shape_244);
    ("JobStatusResponse", shape_245);
    ("JobStatusResult", shape_246);
    ("JobStoredProgress", shape_247);
    ("JobStoredResult", shape_248);
    ("JobType", shape_249);
    ("KbDescription", shape_250);
    ("KbDid", shape_251);
    ("KbEndpoint", shape_252);
    ("KbIdentity", shape_253);
    ("KbIdentityConflict", shape_254);
    ("KbRead", shape_255);
    ("KbReadKind", shape_256);
    ("KbReadVerdict", shape_257);
    ("KbSessionStatus", shape_258);
    ("KbTarget", shape_259);
    ("KnowledgeBase", shape_260);
    ("KnowledgeBaseStatus", shape_261);
    ("KnowledgeGraph", shape_262);
    ("KnowledgeIndex", shape_263);
    ("LastEventIds", shape_264);
    ("LibrarianConfig", shape_265);
    ("LibrarianEngineConfig", shape_266);
    ("LibrarianHealth", shape_267);
    ("LibrarianPromptScore", shape_268);
    ("LimitRefusal", shape_269);
    ("LinkingJobParams", shape_270);
    ("ListResourcesResponse", shape_271);
    ("LocalEndpoint", shape_272);
    ("LocalTarget", shape_273);
    ("LogFormat", shape_274);
    ("LogLevel", shape_275);
    ("LogRecord", shape_276);
    ("LogsFollowParams", shape_277);
    ("LogsFollowResult", shape_278);
    ("MarkArchiveCommand", shape_279);
    ("MarkCommitCommand", shape_280);
    ("MarkCommitOk", shape_281);
    ("MarkCreateOk", shape_282);
    ("MarkCreateOkResponse", shape_283);
    ("MarkCreateRequest", shape_284);
    ("MarkDelegateTimeoutEvent", shape_285);
    ("MarkDeleteCommand", shape_286);
    ("MarkDeleteOk", shape_287);
    ("MarkJobCompleteCommand", shape_288);
    ("MarkJobCreateCommand", shape_289);
    ("MarkJobDone", shape_290);
    ("MarkJobFilter", shape_291);
    ("MarkJobParams", shape_292);
    ("MarkJobQueuedEvent", shape_293);
    ("MarkJobResult", shape_294);
    ("MarkRequestedEvent", shape_295);
    ("MarkSubmitEvent", shape_296);
    ("MarkUnarchiveCommand", shape_297);
    ("MarkUpdateBodyCommand", shape_298);
    ("MarkUpdateEntityTypesCommand", shape_299);
    ("MatchQuality", shape_300);
    ("MatchResourcesRequest", shape_301);
    ("MatchResourcesResponse", shape_302);
    ("MatchResourcesResult", shape_303);
    ("MatchSearchFailed", shape_304);
    ("MatchSearchOptions", shape_305);
    ("MatchSearchRequest", shape_306);
    ("MatchSearchResult", shape_307);
    ("MediaTokenRequest", shape_308);
    ("MediaTokenResponse", shape_309);
    ("MemoryGraphConfig", shape_310);
    ("MemoryVectorsConfig", shape_311);
    ("Metadata", shape_312);
    ("Motivation", shape_313);
    ("Neo4jGraphConfig", shape_314);
    ("NeptuneGraphConfig", shape_315);
    ("NewKnowledgeBase", shape_316);
    ("OcrConfidence", shape_317);
    ("OllamaEmbeddingConfig", shape_318);
    ("OneOrMoreAgents", shape_319);
    ("OneOrMoreStrings", shape_320);
    ("OneOrMoreUris", shape_321);
    ("OpenResource", shape_322);
    ("OutputStream", shape_323);
    ("PdfClass", shape_324);
    ("PdfCoordinate", shape_325);
    ("PdfTextItem", shape_326);
    ("PendingAnnotation", shape_327);
    ("PendingAuthorization", shape_328);
    ("PermissionDenied", shape_329);
    ("PersistedEventId", shape_330);
    ("PrincipalProfileCommand", shape_331);
    ("PrincipalProfiledPayload", shape_332);
    ("Profile", shape_333);
    ("ProfilesProjection", shape_334);
    ("Progress", shape_335);
    ("ProjectConfig", shape_336);
    ("ProtectedResourceMetadata", shape_337);
    ("Provider", shape_338);
    ("QdrantVectorsConfig", shape_339);
    ("QuotedText", shape_340);
    ("ReconciledSpan", shape_341);
    ("ReplyEventId", shape_342);
    ("Representation", shape_343);
    ("RepresentationAddedPayload", shape_344);
    ("RepresentationNotFound", shape_345);
    ("RepresentationRemovedPayload", shape_346);
    ("RequestId", shape_347);
    ("ResourceAnnotations", shape_348);
    ("ResourceArchivedPayload", shape_349);
    ("ResourceClonedPayload", shape_350);
    ("ResourceCreatedPayload", shape_351);
    ("ResourceDescriptor", shape_352);
    ("ResourceErrorEvent", shape_353);
    ("ResourceId", shape_354);
    ("ResourceMovedPayload", shape_355);
    ("ResourceSearchFilters", shape_356);
    ("ResourceUnarchivedPayload", shape_357);
    ("ResourceUpdatedPayload", shape_358);
    ("ResourceUpload", shape_359);
    ("ResourceView", shape_360);
    ("Resources", shape_361);
    ("Root", shape_362);
    ("RootsForgetParams", shape_363);
    ("RootsForgetResult", shape_364);
    ("RootsInitParams", shape_365);
    ("RootsInitResult", shape_366);
    ("RootsListParams", shape_367);
    ("RootsListResult", shape_368);
    ("RunInstance", shape_369);
    ("RunService", shape_370);
    ("Runner", shape_371);
    ("Runtime", shape_372);
    ("RuntimeState", shape_373);
    ("ScoredResource", shape_374);
    ("SecretRef", shape_375);
    ("Selector", shape_376);
    ("SemanticMatch", shape_377);
    ("ServiceAddress", shape_378);
    ("ServiceGroup", shape_379);
    ("ServiceHostParams", shape_380);
    ("ServiceHostResult", shape_381);
    ("ServiceIdentity", shape_382);
    ("ServiceOutput", shape_383);
    ("ServiceRunParams", shape_384);
    ("ServiceRunResult", shape_385);
    ("ServiceSignalParams", shape_386);
    ("ServiceSignalResult", shape_387);
    ("ServiceStarted", shape_388);
    ("ServiceStatus", shape_389);
    ("Session", shape_390);
    ("SessionEndReason", shape_391);
    ("SessionEnded", shape_392);
    ("SessionJoinedEvent", shape_393);
    ("SessionLeftEvent", shape_394);
    ("Setting", shape_395);
    ("SettingLine", shape_396);
    ("SettingsGetParams", shape_397);
    ("SettingsHoverDelayChangedEvent", shape_398);
    ("SettingsListParams", shape_399);
    ("SettingsListResult", shape_400);
    ("SettingsLocaleChangedEvent", shape_401);
    ("SettingsPathParams", shape_402);
    ("SettingsPathResult", shape_403);
    ("SettingsSetParams", shape_404);
    ("SettingsThemeChangedEvent", shape_405);
    ("SettingsUnsetParams", shape_406);
    ("SignInOutcome", shape_407);
    ("SignedIn", shape_408);
    ("SmeltRebuildAnchorsCommand", shape_409);
    ("SmeltSettled", shape_410);
    ("SmelterChunking", shape_411);
    ("SmelterConfig", shape_412);
    ("SmelterHealth", shape_413);
    ("SmelterReconcileSummary", shape_414);
    ("SpecificResource", shape_415);
    ("StackApiVersion", shape_416);
    ("StackKnowledgeBase", shape_417);
    ("StackStartParams", shape_418);
    ("StackStartResult", shape_419);
    ("StackStopParams", shape_420);
    ("StackStopResult", shape_421);
    ("StatusResponse", shape_422);
    ("StatusSnapshotParams", shape_423);
    ("StatusSnapshotResult", shape_424);
    ("StorageUriEntry", shape_425);
    ("StoredEventResponse", shape_426);
    ("StoredSession", shape_427);
    ("SupportedMediaType", shape_428);
    ("SvgSelector", shape_429);
    ("TabCheck", shape_430);
    ("TabVerdict", shape_431);
    ("TagCategory", shape_432);
    ("TagSchema", shape_433);
    ("TagSchemaAddedPayload", shape_434);
    ("TagSchemasProjection", shape_435);
    ("TaggingJobParams", shape_436);
    ("Target", shape_437);
    ("TextPositionSelector", shape_438);
    ("TextQuoteSelector", shape_439);
    ("TextSpan", shape_440);
    ("TextualBody", shape_441);
    ("UnitCursor", shape_442);
    ("UpdateAnnotationBodyRequest", shape_443);
    ("UploadProgress", shape_444);
    ("UserAction", shape_445);
    ("UserId", shape_446);
    ("UserResponse", shape_447);
    ("VectorStore", shape_448);
    ("VectorsConfig", shape_449);
    ("VoyageEmbeddingConfig", shape_450);
    ("WeaveApplied", shape_451);
    ("WeaveRebuildCommand", shape_452);
    ("WeaverConfig", shape_453);
    ("WeaverHealth", shape_454);
    ("WorkerConfig", shape_455);
    ("WorkerEngineConfig", shape_456);
    ("WorkerEngineHealth", shape_457);
    ("WorkerHealth", shape_458);
    ("WorkerKnowledgeBaseConfig", shape_459);
    ("WorkerKnowledgeBaseHealth", shape_460);
    ("WorkerPool", shape_461);
    ("WorkloadStatus", shape_462);
    ("YieldCloneCreateCommand", shape_463);
    ("YieldCloneCreated", shape_464);
    ("YieldClonePersistCommand", shape_465);
    ("YieldClonePersistOk", shape_466);
    ("YieldCloneResourceRequest", shape_467);
    ("YieldCloneTokenRequest", shape_468);
    ("YieldCreateCommand", shape_469);
    ("YieldCreateOk", shape_470);
    ("YieldJobCompleteCommand", shape_471);
    ("YieldJobCreateCommand", shape_472);
    ("YieldJobDone", shape_473);
    ("YieldJobFilter", shape_474);
    ("YieldJobQueuedEvent", shape_475);
    ("YieldJobResult", shape_476);
    ("YieldUpdateCommand", shape_477);
    ("YieldUpdateOk", shape_478);
    ("YieldedResource", shape_479);
  ]
