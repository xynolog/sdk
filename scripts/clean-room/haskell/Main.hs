-- A program that names the SDK's timing table, compiled against the package.
module Main (main) where

import Xynolog.Timing (busRequestTimeoutMs)

main :: IO ()
main = print busRequestTimeoutMs
