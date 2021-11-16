---
fontsize: 12pt

monofont: 'Hack'
monofontoptions: 'Scale=0.6'
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

# Program Overview

# Additional Questions

1. In this lab, you used the Fast PWM mode of both 8-bit Timer/Counters, which
   is only one of many possible ways to implement variable speed on a TekBot.
   Suppose instead that you used just one of the 8-bit Timer/Counters in Normal
   mode, and had it generate an interrupt for every overflow. In the overflow
   ISR, you manually toggled both Motor Enable pins of the TekBot, and wrote a
   new value into the Timer/Counter’s register. (If you used the correct
   sequence of values, you would be manually performing PWM.) Give a detailed
   assessment (in 1-2 paragraphs) of the advantages and disadvantages of this
   new approach, in comparison to the PWM approach used in this lab.

2. The previous question outlined a way of using a single 8-bit Timer/Counter
   in Normal mode to implement variable speed. How would you accomplish the
   same task (variable TekBot speed) using one or both of the 8- bit
   Timer/Counters in CTC mode? Provide a rough-draft sketch of the
   Timer/Counter-related parts of your design, using either a flow chart or some
   pseudocode (but not actual assembly code).



# Difficulties

# Conclusion

# Source Code

```asm

```
