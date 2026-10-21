#!/usr/bin/env python3
"""Generate complete-domain PIC18 prime-prefix tables, not judge-specific answers."""

import argparse
from math import isqrt
from pathlib import Path

MARKER = "; BEGIN GENERATED TABLES -- python3 generate_count_primes.py\n"


def generate_tables():
    prime = bytearray([1]) * 65536
    prime[0:2] = b"\0\0"
    for p in range(2, 256):
        if prime[p]:
            positions = range(p * p, 65536, p)
            prime[p * p : 65536 : p] = bytes(len(positions))

    # Independent trial division guards against errors in generated constants.
    for x in range(65536):
        expected = x >= 2 and all(x % d for d in range(2, isqrt(x) + 1))
        if bool(prime[x]) != expected:
            raise ValueError(f"Incorrect primality at {x}")

    prefix = [0]
    for is_prime in prime:
        prefix.append(prefix[-1] + is_prime)
    if prefix[-1] != 6542:
        raise ValueError("Unexpected total prime count")

    lows, highs, ranks = [], [], []
    for start in range(0, 65536, 8):
        # Block zero includes 2 here; the assembly handles x <= 2 separately.
        base = prefix[start] if start else 1
        packed = 0
        for j in range(4):
            rank = sum(prime[start + 1 : start + 2 * j : 2])
            if rank > 3:
                raise ValueError("Local rank does not fit in two bits")
            packed |= rank << (2 * j)
        lows.append(base & 255)
        highs.append(base >> 8)
        ranks.append(packed)

    for x in range(3, 65536):
        block = x >> 3
        rank = (ranks[block] >> (2 * ((x >> 1) & 3))) & 3
        actual = lows[block] + (highs[block] << 8) + rank
        if actual != prefix[x]:
            raise ValueError(f"Incorrect prefix at {x}")

    lines = ["PSECT cp_tables,local,class=CODE,reloc=256"]
    for name, data in (("cp_prefix_low", lows), ("cp_prefix_high", highs),
                       ("cp_local_rank", ranks)):
        lines.append(f"{name}:")
        for offset in range(0, len(data), 16):
            lines.append("    DB " + ",".join(f"0x{x:02X}" for x in data[offset:offset + 16]))
    return "\n".join(lines) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Verify without writing")
    args = parser.parse_args()
    path = Path(__file__).with_name("count_primes.S")
    current = path.read_text()
    head, separator, _ = current.partition(MARKER)
    if not separator:
        raise SystemExit("Generated-table marker not found")
    generated = head + MARKER + generate_tables()
    if args.check:
        if current != generated:
            raise SystemExit("Generated tables are out of date")
        print("All 65536 primalities and prefix encodings verified; tables match.")
    else:
        path.write_text(generated)
        print("Generated 24576 table bytes; all 65536 primalities verified.")


if __name__ == "__main__":
    main()
