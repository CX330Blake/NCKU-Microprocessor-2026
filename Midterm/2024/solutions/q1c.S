#include <xc.inc>
CONFIG WDT = OFF
CONFIG LVP = OFF
CONFIG XINST = OFF

nval EQU 0x10
kval EQU 0x11
row EQU 0x30
col EQU 0x31
left EQU 0x32

PSECT resetVec,class=CODE,reloc=2
resetVec:
    goto main
PSECT code,class=CODE,reloc=2
GLOBAL main, done, Fact
main:
    movlw 10
    movwf nval,0
    movlw 4
    movwf kval,0
    call Fact
done:
    bra done

; Input: [0x10]=n, [0x11]=k, 0 <= k <= n <= 15.
; Output: [0x00]:[0x01], high byte first.
; Pascal row: 16 little-endian words at 0x100..0x11F.
; Clobbers: row, col, left, WREG, STATUS, FSR0, FSR1.
Fact:
    lfsr 0,0x100
    movlw 32
    movwf left,0
ClearRow:
    clrf POSTINC0,0
    decfsz left,1,0
    bra ClearRow
    lfsr 0,0x100
    movlw 1
    movwf INDF0,0
    clrf row,0
NextRow:
    movf nval,0,0
    cpfseq row,0
    bra BeginRow
    bra Finished
BeginRow:
    incf row,1,0
    movff row,col
    lfsr 0,0x100
    movf col,0,0
    mullw 2
    movf PRODL,0,0
    movwf FSR0L,0
    lfsr 1,0x100
    addlw 0xFE
    movwf FSR1L,0
UpdateCol:
    movf POSTINC1,0,0
    addwf POSTINC0,1,0
    movf INDF1,0,0
    addwfc INDF0,1,0
    ; Pointers are now at the high bytes; move to prior low bytes.
    movlw 3
    subwf FSR0L,1,0
    subwf FSR1L,1,0
    decfsz col,1,0
    bra UpdateCol
    bra NextRow
Finished:
    lfsr 0,0x100
    movf kval,0,0
    mullw 2
    movf PRODL,0,0
    movwf FSR0L,0
    movff POSTINC0,0x01
    movff INDF0,0x00
    return
END resetVec
