/**
 * @file main.c
 * @author CX330
 * @date 2026-10-14
 * @brief Main function
 */
#include <xc.h>

extern unsigned int count_primes(unsigned int n, unsigned int m);

volatile unsigned int ans;

int main(void)
{
    ans = count_primes(1, 65535);

    while (1) {
        // Inspect ans in the Watches window; the expected value is 6542.
    }
}
