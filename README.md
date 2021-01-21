# kitty-jump
## Overview
This project is a game similar to the famous "Doodle Jump" game written in MIPS assembly language.
## Configuration
The project is written and tested in MARS 4.5 developed by Pete Sanderson and Ken Vollmar at Missouri State University. 
Link: http://courses.missouristate.edu/kenvollmar/mars/

To play the game, first open the code file in MARS, and go to Tools - Bitmap Display. Set the configuration as follows:

- Unit width in pixels:       8				     
- Unit height in pixels:      8
- Display width in pixels:    256
- Display height in pixels: 	512
- Base Address for Display: 	0x10008000 ($gp)

Resize the window to fit the bitmap display.
Click on "Connet to MIPS".

Then go to "Tools - Keyboard and Display MMIO Simulater". Again, click on "Connet to MIPS".

You are all set! Simply click on the "Assemble" button on the toolbar and run the program. You can control the Kitty by hitting "J" (turn left) and "K" (turn right).
