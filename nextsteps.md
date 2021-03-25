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

## conversions
    -length
        -logic
            -model = {
                input : Len
                ,output : List Len
            }
            -update
                inputChange -> update all output val
                outputChange unit ->
                    case unit is in model.output -> remove unit from model.output
                    case unit isnt in model.output -> add Len Unit input-converted 
        
            -type Len =
                {unit : Unit
                ,val : Float}
            -type Unit
                -mm milimeter
                -cm centimeter
                -m meter
                -km kilometer
                -in inch
                -ft feet
                -yd yard
                -mi mile
                -mnm M&M
                -minm mini m&m
                -gianm giant m&m
        -ui
            -numberpad
                -0-9, -, ., bcksp
            -input number
            -input drop down, choose unit
            -output dropdown list of check boxes for output units
            -render a list of all the outputs
    
    -weight
        -same as length but with different units
    -volume
        -same as length but with different units
    -caesars cipher
        -model {
            input : String
            offset : int
        }

        view
            -input text box
            -input int
            -encrypt model.input model.offset

    -temperature
        -model =
            {
                F : Float
                C : Float
                K : Float
            }
        -update
            -when one changed manually, update the others automatically
        -view
            -keypad
            -3 inputs
            -write in one to update the others
    -ohms law
        -same as temperature but with different units
    -maybe more later

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