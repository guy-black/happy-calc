module Pages.Top exposing (Model, Msg, Params, page)

import Element exposing (..)
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
init url = Model "" "" Nothing


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


view : Model -> Document Msg
view model =
    { title = "Homepage"
    , body = [ text "Homepage" ]
    }
