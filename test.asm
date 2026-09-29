;hello.asm
;  turns on an LED which is connected to PB5 (digital out 13)

.include "./m2560def.inc"

	ldi r16,0b0000001
	out DDRA,r16
	out PortA,r16
Start:
	rjmp Start