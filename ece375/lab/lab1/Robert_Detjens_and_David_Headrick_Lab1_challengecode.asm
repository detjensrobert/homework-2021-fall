;***********************************************************
;*
;*      BasicBumpBot.asm        -       V2.0
;*
;*      This program contains the neccessary code to enable the
;*      the TekBot to behave in the traditional BumpBot fashion.
;*      It is written to work with the latest TekBots platform.
;*      If you have an earlier version you may need to modify
;*      your code appropriately.
;*
;*      The behavior is very simple.  Get the TekBot moving
;*      forward and poll for whisker inputs.  If the right
;*      whisker is activated, the TekBot backs up for a second,
;*      turns left for a second, and then moves forward again.
;*      If the left whisker is activated, the TekBot backs up
;*      for a second, turns right for a second, and then
;*      continues forward.
;*
;***********************************************************
;*
;*       Author: David Zier and Mohammed Sinky (modification Jan 8, 2009)
;*  MODIFIED BY: Robert Detjens & David Headrick
;*         Date: September 29, 2021
;*      Company: TekBots(TM), Oregon State University - EECS
;*      Version: 2.0
;*
;***********************************************************
;*      Rev     Date    Name            Description
;*----------------------------------------------------------
;*      -       3/29/02 Zier            Initial Creation of Version 1.0
;*      -       1/08/09 Sinky           Version 2.0 modifictions
;*      -       9/29/21 Detjens         Increased wait time
;*
;***********************************************************

.include "m128def.inc"                  ; Include definition file

;************************************************************
;* Variable and Constant Declarations
;************************************************************
.def    mpr = r16                       ; Multi-Purpose Register
.def    waitcnt = r17                   ; Wait Loop Counter
.def    ilcnt = r18                     ; Inner Loop Counter
.def    olcnt = r19                     ; Outer Loop Counter

.equ    WHit = 200                      ; Time to wait before turning
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

;============================================================
; NOTE: Let me explain what the macros above are doing.
; Every macro is executing in the pre-compiler stage before
; the rest of the code is compiled.  The macros used are
; left shift bits (<<) and logical or (|).  Here is how it
; works:
;       Step 1.  .equ   MovFwd = (1<<EngDirR|1<<EngDirL)
;       Step 2.         substitute constants
;                        .equ   MovFwd = (1<<5|1<<6)
;       Step 3.         calculate shifts
;                        .equ   MovFwd = (b00100000|b01000000)
;       Step 4.         calculate logical or
;                        .equ   MovFwd = b01100000
; Thus MovFwd has a constant value of b01100000 or $60 and any
; instance of MovFwd within the code will be replaced with $60
; before the code is compiled.  So why did I do it this way
; instead of explicitly specifying MovFwd = $60?  Because, if
; I wanted to put the Left and Right Direction Bits on different
; pin allocations, all I have to do is change thier individual
; constants, instead of recalculating the new command and
; everything else just falls in place.
;==============================================================

;**************************************************************
;* Beginning of code segment
;**************************************************************
.cseg

;--------------------------------------------------------------
; Interrupt Vectors
;--------------------------------------------------------------
.org    $0000                   ; Reset and Power On Interrupt
  rjmp         INIT             ; Jump to programinitialization

.org    $0046                   ; End of Interrupt Vectors
;--------------------------------------------------------------
; Program Initialization
;--------------------------------------------------------------
INIT:
  ; Initialize the Stack Pointer (VERY IMPORTANT!!!!)
  ldi         mpr,low(RAMEND)
  out         SPL, mpr          ; Load SPL with low byte ofRAMEND
  ldi         mpr,high(RAMEND)
  out         SPH, mpr          ; Load SPH with high byte ofRAMEND

  ; Initialize Port B for output
  ldi         mpr, $FF          ; Set Port B Data DirectionRegister
  out         DDRB, mpr         ; foroutput
  ldi         mpr, $00          ; Initialize Port B DataRegister
  out         PORTB, mpr        ; so all Port B outputs arelow

  ; Initialize Port D for input
  ldi         mpr, $00          ; Set Port D Data DirectionRegister
  out         DDRD, mpr         ; forinput
  ldi         mpr, $FF          ; Initialize Port D DataRegister
  out         PORTD, mpr        ; so all Port D inputs areTri-State

  ; Initialize TekBot Forward Movement
  ldi         mpr, MovFwd       ; Load Move ForwardCommand
  out         PORTB, mpr        ; Send command tomotors

;---------------------------------------------------------------
; Main Program
;---------------------------------------------------------------
MAIN:
  in          mpr, PIND         ; Get whisker input from PortD
  andi        mpr,(1<<WskrR|1<<WskrL)
  cpi         mpr, (1<<WskrL)   ; Check for Right Whisker input (Recall ActiveLow)
  brne        NEXT              ; Continue with nextcheck
  rcall       HitRight          ; Call the subroutineHitRight
  rjmp        MAIN              ; Continue withprogram
NEXT:
  cpi         mpr, (1<<WskrR)   ; Check for Left Whisker input (RecallActive)
  brne        MAIN              ; No Whisker input, continueprogram
  rcall       HitLeft           ; Call subroutineHitLeft
  rjmp        MAIN              ; Continue throughmain

;****************************************************************
;* Subroutines and Functions
;****************************************************************

;----------------------------------------------------------------
; Sub:  HitRight
; Desc: Handles functionality of the TekBot when the right whisker
;       is triggered.
;----------------------------------------------------------------
HitRight:
  push        mpr               ; Save mprregister
  push        waitcnt           ; Save waitregister
  in          mpr, SREG         ; Save programstate
  push        mpr               ;

  ; Move Backwards for a second
  ldi         mpr, MovBck       ; Load Move Backwardcommand
  out         PORTB, mpr        ; Send command toport
  ldi         waitcnt, WHit     ; Wait for 2second
  rcall       Wait              ; Call waitfunction

  ; Turn left for a second
  ldi         mpr, TurnL        ; Load Turn LeftCommand
  out         PORTB, mpr        ; Send command toport
  ldi         waitcnt, WTime    ; Wait for 1second
  rcall       Wait              ; Call waitfunction

  ; Move Forward again
  ldi         mpr, MovFwd       ; Load Move Forwardcommand
  out         PORTB, mpr        ; Send command toport

  pop         mpr               ; Restore programstate
  out         SREG, mpr         ;
  pop         waitcnt           ; Restore waitregister
  pop         mpr               ; Restorempr
  ret                           ; Return fromsubroutine

;----------------------------------------------------------------
; Sub:  HitLeft
; Desc: Handles functionality of the TekBot when the left whisker
;       is triggered.
;----------------------------------------------------------------
HitLeft:
  push        mpr               ; Save mprregister
  push        waitcnt           ; Save waitregister
  in          mpr, SREG         ; Save programstate
  push        mpr               ;

  ; Move Backwards for a second
  ldi         mpr, MovBck       ; Load Move Backwardcommand
  out         PORTB, mpr        ; Send command toport
  ldi         waitcnt, WHit     ; Wait for 2second
  rcall       Wait              ; Call waitfunction

  ; Turn right for a second
  ldi         mpr, TurnR        ; Load Turn LeftCommand
  out         PORTB, mpr        ; Send command toport
  ldi         waitcnt, WTime    ; Wait for 1second
  rcall       Wait              ; Call waitfunction

  ; Move Forward again
  ldi         mpr, MovFwd       ; Load Move Forwardcommand
  out         PORTB, mpr        ; Send command toport

  pop         mpr               ; Restore programstate
  out         SREG, mpr         ;
  pop         waitcnt           ; Restore waitregister
  pop         mpr               ; Restorempr
  ret                           ; Return fromsubroutine

;----------------------------------------------------------------
; Sub:  Wait
; Desc: A wait loop that is 16 + 159975*waitcnt cycles or roughly
;       waitcnt*10ms.  Just initialize wait for the specific amount
;       of time in 10ms intervals. Here is the general eqaution
;       for the number of clock cycles in the wait loop:
;       ((3 * ilcnt + 3) * olcnt + 3) * waitcnt + 13 + call
;----------------------------------------------------------------
Wait:
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
