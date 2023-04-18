# MCLevelReader
Powershell 5 script to process level files from the Bullfrog Productions game Magic Carpet into human readable CSV format to aid in reverse engineering and editing. Can also optionally produce a PNG image map of all entities in a level.

Heavily based on the findings [here](https://github.com/michaelhoward/MagicCarpetFileFormat/blob/master/magic%20carpet%20file%20format.txt).

You will need to uncompress your level files first, using e.g. [this](https://github.com/lab313ru/rnc_propack_source) tool. You can find the seperate level files on the CD of the original release of Magic Carpet (not Magic Carpet Plus).

# Usage

  The level file to open. E.g. LEV00000.DAT, and then if you want a map drawn or not: -map

  MCLevelReader.ps1  LEV00000.DAT -map
    
  The script will produce two CSV files, one containing Thing data (i.e. enemies, walls etc), the second Wizard data - which NPC wizards are present in the      level and their ability levels.
  
# Map Output

If you supply the optional -map argument, a crude PNG map of entities in the level will be drawn for you. 

Map Key:<br/>
Red - Creature (enemies but also villagers)<br/>
Yellow - Player start (including computer controlled wizards)<br/>
Green - Scenery (includes trees and standing stones)<br/>
Purple - Spells<br/>
Cyan - Effect (things like explosions but also extra map elements like canyons and walls)<br/>
White - Switch (hidden switches)<br/>

Examples:

![Level26](https://github.com/Moburma/MCLevelReader/blob/main/LEV00026.DAT.png)
![Level27](https://github.com/Moburma/MCLevelReader/blob/main/LEV00027.DAT.png)
