.nolist
.include "m2560def.inc"
.list

.org 0x0000
jmp main
.org INT0addr
jmp count
.org INT4addr
jmp reset
.org OVF1addr
jmp decrement ; interrupt vector for timer

.org INT_VECTORS_SIZE
.def cntval = r18
.def temp = r19

main:
    ldi r16, HIGH(RAMEND)
    out sph, r16
    ldi r16, LOW(RAMEND)
    out spl, r16 ; set stack pointer

    ldi temp, 0b11111111
    out DDRA, temp ;enable output for PORTA

    ldi cntval, 9

                        ;setup timer (don't start counting though)
  
    ldi temp, 0b00000000
    sts TCCR1A, temp    ; reset TCNT1 at overflow
    ldi temp, 0b00000001
    sts TIMSK1, temp    ; Enable Timer Overflow Interrupts

    ldi temp, 0b00000010 ;enable external interrupt 0-3 on falling edge
    sts EICRA, temp
    ldi temp, 0b00000010 ;enable external interrupt 4-7? on falling edge
    sts EICRB, temp

    ldi temp, 0b00010001 ;enable external interrupt 0 and 4
    out EIMSK, temp


    call display

        sei                 ; enable global interrupts
    
    jmp pause

pause:
    jmp pause

count:
    ldi temp,0b00000100
    sts TCCR1B,temp     ; attach clock to timer to start counting. TCNT1 in FCPU/64 mode, so 250000 cnts/sec 
    reti


decrement:
    dec cntval
    call display

    cpi cntval, 0
    brne continue ;if cntval != 0, then continue counting
    
    ldi temp,0b00000000
    sts TCCR1B,temp     ; stop counting by removing clock source

    ldi temp, 0 ;reset timer1 to 0
    sts TCNT1L, temp
    ldi temp, 0
    sts TCNT1H, temp
    
    ldi temp, 0b10111111
    out PORTA, temp ;display zero and enable launch LED


continue:
    reti

reset:

    ldi temp, 0b00000000
    out PORTA, temp
    
    ldi temp,0b00000000
    sts TCCR1B,temp     ; stop counting by removing clock source

    ldi temp, 0 ;reset timer1 to 0
    sts TCNT1L, temp
    ldi temp, 0
    sts TCNT1H, temp

    ldi cntval, 9
    call display

    reti

display:
    cpi cntval, 0
    breq zero
    cpi cntval, 1
    breq one
    cpi cntval, 2
    breq two
    cpi cntval, 3
    breq three
    cpi cntval, 4
    breq four
    cpi cntval, 5
    breq five
    cpi cntval, 6
    breq six
    cpi cntval, 7
    breq seven
    cpi cntval, 8
    breq eight
    cpi cntval, 9
    breq nine

    zero:
        ldi temp, 0b00111111
        out PORTA, temp
        ret
    one:
        ldi temp, 0b00000110
        out PORTA, temp
        ret
    two:
        ldi temp, 0b01011011
        out PORTA, temp
        ret
    three:
        ldi temp, 0b01001111
        out PORTA, temp
        ret
    four:
        ldi temp, 0b01100110
        out PORTA, temp
        ret
    five:
        ldi temp, 0b01101101
        out PORTA, temp
        ret
    six:
        ldi temp, 0b01111101
        out PORTA, temp
        ret
    seven:
        ldi temp, 0b00000111
        out PORTA, temp
        ret
    eight:
        ldi temp, 0b01111111
        out PORTA, temp
        ret
    nine:
        ldi temp, 0b01101111
        out PORTA, temp
        ret

