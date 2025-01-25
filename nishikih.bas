RANDOMIZE TIMER

TITLE_SCREEN:

score~& = 0
nishiki_len% = 6
enemy_len% = 4
stage~& = 0

CLS
COLOR 15

LOCATE 4, 22: COLOR 2: PRINT "          #                   #"
LOCATE 5, 22: COLOR 5: PRINT "   #     #            #    #######"
LOCATE 6, 22: COLOR 2: PRINT " #####  #######       #    #     #"
LOCATE 7, 22: COLOR 5: PRINT "#  #  # #     #    ####### # #   #"
LOCATE 8, 22: COLOR 2: PRINT "   #    #######    #  #  #   #"
LOCATE 9, 22: COLOR 5: PRINT "####### #     #    #  #  #   #"
LOCATE 10, 22: COLOR 2: PRINT "   #    #######    #######   #  ##"
LOCATE 11, 22: COLOR 5: PRINT "#######    #          #      ###"
LOCATE 12, 22: COLOR 2: PRINT "   #    #######       #      #"
LOCATE 13, 22: COLOR 5: PRINT "#  #  # #  #  #       # #    #"
LOCATE 14, 22: COLOR 2: PRINT " # ###  #  #  #       ####   #   #"
LOCATE 15, 22: COLOR 5: PRINT " ##     #  #  #    ###   #   #   #"
LOCATE 16, 22: COLOR 2: PRINT "#          #                 #####"
LOCATE 18, 25: COLOR 15: PRINT "-- Invasion of NISHIKIHEBI --"
LOCATE 20, 34: PRINT "Hit any key."
_DISPLAY

DO
    c$ = INKEY$
    _LIMIT 30
LOOP UNTIL c$ <> ""
IF c$ = CHR$(27) THEN END

INIT_GAME:

nishiki_len% = nishiki_len% + 1
IF (stage~& MOD 4 = 0) AND enemy_len% < 40 THEN
    enemy_len% = enemy_len% + 1
    nishiki_len% = nishiki_len% - 3
END IF
stage~& = stage~& + 1

REDIM x%(nishiki_len%)
REDIM y%(nishiki_len%)
FOR i% = 1 TO nishiki_len%
    x%(i%) = 1
    y%(i%) = 1
NEXT i%

dead_count% = 0
clear_count% = 0
frame~& = 0
earned_score~& = 0

REDIM e_x%(enemy_len%)
REDIM e_y%(enemy_len%)
REDIM e_d%(enemy_len%)
FOR i% = 1 TO enemy_len%
    e_x%(i%) = INT(80 * (2 * i% - 1) / (2 * enemy_len%))
    e_y%(i%) = 23
    e_d%(i%) = 0
NEXT i%

DO
    CLS

    ' Nishikihebi
    c$ = INKEY$
    IF c$ = CHR$(27) THEN END
    IF c$ <> "" AND dead_count% = 0 AND clear_count% = 0 THEN
        FOR i% = nishiki_len% TO 2 STEP -1
            x%(i%) = x%(i% - 1)
            y%(i%) = y%(i% - 1)
        NEXT i%
        IF y%(1) MOD 4 = 1 THEN
            IF x%(1) = 80 THEN
                y%(1) = y%(1) + 1
            ELSE
                x%(1) = x%(1) + 1
            END IF
        ELSEIF y%(1) MOD 4 = 3 THEN
            IF x%(1) = 1 THEN
                y%(1) = y%(1) + 1
            ELSE
                x%(1) = x%(1) - 1
            END IF
        ELSE
            y%(1) = y%(1) + 1
        END IF
        score~& = score~& + (RND * stage~&)
    END IF

    ' Enemy
    FOR i% = 1 TO enemy_len%
        IF e_y%(i%) > 0 THEN e_y%(i%) = e_y%(i%) - 1
        IF e_y%(i%) = 0 AND e_d%(i%) = 0 THEN
            e_y%(i%) = 23 + INT(RND * 50 + RND * 50)
        END IF
    NEXT i%

    ' Death and hit check
    IF dead_count% > 0 THEN
        dead_count% = dead_count% + 1
    ELSE
        FOR i% = 1 TO nishiki_len%
            FOR j% = 1 TO enemy_len%
                IF x%(i%) = e_x%(j%) THEN
                    IF y%(i%) = e_y%(j%) AND y%(i%) < 23 THEN
                        dead_count% = 1
                    ELSEIF y%(1) = 23 THEN
                        e_d%(j%) = 1
                        IF e_y%(j%) > 23 THEN e_y%(j%) = 0
                    END IF
                END IF
            NEXT j%
        NEXT i%
    END IF

    ' Win
    IF x%(1) = 1 AND y%(1) = 23 THEN
        clear_count% = clear_count% + 1
        IF clear_count% = 1 THEN
            earned_score~& = stage~& * 10000000 / frame~&
            score~& = score~& + earned_score~&
        END IF
    END IF

    ' Display
    FOR i% = nishiki_len% TO 1 STEP -1
        LOCATE y%(i%), x%(i%)
        IF i% = 1 THEN
            IF dead_count% = 0 THEN
                COLOR 15: PRINT "@"
            ELSEIF dead_count% < 5 THEN
                COLOR 6: PRINT "#"
            ELSEIF dead_count% < 10 THEN
                COLOR 4: PRINT "+"
            END IF
        ELSE
            IF dead_count% = 0 THEN
                COLOR 7: PRINT "o"
            ELSEIF dead_count% < 5 THEN
                COLOR 6: PRINT "#"
            ELSEIF dead_count% < 10 THEN
                COLOR 4: PRINT "+"
            END IF
        END IF
    NEXT i%

    FOR i% = 1 TO enemy_len%
        LOCATE 23, e_x%(i%)
        IF e_d%(i%) = 0 THEN
            COLOR 4: PRINT "A"
        ELSE
            COLOR 1: PRINT "#"
        END IF
        IF 1 <= e_y%(i%) AND e_y%(i%) < 23 THEN
            LOCATE e_y%(i%), e_x%(i%)
            COLOR 3: PRINT "|"
        END IF
    NEXT i%

    IF score~& = 0 THEN
        COLOR 15
        LOCATE 10, 20: PRINT "Hit any key to move NISHIKIHEBI."
        LOCATE 12, 20: PRINT "Hit ESC key to quit game."
    END IF

    IF clear_count% >= 1 THEN
        COLOR 15
        LOCATE 10, 20: COLOR 2: PRINT " ##  #    ####  ##  ###"
        LOCATE 11, 20: COLOR 5: PRINT "#  # #    #    #  # #  #"
        LOCATE 12, 20: COLOR 2: PRINT "#    #    #### #### ###"
        LOCATE 13, 20: COLOR 5: PRINT "#  # #    #    #  # # #"
        LOCATE 14, 20: COLOR 2: PRINT " ##  #### #### #  # #  #"
        IF clear_count% >= 10 THEN
            LOCATE 17, 40: COLOR 15: PRINT "Clear bonus is "; earned_score~&
        END IF
    ELSEIF dead_count% >= 10 THEN
        COLOR 15
        LOCATE 10, 20: COLOR 2: PRINT " ###  ##  #   # ####  ##  #   # #### ###"
        LOCATE 11, 20: COLOR 5: PRINT "#    #  # ## ## #    #  # #   # #    #  #"
        LOCATE 12, 20: COLOR 2: PRINT "# ## #### # # # #### #  #  # #  #### ###"
        LOCATE 13, 20: COLOR 5: PRINT "#  # #  # # # # #    #  #  # #  #    # #"
        LOCATE 14, 20: COLOR 2: PRINT " ##  #  # #   # ####  ##    #   #### #  #"
        LOCATE 17, 40: COLOR 15: PRINT "Your final score is "; score~&
    END IF

    frame~& = frame~& + 1
    _DISPLAY
    _LIMIT 30
LOOP UNTIL dead_count% = 70 OR clear_count% = 70

IF clear_count% = 70 THEN GOTO INIT_GAME
IF dead_count% = 70 THEN GOTO TITLE_SCREEN

END
