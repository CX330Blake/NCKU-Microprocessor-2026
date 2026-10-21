#include <xc.inc>
CONFIG WDT = OFF
CONFIG LVP = OFF
CONFIG XINST = OFF

qhi EQU 0x30
qlo EQU 0x31
divisor EQU 0x32
rem8 EQU 0x33
bits EQU 0x34

PSECT resetVec,class=CODE,reloc=2
resetVec:
    goto main
PSECT code,class=CODE,reloc=2
GLOBAL main, done, Divide
main:
    movlw 0x04
    movwf qhi,0
    movlw 0x06
    movwf qlo,0
    movlw 0x03
    movwf divisor,0
    call Divide
done:
    bra done

; Input: qhi:qlo / divisor (nonzero).
; Output: [0x20]:[0x21] quotient, [0x22] remainder.
; Clobbers: inputs, rem8, bits, WREG, STATUS.
Divide:
    clrf rem8,0
    movlw 16
    movwf bits,0
DivideLoop:
    bcf STATUS,0,0
    rlcf qlo,1,0
    rlcf qhi,1,0
    rlcf rem8,1,0
    bc DivideSubtract
    movf divisor,0,0
    subwf rem8,0,0
    bnc DivideNext
DivideSubtract:
    movf divisor,0,0
    subwf rem8,1,0
    bsf qlo,0,0
DivideNext:
    decfsz bits,1,0
    bra DivideLoop
    movff qhi,0x20
    movff qlo,0x21
    movff rem8,0x22
    return
END resetVec
