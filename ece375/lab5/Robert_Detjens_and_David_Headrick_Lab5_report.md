---
fontsize: 12pt

monofont: 'Hack'
monofontoptions: 'Scale=0.6'
---

\begin{titlepage}
  \vspace*{4cm}
  \begin{flushright}
  {\huge
    ECE 375 Lab 5\\[1cm]
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

In this lab, we implemented three large number functions for the ATMega128: ADD16, SUB16, and MUL26. the AVR instruction
set can only work with 8 bits at a time, so working with multi-byte values needs to be done in 1-byte chunks. This means
the functions written in this lab have to coordinate multiple 8 bit instructions to operate on 16 or 24 bits at a time.

# Program Overview

Within the ADD16 function, data is loaded in from program memory. Next, the lower 8 bits are added using ADD. Then, the
high byte is added with ADC, which will also bring in the carry bit from the first add. Finally, the high and low
results of these two operations is stored into the result in data memory.

The SUB16 function works very much the same as the ADD16 function, except using SUB and SBC for subtracting the 8 bit
high and low values.

The MUL24 function uses the shift-and-add challenge algorithm to perform a multiplication on two 24 bit numbers. The
result of this function was stored in a 42 bit space in data memory.

# Additional Questions

- Although this lab dealt with unsigned numbers, the ATmega128 microcontroller has features for performing signed
  arithmetic. What does the V flag in the status register indicate? Give an example (in binary) of two 8-bit values that
  will cause the V flag to be set when they are added together.

  The V flag in the status register is an indication that there was a two's complement overflow. For example, if two
  positive, signed numbers were added together and the result were negative, then the V flag in the status register
  would become set due to the two's complement overflow during addition.

  This 8 bit signed binary addition example would set the V flag:

  ```
      0b 01100000
    + 0b 01000000
    = 0b 10100000
  ```

- In the skeleton file for this lab, the `.BYTE` directive was used to allocate some data memory locations for MUL16’s
  input operands and result. What are some benefits of using this directive to organize your data memory, rather than
  just declaring some address constants using the `.EQU` directive?

  One advantage to using the `.BYTE` directive vs. many `.EQU` directives is that human error can interfere with correct
  address reservation. If you accidentally declare the wrong address, it could write over the data of the previous
  operand. With the `.ORG` and `.BYTE` directives, the assembler automatically declares the correct addresses for you,
  given the number of bytes you need. This reduces the risk of error.

# Difficulties

One difficulty in this lab was organizing the memory for MUL24. Many different locations in memory were involved, so we
had to sit down and write out a plan for where it all was going to end up.

# Conclusion

In conclusion, we have learned the basics of large number operations on the ATMega128 by writing multiple large number
functions in assembly. In addition, we also learned how to better manage our memory to efficiently store and compute
large numbers.

# Source Code
