module Utils exposing (getRandomQuote, bckspNumb, zerosAtEnd, isLastNon0CharDeci, isMod, whichMod, modNumb, appNum, isInt, modStr, numStr, opStr, validNumb)

import Http
import Json.Decode exposing (Decoder, field, string)
import Types exposing (..)
import String


-- HTTP


getRandomQuote : (Result Http.Error String -> msg) -> Cmd msg
getRandomQuote m =
    Http.get
        { url = "http://www.boredapi.com/api/activity/"
        , expect = Http.expectJson m pullQuote
        }


pullQuote : Decoder String
pullQuote =
    field "activity" Json.Decode.string



---- Bcksp a number


bckspNumb : Numb -> Numb
bckspNumb n =
    case n of
        None ->
            None

        Mod m ->
            case m of
                Both ->
                    Mod PosNeg

                _ ->
                    None

        NumWD f i ->
            if i > 0 then
                NumWD f (i - 1)

            else
                Num f i

        Num f i ->
            if i > 0 then
                Num f (i - 1)

            else if String.dropRight 1 (String.fromFloat f) == "" then
                None

            else if String.endsWith "." (String.dropRight 1 (String.fromFloat f)) then
                NumWD (Maybe.withDefault 0 (String.toFloat (String.dropRight 1 (String.fromFloat f)))) i

            else if String.contains "." (String.dropRight 1 (String.fromFloat f)) && String.endsWith "0" (String.dropRight 1 (String.fromFloat f)) then
                if isLastNon0CharDeci (String.dropRight 1 (String.fromFloat f)) then
                    NumWD (Maybe.withDefault 0 (String.toFloat (String.dropRight 1 (String.fromFloat f)))) (zerosAtEnd (String.dropRight 1 (String.fromFloat f)))

                else
                    Num (Maybe.withDefault 0 (String.toFloat (String.dropRight 1 (String.fromFloat f)))) (zerosAtEnd (String.dropRight 1 (String.fromFloat f)))

            else if isMod (String.dropRight 1 (String.fromFloat f)) then
                whichMod (String.dropRight 1 (String.fromFloat f))

            else
                Num (Maybe.withDefault 0 (String.toFloat (String.dropRight 1 (String.fromFloat f)))) i



--------- how many 0 are at the end of the number


zerosAtEnd : String -> Int
zerosAtEnd s =
    if String.endsWith "0" s then
        1 + zerosAtEnd (String.dropRight 1 s)

    else
        0



--------------if last non 0 char a .


isLastNon0CharDeci : String -> Bool
isLastNon0CharDeci s =
    String.endsWith "." (String.dropRight (zerosAtEnd s) s)



----- is the string a mod


isMod : String -> Bool
isMod s =
    if (s == "-") || (s == ".") || (s == "-.") then
        True

    else
        False



--- which mod is it


whichMod : String -> Numb
whichMod s =
    if s == "-" then
        Mod PosNeg

    else if s == "." then
        Mod Deci

    else if s == "-." then
        Mod Both

    else
        None



---- modify a number


modNumb : Numb -> Mod -> Numb
modNumb n m =
    case m of
        Both ->
            n

        --shouldnt happen
        Deci ->
            case n of
                Num f i ->
                    if isInt f then
                        NumWD f i

                    else
                        n

                --numb already has a decimal place, dont add another
                NumWD _ _ ->
                    n

                --already has one, do nothing
                None ->
                    Mod Deci

                Mod mo ->
                    case mo of
                        PosNeg ->
                            Mod Both

                        _ ->
                            n

        --only other options are Deci and Both,.both already has a one
        PosNeg ->
            case n of
                Num f i ->
                    Num (f * -1) i

                NumWD f i ->
                    NumWD (f * -1) i

                None ->
                    Mod PosNeg

                Mod mo ->
                    case mo of
                        Deci ->
                            Mod Both

                        PosNeg ->
                            None

                        Both ->
                            Mod Deci



---- append new digit to a Num


appNum : Numb -> Float -> Numb
appNum num i =
    case num of
        None ->
            Num i 0

        Num n d ->
            if (i == 0) && (isInt n == False) then
                Num n (d + 1)

            else
                Num (Maybe.withDefault 0 (String.toFloat (String.fromFloat n ++ String.repeat d "0" ++ String.fromFloat i))) 0

        NumWD n d ->
            if i == 0 then
                NumWD n (d + 1)

            else
                Num (Maybe.withDefault 0 (String.toFloat (String.fromFloat n ++ "." ++ String.repeat d "0" ++ String.fromFloat i))) 0

        Mod m ->
            case m of
                Deci ->
                    Num (Maybe.withDefault 0 (String.toFloat ("." ++ String.fromFloat i))) 0

                PosNeg ->
                    Num (Maybe.withDefault 0 (String.toFloat ("-" ++ String.fromFloat i))) 0

                Both ->
                    Num (Maybe.withDefault 0 (String.toFloat ("-." ++ String.fromFloat i))) 0



---- handle mods
------ check if number has decimal


isInt : Float -> Bool
isInt f =
    if f == Basics.toFloat (floor f) then
        True

    else
        False

----convert custom types to strings
modStr : Mod -> String
modStr mod =
    case mod of
        Deci ->
            "."
        PosNeg ->
            "+/-"
        Both ->
            ""

numStr : Numb -> String
numStr mum =
    case mum of
        None ->
            " "
        NumWD f i ->
             (String.fromFloat f ++ ".") ++ String.repeat i "0"
        Num f i ->
            String.fromFloat f ++ String.repeat i "0"
        Mod m ->
            case m of
                Deci ->
                    "."
                PosNeg ->
                    "-"
                Both ->
                    "-."

opStr : Op -> String
opStr mop =
    case mop of
        NoOp ->
            " "
        Plus ->
            "+"
        Minus ->
            "-"
        Multply ->
            "*"
        Divide ->
            "/"


validNumb : Numb -> Maybe Float
validNumb n =
    case n of
         Num f i ->
            if i == 0 then
                Just f
            else Nothing  
         NumWD _ _ ->
            Nothing
         Mod _ ->
             Nothing
         None ->
             Nothing
