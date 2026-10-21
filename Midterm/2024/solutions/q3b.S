#include <xc.inc>

CONFIG WDT = OFF
CONFIG LVP = OFF
CONFIG XINST = OFF

CRC_HIGH EQU 0x00
CRC_LOW EQU 0x01
MESSAGE EQU 0x10
ROUND_COUNT EQU 0x30

GLOBAL main, done, solve_q3b

PSECT resetVec,class=CODE,reloc=2
resetVec:
    goto main

PSECT code,class=CODE,reloc=2
main:
    movlw 0xFE
    movwf MESSAGE, 0
    call solve_q3b
done:
    bra done

; Input: one byte in RAM 0x10. Output: CRC high:low in RAM 0x00:0x01.
; Clobbers: WREG, STATUS, RAM 0x30. Input is preserved.
; Divide (message << 16) by x^16 + x^12 + x^5 + 1 (0x11021).
; This is an MSB-first, unreflected, seed-zero CRC with no final XOR.
; Starting with message << 8 and shifting eight times appends 16 zeros
; to the original message in the polynomial-division interpretation.
solve_q3b:
    movf MESSAGE, 0, 0
    movwf CRC_HIGH, 0
    clrf CRC_LOW, 0
    movlw 8
    movwf ROUND_COUNT, 0
crc_round:
    bcf STATUS, 0, 0
    rlcf CRC_LOW, 1, 0
    rlcf CRC_HIGH, 1, 0
    ; Carry now contains the old bit 15, not the newly shifted top bit.
    bnc crc_next_round
    movlw 0x10
    xorwf CRC_HIGH, 1, 0
    movlw 0x21
    xorwf CRC_LOW, 1, 0
crc_next_round:
    decfsz ROUND_COUNT, 1, 0
    bra crc_round
    return

END resetVec
