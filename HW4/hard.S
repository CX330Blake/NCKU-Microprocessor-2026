PROCESSOR 18F4520
#include <xc.inc>

; PDF case 1: 0xC9E3 / 0xB608. Case 2: 0x0004 / 0x0001.
#ifndef TEST_CASE
#define TEST_CASE 2
#endif

; All working bytes are in access RAM. Pairs are high-byte-first.
leftNH      EQU 0x020
leftNL      EQU 0x021
leftDH      EQU 0x022
leftDL      EQU 0x023
rightNH     EQU 0x024
rightNL     EQU 0x025
rightDH     EQU 0x026
rightDL     EQU 0x027
operation   EQU 0x028
resultNH    EQU 0x029
resultNL    EQU 0x02A
resultDH    EQU 0x02B
resultDL    EQU 0x02C
crossH      EQU 0x02D
crossL      EQU 0x02E
gcdAH       EQU 0x02F
gcdAL       EQU 0x030
gcdBH       EQU 0x031
gcdBL       EQU 0x032
quotientH   EQU 0x033
quotientL   EQU 0x034
divisorH    EQU 0x035
divisorL    EQU 0x036
remainderH  EQU 0x037
remainderL  EQU 0x038
differenceH EQU 0x039
differenceL EQU 0x03A
bitCount    EQU 0x03B

; Compute an unsigned 16-bit product. Inputs and output must not overlap.
; The assignment guarantees the complete product fits in 16 bits.
Multiply16 MACRO ah, al, bh, bl, rh, rl
    movf al, w, a
    mulwf bl, a
    movff PRODH, rh
    movff PRODL, rl
    movf ah, w, a
    mulwf bl, a
    movf PRODL, w, a
    addwf rh, f, a
    movf al, w, a
    mulwf bh, a
    movf PRODL, w, a
    addwf rh, f, a
ENDM

LoadLeft MACRO numerator, denominator
    clrf leftNH, a
    movff numerator, leftNL
    clrf leftDH, a
    movff denominator, leftDL
ENDM

LoadRight MACRO numerator, denominator
    clrf rightNH, a
    movff numerator, rightNL
    clrf rightDH, a
    movff denominator, rightDL
ENDM

PSECT resetVec,class=CODE,reloc=2

resetVec:
    goto main

PSECT code

main:
    ; Initialize the eight input bytes; calculate is the custom-input breakpoint.
#if TEST_CASE == 2
    movlw 0x65
    movwf 0x000, a
    movlw 0x17
    movwf 0x001, a
    movlw 0x2E
    movwf 0x002, a
    movlw 0x0b
    movwf 0x003, a
    movlw 0xAB
    movwf 0x004, a
    movlw 0x3E
    movwf 0x005, a
    movlw 0x01
    movwf 0x006, a
    movlw 0x00
    movwf 0x007, a
#else
    movlw 0xC7
    movwf 0x000, a
    movlw 0xE9
    movwf 0x001, a
    movlw 0x11
    movwf 0x002, a
    movlw 0x05
    movwf 0x003, a
    movlw 0x03
    movwf 0x004, a
    movlw 0x28
    movwf 0x005, a
    clrf 0x006, a
    movlw 0x02
    movwf 0x007, a
#endif

calculate:
    ; Only low-precedence op1 followed by high-precedence op2 is right-first.
    ; Bit 1 is clear for + / - and set for * / division.
    btfsc 0x006, 1, a
    bra leftFirst
    btfsc 0x007, 1, a
    bra rightFirst

leftFirst:
    LoadLeft 0x000, 0x001
    LoadRight 0x002, 0x003
    movff 0x006, operation
    call fractionCalc
    LoadRight 0x004, 0x005
    movff 0x007, operation
    call fractionCalc
    bra storeResult

rightFirst:
    LoadLeft 0x002, 0x003
    LoadRight 0x004, 0x005
    movff 0x007, operation
    call fractionCalc
    ; Keep the reduced right-hand expression in the right operand.
    movff leftNH, rightNH
    movff leftNL, rightNL
    movff leftDH, rightDH
    movff leftDL, rightDL
    LoadLeft 0x000, 0x001
    movff 0x006, operation
    call fractionCalc

storeResult:
    movff leftNH, 0x010
    movff leftNL, 0x011
    movff leftDH, 0x012
    movff leftDL, 0x013

done:
    bra done

; Input: leftN/leftD, rightN/rightD and operation (0:+, 1:-, 2:*, 3:/).
; Output: reduced fraction in leftN/leftD. Right operand and input RAM survive.
; Clobbers WREG, STATUS, PRODH/PRODL and scratch 0x029 through 0x03B.
fractionCalc:
    movlw 2
    cpfseq operation, a
    bra checkDivision
    bra multiplyFractions
checkDivision:
    movlw 3
    cpfseq operation, a
    bra addOrSubtract

divideFractions:
    Multiply16 leftNH, leftNL, rightDH, rightDL, resultNH, resultNL
    Multiply16 leftDH, leftDL, rightNH, rightNL, resultDH, resultDL
    bra reduceFraction

multiplyFractions:
    Multiply16 leftNH, leftNL, rightNH, rightNL, resultNH, resultNL
    Multiply16 leftDH, leftDL, rightDH, rightDL, resultDH, resultDL
    bra reduceFraction

addOrSubtract:
    Multiply16 leftNH, leftNL, rightDH, rightDL, resultNH, resultNL
    Multiply16 rightNH, rightNL, leftDH, leftDL, crossH, crossL
    Multiply16 leftDH, leftDL, rightDH, rightDL, resultDH, resultDL
    btfsc operation, 0, a
    bra subtractFractions
    movf crossL, w, a
    addwf resultNL, f, a
    movf crossH, w, a
    addwfc resultNH, f, a
    bra reduceFraction
subtractFractions:
    movf crossL, w, a
    subwf resultNL, f, a
    movf crossH, w, a
    subwfb resultNH, f, a

reduceFraction:
    movff resultNH, gcdAH
    movff resultNL, gcdAL
    movff resultDH, gcdBH
    movff resultDL, gcdBL
    call GCD

    ; Divide both raw results by the same GCD.
    movff gcdAH, divisorH
    movff gcdAL, divisorL
    movff resultNH, quotientH
    movff resultNL, quotientL
    call divide16
    movff quotientH, leftNH
    movff quotientL, leftNL
    movff resultDH, quotientH
    movff resultDL, quotientL
    call divide16
    movff quotientH, leftDH
    movff quotientL, leftDL
    return

; Euclid's algorithm: (A, B) = (B, A % B) until B is zero.
; Input: gcdA, gcdB. Output: gcdA = GCD; gcdB = 0.
; Handles a zero numerator: GCD(0, denominator) = denominator.
GCD:
gcdLoop:
    movf gcdBH, w, a
    iorwf gcdBL, w, a
    bz gcdDone
    movff gcdAH, quotientH
    movff gcdAL, quotientL
    movff gcdBH, divisorH
    movff gcdBL, divisorL
    call divide16
    movff gcdBH, gcdAH
    movff gcdBL, gcdAL
    movff remainderH, gcdBH
    movff remainderL, gcdBL
    bra gcdLoop
gcdDone:
    return

; Unsigned restoring division, exactly 16 bit steps.
; Input: quotient = dividend, divisor != 0.
; Output: quotient and remainder; divisor is preserved.
; Clobbers WREG, STATUS, difference and bitCount.
divide16:
    clrf remainderH, a
    clrf remainderL, a
    movlw 16
    movwf bitCount, a
divideLoop:
    bcf STATUS, 0, a
    rlcf quotientL, f, a
    rlcf quotientH, f, a
    rlcf remainderL, f, a
    rlcf remainderH, f, a

    movf divisorL, w, a
    subwf remainderL, w, a
    movwf differenceL, a
    movf divisorH, w, a
    subwfb remainderH, w, a
    movwf differenceH, a
    bnc nextDivisionBit
    movff differenceH, remainderH
    movff differenceL, remainderL
    bsf quotientL, 0, a
nextDivisionBit:
    decfsz bitCount, f, a
    bra divideLoop
    return
END resetVec
