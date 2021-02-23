# simple desktop calculator

## UI
    - make a "display" object
        - set to fixed size regardless of current input
        - round edges
    - make buttons
        -laid out nice
## Logic


    -set up api connection

# conversions

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
