PROCESSOR 18F4520
#include <xc.inc>

CONFIG OSC = INTIO67
CONFIG WDT = OFF
CONFIG XINST = OFF

INPUT_VAL equ 0x020
RESULT_VAL equ 0x021

PSECT resetVec,class=CODE,reloc=2

resetVec:
main:
    ; Test case 2: 0x6D
    movlw 0x0F
    movwf INPUT_VAL, 0

    ; Move odd-position bits right and keep bits 6, 4, 2, 0
    rrncf INPUT_VAL, 0, 0
    andlw 0x55
    movwf RESULT_VAL, 0

    ; Move even-position bits left and keep bits 7, 5, 3, 1
    rlncf INPUT_VAL, 0, 0
    andlw 0xAA
    iorwf RESULT_VAL, 1, 0

done:
    sleep

END resetVec
