#include <xc.inc>

; ReverseRange
;   Input: FSR0 points to the first byte and FSR1 points to the last byte of an
;          inclusive RAM range. The range must not wrap from 0xFFF to 0x000.
;   Output: reverses the range in place. FSR0 and FSR1 finish crossed or equal.
;   Clobbers: WREG, STATUS, SWAP.
;   Use LFSR before CALL, for example:
;       lfsr 0, 0x300 + head
;       lfsr 1, 0x300 + tail
;       call ReverseRange

SWAP EQU 0x20

PSECT snippets_reverse_range,class=CODE,reloc=2

ReverseRange:
    movf FSR1H, 0, 0
    subwf FSR0H, 0, 0
    bnz ReverseRange_CompareHigh
    movf FSR1L, 0, 0
    subwf FSR0L, 0, 0
    bc ReverseRange_Done
    bra ReverseRange_Swap

ReverseRange_CompareHigh:
    bc ReverseRange_Done

ReverseRange_Swap:
    movff INDF0, SWAP
    movff INDF1, INDF0
    movff SWAP, INDF1
    incf FSR0L, 1, 0
    btfsc STATUS, 2, 0
    incf FSR0H, 1, 0
    decf FSR1L, 1, 0
    movlw 0xFF
    cpfseq FSR1L, 0
    bra ReverseRange
    decf FSR1H, 1, 0
    bra ReverseRange

ReverseRange_Done:
    return
