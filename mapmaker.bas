   10 REM MapMaker V1.1 - Make, Modify, Load and Save a bitmap game field
   20 REM by 8BitVino
   30 REM https://github.com/8BitVino/mapmaker
   40 REM with code snippets from The-8bit-Noob & robogeek42
   50 MB%=&40000 : REM MEMORY BANK &40000.
   60 DIM graphics 1024
   70 DIM the_map%(14,14)
   80 DIM custompack$(9)
   90 DIM customslot%(9)
  100 XSIZE%=14:YSIZE%=14:x%=112:y%=112:ink%=1:sticky%=1
  110 p%=0:lega%=10:legb%=20:slot%=0:decks%=4:deckz%=40:V$="Version 1.1"
  120 custom%=0:clslot%=0:tilespack$="tiles"
  130 VDU 23,27,16 : REM CLEAR ALL SPRITE DATA.
  140 MODE 8 : REM SET SCREEN MODE.
  150 VDU 23,1,0 : REM DISABLE CURSOR.
  160 PROCsetupChars
  170 FOR T=0 TO 148:C.RND(32):P."MAPMAKER";:NEXT:PROCborder
  180 C.7:P.TAB(7,13);"M A P   M A K E R":C.20:P.TAB(10,14);V$
  190 PROCnumdecks
  200 C.15:P.TAB(6,16);"Reticulating splines"
  210 PROCgreenstart:PROCloadbitmaps:PROCreload:PROCmenulist
  220 VDU 23,27,0,0  :REM show cursor in middle at start
  230 VDU 23,27,3,x%;y%;
  240 ON ERROR PROCshowmap:GOTO250 :REM used to stop Escape key from stopping program and refreshes instead
  250 A%=INKEY(0) : REM GET KEYBOARD INPUT FROM PLAYER.
  260 IF A%=21 THEN PROCclearmove:PROCmoveright:PROCnewcursor :REM MOVE SPRITE RIGHT.
  270 IF A%=8 THEN PROCclearmove:PROCmoveleft:PROCnewcursor :REM MOVE SPRITE LEFT.
  280 IF A%=10 THEN PROCclearmove:PROCmoveup:PROCnewcursor :REM MOVE SPRITE DOWN.
  290 IF A%=11 THEN PROCclearmove:PROCmovedown:PROCnewcursor :REM MOVE SPRITE UP.
  300 IF A%=49 THEN PROClay(0+lega%):REM 1
  310 IF A%=50 THEN PROClay(1+lega%):REM 2
  320 IF A%=51 THEN PROClay(2+lega%):REM 3
  330 IF A%=52 THEN PROClay(3+lega%):REM 4
  340 IF A%=53 THEN PROClay(4+lega%):REM 5
  350 IF A%=54 THEN PROClay(5+lega%):REM 6
  360 IF A%=55 THEN PROClay(6+lega%):REM 7
  370 IF A%=56 THEN PROClay(7+lega%):REM 8
  380 IF A%=57 THEN PROClay(8+lega%):REM 9
  390 IF A%=48 THEN PROClay(9+lega%):REM 0
  400 IF A%=113 OR A%=81 THEN PROClay(0+legb%):REM q
  410 IF A%=119 OR A%=87 THEN PROClay(1+legb%):REM w
  420 IF A%=101 OR A%=69 THEN PROClay(2+legb%):REM e
  430 IF A%=114 OR A%=82 THEN PROClay(3+legb%):REM r
  440 IF A%=116 OR A%=84 THEN PROClay(4+legb%):REM t
  450 IF A%=121 OR A%=89 THEN PROClay(5+legb%):REM y
  460 IF A%=117 OR A%=85 THEN PROClay(6+legb%):REM u
  470 IF A%=105 OR A%=73 THEN PROClay(7+legb%):REM i
  480 IF A%=111 OR A%=79 THEN PROClay(8+legb%):REM o
  490 IF A%=80 OR A%=112 THEN PROClay(9+legb%):REM p
  500 IF A%=76 OR A%=108 THEN PROCloadmap::REM (L)OAD
  510 IF A%=86 OR A%=118 THEN PROCsavemap::REM SA(V)E
  520 IF A%=120 OR A%=88 THEN PROCcheckexit :REM (X) Exit
  530 IF A%=90 OR A%=122 THEN PROCzoneload:REM (Z) for tile load WRONG KEYS
  540 IF A%=78 OR A%=110 THEN PROCrandommap:REM ra(N)dom map
  550 IF A%=75 OR A%=107 THEN PROCpenflow :REM toggle ink (K)
  560 IF A%=91 PROClegendleft :REM LEFT LEGEND REFRESH ([)
  570 IF A%=93 PROClegendright :REM RIGHT LEGEND REFRESH (])
  580 IF A%=68 OR A%=64 THEN PROCdirs  :REM (D)
  590 IF A%=63 OR A%=47 THEN PROCinfo :REM (?)
  600 IF A%=67 OR A%=99 THEN PROCclearmap :REM (C)ls
  610 GOTO 250
  620 ENDPROC
  630 DEFPROCclearmap
  640 PROCborder
  650 C. 15:PRINTTAB(6,14);"CLEAR MAP":PRINTTAB(6,16);"Are you sure?":PRINTTAB(6,18);"Press Y to confirm"
  660 N$=GET$
  670 IF N$="y" OR N$="Y" THEN PROCgreenstart
  680 PROCrefresh
  690 ENDPROC
  700 DEFPROCclearmove
  710 XCORD%=x%MOD15 : REM Clever maths. Finds XCORD% by doing array value MODULUS 15.
  720 YCORD%=y%DIV15 : REM Clever maths. Finds YCORD% by doing array value DIV by 15.
  730 w%=the_map%(YCORD%,XCORD%) :REM find the object to restore. Why is X Y reversed?
  740 PROCclearcell
  750 VDU 23,27,0,w%   :REM select the graphic
  760 VDU 23,27,3,x%;y%; :REM paste sprite in location
  770 ENDPROC
  780 DEFPROCnewcursor :REM put the original bitmap back
  790 LOCAL XXCORD%,YYCORD%
  800 XXCORD%=x%MOD15 : REM Clever maths. Finds XCORD% by MODULUS 15.
  810 YYCORD%=y%DIV15 : REM Clever maths. Finds YCORD% by DIV 15.
  820 H%=the_map%(YYCORD%,XXCORD%)
  830 C. 15:PRINTTAB(32,6);"tile:";H%
  840 VDU 23,27,0,0   :REM select the tranparency box
  850 VDU 23,27,3,x%;y%; :REM paste sprite in location
  860 ENDPROC
  870 DEFPROCmoveright
  880 IF x%=224 THEN x%=0:GOTO 900 :REM far right boundary
  890 x%=x%+16
  900 PROCinkcheck
  910 ENDPROC
  920 DEFPROCmoveleft
  930 IF x%=0 THEN x%=224:GOTO 950 :REM far left boundary
  940 x%=x%-16
  950 PROCinkcheck
  960 ENDPROC
  970 DEFPROCmoveup
  980 IF y%=224 THEN y%=0:GOTO 1000 :REM bottom boundary
  990 y%=y%+16
 1000 PROCinkcheck
 1010 ENDPROC
 1020 DEFPROCmovedown
 1030 IF y%=0 THEN y%=224:GOTO 1050 :REM top boundary
 1040 y%=y%-16
 1050 PROCinkcheck
 1060 ENDPROC
 1070 DEFPROClegendleft
 1080 lega%=lega%+10
 1090 IF lega%=deckz% THEN lega%=10
 1100 PROCrefresh
 1110 ENDPROC
 1120 DEFPROClegendright
 1130 legb%=legb%+10
 1140 IF legb%=deckz% THEN legb%=10
 1150 PROCrefresh
 1160 ENDPROC
 1170 DEFPROClegend
 1180 C.1:PRINTTAB(30,8);"[";SPC(8);"]"
 1190 C.15:PRINTTAB(31,8);lega%DIV10
 1200 PRINTTAB(37,8);legb%DIV10
 1210 C.2:PRINTTAB(33,8)"BANK"
 1220 R%=72
 1230 FOR Q=0 TO 9
 1240   VDU23,27,0,Q+lega% :REM COLUMN 1
 1250   VDU23,27,3,247;R%;
 1260   VDU23,27,0,Q+legb% :REM COLUMN 2
 1270   VDU23,27,3,277;R%;
 1280   R%=R%+17
 1290 NEXT
 1300 ENDPROC
 1310 DEFPROCmenulist
 1320 COLOUR8:D%=700
 1330 VDU 5 :REM ALLOW TEXT IN GFX
 1340 FOR H=1 TO 9:MOVE 1060,D%:PRINT;H:D%=D%-73:NEXT
 1350 MOVE 1060,43:PRINT"0"
 1360 MOVE1188,702:P."Q":MOVE1188,628:P."W":MOVE1188,553:P."E":MOVE1188,481:P."R":MOVE1188,402:P."T"
 1370 MOVE1188,328:P."Y":MOVE1188,262:P."U":MOVE1188,184:P."I":MOVE1188,117:P."O":MOVE1188,50:P."P"
 1380 VDU 4 :REM STOP TEXT IN GFX
 1390 COLOUR5:P.TAB(39,9);:VDU243:P.TAB(39,11);"M":P.TAB(39,13);"A":P.TAB(39,15);"P":P.TAB(39,18);"M"
 1400 P.TAB(39,20);"A":P.TAB(39,22);"K":P.TAB(39,24);"E":P.TAB(39,26);"R":P.TAB(39,28);:VDU244
 1410 COLOUR1:PRINTTAB(35,0);:VDU240,243,244,242:COLOUR2:PRINTTAB(30,0);"Move"
 1420 PROCshort(30,1,"","L","oad"):PROCshort(35,1,"sa","V","e")
 1430 PROCshort(30,2,"e","X","it"):PROCshort(35,2,"ra","N","d")
 1440 PROCshort(30,3,"","Z","one"):PROCshort(35,3,"","D","irs")
 1450 PROCshort(30,4,"stic","K","y"):PROCshort(34,5,"","?",""):PROCshort(30,5,"","C","LS")
 1460 ENDPROC
 1470 DEFPROClay(H%)
 1480 sticky%=H% :REM set the sticky value
 1490 PRINTTAB(31,6);SPC(9)  :REM clear dialog box
 1500 COLOUR15:PRINTTAB(32,6);"tile:";H%
 1510 PROCclearcell
 1520 VDU 23,27,0,H%   :REM select the box
 1530 VDU 23,27,3,x%;y%; :REM movebox to new location
 1540 XCORD%=x%MOD15 : REM Clever maths. Finds XCORD% by MODULUS 15.
 1550 YCORD%=y%DIV15 : REM Clever maths. Finds YCORD% by DIV 15.
 1560 the_map%(YCORD%,XCORD%)=H%
 1570 ENDPROC
 1580 DEFPROCshort(x,y,pre$,hi$,post$)
 1590 PRINTTAB(x,y);:C.2:P.pre$;:C.1:P.hi$;:C.2:P.post$;
 1600 ENDPROC
 1610 DEFPROCloadbitmaps
 1620 C. 15
 1630 PROCload_bitmap("0","0",0,16,16) :REM LOAD THE TRANSPARENT CUBE FROM DIR 0
 1640 PROCload_bitmap("0","1",1,16,16) :REM LOAD THE BLACK TILEFROM DIR 0
 1650 PRINTTAB(17,18);"/ ";deckz% :REM fix this based on decks%
 1660 FOR R%=1 TO decks%
 1670   FOR L%=0 TO 9
 1680     p%=R%*10:p%=p%+L% :REM POPULATES SLOT
 1690     PROCload_bitmap(STR$(R%),STR$(L%),p%,16,16) :REM directory, filename, sprite number
 1700   NEXT
 1710 NEXT
 1720 ENDPROC
 1730 DEFPROCload_bitmap(D$,F$,N%,W%,H%)
 1740 IF N%=9 THEN PRINTTAB(15,18);"  "
 1750 PRINTTAB(13,18);N% :REM SHOW LOAD SPRITE
 1760 OSCLI("LOAD " + D$ + "/" + F$ + ".rgb" + " " + STR$(MB%+graphics))
 1770 VDU 23,27,0,N% : REM SELECT SPRITE n (equating to buffer ID numbered 64000+n).
 1780 VDU 23,27,1,W%;H%; : REM LOAD COLOUR BITMAP DATA INTO CURRENT SPRITE.
 1790 FOR I%=0 TO (W%*H%*4)-1 STEP 4 : REM LOOP 16x16x3 EACH PIXEL R,G,B,A
 1800   r% = ?(graphics+I%+0) : REM RED DATA.
 1810   g% = ?(graphics+I%+1) : REM GREEN DATA.
 1820   b% = ?(graphics+I%+2) : REM BLUE DATA.
 1830   a% = ?(graphics+I%+3) : REM ALPHA (TRANSPARENCY)
 1840   VDU r%, g%, b%, a%
 1850 NEXT
 1860 ENDPROC
 1870 DEFPROCshowmap
 1880 LOCAL XLOC%,YLOC%
 1890 FOR j=0TOYSIZE%
 1900   FOR i=0TOXSIZE%
 1910     g%=the_map%(i,j)
 1920     VDU 23,27,0,g% : REM select the specified bitmap
 1930     VDU 23,27,3,YLOC%;XLOC%;   : REM displays the bitmap
 1940     XLOC%=XLOC%+16 :REM update the X location to move to the right
 1950     IF i=14 THEN YLOC%=YLOC%+16:XLOC%=0 :REM at end of row move to start next line and down
 1960   NEXT
 1970 NEXT
 1980 PROCnewcursor :REM always reshow the cursor on a showmap
 1990 ENDPROC
 2000 DEFPROCrandommap
 2010 FOR i=0TOXSIZE%:FOR j=0TOYSIZE%
 2020     the_map%(i,j)=RND(deckz%-10)+10:NEXT:NEXT
 2030 PROCrefresh
 2040 ENDPROC
 2050 DEFPROCsavemap
 2060 PROCborder
 2070 INPUT TAB(7,14) "Save map filename?",TAB(7,16) FILENAME$
 2080 A=OPENOUT FILENAME$
 2090 PRINT#A,XSIZE%
 2100 PRINT#A,YSIZE%
 2110 PRINT#A,decks% :REM output number of decks in use
 2120 PRINT#A,custom% :REM output number of custom zones in use
 2130 FOR i=0TOXSIZE%
 2140   FOR j=0TOYSIZE%
 2150     PRINT#A,the_map%(i,j)
 2160   NEXT
 2170 NEXT
 2180 IF custom%>0 THEN PROCcustomsave
 2190 CLOSE#A
 2200 PROCanykey
 2210 PROCrefresh
 2220 ENDPROC
 2230 DEFPROCcustomsave
 2240 FOR G%=0 TO custom%-1  :REM loop for number of saved custom
 2250   PRINT#A,custompack$(G%)
 2260   PRINT#A,customslot%(G%)
 2270 NEXT
 2280 ENDPROC
 2290 DEFPROCloadmap
 2300 LOCAL XIMP%,YIMP%
 2310 PROCborder
 2320 C. 15:INPUT TAB(7,14) "Load map filename?",TAB(7,16) FILENAME$
 2330 fnum=OPENIN FILENAME$
 2340 IF fnum=0 THEN PRINTTAB(7,14);"Filename NOT loaded":GOTO2480
 2350 INPUT#fnum,XIMP% :REM Read X map size
 2360 INPUT#fnum,YIMP% :REM Read Y map size
 2370 INPUT#fnum,decks% :REM load the number of decks in use
 2380 INPUT#fnum,custom% :REM read number of custom tile slots
 2390 FOR i=0TOXIMP% :REM read map based on defined size
 2400   FOR j=0TOYIMP%
 2410     INPUT#fnum,the_map%(i,j) :REM save to map
 2420   NEXT
 2430 NEXT
 2440 deckz%=decks%*10+10
 2450 PRINTTAB(7,16);"Loading tiles..."
 2460 PROCloadbitmaps :REM reloading base bitmaps (needed because decks%)
 2470 IF custom%>0 THEN PROCcustomload
 2480 CLOSE#fnum
 2490 PROCanykey:PROCrefresh
 2500 ENDPROC
 2510 DEFPROCcustomload
 2520 PRINTTAB(7,16);"Loading extras..."
 2530 PRINTTAB(19,18);custom%*10+10
 2540 FOR G%=0 TO custom%-1  :REM loop for number of saved custom
 2550   INPUT#fnum,clpack$
 2560   INPUT#fnum,clslot%
 2570   FOR L%=0 TO 9
 2580     PROCload_bitmap(clpack$,STR$(L%),(clslot%+L%),16,16) :REM directory, filename, sprite number
 2590   NEXT
 2600   custompack$(G%)=clpack$ :REM replay into the custom tilepack
 2610   customslot%(G%)=clslot% :REM replay into the slot
 2620 NEXT
 2630 ENDPROC
 2640 DEFPROCgreenstart
 2650 FOR i=0TOYSIZE%:FOR j=0TOXSIZE%:the_map%(i,j)=1:NEXT:NEXT
 2660 ENDPROC
 2670 DEFPROCsetupChars
 2680 VDU 23,240,0,&20,&40,&FF,&40,&20,0,0 : REM left arrow
 2690 VDU 23,242,0,&04,&02,&FF,&02,&04,0,0 : REM right
 2700 VDU 23,243,&10,&38,&54,&10,&10,&10,&10,0 : REM up
 2710 VDU 23,244,&10,&10,&10,&10,&54,&38,&10,0 : REM down
 2720 VDU 23,230,255,255,255,255,255,255,255,255  :REM block
 2730 ENDPROC
 2740 DEFPROCzoneload
 2750 PROCborder
 2760 IF custom%>9 THEN COLOUR9:PRINTTAB(9,15);"Exceeded max":PRINTTAB(7,17);"custom slot limit":GOTO2870
 2770 C. 15:INPUT TAB(7,14) "Load tile pack?",TAB(7,15) "(enter dir name)", TAB(7,17) tilespack$
 2780 PRINTTAB(7,17);SPC(16):INPUT TAB(7,14) "Which slot?    ",TAB(7,15) "(enter slot number)", TAB(7,17) slot%
 2790 IF slot%<1 OR slot%>decks% THEN COLOUR9:PRINTTAB(7,19);"Invalid slot. retry":GOTO2780
 2800 slot%=slot%*10
 2810 FOR L%=0 TO 9
 2820   PROCload_bitmap(tilespack$,STR$(L%),(slot%+L%),16,16) :REM directory, filename, sprite number
 2830 NEXT
 2840 custompack$(custom%)=tilespack$   :REM ASSIGN the tilepack used to custompack
 2850 customslot%(custom%)=slot%  :REM record the slot 10-990
 2860 custom%=custom%+1
 2870 PROCreload
 2880 ENDPROC
 2890 DEFPROCborder
 2900 FOR G=12 TO 20 STEP 1:COLOUR0:PRINTTAB(5,G);SPC(22):COLOUR6:PRINTTAB(4,G);CHR$230:PRINTTAB(27,G);CHR$230:NEXT
 2910 COLOUR6:PRINTTAB(5,12);STRING$(22,CHR$230):PRINTTAB(5,20);STRING$(22,CHR$230)
 2920 ENDPROC
 2930 DEFPROCcheckexit
 2940 PROCborder
 2950 C. 15:PRINTTAB(7,14);"Quit:Are you sure?":PRINTTAB(7,16);"Press Y to confirm"
 2960 N$=GET$
 2970 IF N$="y" OR N$="Y" THEN GOTO 3430
 2980 PROCshowmap
 2990 ENDPROC
 3000 DEFPROCrefresh
 3010 CLS:PROClegend:PROCshowmap:PROCmenulist
 3020 ENDPROC
 3030 DEFPROCreload
 3040 PROCrefresh:PROCpenflow
 3050 ENDPROC
 3060 DEFPROCpenflow
 3070 IF ink%=0 THEN ink%=1:COLOUR10:PRINTTAB(37,4);"ON ":GOTO3090
 3080 ink%=0:COLOUR1:PRINTTAB(37,4);"OFF"
 3090 ENDPROC
 3100 DEFPROCinkcheck
 3110 IF ink%=1 THEN PROCclearcell:PROClay(sticky%)
 3120 ENDPROC
 3130 DEFPROCclearcell
 3140 VDU 23,27,0,1 :REM CLEAR WITH BLACK FRAME
 3150 VDU 23,27,3,x%;y%; :REM PASTE BLACK FRAME
 3160 ENDPROC
 3170 DEFPROCnumdecks
 3180 C.15:PRINTTAB(8,19);"(5 recommended)"
 3190 INPUT TAB(6,16) "How many tile packs?",TAB(15,18) decks%
 3200 IF decks%<2 OR decks%>99 THEN COLOUR 9:PRINTTAB(7,19);"Invalid. try again":GOTO3190
 3210 deckz%=decks%*10+10
 3220 PRINTTAB(9,17);SPC(16):PRINTTAB(15,18);SPC(10):PRINTTAB(7,19);SPC(18)
 3230 ENDPROC
 3240 DEFPROCdirs
 3250 PROCborder:COLOUR15:PRINTTAB(6,13);"Custom slot dirs"
 3260 FOR T%=0 TO 4
 3270   PRINTTAB(5,15+T%);T%+1;" ";custompack$(T%)
 3280   PRINTTAB(15,15+T%);T%+6;" ";custompack$(T%+5)
 3290 NEXT
 3300 temp=GET
 3310 PROCrefresh
 3320 ENDPROC
 3330 DEFPROCinfo
 3340 PROCborder
 3350 COLOUR15:PRINTTAB(6,13);"Mapmaker ";V$
 3360 PRINTTAB(6,15);"See readme.txt"
 3370 PRINTTAB(6,16);"for instructions"
 3380 PROCanykey:PROCrefresh
 3390 ENDPROC
 3400 DEFPROCanykey
 3410 PRINTTAB(7,18);"Press any key...":temp=GET
 3420 ENDPROC
 3430 CLS:P."GOODBYE!":END
