# Read a register value from I2C device

## Usage

```
read8.rb address register
```

| argument | description                  |
|----------|------------------------------|
| address  | I2C address of the I2C slave |
| register | register address             |

The both arguments accept HEX style (prefixed with `0x`) or integer value.
The application does the followings:

* Opens the first FTDI device found
* Reads 8 bit `register` from the device with `address`
* Displays the value

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

Example:

```
> bundle exec ruby read8.rb 0x40 0x00
```

If the device has 16 bit register, use `read16.rb` instead.
