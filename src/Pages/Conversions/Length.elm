module Pages.Conversions.Length exposing (Model, Msg, Params, page)

import Element exposing (..)
import Pages.NotFound exposing (Msg)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)
import Ui


page : Page Params Model Msg
page =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Params =
    ()


type alias Model =
    { leftVal : Float
    , leftUnit : Unit
    , rightVal : Float
    , rightUnit : Unit
    }


type Unit
    = Mm --millimeters
    | Cm --centimeters
    | M --meters
    | Km --kilometers
    | Ft --feet
    | In --inch
    | Mi --mile


init : Url Params -> ( Model, Cmd Msg )
init { params } =
    ( Model 0 Mm 0 Mm, Cmd.none )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Conversions.Length"
    , body =
        [ column []
            [ text "length converter"
            , Ui.conversionsMenu
            ]
        ]
    }
