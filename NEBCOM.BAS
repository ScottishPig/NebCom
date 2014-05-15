DECLARE FUNCTION getNumAiShips! ()
DECLARE FUNCTION getNumPlayerShips! ()
DECLARE SUB buildScreen ()
DECLARE SUB newGame ()
DECLARE SUB drawMainScreen ()

' Data stuff
DIM SHARED playerBank AS INTEGER
DIM SHARED aiBank AS INTEGER

TYPE ship
   armor AS SINGLE
   title AS STRING * 10
   x AS SINGLE
   y AS SINGLE
   minDamage AS SINGLE
   randDamage AS SINGLE
   speed AS SINGLE
END TYPE

DIM SHARED playerArmada(50) AS ship
DIM SHARED aiArmada(50) AS ship


' Basic Setup Stuff----------------
SCREEN 1   ' 320x200 40x25
newGame
drawMainScreen
'----------------------------------



' KEY LOOP
DO
k$ = INKEY$


IF UCASE$(k$) = "B" THEN
    buildScreen
END IF


'
' Quit Loop:
'
IF UCASE$(k$) = "Q" THEN
LOCATE 13, 4
PRINT "Do you really want to quit? (Y/N)"
quitloop = 0
WHILE quitloop = 0
    k$ = INKEY$
    IF UCASE$(k$) = "Y" THEN
        END
    ELSEIF UCASE$(k$) = "N" THEN
        ' TODO: Add restart code here.
        quitloop = 1
        drawMainScreen
    END IF
WEND
END IF




LOOP

SUB buildScreen

' Screen Setup --------------------
CLS
COLOR 0
LOCATE 2, 2
LINE (6, 7)-(313, 193), 1, B
PRINT "Build Ship"
'----------------------------------


LOCATE 23, 3
PRINT playerBank; " build points remain."

LOCATE 4, 3
INPUT "Ship's name: ", title$

LOCATE 6, 3
PRINT "Armor"
LOCATE 7, 5
INPUT "(1 pt/unit): ", armor

LOCATE 8, 3
PRINT "Speed"
LOCATE 9, 5
INPUT "(0.5 pt/unit): ", speed


LOCATE 10, 3
PRINT "Base Damage"
LOCATE 11, 5
INPUT "(1 pt/unit): ", dmg

LOCATE 12, 3
PRINT "Additional Damage"
LOCATE 13, 5
INPUT "(0.5 pt/unit): ", vardmg


totalCost = armor + dmg + (vardmg / 2) + (speed / 2)

LOCATE 18, 5
PRINT "Total cost: "; totalCost
LOCATE 19, 5
PRINT "Total bank: "

IF totalCost > playerBank THEN
    COLOR 2
    LOCATE 19, 17
    PRINT playerBank; "Insufficient funds!"
    COLOR 0
    LOCATE 20, 5
    PRINT "Press any key."
    WHILE INKEY$ = ""
    WEND
    EXIT SUB
ELSE
    LOCATE 19, 20
    PRINT playerBank; "OK!"
    LOCATE 20, 5
    PRINT "Press any key."
    WHILE INKEY$ = ""
    WEND
END IF

' Validate and confirm new ship!

' Screen Setup --------------------
CLS
COLOR 0
LOCATE 2, 2
LINE (6, 7)-(313, 193), 1, B
PRINT "Confirm Ship"
'----------------------------------



' Don't worry, dearies... QB doesn't give a single care
' about data validation, so neither do I. ;-)
title$ = UCASE$(LEFT$(title$, 1)) + LCASE$(MID$(title$, 2))

LOCATE 4, 5
PRINT "Ship name: "; title$
LOCATE 5, 5
PRINT "Armor: "; armor
LOCATE 6, 5
PRINT "Speed: "; speed
LOCATE 7, 5
PRINT "Damage (base): "; dmg
LOCATE 8, 5
PRINT "Damage (addl.): "; vardmg

LOCATE 10, 5
PRINT "After construction, you'll"
LOCATE 11, 5
PRINT "have "; playerBank - totalCost; " build points left."

LOCATE 14, 5
PRINT "Does this look good (Y/N)?"

k$ = ""
WHILE k$ <> "Y" AND k$ <> "N"
k$ = UCASE$(INKEY$)
WEND


IF k$ = "Y" THEN
    q = getNumPlayerShips
    playerArmada(q).x = 0
    playerArmada(q).y = 0
    playerArmada(q).title$ = title$
    playerArmada(q).armor = armor
    playerArmada(q).speed = speed
    playerArmada(q).minDamage = dmg
    playerArmada(q).randDamage = vardmg
    playerBank = playerBank - totalCost
END IF

drawMainScreen

END SUB

SUB drawMainScreen

CLS
COLOR 0
LOCATE 2, 2
LINE (6, 7)-(313, 193), 2, B
PRINT "Nebular Commander"
LOCATE 23, 3
PRINT "(M)ap (B)uild (S)tatus (Q)uit"


END SUB

FUNCTION getNumAiShips

FOR i = 1 TO 50
    IF aiArmada(i).x = -1 THEN
        getNumAiShips = i
        EXIT FUNCTION
    END IF
NEXT i


END FUNCTION

FUNCTION getNumPlayerShips

FOR i = 1 TO 50
    IF playerArmada(i).x = -1 THEN
        getNumPlayerShips = i
        EXIT FUNCTION
    END IF
NEXT i

END FUNCTION

SUB newGame

aiBank = 100
playerBank = 100

FOR i = 1 TO 50
    playerArmada(i).x = -1
    aiArmada(i).x = -1
NEXT i


END SUB

