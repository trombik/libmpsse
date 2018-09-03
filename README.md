# `LibMpsse` binding for ruby

## Description

Ruby bindings for [libmpsse](https://github.com/devttys0/libmpsse).

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
