# ECE 375 Homework 4

## Robert Detjens

---

### 1. Suppose that you want to build an ALU which performs addition using 5-bit operands. For this homework you will utilize a Ripple Carry Adder as illustrated below. Assume that all digital input signals arrive simultaneously.

(a) How many OR gates will you need in order to implement the 5-bit RCA?

    $1 * 5 = \bold{5}$

(b) How many AND gates will you need in order to implement the 5-bit RCA?

    $3 * 5 = \bold{15}$

(c) How many exclusive-OR gates will you need in order to implement the 5-bit RCA?

    $2 * 5 = \bold{10}$

(d) How many gate delays (abbreviated as “gds”) are required in order for the RCA to compute the first sum
bit (S~0~)?

    **2**

(e) How many gate delays (abbreviated as “gds”) are required in order for the RCA to compute the second
sum bit (S~1~)?

    **3**

(f) How many gate delays are required in order for the RCA to compute the output carry bit (C~5~)?

    **10**

(g) Imagine that you have insider knowledge regarding the value of Cin. For the application in question, you are
informed that Cin will always have a value of 0. Armed with this information, how many logic gates would we be able to
eliminate from the schematic? Hint: C~1~ and S~0~ will only depend on the value of X~0~ and Y~0~

    **4**, all in the first adder; the second XOR can be removed, and the AND/OR complex for the carry out can be
    simplified to a single AND on the two inputs.

### 2. For each of the math problems below, indicate what values the AVR microcontroller will assign to each of the following flags:

| Flags           | Carry | oVerflow | Negative | Sign | Zero |
| --------------- | ----- | -------- | -------- | ---- | ---- |
| (a) $21 - 32$   | 1     | 0        | 1        | 1    | 0    |
| (b) $93 + 112$  | 0     | 0        | 1        | 1    | 0    |
| (c) $-3 - -100$ | 0     | 0        | 0        | 0    | 0    |
| (d) $120 + 136$ | 1     | 1        | 0        | 1    | 1    |
| (e) $-33 - 7$   | 0     | 0        | 1        | 1    | 0    |

\pagebreak

### 3. Please read section 120 of the AVR Instruction Set Manual and review operation of the `STD Z+q, Rr` instruction (an indirect store with displacement).

(a) List and explain the sequence of microoperations required to implement this instruction on the enhanced AVR datapath
(Figure 8.26 in the textbook). Note that this instruction takes two execute cycles (EX1 and EX2).

1. `DMAR` <- `Z` + `q`
2. `mem[DMAR]` <- `Rr`

(b) List and explain the control signals and the Register Address Logic (RAL) output for the STD Z+q, Rr instruction.
Clearly explain your reasoning. Control signals for the Fetch cycle are given below.

| Control Signals | IF   | EX1  | EX2  |
| --------------- | ---- | ---- | ---- |
| MJ              | 0    | x    | x    |
| MK              | 0    | x    | x    |
| ML              | 0    | x    | x    |
| IR_en           | 1    | 0    | x    |
| PC_en           | 1    | 0    | 0    |
| PCh_en          | 0    | 0    | 0    |
| PCl_en          | 0    | 0    | 0    |
| NPC_en          | 1    | x    | x    |
| SP_en           | 0    | 0    | 0    |
| DEMUX           | x    | x    | x    |
| MA              | x    | x    | x    |
| MB              | x    | x    | 1    |
| ALU_f           | xxxx | xxxx | xxxx |
| MC              | xx   | xx   | 00   |
| RF_wA           | 0    | 0    | 0    |
| RF_wB           | 0    | 0    | 0    |
| MD              | x    | x    | 1    |
| ME              | x    | x    | 1    |
| DM_r            | x    | x    | 0    |
| DM_w            | 0    | 0    | 1    |
| MF              | x    | 1    | x    |
| MG              | x    | 1    | x    |
| Adder_f         | xx   | 00   | xx   |
| Inc_Dec         | x    | x    | x    |
| MH              | x    | 1    | x    |
| MI              | x    | x    | x    |

| RAL Output | EX1     | EX2 |
| ---------- | ------- | --- |
| wA         | x       | x   |
| wB         | x       | x   |
| rA         | Z~HIGH~ | x   |
| rB         | Z~LOW~  | Rr  |

In the first cycle, Z~HIGH~ and ~Z~LOW~ are read from the register file via `rA` and `rB`. The combined result and
offset are routed through the address adder by setting `MG` and `MF`, and the added result is sent to `DMAR` by setting
`MH`. All other control signals don't matter except `IR_en`, `DM_w`, `PC_en`, and `SP_en` which all need to be cleared
to not overwrite the IR register, Data Memory, PC register, and SP register.

The second cycle again has `PC_en`, and `SP_en` cleared to prevent overwriting. Memory is read by enabling `MD` to send
`DMAR` to memory and setting `DM_R`. This result is sent to the register file (`mB`) by setting `rB` to `rR`, setting
`MB` and clearing `MC`, and setting `RF_rA`.
