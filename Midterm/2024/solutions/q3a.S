#include <xc.inc>

CONFIG WDT = OFF
CONFIG LVP = OFF
CONFIG XINST = OFF

INPUT_VALUE EQU 0x00
SHIFT_LEFT EQU 0x01
SHIFT_ARITH EQU 0x02
SHIFT_FINAL EQU 0x03
PRODUCT_1 EQU 0x11
PRODUCT_2 EQU 0x12
PRODUCT_3 EQU 0x13
SHIFT_COUNT EQU 0x30
NIBBLE_TEMP EQU 0x31

GLOBAL main, done, solve_q3a

PSECT resetVec,class=CODE,reloc=2
resetVec:
    goto main

PSECT code,class=CODE,reloc=2
main:
    movlw 0x93
    movwf INPUT_VALUE, 0
    call solve_q3a
done:
    bra done

; Input: RAM 0x00. Outputs: RAM 0x01..0x03 and 0x11..0x13.
; Clobbers: WREG, STATUS, PRODH:PRODL, RAM 0x30..0x31.
; Left shifts discard overflow. Arithmetic right shifts copy the current sign.
solve_q3a:
    movf INPUT_VALUE, 0, 0
    movwf SHIFT_LEFT, 0
    bcf STATUS, 0, 0
    rlcf SHIFT_LEFT, 1, 0
    bcf STATUS, 0, 0
    rlcf SHIFT_LEFT, 1, 0

    movf SHIFT_LEFT, 0, 0
    movwf SHIFT_ARITH, 0
    movlw 3
    movwf SHIFT_COUNT, 0
arithmetic_shift_loop:
    bcf STATUS, 0, 0
    btfsc SHIFT_ARITH, 7, 0
    bsf STATUS, 0, 0
    rrcf SHIFT_ARITH, 1, 0
    decfsz SHIFT_COUNT, 1, 0
    bra arithmetic_shift_loop

    movf SHIFT_ARITH, 0, 0
    movwf SHIFT_FINAL, 0
    bcf STATUS, 0, 0
    rlcf SHIFT_FINAL, 1, 0
    bcf STATUS, 0, 0
    rlcf SHIFT_FINAL, 1, 0

    movf SHIFT_LEFT, 0, 0
    call multiply_nibbles
    movwf PRODUCT_1, 0
    movf SHIFT_ARITH, 0, 0
    call multiply_nibbles
    movwf PRODUCT_2, 0
    movf SHIFT_FINAL, 0, 0
    call multiply_nibbles
    movwf PRODUCT_3, 0
    return

; Input WREG byte; output WREG = upper nibble * lower nibble (0..225).
multiply_nibbles:
    movwf NIBBLE_TEMP, 0
    swapf NIBBLE_TEMP, 0, 0
    andlw 0x0F
    movwf PRODL, 0
    movf NIBBLE_TEMP, 0, 0
    andlw 0x0F
    mulwf PRODL, 0
    movf PRODL, 0, 0
    return

END resetVec
