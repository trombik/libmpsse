# Scan I2C bus for devices

Scan I2C bus for devices using `.ping` method with all possible I2C addresses
at different clock frequency.

## Usage

```
> i2c_scanner.rb
```

The application does the followings:

* Opens the first FTDI device found
* `.ping` all possible I2C address in a loop
* Displays address that respond to `.ping`

The I2C bus, both SCL and SDA, must have pullup registers. Connect the FTDI
board to the I2C bus.

| FT2232 board | I2C bus |
|--------------|---------|
| ADBUS0       | SCL     |
| ADBUS1       | SDA     |
| ADBUS2       | SDA     |

Also, the I2C device and the FTDI board must have common GND. The I2C device
must be powered by 5 V or less (FT2232's IO ports accept 5 V logic level). 5 V
I2C device is known to work fine.

## Example

```
> i2c_scanner.rb
I2C bus frequency: one_hundred_khz
0x00, 0x40
I2C bus frequency: four_hundred_khz
0x00, 0x40
```
