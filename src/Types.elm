module Types exposing (Numb(..), Mod(..), Op(..))


type Numb
    = Num Float Int
    | NumWD Float Int
    | Mod Mod
    | None

type Mod
    = Deci
    | PosNeg
    | Both

type Op
    = Plus
    | Minus
    | Multply
    | Divide
    | NoOp
