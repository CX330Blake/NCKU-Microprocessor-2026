#include <xc.inc>

CONFIG WDT = OFF
CONFIG LVP = OFF
CONFIG XINST = OFF

RESULT EQU 0x00
PRIME_X EQU 0x10
CANDIDATE EQU 0x30
NEXT_VALUE EQU 0x31

GLOBAL main, done, solve_q3c

PSECT resetVec,class=CODE,reloc=2
resetVec:
    goto main

PSECT code,class=CODE,reloc=2
main:
    movlw 11
    movwf PRIME_X, 0
    call solve_q3c
done:
    bra done

; Input: prime X, 2 < X < 256, in RAM 0x10 (preserved).
; Output: smallest unsigned Y with Y OR (Y + 1) = X, in RAM 0x00.
; Clobbers: WREG, STATUS, RAM 0x30..0x31.
; Ascending search makes the first match minimal. Every allowed X is odd,
; so Y = X - 1 is a guaranteed match; addition cannot overflow here.
; Primality is an input precondition, not checked by this routine.
solve_q3c:
    clrf CANDIDATE, 0
candidate_loop:
    incf CANDIDATE, 0, 0
    movwf NEXT_VALUE, 0
    movf CANDIDATE, 0, 0
    iorwf NEXT_VALUE, 0, 0
    xorwf PRIME_X, 0, 0
    bz candidate_found
    incf CANDIDATE, 1, 0
    bra candidate_loop
candidate_found:
    movf CANDIDATE, 0, 0
    movwf RESULT, 0
    return

END resetVec
