# MapMaker

## Background
MapMaker is a map-making utility designed for the AgonLight and Console8 systems, written entirely in BBC Basic with MODE8. Mode 8 was chosen to showcase 16x16 bitmaps with 64-color support. The release playfield is 15x15 wide - but future versions of editor will allow bigger and smaller maps.

## System Requirements
- Tested on (pre-compiled) **Fab Agon Emulator 0.9.12**
- Tested on **AgonLight2** with VDP/MOS 1.04 
- *Should* work on **Console 8** VDP 2.3.0

## Editor controls
Arrow keys: Move cursor
L: Load map (try the example.map provided)
S: Save map (no automatic extensions applied)
N: Create a random map from the existing tileset
Z: Sticky Pen toggle on/off. Default off. When you move it will continue painting with the last tile you layed.
X: Exit the editor (ESC key intentionally won't stop the editor!)


## DIY tiles
The default behaviour is for the tileset is loading the RGBA tiles 0.rgb to 18.rgb from the <tiles> subdirectory.  

To use a custom tileset, create it with sped 1.02
chai(https://github.com/robogeek42/agon_sped/). 
1) Ensure that one pallete colour is made a transparent (alpha) tile (T) 
2) Save in format (2)RGBA8, no multiple frames. 
3) Create a folder in mapmaker directory <yourdirectory> and place your files inside labelled 1.rgb to 18.rgb.
4) Copy the 0.rgb from tiles direcotry to <yourdirectory> (this is the cursor sprite with transparency needed for editor)
5) Either a) Edit mapmaker.bas and change tilespack$="<yourdirectory>"
          b) In mapmaker select Z to load a zone and enter <yourdirectory>

## Making Your Own Game
Included is game.bas, a cut-down version of the editor, serving as a template to create your own game. 

The game.bas will load the example.map file. To use your own map simply change the MYMAP$ variable with your custom map's name. 

The default tile set can be specified by changing tilespack$ variable to match the directory you have you tiles numbered 0.rgb - 18.rgb

As a courtesy, if you create content using the map editor and or game.bas, please leave a credit to 8BitVino in your code.

## File structure
mapmaker.bas - Map Maker
game.bas - Stripped down version of mapmaker for creating your own games
tiles\0-18.rgb - Default 16x16 bitmaps created in Sped. 
example.map - Example map

## Future enhancements planned
- Larger and smaller map support
- Selectable number of tiles per map
- Greater overall available tiles (36)
- Flood fill
- Joystick support

### Thank you:
The 8bit Noob - https://github.com/The-8bit-Noob - for sprite demos and testing MapMaker
Robogeek42 - https://github.com/robogeek42 - for agon-sped sprite editor and testing MapMaker

### Contact details
Please report any bugs to 8bitvino@gmail.com

### Interested in coding for AgonLight/Console8? 
Find us on discord channel Agon Programmer / #sprite-editors
https://discord.com/channels/1080130527908069467/1096246023799722014

### Release version information
v1.0 Inital code release 24/1/2024

### Screenshots
<a href="loading.png" target="blank"><img align="center" src="https://github.com/8BitVino/mapmaker/blob/main/loading.png
" height="100" /></a>
<a href="random.png" target="blank"><img align="center" src="https://github.com/8BitVino/mapmaker/blob/main/random.png" height="100" /></a>
<a href="example.png" target="blank"><img align="center" src="https://github.com/8BitVino/mapmaker/blob/main/example.png" height="100" /></a>