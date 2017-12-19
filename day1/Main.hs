module Main where

import Data.Char (digitToInt, isDigit)
import Data.Semigroup ((<>))
import Options.Applicative
import System.IO

main :: IO ()
main = solveDay1 =<< execParser opts
  where
    opts = info (day1Parser <**> helper)
      ( fullDesc
     <> progDesc "Advent Code 2017 Day 1 solution"
     <> header "Day1" )

data Day1Option = Day1Option
  { filename :: String
  }

day1Parser :: Parser Day1Option
day1Parser = Day1Option
  <$> strOption
        ( long "file"
       <> metavar "INPUT"
       <> help "Puzzle Input")

solveDay1 :: Day1Option -> IO ()
solveDay1 (Day1Option f) = do
  handle <- openFile f ReadMode
  contents <- hGetContents handle
  putStrLn . show $ computeCaptcha $ filter isDigit contents
  hClose handle


computeCaptcha :: String -> Int
computeCaptcha s = captchaSum numSeries
  where
    inSeries  = s ++ [head s]
    numSeries = fmap digitToInt inSeries

captchaSum :: (Num a, Eq a) => [a] -> a
captchaSum (_:[])                = 0
captchaSum (x:y:xs) | x == y     = x + captchaSum (y:xs)
                    | otherwise  = captchaSum (y:xs)
