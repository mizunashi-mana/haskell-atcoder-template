{-# LANGUAGE BlockArguments      #-}
{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE LambdaCase          #-}
{-# LANGUAGE MultiWayIf          #-}
{-# LANGUAGE OverloadedLists     #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE Strict              #-}
{-# LANGUAGE TypeApplications    #-}

module Main where

import           Control.Applicative
import           Control.Monad
import qualified Control.Monad.Primitive           as Prim
import qualified Data.Attoparsec.ByteString.Char8  as Parse
import           Data.Bits
import qualified Data.ByteString.Char8             as BS
import qualified Data.ByteString.Internal          as BSInternal
import qualified Data.ByteString                   as BSInternal
import           Data.Foldable                     hiding (foldl, foldr, foldr')
import           Data.Function
import           Data.Functor
import           Data.Monoid
import           Data.MonoTraversable              hiding (omapM, oforM)
import qualified Data.Vector.Generic               as Vec
import qualified Data.Vector.Generic.Mutable       as MVec
import qualified Data.Vector.Algorithms.Intro      as MVec
import qualified Data.Vector.Unboxed               as UVec
import qualified Data.Vector.Unboxed.Mutable       as UMVec
import qualified Data.Vector.Fusion.Stream.Monadic as VecBundle
import qualified Data.Vector.Fusion.Bundle.Monadic as VecBundle
import qualified Data.Vector.Fusion.Bundle.Size    as VecBundle
import qualified Debug.Trace                       as Debug
import           GHC.Exts                          as GHC
import           Prelude                           hiding (foldl, foldr, head, tail, String)
import qualified Prelude
import qualified System.IO                         as IO


-- Containers

type Vector     = UVec.Vector
type MVector    = UMVec.MVector (Prim.PrimState IO)

ifoldlMVec' :: forall a b. UVec.Unbox a => (b -> Int -> a -> b) -> b -> MVector a -> IO b
ifoldlMVec' f y0 xs = do
  xs' <- Vec.unsafeFreeze xs
  pure $ Vec.ifoldl' f y0 xs'

mvecFromList :: UVec.Unbox a => [a] -> IO (MVector a)
mvecFromList xs = Vec.unsafeThaw $ UVec.fromList xs

mvecToList :: UVec.Unbox a => MVector a -> IO [a]
mvecToList xs = Vec.unsafeFreeze xs <&> otoList

class MonoTraversable mono => MonoTraversableM mono where
  omapM :: Monad m => (Element mono -> m (Element mono)) -> mono -> m mono

instance UVec.Unbox a => MonoTraversableM (UVec.Vector a) where
  omapM = Vec.mapM

oforM :: forall m mono. Monad m => MonoTraversableM mono =>
  mono -> (Element mono -> m (Element mono)) -> m mono
oforM xs f = omapM f xs


-- Strings

type ByteString = BS.ByteString
type Parser     = Parse.Parser

parseOnlyEof :: Parser a -> ByteString -> Either Prelude.String a
parseOnlyEof p s = Parse.parseOnly (p <* Parse.endOfInput) s


-- IO

class ReadBS a where
  readBS :: ByteString -> a

instance ReadBS Int where
  readBS s = case BS.readInt s of
    Just (i, _) -> i
    Nothing     -> error "failed to readInt"

readsBS :: forall a. ReadBS a => ByteString -> [a]
readsBS s = [ readBS x | x <- BS.words s ]

readLineInputs :: forall a. ReadBS a => IO [a]
readLineInputs = readsBS <$> BS.getLine

readsBSBundle :: ReadBS a => Monad m => ByteString -> VecBundle.Bundle m v a
readsBSBundle s = VecBundle.fromStream readsBSStream VecBundle.Unknown
  where
    readsBSStream = VecBundle.Stream step
      $ BSInternal.splitWith BSInternal.isSpaceWord8 s

    step = \case
      []   -> pure VecBundle.Done
      x:xs
        | onull x   -> pure $ VecBundle.Skip xs
        | otherwise -> pure $ VecBundle.Yield (readBS x) xs

readLineInputsVec :: forall a. ReadBS a => UVec.Unbox a => IO (Vector a)
readLineInputsVec = Vec.unstream . readsBSBundle <$> BS.getLine

readLineInputsMVec :: forall a. ReadBS a => UVec.Unbox a => IO (MVector a)
readLineInputsMVec = do
  line <- BS.getLine
  MVec.unstream $ readsBSBundle line

discardLine :: IO ()
discardLine = getLine >> pure ()

putSpace :: IO ()
putSpace = putStr " "

putEndLine :: IO ()
putEndLine = putStrLn ""

printN :: Show a => a -> IO ()
printN x = putStr $ show x

prints :: Show a => [a] -> IO ()
prints []     = putEndLine
prints (x:xs) = do
  printN x
  forM_ xs \y -> do
    putSpace
    printN y
  putEndLine
{-# INLINE prints #-}

putFlush :: IO ()
putFlush = IO.hFlush IO.stdout


-- Utilities

countElem :: Eq a => a -> [a] -> Int
countElem x ys = foldl' (\acc y -> acc + if x == y then 1 else 0) 0 ys

flipOrdering :: Ordering -> Ordering
flipOrdering GT = LT
flipOrdering EQ = EQ
flipOrdering LT = GT

rcompare :: Ord a => a -> a -> Ordering
rcompare x y = flipOrdering $ compare x y

altconcat :: forall f a. Alternative f => [f a] -> f a
altconcat xs = coerce $ mconcat @(Alt f a) $ coerce xs

succN :: Enum a => a -> Int -> a
succN x n = toEnum $ fromEnum x + n
