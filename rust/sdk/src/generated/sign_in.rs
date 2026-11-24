// Generated from protocol/specs/src/sign-in-store/SignIn.json; do not edit.
// Regenerate: make generate (codegen/lib/rust_types/rust_types.ml)
/// One sign-in to a running stack's knowledge base, as the sign-in store keeps it: the tokens an issuer issued to the script client, and what a renewal and a sign-out need of that issuer, learned once at sign-in. TOKENS, never a password. An entry of <stateDir>/tokens.json (see README.md).
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct SignIn {
    /// The access token: short-lived, sent as a Bearer token.
    pub token: String,
    /// The refresh token: long-lived, and what renews the access token at the issuer without another sign-in. An entry with none cannot be renewed.
    #[serde(rename = "refreshToken")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub refresh_token: Option<String>,
    /// Who signed in: the address the access token named when the sign-in was made, which is the one the gateway answers for it. For display. Absent when the token named none. A writer that renews an entry keeps it as it was.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub email: Option<String>,
    /// When the access token was issued to this machine, RFC 3339 in UTC.
    #[serde(rename = "obtainedAt")]
    pub obtained_at: String,
    /// When the access token stops working, RFC 3339 in UTC, so a reader can renew before sending a token it knows is dead. Absent when the issuer named no lifetime: the gateway's refusal is then the signal.
    #[serde(rename = "expiresAt")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub expires_at: Option<String>,
    /// The issuer the sign-in came from: the one the access token named when the sign-in was made. A writer that renews an entry keeps it.
    pub issuer: String,
    /// The issuer's token endpoint, where the refresh grant is made.
    #[serde(rename = "tokenEndpoint")]
    pub token_endpoint: String,
    /// The issuer's revocation endpoint (RFC 7009), where a sign-out tells it to forget the refresh token. Absent when the issuer has none.
    #[serde(rename = "revocationEndpoint")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub revocation_endpoint: Option<String>,
}

impl SignIn {
    /// The `SignIn` that states these and nothing else.
    pub fn new(
        token: impl Into<String>,
        obtained_at: impl Into<String>,
        issuer: impl Into<String>,
        token_endpoint: impl Into<String>,
    ) -> Self {
        Self {
            token: token.into(),
            refresh_token: None,
            email: None,
            obtained_at: obtained_at.into(),
            expires_at: None,
            issuer: issuer.into(),
            token_endpoint: token_endpoint.into(),
            revocation_endpoint: None,
        }
    }
}

schema!(SignIn);
