module Pages.Conversions.Temp exposing (Model, Msg, Params, page)

import Element exposing (..)
import Framework.Color as Color exposing (..)
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
    { unit : Scale
    , f : Maybe Float
    , c : Maybe Float
    , k : Maybe Float
    , quote : String
    }


type Scale
    = F
    | C
    | K


init : Url Params -> ( Model, Cmd Msg )
init { params } =
    ( Model F (Just 6.0) Nothing Nothing "", Cmd.none )



-- UPDATE


type Msg
    = ChgUnit Scale
    | Num Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChgUnit s ->
            ( {model | unit = s}, Cmd.none )

        Num i ->
            case model.unit of
                F -> (model, Cmd.none)
                C -> (model, Cmd.none)
                K -> (model, Cmd.none) 


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Conversions.Temp"
    , body =
        [ column []
            [ text "temp converter"
            , row [] (disps model)
            , numpad
            , Ui.conversionsMenu
            ]
        ]
    }


disps : Model -> List (Element Msg)
disps m =
    case m.unit of
        F ->
            [ Ui.smolDisp m.f "°F" (Just Color.darkerGrey) (ChgUnit F)
            , Ui.smolDisp m.c "°C" Nothing (ChgUnit C)
            , Ui.smolDisp m.k "°K" Nothing (ChgUnit K)
            ]

        C ->
            [ Ui.smolDisp m.f "°F" Nothing (ChgUnit F)
            , Ui.smolDisp m.c "°C" (Just Color.darkerGrey) (ChgUnit C)
            , Ui.smolDisp m.k "°K" Nothing (ChgUnit K)
            ]

        K ->
            [ Ui.smolDisp m.f "°F" Nothing (ChgUnit F)
            , Ui.smolDisp m.c "°C" Nothing (ChgUnit C)
            , Ui.smolDisp m.k "°K" (Just Color.darkerGrey) (ChgUnit K)
            ]


numpad : Element Msg
numpad =
    Ui.numPad <|
        { zero = Just (Num 0)
        , one = Just (Num 1)
        , two = Just (Num 2)
        , three = Just (Num 3)
        , four = Just (Num 4)
        , five = Just (Num 5)
        , six = Just (Num 6)
        , seven = Just (Num 7)
        , eight = Just (Num 8)
        , nine = Just (Num 9)
        , decimal = Nothing
        , posneg = Nothing
        , bcksp = Nothing
        , clear = Nothing
        }
