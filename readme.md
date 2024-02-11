# MapMaker

## Background
MapMaker is a map-making utility designed for the AgonLight and Console8 systems, written entirely in BBC Basic with MODE8. Mode 8 was chosen to showcase 16x16 bitmaps with 64-color support. The release playfield is 15x15 wide - but future versions of editor will allow bigger and smaller maps.

## System Requirements
- Tested on (pre-compiled) **Fab Agon Emulator 0.9.12**
- Tested on **AgonLight 2** with VDP/MOS 1.04 
- *Should* work on **Console 8** VDP 2.3.0

## Editor controls
Arrow keys: Move cursor

**L** : (L)oad map (try dungeon.map)

**V** : Sa(V)e map (as is no automatic extensions applied)

**X** : e(X)it the editor (ESC key intentionally won't stop the editor!)

**N** : ra(N)domly create a map from the existing tilesets

**K** : stic(K)y Pen toggle on/off. Default off. Continue painting with the last tile you layed.

**D** : (D)irs shows the current loaded custom folders

**C** : (C)ls clears current screen with black tiles

**?** : Help

**[** : Scrolls through available tilesets on left bank

**]** : Scrolls through available tilesets on right bank

 
## Tile pack layout
Mapmaker supports large number of tiles using concept of banks(tilepacks). 

A bank is a collection of 10 bitmaps labelled 0.rgb to 9.rgb in a subdirectory from the base mapmaker.bas directory. 

There is an additional "system" bank 0 (directory 0\ ) that is reserved for special tiles being transparency selector bitmap and black tile.

The base git package includes 5 useable banks, ie: directories 1 to 5. 

There are several different methods to load your own tilepacks.

1) Replace the current .rgb files in directories 1-5

2) Add additional directories sequentially from 6 onwards and when starting select a new total number

3) Use the (Z)one tool to load in your own custom tilesets replacing the existing tilesets and save the mapfile. *Note this method needs further consideration for your game file to consider custom load files.

As tile packs bitmaps are loaded into higher memory of the ESP32 (Memory bank &40000) you can load large number of tile packs however the tool is currently limited to 99 zones = 990 custom tiles!

## Making RGB tiles
Mapmaker relies on tiles in RGBA8 format. 

Create new tiles with sped 1.02 (https://github.com/robogeek42/agon_sped/) 
1) Ensure that one pallete colour is made a transparent (alpha) tile (T) - it doesn't acutally need to be used. 

2) Save in format (2)RGBA8, no multiple frames. 

3) Create a folder in mapmaker directory <yourdirectory> and place your files inside labelled 0.rgb to 9.rgb.

4) See tile pack layout information on how to import 

## Maptool utility
An additional basic program called "maptool.bas" has been included. The purpose of this utility is to interigate the saved maps and provide basic information useful for directories in use and mapsizes. 

## Making Your Own Game
Included is dungeon.bas, "Dungeon Crawler". This is a cut-down version of the editor code serving as a template to create your own game. 

## File structure
mapmaker.bas - Map Maker

maptool.bas - Maptool utility 

**dungeon.bas** - Example base game "Dungeon Crawler" (also requires directories /0-5, dungeon.map & dungeon2.map) 

0\ - Special directory containing black tile (1.rgb) and the cursor (0.rgb)

**1 to 5\0-9.rgb** - Default 16x16 bitmaps created in Sped. 

## Map file format
When saving a map the following is the technical format of the saved files

**X%** - Defines the number of tiles wide (15 total this release)

**Y%** - Defines the number of tiles depth (15 total this release)

**decks%** - Define the total number of banks (including custom) in use

**custom%** - Defines the number of custom banks in use

**array(X%,Y%)**- Contains the tile values for the 14x14 array 

**custompack$** - Defines the custom directory to load tiles from

**customslot%** - Defines the assigned slot to load the custompack into

The **custompack$** and **customslot%** are optional and will be added to the save map file dependant on how many entries are defined in the custom%

## Future enhancements planned
- Larger and smaller map support

### Thank you:
[The 8bit Noob](https://github.com/The-8bit-Noob) - for sprite demos and testing MapMaker

[Robogeek42](https://github.com/robogeek42) - for Agon-sped sprite editor and testing MapMaker

## Tutorial
(*Deprecated*) The 8bit Noob has created a [video tutorial](https://youtu.be/1-fgj9UJj9c?si=Hou5eBpbFkzGQucr)



### Contact details
Please report any bugs to 8bitvino at gmail.com


### Interested in coding for AgonLight/Console8? 
Find us on the Discord channel [Agon Programmer](https://discord.com/channels/1080130527908069467/1096246023799722014)


### Release version information
v1.0 Inital code release 24/1/2024

v1.1 Released 11/2/2024

### Screenshots
<a href="loading.png" target="blank"><img align="center" src="https://github.com/8BitVino/mapmaker/blob/main/loading.png" height="100" /></a>
<a href="random.png" target="blank"><img align="center" src="https://github.com/8BitVino/mapmaker/blob/main/random.png" height="100" /></a>
<a href="example.png" target="blank"><img align="center" src="https://github.com/8BitVino/mapmaker/blob/main/example.png" height="100" /></a>
