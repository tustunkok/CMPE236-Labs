		ORG	00H
		SJMP	MAIN

		ORG	0BH ;TIMER 0 INT
		MOV	P1, #00H
		RETI

		ORG	30H
MAIN:		MOV	TMOD, #01H ; 00000001
		MOV	TH0, #0FFH
		MOV	TL0, #0F0H

		SETB	EA
		SETB	ET0

		SETB	TR0

		SJMP	$
		END
