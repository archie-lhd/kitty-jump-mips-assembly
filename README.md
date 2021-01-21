# kitty-jump
## Overview
This project is a game similar to the famous "Doodle Jump" game written in MIPS assembly language.
## Configuration
The project is written and tested in MARS 4.5 developed by Pete Sanderson and Ken Vollmar at Missouri State University. 
Link: http://courses.missouristate.edu/kenvollmar/mars/

To play the game, first open the code file in MARS, and go to ***Tools - Bitmap Display***. Set the configuration as follows:

- Unit width in pixels: &emsp;&emsp;&emsp;&ensp;&ensp;8    			     
- Unit height in pixels: &emsp;&emsp;&emsp; 8
- Display width in pixels: &emsp;&ensp;&ensp;256
- Display height in pixels: &emsp;	512
- Base Address for Display: 	0x10008000 ($gp)

Resize the window to fit the bitmap display.
Click on ***Connet to MIPS***.

Then go to ***Tools - Keyboard and Display MMIO Simulater***.

####Congratulations! You are now all set!
Simply click on <img src=https://user-images.githubusercontent.com/77775845/105328859-7e7cca80-5b9e-11eb-96de-de8f371a2de4.jpg width = "30" alt = "MARS-assemble-icon">
on the toolbar to assemble the program 
 and then click on <img src=https://user-images.githubusercontent.com/77775845/105328867-80468e00-5b9e-11eb-8a9c-3981acb516d4.jpg width = "30" alt = "MARS-run-icon">
to run it. 

You can control the Kitty by hitting "J (turn left) and "K" (turn right) on your keyboard.

