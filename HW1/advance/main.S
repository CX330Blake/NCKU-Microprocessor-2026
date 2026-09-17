PROCESSOR 18F4520

#include <xc.inc>

PSECT resetVec,class=CODE,reloc=2

resetVec:
    goto    main

PSECT code

main:
    ; testcase
    ; 0b11010010 = 0xD2
    MOVLW   0b01100110
    MOVWF   0x000

    MOVFF   0x000, 0x020
    CLRF    0x010

    MOVLW   8
    MOVWF   0x021

loop:
    RRCF    0x020, F
    RLCF    0x010, F
    DECFSZ  0x021, F
    BRA     loop

    MOVF    0x000, W
    CPFSEQ  0x010
    BRA     not_equal

    MOVLW   0xFF
    MOVWF   0x011
    BRA     done

not_equal:
    CLRF    0x011

done:
    BRA     done

END resetVec
