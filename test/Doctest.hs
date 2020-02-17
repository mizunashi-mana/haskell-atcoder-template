{-# LANGUAGE BlockArguments #-}

module Main where

import qualified Build_doctests     as BuildF
import           Control.Monad
import qualified System.IO          as IO
import           Test.DocTest       (doctest)

extensions :: [String]
extensions =
  [ "BlockArguments"
  , "FlexibleContexts"
  , "LambdaCase"
  , "MultiWayIf"
  , "OverloadedLists"
  , "OverloadedStrings"
  , "ScopedTypeVariables"
  , "Strict"
  , "TypeApplications"
  ]

main :: IO ()
main = forM_ BuildF.components \(BuildF.Component name flags pkgs sources) -> do
  putStrLn "============================================="
  print name
  putStrLn "---------------------------------------------"
  IO.hFlush IO.stdout
  let args = ["--fast"] ++ flags ++ pkgs ++ sources ++ [ "-X" ++ ext | ext <- extensions ]
  doctest args
  putStrLn "============================================="
  IO.hFlush IO.stdout
