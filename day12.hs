{-# LANGUAGE OverloadedStrings #-}

import System.IO (readFile)
import Data.Map (Map, fromList, lookup)
import Data.List (findIndices)
import Data.Text (pack, unpack, dropWhileEnd)

chunk :: Int -> String -> [String]
chunk n l
  | length l > n = [take n l] ++ (chunk n $ tail l)
  | otherwise = [l]

nextState :: Map String String -> String -> String
nextState table key =
  case Data.Map.lookup key table of Nothing -> "."
                                    Just c -> c

generate :: Map String String -> String -> String
generate table input =
  let chunks = chunk 5 $ ".." ++ input ++ ".."
  in (concat $ map (nextState table) chunks)

plantSum :: Int -> String -> Int
plantSum padding s =
  let indices = findIndices (=='#') s
  in sum $ map (\x -> x - padding) indices
  
stripDots s =
  (dropWhile f . unpack . dropWhileEnd f) $ pack s
  where f = (=='.')

part2 generate n start
  | stripped == stripped' = (n, start)
  | otherwise             = part2 generate (n+1) next
  where next = generate start
        stripped = stripDots start
        stripped' = stripDots next
  

main = do
  lns <- lines <$> readFile "input/day12.txt"
  let table = fromList $ map (\l -> let w = words l in (w !! 0, w !! 2)) lns
  let s = "##...#......##......#.####.##.#..#..####.#.######.##..#.####...##....#.#.####.####.#..#.######.##..."
  let nPad = 5
  let ends = replicate nPad '.'
  let start = (replicate nPad '.') ++ s ++ (replicate 100 '.')
  let plantSum' = plantSum nPad
  
  let generate' = generate table
  let generations = iterate generate' start
  putStrLn $ show $ plantSum' (generations !! 20)

  -- putStrLn $ unlines $ [ show i ++ l | (i, l) <- zip [0..] (map stripDots (take 101 generations))]
  -- a bit of cheating here, i noticed that it shifted left one once the pattern converged
  let (stage, str) = part2 generate' 0 start
  let numHashes = length $ filter (=='#') str
  putStrLn $ show $ numHashes * (50000000000 - stage) + plantSum' str 
