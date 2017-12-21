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
  putStrLn ("Part 1: " ++ (show $ computeCaptcha $ filter isDigit contents))
  putStrLn ("Part 2: " ++ (show $ computeCaptcha2 $ filter isDigit contents))
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

computeCaptcha2 :: String -> Int
computeCaptcha2 s = captchaSum2 numSeries
  where
    numSeries = fmap digitToInt s


captchaSum2 :: [Int] -> Int
captchaSum2 xs = captchaSum2' xs (len `div` 2)
  where
    len = length xs
    nextIndex i = (i + 1) `mod` len
    captchaSum2' :: [Int] -> Int -> Int
    captchaSum2' ([])   _ = 0
    captchaSum2' (x:ys) i | x == xs !! i  = x + (captchaSum2' ys $ nextIndex i)
                          | otherwise     = captchaSum2' ys $ nextIndex i



