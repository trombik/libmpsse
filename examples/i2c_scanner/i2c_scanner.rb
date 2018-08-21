#!/usr/bin/env ruby

require 'libmpsse'

def scan(freq)
  found = []
  0.upto(127).each do |addr|
    device = LibMpsse::I2CDevice.new(address: addr, freq: freq)
    found << addr if device.ping
  end
  found
end

%i[one_hundred_khz four_hundred_khz].each do |freq|
  puts format('I2C bus frequency: %<freq>s', freq: freq)
  found_devices = scan(LibMpsse::ClockRates[freq])
  if found_devices.empty?
    puts 'None found'
  else
    puts found_devices.map { |i| format('0x%0.2x', i) }.join(', ')
  end
end
