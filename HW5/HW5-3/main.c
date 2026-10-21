#include <xc.h>

#pragma config OSC = INTIO67
#pragma config WDT = OFF
#pragma config LVP = OFF
#pragma config XINST = OFF

extern unsigned int evaluate(unsigned int a, char op1, unsigned int b,
                             char op2, unsigned int c, char op3,
                             unsigned int d);

volatile unsigned int ans;

void main(void)
{
    ans = evaluate(50, '-', 20, '-', 10, '*', 2);

    /* Keep the result available in the debugger's Watches window. */
    while (1) {
    }
}
