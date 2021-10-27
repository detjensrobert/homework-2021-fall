---
fontsize: 12pt
---

\begin{titlepage}
  \vspace*{4cm}
  \begin{flushright}
  {\huge
    ECE 375 Lab 5 Prelab\\[1cm]
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

### 1. For this lab, you will be asked to perform arithmetic operations on numbers that are larger than 8 bits. To be successful at this, you will need to understand and utilize many of the various arithmetic operations supported by the AVR 8-bit instruction set. List and describe all of the addition, subtraction, and multiplication instructions (i.e. ADC, SUBI, FMUL, etc.) available in AVR’s 8-bit instruction set.

- ADC add two registers
- ADD add two registers and the carry bit
- ADIW add immediate to word
- DEC decrement register by 1
- FMUL fractional multiply (both unsigned)
- FMULS fractional multiply (both signed)
- FMULSU fractional multiply (signed with unsigned)
- INC increment register by 1
- MUL multiply (both unsigned)
- MULS multiply (both signed)
- MULSU multiply (signed with unsigned)
- SBCI subtract register and carry constant from register
- SBIW subtract immediate from word
- SUB subtract two registers
- SUBC subtract register and carry bit from register
- SUBI subract immediate from tegister

### 2. Write pseudocode for an 8-bit AVR function that will take two 16-bit numbers (from data memory addresses `$0111:$0110` and `$0121:$0120`), add them together, and then store the 16-bit result (in data memory addresses `$0101:$0100`). (Note: The syntax `$0111:$0110` is meant to specify that the function will expect little-endian data, where the highest byte of a multi-byte value is stored in the highest address of its range of addresses.)

1. clear carry
2. add `$0110` and `$0120`
3. store result into `$0100`
4. add `$0111` and `$0121` with carry
5. store result into `$0101`

### 3. Write pseudocode for an 8-bit AVR function that will take the 16-bit number in `$0111:$0110`, subtract it from the 16-bit number in `$0121:$0120`, and then store the 16-bit result into `$0101:$0100`

1. set carry
2. sub `$0120` from `$0110`
3. store result into `$0100`
4. sub `$0121` from `$0111` with carry
5. store result into `$0101`
