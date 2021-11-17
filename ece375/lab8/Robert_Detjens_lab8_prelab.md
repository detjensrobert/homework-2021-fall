---
fontsize: 12pt
---

\begin{titlepage}
  \vspace*{4cm}
  \begin{flushright}
  {\huge
    ECE 375 Lab 8 Prelab\\[1cm]
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

### 1. In this lab, you will be utilizing Timer/Counter1, which can make use of several 16 bit timer registers. The datasheet describes a particular manner in which these registers must be manipulated. To illustrate the process, write a snippet of assembly code that configures `OCR1A` with a value of `0x3FA5`. For the sake of simplicity, you may assume that no interrupts are triggered during your code’s operation.

```asm
; ...
.def  mpr = r16
; ...
ldi   mpr,    0x3f
out   OCR1AH, mpr
ldi   mpr,    0xA5
out   OCR1AL, mpr
```
