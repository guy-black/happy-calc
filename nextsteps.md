# UI
    - make a "display" object
        - set to fixed size regardless of current input
        - round edges
    - make buttons
        -laid out nice
# Logic

   

    -write out update functions
        button pressed
            number:
                if operator is Nothing
                    append to left
                else append to right
            operator
                if operator is nothing
                    if left is nothing
                        set left to 0
                    set operator
                if operator is something
                    if right is nothing
                        change opersator
                    if right is something
                        solve,, set operator
            number modifier
                if op is nothing
                    apply to left
                if op is something
                    apply to right
                posneg - multipy num by -1
                deci - if num float, ignore, else convert to float

            bcksp : remove last char from act num
            clr : reset state
            eval :  check for any nothings
                    convert left and right to reg numbers
                    then do evaluation


            
        