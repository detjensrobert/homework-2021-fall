---
header-includes:
  - \usepackage{verbatim}
fontsize: 12pt
---

\begin{titlepage}
  \vspace*{4cm}
  \begin{flushright}
  {\huge
    ECE 375 Lab 1\\[1cm]
  }
  {\large
    Introduction to AVR Tools
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

The lab write-up should be done in the style of a professional report/white paper. Proper headers need to be used and written in a clean, professional style. Proof read the report to eliminate both grammatical errors and spelling. The introduction should be a short 1-2 paragraph section discussing what the purpose of this lab is. This is not merely a copy from the lab handout, but rather your own personal opinion about what the object of the lab is and why you are doing it. Basically, consider the objectives for the lab and what you learned and then briefly summarize them. For example, a good introduction to lab 1 may be as follows.

The purpose of this first lab is to provide an introduction on how to use AVRStudio4 software for this course along with connecting the AVR board to the TekBot base. A simple pre-made “BumpBot” program was provided to practice creating a project in AVRStudio4, building the project, and then using the Universal Programmer to download the program onto the AVR board.

# Program Overview

This section provides an overview of how the assembly program works. Take the time to write this section in a clear and concise manner. You do not have to go into so much detail that you are simply repeating the comments that are within your program, but simply provide an overview of all the major components within your program along with how each of the components work. Discuss each of your functions and subroutines, interesting program features such as data structures, program flows, and variables, and try to avoid nitty-gritty details. For example, simple state that you “First initialized the stack pointer,” rather than explaining that you wrote such and such data values to each register. These types of details should be easily found within your source code. Also, do not hesitate to include figures when needed. As they say, a picture is worth a thousand words, and in technical writing, this couldn’t be truer. You may spend 2 pages explaining a function which could have been better explained through a simple program-flow chart. As an example, the remainder of this section will provide an overview for the basic BumpBot behavior.

The BumpBot program provides the basic behavior that allows the TekBot to react to whisker input. The TekBot has two forward facing buttons, or whiskers, a left and a right whisker. By default the TekBot will be moving forward until one of the whiskers are triggered. If the left whisker is hit, then the TekBot will backup and then turn right for a bit, while a right whisker hit will backup and turn left. After the either whisker routine completes, the TekBot resumes its forward motion.

Besides the standard INIT and MAIN routines within the program, three additional routines were created and used. The HitRight and HitLeft routines provide the basic functionality for handling either a Right or Left whisker hit, respectively. Additionally a Wait routine was created to provide an extremely accurate busy wait, allowing time for the TekBot to backup and turn.

# Additional Questions

- What font is used for the source code portion of the report?

  Monospaced font at down to 8pt size.

- What is the naming format for source code submissions?

  `$FIRST_$LAST_and_$FIRST_$LAST_$LAB_sourcecode.asm`

- What are pre-compiler directives?

  These are special instructions that the assembler reads to do stuff unrelated to the actual opcodes, such as setting the memory location of things, or setup memory.

  `.def` vs `.equ`?

  `.def` adds a symbolic name for a register, allowing for descriptive names much like a variable.  `.equ` does the same but for an expression, somewhat like `#DEFINE` in C.

- Determine the binary values for the following:

  - `(1 <<5)`: `00100000`
  - `(4 <<4)`: `01000000`
  - `(8 >>1)`: `00000100`
  - `(5 <<0)`: `00000101`
  - `(8 >>2|1 <<6)` `01000010`

- Describe the following instructions:
  - ADIW: add an immediate 16-bit value to a register pair
  - BCLR: clears a flag in the status register
  - BRCC: Jump if the carry is not set
  - BRGE: Jump if the sign flag is set
  - COM: Performs one's compliment on target register
  - EOR: XOR between two registers
  - LSL: Shift register left one bit, evicted bit set to carry flag
  - LSR: Shift register right one bit, evicted bit set to carry flag
  - NEG: Performs two's complement on target register
  - OR: ORs two registers
  - ORI: ORs register with immediate value
  - ROL: Shift register left, new bit from carry flag
  - ROR: Shift register right, new bit from carry flag
  - SBC: Subtract two registers and the carry flag
  - SBIW: Subtracts 16-bit constant from two registers
  - SUB: Subtracts two registers (without carry)

# Difficulties

I originally installed the GNU GCC AVR toolchain, but the code from this class requires the Atmel AVR assembler instead. Tracking down a Linux version of that proved to be somewhat tricky, but I did eventually find it.

# Conclusion

Text goes here

# Source Code

## Standard source code

\verbatiminput{Robert_Detjens_and_David_Headrick_Lab1_sourcecode.asm}
