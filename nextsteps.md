# simple desktop calculator

## UI
    - make a "display" object
        - set to fixed size regardless of current input
        - round edges
    - make buttons
        -laid out nice
## Logic

Done?

# conversions and other common formulas calculator

## UI
    - display a Form Element Msg

    - display a keypad

## Logic

    - model = {
        inputs : List Float ? --look up list, array, set, etc, figure what would be best here
        form : Form
        actInput : Int --refers to which of inputs is being modified
    }

    - Form data type has
        -Element Msg
            -shows the inputs, output and any other labels
        -update function 
        -default inputs
        

    - main update function
        - chgForm Form -> load a new Form, let inputs to newform defaults
        - inputSelected Int -> set actInput to Int
        - keypadTouched -> update inputs

# long form equation evaluator

## UI
    -a 'whiteboard' area for a display
        -larger than needed to start, plenty of room to add stuff
        -scroll infinitely
        -want to look like real written math symbols
            -LaTeX?
        -on eval, show all steps of work on scrollable whiteboard, ie
                6-(3+8)*4²
                 6-11*4²
                 6-11*16
                  6-176
                  -170
    -keypad
        -0-9
        -+,-,*,/,.,+-
            -/ should be represented as a horizontal bar
            -think of clever way for user to choose whats on top, bottom, left and right naturally
        -add () and exponents
        -replace = with EVAL
        -maybe nth roots, logs, sin, cos, tan etc later



## Logic
    -model
        -a list of expr
            -type expr
            =number
            |operator
                -binary
                -unary
            |modifier
            |parenthesis
                
        -numbers
        -operators
        -modifiers (. +-)
    -update
        -Eval
            -call eval on all parenthesis until flat
                -if more than one number over or uner --- then treat as parenthesis
            -apply exponents
            -go left to right down the list looking for * and /
                -apply * to num before and after it, apply / to num above and below it
            -go left to right looking for plus and minus (should be last operators left)
                -apply operator to the number before and after it
    

# positive affirmation server
    -simple JSON REST server
    -want to use haskell
        -spock
        -scotty
        -wai/warp
        -look at more options