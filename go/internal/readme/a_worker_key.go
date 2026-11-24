package readme

import (
	"fmt"
	"os"

	xynolog "github.com/xynolog/sdk/go"
)

// WorkerCredential is a worker's account at issuer, which proves itself with
// the key the launcher handed it.
func WorkerCredential(issuer, clientID string) (xynolog.KeyCredential, error) {
	key, err := xynolog.ParsePrivateKeyPEM(os.Getenv(string(xynolog.ServiceEnvironmentVariableXynologOidcClientKey)))
	if err != nil {
		return xynolog.KeyCredential{}, fmt.Errorf("%s: %w", xynolog.ServiceEnvironmentVariableXynologOidcClientKey, err)
	}
	return xynolog.KeyCredential{Issuer: issuer, ClientID: clientID, PrivateKey: key}, nil
}
