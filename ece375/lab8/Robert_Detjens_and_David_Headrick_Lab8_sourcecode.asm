;***********************************************************
;*
;*  Robert Detjens & David Headrick Lab 7 Source Code
;*
;***********************************************************
;*
;*   Author: Robert Detjens
;*           David Headrick
;*     Date: 11/16/21
;*
;***********************************************************

.include "m128def.inc"    ; Include definition file

; ====  REGISTER CONSTANTS  ====

.def    mpr           = r16
.def    curr_letter   = r23

;***********************************************************
;*  Start of Code Segment
;***********************************************************
.cseg        ; beginning of code segment

;***********************************************************
;*  Interrupt Vectors
;***********************************************************
.org  $0000
  rjmp  INIT    ; reset interrupt


.org  $0046      ; end of interrupt vectors

;***********************************************************
;*  Program Initialization
;***********************************************************
INIT:
  ; Initialize the Stack Pointer
  ldi		mpr, low(RAMEND)
  out		SPL, mpr		; Load SPL with low byte of RAMEND
  ldi		mpr, high(RAMEND)
  out		SPH, mpr		; Load SPH with high byte of RAMEND

  ; Configure I/O ports

  ; Initialize Port B for output
  ldi		mpr, $FF		; Set Port B Directional Register
  out		DDRB, mpr		; for output
  ldi		mpr, $00		; Initialize Port B for outputs
  out		PORTB, mpr	; Port B outputs low

  ; Initialize Port D for input
  ldi		mpr, $00		; Set Port D Directional Register
  out		DDRD, mpr		; for inputs
  ldi		mpr, $FF		; Initialize Port D for inputs
  out		PORTD, mpr	; with pull-up

  ; init LCD
  call  LCDInit

  ; configure Timer 1 for 1|3s sleep
  ; TODO

  ; Enable global interrupts (if any are used)
  ; sei

;***********************************************************
;*  Main Program
;***********************************************************
MAIN:
  rcall   PROMPT

  rjmp    MAIN    ; return to top of MAIN



;***********************************************************
;*  Functions
;***********************************************************

; PROMPT()
;   Main function for getting the word input from the user.
;   Polls buttons:
;     - 6/7 step through letters
;     - 0 confirms the letter
;     - 4 confirms the word and returns (for transmission)
PROMPT:
  ; load prompt string into line 1
  ; location of string in program memory
  ldi     ZL,   low(PROMPT_S << 1)
  ldi     ZH,   high(PROMPT_S << 1)
  ; dest addr in data memory (0x0100)
  ldi     YL,   low(LCD_Line1)
  ldi     YH,   high(LCD_Line1)
  str1_l:
    lpm     mpr,  Z+
    st      Y+,   mpr
    cpi     YL, low(PROMPT_E << 1)
    brne    str1_l

  ; display string
  call    LCDWrLn1
  call    LCDClrLn2

  ; set Y to line 2
  ; second line in data memory (0x0110)
  ldi     YL,   low(LCD_Line2)
  ldi     YH,   high(LCD_Line2)

  ; turn on cursor on LCD
  ; no proc for this, so send command manually
  ; ldi     mpr,    0b00001110 ;  0 	0 	0 	0 	1 	D 	C 	B
  ; call    LCDWriteCmd

  ; start with A
  ldi     curr_letter,  65

  PROMPT_LOOP:
    ; store current letter to LCD memory
    st      Y,  curr_letter
    ; update LCD
    call  LCDWrLn2

    ; get button inputs
    in    mpr,    PIND

    sbrs  mpr,    7 ; bit 7: decrement letter
    jmp   BIT_7
    sbrs  mpr,    6 ; bit 6: increment letter
    jmp   BIT_6
    sbrs  mpr,    0 ; bit 0: confirm letter
    jmp   BIT_0
    sbrs  mpr,    4 ; bit 4: confirm whole word
    jmp   BIT_4

    jmp   BIT_NONE  ; skip bit handling

    BIT_7:
      ; decrement letter
      dec   curr_letter
      ; wrap around if it underflowed
      cpi   curr_letter,   64   ; 'A' is 65
      brne  DEC_NOOP
        ; only decrement if above min
        ldi   curr_letter,  90  ; 'Z' is 90
      DEC_NOOP:
      jmp BIT_DONE

    BIT_6:
      ; increment letter
      inc   curr_letter
      ; wrap around if it overflowed
      cpi   curr_letter,   91   ; 'z' is 90
      brne  INC_NOOP
        ; only decrement if above min
        ldi   curr_letter,  65  ; 'A' is 65
      INC_NOOP:
      jmp BIT_DONE

    BIT_0:
      ; letter confirmed, increment dest addr

      ; store a final time with post-increment
      st      Y+,   curr_letter

      ; if 16 chars have been entered, start transmission (button 4)
      cpi     YL,   low(LCD_End)
      breq    BIT_4

      ; start with A once more
      ldi     curr_letter,  65

      jmp BIT_DONE

    BIT_4:
      ; word confirmed, exit prompt
      ret

    BIT_DONE:
    ; wait a bit for debounce
    ; reuse exising wait func for inner loop
    ldi   mpr,    100
    wait_loop:
      ldi   wait,   255
      call  LCDWait
      dec   mpr
    brne  wait_loop

    BIT_NONE:

  ; keep looping until button 4 is hit
  jmp   PROMPT_LOOP

;***********************************************************
;*  Additional Program Includes
;***********************************************************
.include "LCDDriver.asm"  ; LCD stuff

;***********************************************************
;*  Stored Program Data
;***********************************************************

PROMPT_S:
.DB    "Enter word:     "
PROMPT_E:

;***********************************************************
;*	Data Memory Allocation
;***********************************************************

.dseg
.org	$0100
LCD_Line1:	.byte $10
.org	$0110
LCD_Line2:	.byte $10
.org	$0120
LCD_End:
