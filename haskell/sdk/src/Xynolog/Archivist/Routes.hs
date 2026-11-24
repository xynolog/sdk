-- Generated from protocol/specs/src/archivist/openapi.json and its paths; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Archivist.Routes (ArchivistRoute (..), archivistRouteName, archivistRouteMethod, archivistRoutePath, archivistRouteStatus, archivistRouteMediaType, archivistRouteRequestMediaType, archivistRouteAuthenticated, archivistRouteRequiredHeaders) where

import Data.ByteString (ByteString)
import Data.Text (Text)
import Xynolog.Types

data ArchivistRoute request answer where
  ArchivistListAnchoredTextEntries :: ArchivistRoute () AnchoredTextEntries
  ArchivistPutAnchoredTextStamp :: ArchivistRoute AnchoredTextStamp ()
  ArchivistListStreams :: ArchivistRoute () ArchivistStreamsResponse
  ArchivistGetResourceEvents :: ArchivistRoute () ArchivistEventsResponse
  ArchivistGetHealth :: ArchivistRoute () ArchivistHealth
  ArchivistStoreResource :: ArchivistRoute ResourceUpload CreateResourceResponse
  ArchivistGetResourceAnchoredText :: ArchivistRoute () AnchoredTextAnswer
  ArchivistPutResourceAnchoredText :: ArchivistRoute AnchoredTextWrite ()
  ArchivistGetStoredResourceAnchoredText :: ArchivistRoute () AnchoredTextEntry
  ArchivistGetResourceAnnotations :: ArchivistRoute () GetAnnotationsResponse
  ArchivistGetResourceContent :: ArchivistRoute () ByteString
  ArchivistGetResourceJsonLd :: ArchivistRoute () GetResourceResponse

archivistRouteName :: ArchivistRoute request answer -> Text
archivistRouteName ArchivistListAnchoredTextEntries = "ListAnchoredTextEntries"
archivistRouteName ArchivistPutAnchoredTextStamp = "PutAnchoredTextStamp"
archivistRouteName ArchivistListStreams = "ListStreams"
archivistRouteName ArchivistGetResourceEvents = "GetResourceEvents"
archivistRouteName ArchivistGetHealth = "GetHealth"
archivistRouteName ArchivistStoreResource = "StoreResource"
archivistRouteName ArchivistGetResourceAnchoredText = "GetResourceAnchoredText"
archivistRouteName ArchivistPutResourceAnchoredText = "PutResourceAnchoredText"
archivistRouteName ArchivistGetStoredResourceAnchoredText = "GetStoredResourceAnchoredText"
archivistRouteName ArchivistGetResourceAnnotations = "GetResourceAnnotations"
archivistRouteName ArchivistGetResourceContent = "GetResourceContent"
archivistRouteName ArchivistGetResourceJsonLd = "GetResourceJsonLd"

archivistRouteMethod :: ArchivistRoute request answer -> ByteString
archivistRouteMethod ArchivistListAnchoredTextEntries = "GET"
archivistRouteMethod ArchivistPutAnchoredTextStamp = "PUT"
archivistRouteMethod ArchivistListStreams = "GET"
archivistRouteMethod ArchivistGetResourceEvents = "GET"
archivistRouteMethod ArchivistGetHealth = "GET"
archivistRouteMethod ArchivistStoreResource = "POST"
archivistRouteMethod ArchivistGetResourceAnchoredText = "GET"
archivistRouteMethod ArchivistPutResourceAnchoredText = "PUT"
archivistRouteMethod ArchivistGetStoredResourceAnchoredText = "GET"
archivistRouteMethod ArchivistGetResourceAnnotations = "GET"
archivistRouteMethod ArchivistGetResourceContent = "GET"
archivistRouteMethod ArchivistGetResourceJsonLd = "GET"

archivistRoutePath :: ArchivistRoute request answer -> Text
archivistRoutePath ArchivistListAnchoredTextEntries = "/anchored-text/entries"
archivistRoutePath ArchivistPutAnchoredTextStamp = "/anchored-text/stamp"
archivistRoutePath ArchivistListStreams = "/events"
archivistRoutePath ArchivistGetResourceEvents = "/events/{resourceId}"
archivistRoutePath ArchivistGetHealth = "/health"
archivistRoutePath ArchivistStoreResource = "/resources"
archivistRoutePath ArchivistGetResourceAnchoredText = "/resources/{id}/anchored-text"
archivistRoutePath ArchivistPutResourceAnchoredText = "/resources/{id}/anchored-text"
archivistRoutePath ArchivistGetStoredResourceAnchoredText = "/resources/{id}/anchored-text/stored"
archivistRoutePath ArchivistGetResourceAnnotations = "/resources/{id}/annotations"
archivistRoutePath ArchivistGetResourceContent = "/resources/{id}/content"
archivistRoutePath ArchivistGetResourceJsonLd = "/resources/{id}/jsonld"

archivistRouteStatus :: ArchivistRoute request answer -> Int
archivistRouteStatus ArchivistListAnchoredTextEntries = 200
archivistRouteStatus ArchivistPutAnchoredTextStamp = 204
archivistRouteStatus ArchivistListStreams = 200
archivistRouteStatus ArchivistGetResourceEvents = 200
archivistRouteStatus ArchivistGetHealth = 200
archivistRouteStatus ArchivistStoreResource = 200
archivistRouteStatus ArchivistGetResourceAnchoredText = 200
archivistRouteStatus ArchivistPutResourceAnchoredText = 204
archivistRouteStatus ArchivistGetStoredResourceAnchoredText = 200
archivistRouteStatus ArchivistGetResourceAnnotations = 200
archivistRouteStatus ArchivistGetResourceContent = 200
archivistRouteStatus ArchivistGetResourceJsonLd = 200

archivistRouteMediaType :: ArchivistRoute request answer -> Maybe ByteString
archivistRouteMediaType ArchivistListAnchoredTextEntries = Just "application/json"
archivistRouteMediaType ArchivistPutAnchoredTextStamp = Nothing
archivistRouteMediaType ArchivistListStreams = Just "application/json"
archivistRouteMediaType ArchivistGetResourceEvents = Just "application/json"
archivistRouteMediaType ArchivistGetHealth = Just "application/json"
archivistRouteMediaType ArchivistStoreResource = Just "application/json"
archivistRouteMediaType ArchivistGetResourceAnchoredText = Just "application/json"
archivistRouteMediaType ArchivistPutResourceAnchoredText = Nothing
archivistRouteMediaType ArchivistGetStoredResourceAnchoredText = Just "application/json"
archivistRouteMediaType ArchivistGetResourceAnnotations = Just "application/json"
archivistRouteMediaType ArchivistGetResourceContent = Just "*/*"
archivistRouteMediaType ArchivistGetResourceJsonLd = Just "application/ld+json"

archivistRouteRequestMediaType :: ArchivistRoute request answer -> Maybe ByteString
archivistRouteRequestMediaType ArchivistListAnchoredTextEntries = Nothing
archivistRouteRequestMediaType ArchivistPutAnchoredTextStamp = Just "application/json"
archivistRouteRequestMediaType ArchivistListStreams = Nothing
archivistRouteRequestMediaType ArchivistGetResourceEvents = Nothing
archivistRouteRequestMediaType ArchivistGetHealth = Nothing
archivistRouteRequestMediaType ArchivistStoreResource = Just "multipart/form-data"
archivistRouteRequestMediaType ArchivistGetResourceAnchoredText = Nothing
archivistRouteRequestMediaType ArchivistPutResourceAnchoredText = Just "application/json"
archivistRouteRequestMediaType ArchivistGetStoredResourceAnchoredText = Nothing
archivistRouteRequestMediaType ArchivistGetResourceAnnotations = Nothing
archivistRouteRequestMediaType ArchivistGetResourceContent = Nothing
archivistRouteRequestMediaType ArchivistGetResourceJsonLd = Nothing

archivistRouteAuthenticated :: ArchivistRoute request answer -> Bool
archivistRouteAuthenticated ArchivistListAnchoredTextEntries = True
archivistRouteAuthenticated ArchivistPutAnchoredTextStamp = True
archivistRouteAuthenticated ArchivistListStreams = True
archivistRouteAuthenticated ArchivistGetResourceEvents = True
archivistRouteAuthenticated ArchivistGetHealth = False
archivistRouteAuthenticated ArchivistStoreResource = True
archivistRouteAuthenticated ArchivistGetResourceAnchoredText = True
archivistRouteAuthenticated ArchivistPutResourceAnchoredText = True
archivistRouteAuthenticated ArchivistGetStoredResourceAnchoredText = True
archivistRouteAuthenticated ArchivistGetResourceAnnotations = True
archivistRouteAuthenticated ArchivistGetResourceContent = True
archivistRouteAuthenticated ArchivistGetResourceJsonLd = True

archivistRouteRequiredHeaders :: ArchivistRoute request answer -> [(ByteString, Text)]
archivistRouteRequiredHeaders ArchivistListAnchoredTextEntries = []
archivistRouteRequiredHeaders ArchivistPutAnchoredTextStamp = []
archivistRouteRequiredHeaders ArchivistListStreams = []
archivistRouteRequiredHeaders ArchivistGetResourceEvents = []
archivistRouteRequiredHeaders ArchivistGetHealth = []
archivistRouteRequiredHeaders ArchivistStoreResource = [("Xynolog-Principal", "ArchivistStoreResourceHeader0"), ("Idempotency-Key", "ArchivistStoreResourceHeader2")]
archivistRouteRequiredHeaders ArchivistGetResourceAnchoredText = []
archivistRouteRequiredHeaders ArchivistPutResourceAnchoredText = []
archivistRouteRequiredHeaders ArchivistGetStoredResourceAnchoredText = []
archivistRouteRequiredHeaders ArchivistGetResourceAnnotations = []
archivistRouteRequiredHeaders ArchivistGetResourceContent = []
archivistRouteRequiredHeaders ArchivistGetResourceJsonLd = []
