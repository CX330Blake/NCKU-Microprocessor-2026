#include <xc.inc>

CONFIG WDT = OFF
CONFIG LVP = OFF
CONFIG XINST = OFF

; Interface: LIST_A at 0x100..0x102 and LIST_B at 0x110..0x112.
; Each list contains three distinct unsigned bytes. Inputs are preserved.
; symmetric_difference writes the result at 0x00..(RESULT_COUNT-1),
; in A-only order followed by B-only order. RESULT_COUNT at 0x20 is 0..6.
; Bytes beyond RESULT_COUNT are unspecified. Scratch: 0x30..0x33.
; Clobbers: WREG, STATUS, FSR0, FSR1, FSR2, scratch.
LIST_A          EQU 0x100
LIST_B          EQU 0x110
RESULT          EQU 0x00
RESULT_COUNT    EQU 0x20
ITEMS_LEFT      EQU 0x30
SCAN_LEFT       EQU 0x31
CANDIDATE       EQU 0x32
OTHER_BASE_LOW  EQU 0x33

GLOBAL main, done, symmetric_difference

PSECT resetVec,class=CODE,reloc=2
reset_entry:
    goto main

PSECT mainCode,class=CODE,reloc=2
main:
    lfsr 0, LIST_A
    movlw 0x08
    movwf POSTINC0, 0
    movlw 0x09
    movwf POSTINC0, 0
    movlw 0x02
    movwf INDF0, 0
    lfsr 0, LIST_B
    movlw 0x02
    movwf POSTINC0, 0
    movlw 0x03
    movwf POSTINC0, 0
    movlw 0x04
    movwf INDF0, 0
    call symmetric_difference
done:
    bra done

symmetric_difference:
    clrf RESULT_COUNT, 0
    lfsr 2, RESULT
    lfsr 0, LIST_A
    movlw 0x10
    movwf OTHER_BASE_LOW, 0
    call append_missing
    lfsr 0, LIST_B
    clrf OTHER_BASE_LOW, 0
    call append_missing
    return

; Scan the three candidates at FSR0 against the opposite three-byte list.
; Both opposite-list base addresses have high byte 1.
append_missing:
    movlw 3
    movwf ITEMS_LEFT, 0
candidate_loop:
    movf POSTINC0, 0, 0
    movwf CANDIDATE, 0
    movff OTHER_BASE_LOW, FSR1L
    movlw 1
    movwf FSR1H, 0
    movlw 3
    movwf SCAN_LEFT, 0
membership_loop:
    movf CANDIDATE, 0, 0
    xorwf POSTINC1, 0, 0
    bz candidate_present
    decfsz SCAN_LEFT, 1, 0
    bra membership_loop
    movff CANDIDATE, POSTINC2
    incf RESULT_COUNT, 1, 0
candidate_present:
    decfsz ITEMS_LEFT, 1, 0
    bra candidate_loop
    return

END reset_entry
