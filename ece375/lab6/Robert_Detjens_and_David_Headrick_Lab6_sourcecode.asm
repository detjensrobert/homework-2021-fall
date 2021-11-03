;***********************************************************
;*
;*	Enter Name of file here
;*
;*	Enter the description of the program here
;*
;*	This is the skeleton file for Lab 6 of ECE 375
;*
;***********************************************************
;*
;*	 Author: Enter your name
;*	   Date: Enter Date
;*
;***********************************************************

.include "m128def.inc"			; Include definition file

;************************************************************
;* Variable and Constant Declarations
;************************************************************
.def    mpr = r16                       ; Multi-Purpose Register
.def    waitcnt = r17                   ; WaitFunc Loop Counter
.def    ilcnt = r18                     ; Inner Loop Counter
.def    olcnt = r19                     ; Outer Loop Counter

.def    LW_count = r20
.def    RW_count = r21

.equ    WTime = 100                     ; Time to wait in wait loop

.equ    WskrR = 0                       ; Right Whisker Input Bit
.equ    WskrL = 1                       ; Left Whisker Input Bit
.equ    EngEnR = 4                      ; Right Engine Enable Bit
.equ    EngEnL = 7                      ; Left Engine Enable Bit
.equ    EngDirR = 5                     ; Right Engine Direction Bit
.equ    EngDirL = 6                     ; Left Engine Direction Bit

;/////////////////////////////////////////////////////////////
;These macros are the values to make the TekBot Move.
;/////////////////////////////////////////////////////////////

.equ    MovFwd = (1<<EngDirR|1<<EngDirL)  ; Move Forward Command
.equ    MovBck = $00                      ; Move Backward Command
.equ    TurnR = (1<<EngDirL)              ; Turn Right Command
.equ    TurnL = (1<<EngDirR)              ; Turn Left Command
.equ    Halt = (1<<EngEnR|1<<EngEnL)      ; Halt Command

;***********************************************************
;*	Start of Code Segment
;***********************************************************
.cseg							; Beginning of code segment

;***********************************************************
;*	Interrupt Vectors
;***********************************************************
.org	$0000					; Beginning of IVs
    rjmp	INIT			; Reset interrupt
.org	$0002
    jmp HitRight    ; IRQ0 Handler - right whisker input
.org	$0004
    jmp HitLeft     ; IRQ1 Handler - left whisker input
.org	$0006
    jmp ClearRight  ; IRQ2 Handler - right whisker count clear
.org	$0008
    jmp ClearLeft   ; IRQ3 Handler - left whisker count clear

    ; Set up interrupt vectors for any interrupts being used

    ; This is just an example:
;.org	$002E					; Analog Comparator IV
;		rcall	HandleAC		; Call function to handle interrupt
;		reti					; Return from interrupt

.org	$0046					; End of Interrupt Vectors

;***********************************************************
;*	Program Initialization
;***********************************************************
INIT:							; The initialization routine
    ; Initialize Stack Pointer
    ldi		mpr, low(RAMEND)
    out		SPL, mpr		; Load SPL with low byte of RAMEND
    ldi		mpr, high(RAMEND)
    out		SPH, mpr		; Load SPH with high byte of RAMEND

    ; Initialize Port B for output
    ldi		mpr, $00		; Initialize Port B for outputs
    out		PORTB, mpr		; Port B outputs low
    ldi		mpr, $FF		; Set Port B Directional Register
    out		DDRB, mpr		; for output

    ; Initialize Port D for input
    ldi		mpr, $FF		; Initialize Port D for inputs
    out		PORTD, mpr		; with Tri-State
    ldi		mpr, $00		; Set Port D Directional Register
    out		DDRD, mpr		; for inputs

    ; Initialize TekBot Foward Movement
    ldi		mpr, MovFwd		; Load Move Foward Command
    out		PORTB, mpr		; Send command to motors

    ; Clear registers
    clr   LW_count
    clr   RW_count

    ; Clear LCD memory
    ldi   olcnt,    $20
    ldi   XL,       low(LCD_Line1)
    ldi   XH,       high(LCD_Line1)
    clr   mpr
    Mem_init:
      st      X+,   mpr
      dec     olcnt
      brne    Mem_init

    ; init LCD
    call      LCDInit

    ; Initialize external interrupts
    ; Set the Interrupt Sense Control to falling edge
    ; Set INT0:3 to be on falling edge
    ldi mpr, 0b10101010
    sts EICRA, mpr

    ; Configure the External Interrupt Mask
    ldi mpr, 0b00001111
    sts EIMSK, mpr

    ; Turn on interrupts
    ; NOTE: This must be the last thing to do in the INIT function
    sei


;***********************************************************
;*	Main Program
;***********************************************************
MAIN:							; The Main program

  ; update LCD

  ; convert left count to string in LCD mem
  mov       mpr,  LW_count
  ldi       XL,   LOW(LCD_Line1)
  ldi       XH,   HIGH(LCD_Line1)
  call      Bin2ASCII

  ; convert right count to string in LCD mem
  mov       mpr,  RW_count
  ldi       XL,   LOW(LCD_Line2)
  ldi       XH,   HIGH(LCD_Line2)
  call      Bin2ASCII

  call      LCDWrite

  rjmp      MAIN

;-----------------------------------------------------------
; Func: ClearLeft
; Desc: Clear the hit count register for left whisker
;-----------------------------------------------------------
ClearLeft:
  cli   ; disable interrupts
  clr   LW_count  ; clear counter register
  sei   ; reenable interrupts
  reti

;-----------------------------------------------------------
; Func: ClearRight
; Desc: Clear the hit count register for right whisker
;-----------------------------------------------------------
ClearRight:
  cli   ; disable interrupts
  clr   RW_count  ; clear counter register
  sei   ; reenable interrupts
  reti

;----------------------------------------------------------------
; Sub:  HitRight
; Desc: Handles functionality of the TekBot when the right whisker
;       is triggered.
;----------------------------------------------------------------
HitRight:
  ; immediately disable interrupts
  cli

  push        mpr               ; Save mprregister
  push        waitcnt           ; Save waitregister
  in          mpr, SREG         ; Save programstate
  push        mpr               ;

  ; Move Backwards for a second
  ldi         mpr, MovBck       ; Load Move Backwardcommand
  out         PORTB, mpr        ; Send command toport
  ldi         waitcnt, WTime    ; WaitFunc for 1 second
  rcall       WaitFunc              ; Call waitfunction

  ; Turn left for a second
  ldi         mpr, TurnL        ; Load Turn LeftCommand
  out         PORTB, mpr        ; Send command toport
  ldi         waitcnt, WTime    ; WaitFunc for 1second
  rcall       WaitFunc              ; Call waitfunction

  ; Move Forward again
  ldi         mpr, MovFwd       ; Load Move Forwardcommand
  out         PORTB, mpr        ; Send command toport

  pop         mpr               ; Restore programstate
  out         SREG, mpr         ;
  pop         waitcnt           ; Restore waitregister
  pop         mpr               ; Restorempr

  inc         RW_count          ; increment right whisker hit count

  ; reenable interrupts once finished
  sei

  reti                          ; Return from interrupt

;----------------------------------------------------------------
; Sub:  HitLeft
; Desc: Handles functionality of the TekBot when the left whisker
;       is triggered.
;----------------------------------------------------------------
HitLeft:
  ; immediately disable interrupts
  cli

  push        mpr               ; Save mprregister
  push        waitcnt           ; Save waitregister
  in          mpr, SREG         ; Save programstate
  push        mpr               ;

  ; Move Backwards for a second
  ldi         mpr, MovBck       ; Load Move Backward command
  out         PORTB, mpr        ; Send command to port
  ldi         waitcnt, WTime    ; WaitFunc for 1 second
  rcall       WaitFunc              ; Call wait function

  ; Turn right for a second
  ldi         mpr, TurnR        ; Load Turn Left Command
  out         PORTB, mpr        ; Send command toport
  ldi         waitcnt, WTime    ; WaitFunc for 1second
  rcall       WaitFunc              ; Call waitfunction

  ; Move Forward again
  ldi         mpr, MovFwd       ; Load Move Forward command
  out         PORTB, mpr        ; Send command to port

  pop         mpr               ; Restore program state
  out         SREG, mpr         ;
  pop         waitcnt           ; Restore wait register
  pop         mpr               ; Restorempr

  inc         LW_count          ; increment left whisker hit count

  ; reenable interrupts once finished
  sei

  reti                          ; Return from interrupt

;----------------------------------------------------------------
; Sub:  WaitFunc
; Desc: A wait loop that is 16 + 159975*waitcnt cycles or roughly
;       waitcnt*10ms.  Just initialize wait for the specific amount
;       of time in 10ms intervals. Here is the general eqaution
;       for the number of clock cycles in the wait loop:
;       ((3 * ilcnt + 3) * olcnt + 3) * waitcnt + 13 + call
;----------------------------------------------------------------
WaitFunc:
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
  brne        Loop              ; Continue Funcloop

  pop         olcnt             ; Restore olcntregister
  pop         ilcnt             ; Restore ilcntregister
  pop         waitcnt           ; Restore waitregister
  ret                           ; Return fromsubroutine

;***********************************************************
;*	Stored Program Data
;***********************************************************

; Enter any stored data you might need here

;***********************************************************
;*	Additional Program Includes
;***********************************************************

.include "LCDDriver.asm"

;***********************************************************
;*	Data Memory Allocation
;***********************************************************

.dseg
.org	$0100
LCD_Line1:	.byte $10
.org	$0110
LCD_Line2:	.byte $10
