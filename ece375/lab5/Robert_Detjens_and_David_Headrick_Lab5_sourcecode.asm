;***********************************************************
;*
;*  Robert_Detjens_and_David_Headrick_Lab5_sourcecode.asm
;*
;*
;*
;*	This is the skeleton file for Lab 5 of ECE 375
;*
;***********************************************************
;*
;*	 Author: Robert Detjens
;*   David Headrick
;*	   Date: 10/27/21
;*
;***********************************************************

.include "m128def.inc"  	; Include definition file

;***********************************************************
;*	Internal Register Definitions and Constants
;***********************************************************
.def	mpr = r16		; Multipurpose register
.def	rlo = r0    ; Low byte of MUL result
.def	rhi = r1    ; High byte of MUL result
.def	zero = r2   ; Zero register, set to zero in INIT, useful for calculations
.def	A = r3    	; A variable
.def	B = r4    	; Another variable

.def	oloop = r17 	; Outer Loop Counter
.def	iloop = r18   ; Inner Loop Counter


;***********************************************************
;*	Start of Code Segment
;***********************************************************
.cseg

;-----------------------------------------------------------
; Interrupt Vectors
;-----------------------------------------------------------
.org	$0000
  rjmp 	INIT  	; Reset interrupt

.org	$0046

;-----------------------------------------------------------
; Program Initialization
;-----------------------------------------------------------
INIT:
    ; Initialize the Stack Pointer
    ldi         mpr,low(RAMEND)
    out         SPL, mpr
    ldi         mpr,high(RAMEND)
    out         SPH, mpr

  clr  zero  	; Set the zero register to zero, maintain
              ; these semantics, meaning, don't
              ; load anything else into it.

;-----------------------------------------------------------
; Main Program
;-----------------------------------------------------------
MAIN:      	; The Main program
  ; Setup the ADD16 function direct test

  ; Move values 0xFCBA and 0xFFFF in program memory to data memory memory
  ; locations where ADD16 will get its inputs from (see "Data Memory Allocation"
  ; section below)
  ; source addr in prog memory
  ldi   ZL,   low(ADD16_D1 << 1)
  ldi   ZH,   high(ADD16_D1 << 1)
  ; store in data memory
  ldi   YL,   low(ADD16_OP1)
  ldi   YH,   high(ADD16_OP1)
  ; store two bytes
  lpm     mpr,  Z+
  st      Y+,   mpr
  lpm     mpr,  Z+
  st      Y+,   mpr
  ; store the second operand (directly contiguous)
  lpm     mpr,  Z+
  st      Y+,   mpr
  lpm     mpr,  Z+
  st      Y+,   mpr

  nop             ; Check load ADD16 operands (Set Break point here #1)
  rcall   ADD16   ; (calculate FCBA + FFFF)
  nop             ; Check ADD16 result (Set Break point here #2)

  ; Setup the SUB16 function direct test
  ; source addr in prog memory
  ldi   ZL,   low(SUB16_D1 << 1)
  ldi   ZH,   high(SUB16_D1 << 1)
  ; store in data memory
  ldi   YL,   low(SUB16_OP1)
  ldi   YH,   high(SUB16_OP1)
  ; store two bytes
  lpm     mpr,  Z+
  st      Y+,   mpr
  lpm     mpr,  Z+
  st      Y+,   mpr
  ; store two more bytes for the second operand (directly contiguous)
  lpm     mpr,  Z+
  st      Y+,   mpr
  lpm     mpr,  Z+
  st      Y+,   mpr

  nop             ; Check load SUB16 operands (Set Break point here #3)
  rcall   SUB16   ; (calculate FCB9 - E420)
  nop             ; Check SUB16 result (Set Break point here #4)

  ; Setup the MUL24 function direct test

  ; source addr in prog memory
  ldi   ZL,   low(MUL24_D1 << 1)
  ldi   ZH,   high(MUL24_D1 << 1)
  ; store in data memory
  ldi   YL,   low(MUL24_OP1)
  ldi   YH,   high(MUL24_OP1)
  ; store three bytes
  lpm     mpr,  Z+
  st      Y+,   mpr
  lpm     mpr,  Z+
  st      Y+,   mpr
  lpm     mpr,  Z+
  st      Y+,   mpr
  ; discard padding byte
  lpm     mpr,  Z+
  ; store three more bytes for the second operand (directly contiguous)
  lpm     mpr,  Z+
  st      Y+,   mpr
  lpm     mpr,  Z+
  st      Y+,   mpr
  lpm     mpr,  Z+
  st      Y+,   mpr
  ; discard padding byte
  lpm     mpr,  Z+

  nop             ; Check load MUL24 operands (Set Break point here #5)
  rcall   MUL24   ; (calculate FFFFFF * FFFFFF)
  nop             ; Check MUL24 result (Set Break point here #6)

  nop ; Check load COMPOUND operands (Set Break point here #7)
  ; Call the COMPOUND function

  nop ; Check COMPUND result (Set Break point here #8)
    ; Observe final result in Memory window

DONE:	rjmp	DONE  	; Create an infinite while loop to signify the
        ; end of the program.

;***********************************************************
;*	Functions and Subroutines
;***********************************************************

;-----------------------------------------------------------
; Func: ADD16
; Desc: Adds two 16-bit numbers and generates a 24-bit number
;  where the high byte of the result contains the carry
;  out bit.
;-----------------------------------------------------------
ADD16:
  ; Load beginning address of first operand into X
  ldi  XL, low(ADD16_OP1)
  ldi  XH, high(ADD16_OP1)

  ; Load beginning address of second operand into Y
  ldi  YL, low(ADD16_OP2)
  ldi  YH, high(ADD16_OP2)

  ; Load beginning address of result into Z
  ldi  ZL, low(ADD16_Result)
  ldi  ZH, high(ADD16_Result)


  ; add low bytes
  ld    A,    X+
  ld    B,    Y+
  add   A,    B
  st    Z+,   A
  ; add high bytes with carry
  ld    A,    X+
  ld    B,    Y+
  adc   A,    B
  st    Z+,   A
  ; store extra bit if carry
  brcc  ADD_nocarry
  ldi   mpr,  1
  st    Z,    mpr  ; if carry, set overflow in next byte
  ADD_nocarry:

  ret

;-----------------------------------------------------------
; Func: SUB16
; Desc: Subtracts two 16-bit numbers and generates a 16-bit
;  result.
;-----------------------------------------------------------
SUB16:

  ; Load beginning address of first operand into X
  ldi  XL, low(SUB16_OP1)
  ldi  XH, high(SUB16_OP1)

  ; Load beginning address of second operand into Y
  ldi  YL, low(SUB16_OP2)
  ldi  YH, high(SUB16_OP2)

  ; Load beginning address of result into Z
  ldi  ZL, low(SUB16_Result)
  ldi  ZH, high(SUB16_Result)

  ; Execute the function

  ; subract low bytes
  ld    A,    X+
  ld    B,    Y+
  sub   A,    B
  st    Z+,   A
  ; subtract high bytes with carry borrow
  ld    A,    X+
  ld    B,    Y+
  sbc   A,    B
  st    Z+,   A
  ; store extra bit if carry
  brcc  SUB_nocarry
  ldi   mpr,  1
  st    Z,    mpr  ; if carry, set overflow in next byte
  SUB_nocarry:

  ret

;-----------------------------------------------------------
; Func: MUL24
; Desc: Multiplies two 24-bit numbers and generates a 48-bit
;  result.
;-----------------------------------------------------------
MUL24:
  ; Execute the function here


  ret

;-----------------------------------------------------------
; Func: COMPOUND
; Desc: Computes the compound expression ((D - E) + F)^2
;  by making use of SUB16, ADD16, and MUL24.
;
;  D, E, and F are declared in program memory, and must
;  be moved into data memory for use as input operands.
;
;  All result bytes should be cleared before beginning.
;-----------------------------------------------------------
COMPOUND:

  ; Setup SUB16 with operands D and E
  ; Perform subtraction to calculate D - E

  ; Setup the ADD16 function with SUB16 result and operand F
  ; Perform addition next to calculate (D - E) + F

  ; Setup the MUL24 function with ADD16 result as both operands
  ; Perform multiplication to calculate ((D - E) + F)^2

  ret

;-----------------------------------------------------------
; Func: MUL16
; Desc: An example function that multiplies two 16-bit numbers
;  	A - Operand A is gathered from address $0101:$0100
;  	B - Operand B is gathered from address $0103:$0102
;  	Res - Result is stored in address
;    	$0107:$0106:$0105:$0104
;  You will need to make sure that Res is cleared before
;  calling this function.
;-----------------------------------------------------------
MUL16:
  push 	A    ; Save A register
  push	B    ; Save B register
  push	rhi    ; Save rhi register
  push	rlo    ; Save rlo register
  push	zero  	; Save zero register
  push	XH    ; Save X-ptr
  push	XL
  push	YH    ; Save Y-ptr
  push	YL
  push	ZH    ; Save Z-ptr
  push	ZL
  push	oloop  	; Save counters
  push	iloop

  clr  zero  	; Maintain zero semantics

  ; Set Y to beginning address of B
  ldi  YL, low(addrB)	; Load low byte
  ldi  YH, high(addrB)	; Load high byte

  ; Set Z to begginning address of resulting Product
  ldi  ZL, low(LAddrP)	; Load low byte
  ldi  ZH, high(LAddrP); Load high byte

  ; Begin outer for loop
  ldi  oloop, 2  ; Load counter
MUL16_OLOOP:
  ; Set X to beginning address of A
  ldi  XL, low(addrA)	; Load low byte
  ldi  XH, high(addrA)	; Load high byte

  ; Begin inner for loop
  ldi  iloop, 2  ; Load counter
MUL16_ILOOP:
  ld  A, X+  	; Get byte of A operand
  ld  B, Y  	; Get byte of B operand
  mul  A,B    ; Multiply A and B
  ld  A, Z+  	; Get a result byte from memory
  ld  B, Z+  	; Get the next result byte from memory
  add  rlo, A  	; rlo <= rlo + A
  adc  rhi, B  	; rhi <= rhi + B + carry
  ld  A, Z  	; Get a third byte from the result
  adc  A, zero  	; Add carry to A
  st  Z, A  	; Store third byte to memory
  st  -Z, rhi  	; Store second byte to memory
  st  -Z, rlo  	; Store first byte to memory
  adiw	ZH:ZL, 1  ; Z <= Z + 1
  dec  iloop  	; Decrement counter
  brne	MUL16_ILOOP  ; Loop if iLoop != 0
  ; End inner for loop

  sbiw	ZH:ZL, 1  ; Z <= Z - 1
  adiw	YH:YL, 1  ; Y <= Y + 1
  dec  oloop  	; Decrement counter
  brne	MUL16_OLOOP  ; Loop if oLoop != 0
  ; End outer for loop

  pop  iloop  	; Restore all registers in reverves order
  pop  oloop
  pop  ZL
  pop  ZH
  pop  YL
  pop  YH
  pop  XL
  pop  XH
  pop  zero
  pop  rlo
  pop  rhi
  pop  B
  pop  A
  ret      ; End a function with RET

;-----------------------------------------------------------
; Func: Template function header
; Desc: Cut and paste this and fill in the info at the
;  beginning of your functions
;-----------------------------------------------------------
FUNC:
  ; Save variable by pushing them to the stack

  ; Execute the function here

  ; Restore variable by popping them from the stack in reverse order
  ret


;***********************************************************
;*	Stored Program Data
;***********************************************************

; Enter any stored data you might need here

; ADD16 operands
ADD16_D1:
  .DW 0xFCBA
ADD16_D2:
  .DW 0xFFFF

; SUB16 operands
SUB16_D1:
  .DW 0xFCB9
SUB16_D2:
  .DW 0xE420

; MUL24 operands
MUL24_D1:
  .DB 0xFF, 0xFF, 0xFF, 0 ; extra byte for 16b alignment
MUL24_D2:
  .DB 0xFF, 0xFF, 0xFF, 0 ; extra byte for 16b alignment

; Compoud operands
OperandD:
  .DW	0xFCBA    ; test value for operand D
OperandE:
  .DW	0x2019    ; test value for operand E
OperandF:
  .DW	0x21BB    ; test value for operand F

;***********************************************************
;*	Data Memory Allocation
;***********************************************************

.dseg
.org	$0100    ; data memory allocation for MUL16 example
addrA:	.byte 2
addrB:	.byte 2
LAddrP:	.byte 4

; Below is an example of data memory allocation for ADD16.
; Consider using something similar for SUB16 and MUL24.

.org	$0110   ; data memory allocation for operands
ADD16_OP1:
  .byte 2     ; allocate two bytes for first operand of ADD16
ADD16_OP2:
  .byte 2     ; allocate two bytes for second operand of ADD16

.org	$0120   ; data memory allocation for results
ADD16_Result:
  .byte 3     ; allocate three bytes for ADD16 result

; SUB16 reservations

.org	$0130   ; data memory allocation for operands
SUB16_OP1:
  .byte 2     ; allocate two bytes for first operand of ADD16
SUB16_OP2:
  .byte 2     ; allocate two bytes for second operand of ADD16

.org	$0140   ; data memory allocation for results
SUB16_Result:
  .byte 3    ; allocate three bytes for ADD16 result

; MUL24 reservations

.org	$0150   ; data memory allocation for operands
MUL24_OP1:
  .byte 3     ; allocate two bytes for first operand of ADD16
MUL24_OP2:
  .byte 3     ; allocate two bytes for second operand of ADD16

.org	$0160   ; data memory allocation for results
MUL24_Result:
  .byte 6    ; allocate 6 bytes for ADD16 result

;***********************************************************
;*	Additional Program Includes
