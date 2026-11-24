-- | OAuth against the issuer named by a knowledge base.
module Xynolog.Issuer
  ( IssuerOptions (..),
    PendingAuthorizationIssuer (..),
    IssuedTokens (..),
    DeviceCode (..),
    BeginAuthorizationOptions (..),
    PendingAuthorization (..),
    pendingAuthorizationKey,
    browserClientId,
    scriptClientId,
    signInScope,
    discoverIssuer,
    codeChallenge,
    beginAuthorization,
    completeAuthorization,
    refreshAtIssuer,
    refreshSession,
    revokeAtIssuer,
    signInWithDeviceGrant,
  )
where

import Xynolog.Internal.Issuer
