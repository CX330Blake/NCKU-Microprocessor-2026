#include <xc.inc>

CONFIG WDT = OFF
CONFIG LVP = OFF
CONFIG XINST = OFF

; Interface: ARRAY is RAM 0x300..0x309; HEAD and TAIL are inclusive
; indices satisfying 0 <= HEAD <= TAIL <= 9. Inputs are preserved.
; reverse_subarray modifies only ARRAY[HEAD..TAIL], using FSR0/FSR1.
; Clobbers: WREG, STATUS, FSR0, FSR1, SWAP_BYTE.
ARRAY       EQU 0x300
HEAD        EQU 0x10
TAIL        EQU 0x11
SWAP_BYTE   EQU 0x30

GLOBAL main, done, reverse_subarray

PSECT resetVec,class=CODE,reloc=2
reset_entry:
    goto main

PSECT mainCode,class=CODE,reloc=2
main:
    lfsr 0, ARRAY
    movlw 0x65
    movwf POSTINC0, 0
    movlw 0x06
    movwf POSTINC0, 0
    movlw 0x03
    movwf POSTINC0, 0
    movlw 0x65
    movwf POSTINC0, 0
    movlw 0x0C
    movwf POSTINC0, 0
    movlw 0x04
    movwf POSTINC0, 0
    movlw 0xF7
    movwf POSTINC0, 0
    movlw 0x32
    movwf POSTINC0, 0
    movlw 0x50
    movwf POSTINC0, 0
    clrf INDF0, 0
    movlw 3
    movwf HEAD, 0
    movlw 6
    movwf TAIL, 0
    call reverse_subarray
done:
    bra done

reverse_subarray:
    lfsr 0, ARRAY
    movf HEAD, 0, 0
    addwf FSR0L, 1, 0
    lfsr 1, ARRAY
    movf TAIL, 0, 0
    addwf FSR1L, 1, 0
reverse_loop:
    ; Both pointers remain in bank 3, so comparing low bytes is enough.
    movf FSR1L, 0, 0
    subwf FSR0L, 0, 0
    bc reverse_done
    movff INDF0, SWAP_BYTE
    movff INDF1, INDF0
    movff SWAP_BYTE, INDF1
    incf FSR0L, 1, 0
    decf FSR1L, 1, 0
    bra reverse_loop
reverse_done:
    return

END reset_entry
