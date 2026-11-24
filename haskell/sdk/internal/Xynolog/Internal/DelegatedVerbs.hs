module Xynolog.Internal.DelegatedVerbs (mark, yield) where

import Xynolog.Internal.Delegation (Verb (..))
import Xynolog.Types

mark :: Verb MarkJobCompleteCommand
mark =
  Verb
    (\completion -> case completion of JobCompleteCommandMarkJobCompleteCommand value -> Just value; JobCompleteCommandYieldJobCompleteCommand _ -> Nothing)
    ( \status resource ->
        if jobStatusResponseType status /= JobTypeMark
          then Nothing
          else do
            result <- case jobStatusResponseResult status of
              Nothing -> Just Nothing
              Just (JobStoredResultObject _) -> Just Nothing
              Just (JobStoredResultJobResult value) -> case value of
                JobResultMarkJobDone done -> Just (Just (MarkJobResultMarkJobDone done))
                JobResultYieldJobDone _ -> Nothing
                JobResultJobDeclined decline -> Just (Just (MarkJobResultJobDeclined decline))
            pure (MarkJobCompleteCommand Nothing Nothing Nothing (jobStatusResponseJobId status) MarkJobCompleteCommandJobTypeMark resource result mempty)
    )

yield :: Verb YieldJobCompleteCommand
yield =
  Verb
    (\completion -> case completion of JobCompleteCommandMarkJobCompleteCommand _ -> Nothing; JobCompleteCommandYieldJobCompleteCommand value -> Just value)
    ( \status resource ->
        if jobStatusResponseType status /= JobTypeYield
          then Nothing
          else do
            result <- case jobStatusResponseResult status of
              Nothing -> Just Nothing
              Just (JobStoredResultObject _) -> Just Nothing
              Just (JobStoredResultJobResult value) -> case value of
                JobResultMarkJobDone _ -> Nothing
                JobResultYieldJobDone done -> Just (Just (YieldJobResultYieldJobDone done))
                JobResultJobDeclined decline -> Just (Just (YieldJobResultJobDeclined decline))
            pure (YieldJobCompleteCommand Nothing Nothing Nothing Nothing (jobStatusResponseJobId status) YieldJobCompleteCommandJobTypeYield resource result mempty)
    )
