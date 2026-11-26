(* Generated from OpenAPI object components and discriminator mappings, and the records of Protocol's tables. Do not edit.
   Regenerate: make generate (codegen/lib/ocaml_sdk/records.ml) *)

open Record_reader

let unions =
  [
    ( "Resource_descriptor_context_item",
      [
        [
          {
            kind = Text_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "One_or_more_strings",
      [
        [
          {
            kind = Text_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = List_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Resource_descriptor_was_derived_from",
      [
        [
          {
            kind = Text_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = List_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "One_or_more_uris",
      [
        [
          {
            kind = Text_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = List_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Request_id",
      [
        [
          {
            kind = Text_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Integer_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Sdk_telemetry_telemetry_spans_item_attributes_item_values_item",
      [
        [
          {
            kind = Text_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Boolean_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Sdk_telemetry_telemetry_metrics_item_attributes_item_values_item",
      [
        [
          {
            kind = Text_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Boolean_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Selector",
      [
        [
          {
            kind = Object_kind;
            required = [ "type"; "start"; "end" ];
            allowed = None;
            fixed = [ ("type", [ Text_value "TextPositionSelector" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "type"; "exact" ];
            allowed = None;
            fixed = [ ("type", [ Text_value "TextQuoteSelector" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "type"; "value" ];
            allowed = None;
            fixed = [ ("type", [ Text_value "SvgSelector" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "type"; "value" ];
            allowed = None;
            fixed = [ ("type", [ Text_value "FragmentSelector" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Annotation_body",
      [
        [
          {
            kind = Object_kind;
            required = [ "type"; "value" ];
            allowed = None;
            fixed =
              [
                ("type", [ Text_value "TextualBody" ]);
                ( "purpose",
                  [
                    Text_value "assessing";
                    Text_value "bookmarking";
                    Text_value "classifying";
                    Text_value "commenting";
                    Text_value "describing";
                    Text_value "editing";
                    Text_value "highlighting";
                    Text_value "identifying";
                    Text_value "linking";
                    Text_value "moderating";
                    Text_value "questioning";
                    Text_value "replying";
                    Text_value "tagging";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "type"; "source" ];
            allowed = None;
            fixed =
              [
                ("type", [ Text_value "SpecificResource" ]);
                ( "purpose",
                  [
                    Text_value "assessing";
                    Text_value "bookmarking";
                    Text_value "classifying";
                    Text_value "commenting";
                    Text_value "describing";
                    Text_value "editing";
                    Text_value "highlighting";
                    Text_value "identifying";
                    Text_value "linking";
                    Text_value "moderating";
                    Text_value "questioning";
                    Text_value "replying";
                    Text_value "tagging";
                  ] );
              ];
            values = None;
          };
        ];
      ] );
    ( "Agent",
      [
        [
          {
            kind = Object_kind;
            required = [ "@type" ];
            allowed = None;
            fixed = [ ("@type", [ Text_value "Person" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "@type"; "name" ];
            allowed = None;
            fixed = [ ("@type", [ Text_value "Organization" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "@type" ];
            allowed = None;
            fixed = [ ("@type", [ Text_value "Software" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Resource_descriptor_context",
      [
        [
          {
            kind = Text_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = List_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Resource_descriptor_identifier",
      [
        [
          {
            kind = Text_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = List_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Directory_entry",
      [
        [
          {
            kind = Object_kind;
            required = [ "type"; "name"; "path"; "size"; "mtime"; "tracked" ];
            allowed =
              Some
                [
                  "type";
                  "name";
                  "path";
                  "size";
                  "mtime";
                  "tracked";
                  "resourceId";
                  "entityTypes";
                  "annotationCount";
                  "creator";
                ];
            fixed = [ ("type", [ Text_value "file" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "type"; "name"; "path"; "mtime" ];
            allowed = Some [ "type"; "name"; "path"; "mtime" ];
            fixed = [ ("type", [ Text_value "dir" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Job_progress_message",
      [
        [
          {
            kind = Object_kind;
            required = [ "code" ];
            allowed = None;
            fixed = [ ("code", [ Text_value "loading" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "code" ];
            allowed = None;
            fixed = [ ("code", [ Text_value "analyzing" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "code" ];
            allowed = None;
            fixed = [ ("code", [ Text_value "analyzing-tags" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "code" ];
            allowed = None;
            fixed = [ ("code", [ Text_value "generating-resource" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "code" ];
            allowed = None;
            fixed = [ ("code", [ Text_value "creating-resource" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "code"; "truncated" ];
            allowed = None;
            fixed = [ ("code", [ Text_value "complete-generated" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "code"; "entityType" ];
            allowed = None;
            fixed = [ ("code", [ Text_value "detecting-entities" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "code"; "count" ];
            allowed = None;
            fixed = [ ("code", [ Text_value "creating-annotations" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "code"; "count" ];
            allowed = None;
            fixed = [ ("code", [ Text_value "creating-tag-annotations" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "code"; "count"; "motivation" ];
            allowed = None;
            fixed =
              [
                ("code", [ Text_value "complete-created" ]);
                ( "motivation",
                  [
                    Text_value "assessing";
                    Text_value "commenting";
                    Text_value "highlighting";
                    Text_value "linking";
                    Text_value "tagging";
                  ] );
              ];
            values = None;
          };
        ];
      ] );
    ( "Job_result",
      [
        [
          {
            kind = Object_kind;
            required = [ "found"; "persisted" ];
            allowed =
              Some
                [
                  "found";
                  "persisted";
                  "errors";
                  "byCategory";
                  "underReportedPieces";
                  "uncheckedPieces";
                ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "resourceId"; "resourceName"; "truncated" ];
            allowed = Some [ "resourceId"; "resourceName"; "truncated" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "declined"; "reason" ];
            allowed = Some [ "declined"; "reason" ];
            fixed =
              [
                ("declined", [ Boolean_value true ]);
                ( "reason",
                  [
                    Text_value "no-text-layer";
                    Text_value "encrypted";
                    Text_value "corrupt";
                    Text_value "too-large";
                    Text_value "empty";
                  ] );
              ];
            values = None;
          };
        ];
      ] );
    ( "Kb_endpoint",
      [
        [
          {
            kind = Object_kind;
            required = [ "kind"; "host"; "port"; "protocol" ];
            allowed = None;
            fixed =
              [
                ("kind", [ Text_value "http" ]);
                ("protocol", [ Text_value "http"; Text_value "https" ]);
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "kind"; "kbId" ];
            allowed = None;
            fixed = [ ("kind", [ Text_value "local" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Mark_job_params",
      [
        [
          {
            kind = Object_kind;
            required = [ "motivation" ];
            allowed =
              Some [ "motivation"; "instructions"; "density"; "sourceLanguage" ];
            fixed = [ ("motivation", [ Text_value "highlighting" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "motivation" ];
            allowed =
              Some
                [
                  "motivation";
                  "instructions";
                  "tone";
                  "density";
                  "language";
                  "sourceLanguage";
                ];
            fixed =
              [
                ("motivation", [ Text_value "commenting" ]);
                ( "tone",
                  [
                    Text_value "scholarly";
                    Text_value "explanatory";
                    Text_value "conversational";
                    Text_value "technical";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "motivation" ];
            allowed =
              Some
                [
                  "motivation";
                  "instructions";
                  "tone";
                  "density";
                  "language";
                  "sourceLanguage";
                ];
            fixed =
              [
                ("motivation", [ Text_value "assessing" ]);
                ( "tone",
                  [
                    Text_value "analytical";
                    Text_value "critical";
                    Text_value "balanced";
                    Text_value "constructive";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "motivation"; "entityTypes" ];
            allowed =
              Some
                [
                  "motivation";
                  "entityTypes";
                  "includeDescriptiveReferences";
                  "language";
                  "sourceLanguage";
                ];
            fixed = [ ("motivation", [ Text_value "linking" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "motivation"; "schemaId"; "categories" ];
            allowed =
              Some
                [
                  "motivation";
                  "schemaId";
                  "categories";
                  "language";
                  "sourceLanguage";
                ];
            fixed = [ ("motivation", [ Text_value "tagging" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Mark_job_result",
      [
        [
          {
            kind = Object_kind;
            required = [ "found"; "persisted" ];
            allowed =
              Some
                [
                  "found";
                  "persisted";
                  "errors";
                  "byCategory";
                  "underReportedPieces";
                  "uncheckedPieces";
                ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "declined"; "reason" ];
            allowed = Some [ "declined"; "reason" ];
            fixed =
              [
                ("declined", [ Boolean_value true ]);
                ( "reason",
                  [
                    Text_value "no-text-layer";
                    Text_value "encrypted";
                    Text_value "corrupt";
                    Text_value "too-large";
                    Text_value "empty";
                  ] );
              ];
            values = None;
          };
        ];
      ] );
    ( "Yield_job_result",
      [
        [
          {
            kind = Object_kind;
            required = [ "resourceId"; "resourceName"; "truncated" ];
            allowed = Some [ "resourceId"; "resourceName"; "truncated" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "declined"; "reason" ];
            allowed = Some [ "declined"; "reason" ];
            fixed =
              [
                ("declined", [ Boolean_value true ]);
                ( "reason",
                  [
                    Text_value "no-text-layer";
                    Text_value "encrypted";
                    Text_value "corrupt";
                    Text_value "too-large";
                    Text_value "empty";
                  ] );
              ];
            values = None;
          };
        ];
      ] );
    ( "Conformance_step_fetches_fetches_item",
      [
        [
          {
            kind = Object_kind;
            required = [ "fetch"; "as" ];
            allowed = Some [ "fetch"; "payload"; "as" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "fetch" ];
            allowed = Some [ "fetch"; "params" ];
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Control_cli_commands_value_positionals_item",
      [
        [
          {
            kind = Object_kind;
            required = [ "name"; "fields" ];
            allowed = Some [ "name"; "fields" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "name"; "cliOnly" ];
            allowed = Some [ "name"; "cliOnly" ];
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Control_cli_commands_value_flags_value",
      [
        [
          {
            kind = Object_kind;
            required = [ "fields" ];
            allowed = Some [ "fields"; "notes" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "method" ];
            allowed = Some [ "method" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "cliOnly" ];
            allowed = Some [ "cliOnly" ];
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Graph_config",
      [
        [
          {
            kind = Object_kind;
            required = [ "type"; "uri"; "username"; "passwordEnv"; "database" ];
            allowed =
              Some [ "type"; "uri"; "username"; "passwordEnv"; "database" ];
            fixed = [ ("type", [ Text_value "neo4j" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "type"; "host"; "port" ];
            allowed = Some [ "type"; "host"; "port" ];
            fixed = [ ("type", [ Text_value "janusgraph" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "type"; "endpoint"; "port" ];
            allowed = Some [ "type"; "endpoint"; "port" ];
            fixed = [ ("type", [ Text_value "neptune" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "type" ];
            allowed = Some [ "type" ];
            fixed = [ ("type", [ Text_value "memory" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Vectors_config",
      [
        [
          {
            kind = Object_kind;
            required = [ "type"; "host"; "port"; "tokenEnv" ];
            allowed = Some [ "type"; "host"; "port"; "tokenEnv" ];
            fixed = [ ("type", [ Text_value "qdrant" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "type" ];
            allowed = Some [ "type" ];
            fixed = [ ("type", [ Text_value "memory" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Embedding_config",
      [
        [
          {
            kind = Object_kind;
            required = [ "type"; "model"; "baseUrl" ];
            allowed = Some [ "type"; "model"; "baseUrl" ];
            fixed = [ ("type", [ Text_value "ollama" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "type"; "model"; "endpoint"; "apiKeyEnv" ];
            allowed = Some [ "type"; "model"; "endpoint"; "apiKeyEnv" ];
            fixed = [ ("type", [ Text_value "voyage" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Annotation_selector",
      [
        [
          {
            kind = Object_kind;
            required = [ "type"; "start"; "end" ];
            allowed = None;
            fixed = [ ("type", [ Text_value "TextPositionSelector" ]) ];
            values = None;
          };
          {
            kind = Object_kind;
            required = [ "type"; "exact" ];
            allowed = None;
            fixed = [ ("type", [ Text_value "TextQuoteSelector" ]) ];
            values = None;
          };
          {
            kind = Object_kind;
            required = [ "type"; "value" ];
            allowed = None;
            fixed = [ ("type", [ Text_value "SvgSelector" ]) ];
            values = None;
          };
          {
            kind = Object_kind;
            required = [ "type"; "value" ];
            allowed = None;
            fixed = [ ("type", [ Text_value "FragmentSelector" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = List_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Annotation_bodies",
      [
        [
          {
            kind = Object_kind;
            required = [ "type"; "value" ];
            allowed = None;
            fixed =
              [
                ("type", [ Text_value "TextualBody" ]);
                ( "purpose",
                  [
                    Text_value "assessing";
                    Text_value "bookmarking";
                    Text_value "classifying";
                    Text_value "commenting";
                    Text_value "describing";
                    Text_value "editing";
                    Text_value "highlighting";
                    Text_value "identifying";
                    Text_value "linking";
                    Text_value "moderating";
                    Text_value "questioning";
                    Text_value "replying";
                    Text_value "tagging";
                  ] );
              ];
            values = None;
          };
          {
            kind = Object_kind;
            required = [ "type"; "source" ];
            allowed = None;
            fixed =
              [
                ("type", [ Text_value "SpecificResource" ]);
                ( "purpose",
                  [
                    Text_value "assessing";
                    Text_value "bookmarking";
                    Text_value "classifying";
                    Text_value "commenting";
                    Text_value "describing";
                    Text_value "editing";
                    Text_value "highlighting";
                    Text_value "identifying";
                    Text_value "linking";
                    Text_value "moderating";
                    Text_value "questioning";
                    Text_value "replying";
                    Text_value "tagging";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = List_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "One_or_more_agents",
      [
        [
          {
            kind = Object_kind;
            required = [ "@type" ];
            allowed = None;
            fixed = [ ("@type", [ Text_value "Person" ]) ];
            values = None;
          };
          {
            kind = Object_kind;
            required = [ "@type"; "name" ];
            allowed = None;
            fixed = [ ("@type", [ Text_value "Organization" ]) ];
            values = None;
          };
          {
            kind = Object_kind;
            required = [ "@type" ];
            allowed = None;
            fixed = [ ("@type", [ Text_value "Software" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = List_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Job_filter",
      [
        [
          {
            kind = Object_kind;
            required = [ "jobType"; "params" ];
            allowed = Some [ "jobType"; "params" ];
            fixed = [ ("jobType", [ Text_value "mark" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "jobType" ];
            allowed = Some [ "jobType" ];
            fixed = [ ("jobType", [ Text_value "yield" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Resource_descriptor_representations",
      [
        [
          {
            kind = Object_kind;
            required = [ "mediaType" ];
            allowed = None;
            fixed =
              [
                ( "rel",
                  [
                    Text_value "original";
                    Text_value "thumbnail";
                    Text_value "preview";
                    Text_value "optimized";
                    Text_value "derived";
                    Text_value "other";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = List_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Job_stored_result",
      [
        [
          {
            kind = Object_kind;
            required = [ "found"; "persisted" ];
            allowed =
              Some
                [
                  "found";
                  "persisted";
                  "errors";
                  "byCategory";
                  "underReportedPieces";
                  "uncheckedPieces";
                ];
            fixed = [];
            values = None;
          };
          {
            kind = Object_kind;
            required = [ "resourceId"; "resourceName"; "truncated" ];
            allowed = Some [ "resourceId"; "resourceName"; "truncated" ];
            fixed = [];
            values = None;
          };
          {
            kind = Object_kind;
            required = [ "declined"; "reason" ];
            allowed = Some [ "declined"; "reason" ];
            fixed =
              [
                ("declined", [ Boolean_value true ]);
                ( "reason",
                  [
                    Text_value "no-text-layer";
                    Text_value "encrypted";
                    Text_value "corrupt";
                    Text_value "too-large";
                    Text_value "empty";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [];
            allowed = Some [];
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Anchored_text_entry",
      [
        [
          {
            kind = Object_kind;
            required = [ "v"; "stamp"; "text"; "lines"; "method" ];
            allowed =
              Some
                [
                  "v";
                  "stamp";
                  "text";
                  "lines";
                  "method";
                  "pdfClass";
                  "ocrConfidence";
                  "unreadPages";
                ];
            fixed =
              [
                ("v", [ Integer_value 3 ]);
                ( "method",
                  [
                    Text_value "text-passthrough";
                    Text_value "pdf-text-layer";
                    Text_value "table";
                    Text_value "form";
                    Text_value "ocr";
                  ] );
                ( "pdfClass",
                  [
                    Text_value "A";
                    Text_value "B";
                    Text_value "C";
                    Text_value "D";
                    Text_value "E";
                    Text_value "F";
                    Text_value "G";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "v"; "stamp"; "declined" ];
            allowed = Some [ "v"; "stamp"; "declined" ];
            fixed =
              [
                ("v", [ Integer_value 3 ]);
                ( "declined",
                  [
                    Text_value "no-text-layer";
                    Text_value "encrypted";
                    Text_value "corrupt";
                    Text_value "too-large";
                  ] );
              ];
            values = None;
          };
        ];
      ] );
    ( "Client_refresh_queries_item",
      [
        [
          {
            kind = Object_kind;
            required = [ "name"; "asks"; "value"; "docs" ];
            allowed =
              Some [ "name"; "per"; "asks"; "persisted"; "value"; "docs" ];
            fixed =
              [
                ( "per",
                  [
                    Text_value "resource";
                    Text_value "annotation";
                    Text_value "filters";
                  ] );
                ("persisted", [ Boolean_value true ]);
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "name"; "reads"; "value"; "docs" ];
            allowed =
              Some [ "name"; "per"; "reads"; "persisted"; "value"; "docs" ];
            fixed =
              [
                ( "per",
                  [
                    Text_value "resource";
                    Text_value "annotation";
                    Text_value "filters";
                  ] );
                ("persisted", [ Boolean_value true ]);
              ];
            values = None;
          };
        ];
      ] );
    ( "Client_refresh_refresh_item",
      [
        [
          {
            kind = Object_kind;
            required = [ "on"; "docs" ];
            allowed =
              Some
                [
                  "on";
                  "when";
                  "reach";
                  "names";
                  "carries";
                  "refetches";
                  "writes";
                  "removes";
                  "docs";
                ];
            fixed =
              [
                ("when", [ Text_value "enriched"; Text_value "unenriched" ]);
                ("reach", [ Text_value "subject"; Text_value "held" ]);
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "stream"; "docs" ];
            allowed = Some [ "stream"; "reach"; "refetches"; "docs" ];
            fixed =
              [
                ("stream", [ Text_value "reopened"; Text_value "unreadable" ]);
                ("reach", [ Text_value "subject"; Text_value "held" ]);
              ];
            values = None;
          };
        ];
      ] );
    ( "Errors_codes_transport_codes_item",
      [
        [
          {
            kind = Object_kind;
            required = [ "code"; "docs"; "status" ];
            allowed = Some [ "code"; "docs"; "status"; "limitRefusals" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "code"; "docs"; "statusFrom" ];
            allowed = Some [ "code"; "docs"; "statusFrom" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "code"; "docs" ];
            allowed = Some [ "code"; "docs" ];
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Anchored_text_answer",
      [
        [
          {
            kind = Object_kind;
            required = [ "text"; "items"; "kind"; "method" ];
            allowed = None;
            fixed =
              [
                ("kind", [ Text_value "extracted" ]);
                ( "method",
                  [
                    Text_value "text-passthrough";
                    Text_value "pdf-text-layer";
                    Text_value "table";
                    Text_value "form";
                    Text_value "ocr";
                  ] );
                ( "pdfClass",
                  [
                    Text_value "A";
                    Text_value "B";
                    Text_value "C";
                    Text_value "D";
                    Text_value "E";
                    Text_value "F";
                    Text_value "G";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "kind"; "declined" ];
            allowed = None;
            fixed =
              [
                ("kind", [ Text_value "declined" ]);
                ( "declined",
                  [
                    Text_value "no-text-layer";
                    Text_value "encrypted";
                    Text_value "corrupt";
                    Text_value "too-large";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "kind" ];
            allowed = None;
            fixed =
              [
                ( "kind",
                  [
                    Text_value "not-yet";
                    Text_value "no-map";
                    Text_value "unknown";
                  ] );
              ];
            values = None;
          };
        ];
      ] );
    ( "Extraction_outcome",
      [
        [
          {
            kind = Object_kind;
            required = [ "text"; "items"; "kind"; "method" ];
            allowed = None;
            fixed =
              [
                ("kind", [ Text_value "extracted" ]);
                ( "method",
                  [
                    Text_value "text-passthrough";
                    Text_value "pdf-text-layer";
                    Text_value "table";
                    Text_value "form";
                    Text_value "ocr";
                  ] );
                ( "pdfClass",
                  [
                    Text_value "A";
                    Text_value "B";
                    Text_value "C";
                    Text_value "D";
                    Text_value "E";
                    Text_value "F";
                    Text_value "G";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "kind"; "declined" ];
            allowed = None;
            fixed =
              [
                ("kind", [ Text_value "declined" ]);
                ( "declined",
                  [
                    Text_value "no-text-layer";
                    Text_value "encrypted";
                    Text_value "corrupt";
                    Text_value "too-large";
                  ] );
              ];
            values = None;
          };
        ];
      ] );
    ( "Bus_stream_message",
      [
        [
          {
            kind = Object_kind;
            required = [ "event"; "id"; "data" ];
            allowed = Some [ "event"; "id"; "data" ];
            fixed = [ ("event", [ Text_value "bus-event" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "event"; "data" ];
            allowed = Some [ "event"; "data" ];
            fixed = [ ("event", [ Text_value "ping" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Conformance_driver_line_emission_emission_state",
      [
        [
          {
            kind = Object_kind;
            required = [ "status" ];
            allowed = Some [ "status" ];
            fixed = [ ("status", [ Text_value "pending" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "status"; "value" ];
            allowed = Some [ "status"; "value" ];
            fixed = [ ("status", [ Text_value "ready" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "status"; "error" ];
            allowed = Some [ "status"; "error" ];
            fixed = [ ("status", [ Text_value "failed" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Body_operation",
      [
        [
          {
            kind = Object_kind;
            required = [ "op"; "item" ];
            allowed = None;
            fixed = [ ("op", [ Text_value "add" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "op"; "item" ];
            allowed = None;
            fixed = [ ("op", [ Text_value "remove" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "op"; "oldItem"; "newItem" ];
            allowed = None;
            fixed = [ ("op", [ Text_value "replace" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Job_stored_progress",
      [
        [
          {
            kind = Object_kind;
            required = [ "percentage" ];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [];
            allowed = Some [];
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Client_option_defaults_defaults_item_schema",
      [
        [
          {
            kind = Object_kind;
            required = [ "$ref" ];
            allowed = Some [ "$ref"; "typeArguments" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "type"; "description" ];
            allowed = Some [ "type"; "minimum"; "format"; "description" ];
            fixed =
              [
                ( "type",
                  [
                    Text_value "integer";
                    Text_value "string";
                    Text_value "boolean";
                  ] );
                ("format", [ Text_value "date-time" ]);
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "typeParameter" ];
            allowed = Some [ "typeParameter" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "decided" ];
            allowed = Some [ "decided" ];
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Conformance_step",
      [
        [
          {
            kind = Object_kind;
            required = [ "let" ];
            allowed = Some [ "let" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "driver" ];
            allowed = Some [ "driver"; "with"; "returns"; "fails"; "as" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "abandon" ];
            allowed = Some [ "abandon" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "settles" ];
            allowed = Some [ "settles"; "returns"; "fails"; "abandoned" ];
            fixed = [ ("abandoned", [ Boolean_value true ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "wire" ];
            allowed =
              Some
                [
                  "wire";
                  "at";
                  "status";
                  "params";
                  "body";
                  "token";
                  "headers";
                  "answer";
                  "as";
                  "follows";
                  "waited";
                ];
            fixed =
              [
                ( "at",
                  [
                    Text_value "arrival"; Text_value "answer"; Text_value "live";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "carried"; "is" ];
            allowed = Some [ "carried"; "is" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "closed" ];
            allowed = Some [ "closed" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "progress" ];
            allowed = Some [ "progress" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "state" ];
            allowed = Some [ "state" ];
            fixed =
              [
                ( "state",
                  [
                    Text_value "initial";
                    Text_value "connecting";
                    Text_value "open";
                    Text_value "reconnecting";
                    Text_value "degraded";
                    Text_value "unauthenticated";
                    Text_value "closed";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "stays" ];
            allowed = Some [ "stays" ];
            fixed =
              [
                ( "stays",
                  [
                    Text_value "initial";
                    Text_value "connecting";
                    Text_value "open";
                    Text_value "reconnecting";
                    Text_value "degraded";
                    Text_value "unauthenticated";
                    Text_value "closed";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "frame"; "is" ];
            allowed = Some [ "frame"; "is" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "frames"; "count" ];
            allowed = Some [ "frames"; "count" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "error" ];
            allowed = Some [ "error" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "backend" ];
            allowed = Some [ "backend"; "with" ];
            fixed =
              [
                ( "backend",
                  [
                    Text_value "listen";
                    Text_value "emit";
                    Text_value "record";
                    Text_value "content";
                    Text_value "description";
                    Text_value "annotations";
                    Text_value "anchored-text";
                    Text_value "uploaded";
                    Text_value "refuse";
                    Text_value "unanswered";
                    Text_value "answer-lost";
                    Text_value "hold";
                    Text_value "release";
                    Text_value "rechunk";
                    Text_value "carry";
                    Text_value "cut";
                    Text_value "down";
                    Text_value "up";
                    Text_value "archivist";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "quiet" ];
            allowed = Some [ "quiet" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "observe"; "as" ];
            allowed = Some [ "observe"; "as" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "leave" ];
            allowed = Some [ "leave" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "reaches"; "state" ];
            allowed = Some [ "reaches"; "state" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "holds"; "state" ];
            allowed = Some [ "holds"; "state" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "completes" ];
            allowed = Some [ "completes" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "fetch"; "as" ];
            allowed = Some [ "fetch"; "payload"; "as" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "fetch" ];
            allowed = Some [ "fetch"; "params" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "fetches" ];
            allowed = Some [ "fetches" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "scopes" ];
            allowed = Some [ "scopes" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "claimed" ];
            allowed = Some [ "claimed" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "refused" ];
            allowed = Some [ "refused" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "signalled" ];
            allowed = Some [ "signalled" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "stalled" ];
            allowed = Some [ "stalled" ];
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Job_complete_command",
      [
        [
          {
            kind = Object_kind;
            required = [ "resourceId"; "jobId"; "jobType" ];
            allowed = None;
            fixed =
              [
                ("jobType", [ Text_value "mark" ]);
                ( "durability",
                  [
                    Text_value "acknowledged";
                    Text_value "probe-confirmed";
                    Text_value "probe-refused";
                    Text_value "probe-unreachable";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "resourceId"; "jobId"; "jobType" ];
            allowed = None;
            fixed =
              [
                ("jobType", [ Text_value "yield" ]);
                ( "durability",
                  [
                    Text_value "acknowledged";
                    Text_value "probe-confirmed";
                    Text_value "probe-refused";
                    Text_value "probe-unreachable";
                  ] );
              ];
            values = None;
          };
        ];
      ] );
    ( "Job_queued_event",
      [
        [
          {
            kind = Object_kind;
            required = [ "jobId"; "jobType"; "resourceId"; "userId"; "params" ];
            allowed = None;
            fixed = [ ("jobType", [ Text_value "mark" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "jobId"; "jobType"; "resourceId"; "userId"; "params" ];
            allowed = None;
            fixed = [ ("jobType", [ Text_value "yield" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Annotation_target_value",
      [
        [
          {
            kind = Text_kind;
            required = [];
            allowed = None;
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "source" ];
            allowed = None;
            fixed = [ ("type", [ Text_value "SpecificResource" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Job",
      [
        [
          {
            kind = Object_kind;
            required = [ "status"; "metadata"; "params" ];
            allowed = Some [ "status"; "metadata"; "params" ];
            fixed = [ ("status", [ Text_value "pending" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required =
              [ "status"; "metadata"; "params"; "startedAt"; "progress" ];
            allowed =
              Some [ "status"; "metadata"; "params"; "startedAt"; "progress" ];
            fixed = [ ("status", [ Text_value "running" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required =
              [
                "status";
                "metadata";
                "params";
                "startedAt";
                "completedAt";
                "result";
              ];
            allowed =
              Some
                [
                  "status";
                  "metadata";
                  "params";
                  "startedAt";
                  "completedAt";
                  "result";
                ];
            fixed = [ ("status", [ Text_value "complete" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required =
              [ "status"; "metadata"; "params"; "completedAt"; "error" ];
            allowed =
              Some
                [
                  "status";
                  "metadata";
                  "params";
                  "startedAt";
                  "completedAt";
                  "error";
                  "failureClass";
                ];
            fixed =
              [
                ("status", [ Text_value "failed" ]);
                ( "failureClass",
                  [
                    Text_value "transient";
                    Text_value "deterministic";
                    Text_value "withheld";
                  ] );
              ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "status"; "metadata"; "params"; "completedAt" ];
            allowed =
              Some
                [ "status"; "metadata"; "params"; "startedAt"; "completedAt" ];
            fixed = [ ("status", [ Text_value "cancelled" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Conformance_driver_line",
      [
        [
          {
            kind = Object_kind;
            required = [ "ready" ];
            allowed = Some [ "ready" ];
            fixed = [ ("ready", [ Boolean_value true ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "id"; "ok" ];
            allowed = Some [ "id"; "ok" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "id"; "error" ];
            allowed = Some [ "id"; "error" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "id"; "abandoned" ];
            allowed = Some [ "id"; "abandoned" ];
            fixed = [ ("abandoned", [ Boolean_value true ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "id"; "unsupported" ];
            allowed = Some [ "id"; "unsupported" ];
            fixed = [ ("unsupported", [ Boolean_value true ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "id"; "misuse" ];
            allowed = Some [ "id"; "misuse" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "state" ];
            allowed = Some [ "state" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "frame" ];
            allowed = Some [ "frame" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "error" ];
            allowed = Some [ "error" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "progress" ];
            allowed = Some [ "progress" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "emission" ];
            allowed = Some [ "emission" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "completed" ];
            allowed = Some [ "completed" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "claimed" ];
            allowed = Some [ "claimed" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "refused" ];
            allowed = Some [ "refused" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "signalled" ];
            allowed = Some [ "signalled" ];
            fixed = [];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "stalled" ];
            allowed = Some [ "stalled" ];
            fixed = [];
            values = None;
          };
        ];
      ] );
    ( "Gathered_context_focus",
      [
        [
          {
            kind = Object_kind;
            required = [ "kind"; "annotation"; "sourceResource" ];
            allowed = None;
            fixed = [ ("kind", [ Text_value "annotation" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "kind"; "resource" ];
            allowed = None;
            fixed = [ ("kind", [ Text_value "resource" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Knowledge_graph_nodes_item",
      [
        [
          {
            kind = Object_kind;
            required = [ "id"; "type"; "label" ];
            allowed = None;
            fixed = [ ("type", [ Text_value "resource" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "id"; "type"; "label"; "annotation" ];
            allowed = None;
            fixed = [ ("type", [ Text_value "annotation" ]) ];
            values = None;
          };
        ];
      ] );
    ( "Job_create_command",
      [
        [
          {
            kind = Object_kind;
            required = [ "jobType"; "resourceId"; "params" ];
            allowed =
              Some [ "_userId"; "_roles"; "jobType"; "resourceId"; "params" ];
            fixed = [ ("jobType", [ Text_value "mark" ]) ];
            values = None;
          };
        ];
        [
          {
            kind = Object_kind;
            required = [ "jobType"; "params" ];
            allowed = Some [ "_userId"; "_roles"; "jobType"; "params" ];
            fixed = [ ("jobType", [ Text_value "yield" ]) ];
            values = None;
          };
        ];
      ] );
  ]
