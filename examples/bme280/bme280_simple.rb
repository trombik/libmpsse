#!/usr/bin/env ruby
require 'libmpsse'

# BME280 driver class
class BME280 < LibMpsse::SPIDevice
  # read bytes from a register
  def read_register(addr, size = 1)
    transaction do
      write(addr)
      read(size)
    end
  end

  # write data to a register
  def write_register(addr, data)
    transaction do
      # when writing to a register, bit 7 of the address is cleared
      write_address = addr & 0b01111111
      if data.is_a?(Array)
        write([write_address] + data)
      else
        write([write_address, data])
      end
    end
  end
end

CHIP_ID = 0x60
ADDRESS = {
  chip_id: 0xD0,
  reset: 0xE0,
  ctrl_meas: 0xF4
}.freeze
RESET_COMMAND = 0xB6

bme280 = BME280.new(
  mode: LibMpsse::Modes[:spi0],
  endianess: LibMpsse::MSB,
  freq: LibMpsse::ClockRates[:one_hundred_khz]
)

puts 'identify chip id'
reg_value = bme280.read_register(ADDRESS[:chip_id]).first
raise format('unexpected chip ID detected: expected: 0x%0.2x', CHIP_ID) unless CHIP_ID == reg_value

puts 'reset the device'
bme280.write_register(ADDRESS[:reset], RESET_COMMAND)

puts 'read ctrl_meas after reset'
reg_value = bme280.read_register(ADDRESS[:ctrl_meas]).first
raise format('expected value: 0x00, but returned value: %0.8b', reg_value) unless reg_value.zero?

value = 0b001 << 5 | 0b001 << 2 | 0b01
puts format('setting ctrl_meas to 0b%0.8b', value)
bme280.write_register(ADDRESS[:ctrl_meas], value)

puts 'read ctrl_meas'
returned_value = bme280.read_register(ADDRESS[:ctrl_meas]).first
raise format('expected value: %0.8b, returned value: %0.8b', value, returned_value) unless value == returned_value

puts 'test successfully finished'
