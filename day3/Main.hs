module Main where

import Data.Semigroup ((<>))
import Options.Applicative
import System.IO
import Math.Geometry.Grid
import Math.Geometry.Grid.SquareInternal
import Control.Monad (join)
import Data.Maybe (catMaybes)
import qualified Data.HashMap.Strict as Map
import Control.Monad.State.Lazy
          ( State(..)
          , get
          , put
          , evalState
          )

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
  let val = head $ dropWhile (<= num) $ evalState allValues (Map.singleton (0,0) 1, 1)
  putStrLn . show $ val
  hClose handle


-- X  X  *  X  X
-- X  5  4  2  X
-- * 10  1  1 54
-- X 11 23 25 26 X
-- X  X  *  X  X


--17 16 15 14 13
--18  5  4  3 12
--19  6  1  2 11
--20  7  8  9 10
--21 22 23 24 25

directionAround :: Int -> [SquareDirection]
directionAround 0 = []
directionAround n = [East] ++ takeNorth ++ takeWest ++ takeSouth ++ takeEast
  where
    steps     = n * 2
    takeNorth = take (steps - 1) $ repeat North
    takeSouth = take steps $ repeat South
    takeEast  = take steps $ repeat East
    takeWest  = take steps $ repeat West

walkAroundDirection :: [Maybe SquareDirection]
walkAroundDirection = [ Just y | x <- [1..], y <- directionAround x]

walkAround :: [Maybe (Index UnboundedSquareGrid)]
walkAround = Just (0,0) : zipWith getNextPos walkAround walkAroundDirection
      where
        getNextPos a b = join $ neighbour <$> Just UnboundedSquareGrid
                                          <*> a
                                          <*> b

type GridValue = Map.HashMap (Index UnboundedSquareGrid) Int
computeNumber :: Index UnboundedSquareGrid -> GridValue -> Int
computeNumber idx gridValue = sum $ catMaybes $ surrounding gridValue
  where
    surrounding v = fmap (flip Map.lookup v)
                    [ (x+1,y), (x+1,y+1), (x+1,y-1)
                    , (x,y+1), (x,y-1)
                    , (x-1,y), (x-1,y+1), (x-1,y-1)
                    ]
    (x, y)        = idx

allValues :: State (GridValue, Int) [Int]
allValues = do
    (gridValue, step) <- get
    let (Just idx) = walkAround !! step
    let val = computeNumber idx gridValue
    put $ (Map.insert idx val gridValue, step + 1)
    xs <- allValues
    return (val:xs)


