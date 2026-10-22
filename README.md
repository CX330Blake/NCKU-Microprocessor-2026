# NCKU-Microprocessor-2026

The study guide includes HW1–HW5 and the 2024 midterm (24 questions). HW3 covers adjacent-bit swaps, 16-bit absolute magnitude, and a SUBLEQ interpreter, including both supplied Hard source files. Its walkthroughs distinguish the sources' current initialization values from the PDF examples and preserve the original source listings.

The offline pages in `study-guide/` use [LXGW WenKai TC v1.530](https://github.com/lxgw/LxgwWenkaiTC/releases/tag/v1.530) for text and headings; source code retains its monospace font. Each HTML embeds a WOFF2 subset and the SIL Open Font License, so no font installation or network access is required. The subset covers the current guide text and printable ASCII; regenerate it when adding characters not already present in the guide.

Source listings use `<pre><code>...</code></pre>` markup, preserving the original whitespace. Each `<code>` element explicitly uses the `ui-monospace, SFMono-Regular, Menlo, Consolas, monospace` stack and inherits only the listing's font size and line height.

The code walkthroughs use 16px source listings and explanations, with 14px line numbers. On narrow screens, each source block stacks above its explanation; long source lines scroll within the block.

Each question's chapter navigation includes a full-source copy link. Clicking it opens the source section; loading a question with `#full-source` also expands that section.

Prose references to instructions, registers, identifiers, file paths, memory addresses, and code expressions use inline `<code>` elements with the same monospace stack. Ordinary narrative text retains LXGW WenKai TC; long inline references can wrap on narrow screens.

Inline spans cover complete instruction-and-operand snippets, expressions, address ranges, and hexadecimal/binary trace values even when no `0x` or `0b` prefix is shown. Carry-flag `C` is code; C as a language, physical device names, chapter/round counters, bit-widths, and source-line numbers remain prose.

## Midterm snippet toolbox

Open `study-guide/index.html` and select the Snippets toolbox, or open [`study-guide/snippets.html`](study-guide/snippets.html) directly. The standalone offline page includes all six `Midterm/snippets/*.S` files, searchable interfaces and register names, access-RAM ranges, clobbers, and separately copyable call examples. Expand a complete-source section to copy the entire file, including its `EQU` declarations and routine dependencies. If automatic copying is blocked, the page selects the code for manual copying.

The embedded listings are exact source snapshots; refresh the corresponding listing when a snippet changes. Combining files requires remapping their overlapping access-RAM addresses and checking symbol conflicts. The page does not supply reset vectors, a main program, or configuration bits.