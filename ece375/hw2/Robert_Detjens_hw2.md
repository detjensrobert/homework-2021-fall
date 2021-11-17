# ECE 375 Homework 2

## Robert Detjens

---

### 1. Consider the AVR assembly code provided below. Read the code and use your knowledge of assembly instructions to answer the questions given at the bottom of this page.

```asm
.EQU var1 = 0b11011010
.EQU var2 = 18
.DEF count = r17

.ORG 0x0000
 RJMP init

.ORG 0x0046
init:
  LDI XH, HIGH(resultA)
  LDI XL, LOW(resultA)
  LDI YH, HIGH(resultB)
  LDI YL, LOW(resultB)
  CLR r10
  LDI r20, var1
  LDI count, var2
loop:
  CLC
  ROR r20
  BRCC skip
  INC r1
skip:
  ROL r10
  DEC count
  BRNE loop

  ST X, r10
  ST Y+, r1
done:
  RJMP done

.DSEG
.ORG 0x03FE
resultA: .BYTE 1
resultB: .BYTE 1
```

Assume the code has reached the `done` label.

(a) What is the decimal value of the count register?

    0

(b) In total, how many times is the instruction “ROR r20” executed?

    18 times

(c) What are the hexadecimal values of r27 and r26?

    `0x03`, `0xfe`

(d) What are the hexadecimal values of r29 and r28?

    `0x04`, `0x00`

(e) What hexadecimal address does the assembler assign to the label resultB?

    `0x4000`

(f) What 8-bit binary value is stored in SRAM at the memory location specified by resultA?

    `00000000`

(g) What decimal value is stored in SRAM at the memory location specified by resultB?

    5

Now, suppose that the entire program is executed again, with one small difference. Assume that the first line of the
program is replaced with: `.EQU var1 = 0b10101010`

(h) What 8-bit binary value is stored in SRAM at the memory location specified by resultA?

    `00000000`

(i) What decimal value is stored in SRAM at the memory location specified by resultB?

    4

### 2. Consider the following section of AVR assembly code (from the previous problem) with its equivalent (partially completed) address and binaries on the right.

Determine the values for:
Determine the values for:


(a) KKKK dddd KKKK (@ address $004C)

    0001 0001 0010

(b) d dddd (@ address $004E)

    1 0100

(c) kk kkkk k (@ address $004F)

    00 0000 1

(d) d dddd (@ address $0052)

    1 0001

(e) r rrrr (@ address $0055)

    0 0001

\pagebreak

### 3. Consider the following hypothetical 1-address assembly instruction called "Add Then Store Indirect with Pre-increment" of the form:

```asm
ATS +(x)      ; M[x] <- M[x]+1, M[M[x]] <- AC+M[M[x]]
```

Give the sequence of microoperations required to implement the execute cycle for the above `ATS +(x)` instruction.

1. MDR $\leftarrow$ mem[MAR] | TEMP $\leftarrow$ AC
2. AC $\leftarrow$ MDR
3. AC $\leftarrow$ AC + 1
4. MDR $\leftarrow$ AC
5. mem[MAR] $\leftarrow$ MDR | MAR $\leftarrow$ AC
6. MDR $\leftarrow$ mem[MAR] | AC $\leftarrow$ TEMP
7. AC $\leftarrow$ AC + MDR
8. MDR $\leftarrow$ AC
9. mem[MAR] $\leftarrow$ MDR | AC $\leftarrow$ TEMP

### 4. Suppose the pseudo-CPU is used to implement the AVR instruction `ST -Y, R3`. Give the sequence of microoperations that would be required to Fetch and Execute this instruction.

```asm
ST -Y, R3     ; Y <- Y-1, M[Y] <- R3
```

**Fetch:**

1. MAR $\leftarrow$ PC
2. MDR $\leftarrow$ mem[MAR] | PC $\leftarrow$ PC + 1
3. IR~low~ $\leftarrow$ MDR
4. MAR $\leftarrow$ PC
5. MDR $\leftarrow$ mem[MAR] | PC $\leftarrow$ PC + 1
6. IR~high~ $\leftarrow$ MDR

**Execute:**

1. AC~low~ $\leftarrow$ r28
2. AC~high~ $\leftarrow$ r29
3. AC $\leftarrow$ AC - 1
4. MAR $\leftarrow$ AC
5. MDR $\leftarrow$ r3
6. mem[MAR] $\leftarrow$ MDR | r28 $\leftarrow$ AC~low~
7. r29 $\leftarrow$ AC~high~
