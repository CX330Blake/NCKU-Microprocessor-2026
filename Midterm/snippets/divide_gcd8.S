#include <xc.inc>

; Copy this file's routines into one program, then reserve the listed access RAM.
;
; Divide8
;   Input: U8_QUOT = dividend, U8_DIVISOR = nonzero divisor.
;   Output: U8_QUOT = quotient, U8_REMAINDER = remainder.
;   Preserves: divisor.
;   Clobbers: WREG, STATUS, U8_BITS.
;
; Gcd8
;   Input: U8_GCD_A and U8_GCD_B.
;   Output: U8_GCD_A = gcd(A, B), U8_GCD_B = 0.
;   Clobbers: Divide8's scratch and WREG, STATUS.

U8_QUOT      EQU 0x20
U8_DIVISOR   EQU 0x21
U8_REMAINDER EQU 0x22
U8_BITS      EQU 0x23
U8_GCD_A     EQU 0x24
U8_GCD_B     EQU 0x25

PSECT snippets_divide_gcd8,class=CODE,reloc=2

Divide8:
    clrf U8_REMAINDER, 0
    movlw 8
    movwf U8_BITS, 0
Divide8_Loop:
    bcf STATUS, 0, 0
    rlcf U8_QUOT, 1, 0
    rlcf U8_REMAINDER, 1, 0
    bc Divide8_Subtract
    movf U8_DIVISOR, 0, 0
    subwf U8_REMAINDER, 0, 0
    bnc Divide8_Next
Divide8_Subtract:
    movf U8_DIVISOR, 0, 0
    subwf U8_REMAINDER, 1, 0
    bsf U8_QUOT, 0, 0
Divide8_Next:
    decfsz U8_BITS, 1, 0
    bra Divide8_Loop
    return

Gcd8:
    movf U8_GCD_B, 0, 0
    bz Gcd8_Done
    movff U8_GCD_A, U8_QUOT
    movff U8_GCD_B, U8_DIVISOR
    call Divide8
    movff U8_GCD_B, U8_GCD_A
    movff U8_REMAINDER, U8_GCD_B
    bra Gcd8
Gcd8_Done:
    return
