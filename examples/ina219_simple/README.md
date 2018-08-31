# Read Vbus from INA219

## Usage

```
ina219_simple address register
```

| argument | description                  |
|----------|------------------------------|
| address  | I2C address of INA219        |

The argument accept HEX style (prefixed with `0x`) or integer value.

The application does the followings:

* `ping` the device
* reset the device
* make sure the configuration register has the default value after reset
* read Vbus and prints it

Make sure to connect Vcc from a power source to `Vin+` and connect a load,
such as LED and register, to `Vin-`.

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
> bundle exec ruby ina219_simple.rb 0x40
ping the device
the device has responded to ping
reset the device
read configuration register after reset
configuration register has default value after reset.
read bus voltage
Vbus: 4.604 V
```
