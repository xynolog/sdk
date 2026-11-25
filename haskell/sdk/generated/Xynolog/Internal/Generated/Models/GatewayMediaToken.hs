-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatewayMediaToken (GatewayMediaToken (..), GatewayMediaTokenClaims (..), GatewayMediaTokenClaimsIss (..), gatewayMediaTokenClaimsIssText, GatewayMediaTokenClaimsPurpose (..), gatewayMediaTokenClaimsPurposeText, GatewayMediaTokenClaimsSub (..), gatewayMediaTokenClaimsSubText, GatewayMediaTokenHeader (..), GatewayMediaTokenHeaderAlg (..), gatewayMediaTokenHeaderAlgText, GatewayMediaTokenHeaderTyp (..), gatewayMediaTokenHeaderTypText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data GatewayMediaToken = GatewayMediaToken
  { gatewayMediaTokenComment :: Text,
    gatewayMediaTokenHeader :: GatewayMediaTokenHeader,
    gatewayMediaTokenClaims :: GatewayMediaTokenClaims,
    gatewayMediaTokenLifetimeSeconds :: Integer
  }
  deriving (Eq, Show)

instance FromJSON GatewayMediaToken where parseJSON = checked "GatewayMediaToken" $ withObject "GatewayMediaToken" (\fields -> GatewayMediaToken <$> (fields .: "$comment") <*> (fields .: "header") <*> (fields .: "claims") <*> (fields .: "lifetimeSeconds"))

instance ToJSON GatewayMediaToken where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (gatewayMediaTokenComment value))], [("header", toJSON (gatewayMediaTokenHeader value))], [("claims", toJSON (gatewayMediaTokenClaims value))], [("lifetimeSeconds", toJSON (gatewayMediaTokenLifetimeSeconds value))]]))

data GatewayMediaTokenClaims = GatewayMediaTokenClaims
  { gatewayMediaTokenClaimsPurpose :: GatewayMediaTokenClaimsPurpose,
    gatewayMediaTokenClaimsIss :: GatewayMediaTokenClaimsIss,
    gatewayMediaTokenClaimsSub :: GatewayMediaTokenClaimsSub
  }
  deriving (Eq, Show)

instance FromJSON GatewayMediaTokenClaims where parseJSON = checked "GatewayMediaTokenClaims" $ withObject "GatewayMediaTokenClaims" (\fields -> GatewayMediaTokenClaims <$> (fields .: "purpose") <*> (fields .: "iss") <*> (fields .: "sub"))

instance ToJSON GatewayMediaTokenClaims where toJSON value = Object (KM.fromList (concat [[("purpose", toJSON (gatewayMediaTokenClaimsPurpose value))], [("iss", toJSON (gatewayMediaTokenClaimsIss value))], [("sub", toJSON (gatewayMediaTokenClaimsSub value))]]))

data GatewayMediaTokenClaimsIss = GatewayMediaTokenClaimsIssDomain deriving (Eq, Show)

instance FromJSON GatewayMediaTokenClaimsIss where parseJSON = checked "GatewayMediaTokenClaimsIss" $ \value -> if value == String "{domain}" then pure GatewayMediaTokenClaimsIssDomain else fail "unknown enumeration member"

instance ToJSON GatewayMediaTokenClaimsIss where toJSON GatewayMediaTokenClaimsIssDomain = String "{domain}"

gatewayMediaTokenClaimsIssText :: GatewayMediaTokenClaimsIss -> Text
gatewayMediaTokenClaimsIssText GatewayMediaTokenClaimsIssDomain = "{domain}"

data GatewayMediaTokenClaimsPurpose = GatewayMediaTokenClaimsPurposeMedia deriving (Eq, Show)

instance FromJSON GatewayMediaTokenClaimsPurpose where parseJSON = checked "GatewayMediaTokenClaimsPurpose" $ \value -> if value == String "media" then pure GatewayMediaTokenClaimsPurposeMedia else fail "unknown enumeration member"

instance ToJSON GatewayMediaTokenClaimsPurpose where toJSON GatewayMediaTokenClaimsPurposeMedia = String "media"

gatewayMediaTokenClaimsPurposeText :: GatewayMediaTokenClaimsPurpose -> Text
gatewayMediaTokenClaimsPurposeText GatewayMediaTokenClaimsPurposeMedia = "media"

data GatewayMediaTokenClaimsSub = GatewayMediaTokenClaimsSubResourceId deriving (Eq, Show)

instance FromJSON GatewayMediaTokenClaimsSub where parseJSON = checked "GatewayMediaTokenClaimsSub" $ \value -> if value == String "{resourceId}" then pure GatewayMediaTokenClaimsSubResourceId else fail "unknown enumeration member"

instance ToJSON GatewayMediaTokenClaimsSub where toJSON GatewayMediaTokenClaimsSubResourceId = String "{resourceId}"

gatewayMediaTokenClaimsSubText :: GatewayMediaTokenClaimsSub -> Text
gatewayMediaTokenClaimsSubText GatewayMediaTokenClaimsSubResourceId = "{resourceId}"

data GatewayMediaTokenHeader = GatewayMediaTokenHeader
  { gatewayMediaTokenHeaderAlg :: GatewayMediaTokenHeaderAlg,
    gatewayMediaTokenHeaderTyp :: GatewayMediaTokenHeaderTyp
  }
  deriving (Eq, Show)

instance FromJSON GatewayMediaTokenHeader where parseJSON = checked "GatewayMediaTokenHeader" $ withObject "GatewayMediaTokenHeader" (\fields -> GatewayMediaTokenHeader <$> (fields .: "alg") <*> (fields .: "typ"))

instance ToJSON GatewayMediaTokenHeader where toJSON value = Object (KM.fromList (concat [[("alg", toJSON (gatewayMediaTokenHeaderAlg value))], [("typ", toJSON (gatewayMediaTokenHeaderTyp value))]]))

data GatewayMediaTokenHeaderAlg = GatewayMediaTokenHeaderAlgHS256 deriving (Eq, Show)

instance FromJSON GatewayMediaTokenHeaderAlg where parseJSON = checked "GatewayMediaTokenHeaderAlg" $ \value -> if value == String "HS256" then pure GatewayMediaTokenHeaderAlgHS256 else fail "unknown enumeration member"

instance ToJSON GatewayMediaTokenHeaderAlg where toJSON GatewayMediaTokenHeaderAlgHS256 = String "HS256"

gatewayMediaTokenHeaderAlgText :: GatewayMediaTokenHeaderAlg -> Text
gatewayMediaTokenHeaderAlgText GatewayMediaTokenHeaderAlgHS256 = "HS256"

data GatewayMediaTokenHeaderTyp = GatewayMediaTokenHeaderTypJWT deriving (Eq, Show)

instance FromJSON GatewayMediaTokenHeaderTyp where parseJSON = checked "GatewayMediaTokenHeaderTyp" $ \value -> if value == String "JWT" then pure GatewayMediaTokenHeaderTypJWT else fail "unknown enumeration member"

instance ToJSON GatewayMediaTokenHeaderTyp where toJSON GatewayMediaTokenHeaderTypJWT = String "JWT"

gatewayMediaTokenHeaderTypText :: GatewayMediaTokenHeaderTyp -> Text
gatewayMediaTokenHeaderTypText GatewayMediaTokenHeaderTypJWT = "JWT"
