---
fontsize: 12pt
---

\begin{titlepage}
  \vspace*{4cm}
  \begin{flushright}
  {\huge
    ECE 375 Lab 4 Prelab\\[1cm]
  }

  \end{flushright}
  \begin{flushleft}
  Lab Time: Wednesday 1-12n
  \end{flushleft}
  \begin{flushright}
  Robert Detjens

  \vfill
  \rule{5in}{.5mm}\\
  TA Signature
  \end{flushright}

\end{titlepage}

\pagebreak

### 1. What is the stack pointer? How is the stack pointer used, and how do you initialize it? Provide pseudocode (not actual assembly code) that illustrates how to initialize the stack pointer.

The stack pointer keeps track of where the top of the stack is. On AVR, the stack grows down the end of memory.
Subroutine calls use the stack to save the execution address before jumping to the subroutine.

Initializing the stack pointer is done by loading the address of the end of RAM into the stack register (`SPH` / `SPL`).

```
move low byte of RAMEND into SPL
move high byte of RAMEND into SPH
```

### 2. What does the AVR instruction `LPM` do, and how do you use it? Provide pseudocode (not actual assembly code) that shows how to setup and use the `LPM` instruction.

`LPM` is used to load constants from the data memory into `r. In order to use `LPM`, the address of the data needs to
be multiplied by two and the low/high bytes stored into `Z`.

```
byte address is 2 * address of data
move low byte of byte address into ZL
move high byte of byte address into ZH
lpm -- load byte from byte address into r0
```

### 3. Take a look at the definition file `m128def.inc` What is contained within this definition file? What are some of the benefits of using a definition file like this? Please be specific, and give a couple examples if possible.

This file contains the hardware-specific register address constants needed for cross-chip AVR assembly. Without this
file, addresses of these registers would need to be entered manually and changed for whatever specific chip was being
targeted. However, since the assembly code is using these constants, the underlying addresses can be adjusted for the
layouts of different chips.
