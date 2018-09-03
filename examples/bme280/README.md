# Read values from BME280 via SPI

There are several `BME280` breakout boards available. Some support both SPI
and I2C, others support I2C only. Make sure that your board is SPI-capable.

## `bme280.rb`

This example reads temperature, humidity, and pressure from popular BME280
censor via SPI.

The code is a modified version of
[lukasjapan/i2c-bme280](https://github.com/lukasjapan/i2c-bme280).

The [diff](bme280.diff.txt).

Do not expect accurate readings from this example. It is made available just
for demonstration purpose. It assumes data is always available. The original
code is not efficient in that, some operations are performed in multiple
transactions, however, the modified one uses the original as-is.

### Usage

```
bundle exec ruby bme280.rb
```

The application does the followings:

* reset the device
* read censor values 10 times in a loop

Connect the FTDI board to the censor device. This example uses four-wire SPI.

Unfortunately, SPI bus lines have several aliases.  Hope your board has sane
silkscreen.

| FT2232 board | BME280       |
|--------------|--------------|
| ADBUS0       | SCLK/SCL     |
| ADBUS1       | MOSI/SDA/SDI |
| ADBUS2       | MISO/SDO     |
| ADBUS3       | CS/CSB       |

### Example

```
> bundle exec ruby bme280.rb
T: 32.849 H: 80.027, P: 1008.13
T: 32.849 H: 57.623, P: 1008.19
T: 32.880 H: 57.500, P: 1008.16
T: 32.860 H: 57.547, P: 1008.10
T: 32.865 H: 57.629, P: 1008.16
T: 32.890 H: 57.695, P: 1008.12
T: 32.880 H: 57.559, P: 1008.13
T: 32.900 H: 57.660, P: 1008.11
T: 32.895 H: 57.701, P: 1008.10
T: 32.910 H: 57.755, P: 1008.13
```

## `bme280_simple.rb`

This is an example to test the driver.

### Usage

```
bundle exec ruby bme280.rb
```

Connect the FTDI board to the censor device just like the above example.

### Example

```
> bundle exec ruby bme280_simple.rb
identify chip id
reset the device
read ctrl_meas after reset
setting ctrl_meas to 0b00100101
read ctrl_meas
test successfully finished
```
