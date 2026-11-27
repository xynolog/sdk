{-# LANGUAGE ScopedTypeVariables #-}

-- | Session ownership supplied to a registry, over HTTP or a host's carrier.
module Xynolog.Registry.Factory (SessionFactory (..), SessionFactoryOptions (..), newHttpSessionFactory) where

import Control.Concurrent.STM (atomically)
import Control.Monad (void)
import Data.Scientific (Scientific)
import Xynolog.Auth qualified as Auth
import Xynolog.Client qualified as Client
import Xynolog.Http qualified as Http
import Xynolog.Internal.Generated.SessionFactoryOptions
import Xynolog.Internal.Issuer qualified as Issuer
import Xynolog.Registry.Stored qualified as Stored
import Xynolog.Session qualified as Session
import Xynolog.State.SessionSignals qualified as Signals
import Xynolog.Timing.Settings qualified as Timing
import Xynolog.Types

data SessionFactory = SessionFactory
  { openSession :: SessionFactoryOptions -> IO Session.OpenedSession,
    revokeSession :: StoredSession -> IO ()
  }

newHttpSessionFactory :: Http.HttpOptions -> Timing.ClientTiming -> IO Scientific -> SessionFactory
newHttpSessionFactory http timing wall = SessionFactory open revoke
  where
    issuer = Issuer.IssuerOptions (Http.httpClient http) (Http.httpTime http) (Http.httpTiming http)
    revoke = void . Issuer.revokeStored issuer
    open options = do
      let kb = sessionFactoryOptionsKb options
          kept = Stored.keptIn (sessionFactoryOptionsStorage options) (knowledgeBaseId kb)
          settings =
            Session.SessionOptions
              (knowledgeBaseId kb)
              (KbTarget {kbTargetEndpoint = (knowledgeBaseEndpoint kb), kbTargetId = (knowledgeBaseId kb), kbTargetLabel = (knowledgeBaseLabel kb)})
              kept
              Nothing
              Nothing
              (Just validate)
              (atomically . Signals.notifySessionEnded (sessionFactoryOptionsSignals options))
              wall
      Session.fromKeptSession http timing (Just (sessionFactoryOptionsStorage options)) settings
    validate client access = case Client.auth client of
      Nothing -> ioError (userError "The HTTP session factory built no gateway identity operation")
      Just auth -> Just <$> Auth.me auth (Just access)
