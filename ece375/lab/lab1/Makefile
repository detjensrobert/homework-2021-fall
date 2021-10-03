PROG = Robert_Detjens_and_David_Headrick_Lab1
GDBPORT = 12000

asm: $(PROG)_sourcecode.asm
	avra $(PROG)_sourcecode.asm -o $(PROG)_out.hex

chal: $(PROG)_challengecode.asm
	avra $(PROG)_challengecode.asm -o $(PROG)_out.hex

flash: $(PROG)_out.hex
	avrdude -p m128 -c usbasp -B12 -U flash:w:$(PROG)_out.hex:i

sim:
	simavr --gdb $(GDBPORT) --mcu atmega128 $(PROG)_out.hex

clean:
	rm -rf $(wildcard *.hex *.obj)
