;***********************************************************
;*
;*	Robert Detjens & David Headrick -- Lab  4 sourcecode
;*
;*	This code interacts with the LCD and
;*
;*	This is the skeleton file for Lab 4 of ECE 375
;*
;***********************************************************
;*
;*	 Author: Enter your name
;*	   Date: Enter date
;*
;***********************************************************

.include "m128def.inc"			; Include definition file

;***********************************************************
;*	Internal Register Definitions and Constants
;***********************************************************
.def			mpr = r16		; Multipurpose register is
											; required for LCD Driver

.def 	waitcnt = r17		; wait function param
.def    ilcnt = r18		; Inner Loop Counter
.def    olcnt = r19   ; Outer Loop Counter


; button definitions
.equ 		BUTT0 = 0b11111110
.equ 		BUTT1 = 0b11111101
.equ 		BUTT7 = 0b01111111

;***********************************************************
;*	Start of Code Segment
;***********************************************************
.cseg									; Beginning of code segment

;***********************************************************
;*	Interrupt Vectors
;***********************************************************
.org	$0000					; Beginning of IVs
		rjmp INIT				; Reset interrupt

.org	$0046					; End of Interrupt Vectors

;***********************************************************
;*	Program Initialization
;***********************************************************
INIT:							; The initialization routine
		; Initialize the Stack Pointer
		ldi         mpr,low(RAMEND)
		out         SPL, mpr
		ldi         mpr,high(RAMEND)
		out         SPH, mpr

		; Initialize LCD Display
    rcall   LCDInit

		; load strings
		rcall 	LOAD_STRINGS

		; setup button inputs
		; Initialize Port D for button inputs
		ldi         mpr, 0b00000000   ; Set Port D Data Direction Register
		out         DDRD, mpr         ; for input
		ldi         mpr, 0b11111111		; Initialize Port D Data Register
		out         PORTD, mpr        ; so all Port D inputs are Tri-State

;***********************************************************
;*	Main Program
;***********************************************************
MAIN:							; The Main program

		; read buttons
		in 		mpr, 	PIND

		cpi 	mpr, 	BUTT0
		brne  NO0
			; button 0: "Name \n Hello"
			rcall 	LOAD_STRINGS
			rcall 	LCDWrLn1
			rcall 	LCDWrLn2
		NO0:

		cpi 	mpr, 	BUTT1
		brne  NO1
			; button 1: "Hello \n Name"
			rcall 	LOAD_STRINGS_SWAPPED
			rcall 	LCDWrLn1
			rcall 	LCDWrLn2
		NO1:

		cpi 	mpr, 	BUTT7
		brne  NO7
			; button 7: clear
			rcall 	LCDClr
		NO7:

		; wait a bit
		ldi 	waitcnt,	10
		rcall	WAIT

		rjmp	MAIN			; jump back to main and create an infinite
								; while loop.  Generally, every main program is an
								; infinite while loop, never let the main program
								; just run off

;***********************************************************
;*	Functions and Subroutines
;***********************************************************

;-----------------------------------------------------------
; Func: LOAD_STRINGS
; Desc: Loads both strings from program memory
;-----------------------------------------------------------
LOAD_STRINGS:							; Begin a function with a label
		; save old mpr
		push 		mpr

		; Move strings from Program Memory to Data Memory
    ; location of string in program memory
    ldi     ZL,   low(NAMESTR_S << 1)
    ldi     ZH,   high(NAMESTR_S << 1)
    ; dest addr in data memory (0x0100)
    ldi     YL,   $00
    ldi     YH,   $01
    str1_l:
      lpm     mpr,  Z+
      st      Y+,   mpr
      cpi     YL, low(NAMESTR_E << 1)
			brne		str1_l

		; String 2
    ldi     ZL,   low(HELLOSTR_S << 1)
    ldi     ZH,   high(HELLOSTR_S << 1)
    ; dest addr in data memory (0x0100)
    ldi     YL,   $10
    ldi     YH,   $01
    str2_l:
      lpm     mpr,  Z+
      st      Y+,   mpr
      cpi     YL, low(HELLOSTR_E << 1)
			brne		str2_l

		; Restore variables by popping them from the stack,
		; in reverse order
		pop 			mpr

		ret						; End a function with RET


;-----------------------------------------------------------
; Func: LOAD_STRINGS_SWAPPED
; Desc: Loads both strings from program memory, in reverse order
;-----------------------------------------------------------
LOAD_STRINGS_SWAPPED:							; Begin a function with a label
		; save old mpr
		push 		mpr

		; String 2
    ldi     ZL,   low(HELLOSTR_S << 1)
    ldi     ZH,   high(HELLOSTR_S << 1)
    ; dest addr in data memory (0x0100)
    ldi     YL,   $00
    ldi     YH,   $01
    str2s_l:
      lpm     mpr,  Z+
      st      Y+,   mpr
      cpi     YL, low(HELLOSTR_E << 1)
			brne		str2s_l

		; String 1
    ldi     ZL,   low(NAMESTR_S << 1)
    ldi     ZH,   high(NAMESTR_S << 1)
    ; dest addr in data memory (0x0100)
    ldi     YL,   $10
    ldi     YH,   $01
    str1s_l:
      lpm     mpr,  Z+
      st      Y+,   mpr
      cpi     YL, low(NAMESTR_E << 1)
			brne		str1s_l


		; Restore variables by popping them from the stack,
		; in reverse order
		pop 			mpr

		ret						; End a function with RET


;----------------------------------------------------------------
; Sub:  Wait
; Desc: A wait loop that is 16 + 159975*waitcnt cycles or roughly
;       waitcnt*10ms.  Just initialize wait for the specific amount
;       of time in 10ms intervals. Here is the general eqaution
;       for the number of clock cycles in the wait loop:
;       ((3 * ilcnt + 3) * olcnt + 3) * waitcnt + 13 + call
;----------------------------------------------------------------
WAIT:
  push         waitcnt          ; Save waitregister
  push         ilcnt            ; Save ilcntregister
  push         olcnt            ; Save olcntregister

Loop:   ldi   olcnt, 224        ; load olcnt register
OLoop:  ldi   ilcnt, 237        ; load ilcnt register
ILoop:  dec   ilcnt             ; decrement ilcnt
  brne        ILoop             ; Continue InnerLoop
  dec         olcnt             ; decrementolcnt
  brne        OLoop             ; Continue OuterLoop
  dec         waitcnt           ; Decrementwait
  brne        Loop              ; Continue Waitloop

  pop         olcnt             ; Restore olcntregister
  pop         ilcnt             ; Restore ilcntregister
  pop         waitcnt           ; Restore waitregister
  ret                           ; Return fromsubroutine


;-----------------------------------------------------------
; Func: Template function header
; Desc: Cut and paste this and fill in the info at the
;		beginning of your functions
;-----------------------------------------------------------
FUNC:							; Begin a function with a label
		; Save variables by pushing them to the stack

		; Execute the function here

		; Restore variables by popping them from the stack,
		; in reverse order

		ret						; End a function with RET

;***********************************************************
;*	Stored Program Data
;***********************************************************

;-----------------------------------------------------------
; An example of storing a string. Note the labels before and
; after the .DB directive; these can help to access the data
;-----------------------------------------------------------
NAMESTR_S:
.DB		"Robert & David  "
NAMESTR_E:
HELLOSTR_S:
.DB		"Hello, world!   "
HELLOSTR_E:

;***********************************************************
;*	Additional Program Includes
;***********************************************************
.include "LCDDriver.asm"		; Include the LCD Driver
