//! Matching, run for whoever asks on the client's own bus.
//!
//! A search is asked for by a signal (`client.match_.request_search`), which
//! carries a correlation id. This unit runs it, and answers on the same bus
//! under the same id: `match:search-results`, or `match:search-failed` with
//! the reference it was for and what went wrong. It holds no state of its
//! own: what it found is what it said.

use super::{Tasks, said, signal};
use crate::channels::{Channel, MatchSearchFailed, MatchSearchRequested, MatchSearchResults};
use crate::client::XynologClient;
use crate::event_bus::BusFrames;
use crate::state_unit::StateUnit;
use crate::transport::Envelope;
use crate::types::{self, MatchSearchOptions, MatchSearchRequest};
use std::sync::Arc;

struct Shared {
    client: Arc<XynologClient>,
    tasks: Tasks,
}

/// See the module's documentation.
pub struct MatchStateUnit {
    shared: Arc<Shared>,
}

impl MatchStateUnit {
    pub fn new(client: Arc<XynologClient>) -> MatchStateUnit {
        let heard = client.bus().frames(MatchSearchRequested::NAME);
        let shared = Arc::new(Shared {
            client,
            tasks: Tasks::new(),
        });
        shared.tasks.spawn(listen(shared.clone(), heard));
        MatchStateUnit { shared }
    }
}

async fn listen(shared: Arc<Shared>, mut heard: BusFrames) {
    while let Some(frame) = heard.next().await {
        // A request missed is not known, and one refused asks nothing.
        let Ok(Ok(frame)) = frame else { continue };
        let Some(request) = said::<MatchSearchRequested>(&frame) else {
            continue;
        };
        let under = Envelope {
            correlation_id: frame.bus_frame.correlation_id,
            scope: None,
        };
        let searching = shared.clone();
        shared.tasks.spawn(async move {
            let MatchSearchRequest {
                resource_id,
                reference_id,
                context,
                limit,
                use_semantic_scoring,
            } = request;
            let options = MatchSearchOptions {
                limit,
                use_semantic_scoring,
            };
            let search =
                searching
                    .client
                    .match_
                    .search(&resource_id, &reference_id, context, options);
            match search.await {
                Ok(found) => signal::<MatchSearchResults>(&searching.client, &found, under),
                Err(error) => signal::<MatchSearchFailed>(
                    &searching.client,
                    &types::MatchSearchFailed {
                        reference_id,
                        message: error.to_string(),
                        code: None,
                        details: None,
                    },
                    under,
                ),
            }
        });
    }
}

impl StateUnit for MatchStateUnit {
    fn dispose(&self) {
        self.shared.tasks.stop();
    }
}

impl Drop for MatchStateUnit {
    fn drop(&mut self) {
        self.dispose();
    }
}
