-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ProjectConfig (ProjectConfig (..), ProjectConfigGit (..), ProjectConfigProject (..), ProjectConfigSite (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ProjectConfig = ProjectConfig
  { projectConfigGit :: ProjectConfigGit,
    projectConfigProject :: ProjectConfigProject,
    projectConfigSite :: ProjectConfigSite
  }
  deriving (Eq, Show)

instance FromJSON ProjectConfig where parseJSON = checked "ProjectConfig" $ withObject "ProjectConfig" (\fields -> ProjectConfig <$> (fields .: "git") <*> (fields .: "project") <*> (fields .: "site"))

instance ToJSON ProjectConfig where toJSON value = Object (KM.fromList (concat [[("git", toJSON (projectConfigGit value))], [("project", toJSON (projectConfigProject value))], [("site", toJSON (projectConfigSite value))]]))

data ProjectConfigGit = ProjectConfigGit
  { projectConfigGitSync :: Bool
  }
  deriving (Eq, Show)

instance FromJSON ProjectConfigGit where parseJSON = checked "ProjectConfigGit" $ withObject "ProjectConfigGit" (\fields -> ProjectConfigGit <$> (fields .: "sync"))

instance ToJSON ProjectConfigGit where toJSON value = Object (KM.fromList (concat [[("sync", toJSON (projectConfigGitSync value))]]))

data ProjectConfigProject = ProjectConfigProject
  { projectConfigProjectName :: Text,
    projectConfigProjectVersion :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ProjectConfigProject where parseJSON = checked "ProjectConfigProject" $ withObject "ProjectConfigProject" (\fields -> ProjectConfigProject <$> (fields .: "name") <*> optional fields "version")

instance ToJSON ProjectConfigProject where toJSON value = Object (KM.fromList (concat [[("name", toJSON (projectConfigProjectName value))], optionalPair "version" (projectConfigProjectVersion value)]))

data ProjectConfigSite = ProjectConfigSite
  { projectConfigSiteDomain :: Text,
    projectConfigSiteSiteName :: Text
  }
  deriving (Eq, Show)

instance FromJSON ProjectConfigSite where parseJSON = checked "ProjectConfigSite" $ withObject "ProjectConfigSite" (\fields -> ProjectConfigSite <$> (fields .: "domain") <*> (fields .: "siteName"))

instance ToJSON ProjectConfigSite where toJSON value = Object (KM.fromList (concat [[("domain", toJSON (projectConfigSiteDomain value))], [("siteName", toJSON (projectConfigSiteSiteName value))]]))
