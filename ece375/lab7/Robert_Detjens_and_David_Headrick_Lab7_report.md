---
header-includes:
  - \usepackage{verbatim}
fontsize: 12pt
---


\begin{titlepage}
  \vspace*{4cm}
  \begin{flushright}
  {\huge
    ECE 375 Lab 7\\[1cm]
  }
  {\large
    External Interrupts
  }
  \end{flushright}
  \begin{flushleft}
  Lab Time: Wednesday 10a-12n
  \end{flushleft}
  \begin{flushright}
  Robert Detjens

  David Headrick
  \vfill
  \rule{5in}{.5mm}\\
  TA Signature
  \end{flushright}
\end{titlepage}

# Introduction

In this lab, we learned how to use the Timer/Counters on the ATMega128 to perform PWM management on output pins. In
addition, we also learned how to write to different portions of an I/O port at different times. The timers on the board
can be used to generate square waves at a user-configured duty cycle, allowing for easy PWM output on some of the output
pins.

# Program Overview

As this lab does not require the full BumpBot functionality, this program is relatively simple in structure. This
program uses interrupts to react to button inputs and adjusts the necessary outputs in the interrupt handlers. The main
loop of this program does nothing, as all of the need functionality of this program is contained within those handlers.

This program keeps track of the current speed level in one of the chip registers. This level ranges from 0 to 15, the
same as what is shown in the lower half of the LEDs. This makes updating the LED I/O port easy, as this is a direct
store without any conversion necessary (aside from loading the current state of the other half of the pins). To convert
this internal speed value into the correct value to store into the Timers, it is multiplied by 17 to convert to a range
of 0 to 255. This multiplication is done manually via shifting (for $\times 16$) and an subsequent add to get the final
$\times 17$ value. This is then stored into both of the timer count registers to set the new duty cycle.

As both the LED update and the timer update are the same across all of the interrupt handlers, these were broken out
into subprocedures and called from each handler in order to de-duplicate code.

# Additional Questions

1. In this lab, you used the Fast PWM mode of both 8-bit Timer/Counters, which is only one of many possible ways to
   implement variable speed on a TekBot. Suppose instead that you used just one of the 8-bit Timer/Counters in Normal
   mode, and had it generate an interrupt for every overflow. In the overflow ISR, you manually toggled both Motor
   Enable pins of the TekBot, and wrote a new value into the Timer/Counter’s register. (If you used the correct sequence
   of values, you would be manually performing PWM.) Give a detailed assessment (in 1-2 paragraphs) of the advantages
   and disadvantages of this new approach, in comparison to the PWM approach used in this lab.

   One advantage to doing this approach would be that you have an extra 8-bit Timer/Counter at your disposal for any
   other use case. Another advantage is that you'd have more control over the semantics of an overflow in relation to
   the motors.

   Advantages to the PWM method used in this lab would be that you don't have to use an interrupt to control PWM for the
   motor pins, they just get controlled in the background after everything is set up. A drawback of this approach is
   that it occupies both 8-bit counters to essentially do the same operation. If you need more counters, and interrupts
   don't bother you, the previously mentioned method would be optimal.

2. The previous question outlined a way of using a single 8-bit Timer/Counter in Normal mode to implement variable
   speed. How would you accomplish the same task (variable TekBot speed) using one or both of the 8-bit Timer/Counters
   in CTC mode? Provide a rough-draft sketch of the Timer/Counter-related parts of your design, using either a flow
   chart or some pseudocode (but not actual assembly code).

   One 8-bit timer in CTC mode and it's corresponding interrupt could be used to
   perform the same action. The interrupt would be manually changing OCR0 every
   time it overflows to manipulate the duty cycle. The OCR pin would be set to
   toggle every overflow.

   ```asm
   INIT:
    set timer/counter 0 to CTC mode
    set OCR0 to 0x08
    set OCR pin to toggle every overflow

   ISR for Timer/Counter0:
    XOR OCR0 and 0x88 to switch between duty cycle counts
   ```

# Difficulties

We spent a large amount of time troubleshooting why our timer was not being updated by our button interrupts. We were
using the `mul` instruction to convert our stored speed level (0 to 15) into the appropriate timer count level (0 to
255). This was done by multiplying the speed level by 15, and storing that result into the timer. However, we did not
fully understand how the `mul` instruction worked and did not realize it stored the result in a different register pair
instead of updating the first operand with the result. We eventually double checked how it worked and realized this, and
decided instead to switch to a more efficient manual shift-and-add instead of using `mul` since 17 is very close to a
power of two and easily done via shifting.

Aside from this one problem, no other components of this lab gave us much trouble.

# Conclusion

Barring the one issue with using `mul` incorrectly, this lab went smoothly. We feel confident now in our ability to
configure and use the 8-bit Tiemr/Counters functionality for both timing and PWM. There are several roughly-equivalent
ways of performing PWM (as discussed in the previous Questions section), and in researching those for said questions, we
are confident in our ability to use those approaches as well.

\pagebreak

# Source Code

\verbatiminput{Robert_Detjens_and_David_Headrick_Lab7_sourcecode.asm}
