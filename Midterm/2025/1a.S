PROCESSOR 18F4520
#include <xc.inc>

CONFIG OSC = INTIO67
CONFIG WDT = OFF
CONFIG XINST = OFF

input_h    equ 0x000
input_l    equ 0x001
result     equ 0x010
original_h equ 0x020
original_l equ 0x021
count      equ 0x022
reverse_h  equ 0x023
reverse_l  equ 0x024

PSECT resetVec,class=CODE,reloc=2

resetVec:
    goto main

PSECT code

main:
    ; Test input: ignore the leading 1 in 0xC001.
    ; The remaining 15 bits, 0x4001, are a palindrome.
    movlw   0xC0
    movwf   input_h
    movlw   0x01
    movwf   input_l

    movff   input_h, original_h
    movff   input_l, original_l
    bcf     original_h, 7

    clrf    reverse_h
    clrf    reverse_l
    movlw   15
    movwf   count

reverse_loop:
    ; Shift one source bit into C, then append it to reverse.
    bcf     STATUS, 0
    rrcf    original_h, F
    rrcf    original_l, F
    rlcf    reverse_l, F
    rlcf    reverse_h, F
    decfsz  count, F
    bra     reverse_loop

    clrf    result
    movf    input_h, W
    andlw   0x7F
    cpfseq  reverse_h
    bra     done
    movf    input_l, W
    cpfseq  reverse_l
    bra     done
    setf    result

done:
    bra     done

END resetVec
