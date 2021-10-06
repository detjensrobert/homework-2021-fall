/*
This code will cause a TekBot connected to the AVR board to move forward and
when it touches an obstacle, it will reverse and turn away from the obstacle and
resume forward motion.

AUTHORS:
- Robert Detjens
- David Headrick

PORT MAP
Port B, Pin 4 -> Output -> Right Motor Enable
Port B, Pin 5 -> Output -> Right Motor Direction
Port B, Pin 7 -> Output -> Left Motor Enable
Port B, Pin 6 -> Output -> Left Motor Direction
Port D, Pin 1 -> Input -> Left Whisker
Port D, Pin 0 -> Input -> Right Whisker
*/

#define F_CPU 16000000

#include <avr/io.h>
#include <stdio.h>
#include <util/delay.h>

int main(void) {

  int hit_state = 0;

  DDRB = 0b11110000;  // set pins 4-7 as outputs (high)
  PORTB = 0b10010000; // initially disable motors

  DDRD = 0b00000000;  // set pins 1-2 as inputs (low)
  PORTD = 0b11111111; // enable pull-up resistors for input pins

  while (1) { // loop forever

    // read input whiskers (only the first 2 pins)
    int reading = PIND & 0b00000011;

    // if hit? (i.e. one of the input pins is low)
    if (reading != 0b11) {
      // back up
      PORTB = 0b00000000; // move backward
      _delay_ms(1000);

      // turn away from the hit:
      //   left hit:   0b1111_1101
      //                  __    ^^ these are the same bits inverted!
      //   turn right: 0b0100_0000
      //   right hit:  0b1111_1110
      //                  __    ^^ these are the same bits inverted!
      //   turn left:  0b0010_0000

      // if both are hit, turn left
      reading = reading ? reading : 0b10;

      // since it is the same bits just inverted,
      // do some coolguy bitmath to not need a conditional B)
      PORTB = (~reading & 0b00000011) << 5;
      _delay_ms(1000);
    }

    // continue forward
    PORTB = 0b01100000;
    _delay_ms(20);
  }
}
