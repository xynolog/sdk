package xynolog_test

// The failures a program outside the SDK makes, as its tests and its own
// sign-in code do.

import (
	"errors"
	"fmt"
	"net/http"
	"testing"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
)

func TestASignInErrorMadeWithTheIssuersStatusIsItsAnswerAndOneMadeWithoutIsNone(t *testing.T) {
	var answered xynolog.Error
	if !errors.As(fmt.Errorf("renewing: %w", xynolog.NewSignInError(api.SignInErrorCodeExchange, "invalid_grant", http.StatusBadRequest)), &answered) {
		t.Fatal("a sign-in error is no xynolog.Error")
	}
	if status, ok := answered.Status(); !ok || status != http.StatusBadRequest {
		t.Errorf("the issuer's answer has the status %d, %v", status, ok)
	}
	if answered.ErrorCode() != string(api.SignInErrorCodeExchange) || answered.Error() != "invalid_grant" {
		t.Errorf("the issuer's answer is %q: %q", answered.ErrorCode(), answered.Error())
	}

	unanswered := &xynolog.SignInError{Code: api.SignInErrorCodeExchange, Message: "the network is down"}
	if status, ok := unanswered.Status(); ok {
		t.Errorf("a sign-in nobody answered has the status %d", status)
	}
}
