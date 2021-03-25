module Ui exposing (menu)

import Spa.Generated.Route as Route
import Element exposing (..)

menu : Element msg
menu = column[][
            link []
                { url = Route.toString Route.Conversions__Length
                , label = text "Length"
                }
            ,link []
                { url = Route.toString Route.Conversions__Weight
                , label = text "weight"
                }
            ,link []
                { url = Route.toString Route.Conversions__Temp
                , label = text "Temp"
                }
        ]
