# `LibMpsse` binding for ruby

## Description

Ruby bindings for [libmpsse](https://github.com/devttys0/libmpsse).

With `ruby` and [FT2232](http://www.ftdichip.com/Products/ICs/FT2232H.htm) (or
any other variants like
[FT232H](http://www.ftdichip.com/Products/ICs/FT232H.htm)), your code can
speak I2C and SPI, or bitbang, over USB. Breakout boards are available at
[digikey](https://www.digikey.com/catalog/en/partgroup/ft2232h-evaluation-board-ft2232h-mini-module/15377) (27 USD),
[aliexpress](https://www.aliexpress.com/wholesale?SearchText=FT2232HL+development+board)
(13 USD), and many others. The chip supports 3.3 V and 5 V devices. Now you
can [read values from BME280](examples/bme280).

## Prerequisites

* [libmpsse](https://github.com/devttys0/libmpsse), and its dependency,
  [libftdi](https://www.intra2net.com/en/developer/libftdi/)

## Current status

| Mode    | Status              |
|---------|---------------------|
| Bitbang | In progress         |
| I2C     | Implemented         |
| SPI     | Implemented         |

## Synopsis

```ruby
#!/usr/bin/env ruby
require 'libmpsse'

# read a value from 8 bit register

register = 0x01
device = LibMpsse::I2CDevice.new(adress: address)
value = device.read8(register)
puts format('address: 0x%0.2x: register: 0x%0.4x: 0x%0.2x', address, register, value)
```

For more examples, see [examples](examples).
