# ECE 375 Comp Arch & Assembly

## week 1

### ISA:

4 dims of isa:
  - operations
  - operands
  - operand locations
  - operand type / size

creation criteria:
  - functionally complete
  - power efficiency
  - simplicity

instruction categories:
  - data transfer
  - arithmetic
  - logic ops
  - control transfer
  - i/o
  - optional ones:
    - MMU / system calls
    - FPU
    - decimal math
    - string ops

### Pseudo ISA

- LDA load acc
- STA store accc
- ADD add to acc
- NAND bitwise NAND on ACC
- SHFT shift left
- J jump to addr
- BNE jump to addr if acc is not zero

8 opcodes == 2**3 ==> 3 bit opcode
rest for opcode, e.g. for 16-bit isa, 13 bits left for addr

Example C -> asm for this isa:

```c
main () {
  int a = 83, b = -23, c = 0;
  C = 4*a + b;
}
```

```asm
  ORG   0
  LDA   A
  SFT
  SFT
  ADD   B
loop:
  JMP   loop

a:DEC   83
b:DEC   -23
c:DEC   0
```

### Computer Org

important registers

- GPR general purpose
- PC program counter - addr to next instruction
- AC accumulator
- IR instruction reg - instruction to be decoded
- MAR mem addr reg - addr of data to fetch/store
- MDR mem data reg - data to fetch/store to

## Week 2

### Fetch / Execute Cycle

every time an instruction is processed, two things happen:

- fetch (read) instruction from memory (usually constant across instructions)
- execute the instruction (time depends on complexity / hardware, e.g. is there a hardware multiplier)

#### Fetch cycle

1. `MAR` <- `PC`
2. `MDR` <- `mem[MAR]`
3. `IR`  <- `MDR` (opcode portion)
   `MAR` <- `MDR` (addr portion)
4. `PC`  <- `PC` + 1

#### Execute cycle

ex: `LDA x`

1. `MDR` <- `mem[MAR]`
2. `AC`  <- `MDR`

ex: `STA x`

1. `MDR`      <- `AC`
2. `mem[MAR]` <- `MDR`

ex: `ADD x`

1. `MDR` <- `mem[MAR]`
2. `AC`  <- `AC` + `MDR`

ex: `JMP x`

1. `PC`  <- `MDR` (addr)

ex: `BNE x`

1. `PC`  <- `MDR` *if* `Z` not set
  - `Z` being the zero flag, set if the last ALU op == 0


### Effective Address

`LDA (x)` -- () for indirect
operand is address of address of actual value

1. `MDR` <- `mem[MAR]`
2. `MAR` <- `MDR`
3. `MDR` <- `mem[MAR]`
4. `AC`  <- `MDR`

`LDA -(x)` -- indirect pre decrement

1. `MDR` <- `mem[MAR]`
2. `AC`  <- `MDR`
3. `AC`  <- `AC` - 1
4. `MDR` <- `AC`
5. `mem[MAR]` <- `MDR`
6. `MAR` <- `MDR`
7. `MDR` <- `mem[MAR]`
8. `AC`  <- `MD

Sometimes a temp / secondary working register is needed, eg for STA -(x) where AC is otherwise occupied
