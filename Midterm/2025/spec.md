# 2025 Microprocessor Principles and Applications — Midterm Questions

> Source: screenshots of a 2025/10/23 discussion post. These are recalled question descriptions, **not the original exam paper**. Unclear or missing information is marked explicitly. No solutions are included.

## Question 1a — 16-bit Palindrome

給定一個 **16-bit 整數**，忽略 **MSB**，判斷剩下 **15 bits** 是否形成 **palindrome（回文）**。

- 若是 palindrome，在記憶體位址 `0x10` 輸出 `0xFF`。
- 否則在 `0x10` 輸出 `0x00`。

## Question 1b — 32-bit Palindrome

給定一個 **32-bit 整數**，忽略前 **4 bits**，判斷後面剩下的 **28 bits** 在十六進位讀取下是否為 **palindrome（回文）**。

- 輸出規則與 Question 1a 相同：在 `0x10` 輸出 `0xFF` 或 `0x00`。

## Question 1c — BCD Addition and Palindrome

給定兩個 **16-bit BCD 整數**，將它們相加，並以 **BCD** 表示結果。

- 判斷結果在十進位下是否形成 **palindrome（回文）**。
- 輸出規則與 Question 1a 相同：在 `0x10` 輸出 `0xFF` 或 `0x00`。

## Question 2a — Fibonacci Sequence with FSR

分別在記憶體位址 `0x00` 和 `0x01` 給定一個初始值。

- **至少使用 FSR** 產生費波那契數列（Fibonacci sequence）。
- 將生成的數列存放在 `0x02` 到 `0x07`。

## Question 2b — Sort Three Lists with FSR

給定三個 list，每個 list 有 **3 個未排序的數字**，分別存放在：

- `0x10`–`0x12`
- `0x20`–`0x22`
- `0x30`–`0x32`

**至少使用 FSR**，將這 **9 個數字排序**，並依序存放到 `0x00`–`0x08`。

> 原截圖未指明遞增或遞減排序。

## Question 2c — In-place Matrix Transpose

以下九個記憶體位置存放一個 **3 × 3 矩陣**：

| | Column 0 | Column 1 | Column 2 |
|---|---|---|---|
| Row 0 | `0x200` | `0x201` | `0x202` |
| Row 1 | `0x210` | `0x211` | `0x212` |
| Row 2 | `0x220` | `0x221` | `0x222` |

- **至少使用 FSR0 和 FSR1**。
- 實現矩陣的 **in-place transpose（原地轉置）**。

## Question 3a — Two Sum Pair Count

記憶體 `0x00`–`0x04` 存放數字，`0x05` 存放目標值（target）。

- 計算有幾組索引 `(i, j)` 滿足 `i < j` 且 `a[i] + a[j] == target`。
- 將結果存入 `0x10`。

> 原文寫「0x00~0x04 存放數字 a0~a5」，範圍只有 5 個位址，卻標示 6 個元素；此處保留位址範圍並記錄歧義。

## Question 3b — IEEE Floating-point Representation

給定一個 **16-bit 有號數**，將其轉換成 **IEEE 風格的浮點數表示法**，位元配置為：

- **1 bit**：sign
- **5 bits**：exponent
- **10 bits**：fraction

> 來源文字為「IEEE 的浮點數表示法 (1+5+10)」。未提供額外的捨入、特殊值或輸出位址規定。

## Question 3c — Floating-point Addition (Unconfirmed)

> 發文者表示未看到題目，**推測**可能是浮點數加法。沒有可確認的題目敘述，因此不補寫詳細規格。
