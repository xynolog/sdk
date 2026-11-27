//! A real client and a real session for tests. Every namespace, cache and
//! deadline is the client's own; only what it speaks through is a double.
//! A test scripts the transport and observes through the client.
//!
//! What a test does not give is a double that refuses: a request nobody
//! scripted an answer for fails naming its operation, and a read of content
//! nobody stored fails naming the resource.

use super::{FaultyTransport, InMemoryContent};
use crate::channels::BRIDGED_CHANNELS;
use crate::client::{ClientOptions, XynologClient};
use crate::option_defaults::testing_create_test_session_kb;
use crate::session::{XynologSession, XynologSessionConfig, kept_in};
use crate::storage::InMemorySessionStorage;
use crate::transport::GatewayOperations;
use crate::types::KbTarget;
use std::sync::Arc;
use tokio::sync::watch;

/// What a test client is built over.
#[derive(Default)]
pub struct TestClientOptions {
    /// The transport, as the test scripted it. Absent, one whose stream
    /// names what a full client's does (`BRIDGED_CHANNELS`) and that nothing
    /// is scripted to answer.
    pub transport: Option<FaultyTransport>,
    /// Absent, one that holds nothing.
    pub content: Option<InMemoryContent>,
    /// The gateway's own operations. Absent, the client has no `auth` and no
    /// `system`, as a client over a transport with no gateway has none.
    pub gateway: Option<Arc<dyn GatewayOperations>>,
    /// The client's timing and cache persistence.
    pub client: ClientOptions,
}

/// A client, and the doubles it speaks through.
pub struct TestClient {
    pub client: Arc<XynologClient>,
    pub transport: FaultyTransport,
    pub content: InMemoryContent,
}

/// A real `XynologClient` over a `FaultyTransport` and an `InMemoryContent`.
pub fn create_test_client(options: TestClientOptions) -> TestClient {
    let transport = options
        .transport
        .unwrap_or_else(|| FaultyTransport::new(BRIDGED_CHANNELS, vec![]));
    let content = options.content.unwrap_or_default();
    let client = Arc::new(XynologClient::new(
        Arc::new(transport.clone()),
        Arc::new(content.clone()),
        options.gateway,
        options.client,
    ));
    TestClient {
        client,
        transport,
        content,
    }
}

/// What a test session is built over.
#[derive(Default)]
pub struct TestSessionOptions {
    pub client: TestClientOptions,
    /// Absent, `option_defaults::testing_create_test_session_kb()`.
    pub kb: Option<KbTarget>,
    /// Where the session keeps its tokens. A session stored in it under
    /// the knowledge base's id is the session's at its start. Absent, one
    /// that holds nothing.
    pub storage: Option<Arc<InMemorySessionStorage>>,
}

/// A session, and what it was built over.
pub struct TestSession {
    pub session: XynologSession,
    pub client: Arc<XynologClient>,
    pub transport: FaultyTransport,
    pub content: InMemoryContent,
    /// Where the session keeps its tokens.
    pub storage: Arc<InMemorySessionStorage>,
    /// The token the session holds. A test that needs a signed-in session
    /// sends one.
    pub token: watch::Sender<Option<String>>,
}

/// A real `XynologSession` over a test client. It renews nothing and asks
/// nobody who it is, so it is ready as soon as it has read its storage, and
/// holds a token only if its storage held one. Built inside a Tokio runtime.
pub fn create_test_session(options: TestSessionOptions) -> TestSession {
    let TestClient {
        client,
        transport,
        content,
    } = create_test_client(options.client);
    let storage = options.storage.unwrap_or_default();
    let token = watch::channel(None).0;
    let kb = options.kb.unwrap_or_else(testing_create_test_session_kb);
    let session = XynologSession::new(XynologSessionConfig {
        kept: kept_in(storage.clone(), &kb.id),
        kb,
        client: client.clone(),
        token: token.clone(),
        refresh: None,
        validate: None,
        on_auth_failed: None,
        random: None,
    });
    TestSession {
        session,
        client,
        transport,
        content,
        storage,
        token,
    }
}
