module Ui exposing (conversionsMenu, display, getRandomQuote, numPad, simpleOps)

import Element exposing (..)
import Element.Input as Input exposing (..)
import Framework.Button as Button exposing (..)
import Framework.Card as Card exposing (..)
import Framework.Color as Color exposing (..)
import Framework.Grid as Grid exposing (..)
import Framework.Tag as Tag exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)
import Spa.Generated.Route as Route


conversionsMenu : Element msg
conversionsMenu =
    Element.row Grid.compact <|
        [ link (Button.simple ++ Tag.slim)
            { url = Route.toString Route.Conversions__Length
            , label = Element.text "Length"
            }
        , link (Button.simple ++ Tag.slim)
            { url = Route.toString Route.Conversions__Weight
            , label = Element.text "weight"
            }
        , link (Button.simple ++ Tag.slim)
            { url = Route.toString Route.Conversions__Temp
            , label = Element.text "Temp"
            }
        ]


numPad :
    { zero : Maybe msg
    , one : Maybe msg
    , two : Maybe msg
    , three : Maybe msg
    , four : Maybe msg
    , five : Maybe msg
    , six : Maybe msg
    , seven : Maybe msg
    , eight : Maybe msg
    , nine : Maybe msg
    , decimal : Maybe msg
    , posneg : Maybe msg
    , bcksp : Maybe msg
    , clear : Maybe msg
    }
    -> Element msg
numPad msgs =
    Element.column []
        [ Element.row Grid.compact <|
            [ Input.button Button.simple <|
                { onPress = msgs.seven
                , label = Element.text " 7 "
                }
            , Input.button Button.simple <|
                { onPress = msgs.eight
                , label = Element.text " 8 "
                }
            , Input.button Button.simple <|
                { onPress = msgs.nine
                , label = Element.text " 9 "
                }
            ]
        , Element.row Grid.compact <|
            [ Input.button Button.simple <|
                { onPress = msgs.four
                , label = Element.text " 4 "
                }
            , Input.button Button.simple <|
                { onPress = msgs.five
                , label = Element.text " 5 "
                }
            , Input.button Button.simple <|
                { onPress = msgs.six
                , label = Element.text " 6 "
                }
            ]
        , Element.row Grid.spaceEvenly <|
            [ Input.button Button.fill <|
                { onPress = msgs.one
                , label = Element.text " 1 "
                }
            , Input.button Button.fill <|
                { onPress = msgs.two
                , label = Element.text " 2 "
                }
            , Input.button Button.fill <|
                { onPress = msgs.three
                , label = Element.text " 3 "
                }
            ]
        , Element.row Grid.spaceEvenly <|
            [ Input.button Button.fill <|
                { onPress = msgs.decimal
                , label = Element.text " . "
                }
            , Input.button Button.fill <|
                { onPress = msgs.zero
                , label = Element.text "0"
                }
            , Input.button Button.fill <|
                { onPress = msgs.posneg
                , label = Element.text "+/-"
                }
            ]
        , Element.row Grid.compact <|
            [ Input.button Button.fill <|
                { onPress = msgs.bcksp
                , label = Element.text "<="
                }
            , Input.button Button.fill <|
                { onPress = msgs.clear
                , label = Element.text "clear"
                }
            ]
        ]


simpleOps :
    { add : Maybe msg
    , sub : Maybe msg
    , mult : Maybe msg
    , div : Maybe msg
    , equ : Maybe msg
    }
    -> Element msg
simpleOps msgs =
    Element.column []
        [ Input.button Button.fill <|
            { onPress = msgs.div
            , label = Element.text "/"
            }
        , Input.button Button.fill <|
            { onPress = msgs.mult
            , label = Element.text "*"
            }
        , Input.button Button.fill <|
            { onPress = msgs.sub
            , label = Element.text "-"
            }
        , Input.button Button.fill <|
            { onPress = msgs.add
            , label = Element.text "+"
            }
        , Input.button Button.fill <|
            { onPress = msgs.equ
            , label = Element.text "="
            }
        ]


isLTE : Int -> Int -> Bool
isLTE s f =
    f <= s


displayLine : String -> Element msg
displayLine s =
    Element.el ((Card.fill ++ Tag.simple) ++ [ Element.width (px 215), Element.height (px 30) ]) <|
        Element.text s


stringCutter : Int -> String -> List String
stringCutter i s =
    let
        str =
            String.trim s
    in
    if String.length str > i then
        let
            breakPoint =
                String.indexes " " str
                    |> List.filter (isLTE i)
                    |> List.maximum
        in
        case breakPoint of
            Nothing ->
                let
                    firstWord =
                        String.words str
                            |> List.head
                            |> Maybe.withDefault ""
                in
                if String.length firstWord > (i * 2) then
                    (String.left i str ++ "...") :: stringCutter i (String.dropLeft i str)

                else
                    (String.left (String.length firstWord // 2) str ++ "..") :: stringCutter i (String.dropLeft (String.length firstWord // 2) str)

            Just bp ->
                String.left bp str :: stringCutter i (String.dropLeft bp str)

    else
        str :: []


display : Int -> String -> Element msg
display i s =
    Element.column [] <|
        List.map displayLine (stringCutter i s)



-- HTTP


getRandomQuote : (Result Http.Error String -> msg) -> Cmd msg
getRandomQuote m =
    Http.get
        { url = "http://www.boredapi.com/api/activity/"
        , expect = Http.expectJson m pullQuote
        }


pullQuote : Decoder String
pullQuote =
    field "activity" Json.Decode.string
