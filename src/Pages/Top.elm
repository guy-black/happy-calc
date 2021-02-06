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


type alias Params =
    ()


type alias Model =
    { left : Maybe Num
    , right : Maybe Num
    , operand : Maybe Op
    }


type Num
    = Inte Int
    | Flo Float


type Mod
    = Deci
    | PosNeg


type Op
    = Plus
    | Minus
    | Multply
    | Divide


type Msg
    = NumButt Int
    | NumMod Mod
    | OpButt Op
    | Solve
    | Bcksp


init : Url Params -> Model
init url =
    Model Nothing Nothing Nothing


page : Page Params Model Msg
page =
    Page.sandbox
        { init = init
        , update = update
        , view = view
        }


update : Msg -> Model -> Model
update msg model =
    case msg of
        NumButt i ->
            model

        NumMod m ->
            model

        OpButt o ->
            model

        Bcksp ->
            model

        Solve ->
            model



-- VIEW


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
            fromInt i

        NumMod m ->
            modStr m

        OpButt o ->
            opStr (Just o)

        Bcksp ->
            "Bcksp"

        Solve ->
            "="


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


numStr : Maybe Num -> String
numStr mum =
    case mum of
        Nothing ->
            " "

        Just (Inte i) ->
            fromInt i

        Just (Flo f) ->
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


keypad : Element Msg
keypad =
    column []
        [ row []
            [ keyButt (NumButt 7)
            , keyButt (NumButt 8)
            , keyButt (NumButt 7)
            , keyButt (OpButt Divide)
            ]
            
        ]


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
