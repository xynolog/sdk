package xynolog

// Bytes over the gateway's HTTP transport, as ContentTransport: an upload
// (POST /resources), a resource's bytes whole or as a stream
// (GET /resources/{id}), its description as linked data
// (GET /resources/{id}/jsonld), its annotations
// (GET /resources/{id}/annotations), and its anchored text
// (GET /resources/{id}/anchored-text). Bytes never ride the bus. And the
// gateway's own operations, as GatewayOperations.

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"iter"
	"mime/multipart"
	"net/http"
	"net/textproto"
	"net/url"
	"strings"
	"sync"

	"github.com/google/uuid"
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/internal/kept"
	"github.com/xynolog/sdk/go/internal/required"
)

// ContentTransport carries bytes, which never ride the bus, a resource's
// description and annotations, and its anchored text.
type ContentTransport interface {
	// PutBinary uploads a resource's bytes and its fields.
	PutBinary(ctx context.Context, request PutBinaryRequest) *Upload
	// GetBinary reads a resource's bytes, whole, with their media type.
	GetBinary(ctx context.Context, resource api.ResourceId) (Content, error)
	// GetBinaryStream reads a resource's bytes as a stream, with their media
	// type.
	GetBinaryStream(ctx context.Context, resource api.ResourceId) (ContentStream, error)
	// GetResourceGraph reads a resource's description as linked data.
	GetResourceGraph(ctx context.Context, resource api.ResourceId) (api.GetResourceResponse, error)
	// GetAnnotations reads a resource's annotations.
	GetAnnotations(ctx context.Context, resource api.ResourceId) (api.GetAnnotationsResponse, error)
	// GetAnchoredText reads a resource's anchored text, or why there is none.
	GetAnchoredText(ctx context.Context, resource api.ResourceId) (api.AnchoredTextAnswer, error)
}

// GatewayOperations is what a gateway answers for itself.
type GatewayOperations interface {
	// GetCurrentUser is who the gateway says this client's token is.
	GetCurrentUser(ctx context.Context) (api.UserResponse, error)
	// GetMediaToken is a token for reading a resource's media.
	GetMediaToken(ctx context.Context, resource api.ResourceId) (api.MediaTokenResponse, error)
	// GetProtectedResourceMetadata is the gateway's OAuth protected resource
	// metadata.
	GetProtectedResourceMetadata(ctx context.Context) (api.ProtectedResourceMetadata, error)
	// HealthCheck is the gateway reporting itself: alive when it answers a
	// success, with its report when the body is one.
	HealthCheck(ctx context.Context) (report api.HealthResponse, ok bool, err error)
	// GetStatus is the gateway's status.
	GetStatus(ctx context.Context) (api.StatusResponse, error)
}

var _ GatewayOperations = (*HTTPTransport)(nil)

// PutBinaryRequest is an upload: the resource's bytes and its fields. A field
// left at its zero value is not sent.
type PutBinaryRequest struct {
	Name       string
	Bytes      []byte
	Format     string
	StorageURI string
	// EntityTypes is the resource's entity types.
	EntityTypes []string
	Language    string
	// SourceAnnotationID and SourceResourceID name what a generated resource
	// was generated from.
	SourceAnnotationID api.AnnotationId
	SourceResourceID   api.ResourceId
	GenerationPrompt   string
	// Generator is the agent that produced a generated resource's content.
	Generator *api.Agent
	// JobID is the job a worker's upload fulfils.
	JobID           api.JobId
	IsDraft         *bool
	CloneToken      string
	ArchiveOriginal *bool
}

// Upload is an upload under way: what it reports as it goes, and what the
// gateway answers. It is consumed once.
type Upload struct {
	progress *kept.Queue[api.UploadProgress]
	done     chan struct{}
	result   api.CreateResourceResponse
	err      error

	mu       sync.Mutex
	consumed bool
}

// NewUpload is the upload work carries out: work reports through report the
// upload's size, before any bytes are sent, and then how much has been sent,
// and returns what the gateway answered. The upload reports the resource made
// once work has returned it. What implements ContentTransport makes each
// upload it starts with it.
func NewUpload(work func(report func(api.UploadProgress)) (api.CreateResourceResponse, error)) *Upload {
	upload := &Upload{progress: kept.NewQueue[api.UploadProgress](), done: make(chan struct{})}
	go func() {
		defer close(upload.done)
		defer upload.progress.Close()
		upload.result, upload.err = work(func(progress api.UploadProgress) { upload.progress.Push(progress) })
		if upload.err != nil {
			return
		}
		var finished api.UploadProgress
		if upload.err = finished.From(api.UploadProgressFinished{Phase: api.UploadProgressFinishedPhaseFinished, ResourceId: upload.result.ResourceId}); upload.err == nil {
			upload.progress.Push(finished)
		}
	}()
	return upload
}

// Progress is what the upload reports, until it ends or the loop over it
// stops: started with its size before any bytes are sent, progress each time
// more has been sent, never less than it last said, and finished with the
// resource made, once the gateway has answered. Its size is every byte sent
// for it: over HTTP, the whole request. An upload that fails reports no
// finished, and Wait gives its failure.
func (u *Upload) Progress() iter.Seq[api.UploadProgress] {
	return u.progress.All(nil, func() {})
}

// Wait is what the gateway answers: the new resource's id. A second Wait is
// refused.
func (u *Upload) Wait(ctx context.Context) (api.CreateResourceResponse, error) {
	u.mu.Lock()
	again := u.consumed
	u.consumed = true
	u.mu.Unlock()
	if again {
		return api.CreateResourceResponse{}, fmt.Errorf("an upload's answer is taken once")
	}
	select {
	case <-u.done:
		return u.result, u.err
	case <-ctx.Done():
		return api.CreateResourceResponse{}, ctx.Err()
	}
}

// Content is a resource's bytes, with their media type.
type Content struct {
	Bytes       []byte
	ContentType string
}

// ContentStream is a resource's bytes as they arrive, with their media type.
// Its reader is closed by its caller.
type ContentStream struct {
	Bytes       io.ReadCloser
	ContentType string
}

// HTTPContentTransport is ContentTransport over the gateway an HTTPTransport
// speaks to, with its token, its retry rule and its error stream.
type HTTPContentTransport struct {
	shared *transportShared
}

var _ ContentTransport = (*HTTPContentTransport)(nil)

// NewHTTPContentTransport is content over the gateway transport speaks to.
func NewHTTPContentTransport(transport *HTTPTransport) *HTTPContentTransport {
	return &HTTPContentTransport{shared: transport.shared}
}

// uploadChunk is how much of an upload's body is handed to the connection at
// a time: the grain its progress is reported in.
const uploadChunk = 64 * 1024

// form is an upload's body, as RouteUploadResource sends it: its members
// every upload sends, then the bytes as the file member, then the others it
// sends.
func form(request PutBinaryRequest) (body []byte, contentType string, err error) {
	var buffer bytes.Buffer
	writer := multipart.NewWriter(&buffer)
	fields := func(required bool) error {
		for _, member := range uploadFields {
			if member.required != required || member.name == uploadFieldFile {
				continue
			}
			text, sent, err := uploadSent[member.name](request)
			if err != nil {
				return err
			}
			if sent {
				if err := writer.WriteField(member.name, text); err != nil {
					return err
				}
			}
		}
		return nil
	}
	if err := fields(true); err != nil {
		return nil, "", err
	}
	header := make(textproto.MIMEHeader)
	escaped := strings.NewReplacer(`\`, `\\`, `"`, `\"`).Replace(request.Name)
	header.Set("Content-Disposition", fmt.Sprintf(`form-data; name="%s"; filename="%s"`, uploadFieldFile, escaped))
	header.Set("Content-Type", request.Format)
	part, err := writer.CreatePart(header)
	if err != nil {
		return nil, "", err
	}
	if _, err := part.Write(request.Bytes); err != nil {
		return nil, "", err
	}
	if err := fields(false); err != nil {
		return nil, "", err
	}
	if err := writer.Close(); err != nil {
		return nil, "", err
	}
	return buffer.Bytes(), routeUploadResourceSends + "; boundary=" + writer.Boundary(), nil
}

// uploadSent is each member of an upload but its file, as request sends it:
// its text, and whether it is sent.
var uploadSent = map[string]func(request PutBinaryRequest) (string, bool, error){
	uploadFieldName:               func(r PutBinaryRequest) (string, bool, error) { return r.Name, true, nil },
	uploadFieldFormat:             func(r PutBinaryRequest) (string, bool, error) { return r.Format, true, nil },
	uploadFieldStorageUri:         func(r PutBinaryRequest) (string, bool, error) { return r.StorageURI, true, nil },
	uploadFieldLanguage:           func(r PutBinaryRequest) (string, bool, error) { return given(r.Language) },
	uploadFieldEntityTypes:        func(r PutBinaryRequest) (string, bool, error) { return encoded(r.EntityTypes, len(r.EntityTypes) > 0) },
	uploadFieldSourceAnnotationId: func(r PutBinaryRequest) (string, bool, error) { return given(r.SourceAnnotationID.String()) },
	uploadFieldSourceResourceId:   func(r PutBinaryRequest) (string, bool, error) { return given(r.SourceResourceID.String()) },
	uploadFieldGenerationPrompt:   func(r PutBinaryRequest) (string, bool, error) { return given(r.GenerationPrompt) },
	uploadFieldGenerator:          func(r PutBinaryRequest) (string, bool, error) { return encoded(r.Generator, r.Generator != nil) },
	uploadFieldJobId:              func(r PutBinaryRequest) (string, bool, error) { return given(r.JobID.String()) },
	uploadFieldIsDraft:            func(r PutBinaryRequest) (string, bool, error) { return flag(r.IsDraft) },
	uploadFieldCloneToken:         func(r PutBinaryRequest) (string, bool, error) { return given(r.CloneToken) },
	uploadFieldArchiveOriginal:    func(r PutBinaryRequest) (string, bool, error) { return flag(r.ArchiveOriginal) },
}

// given is text, sent when it is not empty.
func given(text string) (string, bool, error) { return text, text != "", nil }

// flag is value's text, sent when it is set.
func flag(value *bool) (string, bool, error) {
	if value == nil {
		return "", false, nil
	}
	return fmt.Sprint(*value), true, nil
}

// encoded is value as JSON, sent when sent is true.
func encoded(value any, sent bool) (string, bool, error) {
	if !sent {
		return "", false, nil
	}
	text, err := json.Marshal(value)
	return string(text), true, err
}

// progressReader hands body to the connection a chunk at a time, reporting
// each to progress. reported is how much of this upload has been reported
// sent: a sending that repeats an earlier one, after a renewed token or as the
// upload's one resend, reports nothing until it has passed that.
//
// It is not a body net/http can rewind, so net/http never sends an upload
// again by itself, as it would a keyed request it could rewind on a reused
// connection the server closed: the one resend is exchange's.
type progressReader struct {
	body     []byte
	sent     int
	reported *int
	mu       *sync.Mutex
	report   func(api.UploadProgress)
}

func (p *progressReader) Read(buffer []byte) (int, error) {
	if p.sent >= len(p.body) {
		return 0, io.EOF
	}
	n := copy(buffer[:min(len(buffer), uploadChunk)], p.body[p.sent:])
	p.sent += n
	p.mu.Lock()
	defer p.mu.Unlock()
	if p.sent > *p.reported {
		*p.reported = p.sent
		var progress api.UploadProgress
		if err := progress.From(api.UploadProgressProgress{Phase: api.UploadProgressProgressPhaseProgress, BytesUploaded: p.sent, TotalBytes: len(p.body)}); err != nil {
			return n, err
		}
		p.report(progress)
	}
	return n, nil
}

// PutBinary uploads a resource. Every attempt carries the upload's one
// Idempotency-Key, so an attempt answered with a status RetryRuleTransport
// retries, or not answered at all, is sent once more, with the same key, bytes
// and fields, after Timing.RequestRetryPause or the answer's Retry-After when
// that is longer. Its context abandons it: the connection is closed, nothing
// is reported on the error stream, and it is not sent again.
func (c *HTTPContentTransport) PutBinary(ctx context.Context, putting PutBinaryRequest) *Upload {
	return NewUpload(func(report func(api.UploadProgress)) (api.CreateResourceResponse, error) {
		busLog(ctx, busPut, "content", map[string]any{"name": putting.Name, "format": putting.Format, "storageUri": putting.StorageURI, "sizeBytes": len(putting.Bytes)}, Envelope{})
		ctx, span := uploading(ctx, putting.Format, len(putting.Bytes))
		defer span.End()
		body, contentType, err := form(putting)
		if err != nil {
			return api.CreateResourceResponse{}, c.shared.failures.Report(transportErrorWithoutResponse(fmt.Sprintf("an upload that cannot be written: %v", err), api.TransportErrorCodeError))
		}
		var started api.UploadProgress
		if err := started.From(api.UploadProgressStarted{Phase: api.UploadProgressStartedPhaseStarted, TotalBytes: len(body)}); err != nil {
			return api.CreateResourceResponse{}, err
		}
		report(started)
		var reported int
		var mu sync.Mutex
		return answer[api.CreateResourceResponse](ctx, c.shared, request{
			method: RouteUploadResource.Method, path: RouteUploadResource.Path, authenticated: true, contentType: contentType, idempotencyKey: uuid.NewString(),
			body: func() (io.Reader, int64) {
				return &progressReader{body: body, reported: &reported, mu: &mu, report: report}, int64(len(body))
			},
		})
	})
}

// resourcePath is route's path for resource. Its id is one segment of the path
// as it is: the rule a ResourceId is held to admits nothing a path reads as its
// own.
func resourcePath(route GatewayRoute, resource api.ResourceId) string {
	return strings.Replace(route.Path, "{id}", resource.String(), 1)
}

// read is the stored bytes, as they are: no Accept, so the gateway serves them
// with their own media type. The deadline is on their beginning to arrive:
// how long they take after that is how many there are.
func (c *HTTPContentTransport) read(ctx context.Context, resource api.ResourceId) (answered, error) {
	return c.shared.exchange(ctx, c.get(RouteGetResourceRepresentation, resource))
}

func contentType(response *http.Response) string {
	if stated := response.Header.Get("Content-Type"); stated != "" {
		return stated
	}
	return "application/octet-stream"
}

// interrupted is a read whose bytes stopped coming.
func interrupted(resource api.ResourceId, err error) *TransportError {
	return transportErrorWithoutResponse(fmt.Sprintf("%s %s ended before its bytes did: %v", RouteGetResourceRepresentation.Method, resourcePath(RouteGetResourceRepresentation, resource), err), api.TransportErrorCodeUnavailable)
}

// GetBinary reads a resource's bytes, whole.
func (c *HTTPContentTransport) GetBinary(ctx context.Context, resource api.ResourceId) (Content, error) {
	busLog(ctx, busGet, "content", map[string]any{"resourceId": resource}, Envelope{})
	ctx, span := getting(ctx, resource, false)
	defer span.End()
	got, err := c.read(ctx, resource)
	if err != nil {
		return Content{}, err
	}
	defer got.done()
	read, err := io.ReadAll(got.response.Body)
	if err != nil {
		if ctx.Err() != nil {
			return Content{}, ctx.Err()
		}
		return Content{}, c.shared.failures.Report(interrupted(resource, err))
	}
	return Content{Bytes: read, ContentType: contentType(got.response)}, nil
}

// streamed reports a read whose bytes stopped coming, and releases the
// request once its reader is closed.
type streamed struct {
	body     io.ReadCloser
	done     func()
	resource api.ResourceId
	shared   *transportShared
	once     sync.Once
}

func (s *streamed) Read(p []byte) (int, error) {
	n, err := s.body.Read(p)
	if err != nil && err != io.EOF {
		return n, s.shared.failures.Report(interrupted(s.resource, err))
	}
	return n, err
}

func (s *streamed) Close() error {
	s.once.Do(s.done)
	return nil
}

// GetBinaryStream reads a resource's bytes as a stream; its reader is closed
// by its caller.
func (c *HTTPContentTransport) GetBinaryStream(ctx context.Context, resource api.ResourceId) (ContentStream, error) {
	busLog(ctx, busGet, "content", map[string]any{"resourceId": resource, "stream": true}, Envelope{})
	ctx, span := getting(ctx, resource, true)
	defer span.End()
	got, err := c.read(ctx, resource)
	if err != nil {
		return ContentStream{}, err
	}
	return ContentStream{
		Bytes:       &streamed{body: got.response.Body, done: got.done, resource: resource, shared: c.shared},
		ContentType: contentType(got.response),
	}, nil
}

func (c *HTTPContentTransport) get(route GatewayRoute, resource api.ResourceId) request {
	return request{method: route.Method, path: resourcePath(route, resource), authenticated: true, deadline: c.shared.timing.HttpRequestTimeout}
}

// GetResourceGraph reads a resource's description as linked data.
func (c *HTTPContentTransport) GetResourceGraph(ctx context.Context, resource api.ResourceId) (api.GetResourceResponse, error) {
	busLog(ctx, busGet, "content", map[string]any{"resourceId": resource, "graph": true}, Envelope{})
	ctx, span := reading(ctx, spanContentGetGraph, resource)
	defer span.End()
	return answer[api.GetResourceResponse](ctx, c.shared, c.get(RouteGetResourceJsonLd, resource))
}

// GetAnnotations reads a resource's annotations.
func (c *HTTPContentTransport) GetAnnotations(ctx context.Context, resource api.ResourceId) (api.GetAnnotationsResponse, error) {
	busLog(ctx, busGet, "content", map[string]any{"resourceId": resource, "annotations": true}, Envelope{})
	ctx, span := reading(ctx, spanContentGetAnnotations, resource)
	defer span.End()
	return answer[api.GetAnnotationsResponse](ctx, c.shared, c.get(RouteGetResourceAnnotations, resource))
}

// GetAnchoredText reads a resource's anchored text. The Archivist may hold
// this read while the Smelter settles the content, and the gateway passes
// that wait through: the deadline (Timing.HttpRequestTimeout) outlasts it.
func (c *HTTPContentTransport) GetAnchoredText(ctx context.Context, resource api.ResourceId) (api.AnchoredTextAnswer, error) {
	busLog(ctx, busGet, "content", map[string]any{"resourceId": resource, "anchoredText": true}, Envelope{})
	ctx, span := reading(ctx, spanContentGetAnchoredText, resource)
	defer span.End()
	return answer[api.AnchoredTextAnswer](ctx, c.shared, c.get(RouteGetResourceAnchoredText, resource))
}

func (t *HTTPTransport) operation(route GatewayRoute, authenticated bool) request {
	return request{method: route.Method, path: route.Path, authenticated: authenticated, deadline: t.shared.timing.HttpRequestTimeout}
}

// GetCurrentUser is who the gateway says this client's token is.
func (t *HTTPTransport) GetCurrentUser(ctx context.Context) (api.UserResponse, error) {
	return answer[api.UserResponse](ctx, t.shared, t.operation(RouteGetCurrentUser, true))
}

// GetMediaToken is a token for reading a resource's media.
func (t *HTTPTransport) GetMediaToken(ctx context.Context, resource api.ResourceId) (api.MediaTokenResponse, error) {
	spec := t.operation(RouteCreateMediaToken, true)
	body, err := jsonBody(api.MediaTokenRequest{ResourceId: resource})
	if err != nil {
		return api.MediaTokenResponse{}, t.shared.failures.Report(transportErrorWithoutResponse(fmt.Sprintf("a media token request that does not serialize: %v", err), api.TransportErrorCodeError))
	}
	spec.body, spec.contentType = body, routeCreateMediaTokenSends
	return answer[api.MediaTokenResponse](ctx, t.shared, spec)
}

// MediaURL is where a reader that sends no bearer, such as a page's <img>,
// reads resource's representation: getResourceRepresentationWithMediaToken,
// with a token GetMediaToken gave for that resource.
func (t *HTTPTransport) MediaURL(resource api.ResourceId, token api.MediaTokenResponse) string {
	return t.shared.baseURL + resourcePath(RouteGetResourceRepresentationWithMediaToken, resource) + "?" + url.Values{MediaTokenQuery: {token.Token}}.Encode()
}

// GetProtectedResourceMetadata is the gateway's OAuth protected resource
// metadata, which any caller may read.
func (t *HTTPTransport) GetProtectedResourceMetadata(ctx context.Context) (api.ProtectedResourceMetadata, error) {
	return answer[api.ProtectedResourceMetadata](ctx, t.shared, t.operation(RouteGetProtectedResourceMetadata, false))
}

// HealthCheck asks the gateway to report itself. A nil error means it
// answered with a success status: it is alive. Its report is the body, when
// the body is one; ok is false for a success whose body does not read, or
// lacks a member its schema requires, a live gateway behind a schema this
// client does not know, since calling that down would take a gateway offline
// over a field renamed. Liveness is the status; the body is detail.
func (t *HTTPTransport) HealthCheck(ctx context.Context) (report api.HealthResponse, ok bool, err error) {
	spec := t.operation(RouteGetHealth, true)
	got, err := t.shared.exchange(ctx, spec)
	if err != nil {
		return api.HealthResponse{}, false, err
	}
	defer got.done()
	reading, cancel := context.WithTimeout(ctx, spec.deadline)
	defer cancel()
	body, err := io.ReadAll(readerWithContext(reading, got.response.Body))
	if err != nil {
		return api.HealthResponse{}, false, nil
	}
	report, ok = required.ReadAs[api.HealthResponse](body)
	return report, ok, nil
}

// GetStatus is the gateway's status.
func (t *HTTPTransport) GetStatus(ctx context.Context) (api.StatusResponse, error) {
	return answer[api.StatusResponse](ctx, t.shared, t.operation(RouteGetStatus, true))
}
