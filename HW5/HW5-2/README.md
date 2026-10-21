
# HW5-2

## Structure

| Path                     | Purpose                                                                                                                             |
|--------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| _build                   | The [CMake build tree](https://cmake.org/cmake/help/latest/manual/cmake.1.html#introduction-to-cmake-buildsystems), can be deleted. |
| cmake                    | Generated [CMake](https://cmake.org/) files. May be deleted if user.cmake has not been added                                        |
| .vscode                  | See [VSCode](https://code.visualstudio.com/docs/getstarted/settings)                                                                |
| .vscode/settings.json    | Workspace specific settings                                                                                                         |
| .vscode/HW5-2.mplab.json | The MPLAB project file, should not be deleted                                                                                       |
| out                      | Final build artifacts                                                                                                               |

## Advanced: count primes

`main.c` calls the PIC18F assembly function declared as:

```c
extern unsigned int count_primes(unsigned int n, unsigned int m);
```

The result is stored in the global `volatile unsigned int ans`. The default
demonstration calls `count_primes(1, 65535)`; inspect `ans` in the Watches window
after the call, where it should be **6542**. Change the two arguments to try
another inclusive interval.

### Implementation

- `count_primes.S` computes `F(m+1) - F(n)`, where `F(x)` is the number of
  primes strictly below `x`. Both endpoint lookups take constant time.
- Three program-memory arrays cover every unsigned 16-bit input. Each array has
  8192 bytes: the low and high bytes of a block's prefix count, and a packed
  local rank for each possible endpoint within its eight-integer block.
- Four two-bit ranks fit in one byte because an eight-integer block contains at
  most three odd primes. The prime 2 is included in the first block's base;
  endpoints 0, 1, and 2 are handled separately.
- The exclusive endpoint 65536 is handled explicitly as `F(65536) = 6542`,
  avoiding 16-bit overflow when `m = 65535`.
- All scratch RAM is linker allocated. Parameters and the two-byte return
  value use `_count_primes$0` and `_count_primes$1`, never fixed RAM addresses.
- The routine clobbers WREG, STATUS, PRODL/PRODH, TABLAT, and TBLPTR. It does not
  use FSR registers or depend on their initial contents.
- This trades 24576 bytes of lookup data for a dramatic reduction in runtime.
  It is a complete-domain lookup, not a list of answers for judge test cases.

### Regenerating the tables

The generated data is embedded in `count_primes.S`, so submission still needs
only that one assembly file. From this directory:

```sh
python3 generate_count_primes.py
python3 generate_count_primes.py --check
```

The generator uses a sieve, independently checks every input's primality by
trial division, and checks every encoded prefix before emitting the table. It
preserves the handwritten code above the generated-table marker. `--check`
verifies reproducibility without modifying the file.

### Build

From this `HW5-2` directory, with XC8 3.10, CMake, Ninja, and the configured
PIC18Fxxxx device pack installed:

```sh
cd cmake/HW5-2/default
cmake --preset HW5_2_default_conf
cmake --build ../../../_build/HW5-2/default
```

The firmware is written to `out/HW5-2/default.elf` and `default.hex`.
`cmake/HW5-2/default/user.cmake` includes the assembly source when MPLAB's
generated source list has not yet refreshed. It leaves generated files intact
and does not duplicate the assembly target after regeneration.

### Verification

- XC8 3.10 successfully built the PIC18F4520 demonstration: 24782 bytes of
  program memory and 12 bytes of data memory, including the C caller.
- A temporary C harness ran 196608 consecutive calls in gpsim 0.32.1 with
  zero failures. For every `x` from 0 through 65535, it checked `[0,x]`,
  `[x,65535]`, and `[x,x]` against an independently trial-divided prime-gap
  oracle. This exercises every endpoint, all singleton intervals, both
  exclusive-boundary cases, carry/borrow transitions, and repeated calls.
- The exhaustive harness placed the function and its lookup tables at different
  linked addresses from the demonstration and used different parameter addresses.
- Additional representative interval calls returned the correct results:

| Interval | Result | gpsim cycles, CALL through RETURN |
|----------|--------|-----------------------------------|
| [1, 10] | 4 | 87 |
| [2, 2] | 1 | 87 |
| [24, 28] | 0 | 122 |
| [100, 200] | 21 | 122 |
| [114, 514] | 67 | 119 |
| [1, 65535] | 6542 | 46 |
| [60000, 65535] | 485 | 78 |
| [30000, 60000] | 2812 | 116 |

These cycle counts include the PIC CALL and RETURN instructions, but exclude
argument setup and caller-side result copies. They are not the judge's
overhead-adjusted net-cycle metric.

The previous segmented-sieve version received 20/20 AC and 29.95/30 from the
online judge. The lookup version's results above are local simulator results;
its online score and rank require a new submission.

### Submission

Upload **`count_primes.S` only**. It is self-contained and does not need any
project files or additional assembly sources. Do **not** upload `main.c`, build
artifacts, or the CMake configuration. The
[submission instructions](https://hackmd.io/@mprocessor2026/S1feRxt9ze#How-to-submit-your-code)
allow direct file upload following the 10/11 update; if uploading a ZIP instead,
include only `count_primes.S`.
