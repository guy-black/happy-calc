module Pages.Top exposing (Model, Msg, Params, page)

import Element exposing (..)
import Element.Background as Background
import Element.Input as Input
import Pages.NotFound exposing (Msg)
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)
import String exposing (fromFloat, fromInt)
import Url.Builder exposing (string)
import Url exposing (fromString)
import String exposing (toFloat)



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
    Model Nothing Nothing Nothing


type alias Model =
    { left : Maybe Float
    , right : Maybe Float
    , operand : Maybe Op
    }


type Mod
    = Deci
    | PosNeg
    | Both


type Op
    = Plus
    | Minus
    | Multply
    | Divide

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
                Nothing ->
                    { model | left = (appNum model.left i)}
                Just _ -> 
                    { model | right = (appNum model.right i)}
        NumMod m ->
            model

        OpButt o ->
            case model.right of
                Nothing ->
                    case model.left of
                        Nothing ->
                            { model | left = Just 0, operand = Just o}
                        Just _ ->
                            { model | operand = Just o}
                Just _ -> eval model (Just o)

        Bcksp ->
            model

        Solve ->
            eval model Nothing

        Clear ->
           Model Nothing Nothing Nothing


---- append new digit to a Num
appNum : Maybe  Float -> Float -> Maybe Float
appNum num i =
    case num of
        Nothing -> 
            Just i
        Just n ->
            String.toFloat((fromFloat n) ++ (fromFloat i))


 

---- solve
eval : Model -> Maybe Op -> Model
eval model mayOp = 
    case model.left of
       Nothing -> model
       Just l -> 
            case model.right of
               Nothing -> model
               Just r -> 
                    case model.operand of
                       Nothing -> model
                       Just Plus -> Model (Just (l + r)) Nothing mayOp
                       Just Minus -> Model (Just (l - r)) Nothing mayOp
                       Just Multply -> Model (Just (l * r)) Nothing mayOp
                       Just Divide -> 
                            if (r == 0) then {model  | right = Nothing} else  Model (Just (l / r)) Nothing mayOp


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
        
        Both -> ""


numStr : Maybe Float -> String
numStr mum =
    case mum of
        Nothing ->
            " "
        Just f ->
            fromFloat f


opStr : Maybe Op -> String
opStr mop =
    case mop of
        Nothing ->
            " "

        Just Plus ->
            "+"

        Just Minus ->
            "-"

        Just Multply ->
            "*"

        Just Divide ->
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
            opStr (Just o)

        Bcksp ->
            "Bcksp"

        Solve ->
            "="

        Clear ->
            "CLR"
