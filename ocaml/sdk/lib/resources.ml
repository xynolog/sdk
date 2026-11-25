let primary_representation model =
  match (Records.Resource_descriptor.of_model model).representations with
  | Records.Resource_descriptor_representations.Representation one -> Some one
  | List (first :: _) -> Some first
  | List [] -> None

let primary_media_type model =
  Option.map
    (fun (r : Records.Representation.t) -> r.media_type)
    (primary_representation model)

let entity_types model =
  let fields = Records.Resource_descriptor.of_model model in
  Option.value fields.entity_types ~default:[]

let resource_text client id =
  Result.map
    (fun (content_type, bytes) -> Text_encoding.decode ~content_type bytes)
    (Browse.resource_content client id)
