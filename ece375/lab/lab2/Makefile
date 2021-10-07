PROG = Robert_Detjens_and_David_Headrick_Lab2
GDBPORT = 12000

CFLAGS = -mmcu=avr51 -std=gnu99 -D__AVR_ATmega128__ -O

compile: $(PROG)_sourcecode.c
	avr-gcc -g $(CFLAGS) -o $(PROG)_out.elf $(PROG)_sourcecode.c
	avr-objcopy -O ihex -j .text -j .data $(PROG)_out.elf $(PROG)_out.hex

challenge: $(PROG)_challengecode.c
	avr-gcc -g $(CFLAGS) -o $(PROG)_out.elf $(PROG)_challengecode.c
	avr-objcopy -O ihex -j .text -j .data $(PROG)_out.elf $(PROG)_out.hex

example:
	avr-gcc $(CFLAGS) -o $(PROG)_out.elf dance-bot.c
	avr-objcopy -O ihex -j .text -j .data $(PROG)_out.elf $(PROG)_out.hex

flash:
	avrdude -p m128 -c usbasp -B12 -U flash:w:$(PROG)_out.hex:i

sim:
	echo -e 'target remote localhost:$(GDBPORT)\nsymbol-file $(PROG)_out.elf' > .gdbinit
	simavr --gdb $(GDBPORT) --mcu atmega128 --freq 16000000 $(PROG)_out.elf

clean:
	rm -rf $(wildcard *.hex *.obj *.elf)
