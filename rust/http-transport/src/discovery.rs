//! A launcher's discovery document over HTTP, as `xynolog::discovery`'s
//! transport: read with the tag of the last good document, so a document
//! that has not changed is not sent again, and read as absent when what is
//! at the URL is not JSON, which is what a server that answers every path
//! with its own page gives.

use crate::transport::locked;
use std::sync::Mutex;
use xynolog::discovery::{DiscoveryTransport, parse_discovery_document};
use xynolog::timing::HTTP_REQUEST_TIMEOUT;
use xynolog::transport::BoxFuture;
use xynolog::types::{
    DiscoveryAbsent, DiscoveryAbsentReason, DiscoveryRead, DiscoveryState, DiscoveryUnchanged,
};

struct HttpDiscovery {
    url: String,
    http: reqwest::Client,
    /// The tag of the last document that read as managed.
    etag: Mutex<Option<String>>,
}

fn absent(reason: DiscoveryAbsentReason, diagnostic: String) -> DiscoveryRead {
    DiscoveryRead::DiscoveryAbsent(DiscoveryAbsent {
        diagnostic: Some(diagnostic),
        ..DiscoveryAbsent::new(reason)
    })
}

impl DiscoveryTransport for HttpDiscovery {
    fn read(&self) -> BoxFuture<'_, DiscoveryRead> {
        Box::pin(async move {
            let mut request = self.http.get(&self.url);
            if let Some(etag) = locked(&self.etag).clone() {
                request = request.header("if-none-match", etag);
            }
            // With a deadline: a read that is never answered would hold the
            // poll that awaits it, and every poll after it, for good.
            let response = match request.timeout(HTTP_REQUEST_TIMEOUT).send().await {
                Ok(response) => response,
                Err(error) if error.is_timeout() => {
                    return absent(
                        DiscoveryAbsentReason::Unreadable,
                        format!(
                            "the document was not served within {}s",
                            HTTP_REQUEST_TIMEOUT.as_secs()
                        ),
                    );
                }
                Err(error) => {
                    return absent(DiscoveryAbsentReason::Unreadable, error.to_string());
                }
            };
            let status = response.status();
            if status.as_u16() == 304 {
                return DiscoveryUnchanged::new().into();
            }
            if !status.is_success() {
                return absent(
                    DiscoveryAbsentReason::NotFound,
                    format!("HTTP {}", status.as_u16()),
                );
            }
            let header = |name: &str| {
                response
                    .headers()
                    .get(name)
                    .and_then(|value| value.to_str().ok())
                    .map(str::to_owned)
            };
            let content_type = header("content-type").unwrap_or_default();
            if !content_type.to_ascii_lowercase().contains("json") {
                return absent(
                    DiscoveryAbsentReason::NotFound,
                    format!("the content type is \"{content_type}\", not JSON"),
                );
            }
            let etag = header("etag");
            let text = match response.text().await {
                Ok(text) => text,
                Err(error) => {
                    return absent(DiscoveryAbsentReason::Unreadable, error.to_string());
                }
            };
            let state = parse_discovery_document(&text);
            // Only a good document's tag is kept: one kept for a document
            // that did not read would have this believe it for good.
            if matches!(state, DiscoveryState::DiscoveryManaged(_)) {
                *locked(&self.etag) = etag;
            }
            state.into()
        })
    }
}

/// A transport that reads the discovery document at `url`.
pub fn http_discovery(url: &str, http: reqwest::Client) -> impl DiscoveryTransport {
    HttpDiscovery {
        url: url.to_owned(),
        http,
        etag: Mutex::new(None),
    }
}
