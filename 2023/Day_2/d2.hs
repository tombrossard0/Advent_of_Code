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


checkColor :: [Char] -> Int
checkColor [] = 0
checkColor ('g':'r':'e':'e':'n':y) = 0
checkColor ('b':'l':'u':'e':y) = 1
checkColor ('r':'e':'d':y) = 2
checkColor x = 0

atoi_ :: [Char] -> Int -> Int
atoi_ [] _ = -1
atoi_ (a:[]) acc = 10 * acc + (digitToInt a)
atoi_ (a:b) acc = atoi_ b (10 * acc + (digitToInt a))

atoi :: [Char] -> Int
atoi s = atoi_ s 0

divide_line :: String -> Char -> String -> IO [String]
divide_line line sep acc = do
    case line of
        [] -> return [acc]
        (' ':y) -> divide_line y sep acc
        (x:s:y) | s == sep -> do
            rest <- divide_line y sep []
            return $ (acc ++ [x]) : rest
        (x:y) -> divide_line y sep (acc ++ [x])

isValidLine line maxs = do
    let num = atoi (takeWhile (\x -> isDigit x) line)
    if num >= 0 then do
        let rest = dropWhile (\x -> isDigit x) line
        let color = takeWhile (\x -> not (isDigit x)) rest
        let rest2 = dropWhile (\x -> not (isDigit x)) rest
        case (maxs !! (checkColor color)) of
            n | num > n -> 0
            n -> isValidLine rest2 maxs
    else 1

minInLine line maxs = do
    let num = atoi (takeWhile (\x -> isDigit x) line)
    if num >= 0 then do
        let rest = dropWhile (\x -> isDigit x) line
        let color = takeWhile (\x -> not (isDigit x)) rest
        let rest2 = dropWhile (\x -> not (isDigit x)) rest
        let a = maxs !! 0
        let b = maxs !! 1
        let c = maxs !! 2
        case (checkColor color) of
            0 -> minInLine rest2 (((max a num):b:c:[]))
            1 -> minInLine rest2 (a:((max b num):c:[]))
            2 -> minInLine rest2 (a:b:((max c num):[]))
    else maxs

day2_getLines input = do
    end <- hIsEOF input
    if not end then do
        line <- hGetLine input
        s <- divide_line line ':' []
        r <- divide_line (s !! 1) ';' []
        let f = intercalate "" r
        g <- divide_line f ',' []
        let h = intercalate "" g
        let index = atoi (drop 4 (s !! 0))
        print ((s !! 0) ++ " : " ++ h)
        total <- day2_getLines input
        return (total + index * (isValidLine h [13, 14, 12]))
    else return 0

day2p2_getLines input = do
    end <- hIsEOF input
    if not end then do
        line <- hGetLine input
        s <- divide_line line ':' []
        r <- divide_line (s !! 1) ';' []
        let f = intercalate "" r
        g <- divide_line f ',' []
        let h = intercalate "" g
        let index = atoi (drop 4 (s !! 0))
        print ((s !! 0) ++ " : " ++ h)
        total <- day2p2_getLines input
        return (total + (product (minInLine h [0, 0, 0])))
    else return 0

day2 = do
    input <- openFile "input2.txt" ReadMode
    res <- day2_getLines input
    print res
    hClose input

day2p2 = do
    input <- openFile "input2.txt" ReadMode
    res <- day2p2_getLines input
    print res
    hClose input
