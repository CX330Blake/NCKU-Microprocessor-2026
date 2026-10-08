
# HW4

## Structure

| Path                   | Purpose                                                                                                                             |
|------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| _build                 | The [CMake build tree](https://cmake.org/cmake/help/latest/manual/cmake.1.html#introduction-to-cmake-buildsystems), can be deleted. |
| cmake                  | Generated [CMake](https://cmake.org/) files. May be deleted if user.cmake has not been added                                        |
| .vscode                | See [VSCode](https://code.visualstudio.com/docs/getstarted/settings)                                                                |
| .vscode/settings.json  | Workspace specific settings                                                                                                         |
| .vscode/HW4.mplab.json | The MPLAB project file, should not be deleted                                                                                       |
| out                    | Final build artifacts                                                                                                               |

## Basic: multiply and add

`basic.S` defines and invokes `Mul_Add x1, x2, y1, y2` to compute
`x1 * x2 + y1 * y2` using unsigned 8-bit inputs and 16-bit arithmetic.
Inputs are at `0x000` through `0x003`; the result high byte is at `0x010`
and the low byte is at `0x011`. The macro preserves input RAM and clobbers
WREG, STATUS, PRODH and PRODL. The final sum must fit in 16 bits.

`TEST_CASE` defaults to 1 (`0x037E` expected). Set it to 2 for the second
PDF example (`0xAA80` expected). To provide custom inputs, break at
`calculate` after initialization and edit the four input bytes.
Run to `done` to inspect the result.

Build `basic.S`, `advanced.S` and `hard.S` separately: each has its own
reset entry and standalone program. Place `resetVec` at program address
zero when linking (PIC-AS option `-Wl,-presetVec=0h`).

## Advanced: nibble reversal

`advanced.S` implements the Advance problem for the PIC18F4520.
`main` initializes `0x000:0x001` from `TEST_INPUT`, which defaults to `0x1234`.
Change `TEST_INPUT` in the source or define it at build time to select another
case. The source lists expected results for both PDF examples and zero/boundary
cases. To supply input through the debugger instead, break at `reverseStart`
and set the high byte at `0x000` and low byte at `0x001`.
At `done`, the reversed value is stored high-byte-first at `0x010` and `0x011`.
The reversal leaves the initialized input unchanged.

The program calls `division` exactly four times, including for zero digits.
This subroutine divides the unsigned 16-bit value at `0x020:0x021` by the
fixed divisor 16, replaces it with the quotient, and writes the remainder
to `0x022`. Scratch RAM is `0x020` through `0x024`; WREG and STATUS are
clobbered.

## Hard: fraction calculator

`hard.S` evaluates `A/B op1 C/D op2 E/F`. Input bytes `0x000` through
`0x005` hold A through F; `0x006` and `0x007` hold the operation codes:
0 addition, 1 subtraction, 2 multiplication, 3 division.
Multiplication/division take precedence; equal-precedence operators run
left-to-right. Input RAM is preserved after initialization.

`fractionCalc` performs one operation on two 16-bit fractions and calls
`GCD` to reduce the result before the next operation. `GCD` uses Euclid's
algorithm and `divide16`, an unsigned quotient/remainder subroutine.
Zero numerators reduce to `0/1`. The assignment's nonzero-divisor,
positive-subtraction and 16-bit intermediate-range guarantees are required.

`TEST_CASE` defaults to 1, with expected result `0xC9E3 / 0xB608`.
Set it to 2 for `0x0004 / 0x0001`. To use custom input, break at `calculate`
after initialization and edit `0x000` through `0x007`.
At `done`, `0x010:0x011` holds the numerator and `0x012:0x013` holds the
denominator, both high-byte-first. Working RAM is `0x020` through `0x03B`;
WREG, STATUS, PRODH and PRODL are clobbered.
