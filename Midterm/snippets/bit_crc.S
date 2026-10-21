#include <xc.inc>

; Copy this file's routines into one program, then reserve the listed access RAM.
;
; LogicalShiftLeft8
;   Input: VALUE and COUNT (0..255).
;   Output: VALUE = VALUE << COUNT modulo 256.
;   Clobbers: WREG, STATUS. A count of zero returns immediately.
;
; ArithmeticShiftRight8
;   Input: VALUE and COUNT (0..255).
;   Output: VALUE = signed(VALUE) >> COUNT.
;   Clobbers: WREG, STATUS. A count of zero returns immediately.
;
; MultiplyNibbles
;   Input: WREG byte.
;   Output: WREG = upper_nibble * lower_nibble (0..225).
;   Clobbers: STATUS, PRODH:PRODL, NIBBLE.
;
; Crc16CcittByte
;   Input: MESSAGE.
;   Output: CRC_H:CRC_L, CRC-16 polynomial 0x1021.
;   Parameters: MSB-first, seed 0, no reflection, no final XOR.
;   Clobbers: WREG, STATUS, COUNT. Input is preserved.

VALUE   EQU 0x20
COUNT   EQU 0x21
NIBBLE  EQU 0x22
MESSAGE EQU 0x23
CRC_H   EQU 0x24
CRC_L   EQU 0x25

PSECT snippets_bit_crc,class=CODE,reloc=2

LogicalShiftLeft8:
    movf COUNT, 0, 0
    bz LogicalShiftLeft8_Done
LogicalShiftLeft8_Loop:
    bcf STATUS, 0, 0
    rlcf VALUE, 1, 0
    decfsz COUNT, 1, 0
    bra LogicalShiftLeft8_Loop
LogicalShiftLeft8_Done:
    return

ArithmeticShiftRight8:
    movf COUNT, 0, 0
    bz ArithmeticShiftRight8_Done
ArithmeticShiftRight8_Loop:
    bcf STATUS, 0, 0
    btfsc VALUE, 7, 0
    bsf STATUS, 0, 0
    rrcf VALUE, 1, 0
    decfsz COUNT, 1, 0
    bra ArithmeticShiftRight8_Loop
ArithmeticShiftRight8_Done:
    return

MultiplyNibbles:
    movwf NIBBLE, 0
    swapf NIBBLE, 0, 0
    andlw 0x0F
    movwf PRODL, 0
    movf NIBBLE, 0, 0
    andlw 0x0F
    mulwf PRODL, 0
    movf PRODL, 0, 0
    return

Crc16CcittByte:
    movff MESSAGE, CRC_H
    clrf CRC_L, 0
    movlw 8
    movwf COUNT, 0
Crc16CcittByte_Loop:
    bcf STATUS, 0, 0
    rlcf CRC_L, 1, 0
    rlcf CRC_H, 1, 0
    bnc Crc16CcittByte_Next
    movlw 0x10
    xorwf CRC_H, 1, 0
    movlw 0x21
    xorwf CRC_L, 1, 0
Crc16CcittByte_Next:
    decfsz COUNT, 1, 0
    bra Crc16CcittByte_Loop
    return
