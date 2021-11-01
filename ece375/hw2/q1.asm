
.include "m128def.inc"

.EQU var1 = 0b10101010
.EQU var2 = 18
.DEF count = r17

.ORG 0x0000
 RJMP  init

.ORG 0x0046
init:
  LDI  XH, HIGH(resultA)
  LDI  XL, LOW(resultA)
  LDI  YH, HIGH(resultB)
  LDI  YL, LOW(resultB)
  CLR  r10
  LDI  r20, var1
  LDI  count, var2
loop:
  CLC
  ROR  r20
  BRCC   skip
  INC  r1
skip:
  ROL  r10
  DEC  count
  BRNE   loop

  ST   X, r10
  ST   Y+, r1
done:
  RJMP  done

.DSEG
.ORG 0x03FE
resultA: .BYTE 1
resultB: .BYTE 1
