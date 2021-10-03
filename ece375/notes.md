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
