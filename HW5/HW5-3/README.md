
# HW5-3

## Structure

| Path                     | Purpose                                                                                                                             |
|--------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| _build                   | The [CMake build tree](https://cmake.org/cmake/help/latest/manual/cmake.1.html#introduction-to-cmake-buildsystems), can be deleted. |
| cmake                    | Generated [CMake](https://cmake.org/) files. May be deleted if user.cmake has not been added                                        |
| .vscode                  | See [VSCode](https://code.visualstudio.com/docs/getstarted/settings)                                                                |
| .vscode/settings.json    | Workspace specific settings                                                                                                         |
| .vscode/HW5-3.mplab.json | The MPLAB project file, should not be deleted                                                                                       |
| out                      | Final build artifacts                                                                                                               |

## Hard: evaluate an expression

`main.c` calls the PIC18F assembly function declared as:

```c
extern unsigned int evaluate(unsigned int a, char op1, unsigned int b,
                             char op2, unsigned int c, char op3,
                             unsigned int d);
```

The expression is `a op1 b op2 c op3 d`. Supported operators are `+`, `-`,
and `*`. Multiplication has higher precedence; equal-precedence operators are
evaluated from left to right. Inputs, intermediate results, and the final
result must satisfy the assignment's unsigned 16-bit range, 0 through 65535.

The global `volatile unsigned int ans` retains the result for the Watches
window. The default call is `evaluate(2, '+', 3, '*', 4, '-', 5)`, which returns
**9**. Break inside the final `while (1)` loop and add `ans` to Watches.

### Implementation

- `evaluate.S` keeps a current multiplication term, its pending additive
  sign, and a running total. A `*` extends the term; a `+` or `-` commits the
  previous term before starting the next. This preserves both precedence and
  left-to-right evaluation without a parser or expression stack.
- Each 16-bit multiplication uses three PIC18 `MULWF` instructions. The
  high-byte times high-byte product cannot affect the low 16 bits. The
  assignment guarantees that valid products fit in that range.
- Addition and subtraction use `ADDWFC` and `SUBWFB` to propagate carry and
  borrow through the high byte.
- Arguments use linker symbols `_evaluate$0` through `_evaluate$6`; the
  two-byte return value reuses `_evaluate$0`, in little-endian order.
- All 10 bytes of scratch RAM are linker allocated in a `COMRAM` psect.
  There are no fixed parameter or scratch RAM addresses. `PRODL` and `PRODH`
  name architectural PIC18 special-function registers, not user RAM.
  They are provided by `xc.inc`; the `.S` extension enables preprocessing.
- The function clobbers WREG, STATUS, and PRODL/PRODH. It does not use BSR,
  FSR registers, or table-read registers. Scratch state is initialized on
  every call; the routine is not reentrant.

### Build

The MPLAB project targets **PIC18F4520**, XC8 **3.10**, and
PIC18Fxxxx_DFP **1.8.178**. Its source wildcard includes `evaluate.S`.
Build using the MPLAB extension, or run the following from `HW5-3` on this
machine:

```sh
mkdir -p out/HW5-3
xc8-cc -mcpu=18F4520 \
  -mdfp="$HOME/.mchp_packs/Microchip/PIC18Fxxxx_DFP/1.8.178/xc8" \
  -O2 -o out/HW5-3/default.elf main.c evaluate.S
```

### Verification

- XC8 3.10 compiled and linked the demonstration: **236 bytes** of program
  memory and **23 bytes** of data memory, including the C caller.
- gpsim 0.32.1 executed the demonstration and returned `ans = 9`.
- A temporary C harness executed **2000 consecutive calls**, with **zero
  failures**, against expected results independently generated using
  arbitrary-precision arithmetic. Cases cover all **27 operator triples**,
  zero operands, 65535, byte carry/borrow boundaries, multiplication chains,
  and deterministic random valid expressions.
- The harness reserved RAM `0x00..0x1F`, relocating `_evaluate$0` from `0x01`
  to `0x20`. It completed all cases with the relocated parameter slots.
- XC8 emits warning 1311 for unspecified configuration word `0x300002`
  and uses its default. Compilation and the simulator runs succeeded.
  These are local verification results, not an online-judge score.

### Submission

Upload **`evaluate.S` only**. Do **not** submit `main.c`, the README,
project configuration, or build artifacts. For a ZIP submission, include only
`evaluate.S`. The
[submission instructions](https://hackmd.io/@mprocessor2026/S1feRxt9ze#How-to-submit-your-code)
also permit direct single-file or multiple-file upload after the 10/11 update.
