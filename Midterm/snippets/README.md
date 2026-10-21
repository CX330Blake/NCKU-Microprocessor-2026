# PIC18F4520 期中複習 Subroutine Snippets

#gen-by-ai

這些片段從 HW4/HW5 的 8-bit/16-bit 算術、除法與 GCD，以及 2024 期中考的位元操作、CRC、陣列反轉題整理而來。每個 `.S` 都只有可複製的副程式，沒有 reset vector、`main`、測試輸入或 configuration bits。

## 使用規則

1. 將**整個檔案內容**複製到題目的 `.S`，不要把同一個檔案重複 include/link。
2. 每個檔案都在 access RAM 使用固定 scratch 位址。多個檔案一起使用前，必須重新配置 `EQU` 位址，避免重疊。
   暫存變數使用無前綴名稱，例如 `VALUE`、`COUNT`、`AH:AL`；複製到主程式時須避免名稱衝突。
3. 所有 16-bit 數值皆為 unsigned、high byte first：`HIGH:LOW`。
4. 除非介面明示保留，`WREG`、`STATUS` 與列出的特殊暫存器都可被破壞。
5. 組譯時使用 `pic-as` 的 `-mcpu=18F4520`；片段不含 reset vector，應由題目的主程式提供入口。

| 檔案 | 副程式 | 題型 / 介面摘要 |
|---|---|---|
| `arithmetic8.S` | `Add8`、`Sub8`、`Multiply8` | 8-bit 加、減、乘；加減結果寫回 A，乘法輸出完整 16-bit 結果。 |
| `divide_gcd8.S` | `Divide8`、`Gcd8` | restoring 8-bit unsigned 除法與 Euclid GCD；除數不得為 0。 |
| `arithmetic16.S` | `Add16`、`Sub16`、`Multiply16` | 16-bit 加、減、乘；加減結果寫回 A，乘法輸出低 16 bits。 |
| `divide_gcd16.S` | `Divide16`、`Gcd16` | restoring 16-bit unsigned 除法與 Euclid GCD；除數不得為 0。 |

## 考場對應

- **8-bit 運算、除法、最大公因數**：優先用 `arithmetic8.S` 與 `divide_gcd8.S`。
- **16-bit 運算、分數化簡、最大公因數**：優先用 `arithmetic16.S` 與 `divide_gcd16.S`。
- **左移、算術右移、nibble 乘法、CRC 題**：直接從 `bit_crc.S` 取對應副程式；算術右移每一輪都會重新以 bit7 設定 Carry。
- **反轉子陣列**：先將頭尾元素位址載入 `FSR0`、`FSR1`，再呼叫 `ReverseRange`；指標可跨 bank，不限於 2024 考題的 `0x300` 陣列。

`Crc16CcittByte` 的參數固定為考古題定義：poly `0x1021`、MSB-first、initial value `0`、no reflection、no final XOR。它不是可任意替換 CRC 參數的通用函式。
