module Ui exposing (conversionsMenu)

import Element exposing (..)
import Framework.Grid as Grid exposing  (..)
import Framework.Button as Button exposing (..)
import Framework.Tag as Tag exposing (..)
import Spa.Generated.Route as Route





conversionsMenu : Element msg
conversionsMenu =
    Element.row Grid.compact <|
        [ link (Button.simple ++ Tag.slim)
            { url = Route.toString Route.Conversions__Length
            , label = text "Length"
            }
        , link (Button.simple ++ Tag.slim)
            { url = Route.toString Route.Conversions__Weight
            , label = text "weight"
            }
        , link (Button.simple ++ Tag.slim)
            { url = Route.toString Route.Conversions__Temp
            , label = text "Temp"
            }
        ]

