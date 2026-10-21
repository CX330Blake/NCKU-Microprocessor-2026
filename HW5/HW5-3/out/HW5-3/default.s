subtitle "Microchip MPLAB XC8 C Compiler v3.10 (Free license) build 20250813170317 Og9 "

pagewidth 120

	opt flic

	processor	18F4520
include "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/18f4520.cgen.inc"
getbyte	macro	val,pos
	(((val) >> (8 * pos)) and 0xff)
endm
byte0	macro	val
	(getbyte(val,0))
endm
byte1	macro	val
	(getbyte(val,1))
endm
byte2	macro	val
	(getbyte(val,2))
endm
byte3	macro	val
	(getbyte(val,3))
endm
byte4	macro	val
	(getbyte(val,4))
endm
byte5	macro	val
	(getbyte(val,5))
endm
byte6	macro	val
	(getbyte(val,6))
endm
byte7	macro	val
	(getbyte(val,7))
endm
getword	macro	val,pos
	(((val) >> (8 * pos)) and 0xffff)
endm
word0	macro	val
	(getword(val,0))
endm
word1	macro	val
	(getword(val,2))
endm
word2	macro	val
	(getword(val,4))
endm
word3	macro	val
	(getword(val,6))
endm
gettword	macro	val,pos
	(((val) >> (8 * pos)) and 0xffffff)
endm
tword0	macro	val
	(gettword(val,0))
endm
tword1	macro	val
	(gettword(val,3))
endm
tword2	macro	val
	(gettword(val,6))
endm
getdword	macro	val,pos
	(((val) >> (8 * pos)) and 0xffffffff)
endm
dword0	macro	val
	(getdword(val,0))
endm
dword1	macro	val
	(getdword(val,4))
endm
clrc   macro
	bcf	status,0
endm
setc   macro
	bsf	status,0
endm
clrz   macro
	bcf	status,2
endm
setz   macro
	bsf	status,2
endm
skipnz macro
	btfsc	status,2
endm
skipz  macro
	btfss	status,2
endm
skipnc macro
	btfsc	status,0
endm
skipc  macro
	btfss	status,0
endm
pushw macro
	movwf postinc1
endm
pushf macro arg1
	movff arg1, postinc1
endm
popw macro
	movf postdec1,f
	movf indf1,w
endm
popf macro arg1
	movf postdec1,f
	movff indf1,arg1
endm
popfc macro arg1
	movff plusw1,arg1
	decfsz fsr1,f
endm
skiprom24 macro arg1
	btfsc arg1,7
endm
	global	__ramtop
	global	__accesstop
# 38 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PORTA equ 0F80h ;# 
# 257 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PORTB equ 0F81h ;# 
# 436 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PORTC equ 0F82h ;# 
# 618 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PORTD equ 0F83h ;# 
# 760 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PORTE equ 0F84h ;# 
# 963 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
LATA equ 0F89h ;# 
# 1075 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
LATB equ 0F8Ah ;# 
# 1187 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
LATC equ 0F8Bh ;# 
# 1299 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
LATD equ 0F8Ch ;# 
# 1411 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
LATE equ 0F8Dh ;# 
# 1463 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TRISA equ 0F92h ;# 
# 1468 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
DDRA equ 0F92h ;# 
# 1685 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TRISB equ 0F93h ;# 
# 1690 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
DDRB equ 0F93h ;# 
# 1907 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TRISC equ 0F94h ;# 
# 1912 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
DDRC equ 0F94h ;# 
# 2129 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TRISD equ 0F95h ;# 
# 2134 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
DDRD equ 0F95h ;# 
# 2351 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TRISE equ 0F96h ;# 
# 2356 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
DDRE equ 0F96h ;# 
# 2515 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
OSCTUNE equ 0F9Bh ;# 
# 2580 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PIE1 equ 0F9Dh ;# 
# 2657 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PIR1 equ 0F9Eh ;# 
# 2734 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
IPR1 equ 0F9Fh ;# 
# 2811 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PIE2 equ 0FA0h ;# 
# 2877 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PIR2 equ 0FA1h ;# 
# 2943 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
IPR2 equ 0FA2h ;# 
# 3009 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
EECON1 equ 0FA6h ;# 
# 3075 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
EECON2 equ 0FA7h ;# 
# 3082 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
EEDATA equ 0FA8h ;# 
# 3089 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
EEADR equ 0FA9h ;# 
# 3096 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
RCSTA equ 0FABh ;# 
# 3101 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
RCSTA1 equ 0FABh ;# 
# 3306 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TXSTA equ 0FACh ;# 
# 3311 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TXSTA1 equ 0FACh ;# 
# 3562 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TXREG equ 0FADh ;# 
# 3567 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TXREG1 equ 0FADh ;# 
# 3574 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
RCREG equ 0FAEh ;# 
# 3579 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
RCREG1 equ 0FAEh ;# 
# 3586 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
SPBRG equ 0FAFh ;# 
# 3591 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
SPBRG1 equ 0FAFh ;# 
# 3598 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
SPBRGH equ 0FB0h ;# 
# 3605 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
T3CON equ 0FB1h ;# 
# 3717 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TMR3 equ 0FB2h ;# 
# 3724 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TMR3L equ 0FB2h ;# 
# 3731 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TMR3H equ 0FB3h ;# 
# 3738 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
CMCON equ 0FB4h ;# 
# 3828 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
CVRCON equ 0FB5h ;# 
# 3907 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
ECCP1AS equ 0FB6h ;# 
# 3912 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
ECCPAS equ 0FB6h ;# 
# 4069 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PWM1CON equ 0FB7h ;# 
# 4074 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
ECCP1DEL equ 0FB7h ;# 
# 4207 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
BAUDCON equ 0FB8h ;# 
# 4212 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
BAUDCTL equ 0FB8h ;# 
# 4387 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
CCP2CON equ 0FBAh ;# 
# 4466 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
CCPR2 equ 0FBBh ;# 
# 4473 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
CCPR2L equ 0FBBh ;# 
# 4480 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
CCPR2H equ 0FBCh ;# 
# 4487 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
CCP1CON equ 0FBDh ;# 
# 4584 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
CCPR1 equ 0FBEh ;# 
# 4591 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
CCPR1L equ 0FBEh ;# 
# 4598 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
CCPR1H equ 0FBFh ;# 
# 4605 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
ADCON2 equ 0FC0h ;# 
# 4676 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
ADCON1 equ 0FC1h ;# 
# 4761 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
ADCON0 equ 0FC2h ;# 
# 4880 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
ADRES equ 0FC3h ;# 
# 4887 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
ADRESL equ 0FC3h ;# 
# 4894 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
ADRESH equ 0FC4h ;# 
# 4901 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
SSPCON2 equ 0FC5h ;# 
# 4996 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
SSPCON1 equ 0FC6h ;# 
# 5066 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
SSPSTAT equ 0FC7h ;# 
# 5287 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
SSPADD equ 0FC8h ;# 
# 5294 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
SSPBUF equ 0FC9h ;# 
# 5301 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
T2CON equ 0FCAh ;# 
# 5399 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PR2 equ 0FCBh ;# 
# 5404 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
MEMCON equ 0FCBh ;# 
# 5509 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TMR2 equ 0FCCh ;# 
# 5516 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
T1CON equ 0FCDh ;# 
# 5619 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TMR1 equ 0FCEh ;# 
# 5626 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TMR1L equ 0FCEh ;# 
# 5633 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TMR1H equ 0FCFh ;# 
# 5640 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
RCON equ 0FD0h ;# 
# 5773 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
WDTCON equ 0FD1h ;# 
# 5801 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
HLVDCON equ 0FD2h ;# 
# 5806 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
LVDCON equ 0FD2h ;# 
# 6071 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
OSCCON equ 0FD3h ;# 
# 6154 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
T0CON equ 0FD5h ;# 
# 6237 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TMR0 equ 0FD6h ;# 
# 6244 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TMR0L equ 0FD6h ;# 
# 6251 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TMR0H equ 0FD7h ;# 
# 6258 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
STATUS equ 0FD8h ;# 
# 6329 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
FSR2 equ 0FD9h ;# 
# 6336 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
FSR2L equ 0FD9h ;# 
# 6343 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
FSR2H equ 0FDAh ;# 
# 6350 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PLUSW2 equ 0FDBh ;# 
# 6357 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PREINC2 equ 0FDCh ;# 
# 6364 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
POSTDEC2 equ 0FDDh ;# 
# 6371 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
POSTINC2 equ 0FDEh ;# 
# 6378 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
INDF2 equ 0FDFh ;# 
# 6385 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
BSR equ 0FE0h ;# 
# 6392 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
FSR1 equ 0FE1h ;# 
# 6399 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
FSR1L equ 0FE1h ;# 
# 6406 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
FSR1H equ 0FE2h ;# 
# 6413 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PLUSW1 equ 0FE3h ;# 
# 6420 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PREINC1 equ 0FE4h ;# 
# 6427 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
POSTDEC1 equ 0FE5h ;# 
# 6434 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
POSTINC1 equ 0FE6h ;# 
# 6441 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
INDF1 equ 0FE7h ;# 
# 6448 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
WREG equ 0FE8h ;# 
# 6460 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
FSR0 equ 0FE9h ;# 
# 6467 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
FSR0L equ 0FE9h ;# 
# 6474 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
FSR0H equ 0FEAh ;# 
# 6481 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PLUSW0 equ 0FEBh ;# 
# 6488 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PREINC0 equ 0FECh ;# 
# 6495 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
POSTDEC0 equ 0FEDh ;# 
# 6502 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
POSTINC0 equ 0FEEh ;# 
# 6509 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
INDF0 equ 0FEFh ;# 
# 6516 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
INTCON3 equ 0FF0h ;# 
# 6608 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
INTCON2 equ 0FF1h ;# 
# 6678 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
INTCON equ 0FF2h ;# 
# 6795 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PROD equ 0FF3h ;# 
# 6802 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PRODL equ 0FF3h ;# 
# 6809 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PRODH equ 0FF4h ;# 
# 6816 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TABLAT equ 0FF5h ;# 
# 6825 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TBLPTR equ 0FF6h ;# 
# 6832 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TBLPTRL equ 0FF6h ;# 
# 6839 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TBLPTRH equ 0FF7h ;# 
# 6846 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TBLPTRU equ 0FF8h ;# 
# 6855 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PCLAT equ 0FF9h ;# 
# 6862 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PC equ 0FF9h ;# 
# 6869 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PCL equ 0FF9h ;# 
# 6876 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PCLATH equ 0FFAh ;# 
# 6883 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
PCLATU equ 0FFBh ;# 
# 6890 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
STKPTR equ 0FFCh ;# 
# 6964 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TOS equ 0FFDh ;# 
# 6971 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TOSL equ 0FFDh ;# 
# 6978 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TOSH equ 0FFEh ;# 
# 6985 "/Users/CX330/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8/pic/include/proc/pic18f4520.h"
TOSU equ 0FFFh ;# 
	debug_source C
	FNCALL	_main,_evaluate
	FNROOT	_main
	global	_ans
; #config settings
	config pad_punits      = on
	config apply_mask      = off
	config ignore_cmsgs    = off
	config default_configs = off
	config default_idlocs  = off
	config OSC = "INTIO67"
	config WDT = "OFF"
	config LVP = "OFF"
	config XINST = "OFF"
	file	"out/HW5-3/default.s"
	line	#
psect	cinit,class=CODE,delta=1,reloc=2
global __pcinit
__pcinit:
global start_initialization
start_initialization:

global __initialization
__initialization:
psect	bssCOMRAM,class=COMRAM,space=1,noexec,lowdata
global __pbssCOMRAM
__pbssCOMRAM:
	global	_ans
_ans:
       ds      2
	file	"out/HW5-3/default.s"
	line	#
psect	cinit
; Clear objects allocated to COMRAM (2 bytes)
	global __pbssCOMRAM
clrf	(__pbssCOMRAM+1)&0xffh,c
clrf	(__pbssCOMRAM+0)&0xffh,c
psect cinit,class=CODE,delta=1
global end_of_initialization,__end_of__initialization

;End of C runtime variable initialization code

end_of_initialization:
__end_of__initialization:
movlb 0
goto _main	;jump to C main() function
psect	cstackCOMRAM,class=COMRAM,space=1,noexec,lowdata
global __pcstackCOMRAM
__pcstackCOMRAM:
?_main:	; 1 bytes @ 0x0
?_evaluate:	; 2 bytes @ 0x0
	global	_evaluate$0
_evaluate$0:	; 2 bytes @ 0x0
??_evaluate:	; 1 bytes @ 0x0
??_main:	; 1 bytes @ 0x0
	ds   2
	global	_evaluate$1
_evaluate$1:	; 1 bytes @ 0x2
	ds   1
	global	_evaluate$2
_evaluate$2:	; 2 bytes @ 0x3
	ds   2
	global	_evaluate$3
_evaluate$3:	; 1 bytes @ 0x5
	ds   1
	global	_evaluate$4
_evaluate$4:	; 2 bytes @ 0x6
	ds   2
	global	_evaluate$5
_evaluate$5:	; 1 bytes @ 0x8
	ds   1
	global	_evaluate$6
_evaluate$6:	; 2 bytes @ 0x9
	ds   2
;!
;!Data Sizes:
;!    Strings     0
;!    Constant    0
;!    Data        0
;!    BSS         2
;!    Persistent  0
;!    Stack       0
;!
;!Auto Spaces:
;!    Space          Size  Autos    Used
;!    COMRAM          127      0       2
;!    BANK0           128      0       0
;!    BANK1           256      0       0
;!    BANK2           256      0       0
;!    BANK3           256      0       0
;!    BANK4           256      0       0
;!    BANK5           256      0       0

;!
;!Pointer List with Targets:
;!
;!    None.


;!
;!Critical Paths under _main in COMRAM
;!
;!    None.
;!
;!Critical Paths under _main in BANK0
;!
;!    None.
;!
;!Critical Paths under _main in BANK1
;!
;!    None.
;!
;!Critical Paths under _main in BANK2
;!
;!    None.
;!
;!Critical Paths under _main in BANK3
;!
;!    None.
;!
;!Critical Paths under _main in BANK4
;!
;!    None.
;!
;!Critical Paths under _main in BANK5
;!
;!    None.

;;
;;Main: autosize = 0, tempsize = 0, incstack = 0, save=0
;;

;!
;!Call Graph Tables:
;!
;! ---------------------------------------------------------------------------------
;! (Depth) Function   	        Calls       Base Space   Used Autos Params    Refs
;! ---------------------------------------------------------------------------------
;! (0) _main                                                 0     0      0       7
;!                           _evaluate
;! ---------------------------------------------------------------------------------
;! (1) _evaluate                                            11     0     11       7
;! ---------------------------------------------------------------------------------
;! Estimated maximum stack depth 1
;! ---------------------------------------------------------------------------------
;!
;! Call Graph Graphs:
;!
;! _main (ROOT)
;!   _evaluate
;!

;!Address spaces:

;!Name               Size   Autos  Total    Usage
;!BIGRAM            1535      0       0      0.0%
;!BITBANK5           256      0       0      0.0%
;!BANK5              256      0       0      0.0%
;!BITBANK4           256      0       0      0.0%
;!BANK4              256      0       0      0.0%
;!BITBANK3           256      0       0      0.0%
;!BANK3              256      0       0      0.0%
;!BITBANK2           256      0       0      0.0%
;!BANK2              256      0       0      0.0%
;!BITBANK1           256      0       0      0.0%
;!BANK1              256      0       0      0.0%
;!BITBIGSFR          128      0       0      0.0%
;!BITBANK0           128      0       0      0.0%
;!BANK0              128      0       0      0.0%
;!BITCOMRAM          127      0       0      0.0%
;!COMRAM             127      0       2      1.6%
;!STACK                0      0       0      0.0%
;!DATA                 0      0       2      0.0%

	global	_main

;; *************** function _main *****************
;; Defined at:
;;		line 14 in file "main.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr0l, fsr0h, fsr1l, fsr1h, fsr1l, fsr1h, fsr2l, fsr2h, bsr, status,2, status,0, pcl, pclath, pclatu, btemp0, btemp1, btemp2, btemp3, btemp4, btemp5, btemp6, btemp7, btemp40, btemp41, btemp42, btemp43, btemp44, btemp45, btemp46, btemp47, btemp48, btemp49, btemp50, btemp51, btemp52, btemp53, btemp54, btemp55, tosl, structret, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5
;;      Params:         0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_evaluate
;; This function is called by:
;;		Startup code after reset
;; This function uses a non-reentrant model
;;
psect	text0,class=CODE,space=0,reloc=2,group=0
	file	"main.c"
	line	14
global __ptext0
__ptext0:
psect	text0
	file	"main.c"
	line	14
	
_main:
;incstack = 0
	callstack 30
	line	16
	
l800:
	clrf	((c:_evaluate$0+1))^00h,c
	movlw	low(02h)
	movwf	((c:_evaluate$0))^00h,c
	movlw	low(02Bh)
	movwf	((c:_evaluate$1))^00h,c
	clrf	((c:_evaluate$2+1))^00h,c
	movlw	low(03h)
	movwf	((c:_evaluate$2))^00h,c
	movlw	low(02Ah)
	movwf	((c:_evaluate$3))^00h,c
	clrf	((c:_evaluate$4+1))^00h,c
	movlw	low(04h)
	movwf	((c:_evaluate$4))^00h,c
	movlw	low(02Dh)
	movwf	((c:_evaluate$5))^00h,c
	clrf	((c:_evaluate$6+1))^00h,c
	movlw	low(05h)
	movwf	((c:_evaluate$6))^00h,c
	call	_evaluate	;wreg free
	movff	0+?_evaluate,(c:_ans)	;volatile
	movff	1+?_evaluate,(c:_ans+1)	;volatile
	line	19
	
l9:
	line	20
	
l10:
	goto	l9
	global	start
	goto	start
	callstack 0
	line	21
GLOBAL	__end_of_main
	__end_of_main:
	signat	_main,89
	global	_evaluate
psect	smallconst,class=SMALLCONST,space=0,reloc=2,noexec
global __psmallconst
__psmallconst:
	db	0
	db 0	; dummy byte at the end
	global	__smallconst
__smallconst	set	__psmallconst
	global	__mediumconst
__mediumconst	set	__psmallconst
	GLOBAL	__activetblptr
__activetblptr	EQU	0
	psect	intsave_regs,class=BIGRAM,space=1,noexec
	PSECT	rparam,class=COMRAM,space=1,noexec
	GLOBAL	__Lrparam
	FNCONF	rparam,??,?
	GLOBAL	___rparam_used
	___rparam_used EQU 1
	GLOBAL	___param_bank
	___param_bank EQU 0
GLOBAL	__Lparam, __Hparam
GLOBAL	__Lrparam, __Hrparam
__Lparam	EQU	__Lrparam
__Hparam	EQU	__Hrparam
	end
