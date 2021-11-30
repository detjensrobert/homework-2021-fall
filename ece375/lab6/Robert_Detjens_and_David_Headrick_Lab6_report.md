---
header-includes:
  - \usepackage{verbatim}
fontsize: 12pt
---

\begin{titlepage}
  \vspace*{4cm}
  \begin{flushright}
  {\huge
    ECE 375 Lab 6\\[1cm]
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

In this lab, we re-implemented the Basic Bump Bot program from previous labs using interrupts instead of polling to
trigger the `HitRight` and `HitLeft` subroutines from before. In addition, we added LCD functionality to the program.
The LCD now displays the number of times the `HitLeft` and `HitRight` functions have been called since the last time the
`ClearLeft` and `ClearRight` subroutines were triggered by interrupts. The main routine of this program does nothing,
since all interactions are triggered by interrupts and run on-demand.

# Program Overview

We setup interrupt vectors for INT0:3. INT0 and INT1 correspond to `HitRight` and `HitLeft` respectively. We also setup
INT2 and INT3 to correspond to `ClearRight` and `ClearLeft`. Within the `HitRight/Left` routines, the original routines
from previous labs were ran and were adapted to increment a general register corresponding to the subroutine hit count.
At the beginning of each routine, the general register was incremented, and the LCD was updated with the new count.

The `ClearLeft/Right` routines simply cleared the general registers corresponding to the respective `HitLeft/Right`
counter. Then, the LCD was updated.

# Additional Questions

- As this lab, Lab 1, and Lab 2 have demonstrated, there are always multiple ways to accomplish the same task when
  programming (this is especially true for assembly programming). As an engineer, you will need to be able to justify
  your design choices. You have now seen the BumpBot behavior implemented using two different programming languages (AVR
  assembly and C), and also using two different methods of receiving external input (polling and interrupts). Explain
  the benefits and costs of each of these approaches. Some important areas of interest include, but are not limited to:
  efficiency, speed, cost of context switching, programming time, understandability, etc.

  One con to polling is that it takes up processor time while the processor could be doing something else. This slows
  the speed of the processor. An advantage of polling is that the processor knows the context and doesn't have to be
  interrupted while doing something else. No context switching needed, thus it doesn't have to be accounted for while
  programming, and makes the flow of the program easier to understand.

  One con to interrupts is that it halts what the processor was doing to service it's subroutine. An advantage to
  interrupts is that the processor doesn't have to waste time polling for the state, thus increasing speed. Reading the
  program from an engineer's view would be harder, because the flow of the program would be less obvious.

  An advantage of C is that it's much more easy to read and can be written faster. C can be compiled to many different
  architectures, and is widely known. A con of C is that your final generated machine code is up to the mercy of the
  compiler. The compiler does the translation of your C code into machine code, and can make good, or bad decisions. In
  the case that the compiler is generating non-optimal, or incorrect machine code, the engineer would still have to peak
  into the assembly to fix the issue.

  An advantage of AVR assembly, and assembly in general, is that the engineer has complete control over the machine
  instructions being produced. This comes at the cost of hard to read, complex code. When writing in just assembly, the
  engineer also doesn't have the assistance of the compiler to them out.

- Instead of using the Wait function that was provided in BasicBumpBot.asm, is it possible to use a timer/counter
  interrupt to perform the one-second delays that are a part of the BumpBot behavior, while still using external
  interrupts for the bumpers? Give a reasonable argument either way, and be

  We could use the timer, however we would have to re-enable interrupts in our interrupt handlers in order to receive
  the timer interrupt. The timer interrupt also has a lower priority than the external interrupts do, so we would be at
  risk of stacking interrupts, which is not desirable for this lab.

# Difficulties

Our "whisker" interrupts were implemented and handled correctly, however one of our clear handlers was falling through
to the next one, causing both counters to be cleared when only one should have been cleared. This was fixed after we
changed the interrupt vector from `jmp ClearLeft` to `rcall ClearLeft; reti`. We aren't sure why this fixed the
issue. The inspiration to change this came from the lecture slides.

# Conclusion

In conclusion, we have learned the basics behind using interrupts, instead of polling, to interact and respond to
outside input. `EIMSK` and `EICRA` were used to initialize INT0:3 with the settings required by the lab.

\pagebreak

# Source Code

\verbatiminput{Robert_Detjens_and_David_Headrick_Lab6_sourcecode.asm}
