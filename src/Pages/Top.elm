module Pages.Top exposing (Model, Msg, Params, page)

import Element exposing (..)
import Element.Background as Background
import Element.Input as Input
import Http
import Json.Decode exposing (Decoder, field, string)
import Pages.NotFound exposing (Msg)
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)
import String exposing (fromFloat, fromInt, toFloat)
import Ui
import Url exposing (fromString)
import Url.Builder exposing (string)



-- INIT


page : Page Params Model Msg
page =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type alias Params =
    ()



-- MODEL


init : Url Params -> ( Model, Cmd Msg )
init url =
    ( Model None None NoOp " ", Cmd.none )


type alias Model =
    { left : Numb
    , right : Numb
    , operand : Op
    , quote : String
    }


type Numb
    = Num Float Int
    | NumWD Float Int
    | Mod Mod
    | None


type Mod
    = Deci
    | PosNeg
    | Both


type Op
    = Plus
    | Minus
    | Multply
    | Divide
    | NoOp


type Msg
    = NumButt Float
    | NumMod Mod
    | OpButt Op
    | Solve
    | Bcksp
    | Clear
    | SetQuote (Result Http.Error String)



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NumButt i ->
            case model.operand of
                NoOp ->
                    --if left is active number
                    ( { model | left = appNum model.left i }, Cmd.none )

                _ ->
                    -- if right is active number
                    ( { model | right = appNum model.right i }, Cmd.none )

        NumMod m ->
            case model.operand of
                NoOp ->
                    ( { model | left = modNumb model.left m }, Cmd.none )

                _ ->
                    ( { model | right = modNumb model.right m }, Cmd.none )

        OpButt o ->
            case model.right of
                None ->
                    case model.left of
                        None ->
                            ( { model | left = Num 0 0, operand = o }, Cmd.none )

                        Num _ _ ->
                            ( { model | operand = o }, Cmd.none )

                        Mod _ ->
                            ( model, Cmd.none )

                        {--what happens if the left is just an mod with no number, and an operator is pressed?
                        for now assume user error and do nothing.  maybe change to treat same as None?--}
                        NumWD n d ->
                            ( { model | left = Num n 0, operand = o }, Cmd.none )

                Num _ _ ->
                    eval model o

                NumWD n d ->
                    eval (Model model.left (Num n 0) model.operand "") o

                Mod _ ->
                    ( model, Cmd.none )

        {--what happens if the right is just a mod with no number and operator is pressed?
                for now assume user erro and do nothing.--}
        Bcksp ->
            case model.right of
                None ->
                    case model.operand of
                        NoOp ->
                            case model.left of
                                None ->
                                    ( model, Cmd.none )

                                _ ->
                                    ( { model | left = bckspNumb model.left }, Cmd.none )

                        _ ->
                            ( { model | operand = NoOp }, Cmd.none )

                _ ->
                    ( { model | right = bckspNumb model.right }, Cmd.none )

        Solve ->
            eval model NoOp

        Clear ->
            ( Model None None NoOp " ", Cmd.none )

        SetQuote result ->
            case result of
                Ok s ->
                    ( { model | quote = s }, Cmd.none )

                Err _ ->
                    ( { model | quote = "oopsiedoopsie" }, Cmd.none )



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



-------- is the string a mod


isMod : String -> Bool
isMod s =
    if (s == "-") || (s == ".") || (s == "-.") then
        True

    else
        False



------ which mod is it


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
                Num (Maybe.withDefault 0 (String.toFloat (fromFloat n ++ String.repeat d "0" ++ fromFloat i))) 0

        NumWD n d ->
            if i == 0 then
                NumWD n (d + 1)

            else
                Num (Maybe.withDefault 0 (String.toFloat (fromFloat n ++ "." ++ String.repeat d "0" ++ fromFloat i))) 0

        Mod m ->
            case m of
                Deci ->
                    Num (Maybe.withDefault 0 (String.toFloat ("." ++ fromFloat i))) 0

                PosNeg ->
                    Num (Maybe.withDefault 0 (String.toFloat ("-" ++ fromFloat i))) 0

                Both ->
                    Num (Maybe.withDefault 0 (String.toFloat ("-." ++ fromFloat i))) 0



---- handle mods
------ check if number has decimal


isInt : Float -> Bool
isInt f =
    if f == Basics.toFloat (floor f) then
        True

    else
        False



---- solve


eval : Model -> Op -> ( Model, Cmd Msg )
eval model mayOp =
    case model.left of
        Mod _ ->
            ( model, (Ui.getRandomQuote SetQuote) )

        --fix later
        None ->
            ( model, (Ui.getRandomQuote SetQuote) )

        NumWD _ _ ->
            ( model, (Ui.getRandomQuote SetQuote) )

        --fix later
        Num l li ->
            case model.right of
                Mod _ ->
                    ( model, (Ui.getRandomQuote SetQuote) )

                --fix later
                NumWD _ _ ->
                    ( model, (Ui.getRandomQuote SetQuote) )

                --fix later
                None ->
                    ( model, (Ui.getRandomQuote SetQuote) )

                Num r ri ->
                    case model.operand of
                        NoOp ->
                            ( model, (Ui.getRandomQuote SetQuote) )

                        Plus ->
                            ( Model (Num (l + r) 0) None mayOp "", (Ui.getRandomQuote SetQuote) )

                        Minus ->
                            ( Model (Num (l - r) 0) None mayOp "", (Ui.getRandomQuote SetQuote) )

                        Multply ->
                            ( Model (Num (l * r) 0) None mayOp "", (Ui.getRandomQuote SetQuote) )

                        Divide ->
                            if r == 0 then
                                ( { model | right = None }, (Ui.getRandomQuote SetQuote) )

                            else
                                ( Model (Num (l / r) 0) None NoOp "", (Ui.getRandomQuote SetQuote) )



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Calculator :)"
    , body =
        [ column []
            [ Ui.display ((numStr model.left) ++ (opStr model.operand) ++ (numStr model.right))
            , Ui.display (model.quote)
            , keypad
            ]
        ]
    }



----NEW KEYPAD


keypad : Element Msg
keypad =
    row []
        [ Ui.numPad <|
            { zero = Just (NumButt 0)
            , one = Just (NumButt 1)
            , two = Just (NumButt 2)
            , three = Just (NumButt 3)
            , four = Just (NumButt 4)
            , five = Just (NumButt 5)
            , six = Just (NumButt 6)
            , seven = Just (NumButt 7)
            , eight = Just (NumButt 8)
            , nine = Just (NumButt 9)
            , decimal = Just (NumMod Deci)
            , posneg = Just (NumMod PosNeg)
            , bcksp = Just Bcksp
            , clear = Just Clear
            }
        , Ui.simpleOps <|
            { add = Just (OpButt Plus)
            , sub = Just (OpButt Minus)
            , mult = Just (OpButt Multply)
            , div = Just (OpButt Divide)
            , equ = Just Solve
            }
        ]



----DISPLAY


display : Model -> Element msg
display model =
    column []
        [ row
            [ Background.color grey
            , padding 10
            ]
            [ text (numStr model.left)
            , text (opStr model.operand)
            , text (numStr model.right)
            ]
        , row
            []
            [ text model.quote
            ]
        ]


grey : Color
grey =
    rgb255 169 184 199


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
            (fromFloat f ++ ".") ++ String.repeat i "0"

        Num f i ->
            fromFloat f ++ String.repeat i "0"

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



