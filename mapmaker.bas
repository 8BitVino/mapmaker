   10 REM MapMaker. Make, Modify, Load and Save a bitmap game field
   20 REM by 8BitVino. v1.0 (Release version)
   30 REM https://github.com/8BitVino/mapmaker
   40 REM with code snippets from The-8bit-Noob & robogeek42
   50 MB%=&40000 : REM MEMORY BANK &40000.
   60 DIM graphics 1024 : REM ARRAY FOR PIXELS ?.
   70 DIM the_map%(14,14)
   80 XSIZE%=14:YSIZE%=14:XIMP%=0:YIMP%=0:x%=112:y%=112:ink%=1:sticky%=1
   90 tilespack$="tiles"   :REM changes for your custom tiles directory
  100 VDU 23,27,16 : REM CLEAR ALL SPRITE DATA.
  110 MODE 8 : REM SET SCREEN MODE.
  120 CLS : REM CLEAR THE SCREEN.
  130 VDU 23,1,0 : REM DISABLE CURSOR.
  140 PROCsetupChars
  150 FOR T=0 TO 148:C.RND(32):P."MAPMAKER";:NEXT:PROCborder
  160 C.15:P.TAB(7,13);"M A P   M A K E R":C.1:P.TAB(10,14);"PRE-RELEASE 2"
  170 C.15:P.TAB(6,16);"Reticulating splines"
  180 PROCgreenstart
  190 PROCreload
  200 VDU 23,27,0,0  :REM show cursor in middle at start
  210 VDU 23,27,3,x%;y%;
  220 ON ERROR PROCshowmap:GOTO230 :REM used to stop Escape key from stopping program and refreshes instead
  230 A%=INKEY(0) : REM GET KEYBOARD INPUT FROM PLAYER.
  240 IF A%=21 THEN PROCclearmove:PROCmoveright:PROCnewcursor :REM MOVE SPRITE RIGHT.
  250 IF A%=8 THEN PROCclearmove:PROCmoveleft:PROCnewcursor :REM MOVE SPRITE LEFT.
  260 IF A%=10 THEN PROCclearmove:PROCmoveup:PROCnewcursor :REM MOVE SPRITE DOWN.
  270 IF A%=11 THEN PROCclearmove:PROCmovedown:PROCnewcursor :REM MOVE SPRITE UP.
  280 IF A%=49 THEN PROClay(1):REM 1
  290 IF A%=50 THEN PROClay(2):REM 2
  300 IF A%=51 THEN PROClay(3):REM 3
  310 IF A%=52 THEN PROClay(4):REM 4
  320 IF A%=53 THEN PROClay(5):REM 5
  330 IF A%=54 THEN PROClay(6):REM 6
  340 IF A%=55 THEN PROClay(7):REM 7
  350 IF A%=56 THEN PROClay(8):REM 8
  360 IF A%=57 THEN PROClay(9):REM 9
  370 IF A%=113 OR A%=81 THEN PROClay(10):REM q
  380 IF A%=119 OR A%=87 THEN PROClay(11):REM w
  390 IF A%=101 OR A%=69 THEN PROClay(12):REM e
  400 IF A%=114 OR A%=82 THEN PROClay(13):REM r
  410 IF A%=116 OR A%=84 THEN PROClay(14):REM t
  420 IF A%=121 OR A%=89 THEN PROClay(15):REM y
  430 IF A%=117 OR A%=85 THEN PROClay(16):REM u
  440 IF A%=105 OR A%=73 THEN PROClay(17):REM i
  450 IF A%=111 OR A%=79 THEN PROClay(18):REM o
  460 IF A%=76 OR A%=108 THEN PROCloadmap::REM (L)OAD
  470 IF A%=83 OR A%=115 THEN PROCsavemap::REM (S)AVE
  480 IF A%=120 OR A%=88 THEN PROCcheckexit :REM (X) Exit
  490 IF A%=90 OR A%=122 THEN PROCzoneload:REM (Z) for tile load WRONG KEYS
  500 IF A%=78 OR A%=110 THEN PROCrandommap:REM ra(N)dom map
  510 IF A%=75 OR A%=107 THEN PROCpenflow :REM toggle ink (K)
  520 GOTO 230
  530 ENDPROC
  540 DEFPROCclearmove
  550 XCORD%=x%MOD15 : REM Clever maths. Finds XCORD% by doing array value MODULUS 15.
  560 YCORD%=y%DIV15 : REM Clever maths. Finds YCORD% by doing array value DIV by 15.
  570 w%=the_map%(YCORD%,XCORD%) :REM find the object to restore. Why is X Y reversed?
  580 VDU 23,27,0,w%   :REM select the graphic
  590 VDU 23,27,3,x%;y%; :REM movebox to new location
  600 ENDPROC
  610 DEFPROCmoveright
  620 IF x%=224 THEN x%=0:GOTO 640 :REM far right boundary
  630 x%=x%+16
  640 PROCinkcheck
  650 ENDPROC
  660 DEFPROCmoveleft
  670 IF x%=0 THEN x%=224:GOTO 690 :REM far left boundary
  680 x%=x%-16
  690 PROCinkcheck
  700 ENDPROC
  710 DEFPROCmoveup
  720 IF y%=224 THEN y%=0:GOTO 740 :REM bottom boundary
  730 y%=y%+16
  740 PROCinkcheck
  750 ENDPROC
  760 DEFPROCmovedown
  770 IF y%=0 THEN y%=224:GOTO 790 :REM top boundary
  780 y%=y%-16
  790 PROCinkcheck
  800 ENDPROC
  810 DEFPROCnewcursor :REM put the original bitmap back
  820 VDU 23,27,0,0   :REM select the tranparency box
  830 VDU 23,27,3,x%;y%; :REM movebox to new location
  840 ENDPROC
  850 DEFPROClegend
  860 R%=60
  870 FOR Q=1 TO 9
  880   VDU23,27,0,Q :REM COLUMN 1
  890   VDU23,27,3,247;R%;
  900   VDU23,27,0,Q+9 :REM COLUMN 2
  910   VDU23,27,3,277;R%;
  920   R%=R%+20
  930 NEXT
  940 COLOUR8:D%=735
  950 VDU 5 :REM ALLOW TEXT IN GFX
  960 FOR H=1 TO 9:MOVE 1060,D%:PRINT;H:D%=D%-84:NEXT
  970 MOVE1188,735:P."Q":MOVE1188,651:P."W":MOVE1188,567:P."E":MOVE1188,483:P."R":MOVE1188,399:P."T"
  980 MOVE1188,315:P."Y":MOVE1188,231:P."U":MOVE1188,147:P."I":MOVE1188,63:P."O"
  990 VDU 4 :REM STOP TEXT IN GFX
 1000 COLOUR5:P.TAB(39,8);:VDU243:P.TAB(39,10);"M":P.TAB(39,12);"A":P.TAB(39,14);"P":P.TAB(39,18);"M"
 1010 P.TAB(39,20);"A":P.TAB(39,22);"K":P.TAB(39,24);"E":P.TAB(39,26);"R":P.TAB(39,28);:VDU244
 1020 COLOUR1:PRINTTAB(35,0);:VDU240,243,244,242:COLOUR2:PRINTTAB(30,0);"Move"
 1030 PROCshort(30,1,"","L","oad")
 1040 PROCshort(35,1,"","S","ave")
 1050 PROCshort(30,2,"e","X","it")
 1060 PROCshort(35,2,"ra","N","d")
 1070 PROCshort(30,3,"","Z","one")
 1080 PROCshort(30,4,"stic","K","y")
 1090 ENDPROC
 1100 DEFPROClay(H%)
 1110 sticky%=H% :REM set the sticky value
 1120 PRINTTAB(31,6);SPC(9)  :REM clear dialog box
 1130 COLOUR15:PRINTTAB(32,6);"Tile:";H%
 1140 VDU 23,27,0,H%   :REM select the box
 1150 VDU 23,27,3,x%;y%; :REM movebox to new location
 1160 XCORD%=x%MOD15 : REM Clever maths. Finds XCORD% by MODULUS 15.
 1170 YCORD%=y%DIV15 : REM Clever maths. Finds YCORD% by DIV 15.
 1180 the_map%(YCORD%,XCORD%)=H%
 1190 ENDPROC
 1200 DEFPROCshort(x,y,pre$,hi$,post$)
 1210 PRINTTAB(x,y);:C.2:P.pre$;:C.1:P.hi$;:C.2:P.post$;
 1220 ENDPROC
 1230 DEFPROCloadbitmaps
 1240 C. 15
 1250 FOR L%=18 TO 0 STEP -1
 1260   PROCload_bitmap(STR$(L%),L%,16,16)
 1270 NEXT
 1280 COLOUR10:PRINTTAB(15,18);"GO!"
 1290 ENDPROC
 1300 DEFPROCload_bitmap(F$,N%,W%,H%)
 1310 IF N%=9 THEN PRINTTAB(15,18);"  "
 1320 PRINTTAB(15,18);F$; :REM SHOW A COUNTDOWN
 1330 OSCLI("LOAD " + tilespack$ + "/" + F$ + ".rgb" + " " + STR$(MB%+graphics))
 1340 VDU 23,27,0,N% : REM SELECT SPRITE n (equating to buffer ID numbered 64000+n).
 1350 VDU 23,27,1,W%;H%; : REM LOAD COLOUR BITMAP DATA INTO CURRENT SPRITE.
 1360 FOR I%=0 TO (W%*H%*4)-1 STEP 4 : REM LOOP 16x16x3 EACH PIXEL R,G,B,A
 1370   r% = ?(graphics+I%+0) : REM RED DATA.
 1380   g% = ?(graphics+I%+1) : REM GREEN DATA.
 1390   b% = ?(graphics+I%+2) : REM BLUE DATA.
 1400   a% = ?(graphics+I%+3) : REM ALPHA (TRANSPARENCY)
 1410   VDU r%, g%, b%, a%
 1420 NEXT
 1430 ENDPROC
 1440 DEFPROCshowmap
 1450 REM outputs each map location and moves 16 pixels to next. End of each line resets location
 1460 XLOC%=0:YLOC%=0
 1470 FOR j=0TO14
 1480   FOR i=0TO14
 1490     g%=the_map%(i,j)
 1500     VDU 23,27,0,g% : REM select the specified bitmap
 1510     VDU 23,27,3,YLOC%;XLOC%;   : REM displays the bitmap
 1520     XLOC%=XLOC%+16 :REM update the X location to move to the right
 1530     IF i=14 THEN YLOC%=YLOC%+16:XLOC%=0 :REM at end of row move to start next line and down
 1540   NEXT
 1550 NEXT
 1560 PROCnewcursor :REM always reshow the cursor on a showmap
 1570 ENDPROC
 1580 DEFPROCrandommap
 1590 FOR i=0TOXSIZE%:FOR j=0TOYSIZE%:the_map%(i,j)=RND(18):NEXT:NEXT
 1600 PROCshowmap
 1610 ENDPROC
 1620 DEFPROCsavemap
 1630 PROCborder
 1640 INPUT TAB(7,14) "Save map filename?",TAB(7,16) FILENAME$
 1650 A=OPENOUT FILENAME$
 1660 PRINT#A,XSIZE%:PRINT#A,YSIZE%
 1670 FOR i=0TO14:FOR j=0TO14:PRINT#A,the_map%(i,j):NEXT:NEXT
 1680 CLOSE#A
 1690 PRINTTAB(7,18);"Press any key...":temp=GET
 1700 PROCrefresh
 1710 ENDPROC
 1720 DEFPROCloadmap
 1730 PROCborder
 1740 C. 15:INPUT TAB(7,14) "Load map filename?",TAB(7,16) FILENAME$
 1750 fnum=OPENIN FILENAME$
 1760 IF fnum=0 THEN PRINTTAB(7,14);"Filename NOT loaded":GOTO1840
 1770 INPUT#fnum,XIMP% :REM Read X map size
 1780 INPUT#fnum,YIMP% :REM Read Y map size
 1790 FOR i=0TOXIMP% :REM read map based on defined size
 1800   FOR j=0TOYIMP%
 1810     INPUT#fnum,the_map%(i,j) :REM save to map
 1820   NEXT
 1830 NEXT
 1840 CLOSE#fnum
 1850 PRINTTAB(7,18);"Press any key...":temp=GET
 1860 PROCrefresh
 1870 ENDPROC
 1880 DEFPROCgreenstart
 1890 FOR i=0TO14:FOR j=0TO14:the_map%(i,j)=1:NEXT:NEXT
 1900 ENDPROC
 1910 DEFPROCsetupChars
 1920 VDU 23,240,0,&20,&40,&FF,&40,&20,0,0 : REM left arrow
 1930 VDU 23,242,0,&04,&02,&FF,&02,&04,0,0 : REM right
 1940 VDU 23,243,&10,&38,&54,&10,&10,&10,&10,0 : REM up
 1950 VDU 23,244,&10,&10,&10,&10,&54,&38,&10,0 : REM down
 1960 VDU 23,230,255,255,255,255,255,255,255,255  :REM block
 1970 ENDPROC
 1980 DEFPROCzoneload
 1990 PROCborder
 2000 C. 15:INPUT TAB(7,14) "Load tile pack?",TAB(7,15) "(enter dir name)", TAB(7,17) tilespack$ :REM ADD A CHECK OR NOTE WHEN NOT LOADED
 2010 PROCreload
 2020 ENDPROC
 2030 DEFPROCborder
 2040 FOR G=12 TO 20 STEP 1:COLOUR0:PRINTTAB(6,G);SPC(20):COLOUR6:PRINTTAB(5,G);CHR$230:PRINTTAB(26,G);CHR$230:NEXT
 2050 COLOUR6:PRINTTAB(6,12);STRING$(20,CHR$230):PRINTTAB(5,20);STRING$(21,CHR$230)
 2060 ENDPROC
 2070 DEFPROCcheckexit
 2080 PROCborder
 2090 C. 15:PRINTTAB(7,14);"Quit:Are you sure?":PRINTTAB(7,16);"Press Y to confirm"
 2100 N$=GET$
 2110 IF N$="y" OR N$="Y" THEN GOTO 2270
 2120 PROCshowmap
 2130 ENDPROC
 2140 DEFPROCrefresh
 2150 CLS:PROClegend:PROCshowmap
 2160 ENDPROC
 2170 DEFPROCreload
 2180 PROCloadbitmaps:PROCrefresh:PROCpenflow
 2190 ENDPROC
 2200 DEFPROCpenflow
 2210 IF ink%=0 THEN ink%=1:COLOUR10:PRINTTAB(37,4);"ON ":GOTO2230
 2220 ink%=0:COLOUR1:PRINTTAB(37,4);"OFF" :REM
 2230 ENDPROC
 2240 DEFPROCinkcheck
 2250 IF ink%=1 THEN PROClay(sticky%)
 2260 ENDPROC
 2270 MODE8:P."GOODBYE!":END
