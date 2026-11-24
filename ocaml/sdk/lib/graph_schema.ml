(* Generated from protocol/specs/src/graph/schema.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type resource = {
  label : string;
  row : string option;
  key : string;
  lookups : string list;
}

let resource_json (r : resource) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("label", (fun s -> `String s) r.label);
         Option.map (fun v -> ("row", (fun s -> `String s) v)) r.row;
         Option.Some ("key", (fun s -> `String s) r.key);
         Option.Some
           ( "lookups",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.lookups );
       ])

type nodes = {
  resource : resource;
  annotation : resource;
  entity_type : resource;
}

let nodes_json (r : nodes) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("resource", resource_json r.resource);
         Option.Some ("annotation", resource_json r.annotation);
         Option.Some ("entityType", resource_json r.entity_type);
       ])

type belongs_to = { type_ : string; from : string; to_ : string; says : string }

let belongs_to_json (r : belongs_to) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("type", (fun s -> `String s) r.type_);
         Option.Some ("from", (fun s -> `String s) r.from);
         Option.Some ("to", (fun s -> `String s) r.to_);
         Option.Some ("says", (fun s -> `String s) r.says);
       ])

type relationships = {
  belongs_to : belongs_to;
  references : belongs_to;
  tagged_as : belongs_to;
}

let relationships_json (r : relationships) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("belongsTo", belongs_to_json r.belongs_to);
         Option.Some ("references", belongs_to_json r.references);
         Option.Some ("taggedAs", belongs_to_json r.tagged_as);
       ])

type stub = { node : string; marker : string }

let stub_json (r : stub) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("node", (fun s -> `String s) r.node);
         Option.Some ("marker", (fun s -> `String s) r.marker);
       ])

type t = {
  comment : string;
  nodes : nodes;
  relationships : relationships;
  stub : stub;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some ("nodes", nodes_json r.nodes);
         Option.Some ("relationships", relationships_json r.relationships);
         Option.Some ("stub", stub_json r.stub);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for the shape of the graph every store keeps (WEAVER.md \
        \194\167 What the graph holds), as a reader of a store finds it: each \
        kind of node by its label, the property it is one of its kind by \
        (`key`) and the properties a reader finds one by (`lookups`); each \
        kind of relationship by its type, the kind of node it goes from and \
        the kind it goes to; and the stub. What a node holds is its codec row, \
        the `properties` and `json` of graph/codec-cases.json's part that \
        `row` names; a node without a row holds its key alone. How a store \
        spells a node, a list or a property is its own dialect, as \
        graph/codec-cases.json says of a row. A link's target the graph has \
        not been given yet is a stub: a node holding its key and the marker, \
        `true`, and nothing else. It is not a resource the graph holds: no \
        read answers it, lists it, counts it or follows it. Storing the \
        resource fills it in, and the marker goes. A store makes what else it \
        likes of its own, such as a second label or an index; no reader reads \
        it.";
     nodes =
       ({
          resource =
            ({
               label = "Resource";
               row = Some "resourceStored";
               key = "id";
               lookups = [ "name"; "entityTypes" ];
             }
              : resource);
          annotation =
            ({
               label = "Annotation";
               row = Some "annotationStored";
               key = "id";
               lookups = [ "resourceId" ];
             }
              : resource);
          entity_type =
            ({ label = "EntityType"; row = None; key = "name"; lookups = [] }
              : resource);
        }
         : nodes);
     relationships =
       ({
          belongs_to =
            ({
               type_ = "BELONGS_TO";
               from = "annotation";
               to_ = "resource";
               says =
                 "The resource the annotation is on, the one its row's \
                  `resourceId` names. An annotation has one.";
             }
              : belongs_to);
          references =
            ({
               type_ = "REFERENCES";
               from = "annotation";
               to_ = "resource";
               says =
                 "The resource the annotation links to, the one its row's \
                  `source` names, held or a stub. An annotation has one where \
                  its row has a `source`, and none where it has not.";
             }
              : belongs_to);
          tagged_as =
            ({
               type_ = "TAGGED_AS";
               from = "annotation";
               to_ = "entityType";
               says =
                 "One of the annotation's entity tags, the entity type of that \
                  name. An annotation has one to each of its tags.";
             }
              : belongs_to);
        }
         : relationships);
     stub = ({ node = "resource"; marker = "stub" } : stub);
   }
    : t)
