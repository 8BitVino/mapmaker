   10 REM Maptool - A supplementary tool for displaying map parameters
   20 REM Included in MapMaker. Make, Modify, Load and Save a bitmap game field
   30 REM by 8BitVino. v1.1 
   40 REM https://github.com/8BitVino/mapmaker
   50 DIM the_map%(14,14)
   60 MODE2
   70 PRINT"Maptool V1.1: information on your saved MapMaker maps":P.
   80 PROCloadmap
   90 PROCdisplaymap
  100 GOTO80
  110 DEFPROCloadmap
  120 P.:INPUT "Which map (enter filename)",FILENAME$
  130 fnum=OPENIN FILENAME$
  140 IF fnum=0 THEN PRINT"Filename NOT loaded":CLOSE#fnum:GOTO120
  150 INPUT#fnum,XIMP%
  160 INPUT#fnum,YIMP%
  170 INPUT#fnum,decks%
  180 INPUT#fnum,custom%
  190 FOR i=0TOXIMP%
  200   FOR j=0TOYIMP%
  210     INPUT#fnum,the_map%(i,j)
  220   NEXT
  230 NEXT
  240 IF custom%>0 THEN PROCcustomload
  250 PRINT"Total zones:";decks%:P.
  260 PRINT"Custom zones:";custom%:P.
  270 CLOSE#fnum
  280 ENDPROC
  290 DEFPROCdisplaymap
  300 P.:PRINT"Mapsize:";XIMP%;"x by ";YIMP%;"y":P.
  310 FOR i=0TOXIMP% :REM read map based on defined size
  320   FOR j=0TOYIMP%
  330     LOCATION%=the_map%(i,j)
  340     IF LOCATION%<10 THEN PRINT;" ";
  350     PRINT;LOCATION%;" ";
  360     IF j=14 THEN PRINT"":P.
  370   NEXT
  380 NEXT
  390 ENDPROC
  400 DEFPROCcustomload
  410 P.:PRINT"Custom slots assigned directories":P.
  420 FOR G%=0 TO custom%-1  :REM loop for number of saved custom
  430   INPUT#fnum,clpack$
  440   INPUT#fnum,clslot%
  450   PRINT"Slot:";clslot%/10;" Dir:";clpack$:P.
  460 NEXT
  470 ENDPROC
  480 END
