module Pages.Top exposing (Model, Msg, Params, page)

import Element exposing (..)
import Element.Background as Background
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)
import Url.Builder exposing (string)


type alias Params =
    ()


type alias Model =
    { left : String
    , right : String
    , operand : Maybe Op
    }


type Op
    = Plus
    | Minus
    | Multply
    | Divide


type alias Msg =
    Never


init : Url Params -> Model
init url =
    Model "" "" (Just Plus)


page : Page Params Model Msg
page =
    Page.sandbox
        { init = init
        , update = update
        , view = view
        }


update : Msg -> Model -> Model
update msg model =
    model



-- VIEW


grey : Color
grey =
    rgb255 169 184 199

opStr : Maybe Op -> String
opStr mop = 
    case  mop of
       Nothing -> ""
       Just Plus -> "+"
       Just Minus -> "-"
       Just Multply -> "*"
       Just Divide -> "/"


display : Model -> Element Msg
display model =
    row
        [ Background.color grey
        , padding 10
        ]
        [ text model.left
        , text (opStr model.operand)
        , text model.right
        ]


keypad : Element Msg
keypad =
    none


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
