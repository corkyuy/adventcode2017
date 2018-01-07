module Main where

import Data.Semigroup ((<>))
import Data.List (sort)
import System.IO
import Options.Applicative
import Control.Monad.Trans.State.Lazy
  ( State(..)
  , get
  , put
  , evalState
  )

main :: IO ()
main = solveDay5 =<< execParser opts
  where
    opts = info (day5Parser <**> helper)
      ( fullDesc
     <> progDesc "Advent Code 2017 Day 5 solution"
     <> header "Day5" )

data Day5Option = Day5Option
  { filename :: String
  }

day5Parser :: Parser Day5Option
day5Parser = Day5Option
  <$> strOption
        ( long "file"
       <> metavar "INPUT"
       <> help "Puzzle Input")

solveDay5 :: Day5Option -> IO ()
solveDay5 (Day5Option f) = do
  handle <- openFile f ReadMode
  contents <- hGetContents handle
  let codes = compile $ lines contents
  putStrLn . show $ evalState runCodes (codes, 0)


compile :: [String] -> Codes
compile = fmap (read)

type Codes = [Int]
type IP    = Int

-- do one step execution on the code
step :: Codes -> IP -> (Codes, IP)
step codes ip = (updatedCode, newIp)
  where
    updatedCode = take ip codes ++ [(+1) $ codes !! ip] ++ drop (ip + 1) codes
    newIp       = ip + (codes !! ip)

type Result = State (Codes, IP) Int

runCodes :: Result
runCodes = do
  (codes, ip) <- get
  let newState = step codes ip
  put newState
  if ip < length codes then do
    count <- runCodes
    return $ count + 1
  else return 0

