---
fontsize: 12pt
---

\begin{titlepage}
    \vspace*{4cm}
    \begin{flushright}
    {\huge
        ECE 375 Prelab 1\\[1cm]
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

# Questions

1. Suppose you want to configure Port B so that all 8 of its pins are configured
   as outputs. Which I/O register is used to make this configuration, and what
   8-bit binary value must be written to configure all 8 pins as outputs?

   `DDRB` controls the direction of port B. To set all pins as outputs, all bits
   are set to 1 and `11111111` is written.

2. Suppose all 8 of Port D’s pins have been configured as inputs. Which I/O
   register must be used to read the current state of Port D’s pins?

   `PIND` holds the current input reading for port D.

3. Does the function of a PORTx register differ depending on the setting of its
   corresponding DDRx register? If so, explain any differences

   Yes, writing to `PORTx` when the pin is configured as input activates a
   pull-up resistor for that pin.

# Reference

Course textbook, section 5.2.1.
