PROG = q1
GDBPORT = 12000

asm: $(PROG).asm
	avra $(PROG).asm -o $(PROG)_out.hex

sim:
	echo 'target remote localhost:$(GDBPORT)' > .gdbinit
	simavr --gdb $(GDBPORT) --mcu atmega128 --freq 16000000 $(PROG)_out.hex

clean:
	rm -rf $(wildcard *.hex *.obj)
