#include <xc.inc>

; Copy this file's routines into one program, then reserve the listed access RAM.
; All 16-bit values use high-byte-first order.
;
; Divide16
;   Input: QUOT_H:QUOT_L = dividend, DIV_H:DIV_L = nonzero divisor.
;   Output: QUOT_H:QUOT_L = quotient, REM_H:REM_L = remainder.
;   Preserves: divisor.
;   Clobbers: WREG, STATUS, DIFF_H:DIFF_L, BITS.
;
; Gcd16
;   Input: GCD_AH:GCD_AL and GCD_BH:GCD_BL.
;   Output: GCD_AH:GCD_AL = gcd(A, B), GCD_BH:GCD_BL = 0.
;   Clobbers: Divide16's scratch and WREG, STATUS.

QUOT_H EQU 0x20
QUOT_L EQU 0x21
DIV_H  EQU 0x22
DIV_L  EQU 0x23
REM_H  EQU 0x24
REM_L  EQU 0x25
DIFF_H EQU 0x26
DIFF_L EQU 0x27
BITS   EQU 0x28
GCD_AH EQU 0x29
GCD_AL EQU 0x2A
GCD_BH EQU 0x2B
GCD_BL EQU 0x2C

PSECT snippets_divide_gcd,class=CODE,reloc=2

Divide16:
    clrf REM_H, 0
    clrf REM_L, 0
    movlw 16
    movwf BITS, 0
Divide16_Loop:
    bcf STATUS, 0, 0
    rlcf QUOT_L, 1, 0
    rlcf QUOT_H, 1, 0
    rlcf REM_L, 1, 0
    rlcf REM_H, 1, 0

    movf DIV_L, 0, 0
    subwf REM_L, 0, 0
    movwf DIFF_L, 0
    movf DIV_H, 0, 0
    subwfb REM_H, 0, 0
    movwf DIFF_H, 0
    bnc Divide16_Next
    movff DIFF_H, REM_H
    movff DIFF_L, REM_L
    bsf QUOT_L, 0, 0
Divide16_Next:
    decfsz BITS, 1, 0
    bra Divide16_Loop
    return

Gcd16:
    movf GCD_BH, 0, 0
    iorwf GCD_BL, 0, 0
    bz Gcd16_Done

    movff GCD_AH, QUOT_H
    movff GCD_AL, QUOT_L
    movff GCD_BH, DIV_H
    movff GCD_BL, DIV_L
    call Divide16
    movff GCD_BH, GCD_AH
    movff GCD_BL, GCD_AL
    movff REM_H, GCD_BH
    movff REM_L, GCD_BL
    bra Gcd16
Gcd16_Done:
    return
