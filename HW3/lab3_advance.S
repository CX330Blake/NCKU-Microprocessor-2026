PROCESSOR 18F4520
#include <xc.inc>

CONFIG OSC = INTIO67
CONFIG WDT = OFF
CONFIG XINST = OFF

PSECT resetVec,class=CODE,reloc=2

resetVec:
    goto main

PSECT code

INPUT_H equ 0x000
INPUT_L equ 0x001
RESULT_H equ 0x010
RESULT_L equ 0x011

main:
    ; Complement, then add 1

    ; Test case 1:0x00, 2:0xFF
    movlw 0x01
    movwf INPUT_H, 0
    ; Test case 1:0x64, 2:0x9C
    movlw 0x00
    movwf INPUT_L, 0

    movff INPUT_H, RESULT_H
    movff INPUT_L, RESULT_L

    btfss INPUT_H, 7, 0
    ; Nonnegative: the copy is already correct
    bra done

    comf RESULT_H, 1, 0
    comf RESULT_L, 1, 0

    movlw 0x01
    addwf RESULT_L, 1, 0
    ; MOVLW preserves carry
    movlw 0x00
    addwfc RESULT_H, 1, 0

done:
    bra done

END resetVec