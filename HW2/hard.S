#include "xc.inc"
PSECT testcase, local, class=STRCODE, reloc=1
ORG 0x5000
; Sequence length, 0x02~0xff
DW  0x20
; The following is the input sequence.
; Here is an example sequence of length 64.
DB  0x88, 0x7b, 0xb6, 0xbd, 0xf5, 0xfa, 0x8c, 0x9a
DB  0xca, 0xec, 0x95, 0x69, 0x3f, 0x33, 0xae, 0x23
DB  0x3d, 0x29, 0x85, 0x80, 0x44, 0x8a, 0x99, 0xc9
DB  0x41, 0x09, 0xc1, 0x5c, 0x66, 0xba, 0xac, 0xa4
DB  0xe0, 0xcb, 0x64, 0xc6, 0xa1, 0xa5, 0x2f, 0xa8
DB  0x7c, 0xd3, 0x93, 0x0c, 0x07, 0xd1, 0xd2, 0xc6
DB  0x11, 0x34, 0x1f, 0x2b, 0x31, 0x72, 0x4e, 0x71
DB  0xc3, 0xb9, 0xf6, 0xf0, 0x74, 0x6c, 0x5f, 0x70

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
