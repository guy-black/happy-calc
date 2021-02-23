module Pages.Top exposing (Model, Msg, Params, page)

import Element exposing (..)
import Element.Background as Background
import Element.Input as Input
import Pages.NotFound exposing (Msg)
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)
import String exposing (fromFloat, fromInt, toFloat)
import Url exposing (fromString)
import Url.Builder exposing (string)



-- INIT


page : Page Params Model Msg
page =
    Page.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Params =
    ()



-- MODEL


init : Url Params -> Model
init url =
    Model None None NoOp


type alias Model =
    { left : Numb
    , right : Numb
    , operand : Op
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



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        NumButt i ->
            case model.operand of
                NoOp ->
                    --if left is active number
                    { model | left = appNum model.left i }

                _ ->
                    -- if right is active number
                    { model | right = appNum model.right i }

        NumMod m ->
            case model.operand of
               NoOp -> {model | left = modNumb model.left m}
               _ -> {model | right = modNumb model.right m}
        OpButt o ->
            case model.right of
                None ->
                    case model.left of
                        None ->
                            { model | left = Num 0 0, operand = o }

                        Num _ _ ->
                            { model | operand = o }

                        Mod _ ->
                            model

                        {--what happens if the left is just an mod with no number, and an operator is pressed?
                        for now assume user error and do nothing.  maybe change to treat same as None?--}
                        NumWD n d ->
                            { model | left = Num n 0, operand = o }

                Num _ _ ->
                    eval model o

                NumWD n d ->
                    eval (Model model.left (Num n 0) model.operand) o

                Mod _ ->
                    model

        {--what happens if the right is just a mod with no number and operator is pressed?
                for now assume user erro and do nothing.--}
        Bcksp ->
            model

        Solve ->
            eval model NoOp

        Clear ->
            Model None None NoOp



---- modify a number


modNumb : Numb -> Mod -> Numb
modNumb n m =
    case m of
            Both -> n --shouldnt happen
            Deci -> 
                case n of
                    Num f i -> if isInt f 
                        then NumWD f i 
                        else n --numb already has a decimal place, dont add another
                    NumWD _ _ ->  n --already has one, do nothing
                    None -> Mod Deci
                    Mod mo -> 
                        case mo of
                            PosNeg -> Mod Both 
                            _ -> n --only other options are Deci and Both,.both already has a one
            PosNeg ->
                case n of
                    Num f i -> Num (f * -1) i
                    NumWD f i -> NumWD (f * -1) i
                    None -> Mod PosNeg
                    Mod mo -> 
                        case mo of
                            Deci -> Mod Both
                            PosNeg -> None
                            Both -> Mod Deci



---- append new digit to a Num


appNum : Numb -> Float -> Numb
appNum num i =
    case num of
        None ->
            Num i 0

        Num n d ->
            if i == 0 then Num n (d+1)
            else Num (Maybe.withDefault 0 (String.toFloat (fromFloat n ++ fromFloat i))) 0

        NumWD n d ->
            if i == 0 then
                NumWD n (d + 1)

            else
                Num (Maybe.withDefault 0 (String.toFloat (fromFloat n ++ "." ++ String.repeat d "0" ++fromFloat i))) 0

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


eval : Model -> Op -> Model
eval model mayOp =
    case model.left of
        Mod _ ->
            model

        --fix later
        None ->
            model

        NumWD _ _ ->
            model

        --fix later
        Num l li ->
            case model.right of
                Mod _ ->
                    model

                --fix later
                NumWD _ _ ->
                    model

                --fix later
                None ->
                    model

                Num r ri ->
                    case model.operand of
                        NoOp ->
                            model

                        Plus ->
                            Model (Num (l + r) 0) None mayOp

                        Minus ->
                            Model (Num (l - r) 0) None mayOp

                        Multply ->
                            Model (Num (l * r) 0) None mayOp

                        Divide ->
                            if r == 0 then
                                { model | right = None }

                            else
                                Model (Num (l / r) 0) None NoOp



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Calculator :)"
    , body =
        [ column []
            [ display model
            , keypad
            ]
        ]
    }



----DISPLAY


display : Model -> Element Msg
display model =
    row
        [ Background.color grey
        , padding 10
        ]
        [ text (numStr model.left)
        , text (opStr model.operand)
        , text (numStr model.right)
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

        Num f i->
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



----KEYPAD


keypad : Element Msg
keypad =
    column []
        [ row []
            [ keyButt (NumButt 7)
            , keyButt (NumButt 8)
            , keyButt (NumButt 9)
            , keyButt (OpButt Divide)
            ]
        , row []
            [ keyButt (NumButt 4)
            , keyButt (NumButt 5)
            , keyButt (NumButt 6)
            , keyButt (OpButt Multply)
            ]
        , row []
            [ keyButt (NumButt 1)
            , keyButt (NumButt 2)
            , keyButt (NumButt 3)
            , keyButt (OpButt Minus)
            ]
        , row []
            [ keyButt (NumMod Deci)
            , keyButt (NumButt 0)
            , keyButt (NumMod PosNeg)
            , keyButt (OpButt Plus)
            ]
        , row []
            [ keyButt Bcksp
            , keyButt Solve
            , keyButt Clear
            ]
        ]


keyButt : Msg -> Element Msg
keyButt msg =
    Input.button []
        { onPress = Just msg
        , label = text (buttLab msg)
        }


buttLab : Msg -> String
buttLab msg =
    case msg of
        NumButt i ->
            fromFloat i

        NumMod m ->
            modStr m

        OpButt o ->
            opStr o

        Bcksp ->
            "Bcksp"

        Solve ->
            "="

        Clear ->
            "CLR"
