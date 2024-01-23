   10 REM Game example for MapMaker. Make, Modify, Load and Save a bitmap game field
   20 REM by 8BitVino. PRE-RELEASE 1
   30 REM https://github.com/8BitVino/mapmaker
   40 REM with code snippets from The-8bit-Noob & robogeek42
   50 MB%=&40000 : REM MEMORY BANK &40000.
   60 DIM graphics 1024 : REM ARRAY FOR PIXELS ?.
   70 DIM the_map%(14,14)
   80 MYMAP$="example.map" :REM PUT YOUR OWN CUSTOM MAP HERE
   90 tilespack$="tiles"   :REM changes for your custom tiles directory
  100 XSIZE%=14:YSIZE%=14:XIMP%=0:YIMP%=0:x%=112:y%=112
  110 VDU 23,27,16 : REM CLEAR ALL SPRITE DATA.
  120 MODE 8 : REM SET SCREEN MODE.
  130 CLS : REM CLEAR THE SCREEN.
  140 VDU 23,1,0 : REM DISABLE CURSOR.
  150 PROCloadbitmaps
  160 PROCloadmap
  170 CLS:PROClegend
  180 PROCshowmap
  190 VDU 23,27,0,0  :REM show cursor in middle at start
  200 VDU 23,27,3,x%;y%;
  210 ON ERROR PROCshowmap:GOTO220 :REM used to stop Escape key from stopping program and refreshes instead
  220 A%=INKEY(0) : REM GET KEYBOARD INPUT FROM PLAYER.
  230 IF A%=21 THEN PROCclearmove:PROCmoveright:PROCnewcursor :REM MOVE SPRITE RIGHT.
  240 IF A%=8 THEN PROCclearmove:PROCmoveleft:PROCnewcursor :REM MOVE SPRITE LEFT.
  250 IF A%=10 THEN PROCclearmove:PROCmoveup:PROCnewcursor :REM MOVE SPRITE DOWN.
  260 IF A%=11 THEN PROCclearmove:PROCmovedown:PROCnewcursor :REM MOVE SPRITE UP.
  270 IF A%=120 OR A%=88 THEN PROCcheckexit :REM (X) Exit
  280 GOTO 220
  290 ENDPROC
  300 DEFPROCclearmove
  310 XCORD%=x%MOD15 : REM Clever maths. Finds XCORD% by doing array value MODULUS 15.
  320 YCORD%=y%DIV15 : REM Clever maths. Finds YCORD% by doing array value DIV by 15.
  330 w%=the_map%(YCORD%,XCORD%) :REM find the object to restore. Why is X Y reversed?
  340 VDU 23,27,0,w%   :REM select the graphic
  350 VDU 23,27,3,x%;y%; :REM movebox to new location
  360 ENDPROC
  370 DEFPROCmoveright
  380 IF x%=224 THEN x%=0:GOTO 400 :REM far right boundary
  390 x%=x%+16
  400 ENDPROC
  410 DEFPROCmoveleft
  420 IF x%=0 THEN x%=224:GOTO 440 :REM far left boundary
  430 x%=x%-16
  440 ENDPROC
  450 DEFPROCmoveup
  460 IF y%=224 THEN y%=0:GOTO 480 :REM bottom boundary
  470 y%=y%+16
  480 ENDPROC
  490 DEFPROCmovedown
  500 IF y%=0 THEN y%=224:GOTO 520 :REM top boundary
  510 y%=y%-16
  520 ENDPROC
  530 DEFPROCnewcursor :REM put the original bitmap back
  540 VDU 23,27,0,0   :REM select the tranparency box
  550 VDU 23,27,3,x%;y%; :REM movebox to new location
  560 ENDPROC
  570 DEFPROClegend
  580 PRINTTAB(31,14);"X = eXit"
  590 ENDPROC
  600 DEFPROCloadbitmaps
  610 PRINTTAB(10,15);"Loading bitmaps...."
  620 FOR L%=18 TO 0 STEP -1
  630   PROCload_bitmap(STR$(L%),L%,16,16)
  640 NEXT
  650 COLOUR10:PRINTTAB(15,18);"GO!"
  660 ENDPROC
  670 DEFPROCload_bitmap(F$,N%,W%,H%)
  680 IF N%=9 THEN PRINTTAB(15,18);"  "
  690 PRINTTAB(15,18);F$; :REM SHOW A COUNTDOWN
  700 OSCLI("LOAD " + tilespack$ + "/" + F$ + ".rgb" + " " + STR$(MB%+graphics))
  710 VDU 23,27,0,N% : REM SELECT SPRITE n (equating to buffer ID numbered 64000+n).
  720 VDU 23,27,1,W%;H%; : REM LOAD COLOUR BITMAP DATA INTO CURRENT SPRITE.
  730 FOR I%=0 TO (W%*H%*4)-1 STEP 4 : REM LOOP 16x16x3 EACH PIXEL R,G,B,A
  740   r% = ?(graphics+I%+0) : REM RED DATA.
  750   g% = ?(graphics+I%+1) : REM GREEN DATA.
  760   b% = ?(graphics+I%+2) : REM BLUE DATA.
  770   a% = ?(graphics+I%+3) : REM ALPHA (TRANSPARENCY)
  780   VDU r%, g%, b%, a%
  790 NEXT
  800 ENDPROC
  810 DEFPROCshowmap
  820 REM outputs each map location and moves 16 pixels to next. End of each line resets location
  830 XLOC%=0:YLOC%=0
  840 FOR j=0TO14
  850   FOR i=0TO14
  860     g%=the_map%(i,j)
  870     VDU 23,27,0,g% : REM select the specified bitmap
  880     VDU 23,27,3,YLOC%;XLOC%;   : REM displays the bitmap
  890     XLOC%=XLOC%+16 :REM update the X location to move to the right
  900     IF i=14 THEN YLOC%=YLOC%+16:XLOC%=0 :REM at end of row move to start next line and down
  910   NEXT
  920 NEXT
  930 PROCnewcursor :REM always reshow the cursor on a showmap
  940 ENDPROC
  950 DEFPROCloadmap
  960 fnum=OPENIN MYMAP$
  970 IF fnum=0 THEN PRINTTAB(7,14);"Filename NOT loaded": GOTO1050
  980 INPUT#fnum,XIMP% :REM Read X map size
  990 INPUT#fnum,YIMP% :REM Read Y map size
 1000 FOR i=0TOXIMP% :REM read map based on defined size
 1010   FOR j=0TOYIMP%
 1020     INPUT#fnum,the_map%(i,j)  :REM save to map
 1030   NEXT
 1040 NEXT
 1050 CLOSE#fnum
 1060 ENDPROC
 1070 DEFPROCcheckexit
 1080 PRINTTAB(7,14);"Quit:Are you sure?"
 1090 PRINTTAB(7,16);"Press Y to confirm"
 1100 N$=GET$
 1110 IF N$="y" OR N$="Y" THEN GOTO 1140
 1120 PROCshowmap
 1130 ENDPROC
 1140 MODE8:P."GOODBYE!":END
