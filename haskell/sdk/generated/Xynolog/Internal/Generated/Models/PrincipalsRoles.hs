-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.PrincipalsRoles (PrincipalsRoles (..), PrincipalsRolesRolesItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data PrincipalsRoles = PrincipalsRoles
  { principalsRolesComment :: Text,
    principalsRolesRolesClaim :: Text,
    principalsRolesRoles :: [PrincipalsRolesRolesItem],
    principalsRolesKindClaim :: Text,
    principalsRolesAgentKind :: Text
  }
  deriving (Eq, Show)

instance FromJSON PrincipalsRoles where parseJSON = checked "PrincipalsRoles" $ withObject "PrincipalsRoles" (\fields -> PrincipalsRoles <$> (fields .: "$comment") <*> (fields .: "rolesClaim") <*> (fields .: "roles") <*> (fields .: "kindClaim") <*> (fields .: "agentKind"))

instance ToJSON PrincipalsRoles where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (principalsRolesComment value))], [("rolesClaim", toJSON (principalsRolesRolesClaim value))], [("roles", toJSON (principalsRolesRoles value))], [("kindClaim", toJSON (principalsRolesKindClaim value))], [("agentKind", toJSON (principalsRolesAgentKind value))]]))

data PrincipalsRolesRolesItem = PrincipalsRolesRolesItem
  { principalsRolesRolesItemRole :: Text,
    principalsRolesRolesItemDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON PrincipalsRolesRolesItem where parseJSON = checked "PrincipalsRolesRolesItem" $ withObject "PrincipalsRolesRolesItem" (\fields -> PrincipalsRolesRolesItem <$> (fields .: "role") <*> (fields .: "docs"))

instance ToJSON PrincipalsRolesRolesItem where toJSON value = Object (KM.fromList (concat [[("role", toJSON (principalsRolesRolesItemRole value))], [("docs", toJSON (principalsRolesRolesItemDocs value))]]))
