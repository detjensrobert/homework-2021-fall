;***********************************************************
;*
;*  Robert Detjens & David Headrick Lab 7 Source Code
;*
;***********************************************************
;*
;*   Author: Robert Detjens
;*           David Headrick
;*     Date: 11/10/21
;*
;***********************************************************

.include "m128def.inc"    ; Include definition file

;***********************************************************
;*  Internal Register Definitions and Constants
;***********************************************************
.def  mpr       = r16   ; Multipurpose register
.def  curr_speed = r17   ; current speed level (0-15) * 17


.equ  EngEnR = 4    ; right Engine Enable Bit
.equ  EngEnL = 7    ; left Engine Enable Bit
.equ  EngDirR = 5   ; right Engine Direction Bit
.equ  EngDirL = 6   ; left Engine Direction Bit

;***********************************************************
;*  Start of Code Segment
;***********************************************************
.cseg        ; beginning of code segment

;***********************************************************
;*  Interrupt Vectors
;***********************************************************
.org  $0000
  rjmp  INIT    ; reset interrupt

.org	$0002
  rcall SpeedMax    ; IRQ0 Handler - set maximum speed
  reti
.org	$0004
  rcall SpeedInc    ; IRQ1 Handler - increment speed
  reti
.org	$0006
  rcall SpeedDec    ; IRQ2 Handler - decrement speed
  reti
.org	$0008
  rcall SpeedMin    ; IRQ3 Handler - set minimum speed
  reti

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
  ldi		mpr, $00		; Initialize Port B for outputs
  out		PORTB, mpr	; Port B outputs low
  ldi		mpr, $FF		; Set Port B Directional Register
  out		DDRB, mpr		; for output

  ; Initialize Port D for input
  ldi		mpr, $FF		; Initialize Port D for inputs
  out		PORTD, mpr	; with Tri-State
  ldi		mpr, $00		; Set Port D Directional Register
  out		DDRD, mpr		; for inputs

  ; Configure External Interrupts, if needed

  ; Set the Interrupt Sense Control to falling edge
  ; Set INT0:3 to be on falling edge
  ldi mpr, 0b10101010
  sts EICRA, mpr

  ; Configure the External Interrupt Mask
  ldi mpr, 0b00001111
  out EIMSK, mpr

  ; Configure 8-bit Timer/Counters

  ; Enable PWM with no prescaling, set on OCR clear on overflow.
  ldi mpr,    0b01101001  ; WGM00 | WGM01 | COM01 | CS00
  out TCCR0,  mpr   ; T/C 0
  out TCCR2,  mpr   ; T/C 2

  ; Set TekBot to Move Forward (1<<EngDirR|1<<EngDirL)
  ldi		mpr, (1<<EngDirR|1<<EngDirL)
  out		PORTB, mpr    ; Send command to motors

  ; Set initial speed, display on Port B pins 3:0
  ldi   curr_speed,  0  ; start at full speed
  rcall UpdateTimers

  ; Enable global interrupts (if any are used)
  sei

;***********************************************************
;*  Main Program
;***********************************************************
MAIN:
  ; poll Port D pushbuttons (if needed)

        ; if pressed, adjust speed
        ; also, adjust speed indication

  rjmp  MAIN    ; return to top of MAIN

;***********************************************************
;*  Functions and Subroutines
;***********************************************************

;-----------------------------------------------------------
; Func:   SpeedMax
; Desc:   GO TO PLAID
;-----------------------------------------------------------
SpeedMax:

  ldi   curr_speed,   15
  rcall UpdateTimers

  ; clear interrupt
  ldi   mpr,    0b00001111
  out   EIFR,   mpr

  ret

;-----------------------------------------------------------
; Func:   SpeedInc
; Desc:   Increment speed level by one
;-----------------------------------------------------------
SpeedInc:

  cpi   curr_speed, 15
  brge  Inc_noop
    ; only increment if below max
    inc   curr_speed
  Inc_noop:
  rcall UpdateTimers

  ; clear interrupt
  ldi   mpr,    0b00001111
  out   EIFR,   mpr

  ret

;-----------------------------------------------------------
; Func:   SpeedDec
; Desc:   Decrement speed level by one
;-----------------------------------------------------------
SpeedDec:

  cpi   curr_speed,   0
  breq  Dec_noop
    ; only decrement if above min
    dec   curr_speed
  Dec_noop:
  rcall UpdateTimers

  ; clear interrupt
  ldi   mpr,    0b00001111
  out   EIFR,   mpr

  ret

;-----------------------------------------------------------
; Func:   SpeedMin
; Desc:   Set minimum speed
;-----------------------------------------------------------
SpeedMin:

  ldi   curr_speed,   0
  rcall UpdateTimers

  ; clear interrupt
  ldi   mpr,    0b00001111
  out   EIFR,   mpr

  ret

;-----------------------------------------------------------
; Func:   UpdateTimers
; Desc:   Update timers and display with new speed value
;-----------------------------------------------------------
UpdateTimers:
  push  mpr

  ; update leds with current speed
  ldi		mpr,    (1<<EngDirR|1<<EngDirL)
  or    mpr,    curr_speed
  out   PORTB,  mpr
  ; convert speed level to timer match value
  ldi   mpr,    17
  mul   mpr,    curr_speed
  out   OCR0,   mpr
  out   OCR2,   mpr

  pop   mpr
  ret



;***********************************************************
;*  Stored Program Data
;***********************************************************
  ; Enter any stored data you might need here

;***********************************************************
;*  Additional Program Includes
;***********************************************************
  ; There are no additional file includes for this program