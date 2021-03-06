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

		ORG	00H
		SJMP	MAIN

		ORG	30H
MAIN:		ACALL	WAIT
		ACALL	DECODE_KEY			; INT R2 = DECODE_KEY();

		MOV	R2, A
		ACALL	WRT2LED				; WRT2LED(R2);

		SJMP	MAIN

; ===================================================
; WAIT FOR AN INPUT
; PARAMS: NONE
; RETURN: NONE
WAIT:		MOV	P1, #0F0H
		MOV	A, P1
		ORL	A, #0FH
		CPL	A
		JZ	WAIT
		RET

; ===================================================
; GETS THE COLUMN VALUE AND CALCULATES THE EXACT BUTTON
; PARAMS: COLUMN INDEX
; RETURN: ASCII/VALUE OF THE CLICKED NUMBER
DECODE_KEY:	MOV	P1, #0F0H
		MOV	R2, #00D
		ACALL	FIND_ROW_COL			; FINDING THE INDEX OF THE COL
		PUSH	A				; SAVE THE RETURN VALUE IN THE LOCAL VARIABLE (R3)

		MOV	P1, #0FH
		MOV	R2, #01D
		ACALL	FIND_ROW_COL			;FINDING THE INDEX OF THE ROW

		POP	03H
		MOV	B, #04D				;LOADING THE B WITH THE MAX. COL COUNT IN A ROW
		MUL	AB
		ADD	A, R3				;A IS THE OFFSET VALUE FOR THE FLATTENED VECTOR
		MOV	DPTR, #MATRIX_LOOKUP
		MOVC	A, @A+DPTR

		RET

; ===================================================
; ACCORDING TO GIVEN PARAMETER FIND WHICH COL/ROW IS ACTIVATED
; PARAMS: STATE (0/1)
; RETURN: THE COLUMN/ROW NUMBER
FIND_ROW_COL:	CJNE	R2, #00H, PASS_ROW_DATA
		MOV	DPTR, #COL_DATA
		SJMP	CNT1
PASS_ROW_DATA:	MOV	DPTR, #ROW_DATA
CNT1:		MOV	R2, P1

		MOV	R3, #04D
		MOV	R4, #00D

LP2:		MOV	A, R4
		MOVC	A, @A+DPTR
		CLR	C
		SUBB	A, R2
		JZ	FOUND
		INC	R4
		DJNZ	R3, LP2

FOUND:		MOV	A, R4
		RET

; ==================================================
WRT2LED:	MOV	DPTR, #LED_DATA
		MOV	A, #10H
		CLR	C
		SUBB	A, R2
		JC	EXT1
		MOV	A, R2
		MOVC	A, @A+DPTR
		MOV	P2, A
EXT1:		RET

; ==================================================
		ORG	0200H
COL_DATA:	DB	70H, 0B0H, 0D0H, 0E0H
ROW_DATA:	DB	07H, 0BH, 0DH, 0EH
LED_DATA:	DB	N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, NA, NB, NC, ND, NE_, NF
;MATRIX_LOOKUP:	DB	'1', '2', '3', 'A', '4', '5', '6', 'B', '7', '8', '9', 'C', '*', '0', '#', 'D'
MATRIX_LOOKUP:	DB	01, 02, 03, 0AH, 04, 05, 06, 0BH, 07, 08, 09, 0CH, 0EH, 00, 0EH, 0DH
		END