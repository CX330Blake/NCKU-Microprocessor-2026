#include <xc.h>

#pragma config OSC = INTIO67
#pragma config WDT = OFF
#pragma config LVP = OFF
#pragma config XINST = OFF

extern unsigned char gcd(unsigned char a, unsigned char b);

volatile unsigned char ans;

void main(void)
{
    ans = gcd(144, 233);

    /* Keep the result available in the debugger's Watches window. */
    while (1) {
    }
}
