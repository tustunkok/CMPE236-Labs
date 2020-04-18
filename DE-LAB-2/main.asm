; GLOBAL 7SEG CONSTANTS
N0		EQU	11000000B		; #DEFINE N0 11000000B
N1		EQU	11111001B
N2		EQU	10100100B
N3		EQU	10110000B
N4		EQU	10011001B
N5		EQU	10010010B
N6		EQU	10000010B
N7		EQU	11111000B
N8		EQU	10000000B
N9		EQU	10010000B
NA		EQU	10001000B
NB		EQU	10000011B
NC		EQU	11000110B
ND		EQU	10100001B
NE_		EQU	10000110B
NF		EQU	10001110B

; CONTSTANTS
ATTEMPT_LOC	EQU	20H
PASSWD_LOC	EQU	21H			; PASSWD_LOC[4]
EN		EQU	P3.0
LENGTH		EQU	04D

		ORG	00H
		SJMP	MAIN

		ORG	30H
MAIN:		MOV	ATTEMPT_LOC, #03D	; INT ATTEMPT = 3;

		ACALL	GET_PASSWD		; LET THE USER ENTER HıS/HER PASSWORD ıNFO
		ACALL	CHCK_PASSWD		; CHECK IF THE PASSWORD ENTERED CORRECTLY

		; COMPARE THE RETURNED VALUE WITH THE PASSWORD
		; LENGTH TO SEE IF THEY ARE EQUAL OR NOT.
		CJNE	A, #LENGTH, ERROR

		; PASSWORD IS CORRECT
		MOV	R2, #0CH
		ACALL	WRT2LED
		SJMP	HALT

		; PASSWORD IS NOT CORRECT
ERROR:		MOV	R2, #0FH
		ACALL	WRT2LED

HALT:		SJMP	HALT

; ===================================================
; CHECK THE ENTERED DIGITS BY THE USER
; PARAMS: NONE
; RETURN: NUMBER OF CORRECTLY ENTERED DIGITS
CHCK_PASSWD:	MOV	R2, #LENGTH		;INT PWD_LENGTH=4;
		MOV	R0, #PASSWD_LOC		;LOAD THE R0 TO THE PLACE WHERE PASSWORD RESIDES
		CLR	A			;INT CORRECT_COUNT = 0
		PUSH	A

LP2:		PUSH	02H			;SAVE THE PREVIOUS VALUE OF THE R2 REGISTER
		MOV	R2, ATTEMPT_LOC		;PARAMETER LOADING, WRT2LED(ATTEMPT_COUNT)
		ACALL	WRT2LED
		POP	02H			;GET THE PREVIOUS R2 VALUE

LP3:		JB	EN, LP3			;WAIT UNTILL THE USER OPENS ENABLE PIN
		MOV	A, P2			;GET A DIGIT FROM THE USER
		CLR	C
		SUBB	A, @R0			;CHECKT THE CORRESPONDING DIGIT IN THE PSWD

		JZ	CONT
		DJNZ	ATTEMPT_LOC, LP2	;ATTEMPT_COUNT --;
		MOV	R2, ATTEMPT_LOC		;ATTEMPT COUNT IS FINISHED
		ACALL	WRT2LED			;WRITE 0 TO 7SEG DISPLAY
		SJMP	EXT			;GO TO THE EXIT

						;IF(DIGIT=PASSWORD[I]){CORRECT_COUNT++;}
CONT:		INC	R0			;MOVE THE POINTER TO THE NEXT VALUE
		POP	A			;GET THE CORRECT_COUNT	VARIABLE
		INC	A			;CORRECT_COUNT++
		PUSH	A
		DJNZ	R2, LP2

EXT:		POP	A			 ;RETURN CORRECT_COUNT++
		RET

; ===================================================
; GET 4 DIGIT PASSWORD FROM USER
; PARAMS: NONE
; RETURN: NONE
GET_PASSWD:	MOV	R2, #LENGTH		; INT PASSWORD_LENGTH=4;
		MOV	R0, #PASSWD_LOC		; LOAD R0 POINTER WITH THE VALUE OF 21H
LP1:		JB	EN, LP1			; WAIT UNTILL THE USER OPENS ENABLE PIN
		MOV	@R0, P2
		INC	R0
		DJNZ	R2, LP1			; PASSWORD_LENGTH --;
		RET

; ===================================================
; WRITE THE GIVEN NUMBER TO THE 7SEG DISPLAY
; PARAMS: NUMBER
; RETURN: NONE
WRT2LED:	MOV	DPTR, #LED_DATA
		MOV	A, #0FH			; IF(PARAMETER>MAX_VALUE){RETURN;}
		CLR	C			; CLEAR THE CARRY BIT
		SUBB	A, R2
		JC	EXT1			; IF CARRY OCCURS DO NOTHING
		MOV	A, R2			; READ THE PARAMETER
		MOVC	A, @A+DPTR
		MOV	P1, A
EXT1:		RET

		ORG	0200H
LED_DATA:	DB	N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, NA, NB, NC, ND, NE_, NF
		END