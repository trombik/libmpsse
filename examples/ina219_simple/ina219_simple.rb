#!/usr/bin/env ruby

require 'libmpsse'

i2c_address = ARGV[0] =~ /^0[xX]/ ? ARGV[0].hex : ARGV[0].to_i

config_reg_address = 0x00
config_reg_value_default = 0x399f
bus_voltage_reg_address = 0x02

ina219 = LibMpsse::I2CDevice.new(address: i2c_address)

puts 'ping the device'
raise format('address 0x%<address>0.2X does not respond to ping', address: i2c_address) unless ina219.ping
puts 'the device has responded to ping'

puts 'reset the device'
ina219.write(config_reg_address, config_reg_value_default | (1 << 15))

puts 'read configuration register after reset'
reg_value = ina219.read16(config_reg_address)

if reg_value != config_reg_value_default
  raise format('expected default value: 0x%<value>0.4X, but found: 0x%<actual>0.4X',
               value: config_reg_value_default, actual: reg_value)
end
puts 'configuration register has default value after reset.'

puts 'read bus voltage'
reg_value = ina219.read16(bus_voltage_reg_address)

# default: 32 V, LSB = 4 mV
# bit[0-2] are flags, discard them.
v_bus = (reg_value >> 3) * (4.0 / 1000)
puts format('Vbus: %<v_bus>0.3f V', v_bus: v_bus)
