(* Generated from the string enums among the schemas protocol/specs/src roots, its client types and its tables. Do not edit.
   Regenerate: make generate (codegen/lib/ocaml_sdk/enums.ml) *)

let () =
  let module Model = Xynolog.Enums.Api_version in
  Alcotest.check Alcotest.string "Api_version encode"
    "control.xynolog.org/v1alpha1"
    (Model.to_string Model.Control_xynolog_org_v1alpha1);
  Alcotest.check Alcotest.bool "Api_version decode" true
    (Model.of_string "control.xynolog.org/v1alpha1"
    = Some Model.Control_xynolog_org_v1alpha1);
  Alcotest.check Alcotest.bool "Api_version rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Body_purpose in
  Alcotest.check Alcotest.string "Body_purpose encode" "assessing"
    (Model.to_string Model.Assessing);
  Alcotest.check Alcotest.bool "Body_purpose decode" true
    (Model.of_string "assessing" = Some Model.Assessing);
  Alcotest.check Alcotest.string "Body_purpose encode" "bookmarking"
    (Model.to_string Model.Bookmarking);
  Alcotest.check Alcotest.bool "Body_purpose decode" true
    (Model.of_string "bookmarking" = Some Model.Bookmarking);
  Alcotest.check Alcotest.string "Body_purpose encode" "classifying"
    (Model.to_string Model.Classifying);
  Alcotest.check Alcotest.bool "Body_purpose decode" true
    (Model.of_string "classifying" = Some Model.Classifying);
  Alcotest.check Alcotest.string "Body_purpose encode" "commenting"
    (Model.to_string Model.Commenting);
  Alcotest.check Alcotest.bool "Body_purpose decode" true
    (Model.of_string "commenting" = Some Model.Commenting);
  Alcotest.check Alcotest.string "Body_purpose encode" "describing"
    (Model.to_string Model.Describing);
  Alcotest.check Alcotest.bool "Body_purpose decode" true
    (Model.of_string "describing" = Some Model.Describing);
  Alcotest.check Alcotest.string "Body_purpose encode" "editing"
    (Model.to_string Model.Editing);
  Alcotest.check Alcotest.bool "Body_purpose decode" true
    (Model.of_string "editing" = Some Model.Editing);
  Alcotest.check Alcotest.string "Body_purpose encode" "highlighting"
    (Model.to_string Model.Highlighting);
  Alcotest.check Alcotest.bool "Body_purpose decode" true
    (Model.of_string "highlighting" = Some Model.Highlighting);
  Alcotest.check Alcotest.string "Body_purpose encode" "identifying"
    (Model.to_string Model.Identifying);
  Alcotest.check Alcotest.bool "Body_purpose decode" true
    (Model.of_string "identifying" = Some Model.Identifying);
  Alcotest.check Alcotest.string "Body_purpose encode" "linking"
    (Model.to_string Model.Linking);
  Alcotest.check Alcotest.bool "Body_purpose decode" true
    (Model.of_string "linking" = Some Model.Linking);
  Alcotest.check Alcotest.string "Body_purpose encode" "moderating"
    (Model.to_string Model.Moderating);
  Alcotest.check Alcotest.bool "Body_purpose decode" true
    (Model.of_string "moderating" = Some Model.Moderating);
  Alcotest.check Alcotest.string "Body_purpose encode" "questioning"
    (Model.to_string Model.Questioning);
  Alcotest.check Alcotest.bool "Body_purpose decode" true
    (Model.of_string "questioning" = Some Model.Questioning);
  Alcotest.check Alcotest.string "Body_purpose encode" "replying"
    (Model.to_string Model.Replying);
  Alcotest.check Alcotest.bool "Body_purpose decode" true
    (Model.of_string "replying" = Some Model.Replying);
  Alcotest.check Alcotest.string "Body_purpose encode" "tagging"
    (Model.to_string Model.Tagging);
  Alcotest.check Alcotest.bool "Body_purpose decode" true
    (Model.of_string "tagging" = Some Model.Tagging);
  Alcotest.check Alcotest.bool "Body_purpose rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Control_sender in
  Alcotest.check Alcotest.string "Control_sender encode" "client"
    (Model.to_string Model.Client);
  Alcotest.check Alcotest.bool "Control_sender decode" true
    (Model.of_string "client" = Some Model.Client);
  Alcotest.check Alcotest.string "Control_sender encode" "launcher"
    (Model.to_string Model.Launcher);
  Alcotest.check Alcotest.bool "Control_sender decode" true
    (Model.of_string "launcher" = Some Model.Launcher);
  Alcotest.check Alcotest.bool "Control_sender rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Durability_evidence in
  Alcotest.check Alcotest.string "Durability_evidence encode" "acknowledged"
    (Model.to_string Model.Acknowledged);
  Alcotest.check Alcotest.bool "Durability_evidence decode" true
    (Model.of_string "acknowledged" = Some Model.Acknowledged);
  Alcotest.check Alcotest.string "Durability_evidence encode" "probe-confirmed"
    (Model.to_string Model.Probe_confirmed);
  Alcotest.check Alcotest.bool "Durability_evidence decode" true
    (Model.of_string "probe-confirmed" = Some Model.Probe_confirmed);
  Alcotest.check Alcotest.string "Durability_evidence encode" "probe-refused"
    (Model.to_string Model.Probe_refused);
  Alcotest.check Alcotest.bool "Durability_evidence decode" true
    (Model.of_string "probe-refused" = Some Model.Probe_refused);
  Alcotest.check Alcotest.string "Durability_evidence encode"
    "probe-unreachable"
    (Model.to_string Model.Probe_unreachable);
  Alcotest.check Alcotest.bool "Durability_evidence decode" true
    (Model.of_string "probe-unreachable" = Some Model.Probe_unreachable);
  Alcotest.check Alcotest.bool "Durability_evidence rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Extraction_declined_reason in
  Alcotest.check Alcotest.string "Extraction_declined_reason encode"
    "no-text-layer"
    (Model.to_string Model.No_text_layer);
  Alcotest.check Alcotest.bool "Extraction_declined_reason decode" true
    (Model.of_string "no-text-layer" = Some Model.No_text_layer);
  Alcotest.check Alcotest.string "Extraction_declined_reason encode" "encrypted"
    (Model.to_string Model.Encrypted);
  Alcotest.check Alcotest.bool "Extraction_declined_reason decode" true
    (Model.of_string "encrypted" = Some Model.Encrypted);
  Alcotest.check Alcotest.string "Extraction_declined_reason encode" "corrupt"
    (Model.to_string Model.Corrupt);
  Alcotest.check Alcotest.bool "Extraction_declined_reason decode" true
    (Model.of_string "corrupt" = Some Model.Corrupt);
  Alcotest.check Alcotest.string "Extraction_declined_reason encode" "too-large"
    (Model.to_string Model.Too_large);
  Alcotest.check Alcotest.bool "Extraction_declined_reason decode" true
    (Model.of_string "too-large" = Some Model.Too_large);
  Alcotest.check Alcotest.bool
    "Extraction_declined_reason rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Extraction_method in
  Alcotest.check Alcotest.string "Extraction_method encode" "text-passthrough"
    (Model.to_string Model.Text_passthrough);
  Alcotest.check Alcotest.bool "Extraction_method decode" true
    (Model.of_string "text-passthrough" = Some Model.Text_passthrough);
  Alcotest.check Alcotest.string "Extraction_method encode" "pdf-text-layer"
    (Model.to_string Model.Pdf_text_layer);
  Alcotest.check Alcotest.bool "Extraction_method decode" true
    (Model.of_string "pdf-text-layer" = Some Model.Pdf_text_layer);
  Alcotest.check Alcotest.string "Extraction_method encode" "table"
    (Model.to_string Model.Table);
  Alcotest.check Alcotest.bool "Extraction_method decode" true
    (Model.of_string "table" = Some Model.Table);
  Alcotest.check Alcotest.string "Extraction_method encode" "form"
    (Model.to_string Model.Form);
  Alcotest.check Alcotest.bool "Extraction_method decode" true
    (Model.of_string "form" = Some Model.Form);
  Alcotest.check Alcotest.string "Extraction_method encode" "ocr"
    (Model.to_string Model.Ocr);
  Alcotest.check Alcotest.bool "Extraction_method decode" true
    (Model.of_string "ocr" = Some Model.Ocr);
  Alcotest.check Alcotest.bool "Extraction_method rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Failure_class in
  Alcotest.check Alcotest.string "Failure_class encode" "transient"
    (Model.to_string Model.Transient);
  Alcotest.check Alcotest.bool "Failure_class decode" true
    (Model.of_string "transient" = Some Model.Transient);
  Alcotest.check Alcotest.string "Failure_class encode" "deterministic"
    (Model.to_string Model.Deterministic);
  Alcotest.check Alcotest.bool "Failure_class decode" true
    (Model.of_string "deterministic" = Some Model.Deterministic);
  Alcotest.check Alcotest.string "Failure_class encode" "withheld"
    (Model.to_string Model.Withheld);
  Alcotest.check Alcotest.bool "Failure_class decode" true
    (Model.of_string "withheld" = Some Model.Withheld);
  Alcotest.check Alcotest.bool "Failure_class rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Inference_provider in
  Alcotest.check Alcotest.string "Inference_provider encode" "anthropic"
    (Model.to_string Model.Anthropic);
  Alcotest.check Alcotest.bool "Inference_provider decode" true
    (Model.of_string "anthropic" = Some Model.Anthropic);
  Alcotest.check Alcotest.string "Inference_provider encode" "google"
    (Model.to_string Model.Google);
  Alcotest.check Alcotest.bool "Inference_provider decode" true
    (Model.of_string "google" = Some Model.Google);
  Alcotest.check Alcotest.string "Inference_provider encode" "llamacpp"
    (Model.to_string Model.Llamacpp);
  Alcotest.check Alcotest.bool "Inference_provider decode" true
    (Model.of_string "llamacpp" = Some Model.Llamacpp);
  Alcotest.check Alcotest.string "Inference_provider encode" "ollama"
    (Model.to_string Model.Ollama);
  Alcotest.check Alcotest.bool "Inference_provider decode" true
    (Model.of_string "ollama" = Some Model.Ollama);
  Alcotest.check Alcotest.string "Inference_provider encode" "openai"
    (Model.to_string Model.Openai);
  Alcotest.check Alcotest.bool "Inference_provider decode" true
    (Model.of_string "openai" = Some Model.Openai);
  Alcotest.check Alcotest.string "Inference_provider encode" "together"
    (Model.to_string Model.Together);
  Alcotest.check Alcotest.bool "Inference_provider decode" true
    (Model.of_string "together" = Some Model.Together);
  Alcotest.check Alcotest.string "Inference_provider encode" "vllm"
    (Model.to_string Model.Vllm);
  Alcotest.check Alcotest.bool "Inference_provider decode" true
    (Model.of_string "vllm" = Some Model.Vllm);
  Alcotest.check Alcotest.bool "Inference_provider rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Job_type in
  Alcotest.check Alcotest.string "Job_type encode" "mark"
    (Model.to_string Model.Mark);
  Alcotest.check Alcotest.bool "Job_type decode" true
    (Model.of_string "mark" = Some Model.Mark);
  Alcotest.check Alcotest.string "Job_type encode" "yield"
    (Model.to_string Model.Yield);
  Alcotest.check Alcotest.bool "Job_type decode" true
    (Model.of_string "yield" = Some Model.Yield);
  Alcotest.check Alcotest.bool "Job_type rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Kb_placement in
  Alcotest.check Alcotest.string "Kb_placement encode" "local"
    (Model.to_string Model.Local);
  Alcotest.check Alcotest.bool "Kb_placement decode" true
    (Model.of_string "local" = Some Model.Local);
  Alcotest.check Alcotest.string "Kb_placement encode" "codespace"
    (Model.to_string Model.Codespace);
  Alcotest.check Alcotest.bool "Kb_placement decode" true
    (Model.of_string "codespace" = Some Model.Codespace);
  Alcotest.check Alcotest.bool "Kb_placement rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Log_format in
  Alcotest.check Alcotest.string "Log_format encode" "json"
    (Model.to_string Model.Json);
  Alcotest.check Alcotest.bool "Log_format decode" true
    (Model.of_string "json" = Some Model.Json);
  Alcotest.check Alcotest.string "Log_format encode" "simple"
    (Model.to_string Model.Simple);
  Alcotest.check Alcotest.bool "Log_format decode" true
    (Model.of_string "simple" = Some Model.Simple);
  Alcotest.check Alcotest.bool "Log_format rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Log_level in
  Alcotest.check Alcotest.string "Log_level encode" "error"
    (Model.to_string Model.Error);
  Alcotest.check Alcotest.bool "Log_level decode" true
    (Model.of_string "error" = Some Model.Error);
  Alcotest.check Alcotest.string "Log_level encode" "warn"
    (Model.to_string Model.Warn);
  Alcotest.check Alcotest.bool "Log_level decode" true
    (Model.of_string "warn" = Some Model.Warn);
  Alcotest.check Alcotest.string "Log_level encode" "info"
    (Model.to_string Model.Info);
  Alcotest.check Alcotest.bool "Log_level decode" true
    (Model.of_string "info" = Some Model.Info);
  Alcotest.check Alcotest.string "Log_level encode" "http"
    (Model.to_string Model.Http);
  Alcotest.check Alcotest.bool "Log_level decode" true
    (Model.of_string "http" = Some Model.Http);
  Alcotest.check Alcotest.string "Log_level encode" "debug"
    (Model.to_string Model.Debug);
  Alcotest.check Alcotest.bool "Log_level decode" true
    (Model.of_string "debug" = Some Model.Debug);
  Alcotest.check Alcotest.bool "Log_level rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Motivation in
  Alcotest.check Alcotest.string "Motivation encode" "assessing"
    (Model.to_string Model.Assessing);
  Alcotest.check Alcotest.bool "Motivation decode" true
    (Model.of_string "assessing" = Some Model.Assessing);
  Alcotest.check Alcotest.string "Motivation encode" "commenting"
    (Model.to_string Model.Commenting);
  Alcotest.check Alcotest.bool "Motivation decode" true
    (Model.of_string "commenting" = Some Model.Commenting);
  Alcotest.check Alcotest.string "Motivation encode" "highlighting"
    (Model.to_string Model.Highlighting);
  Alcotest.check Alcotest.bool "Motivation decode" true
    (Model.of_string "highlighting" = Some Model.Highlighting);
  Alcotest.check Alcotest.string "Motivation encode" "linking"
    (Model.to_string Model.Linking);
  Alcotest.check Alcotest.bool "Motivation decode" true
    (Model.of_string "linking" = Some Model.Linking);
  Alcotest.check Alcotest.string "Motivation encode" "tagging"
    (Model.to_string Model.Tagging);
  Alcotest.check Alcotest.bool "Motivation decode" true
    (Model.of_string "tagging" = Some Model.Tagging);
  Alcotest.check Alcotest.bool "Motivation rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Output_stream in
  Alcotest.check Alcotest.string "Output_stream encode" "stdout"
    (Model.to_string Model.Stdout);
  Alcotest.check Alcotest.bool "Output_stream decode" true
    (Model.of_string "stdout" = Some Model.Stdout);
  Alcotest.check Alcotest.string "Output_stream encode" "stderr"
    (Model.to_string Model.Stderr);
  Alcotest.check Alcotest.bool "Output_stream decode" true
    (Model.of_string "stderr" = Some Model.Stderr);
  Alcotest.check Alcotest.bool "Output_stream rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Pdf_class in
  Alcotest.check Alcotest.string "Pdf_class encode" "A"
    (Model.to_string Model.A);
  Alcotest.check Alcotest.bool "Pdf_class decode" true
    (Model.of_string "A" = Some Model.A);
  Alcotest.check Alcotest.string "Pdf_class encode" "B"
    (Model.to_string Model.B);
  Alcotest.check Alcotest.bool "Pdf_class decode" true
    (Model.of_string "B" = Some Model.B);
  Alcotest.check Alcotest.string "Pdf_class encode" "C"
    (Model.to_string Model.C);
  Alcotest.check Alcotest.bool "Pdf_class decode" true
    (Model.of_string "C" = Some Model.C);
  Alcotest.check Alcotest.string "Pdf_class encode" "D"
    (Model.to_string Model.D);
  Alcotest.check Alcotest.bool "Pdf_class decode" true
    (Model.of_string "D" = Some Model.D);
  Alcotest.check Alcotest.string "Pdf_class encode" "E"
    (Model.to_string Model.E);
  Alcotest.check Alcotest.bool "Pdf_class decode" true
    (Model.of_string "E" = Some Model.E);
  Alcotest.check Alcotest.string "Pdf_class encode" "F"
    (Model.to_string Model.F);
  Alcotest.check Alcotest.bool "Pdf_class decode" true
    (Model.of_string "F" = Some Model.F);
  Alcotest.check Alcotest.string "Pdf_class encode" "G"
    (Model.to_string Model.G);
  Alcotest.check Alcotest.bool "Pdf_class decode" true
    (Model.of_string "G" = Some Model.G);
  Alcotest.check Alcotest.bool "Pdf_class rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Run_service in
  Alcotest.check Alcotest.string "Run_service encode" "archivist"
    (Model.to_string Model.Archivist);
  Alcotest.check Alcotest.bool "Run_service decode" true
    (Model.of_string "archivist" = Some Model.Archivist);
  Alcotest.check Alcotest.string "Run_service encode" "dispatcher"
    (Model.to_string Model.Dispatcher);
  Alcotest.check Alcotest.bool "Run_service decode" true
    (Model.of_string "dispatcher" = Some Model.Dispatcher);
  Alcotest.check Alcotest.string "Run_service encode" "gateway"
    (Model.to_string Model.Gateway);
  Alcotest.check Alcotest.bool "Run_service decode" true
    (Model.of_string "gateway" = Some Model.Gateway);
  Alcotest.check Alcotest.string "Run_service encode" "librarian"
    (Model.to_string Model.Librarian);
  Alcotest.check Alcotest.bool "Run_service decode" true
    (Model.of_string "librarian" = Some Model.Librarian);
  Alcotest.check Alcotest.string "Run_service encode" "smelter"
    (Model.to_string Model.Smelter);
  Alcotest.check Alcotest.bool "Run_service decode" true
    (Model.of_string "smelter" = Some Model.Smelter);
  Alcotest.check Alcotest.string "Run_service encode" "weaver"
    (Model.to_string Model.Weaver);
  Alcotest.check Alcotest.bool "Run_service decode" true
    (Model.of_string "weaver" = Some Model.Weaver);
  Alcotest.check Alcotest.string "Run_service encode" "worker"
    (Model.to_string Model.Worker);
  Alcotest.check Alcotest.bool "Run_service decode" true
    (Model.of_string "worker" = Some Model.Worker);
  Alcotest.check Alcotest.bool "Run_service rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Runtime in
  Alcotest.check Alcotest.string "Runtime encode" "container"
    (Model.to_string Model.Container);
  Alcotest.check Alcotest.bool "Runtime decode" true
    (Model.of_string "container" = Some Model.Container);
  Alcotest.check Alcotest.string "Runtime encode" "docker"
    (Model.to_string Model.Docker);
  Alcotest.check Alcotest.bool "Runtime decode" true
    (Model.of_string "docker" = Some Model.Docker);
  Alcotest.check Alcotest.string "Runtime encode" "podman"
    (Model.to_string Model.Podman);
  Alcotest.check Alcotest.bool "Runtime decode" true
    (Model.of_string "podman" = Some Model.Podman);
  Alcotest.check Alcotest.bool "Runtime rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Service_group in
  Alcotest.check Alcotest.string "Service_group encode" "record"
    (Model.to_string Model.Record);
  Alcotest.check Alcotest.bool "Service_group decode" true
    (Model.of_string "record" = Some Model.Record);
  Alcotest.check Alcotest.string "Service_group encode" "index"
    (Model.to_string Model.Index);
  Alcotest.check Alcotest.bool "Service_group decode" true
    (Model.of_string "index" = Some Model.Index);
  Alcotest.check Alcotest.string "Service_group encode" "issuer"
    (Model.to_string Model.Issuer);
  Alcotest.check Alcotest.bool "Service_group decode" true
    (Model.of_string "issuer" = Some Model.Issuer);
  Alcotest.check Alcotest.string "Service_group encode" "knowledge-workers"
    (Model.to_string Model.Knowledge_workers);
  Alcotest.check Alcotest.bool "Service_group decode" true
    (Model.of_string "knowledge-workers" = Some Model.Knowledge_workers);
  Alcotest.check Alcotest.string "Service_group encode" "providers"
    (Model.to_string Model.Providers);
  Alcotest.check Alcotest.bool "Service_group decode" true
    (Model.of_string "providers" = Some Model.Providers);
  Alcotest.check Alcotest.string "Service_group encode" "telemetry"
    (Model.to_string Model.Telemetry);
  Alcotest.check Alcotest.bool "Service_group decode" true
    (Model.of_string "telemetry" = Some Model.Telemetry);
  Alcotest.check Alcotest.bool "Service_group rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Stack_api_version in
  Alcotest.check Alcotest.string "Stack_api_version encode"
    "xynolog.org/v1alpha1"
    (Model.to_string Model.Xynolog_org_v1alpha1);
  Alcotest.check Alcotest.bool "Stack_api_version decode" true
    (Model.of_string "xynolog.org/v1alpha1" = Some Model.Xynolog_org_v1alpha1);
  Alcotest.check Alcotest.bool "Stack_api_version rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Supported_media_type in
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/plain"
    (Model.to_string Model.Text_plain);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/plain" = Some Model.Text_plain);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/markdown"
    (Model.to_string Model.Text_markdown);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/markdown" = Some Model.Text_markdown);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/html"
    (Model.to_string Model.Text_html);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/html" = Some Model.Text_html);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/css"
    (Model.to_string Model.Text_css);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/css" = Some Model.Text_css);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/csv"
    (Model.to_string Model.Text_csv);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/csv" = Some Model.Text_csv);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/xml"
    (Model.to_string Model.Text_xml);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/xml" = Some Model.Text_xml);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/json"
    (Model.to_string Model.Application_json);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/json" = Some Model.Application_json);
  Alcotest.check Alcotest.string "Supported_media_type encode" "application/xml"
    (Model.to_string Model.Application_xml);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/xml" = Some Model.Application_xml);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/yaml"
    (Model.to_string Model.Application_yaml);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/yaml" = Some Model.Application_yaml);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/x-yaml"
    (Model.to_string Model.Application_x_yaml);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/x-yaml" = Some Model.Application_x_yaml);
  Alcotest.check Alcotest.string "Supported_media_type encode" "application/pdf"
    (Model.to_string Model.Application_pdf);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/pdf" = Some Model.Application_pdf);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/msword"
    (Model.to_string Model.Application_msword);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/msword" = Some Model.Application_msword);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    (Model.to_string
       Model
       .Application_vnd_openxmlformats_officedocument_wordprocessingml_document);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string
       "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    = Some
        Model
        .Application_vnd_openxmlformats_officedocument_wordprocessingml_document
    );
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/vnd.ms-excel"
    (Model.to_string Model.Application_vnd_ms_excel);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/vnd.ms-excel"
    = Some Model.Application_vnd_ms_excel);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    (Model.to_string
       Model.Application_vnd_openxmlformats_officedocument_spreadsheetml_sheet);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string
       "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    = Some
        Model.Application_vnd_openxmlformats_officedocument_spreadsheetml_sheet
    );
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/vnd.ms-powerpoint"
    (Model.to_string Model.Application_vnd_ms_powerpoint);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/vnd.ms-powerpoint"
    = Some Model.Application_vnd_ms_powerpoint);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    (Model.to_string
       Model
       .Application_vnd_openxmlformats_officedocument_presentationml_presentation);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string
       "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    = Some
        Model
        .Application_vnd_openxmlformats_officedocument_presentationml_presentation
    );
  Alcotest.check Alcotest.string "Supported_media_type encode" "application/zip"
    (Model.to_string Model.Application_zip);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/zip" = Some Model.Application_zip);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/gzip"
    (Model.to_string Model.Application_gzip);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/gzip" = Some Model.Application_gzip);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/x-tar"
    (Model.to_string Model.Application_x_tar);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/x-tar" = Some Model.Application_x_tar);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/x-7z-compressed"
    (Model.to_string Model.Application_x_7z_compressed);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/x-7z-compressed"
    = Some Model.Application_x_7z_compressed);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/octet-stream"
    (Model.to_string Model.Application_octet_stream);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/octet-stream"
    = Some Model.Application_octet_stream);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/wasm"
    (Model.to_string Model.Application_wasm);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/wasm" = Some Model.Application_wasm);
  Alcotest.check Alcotest.string "Supported_media_type encode" "image/png"
    (Model.to_string Model.Image_png);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "image/png" = Some Model.Image_png);
  Alcotest.check Alcotest.string "Supported_media_type encode" "image/jpeg"
    (Model.to_string Model.Image_jpeg);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "image/jpeg" = Some Model.Image_jpeg);
  Alcotest.check Alcotest.string "Supported_media_type encode" "image/gif"
    (Model.to_string Model.Image_gif);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "image/gif" = Some Model.Image_gif);
  Alcotest.check Alcotest.string "Supported_media_type encode" "image/webp"
    (Model.to_string Model.Image_webp);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "image/webp" = Some Model.Image_webp);
  Alcotest.check Alcotest.string "Supported_media_type encode" "image/svg+xml"
    (Model.to_string Model.Image_svg_plusxml);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "image/svg+xml" = Some Model.Image_svg_plusxml);
  Alcotest.check Alcotest.string "Supported_media_type encode" "image/bmp"
    (Model.to_string Model.Image_bmp);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "image/bmp" = Some Model.Image_bmp);
  Alcotest.check Alcotest.string "Supported_media_type encode" "image/tiff"
    (Model.to_string Model.Image_tiff);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "image/tiff" = Some Model.Image_tiff);
  Alcotest.check Alcotest.string "Supported_media_type encode" "image/x-icon"
    (Model.to_string Model.Image_x_icon);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "image/x-icon" = Some Model.Image_x_icon);
  Alcotest.check Alcotest.string "Supported_media_type encode" "video/mp4"
    (Model.to_string Model.Video_mp4);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "video/mp4" = Some Model.Video_mp4);
  Alcotest.check Alcotest.string "Supported_media_type encode" "video/mpeg"
    (Model.to_string Model.Video_mpeg);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "video/mpeg" = Some Model.Video_mpeg);
  Alcotest.check Alcotest.string "Supported_media_type encode" "video/webm"
    (Model.to_string Model.Video_webm);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "video/webm" = Some Model.Video_webm);
  Alcotest.check Alcotest.string "Supported_media_type encode" "video/ogg"
    (Model.to_string Model.Video_ogg);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "video/ogg" = Some Model.Video_ogg);
  Alcotest.check Alcotest.string "Supported_media_type encode" "video/quicktime"
    (Model.to_string Model.Video_quicktime);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "video/quicktime" = Some Model.Video_quicktime);
  Alcotest.check Alcotest.string "Supported_media_type encode" "video/x-msvideo"
    (Model.to_string Model.Video_x_msvideo);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "video/x-msvideo" = Some Model.Video_x_msvideo);
  Alcotest.check Alcotest.string "Supported_media_type encode" "audio/mpeg"
    (Model.to_string Model.Audio_mpeg);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "audio/mpeg" = Some Model.Audio_mpeg);
  Alcotest.check Alcotest.string "Supported_media_type encode" "audio/wav"
    (Model.to_string Model.Audio_wav);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "audio/wav" = Some Model.Audio_wav);
  Alcotest.check Alcotest.string "Supported_media_type encode" "audio/ogg"
    (Model.to_string Model.Audio_ogg);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "audio/ogg" = Some Model.Audio_ogg);
  Alcotest.check Alcotest.string "Supported_media_type encode" "audio/webm"
    (Model.to_string Model.Audio_webm);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "audio/webm" = Some Model.Audio_webm);
  Alcotest.check Alcotest.string "Supported_media_type encode" "audio/aac"
    (Model.to_string Model.Audio_aac);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "audio/aac" = Some Model.Audio_aac);
  Alcotest.check Alcotest.string "Supported_media_type encode" "audio/flac"
    (Model.to_string Model.Audio_flac);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "audio/flac" = Some Model.Audio_flac);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/javascript"
    (Model.to_string Model.Text_javascript);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/javascript" = Some Model.Text_javascript);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/javascript"
    (Model.to_string Model.Application_javascript);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/javascript"
    = Some Model.Application_javascript);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "text/x-typescript"
    (Model.to_string Model.Text_x_typescript);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/x-typescript" = Some Model.Text_x_typescript);
  Alcotest.check Alcotest.string "Supported_media_type encode"
    "application/typescript"
    (Model.to_string Model.Application_typescript);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "application/typescript"
    = Some Model.Application_typescript);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/x-python"
    (Model.to_string Model.Text_x_python);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/x-python" = Some Model.Text_x_python);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/x-java"
    (Model.to_string Model.Text_x_java);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/x-java" = Some Model.Text_x_java);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/x-c"
    (Model.to_string Model.Text_x_c);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/x-c" = Some Model.Text_x_c);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/x-c++"
    (Model.to_string Model.Text_x_c_plus_plus);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/x-c++" = Some Model.Text_x_c_plus_plus);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/x-csharp"
    (Model.to_string Model.Text_x_csharp);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/x-csharp" = Some Model.Text_x_csharp);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/x-go"
    (Model.to_string Model.Text_x_go);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/x-go" = Some Model.Text_x_go);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/x-rust"
    (Model.to_string Model.Text_x_rust);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/x-rust" = Some Model.Text_x_rust);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/x-ruby"
    (Model.to_string Model.Text_x_ruby);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/x-ruby" = Some Model.Text_x_ruby);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/x-php"
    (Model.to_string Model.Text_x_php);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/x-php" = Some Model.Text_x_php);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/x-swift"
    (Model.to_string Model.Text_x_swift);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/x-swift" = Some Model.Text_x_swift);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/x-kotlin"
    (Model.to_string Model.Text_x_kotlin);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/x-kotlin" = Some Model.Text_x_kotlin);
  Alcotest.check Alcotest.string "Supported_media_type encode" "text/x-shell"
    (Model.to_string Model.Text_x_shell);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "text/x-shell" = Some Model.Text_x_shell);
  Alcotest.check Alcotest.string "Supported_media_type encode" "font/woff"
    (Model.to_string Model.Font_woff);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "font/woff" = Some Model.Font_woff);
  Alcotest.check Alcotest.string "Supported_media_type encode" "font/woff2"
    (Model.to_string Model.Font_woff2);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "font/woff2" = Some Model.Font_woff2);
  Alcotest.check Alcotest.string "Supported_media_type encode" "font/ttf"
    (Model.to_string Model.Font_ttf);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "font/ttf" = Some Model.Font_ttf);
  Alcotest.check Alcotest.string "Supported_media_type encode" "font/otf"
    (Model.to_string Model.Font_otf);
  Alcotest.check Alcotest.bool "Supported_media_type decode" true
    (Model.of_string "font/otf" = Some Model.Font_otf);
  Alcotest.check Alcotest.bool "Supported_media_type rejects unknown values"
    true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.System in
  Alcotest.check Alcotest.string "System encode" "macos"
    (Model.to_string Model.Macos);
  Alcotest.check Alcotest.bool "System decode" true
    (Model.of_string "macos" = Some Model.Macos);
  Alcotest.check Alcotest.string "System encode" "windows"
    (Model.to_string Model.Windows);
  Alcotest.check Alcotest.bool "System decode" true
    (Model.of_string "windows" = Some Model.Windows);
  Alcotest.check Alcotest.string "System encode" "other"
    (Model.to_string Model.Other);
  Alcotest.check Alcotest.bool "System decode" true
    (Model.of_string "other" = Some Model.Other);
  Alcotest.check Alcotest.bool "System rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Anchor_method in
  Alcotest.check Alcotest.string "Anchor_method encode" "unique-match"
    (Model.to_string Model.Unique_match);
  Alcotest.check Alcotest.bool "Anchor_method decode" true
    (Model.of_string "unique-match" = Some Model.Unique_match);
  Alcotest.check Alcotest.string "Anchor_method encode" "context-recovered"
    (Model.to_string Model.Context_recovered);
  Alcotest.check Alcotest.bool "Anchor_method decode" true
    (Model.of_string "context-recovered" = Some Model.Context_recovered);
  Alcotest.check Alcotest.string "Anchor_method encode" "first-of-many"
    (Model.to_string Model.First_of_many);
  Alcotest.check Alcotest.bool "Anchor_method decode" true
    (Model.of_string "first-of-many" = Some Model.First_of_many);
  Alcotest.check Alcotest.string "Anchor_method encode" "fuzzy-match"
    (Model.to_string Model.Fuzzy_match);
  Alcotest.check Alcotest.bool "Anchor_method decode" true
    (Model.of_string "fuzzy-match" = Some Model.Fuzzy_match);
  Alcotest.check Alcotest.bool "Anchor_method rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Cache_status in
  Alcotest.check Alcotest.string "Cache_status encode" "pending"
    (Model.to_string Model.Pending);
  Alcotest.check Alcotest.bool "Cache_status decode" true
    (Model.of_string "pending" = Some Model.Pending);
  Alcotest.check Alcotest.string "Cache_status encode" "ready"
    (Model.to_string Model.Ready);
  Alcotest.check Alcotest.bool "Cache_status decode" true
    (Model.of_string "ready" = Some Model.Ready);
  Alcotest.check Alcotest.string "Cache_status encode" "failed"
    (Model.to_string Model.Failed);
  Alcotest.check Alcotest.bool "Cache_status decode" true
    (Model.of_string "failed" = Some Model.Failed);
  Alcotest.check Alcotest.bool "Cache_status rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Connection_state in
  Alcotest.check Alcotest.string "Connection_state encode" "initial"
    (Model.to_string Model.Initial);
  Alcotest.check Alcotest.bool "Connection_state decode" true
    (Model.of_string "initial" = Some Model.Initial);
  Alcotest.check Alcotest.string "Connection_state encode" "connecting"
    (Model.to_string Model.Connecting);
  Alcotest.check Alcotest.bool "Connection_state decode" true
    (Model.of_string "connecting" = Some Model.Connecting);
  Alcotest.check Alcotest.string "Connection_state encode" "open"
    (Model.to_string Model.Open);
  Alcotest.check Alcotest.bool "Connection_state decode" true
    (Model.of_string "open" = Some Model.Open);
  Alcotest.check Alcotest.string "Connection_state encode" "reconnecting"
    (Model.to_string Model.Reconnecting);
  Alcotest.check Alcotest.bool "Connection_state decode" true
    (Model.of_string "reconnecting" = Some Model.Reconnecting);
  Alcotest.check Alcotest.string "Connection_state encode" "degraded"
    (Model.to_string Model.Degraded);
  Alcotest.check Alcotest.bool "Connection_state decode" true
    (Model.of_string "degraded" = Some Model.Degraded);
  Alcotest.check Alcotest.string "Connection_state encode" "unauthenticated"
    (Model.to_string Model.Unauthenticated);
  Alcotest.check Alcotest.bool "Connection_state decode" true
    (Model.of_string "unauthenticated" = Some Model.Unauthenticated);
  Alcotest.check Alcotest.string "Connection_state encode" "closed"
    (Model.to_string Model.Closed);
  Alcotest.check Alcotest.bool "Connection_state decode" true
    (Model.of_string "closed" = Some Model.Closed);
  Alcotest.check Alcotest.bool "Connection_state rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Frame_refusal_reason in
  Alcotest.check Alcotest.string "Frame_refusal_reason encode" "lacks"
    (Model.to_string Model.Lacks);
  Alcotest.check Alcotest.bool "Frame_refusal_reason decode" true
    (Model.of_string "lacks" = Some Model.Lacks);
  Alcotest.check Alcotest.string "Frame_refusal_reason encode" "malformed"
    (Model.to_string Model.Malformed);
  Alcotest.check Alcotest.bool "Frame_refusal_reason decode" true
    (Model.of_string "malformed" = Some Model.Malformed);
  Alcotest.check Alcotest.bool "Frame_refusal_reason rejects unknown values"
    true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Match_quality in
  Alcotest.check Alcotest.string "Match_quality encode" "normalized"
    (Model.to_string Model.Normalized);
  Alcotest.check Alcotest.bool "Match_quality decode" true
    (Model.of_string "normalized" = Some Model.Normalized);
  Alcotest.check Alcotest.string "Match_quality encode" "case-insensitive"
    (Model.to_string Model.Case_insensitive);
  Alcotest.check Alcotest.bool "Match_quality decode" true
    (Model.of_string "case-insensitive" = Some Model.Case_insensitive);
  Alcotest.check Alcotest.string "Match_quality encode" "fuzzy"
    (Model.to_string Model.Fuzzy);
  Alcotest.check Alcotest.bool "Match_quality decode" true
    (Model.of_string "fuzzy" = Some Model.Fuzzy);
  Alcotest.check Alcotest.bool "Match_quality rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Discovery_absent_reason in
  Alcotest.check Alcotest.string "Discovery_absent_reason encode" "not-found"
    (Model.to_string Model.Not_found);
  Alcotest.check Alcotest.bool "Discovery_absent_reason decode" true
    (Model.of_string "not-found" = Some Model.Not_found);
  Alcotest.check Alcotest.string "Discovery_absent_reason encode" "not-json"
    (Model.to_string Model.Not_json);
  Alcotest.check Alcotest.bool "Discovery_absent_reason decode" true
    (Model.of_string "not-json" = Some Model.Not_json);
  Alcotest.check Alcotest.string "Discovery_absent_reason encode" "invalid"
    (Model.to_string Model.Invalid);
  Alcotest.check Alcotest.bool "Discovery_absent_reason decode" true
    (Model.of_string "invalid" = Some Model.Invalid);
  Alcotest.check Alcotest.string "Discovery_absent_reason encode"
    "unsupported-version"
    (Model.to_string Model.Unsupported_version);
  Alcotest.check Alcotest.bool "Discovery_absent_reason decode" true
    (Model.of_string "unsupported-version" = Some Model.Unsupported_version);
  Alcotest.check Alcotest.string "Discovery_absent_reason encode" "unreadable"
    (Model.to_string Model.Unreadable);
  Alcotest.check Alcotest.bool "Discovery_absent_reason decode" true
    (Model.of_string "unreadable" = Some Model.Unreadable);
  Alcotest.check Alcotest.bool "Discovery_absent_reason rejects unknown values"
    true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Kb_session_status in
  Alcotest.check Alcotest.string "Kb_session_status encode" "authenticated"
    (Model.to_string Model.Authenticated);
  Alcotest.check Alcotest.bool "Kb_session_status decode" true
    (Model.of_string "authenticated" = Some Model.Authenticated);
  Alcotest.check Alcotest.string "Kb_session_status encode" "expired"
    (Model.to_string Model.Expired);
  Alcotest.check Alcotest.bool "Kb_session_status decode" true
    (Model.of_string "expired" = Some Model.Expired);
  Alcotest.check Alcotest.string "Kb_session_status encode" "signed-out"
    (Model.to_string Model.Signed_out);
  Alcotest.check Alcotest.bool "Kb_session_status decode" true
    (Model.of_string "signed-out" = Some Model.Signed_out);
  Alcotest.check Alcotest.bool "Kb_session_status rejects unknown values" true
    (Model.of_string "" = None);
  let module Model = Xynolog.Enums.Session_end_reason in
  Alcotest.check Alcotest.string "Session_end_reason encode" "expired"
    (Model.to_string Model.Expired);
  Alcotest.check Alcotest.bool "Session_end_reason decode" true
    (Model.of_string "expired" = Some Model.Expired);
  Alcotest.check Alcotest.string "Session_end_reason encode" "refused"
    (Model.to_string Model.Refused);
  Alcotest.check Alcotest.bool "Session_end_reason decode" true
    (Model.of_string "refused" = Some Model.Refused);
  Alcotest.check Alcotest.bool "Session_end_reason rejects unknown values" true
    (Model.of_string "" = None);
  ()
