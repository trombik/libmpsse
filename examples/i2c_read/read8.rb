#!/usr/bin/env ruby
require 'libmpsse'

address  = ARGV[0] =~ /^0[xX]/ ? ARGV[0].hex : ARGV[0].to_i
register = ARGV[1] =~ /^0[xX]/ ? ARGV[1].hex : ARGV[1].to_i

device = LibMpsse::I2CDevice.new(address)
value = device.read8(register)
puts format('address: 0x%0.2x: register: 0x%0.4x: 0x%0.2x', address, register, value)
