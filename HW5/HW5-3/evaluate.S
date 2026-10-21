#include <xc.inc>

GLOBAL _evaluate
EXTRN _evaluate$0, _evaluate$1, _evaluate$2, _evaluate$3
EXTRN _evaluate$4, _evaluate$5, _evaluate$6

PSECT evaluate_data, class=COMRAM, space=1, noexec, lowdata
eval_total: DS 2
eval_term: DS 2
eval_rhs: DS 2
eval_product: DS 2
eval_sign: DS 1
eval_operator: DS 1

PSECT evaluate_text, local, class=CODE, reloc=2

; XC8 allocates each argument slot and returns unsigned int in _evaluate$0.
; Keep one multiplication term and the pending '+' or '-' for that term.
_evaluate:
    CLRF eval_total, a
    CLRF eval_total+1, a
    MOVLW '+'
    MOVWF eval_sign, a
    MOVFF _evaluate$0, eval_term
    MOVFF _evaluate$0+1, eval_term+1

    MOVFF _evaluate$1, eval_operator
    MOVFF _evaluate$2, eval_rhs
    MOVFF _evaluate$2+1, eval_rhs+1
    CALL eval_step

    MOVFF _evaluate$3, eval_operator
    MOVFF _evaluate$4, eval_rhs
    MOVFF _evaluate$4+1, eval_rhs+1
    CALL eval_step

    MOVFF _evaluate$5, eval_operator
    MOVFF _evaluate$6, eval_rhs
    MOVFF _evaluate$6+1, eval_rhs+1
    CALL eval_step

    CALL eval_flush
    MOVFF eval_total, _evaluate$0
    MOVFF eval_total+1, _evaluate$0+1
    RETURN

; Multiplication extends the current term; addition/subtraction ends it.
eval_step:
    MOVF eval_operator, w, a
    XORLW '*'
    BZ eval_multiply
    CALL eval_flush
    MOVFF eval_operator, eval_sign
    MOVFF eval_rhs, eval_term
    MOVFF eval_rhs+1, eval_term+1
    RETURN

; Low 16 bits of (term.low + 256*term.high)*(rhs.low + 256*rhs.high).
; The high*high product contributes only above bit 15 and is unnecessary.
eval_multiply:
    MOVF eval_term, w, a
    MULWF eval_rhs, a
    MOVFF PRODL, eval_product
    MOVFF PRODH, eval_product+1

    MOVF eval_term+1, w, a
    MULWF eval_rhs, a
    MOVF PRODL, w, a
    ADDWF eval_product+1, f, a

    MOVF eval_term, w, a
    MULWF eval_rhs+1, a
    MOVF PRODL, w, a
    ADDWF eval_product+1, f, a

    MOVFF eval_product, eval_term
    MOVFF eval_product+1, eval_term+1
    RETURN

; Commit terms from left to right, propagating carry or borrow to bit 15.
eval_flush:
    MOVF eval_sign, w, a
    XORLW '-'
    BZ eval_subtract
    MOVF eval_term, w, a
    ADDWF eval_total, f, a
    MOVF eval_term+1, w, a
    ADDWFC eval_total+1, f, a
    RETURN

eval_subtract:
    MOVF eval_term, w, a
    SUBWF eval_total, f, a
    MOVF eval_term+1, w, a
    SUBWFB eval_total+1, f, a
    RETURN
