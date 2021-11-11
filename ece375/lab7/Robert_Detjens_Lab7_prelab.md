---
fontsize: 12pt
---

\begin{titlepage}
  \vspace*{4cm}
  \begin{flushright}
  {\huge
    ECE 375 Lab 7 Prelab\\[1cm]
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

### 1. List the correct sequence of AVR assembly instructions needed to store the contents of registers `R25:R24` into Timer/Counter1’s 16-bit register, `TCNT1`. (You may assume that registers `R25:R24` have already been initialized to contain some 16-bit value.)

```asm
out   TCNT1H,  r25
out   TCNT1L,  r24
```

### 2. List the correct sequence of AVR assembly instructions needed to load the contents of Timer/Counter1’s 16-bit register, `TCNT1`, into registers `R25:R24`.

```asm
in    r25,  TCNT1L
in    r24,  TCNT1H
```

### 3. Suppose Timer/Counter0 (an 8-bit timer) has been configured to operate in Normal mode, and with no prescaling (i.e., $clk_{T0} = clk_{I/O} = 16 MHz$). The decimal value `128` has  just been written into Timer/Counter0’s 8-bit register, `TCNT0`. How long will it take for the `TOV0` flag to become set? Give your answer as an amount of time, not as a number of cycles.

Timer/Counter 0 overflows at decimal value 255, so the counter needs 128 cycles to increment up and overflow. 128 cycles
at 16 MHz occurs in 0.000000008 ($8*10^{-6}$) seconds.
