# UI
    - make a "display" object
        - set to fixed size regardless of current input
        - round edges
    - make buttons
        -laid out nice
# Logic

   

    -write out update functions
        button pressed
            
            number modifier
                
                deci - 
                    check if number is there
                        if not, render a . until it is ***
                        if so check if num has . **
                            if so ignore
                            if not render a . until a next digit comes*

            * push a . into a buffer that gets printed at the end of the expression in display
                on number button push check . buffer
                if empty app number as usual
                if not, clear it and append a . before number


            ** isInt : Float -> Bool
                isInt f = if f-f.floor == 0 true
                    else false


            

handle mod a mod 
and deci buffer

            use Just Mod for when there is no number, but a mod to render


            bcksp : remove last char from act num
            


            
        