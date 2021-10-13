---
fontsize: 12pt
---

\begin{titlepage}
  \vspace*{4cm}
  \begin{flushright}
  {\huge
    ECE 375 Lab 3\\[1cm]
  }
  {\large
    Intro to AVR Simulation
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

# Lab Questions

1. What is the initial value of DDRB?

   `00`

2. What is the initial value of PORTB?

   `00`

3. Based on the initial values of DDRB and PORTB, what is Port B’s default I/O configuration?

   Input with no pull-up resistor.

4. What 16-bit address (in hexadecimal) is the stack pointer initialized to?

   `10FF`

5. What are the contents of register r0 after it is initialized?

   `FF`

6. How many times did the code inside of LOOP end up running?

   4 times

7. Which instruction would you modify if you wanted to change the number of times that the loop runs?

   `ldi i, $04` -- change the immediate value to the desired count

8. What are the contents of register r1 after it is initialized?

   `AA`

9. What are the contents of register r2 after it is initialized?

   `0F`

10. What are the contents of register r3 after it is initialized?

    `0F`

11. What is the value of the stack pointer when the program execution is inside the FUNCTION subroutine?

    `10FD`

12. What is the final result of FUNCTION? (What are the hexadecimal contents of memory locations $0105:$0104)?

    `BA:0E`

# Challenge Questions

1. What type of operation does the FUNCTION subroutine perform on its two 16-bit inputs? How can you tell? Give a
   detailed description of the operation being performed by the FUNCTION subroutine.

   This function is adding two 16-bit numbers ($0101:$0100 and $0103:$0102) and stores the result in $0105:$0104.

   It does this by adding each byte of the word separately and propagating the carry to the second add.

2. Currently, the two 16-bit inputs used in the sample code cause the `brcc EXIT` branch to be taken. Come up with two
   16-bit values that would cause the branch NOT to be taken, therefore causing the `st Z, XH` instruction to be
   executed before the subroutine returns.

   Any values that overflow the 16-bit word would cause the carry flag to be set after the second add, and thus avoid
   the branch. E.g., `$aa00` + `$faba`.

3. What is the purpose of the conditionally-executed instruction `st Z, XH`?

   If there was an overflow (i.e. the carry bit was set), this instruction sets the next byte in RAM (`$0106`) to `$01`.
