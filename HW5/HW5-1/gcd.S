; Equivalent C pseudocode (valid inputs: 1..255):
; unsigned char gcd(unsigned char a, unsigned char b) {
;     while (a != b) {
;         if (a > b) {
;             a -= b;
;         } else {
;             b -= a;
;         }
;     }
;     return a;
; }

GLOBAL _gcd
EXTRN _gcd$1

PSECT gcd_data, class=COMRAM, space=1, noexec, lowdata
gcd_a: DS 1
gcd_b: DS 1

PSECT gcd_text, local, class=CODE, reloc=2

; XC8 passes a in WREG and b in the linker-allocated _gcd$1 slot.
; Inputs are in the assignment's range 1..255.
_gcd:
    MOVWF gcd_a, a
    MOVFF _gcd$1, gcd_b

; Subtraction preserves the GCD; each iteration reduces the larger value.
gcd_loop:
    MOVF gcd_b, w, a
    SUBWF gcd_a, w, a
    BZ gcd_done
    BC gcd_reduce_a

    MOVF gcd_a, w, a
    SUBWF gcd_b, f, a
    BRA gcd_loop

gcd_reduce_a:
    MOVWF gcd_a, a
    BRA gcd_loop

gcd_done:
    MOVF gcd_a, w, a
    MOVWF _gcd$1, a
    RETURN
