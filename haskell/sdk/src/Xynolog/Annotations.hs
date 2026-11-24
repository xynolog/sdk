{-# LANGUAGE OverloadedStrings #-}

-- | Typed readers and reproducible builders of W3C annotations. All offsets
-- count Unicode code points. A caller supplies the creation time.
module Xynolog.Annotations
  ( QuotedText (..),
    TextSpan (..),
    ReconciledSpan (..),
    AnchorMethod (..),
    MatchQuality (..),
    SpanRefusedError (..),
    SpanRefusalCode (..),
    Spanned (..),
    bodySource,
    isBodyResolved,
    targetSource,
    targetSelector,
    isHighlight,
    isReference,
    isAssessment,
    isComment,
    isTag,
    commentText,
    isStubReference,
    isResolvedReference,
    textQuoteSelector,
    textPositionSelector,
    svgSelector,
    fragmentSelector,
    exactText,
    annotationExactText,
    entityTypes,
    tagCategory,
    tagSchemaId,
    reconcile,
    textSpanOf,
    annotationOfSpan,
    annotationOfResource,
  )
where

import Control.Exception (Exception, throwIO)
import Control.Monad (forM_, unless)
import Data.Aeson (toJSON)
import Data.Maybe (isJust, listToMaybe, mapMaybe)
import Data.Text (Text)
import Data.Text qualified as Text
import Data.Time (UTCTime, defaultTimeLocale, formatTime)
import Xynolog.ErrorCodes (SpanRefusalCode (..))
import Xynolog.Internal.Annotations.Id qualified as Id
import Xynolog.Internal.Annotations.Pdf qualified as Pdf
import Xynolog.Internal.Annotations.Spans (between, collapsed, reconcile)
import Xynolog.Types hiding (tagSchemaId)

data SpanRefusedError = SpanRefusedError
  { spanRefusedCode :: SpanRefusalCode,
    spanRefusedMessage :: Text
  }
  deriving (Eq, Show)

instance Exception SpanRefusedError

data Spanned = TextContent Text | PdfContent AnchoredText deriving (Eq, Show)

bodies :: Maybe AnnotationBodies -> [AnnotationBody]
bodies Nothing = []
bodies (Just (AnnotationBodiesAnnotationBody body)) = [body]
bodies (Just (AnnotationBodiesList body)) = body

selectors :: AnnotationSelector -> [Selector]
selectors (AnnotationSelectorSelector selector) = [selector]
selectors (AnnotationSelectorList values) = values

bodySource :: Maybe AnnotationBodies -> Maybe ResourceId
bodySource = listToMaybe . mapMaybe source . bodies
  where
    source (AnnotationBodySpecificResource resource) = Just (specificResourceSource resource); source _ = Nothing

isBodyResolved :: Maybe AnnotationBodies -> Bool
isBodyResolved = isJust . bodySource

targetSource :: AnnotationTargetInline -> ResourceId
targetSource (AnnotationTargetInlineResourceId resource) = resource
targetSource (AnnotationTargetInlineAnnotationTarget target) = annotationTargetSource target

targetSelector :: AnnotationTargetInline -> Maybe AnnotationSelector
targetSelector (AnnotationTargetInlineResourceId _) = Nothing
targetSelector (AnnotationTargetInlineAnnotationTarget target) = annotationTargetSelector target

isHighlight, isReference, isAssessment, isComment, isTag :: Annotation -> Bool
isHighlight = (== MotivationHighlighting) . annotationMotivation
isReference = (== MotivationLinking) . annotationMotivation
isAssessment = (== MotivationAssessing) . annotationMotivation
isComment = (== MotivationCommenting) . annotationMotivation
isTag = (== MotivationTagging) . annotationMotivation

commentText :: Annotation -> Maybe Text
commentText annotation
  | isComment annotation = case bodies (annotationBody annotation) of AnnotationBodyTextualBody body : _ -> Just (textualBodyValue body); _ -> Nothing
  | otherwise = Nothing

isStubReference, isResolvedReference :: Annotation -> Bool
isStubReference annotation = isReference annotation && not (isBodyResolved (annotationBody annotation))
isResolvedReference annotation = isReference annotation && isBodyResolved (annotationBody annotation)

textQuoteSelector :: AnnotationSelector -> Maybe TextQuoteSelector
textQuoteSelector = listToMaybe . mapMaybe select . selectors
  where
    select (SelectorTextQuoteSelector value) = Just value; select _ = Nothing

textPositionSelector :: AnnotationSelector -> Maybe TextPositionSelector
textPositionSelector = listToMaybe . mapMaybe select . selectors
  where
    select (SelectorTextPositionSelector value) = Just value; select _ = Nothing

svgSelector :: AnnotationSelector -> Maybe SvgSelector
svgSelector = listToMaybe . mapMaybe select . selectors
  where
    select (SelectorSvgSelector value) = Just value; select _ = Nothing

fragmentSelector :: AnnotationSelector -> Maybe FragmentSelector
fragmentSelector = listToMaybe . mapMaybe select . selectors
  where
    select (SelectorFragmentSelector value) = Just value; select _ = Nothing

exactText :: Maybe AnnotationSelector -> Text
exactText selector = maybe "" textQuoteSelectorExact (selector >>= textQuoteSelector)

annotationExactText :: Annotation -> Text
annotationExactText = exactText . targetSelector . annotationTarget

textsFor :: BodyPurpose -> Annotation -> [Text]
textsFor purpose annotation = [textualBodyValue body | AnnotationBodyTextualBody body <- bodies (annotationBody annotation), textualBodyPurpose body == Just purpose]

entityTypes :: Annotation -> [Text]
entityTypes = filter (not . Text.null) . textsFor BodyPurposeTagging

tagCategory, tagSchemaId :: Annotation -> Maybe Text
tagCategory annotation = if isTag annotation then listToMaybe (textsFor BodyPurposeTagging annotation) else Nothing
tagSchemaId annotation = if isTag annotation then listToMaybe (textsFor BodyPurposeClassifying annotation) else Nothing

built :: IO UTCTime -> ResourceId -> Motivation -> Text -> AnnotationTarget -> Maybe Agent -> Maybe AnnotationBodies -> IO Annotation
built wall resource motivation anchor target generator body = do
  identity <- either (ioError . userError) pure (Id.annotationIdFor resource motivation anchor (toJSON <$> body))
  instant <- wall
  let created = Text.pack (formatTime defaultTimeLocale "%Y-%m-%dT%H:%M:%S%3QZ" instant)
  pure
    ( Annotation
        AnnotationU40_contextHttpU3a_U2f_U2f_wwwU2e_w3U2e_orgU2f_nsU2f_annoU2e_jsonld
        body
        created
        Nothing
        (OneOrMoreAgentsAgent <$> generator)
        identity
        Nothing
        motivation
        (AnnotationTargetInlineAnnotationTarget target)
        AnnotationTypeAnnotation
        Nothing
        mempty
    )

annotationOfResource :: IO UTCTime -> ResourceId -> Motivation -> Maybe Agent -> Maybe AnnotationBodies -> IO Annotation
annotationOfResource wall resource motivation generator body =
  built wall resource motivation "" (AnnotationTarget Nothing resource Nothing mempty) generator body

-- | The span a reconciliation found, as 'annotationOfSpan' takes one.
textSpanOf :: ReconciledSpan -> TextSpan
textSpanOf (ReconciledSpanReconciledSpanUniqueMatch found) = TextSpan (reconciledSpanUniqueMatchEnd found) (reconciledSpanUniqueMatchExact found) (reconciledSpanUniqueMatchPrefix found) (reconciledSpanUniqueMatchStart found) (reconciledSpanUniqueMatchSuffix found)
textSpanOf (ReconciledSpanReconciledSpanContextRecovered found) = TextSpan (reconciledSpanContextRecoveredEnd found) (reconciledSpanContextRecoveredExact found) (reconciledSpanContextRecoveredPrefix found) (reconciledSpanContextRecoveredStart found) (reconciledSpanContextRecoveredSuffix found)
textSpanOf (ReconciledSpanReconciledSpanFirstOfMany found) = TextSpan (reconciledSpanFirstOfManyEnd found) (reconciledSpanFirstOfManyExact found) (reconciledSpanFirstOfManyPrefix found) (reconciledSpanFirstOfManyStart found) (reconciledSpanFirstOfManySuffix found)
textSpanOf (ReconciledSpanReconciledSpanFuzzyMatch found) = TextSpan (reconciledSpanFuzzyMatchEnd found) (reconciledSpanFuzzyMatchExact found) (reconciledSpanFuzzyMatchPrefix found) (reconciledSpanFuzzyMatchStart found) (reconciledSpanFuzzyMatchSuffix found)

annotationOfSpan :: IO UTCTime -> Spanned -> TextSpan -> ResourceId -> Motivation -> Agent -> Maybe AnnotationBodies -> IO Annotation
annotationOfSpan wall content spanValue resource motivation generator body = do
  let whole = case content of TextContent value -> value; PdfContent value -> anchoredTextText value
      lengthInPoints = toInteger (Text.length whole)
      valid start end = start >= 0 && end >= start && end <= lengthInPoints
      refuse code message = throwIO (SpanRefusedError code message)
  case content of
    TextContent _ -> pure ()
    PdfContent anchored -> forM_ (anchoredTextItems anchored) $ \item ->
      unless
        (valid (pdfTextItemStart item) (pdfTextItemEnd item))
        (refuse SpanRefusalItemOutOfRange "An anchored-text item is not a stretch of its text")
  unless
    (valid (textSpanStart spanValue) (textSpanEnd spanValue))
    (refuse SpanRefusalSpanOutOfRange "The offsets are not a span of the text")
  let start = textSpanStart spanValue
      end = textSpanEnd spanValue
      exact = textSpanExact spanValue
  places <- case content of
    TextContent _ -> do
      unless
        (between whole (fromInteger start) (fromInteger end) == exact)
        (refuse SpanRefusalExactMismatch "The span's words differ from the text between its offsets")
      pure [SelectorTextPositionSelector (TextPositionSelector end start TextPositionSelectorTypeTextPositionSelector mempty)]
    PdfContent anchored -> do
      let (overlapping, rectangles) = Pdf.locate anchored start end
      unless (not (null rectangles)) (refuse SpanRefusalNothingLocated "No anchored-text item overlaps the span")
      let covered = between whole (fromInteger (minimum (map pdfTextItemStart overlapping))) (fromInteger (maximum (map pdfTextItemEnd overlapping)))
      unless
        (collapsed exact `Text.isInfixOf` collapsed covered)
        (refuse SpanRefusalExactNotCovered "The overlapping items do not cover the span's words")
      pure [SelectorFragmentSelector (FragmentSelector (Just "http://tools.ietf.org/rfc/rfc3778") FragmentSelectorTypeFragmentSelector (Pdf.fragmentOf rectangle) mempty) | rectangle <- rectangles]
  forM_ (textSpanPrefix spanValue) $ \prefix ->
    unless
      (prefix `Text.isSuffixOf` Text.take (fromInteger start) whole)
      (refuse SpanRefusalPrefixMismatch "The span's prefix differs from the text before it")
  forM_ (textSpanSuffix spanValue) $ \suffix ->
    unless
      (suffix `Text.isPrefixOf` Text.drop (fromInteger end) whole)
      (refuse SpanRefusalSuffixMismatch "The span's suffix differs from the text after it")
  let nonempty = (>>= \value -> if Text.null value then Nothing else Just value)
      quote = SelectorTextQuoteSelector (TextQuoteSelector exact (nonempty (textSpanPrefix spanValue)) (nonempty (textSpanSuffix spanValue)) TextQuoteSelectorTypeTextQuoteSelector mempty)
      target = AnnotationTarget (Just (AnnotationSelectorList (places ++ [quote]))) resource (Just AnnotationTargetTypeSpecificResource) mempty
      anchor = Text.pack (show start) <> ":" <> Text.pack (show end) <> ":" <> exact
  built wall resource motivation anchor target (Just generator) body
