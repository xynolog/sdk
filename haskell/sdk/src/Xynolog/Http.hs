{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Http
  ( HttpTransport,
    HttpClient,
    HttpOptions (..),
    newHttpClient,
    newHttpTransport,
    transport,
    content,
    gateway,
    dispose,
  )
where

import Control.Exception (finally, onException)
import Data.Set qualified as Set
import Xynolog.Channels (scopedChannels)
import Xynolog.Content (ContentTransport)
import Xynolog.Content qualified as Content
import Xynolog.Gateway
import Xynolog.Http.Routes
import Xynolog.Internal.Http (HttpClient, HttpOptions (..), newHttpClient)
import Xynolog.Internal.Http qualified as Internal
import Xynolog.Internal.HttpActor (runActor)
import Xynolog.Internal.HttpContent (newContent)
import Xynolog.Transport qualified as Transport
import Xynolog.Types

data HttpTransport = HttpTransport Internal.Http ContentTransport GatewayOperations

newHttpTransport :: HttpOptions -> IO HttpTransport
newHttpTransport options = do
  http <- Internal.newHttp options (Set.union (httpGlobalChannels options) (Set.fromList scopedChannels)) runActor
  contents <- newContent http `onException` Transport.dispose (Internal.transport http)
  let empty = ()
      operations =
        GatewayOperations
          { getCurrentUser = \override -> Internal.json http GetCurrentUser Nothing override empty,
            getMediaToken = \resource -> Internal.json http CreateMediaToken Nothing Nothing (MediaTokenRequest resource),
            getProtectedResourceMetadata = Internal.json http GetProtectedResourceMetadata Nothing Nothing empty,
            healthCheck = Internal.json http GetHealth Nothing Nothing empty,
            getStatus = Internal.json http GetStatus Nothing Nothing empty
          }
  pure (HttpTransport http contents operations)

transport :: HttpTransport -> Transport.Transport
transport (HttpTransport http _ _) = Internal.transport http

content :: HttpTransport -> ContentTransport
content (HttpTransport _ contents _) = contents

gateway :: HttpTransport -> GatewayOperations
gateway (HttpTransport _ _ operations) = operations

dispose :: HttpTransport -> IO ()
dispose value = Content.dispose (content value) `finally` Transport.dispose (transport value)
