module Main where

import Data.Semigroup ((<>))
import Data.Ratio
import Options.Applicative
import System.IO


main :: IO ()
main = solveDay2 =<< execParser opts
  where
    opts = info (day2Parser <**> helper)
      ( fullDesc
     <> progDesc "Advent Code 2017 Day 2 solution"
     <> header "Day2" )


data Day2Option = Day2Option
  { filename :: String
  }

day2Parser :: Parser Day2Option
day2Parser = Day2Option
  <$> strOption
        ( long "file"
       <> metavar "INPUT"
       <> help "Puzzle Input")

rowDiff :: (Ord a, Num a) => [a] -> a
rowDiff xs = max - min
  where
    min = minimum xs
    max = maximum xs

rowDivisible :: [Integer] -> Integer
rowDivisible xs = numerator . divs . head $ filter isEvenlyDivs perm
  where
    perm               = [(x, y) | x <- xs
                                , y <- xs
                                , x < y]
    isWholeNum :: Float -> Bool
    isWholeNum x       = x == fromInteger (round x)

    isEvenlyDivs :: (Integer, Integer) -> Bool
    isEvenlyDivs (x,y) = isWholeNum $ (fromInteger y) / (fromInteger x)
    divs  :: (Integer, Integer) -> Rational
    divs         (x,y) = (toRational y) / (toRational x)

solveDay2 :: Day2Option -> IO ()
solveDay2 (Day2Option f) = do
  handle <- openFile f ReadMode
  contents <- hGetContents handle
  let rows = fmap words $ lines $ contents
  let numRows = (fmap . fmap) read rows :: [[Integer]]
  let diffPerRows = fmap rowDiff numRows
  let diffPerRows2 = fmap rowDivisible numRows
  putStrLn . show $ sum diffPerRows
  putStrLn . show $ sum diffPerRows2
  hClose handle



