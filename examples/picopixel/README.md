# Control Attiny85 I2C slave

Control Attiny I2C slave, aka
`[picopixel](https://github.com/usedbytes/neopixel_i2c)`. The README has a
suggested circuit.

In this setup, Attiny85 (internal oscillator, at 8 MHz) is used.

Connect NeoPixels' signal line to `PB3` (physical pin number is 2).

For general hookup information about NeoPixel, follow the instructions from
Adafruit, [The Magic of NeoPixels](https://learn.adafruit.com/adafruit-neopixel-uberguide/the-magic-of-neopixels).

## Usage

```
picopixel.rb
```

The application does the followings:

* `ping` the device
* reset the device
* change the all NeoPixels connected to `picopixel` at 1 Hz in a loop

The I2C bus, both SCL and SDA, must have pullup registers. Connect the FTDI
board to the I2C bus.

| FT2232 board | I2C bus |
|--------------|---------|
| ADBUS0       | SCL     |
| ADBUS1       | SDA     |
| ADBUS2       | SDA     |

Example:

```
> bundle exec ruby ./picopixel.rb
ping the device: 0x40
reset the device
Starting loop
Press CTRL + C to stop the loop
```
