module Pages.Conversions.Temp exposing (Model, Msg, Params, page)

import Element exposing (..)
import Framework.Color as Color exposing (..)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)
import Types exposing (..)
import Ui
import Utils


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
    , f : Numb
    , c : Numb
    , k : Numb
    , quote : String
    }


type Scale
    = F
    | C
    | K


init : Url Params -> ( Model, Cmd Msg )
init { params } =
    ( Model F None None None "", Cmd.none )



-- UPDATE


type Msg
    = ChgUnit Scale
    | ChgNum Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChgUnit s ->
            ( { model | unit = s }, Cmd.none )

        ChgNum i ->
            case model.unit of
                F ->
                    let
                        newNumb =
                            Utils.appNum model.f i
                    in
                    case Utils.validNumb newNumb of
                        Just f ->
                            ( { model | f = newNumb, c = Num (ftoc f) 0, k = Num (ftok f) 0 }, Cmd.none )

                        Nothing ->
                            ( { model | f = newNumb }, Cmd.none )

                C ->
                    let
                        newNumb =
                            Utils.appNum model.c i
                    in
                    case Utils.validNumb newNumb of
                        Just c ->
                            ( { model | c = newNumb, f = Num (ctof c) 0, k = Num (ctok c) 0 }, Cmd.none )

                        Nothing ->
                            ( { model | c = newNumb }, Cmd.none )

                K ->
                    let
                        newNumb =
                            Utils.appNum model.k i
                    in
                    case Utils.validNumb newNumb of
                        Just k ->
                            ( { model | k = newNumb, c = Num (ktoc k) 0, f = Num (ktof k) 0 }, Cmd.none )

                        Nothing ->
                            ( { model | k = newNumb }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



---- helper functions


ftoc : Float -> Float
ftoc f =
    (f - 32) * (5 / 9)


ftok : Float -> Float
ftok f =
    ftoc f + 273.15


ctof : Float -> Float
ctof c =
    (c * (9 / 5)) + 32


ctok : Float -> Float
ctok c =
    c + 273.15


ktoc : Float -> Float
ktoc k =
    k - 273.15


ktof : Float -> Float
ktof k =
    ctof (ktoc k)



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
        { zero = Just (ChgNum 0)
        , one = Just (ChgNum 1)
        , two = Just (ChgNum 2)
        , three = Just (ChgNum 3)
        , four = Just (ChgNum 4)
        , five = Just (ChgNum 5)
        , six = Just (ChgNum 6)
        , seven = Just (ChgNum 7)
        , eight = Just (ChgNum 8)
        , nine = Just (ChgNum 9)
        , decimal = Nothing
        , posneg = Nothing
        , bcksp = Nothing
        , clear = Nothing
        }
