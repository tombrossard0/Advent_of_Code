-- This is a comment !

{-
 Multiline comment !
 -}

import Data.List
import Data.Char
import System.IO

checkNum :: [Char] -> Maybe Int
checkNum [] = Nothing
checkNum ('o':'n':'e':y) = Just 1
checkNum ('t':'w':'o':y) = Just 2
checkNum ('t':'h':'r':'e':'e':y) = Just 3
checkNum ('f':'o':'u':'r':y) = Just 4
checkNum ('f':'i':'v':'e':y) = Just 5
checkNum ('s':'i':'x':y) = Just 6
checkNum ('s':'e':'v':'e':'n':y) = Just 7
checkNum ('e':'i':'g':'h':'t':y) = Just 8
checkNum ('n':'i':'n':'e':y) = Just 9
checkNum x = Nothing

checkNumR :: [Char] -> Maybe Int
checkNumR [] = Nothing
checkNumR ('e':'n':'o':y) = Just 1
checkNumR ('o':'w':'t':y) = Just 2
checkNumR ('e':'e':'r':'h':'t':y) = Just 3
checkNumR ('r':'u':'o':'f':y) = Just 4
checkNumR ('e':'v':'i':'f':y) = Just 5
checkNumR ('x':'i':'s':y) = Just 6
checkNumR ('n':'e':'v':'e':'s':y) = Just 7
checkNumR ('t':'h':'g':'i':'e':y) = Just 8
checkNumR ('e':'n':'i':'n':y) = Just 9
checkNumR x = Nothing

getFirstNumInText :: ([Char] -> Maybe Int) -> [Char] -> Maybe Int
getFirstNumInText _ [] = Nothing
getFirstNumInText func (x:y) =
    if not $ isNumber x then
        case func (x:y) of
            Nothing -> getFirstNumInText func y
            Just n -> Just n
        else Just (digitToInt x)

getLines :: Handle -> IO Int
getLines input = do
    end <- hIsEOF input
    if not end then do
        line <- hGetLine input
        let res1 = case getFirstNumInText checkNum line of
                    Just n -> n
                    Nothing -> 0
        let res2 = case getFirstNumInText checkNumR (reverse line) of
                    Just n -> n
                    Nothing -> 0
        rest <- getLines input
        return (10 * res1 + res2 + rest)
    else return 0

day1 = do
    input <- openFile "input1.txt" ReadMode
    res <- getLines input
    putStrLn $ "Total sum: " ++ show res
    hClose input
