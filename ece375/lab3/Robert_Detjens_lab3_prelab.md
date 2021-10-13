---
fontsize: 12pt
---

\begin{titlepage}
    \vspace*{4cm}
    \begin{flushright}
    {\huge
        ECE 375 Lab 3 Prelab\\[1cm]
    }

    \end{flushright}
    \begin{flushleft}
    Lab Time: Wednesday 10a-12n
    \end{flushleft}
    \begin{flushright}
    Robert Detjens

    \vfill
    \rule{5in}{.5mm}\\
    TA Signature
    \end{flushright}

\end{titlepage}

\pagebreak

### 1. What are some differences between the debugging mode and run mode of the AVR simulator? What do you think are some benefits of each mode?

Run mode will run the program at full speed, useful to check that the program is e.g. sleeping the correct length. Debug mode steps through the code line-by-line which allows you to closely inspect the state of the chip after each instruction for fine-grained debugging.

### 2. What are breakpoints, and why are they useful when you are simulating your code?

Breakpoints with stop (break) execution where set, allowing for easy debugging of a single / few lines without having to step through the rest of the program waiting to get back to the lines under inspection.

### 3. Explain what the I/O View and Processor windows are used for. Can you provide input to the simulation via these windows?

The I/O window shows the current state of all the I/O ports, timers, and other non-CPU registers on the board. Simulated input can be entered in the I/O pane. The Processor window shows the state of all the registers in the CPU, such as the PC and GPRs.

### 4. The ATmega128 microcontroller features three different types of memory: data memory, program memory, and EEPROM. Which of these memory types can you access by using the Memory window of the simulator?

(e) **[All three types]**
