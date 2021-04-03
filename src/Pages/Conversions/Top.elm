module Pages.Conversions.Top exposing (Params, Model, Msg, page)

import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)
import Spa.Generated.Route as Route
import Element exposing (..)
import Element exposing (link, text)
import Ui
import Utils
import Http


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
    {
    quote : String
    }


init : Url Params -> ( Model, Cmd Msg )
init { params } =
    ( Model "", (Utils.getRandomQuote SetQuote) )



-- UPDATE


type Msg
    = SetQuote (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetQuote result ->
           case result of
                Ok s ->
                    ( { model | quote = s }, Cmd.none )

                Err _ ->
                    ( { model | quote = "oopsiedoopsie" }, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Conversions.Top"
    , body = [
        column [][
             Ui.display 20 model.quote
            ,Ui.conversionsMenu    
        ]   
    ]
    }



