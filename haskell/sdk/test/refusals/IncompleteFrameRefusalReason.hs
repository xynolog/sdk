module IncompleteFrameRefusalReason where

import Xynolog.Bus (FrameRefusalReason (..))

missing :: FrameRefusalReason -> Bool
missing FrameRefusalReasonLacks = True
