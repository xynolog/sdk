-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatewayMediaToken (GatewayMediaToken (..), GatewayMediaTokenClaims (..), GatewayMediaTokenClaimsIss (..), gatewayMediaTokenClaimsIssText, GatewayMediaTokenClaimsPurpose (..), gatewayMediaTokenClaimsPurposeText, GatewayMediaTokenClaimsSub (..), gatewayMediaTokenClaimsSubText, GatewayMediaTokenHeader (..), GatewayMediaTokenHeaderAlg (..), gatewayMediaTokenHeaderAlgText, GatewayMediaTokenHeaderTyp (..), gatewayMediaTokenHeaderTypText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data GatewayMediaToken = GatewayMediaToken
  { gatewayMediaTokenU24_comment :: Text,
    gatewayMediaTokenClaims :: GatewayMediaTokenClaims,
    gatewayMediaTokenHeader :: GatewayMediaTokenHeader,
    gatewayMediaTokenLifetimeSeconds :: Integer
  }
  deriving (Eq, Show)

instance FromJSON GatewayMediaToken where parseJSON = checked "GatewayMediaToken" $ withObject "GatewayMediaToken" (\fields -> GatewayMediaToken <$> (fields .: "$comment") <*> (fields .: "claims") <*> (fields .: "header") <*> (fields .: "lifetimeSeconds"))

instance ToJSON GatewayMediaToken where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (gatewayMediaTokenU24_comment value))], [("claims", toJSON (gatewayMediaTokenClaims value))], [("header", toJSON (gatewayMediaTokenHeader value))], [("lifetimeSeconds", toJSON (gatewayMediaTokenLifetimeSeconds value))]]))

data GatewayMediaTokenClaims = GatewayMediaTokenClaims
  { gatewayMediaTokenClaimsIss :: GatewayMediaTokenClaimsIss,
    gatewayMediaTokenClaimsPurpose :: GatewayMediaTokenClaimsPurpose,
    gatewayMediaTokenClaimsSub :: GatewayMediaTokenClaimsSub
  }
  deriving (Eq, Show)

instance FromJSON GatewayMediaTokenClaims where parseJSON = checked "GatewayMediaTokenClaims" $ withObject "GatewayMediaTokenClaims" (\fields -> GatewayMediaTokenClaims <$> (fields .: "iss") <*> (fields .: "purpose") <*> (fields .: "sub"))

instance ToJSON GatewayMediaTokenClaims where toJSON value = Object (KM.fromList (concat [[("iss", toJSON (gatewayMediaTokenClaimsIss value))], [("purpose", toJSON (gatewayMediaTokenClaimsPurpose value))], [("sub", toJSON (gatewayMediaTokenClaimsSub value))]]))

data GatewayMediaTokenClaimsIss = GatewayMediaTokenClaimsIssU7b_domainU7d_ deriving (Eq, Show)

instance FromJSON GatewayMediaTokenClaimsIss where parseJSON = checked "GatewayMediaTokenClaimsIss" $ \value -> if value == String "{domain}" then pure GatewayMediaTokenClaimsIssU7b_domainU7d_ else fail "unknown enumeration member"

instance ToJSON GatewayMediaTokenClaimsIss where toJSON GatewayMediaTokenClaimsIssU7b_domainU7d_ = String "{domain}"

gatewayMediaTokenClaimsIssText :: GatewayMediaTokenClaimsIss -> Text
gatewayMediaTokenClaimsIssText GatewayMediaTokenClaimsIssU7b_domainU7d_ = "{domain}"

data GatewayMediaTokenClaimsPurpose = GatewayMediaTokenClaimsPurposeMedia deriving (Eq, Show)

instance FromJSON GatewayMediaTokenClaimsPurpose where parseJSON = checked "GatewayMediaTokenClaimsPurpose" $ \value -> if value == String "media" then pure GatewayMediaTokenClaimsPurposeMedia else fail "unknown enumeration member"

instance ToJSON GatewayMediaTokenClaimsPurpose where toJSON GatewayMediaTokenClaimsPurposeMedia = String "media"

gatewayMediaTokenClaimsPurposeText :: GatewayMediaTokenClaimsPurpose -> Text
gatewayMediaTokenClaimsPurposeText GatewayMediaTokenClaimsPurposeMedia = "media"

data GatewayMediaTokenClaimsSub = GatewayMediaTokenClaimsSubU7b_resourceIdU7d_ deriving (Eq, Show)

instance FromJSON GatewayMediaTokenClaimsSub where parseJSON = checked "GatewayMediaTokenClaimsSub" $ \value -> if value == String "{resourceId}" then pure GatewayMediaTokenClaimsSubU7b_resourceIdU7d_ else fail "unknown enumeration member"

instance ToJSON GatewayMediaTokenClaimsSub where toJSON GatewayMediaTokenClaimsSubU7b_resourceIdU7d_ = String "{resourceId}"

gatewayMediaTokenClaimsSubText :: GatewayMediaTokenClaimsSub -> Text
gatewayMediaTokenClaimsSubText GatewayMediaTokenClaimsSubU7b_resourceIdU7d_ = "{resourceId}"

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
