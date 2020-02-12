#include "../src/Header.hs"

main :: IO ()
main = do
  [n] <- readLineInputs
  print $ solve n

-- |
--
-- >>> solve 10
-- 10
--
solve :: Int -> Int
solve n = n
