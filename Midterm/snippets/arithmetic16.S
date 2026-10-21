#include <xc.inc>

; Copy this file's routines into one program, then reserve the listed access RAM.
; All 16-bit values use high-byte-first order.
;
; Add16 / Sub16
;   Input: AH:AL and BH:BL.
;   Output: AH:AL = A + B or A - B modulo 65536.
;   Clobbers: WREG, STATUS.
;
; Multiply16
;   Input: AH:AL and BH:BL.
;   Output: RH:RL = low 16 bits of A * B.
;   Precondition: the required product fits in 16 bits when overflow matters.
;   Clobbers: WREG, STATUS, PRODH:PRODL.

AH  EQU 0x20
AL  EQU 0x21
BH  EQU 0x22
BL  EQU 0x23
RH  EQU 0x24
RL  EQU 0x25

PSECT snippets_arithmetic,class=CODE,reloc=2

Add16:
    movf BL, 0, 0
    addwf AL, 1, 0
    movf BH, 0, 0
    addwfc AH, 1, 0
    return

Sub16:
    movf BL, 0, 0
    subwf AL, 1, 0
    movf BH, 0, 0
    subwfb AH, 1, 0
    return

Multiply16:
    movf AL, 0, 0
    mulwf BL, 0
    movff PRODL, RL
    movff PRODH, RH

    movf AH, 0, 0
    mulwf BL, 0
    movf PRODL, 0, 0
    addwf RH, 1, 0

    movf AL, 0, 0
    mulwf BH, 0
    movf PRODL, 0, 0
    addwf RH, 1, 0
    return
