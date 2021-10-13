# ECE 375 Homework 1

## Robert Detjens

---

### 1. Based on the initial register and data memory contents, show how these contents are modified (in hexadecimal) after executing each of the following AVR assembly instructions.

- `add R3, R2`

  `R3` new value: `22`

- `ld R0, X+`

  `R0` new value: `04`

  `X` new value: `0107`

- `andi R3, $42`

  `R3` new value: `02`

- `muls R1, R28`

  `R1` new value: `1e`

- `sbr R26, 15`

  `R26` new value: `0f`

- `ser R2`

  `R2` new value: `ff`

### 2. Consider a CPU with 3-address format that has a memory unit with a capacity of 3000 words and supports 112 unique instructions. Indicate the number of bits required for each part of the instruction, and the total bits for the whole instruction.

The total instruction is 47 bits long:

- 7 bits for the opcode -- 112 separate instructions fit in $2^7$ bits
- 1 bit for the indirect addressing flag
- 13 (x3) bits for each address, 3000 words == 6000 bytes, which needs $2^13$ bytes to address

### 3. Explain the meaning of each term in the list below. Be sure that you describe how each item is used within the pseudo-computer discussed in class.

- Operation code (opcode)

  This tells the control unit what operation the CPU is going to perform.

- ALU

  The (arithmetic logic unit) is where all the math and logic operations take place.

- Effective Address

  When doing an indirect reference, the effective address is the final location to fetch the data from after doing any
  increments or decrements.

- Program Counter (PC)

  This stores the address of the next instruction to fetch and execute.

- Internal Data Bus

  All of the components of the CPU are connected to this internal bus, and all data movement between registers occurs on
  this bus.

### 4. Imagine that you want to introduce a new assembly code instruction: `INCS Y` (Increment and Save). What is the `EXECUTE` cycle for this new instruction?

1. `MDR` <- `mem[MAR]`
2. `AC`  <- `MDR`, `TMP` <- `AC`
3. `AC`  <- `AC` + 1
4. `MDR` <- `AC`, `AC` <- `TMP`
5. `mem[MAR]` <- `MDR`

### 5. Consider the following hypothetical 1-address assembly instruction called `STA (x)-` (Store Accumulator Indirect with Post-decrement). What is the `EXECUTE` cycle for this new instruction?

1. `MDR` <- `mem[MAR]`
2. `MAR` <- `MDR`,
3. `MDR` <- `AC`, `TMP` <- `AC`  // Store AC
4. `mem[MAR]` <- `MDR`,
5. `AC`  <- `MDR`  // decrement and store operand
6. `AC`  <- `AC` - 1,
7. `MDR` <- `AC`, `AC` <- `TMP`
8. `mem[MAR]` <- `MDR`
