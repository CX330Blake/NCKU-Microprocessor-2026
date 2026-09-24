#include "xc.inc"
PSECT testcase, local, class=STRCODE, reloc=1
ORG 0x5000
; Sequence length, 0x02~0xff
DW  0xff
; The following is the input sequence.
; Here is a random sequence of length 255.
DB  0x09, 0x0e, 0x97, 0x35, 0x02, 0x71, 0x41, 0x1f
DB  0xd4, 0x5c, 0x89, 0x11, 0xc2, 0xe4, 0x6b, 0x0c
DB  0x82, 0x8b, 0x61, 0x83, 0x87, 0x83, 0x65, 0x7f
DB  0x75, 0x70, 0x94, 0x55, 0x5e, 0xa0, 0x05, 0xd2
DB  0xd5, 0x3d, 0x1c, 0x95, 0x4e, 0x51, 0xce, 0x1a
DB  0x01, 0xb2, 0x09, 0xcf, 0x69, 0x57, 0x08, 0x68
DB  0xd7, 0x9e, 0x05, 0x8b, 0xbc, 0x97, 0x51, 0x38
DB  0x70, 0xda, 0x8f, 0xac, 0x9a, 0x1d, 0x7f, 0x24
DB  0x7b, 0x96, 0xeb, 0x55, 0x8e, 0x5f, 0x47, 0xb1
DB  0xe0, 0xb2, 0x60, 0xca, 0x56, 0x3b, 0x7e, 0x81
DB  0x6b, 0x29, 0x68, 0x0b, 0x75, 0x5e, 0x8d, 0xf1
DB  0x5f, 0x46, 0x17, 0x9e, 0x3e, 0xa7, 0x18, 0x21
DB  0x2b, 0x0e, 0x61, 0xa6, 0x6d, 0xd7, 0x23, 0xf9
DB  0x96, 0xc7, 0x2a, 0x80, 0xdf, 0x45, 0x22, 0x73
DB  0xc1, 0xaf, 0x4f, 0x28, 0x44, 0xee, 0xbd, 0x68
DB  0x0a, 0x60, 0x17, 0x00, 0x96, 0xd6, 0x75, 0x6b
DB  0x9d, 0xf1, 0xe8, 0x3a, 0xf9, 0xf3, 0xb4, 0x4f
DB  0x8b, 0x1b, 0x7c, 0xc7, 0xd5, 0xbd, 0x56, 0xa0
DB  0xb7, 0x53, 0x48, 0x8a, 0xd5, 0xbf, 0x97, 0xdc
DB  0x70, 0xd8, 0xc0, 0x41, 0xc9, 0xe3, 0xb1, 0xdc
DB  0x56, 0x5e, 0xf5, 0xd7, 0x62, 0x3d, 0x03, 0xc5
DB  0x7b, 0x1f, 0x1a, 0x05, 0x2b, 0x4a, 0xeb, 0x9d
DB  0xe2, 0xa5, 0x78, 0xdb, 0x83, 0x93, 0x95, 0x8a
DB  0x53, 0x08, 0xfa, 0x98, 0x52, 0x2d, 0x72, 0x29
DB  0x95, 0x3f, 0xb7, 0x47, 0x31, 0x4f, 0x87, 0x58
DB  0xc7, 0x3f, 0x0b, 0xc3, 0x55, 0x50, 0x70, 0xc3
DB  0x92, 0xab, 0xc8, 0xa9, 0x05, 0xf4, 0x25, 0x82
DB  0xf2, 0x83, 0xcb, 0xf6, 0x23, 0xe9, 0xee, 0x58
DB  0x10, 0x0f, 0x93, 0xc8, 0x3b, 0x52, 0xa1, 0x22
DB  0x37, 0xe2, 0xaa, 0xd8, 0x19, 0x44, 0x65, 0x52
DB  0x3e, 0x57, 0x30, 0x62, 0x7d, 0xe2, 0xf3, 0x51
DB  0x3d, 0x9b, 0x3d, 0xb0, 0x9a, 0x2f, 0x64


PSECT main, local, abs, class=CODE, reloc=2
ORG 0x00
; Data loader, !DO NOT MODIFY!
DW 0x6af6, 0x6af8, 0x0e50, 0x6ef7, 0x0009, 0x50f5, 0x6f00, 0xee01
DW 0xf000, 0x000b, 0xcff5, 0xffee, 0x62e9, 0xd7fb, 0xee00, 0xf000

SEQ_LEN     equ 0x00

STACK_SP    equ 0x20

QS_LOW      equ 0x21
QS_HIGH     equ 0x22
QS_PIVOT    equ 0x23
QS_I        equ 0x24
QS_J        equ 0x25
QS_CURR     equ 0x26
QS_TEMP     equ 0x27 ; for swap
QS_P        equ 0x28 ; partition result p

PUSH_LOW    equ 0x29
PUSH_HIGH   equ 0x2A

main:
    ; --------------------------------------------------------
    ; Explicit stack:
    ;
    ;   0x300 + SP : low index
    ;   0x400 + SP : high index
    ;
    ; Initially push [0, length - 1].
    ; --------------------------------------------------------

    clrf    STACK_SP,c

    clrf    PUSH_LOW,c

    movf    SEQ_LEN,w,c
    addlw   0xFF                ; length - 1
    movwf   PUSH_HIGH,c

    call    push_range


; ============================================================
; Iterative Quicksort
; ============================================================

sort_loop:
    ; If stack is empty, sorting is finished.
    movf    STACK_SP,w,c
    bz      sort_done

    ; --------------------------------------------------------
    ; Pop one [low, high] pair.
    ; --------------------------------------------------------

    decf    STACK_SP,f,c

    ; low = stack_low[SP]
    movlw   0x03
    movwf   FSR0H,c

    movf    STACK_SP,w,c
    movwf   FSR0L,c

    movf    INDF0,w,c
    movwf   QS_LOW,c

    ; high = stack_high[SP]
    movlw   0x04
    movwf   FSR1H,c

    movf    STACK_SP,w,c
    movwf   FSR1L,c

    movf    INDF1,w,c
    movwf   QS_HIGH,c

    ; A single-element range is already sorted.
    movf    QS_HIGH,w,c
    cpfseq  QS_LOW,c
    bra     partition_setup
    bra     sort_loop


; ============================================================
; Lomuto partition
;
; pivot = A[high]
; i = low - 1
;
; for j = low; j < high; j++:
;     if A[j] <= pivot:
;         i++
;         swap(A[i], A[j])
;
; i++
; swap(A[i], A[high])
; p = i
; ============================================================

partition_setup:
    ; --------------------------------------------------------
    ; pivot = A[high]
    ;
    ; Sequence is stored at 0x100 + index.
    ; --------------------------------------------------------

    ; FSR0 = 0x100 + high
    ; pivot = *FSR0
    movlw   0x01
    movwf   FSR0H,c

    movf    QS_HIGH,w,c
    movwf   FSR0L,c

    movf    INDF0,w,c
    movwf   QS_PIVOT,c

    ; i = low - 1
    movf    QS_LOW,w,c
    addlw   0xFF
    movwf   QS_I,c

    ; j = low
    movf    QS_LOW,w,c
    movwf   QS_J,c


partition_loop:
    ; Stop when j == high.
    movf    QS_HIGH,w,c
    cpfseq  QS_J,c
    bra     partition_body
    bra     partition_finish


partition_body:
    ; --------------------------------------------------------
    ; Load A[j].
    ; --------------------------------------------------------

    movlw   0x01
    movwf   FSR0H,c

    movf    QS_J,w,c
    movwf   FSR0L,c

    movf    INDF0,w,c
    movwf   QS_CURR,c

    ; --------------------------------------------------------
    ; if A[j] <= pivot
    ;
    ; CPFSGT skips the next instruction when:
    ;
    ;     file > WREG
    ;
    ; Here:
    ;
    ;     file = A[j]
    ;     WREG = pivot
    ; --------------------------------------------------------

    movf    QS_PIVOT,w,c
    cpfsgt  QS_CURR,c
    bra     partition_take

    bra     partition_next


partition_take:
    ; i++
    incf    QS_I,f,c

    ; --------------------------------------------------------
    ; FSR0 -> A[j]
    ; FSR1 -> A[i]
    ; --------------------------------------------------------

    movlw   0x01
    movwf   FSR1H,c

    movf    QS_I,w,c
    movwf   FSR1L,c

    ; --------------------------------------------------------
    ; Swap A[i] and A[j].
    ; --------------------------------------------------------

    movf    INDF1,w,c
    movwf   QS_TEMP,c

    movf    QS_CURR,w,c
    movwf   INDF1,c

    movf    QS_TEMP,w,c
    movwf   INDF0,c


partition_next:
    incf    QS_J,f,c
    bra     partition_loop


; ============================================================
; Place pivot into its final position.
; ============================================================

partition_finish:
    ; i++
    incf    QS_I,f,c

    ; p = i
    movf    QS_I,w,c
    movwf   QS_P,c

    ; FSR0 -> A[p]
    movlw   0x01
    movwf   FSR0H,c

    movf    QS_P,w,c
    movwf   FSR0L,c

    ; FSR1 -> A[high]
    movlw   0x01
    movwf   FSR1H,c

    movf    QS_HIGH,w,c
    movwf   FSR1L,c

    ; Swap A[p] and A[high].
    movf    INDF0,w,c
    movwf   QS_TEMP,c

    movf    INDF1,w,c
    movwf   INDF0,c

    movf    QS_TEMP,w,c
    movwf   INDF1,c


; ============================================================
; Push right range [p + 1, high] if p < high.
; ============================================================

check_right:
    movf    QS_HIGH,w,c
    cpfslt  QS_P,c
    bra     check_left

    movf    QS_P,w,c
    addlw   0x01
    movwf   PUSH_LOW,c

    movf    QS_HIGH,w,c
    movwf   PUSH_HIGH,c

    call    push_range


; ============================================================
; Push left range [low, p - 1] if p > low.
;
; Right is pushed first and left second, therefore left will
; be processed first because the explicit stack is LIFO.
; ============================================================

check_left:
    movf    QS_LOW,w,c
    cpfsgt  QS_P,c
    bra     sort_loop

    movf    QS_LOW,w,c
    movwf   PUSH_LOW,c

    movf    QS_P,w,c
    addlw   0xFF
    movwf   PUSH_HIGH,c

    call    push_range

    bra     sort_loop


; ============================================================
; push_range
;
; Store one [PUSH_LOW, PUSH_HIGH] range into the explicit
; software stack.
;
; low stack  : 0x300 + STACK_SP
; high stack : 0x400 + STACK_SP
; ============================================================

push_range:
    ; Store low index.
    movlw   0x03
    movwf   FSR0H,c

    movf    STACK_SP,w,c
    movwf   FSR0L,c

    movf    PUSH_LOW,w,c
    movwf   INDF0,c

    ; Store high index.
    movlw   0x04
    movwf   FSR1H,c

    movf    STACK_SP,w,c
    movwf   FSR1L,c

    movf    PUSH_HIGH,w,c
    movwf   INDF1,c

    ; SP++
    incf    STACK_SP,f,c

    return


; ============================================================
; Finished
; ============================================================

sort_done:
    bra     sort_done

END
