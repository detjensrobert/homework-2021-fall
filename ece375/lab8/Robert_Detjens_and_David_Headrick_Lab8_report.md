---
header-includes:
  - \usepackage{verbatim}
fontsize: 12pt
---

\begin{titlepage}
  \vspace*{4cm}
  \begin{flushright}
  {\huge
    ECE 375 Lab 8\\[1cm]
  }
  {\large
    Morse Code Transmitter
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

In this lab, we used two main routines, endlessly looping in our `MAIN` routine to carry out the requested
functionality. We used polling to listen for button inputs, and Timer/Counter 1 to keep track of time during the morse
code segments. We used a jump table to keep record of every letter of the alphabet, and its associated morse code
sequence. One major difficulty we had was the jump table not working because it kept outputting the letter `A`, but
other than that, this lab was mostly smooth sailing.

# Program Overview

Three main routines were used: `INTRO`, `PROMPT`, and `MORSE`.

`INTRO` displayed a welcome text, and asks the user to press a Button 0 to start, then blocks until that button is
pressed.

`PROMPT` is the main runner function for getting the user input string. It records button presses and store the
corresponding ASCII text into data memory and displays it on the LCD. Polling was used to check for button presses. To
keep track of the current letter, a specific register was used, then when Button 0 is pressed, this register is stored
to the next character in LCDLine2 (tracked with `Y` and a post-increment), then resets back to the default letter of `A`
for the next letter selection. Once the line is full or when Button 4 is pressed, the line is space-terminated and this
procedure returns.

`MORSE` is used to translate the string of characters filled from `PROMPT` in data memory into Morse code output on LEDs
7:5. This procedure uses a jump table and and indirect jump to efficiently perform the correct Morse sequence for each
letter, instead a sequence of comparisons. The start address of this jump table is defined using a label. Each block in
the jump table was padded to 5 instructions with `nop`s, as the maximum length of a letter's morse code sequence is 4
symbols (4 rcalls to DOT/DASH), plus an additional word for a `ret` instruction. To calculate the offset into the jump
table, the following formula was used:

$$JUMP\_TABLE + [(ascii\_letter - \text{'A'}) * 5]$$

As each block in the jump table is 5 words long, this formula will index into the jump table based on the "index" of the
ascii number (0-26), multiplied by 5 for the 5-word padding. This resultant address is stored into `Z` for use with
`icall`.

# Difficulties

Our main difficulties were in trying to get the jump table to work properly.

Initially, we used `call` instructions in the jump table to call the `DOT` and `DASH` functions. This was a problem
because we were expecting each instruction in the table to be 16 bits in order to adhere to the 5-word padding. However,
we forgot that the `call` instruction is a two-word instruction and consumes 32 bits. Switching to using `rcall`s
instead, which are 16 bits, fixed this alignment issue.

Before we jumped to the jump table, we calculated the offset into the jump table. We knew this would fit into 8 bits, so
we just used a register to store the result. However, the final value of the address into the jump table -- after adding
the offset to the base address -- was 16 bits. This ended up causing a 8 bit overflow when adding the offset to the jump
table address, which we didn't account for. We ended up using `ADD` to add the offset and the low byte of base address,
then propagating any overflow to the high byte of the address with `ADC`.

Initially, when using `icall` to perform the call into the jump table, we misinterpreted the instruction set manual. We
thought that the `Z` register held a pointer to where the destination address was. This extra level of indirection was
incorrect, and `Z` holds the destination address directly. Once we realized this, we loaded the destination directly
into Z and the call worked correctly.

The worst difficulty we had was an off-by-one error in our jump table. When performing the morse code transmission, the
first segment of the first letter of the message was always skipped. For example: `AA` would always print out `DASH DOT
DASH`, missing the initial `DOT`. We never found the cause of this error, but we did bodge in a workaround. Before the
message is printed, the letter `E` is printed first. `E` only has one segment (`DOT`), which is always skipped because
of this bug. This ensures that the entire string the user submitted is printed.

In addition, while trying to solve the above off-by-one error, we added a `NOP` into the jump table to try and fix the
off-by-one issue. This didn't fix it, and we forgot to remove it which caused more confusion down the line. We
eventually remembered to remove it, and it worked after.

The simulator proved to be annoying during this lab. Anything that used a timer, e.g. the Morse code delays, took a very
long time to simulate. We had to comment out a few lines and make other modifications to make debugging in the simulator
easier. That being said, the examination tools in the simulator proved to be pivotal when debugging the mentioned issues
with the jump table.

# Conclusion

The hardest part of Lab 8 was the jump table. The jump table took the longest amount of time to debug because of the odd
errors.

As far as the button presses go, our past labs helped us out a lot. We were able to reuse polling code from previous
labs. Not once in this lab did we have a problem with the buttons, just took some fine tuning for the debounce length.

Throughout the source code, we modularized functionality to keep procedures short, clean, and readable. We also used
plenty of comments to document what everything was doing. As the lab was completed over the span of 2 weeks, these
comments were useful to remember what the previously-written code was doing. Once we came back over thanksgiving break,
the well documented, clean code helped us get right back to work.

All of our past labs helped us a lot. Overall, we used a lot of the same techniques used in previous labs. Button
polling, Timer/Counter, and 16-bit add just to name a few. During the course of this whole lab class, we've been
constantly referring to previous labs to remember how something is properly done.

# Source Code

\verbatiminput{Robert_Detjens_and_David_Headrick_Lab8_sourcecode.asm}
