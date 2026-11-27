//go:build go1.27

package registry_test

// The stage in a testing/synctest bubble, on a network faked there by
// httptest.NewTestServer, which is new in Go 1.27: so this file, and those
// whose tests run on it, are built by 1.27 and later only, while the module
// admits 1.26.

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

// bubbledStage is a stage whose gateway and issuer are one server of the
// bubble t runs in, told apart by the host each request names.
func bubbledStage(t *testing.T) *stage {
	t.Helper()
	s := unserved()
	s.issuerURL, s.gatewayURL = "http://issuer.test", "http://gateway.test:80"
	s.client = httptest.NewTestServer(t, http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Host == "issuer.test" {
			s.asIssuer(w, r)
			return
		}
		s.asGateway(w, r)
	})).Client()
	return s
}
