module Main where

import Data.Semigroup ((<>))
import Options.Applicative
import System.IO

main :: IO ()
main = solveDay3 =<< execParser opts
  where
    opts = info (day3Parser <**> helper)
      ( fullDesc
     <> progDesc "Advent Code 2017 Day 3 solution"
     <> header "Day3" )

data Day3Option = Day3Option
  { filename :: String
  }

day3Parser :: Parser Day3Option
day3Parser = Day3Option
  <$> strOption
        ( long "file"
       <> metavar "INPUT"
       <> help "Puzzle Input")



-- Idea:
-- Get the layer that contains the number: ex (12)
-- X X * X X
-- X 5 4 3 X
-- * 6 1 2 *
-- X 7 8 9 X
-- X X * X X
-- We can now know the "x coordinate"
-- Get the "*", and get the min diff of 12 and the value in "*" -> y coor
-- x + y => TADAAA

maxCircle :: Int -> Int
maxCircle 0 = 1
maxCircle n = (n*2+1)^2

getSides :: Int -> [Int]
getSides n = fmap sides [0..3]
  where
    maxSide = maxCircle n               -- Max number in the circle
    len = (n*2+1)                       -- length of one side of the wall
    sides i = maxSide - (i * (len - 1)) -- corner value

stepsToOuter :: Int -> Int
stepsToOuter n = length $ takeWhile (<n) $ fmap maxCircle  [0..]

getOuterSide :: Int -> [Int]
getOuterSide n = getSides $ stepsToOuter n

getSteps :: Int -> Int
getSteps n = x + y
  where
    sides = getOuterSide n
    x = stepsToOuter n
    y = minimum $ fmap ( abs . (-) n . flip (-) x ) $ sides

solveDay3 :: Day3Option -> IO ()
solveDay3 (Day3Option f) = do
  handle <- openFile f ReadMode
  contents <- hGetContents handle
  let num = read contents :: Int
  putStrLn . show $ getSteps num
  hClose handle
