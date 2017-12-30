module Main where

import Data.Semigroup ((<>))
import Data.List (sort)
import System.IO
import Options.Applicative
import Control.Monad.State.Lazy

main :: IO ()
main = solveDay4 =<< execParser opts
  where
    opts = info (day4Parser <**> helper)
      ( fullDesc
     <> progDesc "Advent Code 2017 Day 3 solution"
     <> header "Day4" ) 
data Day4Option = Day4Option
  { filename :: String
  }

day4Parser :: Parser Day4Option
day4Parser = Day4Option
  <$> strOption
        ( long "file"
       <> metavar "INPUT"
       <> help "Puzzle Input")


solveDay4 :: Day4Option -> IO ()
solveDay4 (Day4Option f) = do
  handle <- openFile f ReadMode
  contents <- hGetContents handle
  let phrases = lines contents
  putStrLn . show $ length $ filter (not . hasDuplicate) phrases
  putStrLn . show $ length $ filter (not . hasDuplicate2) phrases
  hClose handle


type PassWord   = String
type PassPhrase = String

hasDuplicate :: PassPhrase -> Bool
hasDuplicate p = evalState (hasPassWordsDuplicate . words $ p) []

hasDuplicate2 :: PassPhrase -> Bool
hasDuplicate2 p = evalState (hasPassWordsDuplicate . fmap (sort) $ words $ p) []

hasPassWordsDuplicate :: [PassWord] -> State [PassWord] Bool
hasPassWordsDuplicate [] = return False
hasPassWordsDuplicate (x:xs) = do
  s <- get
  let b = x `elem` s
  let s2 = (x:s)
  put s2
  if b == False then do
    bb <- hasPassWordsDuplicate xs
    return bb
  else return b

 

