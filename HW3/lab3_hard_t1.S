PROCESSOR 18F4520
#include <xc.inc>

CONFIG OSC = INTIO67
CONFIG WDT = OFF
CONFIG XINST = OFF

PSECT resetVec,class=CODE,reloc=2

resetVec:
    goto main

PSECT code

PC_L equ 0x100
PC_H equ 0x101
TARGET equ 0x102

main:
    ; Clear simulated memory BEFORE loading the supplied input.
    lfsr 0, 0x000

clear_memory:
    clrf POSTINC0, 0
    btfss FSR0H, 0, 0
    bra clear_memory

    ; Instruction Start: replace this block with the TA's input.
        MOVLW   0x0D
        MOVWF   0x00, 0
        MOVLW   0x0D
        MOVWF   0x01, 0
        MOVLW   0x03
        MOVWF   0x02, 0
        MOVLW   0x0C
        MOVWF   0x03, 0
        MOVLW   0x0D
        MOVWF   0x04, 0
        MOVLW   0x06
        MOVWF   0x05, 0

        MOVLW   0x0D
        MOVWF   0x06, 0
        MOVLW   0x0E
        MOVWF   0x07, 0
        MOVLW   0x09
        MOVWF   0x08, 0
        MOVLW   0x0F
        MOVWF   0x09, 0
        MOVLW   0x0F
        MOVWF   0x0A, 0
        MOVLW   0xFF
        MOVWF   0x0B, 0

        MOVLW   0x03
        MOVWF   0x0C, 0
        MOVLW   0x10
        MOVWF   0x0D, 0
        MOVLW   0x05
        MOVWF   0x0E, 0
        MOVLW   0x00
        MOVWF   0x0F, 0
    ; Instruction End

    movlb 0x01 ; interpreter state is in bank 1
    clrf BANKMASK(PC_L), 1
    clrf BANKMASK(PC_H), 1
    clrf FSR1H, 0
    clrf FSR2H, 0

execute:
    ; Terminate if the unsigned 16-bit PC is >= 0x00FE.
    movf BANKMASK(PC_H), 0, 1
    bnz done
    movlw 0xFE
    cpfslt BANKMASK(PC_L), 1
    bra done

    ; Fetch all three operands from the current simulated memory.
    clrf FSR0H, 0
    movff PC_L, FSR0L
    movff POSTINC0, FSR1L ; a: FSR1 points to memory[a]
    movff POSTINC0, FSR2L ; b: FSR2 points to memory[b]
    movf INDF0, 0, 0
    movwf BANKMASK(TARGET), 1 ; c

    movf INDF1, 0, 0
    subwf INDF2, 1, 0 ; memory[b] = memory[b] - memory[a]
    bz take_branch
    bn take_branch ; test the wrapped result's sign bit

    ; Sequential PC += 3, preserving carry into the high byte.
    movlw 0x03
    addwf BANKMASK(PC_L), 1, 1
    movlw 0x00
    addwfc BANKMASK(PC_H), 1, 1
    bra execute

take_branch:
    movff TARGET, PC_L
    clrf BANKMASK(PC_H), 1
    bra execute

done:
    bra done

END resetVec
