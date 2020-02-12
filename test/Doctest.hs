{-# LANGUAGE BlockArguments #-}

module Main where

import qualified Build_doctests     as BuildF
import           Control.Monad
import           Test.DocTest       (doctest)


main :: IO ()
main = forM_ BuildF.components \(BuildF.Component name flags pkgs sources) -> do
  print name
  putStrLn "----------------------------------------"
  let args = flags ++ pkgs ++ sources
  doctest args
