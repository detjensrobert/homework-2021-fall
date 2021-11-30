---
header-includes:
  - \usepackage{verbatim}
fontsize: 12pt
---


\begin{titlepage}
  \vspace*{4cm}
  \begin{flushright}
  {\huge
    ECE 375 Lab 4\\[1cm]
  }
  {\large
    Data Manipulation \& the LCD
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

This lab is an introduction to using the LCD Driver library and manipulating
data in both program and data memory.

# Program Overview

This program initializes the chip and LCD, and in response to button presses
displays or clears text on the LCD.

In more detail, this program:

- initializes the stack pointer to allow for subroutine calls
- clears the LCD
- copies string constants from program memory into data memory
- listens to button presses and displays different text for different buttons

# Additional Questions

1. In this lab, you were required to move data between two memory types: program
   memory and data memory. Explain the intended uses and key differences of
   these two memory types.

    Program memory is read only and is the only location that can contain
    program code. Data memory is the actual RAM on the MCU and is where all data
    -- i.e. everything that is not instructions -- should be located to be used
    by the program.

2. You also learned how to make function calls. Explain how making a function
   call works (including its connection to the stack), and explain why a RET
   instruction must be used to return from a function.

   When running the `CALL` instruction, the address of the next instruction
   after the `CALL` is pushed to the stack. When `RET`tig, it pops that address
   back off the stack and goes back to that location. If that address is not
   popped off the stack when returning, it will stay around and cause problems
   as there is now extra stuff on the stack that probably is not supposed to be
   there anymore.

3. To help you understand why the stack pointer is important, comment out the
   stack pointer initialization at the beginning of your program, and then try
   running the program on your mega128 board and also in the simulator. What
   behavior do you observe when the stack pointer is never initialized? In
   detail, explain what happens (or no longer happens) and why it happens.

  If the stack pointer is not correctly /initialized, the first time that
  subroutine (e.g. `LCDInit`) tries to `RET`, it gets a bogus address from
  uninitialized memory and faults and restarts the execution from the top.

# Difficulties

Initially, the stack pointer was incorrectly initialized with the high byte
actually getting set to the low byte of the stack address. This was not caught
for several minutes and caused much confusion before realizing our simple
mistake.

We also were not initially aware that the `LCDClr` proc cleared the data in Data
memory, and only thought that it cleared the LCD directly. After realizing this,
we then correctly re-copied the strings back into memory after clearing.

# Conclusion

After exploring this lab, we now feel confident in interacting with data in both
memory pools and calling functions either within or externally defined.

# Source Code

\verbatiminput{Robert_Detjens_and_David_Headrick_Lab4_sourcecode.asm}
