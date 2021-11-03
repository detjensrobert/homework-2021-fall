---
fontsize: 12pt
---

\begin{titlepage}
  \vspace*{4cm}
  \begin{flushright}
  {\huge
    ECE 375 Lab 6 Prelab\\[1cm]
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

### 1. In computing, there are traditionally two ways for a microprocessor to listen to other devices and communicate: polling and interrupts. Give a concise overview/description of each method, and give a few examples of situations where you would want to choose one method over the other.

- Polling is when the CPU asks the device "have you got anything?" repeatedly until the device has data ready.

  This may be the only option if the method the CPU and device use to communicate has no way for the device to initiate
  an interrupt.

  Polling may be better if there are a lot of devices and each one interrupting the CPU would consume too much time
  servicing the interrupts.

- Interrupts let the CPU continue doing other things and when the device is ready, it can trigger an interrupt to tell
  the CPU that data is ready.

  This is preferable when I/O devices are slow and would cause the CPU to waste a lot of time waiting for the device to
  be ready.

  This is commonly used in PC storage since if the CPU was blocked continually asking the (comparatively) super slow I/O
  device that would be a whole lot of wasted cycles.

### 2. Describe the function of each bit in the following ATmega128 I/O registers: `EICRA`, `EICRB`, and `EIMSK`. Do not just give a brief summary of these registers; give specific details for each bit of each register, such as its possible values and what function or setting results from each of those values. Also, do not just directly paste your answer from the datasheet, but instead try to describe these details in your own words.

- `EICRA` & `EICRB`: Each pair of bits in these registers control an interrupt (interrupts 0-3 for A, 4-7 for B). The
  possible states of the bitpair are as follows:
  - `00`: interrupt is triggered on a low signal
  - `01`: reserved and not used
  - `10`: interrupt is triggered on the falling edge of a signal (high -> low)
  - `11`: interrupt is triggered on the rising edge of a signal (low -> high)

- `EIMSK`: this register controls which interrupts are enabled. Setting a bit will enable the corresponding interrupt
  (i.e. bit 6 controls Interrupt 6).

\pagebreak

### 3. The ATmega128 microcontroller uses interrupt vectors to execute particular instructions when an interrupt occurs. What is an interrupt vector? List the interrupt vector  (address) for each of the following ATmega128 interrupts: Timer/Counter0 Overflow, External Interrupt 5, and Analog Comparator

| Interrupt          | Vector  |
|--------------------|---------|
| Timer/Counter 0 OF | `$0020` |
| External Int 5     | `$000C` |
| Analog Comparator  | `$002E` |

### 4. Microcontrollers often provide several different ways of configuring interrupt triggering, such as level detection and edge detection. Suppose the signal shown in Figure 1 was connected to a microcontroller pin that was configured as an input and had the ability to trigger an interrupt based on certain signal conditions. List the cycles (or range of cycles) for which an external interrupt would be triggered if that pin’s sense control was configured for:

(a) rising edge detection: interrupt fires when pin changes from low to high
(b) falling edge detection: interrupt fires when pin changes from high to low
(c) low level detection: interrupt fires as long as the pin is low
(d) high level detection: interrupt fires as long as the pin is high
