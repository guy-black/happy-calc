# UI
    - make a "display" object
        - set to fixed size regardless of current input
        - round edges
    - make buttons
        -laid out nice
# Logic


     bcksp -> 
        case model.right of
            None ->
                case model.operand of
                    None ->
                        case model.left of
                            None -> model
                            _ -> {model | left = bckspNumb model.left}
                    _ -> {model | operand = NoOP}
            _ -> {model | right = bckspNumb model.right}

    
    bckspNumb : Numb -> Numb
    bckspNumb n =
        case n of
            None -> None
            Num f i ->
                if i>0 then Num f i-1
                else --convert f to string, apply dropRight 1, convert back to float, return Num new f i
            NumWD f i -> 
                if i>0 then NumWD f i-1
                else Num f i
            Mod m -> 
                case m of
                    Both -> Mod PosNeg
                    _ -> None