# LibMpsse

## Description

Ruby bindings for [libmpsse](https://github.com/devttys0/libmpsse).

## Prerequisites

* libmpsse, and its dependency, libftdi

Currently, patched version of `libftdi-ruby` is used, which means no gem
available. Use bundler for the moment.

## Current status

| Mode    | Status              |
|---------|---------------------|
| Bitbang | In progress         |
| I2C     | Implemented         |
| SPI     | Not yet implemented |

## Synopsis

```ruby
#!/usr/bin/env ruby
require 'libmpsse'

device = LibMpsse::I2CDevice.new(adress: address)
value = device.read8(register)
puts format('address: 0x%0.2x: register: 0x%0.4x: 0x%0.2x', address, register, value)
```

For more examples, see [examples](examples).
