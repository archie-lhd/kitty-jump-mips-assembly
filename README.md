# kitty-jump
## Overview
Kitty Jump is a game similar to the classic "Doodle Jump" game, implemented in MIPS assembly language.
## Configuration
The project is written and tested in **MARS 4.5** developed by Pete Sanderson and Ken Vollmar at Missouri State University. 
[Download MARS 4.5](http://courses.missouristate.edu/kenvollmar/mars/)

To play the game, first open the code file in MARS, and go to ***Tools - Bitmap Display***. Set the configuration as follows:

- Unit width in pixels: 8        		     
- Unit height in pixels: 8
- Display width in pixels: 256
- Display height in pixels: 512
- Base Address for Display: 0x10008000 ($gp)

Resize the window to fit the bitmap display. Click on ***Connet to MIPS***.

Then go to ***Tools - Keyboard and Display MMIO Simulater***. Again, click on ***Connet to MIPS***.

Simply click on <img src=https://user-images.githubusercontent.com/77775845/105328859-7e7cca80-5b9e-11eb-96de-de8f371a2de4.jpg width = "30" alt = "MARS-assemble-icon">
on the toolbar to assemble the program 
 and then click on <img src=https://user-images.githubusercontent.com/77775845/105328867-80468e00-5b9e-11eb-8a9c-3981acb516d4.jpg width = "30" alt = "MARS-run-icon">
to run it. 

**Congratulations! You are now all set!**

## Game Instruction
Control the Kitty by hitting "J" (move left) and "K" (move right) on your keyboard.

Pause the game by hitting "P". Hit "P" again to continue.


