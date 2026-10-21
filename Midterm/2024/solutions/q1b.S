#include <xc.inc>
CONFIG WDT = OFF
CONFIG LVP = OFF
CONFIG XINST = OFF

row EQU 0x30
col EQU 0x31
nval EQU 0x32
kval EQU 0x33
left EQU 0x34

; Literal arguments: 0 <= kk <= nn <= 8.
; Pascal row occupies 0x40..0x48. Output: [0x00].
; Clobbers: scratch RAM, WREG, STATUS, FSR0, FSR1.
Fact MACRO nn,kk
    LOCAL clearRow,nextRow,nextCol,updateCol,finished
    movlw nn
    movwf nval,0
    movlw kk
    movwf kval,0
    lfsr 0,0x40
    movlw 9
    movwf left,0
clearRow:
    clrf POSTINC0,0
    decfsz left,1,0
    bra clearRow
    movlw 1
    movwf 0x40,0
    clrf row,0
nextRow:
    movf nval,0,0
    cpfseq row,0
    bra nextCol
    bra finished
nextCol:
    incf row,1,0
    movff row,col
    lfsr 0,0x40
    movf col,0,0
    addwf FSR0L,1,0
    movff FSR0L,FSR1L
    clrf FSR1H,0
    decf FSR1L,1,0
updateCol:
    movf INDF1,0,0
    addwf INDF0,1,0
    decf FSR0L,1,0
    decf FSR1L,1,0
    decfsz col,1,0
    bra updateCol
    bra nextRow
finished:
    lfsr 0,0x40
    movf kval,0,0
    addwf FSR0L,1,0
    movff INDF0,0x00
ENDM

PSECT resetVec,class=CODE,reloc=2
resetVec:
    goto main
PSECT code,class=CODE,reloc=2
GLOBAL main, done
main:
    Fact 5,3
done:
    bra done
END resetVec
