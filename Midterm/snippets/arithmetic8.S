#include <xc.inc>

; Copy this file's routines into one program, then reserve the listed access RAM.
;
; Add8 / Sub8
;   Input: U8_A and U8_B.
;   Output: U8_A = A + B or A - B modulo 256.
;   Clobbers: WREG, STATUS.
;
; Multiply8
;   Input: U8_A and U8_B.
;   Output: U8_PRODUCT_H:U8_PRODUCT_L = A * B.
;   Clobbers: WREG, STATUS, PRODH:PRODL.

U8_A         EQU 0x20
U8_B         EQU 0x21
U8_PRODUCT_H EQU 0x22
U8_PRODUCT_L EQU 0x23

PSECT snippets_arithmetic8,class=CODE,reloc=2

Add8:
    movf U8_B, 0, 0
    addwf U8_A, 1, 0
    return

Sub8:
    movf U8_B, 0, 0
    subwf U8_A, 1, 0
    return

Multiply8:
    movf U8_A, 0, 0
    mulwf U8_B, 0
    movff PRODH, U8_PRODUCT_H
    movff PRODL, U8_PRODUCT_L
    return
