package discovery

// A launcher's discovery document over HTTP: read with the tag of the last
// good document, so a document that has not changed is not sent again, and
// read as absent when what is at the URL is not JSON, which is what a server
// that answers every path with its own page gives.

import (
	"context"
	"errors"
	"fmt"
	"io"
	"net/http"
	"strings"
	"sync"

	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/internal/timing"
)

type httpDiscovery struct {
	url  string
	http *http.Client
	mu   sync.Mutex
	// etag is the tag of the last document that read as managed; "" when
	// that document had none, or none has.
	etag string
}

func (h *httpDiscovery) Read(ctx context.Context) api.DiscoveryRead {
	// With a deadline: a read that is never answered would hold the poll that
	// awaits it, and every poll after it, for good.
	deadline := timing.HttpRequestTimeout
	asking, cancel := context.WithTimeout(ctx, deadline)
	defer cancel()
	unreadable := func(err error) api.DiscoveryRead {
		if errors.Is(asking.Err(), context.DeadlineExceeded) && ctx.Err() == nil {
			return readOf(absent(api.DiscoveryAbsentReasonUnreadable, fmt.Sprintf("the document was not served within %ds", int64(deadline.Seconds()))))
		}
		return readOf(absent(api.DiscoveryAbsentReasonUnreadable, err.Error()))
	}

	request, err := http.NewRequestWithContext(asking, http.MethodGet, h.url, nil)
	if err != nil {
		return unreadable(err)
	}
	h.mu.Lock()
	if h.etag != "" {
		request.Header.Set("If-None-Match", h.etag)
	}
	h.mu.Unlock()
	response, err := h.http.Do(request)
	if err != nil {
		return unreadable(err)
	}
	defer response.Body.Close()
	if response.StatusCode == http.StatusNotModified {
		return readOf(api.DiscoveryUnchanged{})
	}
	if response.StatusCode < 200 || response.StatusCode > 299 {
		return readOf(absent(api.DiscoveryAbsentReasonNotFound, fmt.Sprintf("HTTP %d", response.StatusCode)))
	}
	contentType := response.Header.Get("Content-Type")
	if !strings.Contains(strings.ToLower(contentType), "json") {
		return readOf(absent(api.DiscoveryAbsentReasonNotFound, fmt.Sprintf("the content type is \"%s\", not JSON", contentType)))
	}
	body, err := io.ReadAll(response.Body)
	if err != nil {
		return unreadable(err)
	}
	found := parse(string(body))
	// Only a good document's tag is kept: one kept for a document that did
	// not read would have this believe it for good.
	if _, isManaged := found.(api.DiscoveryManaged); isManaged {
		h.mu.Lock()
		h.etag = response.Header.Get("ETag")
		h.mu.Unlock()
	}
	return readOf(found)
}

// HttpDiscovery is a transport that reads the discovery document at url, each
// read within the timing table's request deadline (httpRequestTimeoutMs,
// protocol/specs/src/client/timing.json).
func HttpDiscovery(url string, client *http.Client) DiscoveryTransport {
	return &httpDiscovery{url: url, http: client}
}
