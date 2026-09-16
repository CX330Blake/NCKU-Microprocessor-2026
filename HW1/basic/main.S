PROCESSOR 18F4520
#include <xc.inc>

PSECT resetVec,class=CODE,reloc=2

resetVec:
    goto    main

PSECT code

main:
    ; ------------------------------------------------------------
    ; Testcase 1 initialization
    ; Remove this block before submission if the grader provides
    ; the input values in RAM.
    ;
    ; x1 = 0x12
    ; x2 = 0x08
    ; y1 = 0x0A
    ; y2 = 0x05
    ; ------------------------------------------------------------

    movlw   0x12
    movwf   0x000, c

    movlw   0x08
    movwf   0x001, c

    movlw   0x0A
    movwf   0x002, c

    movlw   0x05
    movwf   0x003, c

    ; ------------------------------------------------------------
    ; A1 = x1 + x2
    ; Store A1 at 0x010
    ; ------------------------------------------------------------

    movf    0x000, w, c
    addwf   0x001, w, c
    movwf   0x010, c

    ; ------------------------------------------------------------
    ; A2 = y1 + y2
    ; Store A2 at 0x011
    ; ------------------------------------------------------------

    movf    0x002, w, c
    addwf   0x003, w, c
    movwf   0x011, c

    ; ------------------------------------------------------------
    ; Compare A1 and A2
    ;
    ; WREG = A2
    ; CPFSEQ 0x010 compares A1 with WREG
    ; ------------------------------------------------------------

    movf    0x011, w, c

    ; If A1 == A2, skip the next instruction
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