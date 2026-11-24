//! Bytes over the gateway's HTTP transport, as
//! `xynolog::transport::ContentTransport`: an upload (`POST /resources`), a
//! resource's bytes whole or as a stream (`GET /resources/{id}`), its
//! description as linked data (`GET /resources/{id}/jsonld`), its
//! annotations (`GET /resources/{id}/annotations`), and its anchored text
//! (`GET /resources/{id}/anchored-text`). Bytes never ride the bus.
//!
//! It uses the bus transport's token, its retry rule and its error stream,
//! so a request here is refused, renewed and reported as any other. An
//! upload carries one `Idempotency-Key`, the same on every sending of it, as
//! an emit does, and so is sent once more, as a read is, when the gateway
//! answered it with a status that promises recovery or did not answer at
//! all. Every sending is the same key, fields and bytes. Each request is
//! logged (`[bus PUT]`, `[bus GET]`) and made
//! in a client span (`content.put`, `content.get`, `content.get_graph`,
//! `content.get_annotations`, `content.get_anchored_text`).

use crate::transport::{HttpTransport, Shared, idempotency_key, method_of};
use bytes::Bytes;
use futures::StreamExt;
use serde_json::json;
use std::sync::Arc;
use std::sync::atomic::{AtomicU64, Ordering};
use tokio::sync::mpsc;
use xynolog::bus_log::bus_log;
use xynolog::errors::{TransportError, TransportErrorCode};
use xynolog::gateway_http::{
    GET_RESOURCE_ANCHORED_TEXT, GET_RESOURCE_ANNOTATIONS, GET_RESOURCE_JSON_LD,
    GET_RESOURCE_REPRESENTATION, IDEMPOTENCY_KEY, UPLOAD_RESOURCE, UploadField,
};
use xynolog::transport::{
    BoxFuture, Content, ContentStream, ContentTransport, PutBinaryRequest, Upload,
};
use xynolog::types::AnchoredTextAnswer;
use xynolog::types::GetAnnotationsResponse;
use xynolog::types::GetResourceResponse;
use xynolog::types::ResourceId;
use xynolog::types::{AnnotationId, JobId};
use xynolog::types::{UploadProgress, UploadProgressProgress, UploadProgressStarted};

/// How much of an upload's body is handed to the connection at a time: the
/// grain its progress is reported in.
const UPLOAD_CHUNK: usize = 64 * 1024;

pub struct HttpContentTransport {
    shared: Arc<Shared>,
}

impl HttpContentTransport {
    /// Content over the gateway `transport` speaks to.
    pub fn new(transport: &HttpTransport) -> HttpContentTransport {
        HttpContentTransport {
            shared: transport.shared().clone(),
        }
    }
}

/// A `multipart/form-data` body: each field under its own name, and the
/// bytes as the part `file`.
struct Form {
    boundary: String,
    /// The parts before the file's bytes, the bytes, and what follows them.
    parts: [Bytes; 3],
}

/// What an upload sends as a member's text, if anything: the file is its
/// bytes, sent between the members every upload sends and the others. Every
/// member of `ResourceUpload` is named, so one it gains or loses does not
/// compile.
fn sent(request: &PutBinaryRequest, member: UploadField) -> Option<String> {
    let stated = |value: Option<&str>| value.filter(|value| !value.is_empty()).map(str::to_owned);
    match member {
        UploadField::Name => Some(request.name.to_string()),
        UploadField::File => None,
        UploadField::Format => Some(request.format.to_string()),
        UploadField::StorageUri => Some(request.storage_uri.to_string()),
        UploadField::Language => stated(request.language.as_deref()),
        UploadField::EntityTypes => {
            (!request.entity_types.is_empty()).then(|| json!(request.entity_types).to_string())
        }
        UploadField::SourceAnnotationId => stated(
            request
                .source_annotation_id
                .as_ref()
                .map(AnnotationId::as_str),
        ),
        UploadField::SourceResourceId => {
            stated(request.source_resource_id.as_ref().map(ResourceId::as_str))
        }
        UploadField::GenerationPrompt => stated(request.generation_prompt.as_deref()),
        UploadField::Generator => request.generator.as_ref().map(ToString::to_string),
        UploadField::JobId => stated(request.job_id.as_ref().map(JobId::as_str)),
        UploadField::IsDraft => request.is_draft.map(|value| value.to_string()),
        UploadField::CloneToken => stated(request.clone_token.as_deref()),
        UploadField::ArchiveOriginal => request.archive_original.map(|value| value.to_string()),
    }
}

impl Form {
    fn of(request: &PutBinaryRequest) -> Form {
        let boundary = format!("xynolog-{}", uuid::Uuid::new_v4().simple());
        let field = |name: &str, value: &str| {
            format!(
                "--{boundary}\r\nContent-Disposition: form-data; name=\"{name}\"\r\n\r\n{value}\r\n"
            )
        };
        let quoted = |text: &str| text.replace('\\', "\\\\").replace('"', "\\\"");
        let mut before = String::new();
        let mut after = String::from("\r\n");
        let (every, others): (Vec<_>, Vec<_>) = UploadField::ALL
            .into_iter()
            .partition(|member| member.required());
        for member in every
            .into_iter()
            .filter(|member| *member != UploadField::File)
        {
            if let Some(value) = sent(request, member) {
                before.push_str(&field(member.name(), &value));
            }
        }
        before.push_str(&format!(
            "--{boundary}\r\nContent-Disposition: form-data; name=\"{}\"; filename=\"{}\"\r\nContent-Type: {}\r\n\r\n",
            UploadField::File.name(),
            quoted(&request.name),
            request.format
        ));
        for member in others {
            if let Some(value) = sent(request, member) {
                after.push_str(&field(member.name(), &value));
            }
        }
        after.push_str(&format!("--{boundary}--\r\n"));
        Form {
            boundary,
            parts: [
                Bytes::from(before),
                request.bytes.clone(),
                Bytes::from(after),
            ],
        }
    }

    fn len(&self) -> u64 {
        self.parts.iter().map(|part| part.len() as u64).sum()
    }

    /// The body as it is sent: a piece at a time, each reported to `progress`
    /// as it is handed to the connection. `reported` is how much of this
    /// upload has been reported sent: a sending that repeats an earlier one
    /// reports nothing until it has passed that.
    fn body(
        &self,
        progress: mpsc::UnboundedSender<UploadProgress>,
        reported: Arc<AtomicU64>,
    ) -> reqwest::Body {
        let total_bytes = self.len();
        let pieces: Vec<Bytes> = self
            .parts
            .iter()
            .flat_map(|part| {
                (0..part.len())
                    .step_by(UPLOAD_CHUNK)
                    .map(|start| part.slice(start..part.len().min(start + UPLOAD_CHUNK)))
                    .collect::<Vec<_>>()
            })
            .collect();
        let mut bytes_uploaded = 0;
        reqwest::Body::wrap_stream(futures::stream::iter(pieces).map(move |piece| {
            bytes_uploaded += piece.len() as u64;
            if reported.fetch_max(bytes_uploaded, Ordering::Relaxed) < bytes_uploaded {
                let _ = progress.send(UploadProgress::Progress(UploadProgressProgress::new(
                    bytes_uploaded,
                    total_bytes,
                )));
            }
            Ok::<Bytes, std::convert::Infallible>(piece)
        }))
    }
}

impl ContentTransport for HttpContentTransport {
    fn put_binary(&self, request: PutBinaryRequest) -> Upload {
        let shared = self.shared.clone();
        let (progress, reports) = mpsc::unbounded_channel();
        let reported = Arc::new(AtomicU64::new(0));
        let sending = async move {
            let size = request.bytes.len();
            bus_log(
                "PUT",
                "content",
                &json!({
                    "name": request.name,
                    "format": request.format,
                    "storageUri": request.storage_uri,
                    "sizeBytes": size,
                }),
                None,
                None,
            );
            let form = Form::of(&request);
            // Once, before the first sending: one that repeats it does not
            // start the upload again.
            let _ = progress.send(UploadProgress::Started(UploadProgressStarted::new(
                form.len(),
            )));
            let key = idempotency_key();
            xynolog_telemetry::content_put(
                &request.format,
                size as u64,
                shared.answer_at_length(
                    method_of(&UPLOAD_RESOURCE),
                    UPLOAD_RESOURCE.path,
                    true,
                    |builder| {
                        let builder = match UPLOAD_RESOURCE.sends {
                            Some(media) => builder.header(
                                reqwest::header::CONTENT_TYPE,
                                format!("{media}; boundary={}", form.boundary),
                            ),
                            None => builder,
                        };
                        builder
                            .header(reqwest::header::CONTENT_LENGTH, form.len())
                            .header(IDEMPOTENCY_KEY, key.as_str())
                            .body(form.body(progress.clone(), reported.clone()))
                    },
                ),
            )
            .await
        };
        Upload::new(reports, Box::pin(sending))
    }

    fn get_binary<'a>(
        &'a self,
        resource_id: &'a ResourceId,
    ) -> BoxFuture<'a, Result<Content, TransportError>> {
        Box::pin(async move {
            bus_log(
                "GET",
                "content",
                &json!({ "resourceId": resource_id }),
                None,
                None,
            );
            xynolog_telemetry::content_get(resource_id, false, async {
                let response = self.read(resource_id).await?;
                let content_type = content_type(&response);
                let bytes = response
                    .bytes()
                    .await
                    .map_err(|error| self.shared.failed(interrupted(resource_id, &error)))?;
                Ok(Content {
                    bytes,
                    content_type,
                })
            })
            .await
        })
    }

    fn get_binary_stream<'a>(
        &'a self,
        resource_id: &'a ResourceId,
    ) -> BoxFuture<'a, Result<ContentStream, TransportError>> {
        Box::pin(async move {
            bus_log(
                "GET",
                "content",
                &json!({ "resourceId": resource_id, "stream": true }),
                None,
                None,
            );
            xynolog_telemetry::content_get(resource_id, true, async {
                let response = self.read(resource_id).await?;
                let content_type = content_type(&response);
                let resource = resource_id.clone();
                let shared = self.shared.clone();
                let bytes = response.bytes_stream().map(move |read| {
                    read.map_err(|error| shared.failed(interrupted(&resource, &error)))
                });
                Ok(ContentStream {
                    bytes: Box::pin(bytes),
                    content_type,
                })
            })
            .await
        })
    }

    fn get_resource_graph<'a>(
        &'a self,
        resource_id: &'a ResourceId,
    ) -> BoxFuture<'a, Result<GetResourceResponse, TransportError>> {
        Box::pin(async move {
            bus_log(
                "GET",
                "content",
                &json!({ "resourceId": resource_id, "graph": true }),
                None,
                None,
            );
            xynolog_telemetry::content_get_graph(
                resource_id,
                self.shared.answer(
                    method_of(&GET_RESOURCE_JSON_LD),
                    &GET_RESOURCE_JSON_LD.path_for(resource_id),
                    true,
                    |builder| builder,
                ),
            )
            .await
        })
    }

    fn get_annotations<'a>(
        &'a self,
        resource_id: &'a ResourceId,
    ) -> BoxFuture<'a, Result<GetAnnotationsResponse, TransportError>> {
        Box::pin(async move {
            bus_log(
                "GET",
                "content",
                &json!({ "resourceId": resource_id, "annotations": true }),
                None,
                None,
            );
            xynolog_telemetry::content_get_annotations(
                resource_id,
                self.shared.answer(
                    method_of(&GET_RESOURCE_ANNOTATIONS),
                    &GET_RESOURCE_ANNOTATIONS.path_for(resource_id),
                    true,
                    |builder| builder,
                ),
            )
            .await
        })
    }

    fn get_anchored_text<'a>(
        &'a self,
        resource_id: &'a ResourceId,
    ) -> BoxFuture<'a, Result<AnchoredTextAnswer, TransportError>> {
        Box::pin(async move {
            bus_log(
                "GET",
                "content",
                &json!({ "resourceId": resource_id, "anchoredText": true }),
                None,
                None,
            );
            // The Archivist may hold this read while the Smelter settles the
            // content, and the gateway passes that wait through: the
            // deadline (`Timing::http_request`) must outlast it.
            xynolog_telemetry::content_get_anchored_text(
                resource_id,
                self.shared.answer(
                    method_of(&GET_RESOURCE_ANCHORED_TEXT),
                    &GET_RESOURCE_ANCHORED_TEXT.path_for(resource_id),
                    true,
                    |builder| builder,
                ),
            )
            .await
        })
    }
}

impl HttpContentTransport {
    /// The stored bytes, as they are: no `Accept`, so the gateway serves them
    /// with their own media type. The deadline is on their beginning to
    /// arrive: how long they take after that is how many there are.
    async fn read(&self, resource_id: &ResourceId) -> Result<reqwest::Response, TransportError> {
        self.shared
            .send(
                method_of(&GET_RESOURCE_REPRESENTATION),
                &GET_RESOURCE_REPRESENTATION.path_for(resource_id),
                true,
                |builder| builder,
            )
            .await
    }
}

fn content_type(response: &reqwest::Response) -> String {
    response
        .headers()
        .get(reqwest::header::CONTENT_TYPE)
        .and_then(|value| value.to_str().ok())
        .unwrap_or("application/octet-stream")
        .to_owned()
}

/// A read whose bytes stopped coming.
fn interrupted(resource_id: &ResourceId, error: &reqwest::Error) -> TransportError {
    TransportError::without_response(
        format!(
            "{} {} ended before its bytes did: {error}",
            method_of(&GET_RESOURCE_REPRESENTATION),
            GET_RESOURCE_REPRESENTATION.path_for(resource_id)
        ),
        TransportErrorCode::Unavailable,
    )
}

#[cfg(test)]
mod tests {
    use super::*;
    use xynolog::testing::as_id;

    fn request() -> PutBinaryRequest {
        PutBinaryRequest {
            name: "A \"quoted\" name".to_owned(),
            bytes: Bytes::from_static(&[0, 1, 2, 255]),
            format: "image/png".to_owned(),
            storage_uri: "file://uploads/a.png".to_owned(),
            entity_types: vec!["Person".to_owned(), "Place".to_owned()],
            language: Some("en".to_owned()),
            source_annotation_id: None,
            source_resource_id: None,
            generation_prompt: None,
            generator: None,
            job_id: Some(as_id("job-1")),
            is_draft: Some(true),
            clone_token: None,
            archive_original: None,
        }
    }

    #[test]
    fn a_form_carries_each_field_under_its_own_name_and_the_bytes_unchanged() {
        let form = Form::of(&request());
        let before = String::from_utf8(form.parts[0].to_vec()).expect("text");
        let after = String::from_utf8(form.parts[2].to_vec()).expect("text");
        assert!(before.contains("name=\"name\"\r\n\r\nA \"quoted\" name\r\n"));
        assert!(before.contains("name=\"storageUri\"\r\n\r\nfile://uploads/a.png\r\n"));
        assert!(before.ends_with(
            "name=\"file\"; filename=\"A \\\"quoted\\\" name\"\r\nContent-Type: image/png\r\n\r\n"
        ));
        assert_eq!(form.parts[1], Bytes::from_static(&[0, 1, 2, 255]));
        assert!(after.contains("name=\"entityTypes\"\r\n\r\n[\"Person\",\"Place\"]\r\n"));
        assert!(after.contains("name=\"jobId\"\r\n\r\njob-1\r\n"));
        assert!(after.contains("name=\"isDraft\"\r\n\r\ntrue\r\n"));
        assert!(
            !after.contains("sourceResourceId"),
            "an absent field is not sent"
        );
        assert!(after.ends_with(&format!("--{}--\r\n", form.boundary)));
    }

    #[tokio::test]
    async fn the_body_is_the_form_and_its_progress_ends_at_its_length() {
        let mut large = request();
        large.bytes = Bytes::from(vec![7u8; UPLOAD_CHUNK * 2 + 10]);
        let form = Form::of(&large);
        let (progress, mut reported) = mpsc::unbounded_channel();
        let body = form.body(progress, Arc::default());
        let sent = http_body_util::BodyExt::collect(body)
            .await
            .expect("the body is read")
            .to_bytes();
        assert_eq!(sent.len() as u64, form.len());
        assert_eq!(sent, form.parts.concat());
        let mut last = None;
        let mut reports = 0;
        while let Some(report) = reported.recv().await {
            let UploadProgress::Progress(report) = report else {
                panic!("the body reports only what it has sent: {report:?}");
            };
            assert_eq!(report.total_bytes, form.len());
            assert!(last.is_none_or(|before| report.bytes_uploaded > before));
            last = Some(report.bytes_uploaded);
            reports += 1;
        }
        assert_eq!(last, Some(form.len()));
        assert!(
            reports >= 3,
            "a body of several pieces reports several times"
        );
    }
}
