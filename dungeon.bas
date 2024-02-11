   10 REM MapMaker V1.1 - Make, Modify, Load and Save a bitmap game field
   20 REM Supplementary game example : Dungeon Crawler
   30 REM by 8BitVino
   40 REM https://github.com/8BitVino/mapmaker
   50 REM with code snippets from The-8bit-Noob & robogeek42
   60 MB%=&40000 : REM MEMORY BANK &40000.
   70 DIM graphics 1024
   80 DIM the_map%(14,14)
   90 XSIZE%=14:YSIZE%=14:x%=112:y%=112:p%=0:custom%=0:tilespack$="tiles":FILENAME$="dungeon.map"
  100 VDU 23,27,16 : REM CLEAR ALL SPRITE DATA.
  110 MODE 8 : REM SET SCREEN MODE.
  120 VDU 23,1,0 : REM DISABLE CURSOR.
  130 PROCsetupChars:PROCloadbitmaps:PROCloadmap:PROCrefresh
  140 VDU 23,27,0,0  :REM show cursor in middle at start
  150 VDU 23,27,3,x%;y%;
  160 ON ERROR PROCshowmap:GOTO170 :REM used to stop Escape key from stopping program and refreshes instead
  170 A%=INKEY(0) : REM GET KEYBOARD INPUT FROM PLAYER.
  180 IF A%=21 THEN PROCclearmove:PROCmoveright:PROCnewcursor :REM MOVE SPRITE RIGHT.
  190 IF A%=8 THEN PROCclearmove:PROCmoveleft:PROCnewcursor :REM MOVE SPRITE LEFT.
  200 IF A%=10 THEN PROCclearmove:PROCmoveup:PROCnewcursor :REM MOVE SPRITE DOWN.
  210 IF A%=11 THEN PROCclearmove:PROCmovedown:PROCnewcursor :REM MOVE SPRITE UP.
  220 IF A%=32 THEN PROCmapswap
  230 IF A%=120 OR A%=88 THEN PROCcheckexit :REM (X) Exit
  240 GOTO 170
  250 ENDPROC
  260 DEFPROCclearmove
  270 XCORD%=x%MOD15 : REM Clever maths. Finds XCORD% by doing array value MODULUS 15.
  280 YCORD%=y%DIV15 : REM Clever maths. Finds YCORD% by doing array value DIV by 15.
  290 w%=the_map%(YCORD%,XCORD%) :REM find the object to restore. Why is X Y reversed?
  300 PROCclearcell
  310 VDU 23,27,0,w%   :REM select the graphic
  320 VDU 23,27,3,x%;y%; :REM paste sprite in location
  330 ENDPROC
  340 DEFPROCnewcursor :REM put the original bitmap back
  350 LOCAL XXCORD%,YYCORD%
  360 XXCORD%=x%MOD15 : REM Clever maths. Finds XCORD% by MODULUS 15.
  370 YYCORD%=y%DIV15 : REM Clever maths. Finds YCORD% by DIV 15.
  380 H%=the_map%(YYCORD%,XXCORD%)
  390 VDU 23,27,0,0   :REM select the tranparency box
  400 VDU 23,27,3,x%;y%; :REM paste sprite in location
  410 ENDPROC
  420 DEFPROCmoveright
  430 IF x%=224 THEN x%=0:GOTO 450 :REM far right boundary
  440 x%=x%+16
  450 ENDPROC
  460 DEFPROCmoveleft
  470 IF x%=0 THEN x%=224:GOTO 490 :REM far left boundary
  480 x%=x%-16
  490 ENDPROC
  500 DEFPROCmoveup
  510 IF y%=224 THEN y%=0:GOTO 530 :REM bottom boundary
  520 y%=y%+16
  530 ENDPROC
  540 DEFPROCmovedown
  550 IF y%=0 THEN y%=224:GOTO 570 :REM top boundary
  560 y%=y%-16
  570 ENDPROC
  580 DEFPROClegend
  590 C.5:PRINTTAB(31,2);"DUNGEON":PRINTTAB(32,4);"CRAWLER":
  600 C.1:PRINTTAB(31,27);"X to Exit"
  610 PRINTTAB(31,15);"Spacebar":PRINTTAB(31,16);"next map"
  620 COLOUR1:PRINTTAB(36,13);:VDU240,243,244,242:COLOUR2:PRINTTAB(31,13);"Move"
  630
  640 ENDPROC
  650 DEFPROCloadbitmaps
  660 PROCload_bitmap("0","0",0,16,16) :REM LOAD THE TRANSPARENT CUBE FROM DIR 0
  670 PROCload_bitmap("0","1",1,16,16) :REM LOAD THE BLACK TILEFROM DIR 0
  680 PRINTTAB(7,15);"Loading Dungeon Crawler..."
  690 FOR R%=1 TO 5
  700   FOR L%=0 TO 9
  710     p%=R%*10:p%=p%+L% :REM POPULATES SLOT
  720     PROCload_bitmap(STR$(R%),STR$(L%),p%,16,16) :REM directory, filename, sprite number
  730   NEXT
  740 NEXT
  750 ENDPROC
  760 DEFPROCload_bitmap(D$,F$,N%,W%,H%)
  770 OSCLI("LOAD " + D$ + "/" + F$ + ".rgb" + " " + STR$(MB%+graphics))
  780 VDU 23,27,0,N% : REM SELECT SPRITE n (equating to buffer ID numbered 64000+n).
  790 VDU 23,27,1,W%;H%; : REM LOAD COLOUR BITMAP DATA INTO CURRENT SPRITE.
  800 FOR I%=0 TO (W%*H%*4)-1 STEP 4 : REM LOOP 16x16x3 EACH PIXEL R,G,B,A
  810   r% = ?(graphics+I%+0) : REM RED DATA.
  820   g% = ?(graphics+I%+1) : REM GREEN DATA.
  830   b% = ?(graphics+I%+2) : REM BLUE DATA.
  840   a% = ?(graphics+I%+3) : REM ALPHA (TRANSPARENCY)
  850   VDU r%, g%, b%, a%
  860 NEXT
  870 ENDPROC
  880 DEFPROCshowmap
  890 LOCAL XLOC%,YLOC%
  900 FOR j=0TOYSIZE%
  910   FOR i=0TOXSIZE%
  920     g%=the_map%(i,j)
  930     VDU 23,27,0,g% : REM select the specified bitmap
  940     VDU 23,27,3,YLOC%;XLOC%;   : REM displays the bitmap
  950     XLOC%=XLOC%+16 :REM update the X location to move to the right
  960     IF i=14 THEN YLOC%=YLOC%+16:XLOC%=0 :REM at end of row move to start next line and down
  970   NEXT
  980 NEXT
  990 PROCnewcursor :REM always reshow the cursor on a showmap
 1000 ENDPROC
 1010 DEFPROCloadmap
 1020 LOCAL XIMP%,YIMP%
 1030 fnum=OPENIN FILENAME$
 1040 IF fnum=0 THEN PRINTTAB(7,14);"Filename NOT loaded":GOTO1140
 1050 INPUT#fnum,XIMP% :REM Read X map size
 1060 INPUT#fnum,YIMP% :REM Read Y map size
 1070 INPUT#fnum,decks% :REM load the number of decks in use
 1080 INPUT#fnum,custom% :REM read number of custom tile slots
 1090 FOR i=0TOXIMP% :REM read map based on defined size
 1100   FOR j=0TOYIMP%
 1110     INPUT#fnum,the_map%(i,j) :REM save to map
 1120   NEXT
 1130 NEXT
 1140 CLOSE#fnum
 1150 ENDPROC
 1160 DEFPROCsetupChars
 1170 VDU 23,240,0,&20,&40,&FF,&40,&20,0,0 : REM left arrow
 1180 VDU 23,242,0,&04,&02,&FF,&02,&04,0,0 : REM right
 1190 VDU 23,243,&10,&38,&54,&10,&10,&10,&10,0 : REM up
 1200 VDU 23,244,&10,&10,&10,&10,&54,&38,&10,0 : REM down
 1210 VDU 23,230,255,255,255,255,255,255,255,255  :REM block
 1220 ENDPROC
 1230 DEFPROCborder
 1240 FOR G=12 TO 20 STEP 1:COLOUR0:PRINTTAB(5,G);SPC(22):COLOUR6:PRINTTAB(4,G);CHR$230:PRINTTAB(27,G);CHR$230:NEXT
 1250 COLOUR6:PRINTTAB(5,12);STRING$(22,CHR$230):PRINTTAB(5,20);STRING$(22,CHR$230)
 1260 ENDPROC
 1270 DEFPROCcheckexit
 1280 PROCborder
 1290 C. 15:PRINTTAB(7,14);"Quit:Are you sure?":PRINTTAB(7,16);"Press Y to confirm"
 1300 N$=GET$
 1310 IF N$="y" OR N$="Y" THEN GOTO 1460
 1320 PROCshowmap
 1330 ENDPROC
 1340 DEFPROCrefresh
 1350 CLS:PROClegend:PROCshowmap
 1360 ENDPROC
 1370 DEFPROCclearcell
 1380 VDU 23,27,0,1 :REM CLEAR WITH BLACK FRAME
 1390 VDU 23,27,3,x%;y%; :REM PASTE BLACK FRAME
 1400 ENDPROC
 1410 DEFPROCmapswap
 1420 IF FILENAME$="dungeon.map" THEN FILENAME$="dungeon2.map":GOTO1440
 1430 IF FILENAME$="dungeon2.map" THEN FILENAME$="dungeon.map"
 1440 PROCloadmap:PROCrefresh
 1450 ENDPROC
 1460 CLS:P."GOODBYE!":END
