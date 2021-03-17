# simple desktop calculator

## UI
    - make a "display" object
        - set to fixed size regardless of current input
        - round edges
    - make buttons
        -laid out nice
## Logic

-set up api connection
    -channge from sandbox to element
     	  -subscriptions can return Sub.none for now, look more later
    -init and update have to return (model, command) instead of model.
    	  -set to cmd.none for all instances right now
    	  -make a command to get the quote
	  	-more on how to make my command here
	  -make the eval function return command with model
	  	-all under update function will either just return (newmodel, cmd.none) or eval model _

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
