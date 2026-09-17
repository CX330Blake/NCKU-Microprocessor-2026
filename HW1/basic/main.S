PROCESSOR 18F4520
#include <xc.inc>

PSECT resetVec,class=CODE,reloc=2

resetVec:
    goto    main

PSECT code

main:
    ; testcase 1 initialization
    movlw   0x07
    movwf   0x000, c

    movlw   0x09
    movwf   0x001, c

    movlw   0x16
    movwf   0x002, c

    movlw   0x09
    movwf   0x003, c

    ; A1 = x1 + x2
    movf    0x000, w, c
    addwf   0x001, w, c
    movwf   0x010, c

    ; A2 = y1 + y2
    movf    0x002, w, c
    addwf   0x003, w, c
    movwf   0x011, c

    ; if A1 == A2, skip the next instruction
    movf    0x011, w, c
    cpfseq  0x010, c
    bra     check_greater

equal:
    movlw   0x22
    movwf   0x020, c
    bra     done

check_greater:
    ; If A1 > A2, skip the next instruction
    cpfsgt  0x010, c
    bra     less

greater:
    movlw   0x11
    movwf   0x020, c
    bra     done

less:
    movlw   0x33
    movwf   0x020, c

done:
    bra     done

END resetVec
