module Main where

import Data.Semigroup ((<>))
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


solveDay2 :: Day2Option -> IO ()
solveDay2 (Day2Option f) = do
  handle <- openFile f ReadMode
  contents <- hGetContents handle
  let rows = fmap words $ lines $ contents
  let numRows = (fmap . fmap) read rows :: [[Int]]
  let diffPerRows = fmap rowDiff numRows
  putStrLn . show $ sum diffPerRows
  hClose handle
