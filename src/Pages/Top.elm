module Pages.Top exposing (Model, Msg, Params, page)

import Element exposing (..)
import Element.Background as Background
import Element.Input as Input
import Http
import Json.Decode exposing (Decoder, field, string)
import Pages.NotFound exposing (Msg)
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)
import String exposing (fromFloat, fromInt, toFloat)
import Ui
import Utils
import Types exposing (..)
import Url exposing (fromString)
import Url.Builder exposing (string)



-- INIT


page : Page Params Model Msg
page =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type alias Params =
    ()



-- MODEL


init : Url Params -> ( Model, Cmd Msg )
init url =
    ( Model None None NoOp "", Cmd.none )


type alias Model =
    { left : Numb
    , right : Numb
    , operand : Op
    , quote : String
    }




type Msg
    = NumButt Float
    | NumMod Mod
    | OpButt Op
    | Solve
    | Bcksp
    | Clear
    | SetQuote (Result Http.Error String)



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NumButt i ->
            case model.operand of
                NoOp ->
                    --if left is active number
                    ( { model | left = Utils.appNum model.left i }, Cmd.none )

                _ ->
                    -- if right is active number
                    ( { model | right = Utils.appNum model.right i }, Cmd.none )

        NumMod m ->
            case model.operand of
                NoOp ->
                    ( { model | left = Utils.modNumb model.left m }, Cmd.none )

                _ ->
                    ( { model | right = Utils.modNumb model.right m }, Cmd.none )

        OpButt o ->
            case model.right of
                None ->
                    case model.left of
                        None ->
                            ( { model | left = Num 0 0, operand = o }, Cmd.none )

                        Num _ _ ->
                            ( { model | operand = o }, Cmd.none )

                        Mod _ ->
                            ( model, Cmd.none )

                        {--what happens if the left is just an mod with no number, and an operator is pressed?
                        for now assume user error and do nothing.  maybe change to treat same as None?--}
                        NumWD n d ->
                            ( { model | left = Num n 0, operand = o }, Cmd.none )

                Num _ _ ->
                    eval model o

                NumWD n d ->
                    eval (Model model.left (Num n 0) model.operand "") o

                Mod _ ->
                    ( model, Cmd.none )

        {--what happens if the right is just a mod with no number and operator is pressed?
                for now assume user erro and do nothing.--}
        Bcksp ->
            case model.right of
                None ->
                    case model.operand of
                        NoOp ->
                            case model.left of
                                None ->
                                    ( model, Cmd.none )

                                _ ->
                                    ( { model | left = Utils.bckspNumb model.left }, Cmd.none )

                        _ ->
                            ( { model | operand = NoOp }, Cmd.none )

                _ ->
                    ( { model | right = Utils.bckspNumb model.right }, Cmd.none )

        Solve ->
            eval model NoOp

        Clear ->
            ( Model None None NoOp " ", Cmd.none )

        SetQuote result ->
            case result of
                Ok s ->
                    ( { model | quote = s }, Cmd.none )

                Err _ ->
                    ( { model | quote = "oopsiedoopsie" }, Cmd.none )




---- solve


eval : Model -> Op -> ( Model, Cmd Msg )
eval model mayOp =
    case model.left of
        Mod _ ->
            ( model, (Utils.getRandomQuote SetQuote) )

        --fix later
        None ->
            ( model, (Utils.getRandomQuote SetQuote) )

        NumWD _ _ ->
            ( model, (Utils.getRandomQuote SetQuote) )

        --fix later
        Num l li ->
            case model.right of
                Mod _ ->
                    ( model, (Utils.getRandomQuote SetQuote) )

                --fix later
                NumWD _ _ ->
                    ( model, (Utils.getRandomQuote SetQuote) )

                --fix later
                None ->
                    ( model, (Utils.getRandomQuote SetQuote) )

                Num r ri ->
                    case model.operand of
                        NoOp ->
                            ( model, (Utils.getRandomQuote SetQuote) )

                        Plus ->
                            ( Model (Num (l + r) 0) None mayOp "", (Utils.getRandomQuote SetQuote) )

                        Minus ->
                            ( Model (Num (l - r) 0) None mayOp "", (Utils.getRandomQuote SetQuote) )

                        Multply ->
                            ( Model (Num (l * r) 0) None mayOp "", (Utils.getRandomQuote SetQuote) )

                        Divide ->
                            if r == 0 then
                                ( { model | right = None }, (Utils.getRandomQuote SetQuote) )

                            else
                                ( Model (Num (l / r) 0) None NoOp "", (Utils.getRandomQuote SetQuote) )



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Calculator :)"
    , body =
        [ column []
            [ Ui.display 20 ((Utils.numStr model.left) ++ (Utils.opStr model.operand) ++ (Utils.numStr model.right))
            , Ui.display 20 (model.quote)
            , keypad
            ]
        ]
    }



----NEW KEYPAD


keypad : Element Msg
keypad =
    row []
        [ Ui.numPad <|
            { zero = Just (NumButt 0)
            , one = Just (NumButt 1)
            , two = Just (NumButt 2)
            , three = Just (NumButt 3)
            , four = Just (NumButt 4)
            , five = Just (NumButt 5)
            , six = Just (NumButt 6)
            , seven = Just (NumButt 7)
            , eight = Just (NumButt 8)
            , nine = Just (NumButt 9)
            , decimal = Just (NumMod Deci)
            , posneg = Just (NumMod PosNeg)
            , bcksp = Just Bcksp
            , clear = Just Clear
            }
        , Ui.simpleOps <|
            { add = Just (OpButt Plus)
            , sub = Just (OpButt Minus)
            , mult = Just (OpButt Multply)
            , div = Just (OpButt Divide)
            , equ = Just Solve
            }
        ]

