(* Generated from protocol/specs/src/archivist/openapi.json and its paths. Do not edit.
   Regenerate: make generate (codegen/lib/gateway_http/ocaml.ml) *)

let get_health = ("GET", "/health")
let list_streams = ("GET", "/events")
let get_resource_events = ("GET", "/events/{resourceId}")
let store_resource = ("POST", "/resources")
let get_resource_content = ("GET", "/resources/{id}/content")
let get_resource_json_ld = ("GET", "/resources/{id}/jsonld")
let get_resource_annotations = ("GET", "/resources/{id}/annotations")
let get_resource_anchored_text = ("GET", "/resources/{id}/anchored-text")
let put_resource_anchored_text = ("PUT", "/resources/{id}/anchored-text")
let list_anchored_text_entries = ("GET", "/anchored-text/entries")

let get_stored_resource_anchored_text =
  ("GET", "/resources/{id}/anchored-text/stored")

let put_anchored_text_stamp = ("PUT", "/anchored-text/stamp")
