PROCESSOR 18F4520
#include <xc.inc>

PSECT resetVec,class=CODE,reloc=2

resetVec:
    goto    main

PSECT code

main:
    ; test 1
    MOVLW 0b01010101
    MOVWF 0x00
    ; test 2
    ; MOVLW 0b01111100
    ; MOVWF 0x00

    ; 0x000 : original input (must remain unchanged)
    ; 0x001 : working copy of input
    ; 0x002 : current consecutive-1 count
    ; 0x003 : loop counter
    ; 0x010 : maximum consecutive-1 count (result)
    movf    0x000, w, c
    movwf   0x001, c

    ; current_count = 0
    clrf    0x002, c

    ; max_count = 0
    clrf    0x010, c

    ; Process exactly 8 bits.
    movlw   0x08
    movwf   0x003, c

check_bit:
    ; Check bit 0 of the working copy.
    ; If bit 0 is 0, skip the BRA and execute bit_one.
    btfsc   0x001, 0, c
    bra     bit_one

bit_zero:
    ; A zero terminates the current consecutive-1 sequence.
    clrf    0x002, c
    bra     next_bit

bit_one:
    incf    0x002, f, c

    ; WREG = max_count
    ; if (current_count > max_count): skip next
    movf    0x010, w, c
    cpfsgt  0x002, c
    bra     next_bit

    ; update max_count
    movf    0x002, w, c
    movwf   0x010, c

next_bit:
    ; Rotate the working copy right so the next original bit
    ; moves into bit 0.
    rrncf   0x001, f, c

    decfsz  0x003, f, c
    bra     check_bit

done:
    bra     done

END resetVec

