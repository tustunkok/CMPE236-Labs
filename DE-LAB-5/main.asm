N1_LB		EQU	31H
N1_HB		EQU	30H
N2_LB		EQU	33H
N2_HB		EQU	32H
RESULT		EQU	40H

		ORG	00H
		SJMP	MAIN

		ORG	30H
MAIN:		MOV	R2, #03D
		ACALL	DELAY

HALT:		SJMP	HALT

; PARAMETERS: R2 -> DELAY TIME (MILLISECONDS)
DELAY:		;MOV	N1_LB, R2
		;MOV	N1_HB, #00H
		;MOV	N2_LB, #0E8H
		;MOV	N2_HB, #03H

		MOV	N1_LB, #21H
		MOV	N1_HB, #47H
		MOV	N2_LB, #2AH
		MOV	N2_HB, #5FH
		ACALL	MUL_2BYTE
		RET

MUL_2BYTE:	MOV	R0, #38H

		MOV	A, N1_LB
		MOV	B, N2_LB
		MUL	AB
		MOV	@R0, B
		INC	R0
		MOV	@R0, A
		INC	R0

		MOV	A, N1_HB
		MOV	B, N2_LB
		MUL	AB
		MOV	@R0, B
		INC	R0
		MOV	@R0, A
		INC	R0

		MOV	A, N1_LB
		MOV	B, N2_HB
		MUL	AB
		MOV	@R0, B
		INC	R0
		MOV	@R0, A
		INC	R0

		MOV	A, N1_HB
		MOV	B, N2_HB
		MUL	AB
		MOV	@R0, B
		INC	R0
		MOV	@R0, A
		INC	R0

		MOV	(RESULT + 3), 39H

		MOV	A, 38H
		ADD	A, 3BH
		ADDC	A, 3DH
		MOV	(RESULT + 2), A

		MOV	A, 3AH
		ADDC	A, 3CH
		ADDC	A, 3FH
		MOV	(RESULT + 1), A

		CLR	A
		ADDC	A, 3EH
		MOV	RESULT, A
		RET

		END