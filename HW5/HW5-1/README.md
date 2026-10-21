# HW5-1: Basic GCD

PIC18F4520 firmware mixing XC8 C with PIC18 assembly.

## Files

| Path | Purpose |
|------|---------|
| `main.c` | Calls `gcd(252, 105)` and stores the result in `volatile unsigned char ans`. |
| `gcd.S` | Implements `unsigned char gcd(unsigned char a, unsigned char b)` for inputs from 1 to 255. |
| `.vscode/HW5-1.mplab.json` | MPLAB project using XC8 3.10 and PIC18Fxxxx_DFP 1.8.178. |
| `out/HW5-1/` | Generated firmware and build artifacts; not submission sources. |

## Implementation

XC8 passes the first byte argument in WREG and the second in `_gcd$1`.
The assembly imports that parameter symbol and reserves two scratch bytes in a
linker-allocated access-bank psect. No RAM addresses are hardcoded.

The subtraction form of Euclid's algorithm repeatedly reduces the larger
operand until both are equal. The result is returned in WREG and written to
the parameter/return slot. The function uses static scratch storage and is
not reentrant; do not call it concurrently from an interrupt.

## Build

Open this directory as an MPLAB for VS Code project and build with XC8 3.10,
not the standalone PIC-AS toolchain.

Alternatively, on this workstation:

```sh
mkdir -p out/HW5-1
xc8-cc -mcpu=18F4520 \
  -mdfp="$HOME/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8" \
  -O0 -gdwarf-3 -o out/HW5-1/default.elf main.c gcd.S
```

`gcd.S` uses the preprocessed assembly extension but needs no preprocessor directives or `xc.inc`.
XC8 may report warning 1311 for an unspecified configuration word and use
the device default. Watchdog, low-voltage programming, and extended
instruction mode are explicitly disabled in `main.c`.

## Demonstration in Watches

1. Select the PIC18F4520 simulator and start a debug session.
2. Set a breakpoint inside the `while (1)` loop, after the assignment to `ans`.
3. Add `ans` to Watches and run to the breakpoint.
4. Expect decimal `21` (hexadecimal `0x15`).
5. Change the arguments in `main.c`, rebuild, and restart debugging for each case.

| Call | Expected result |
|------|-----------------|
| `gcd(5, 10)` | 5 |
| `gcd(252, 105)` | 21 |
| `gcd(17, 5)` | 1 |

## Verification

XC8 3.10 compilation and linking succeeded. A temporary instruction-level
smoke harness executed the generated PIC18 HEX from reset through the C
caller and observed `ans = 21`. It also executed the compiled GCD routine
for all 65,025 pairs in `1..255`, comparing both WREG and the return slot
against a reference GCD. All pairs passed.

This check is not the official MPLAB simulator. Watches display and physical
hardware execution have not been verified.

## Submission

Submit **`gcd.S` only**. Do not submit `main.c`, the README, project settings,
or generated artifacts. The submission page's October 11 update permits
uploading individual files without a ZIP. If a ZIP is required, create one
containing only `gcd.S`.

Sources:
- Assignment: `../requirements.pdf`, Basic section.
- [Lab 5 instructions and submission rules](https://hackmd.io/@mprocessor2026/S1feRxt9ze#How-to-submit-your-code).
