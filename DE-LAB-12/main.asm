OPER	EQU		0FFH
		ORG		00H
		SJMP	MAIN

		ORG		30H
MAIN:	MOV		R0, #32H
		MOV		R1, #38H
		MOV		B, #OPER
		MOV		R2, #3D

BACK:	MOV		A, @R0
		DEC		R0
		MUL		AB
		MOV		@R1, A
		INC		R1
		MOV		@R1, B
		MOV		B, #OPER
		INC		R1
		DJNZ	R2, BACK

		MOV		R0, #43H
		MOV		R1, #38H
		MOV		R2, #2D

		MOV		A, @R1
		MOV		@R0, A
		DEC		R0
		INC		R1
		CLR		C
LOOP:	MOV		A, @R1
		INC		R1
		ADDC	A, @R1
		MOV		@R0, A
		DEC		R0
		INC		R1
		DJNZ	R2, LOOP
		MOV		A, @R1
		ADDC	A, #00H
		MOV		@R0, A

		SJMP	$
		END
