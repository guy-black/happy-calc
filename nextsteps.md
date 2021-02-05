# UI
    - make a "display" object
        - set to fixed size regardless of current input
        - round edges
    - make buttons
        -numbers
        -number modifiers
            - negative and decimal
        -operands
        -eval
        -laid out nice
# Logic
    -fill out messages and update
        if number or number modifier
            if operand == nothing
                append to left
            else 
                append to right
        if operand
            if operand == nothing
                set operand
            else
                eval
                set answer as left and set operator
            
        