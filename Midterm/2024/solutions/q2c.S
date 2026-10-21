#include <xc.inc>

CONFIG WDT = OFF
CONFIG LVP = OFF
CONFIG XINST = OFF

; Interface: INPUT_HI:INPUT_LO at 0x10:0x11 is an unsigned 16-bit value.
; next_permutation preserves the input and returns OUTPUT_HI:OUTPUT_LO
; at 0x00:0x01. SUCCESS at 0x20 is 1 if a strictly larger permutation
; exists. Otherwise SUCCESS is 0 and the output equals the input.
; All four nibbles participate, including leading zeros and duplicates.
; Scratch: 0x30..0x38. Clobbers: WREG, STATUS, FSR0, FSR1, scratch.
OUTPUT_HI   EQU 0x00
OUTPUT_LO   EQU 0x01
INPUT_HI    EQU 0x10
INPUT_LO    EQU 0x11
SUCCESS     EQU 0x20
DIGIT0      EQU 0x30
DIGIT1      EQU 0x31
DIGIT2      EQU 0x32
DIGIT3      EQU 0x33
PIVOT       EQU 0x34
SUCCESSOR   EQU 0x35
LEFT_INDEX  EQU 0x36
RIGHT_INDEX EQU 0x37
TEMP_BYTE   EQU 0x38

GLOBAL main, done, next_permutation

PSECT resetVec,class=CODE,reloc=2
reset_entry:
    goto main

PSECT mainCode,class=CODE,reloc=2
main:
    movlw 0x1A
    movwf INPUT_HI, 0
    movlw 0xC3
    movwf INPUT_LO, 0
    call next_permutation
done:
    bra done

next_permutation:
    clrf SUCCESS, 0
    movff INPUT_HI, OUTPUT_HI
    movff INPUT_LO, OUTPUT_LO
    swapf INPUT_HI, 0, 0
    andlw 0x0F
    movwf DIGIT0, 0
    movf INPUT_HI, 0, 0
    andlw 0x0F
    movwf DIGIT1, 0
    swapf INPUT_LO, 0, 0
    andlw 0x0F
    movwf DIGIT2, 0
    movf INPUT_LO, 0, 0
    andlw 0x0F
    movwf DIGIT3, 0

    ; Find the rightmost i with digit[i] < digit[i+1].
    movlw 2
    movwf PIVOT, 0
find_pivot:
    lfsr 0, DIGIT0
    movf PIVOT, 0, 0
    addwf FSR0L, 1, 0
    movf INDF0, 0, 0
    movwf TEMP_BYTE, 0
    movf PREINC0, 0, 0
    subwf TEMP_BYTE, 0, 0
    bnc pivot_found
    decf PIVOT, 1, 0
    bn no_larger_permutation
    bra find_pivot

pivot_found:
    lfsr 0, DIGIT0
    movf PIVOT, 0, 0
    addwf FSR0L, 1, 0
    movlw 3
    movwf SUCCESSOR, 0
find_successor:
    ; The suffix is nonincreasing: its rightmost larger digit is the
    ; smallest available digit strictly greater than the pivot.
    lfsr 1, DIGIT0
    movf SUCCESSOR, 0, 0
    addwf FSR1L, 1, 0
    movf INDF1, 0, 0
    subwf INDF0, 0, 0
    bnc successor_found
    decf SUCCESSOR, 1, 0
    bra find_successor
successor_found:
    movff INDF0, TEMP_BYTE
    movff INDF1, INDF0
    movff TEMP_BYTE, INDF1
    movf PIVOT, 0, 0
    addlw 1
    movwf LEFT_INDEX, 0
    movlw 3
    movwf RIGHT_INDEX, 0

    ; Reverse the suffix to obtain the smallest possible remaining value.
reverse_suffix:
    movf RIGHT_INDEX, 0, 0
    subwf LEFT_INDEX, 0, 0
    bc pack_result
    lfsr 0, DIGIT0
    movf LEFT_INDEX, 0, 0
    addwf FSR0L, 1, 0
    lfsr 1, DIGIT0
    movf RIGHT_INDEX, 0, 0
    addwf FSR1L, 1, 0
    movff INDF0, TEMP_BYTE
    movff INDF1, INDF0
    movff TEMP_BYTE, INDF1
    incf LEFT_INDEX, 1, 0
    decf RIGHT_INDEX, 1, 0
    bra reverse_suffix

pack_result:
    swapf DIGIT0, 0, 0
    iorwf DIGIT1, 0, 0
    movwf OUTPUT_HI, 0
    swapf DIGIT2, 0, 0
    iorwf DIGIT3, 0, 0
    movwf OUTPUT_LO, 0
    movlw 1
    movwf SUCCESS, 0
no_larger_permutation:
    return

END reset_entry
