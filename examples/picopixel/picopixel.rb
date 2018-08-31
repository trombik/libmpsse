#!/usr/bin/env ruby

# Controlling neopixel_i2c_slave, aka picopixel.
# https://github.com/usedbytes/neopixel_i2c

require 'libmpsse'

i2c_address = 0x40
reg_config_address = 0x00
reg_array_start_address = 0x04
cmd_reset = (1 << 0)
n_pixels = 12

color_red =   [0x00, 0x10, 0x00]
color_blue =  [0x00, 0x00, 0x10]
color_green = [0x10, 0x00, 0x00]

# Attiny85 as slave. Note that it cannot handle 400 Khz bus speed.
picopixel = LibMpsse::I2CDevice.new(address: i2c_address)

puts format('ping the device: 0x%0.2x', i2c_address)
raise 'no reply' unless picopixel.ping

puts 'reset the device'
picopixel.write(reg_config_address, cmd_reset)

# simply change the color (R -> B -> G) in a loop.
puts 'starting loop'
puts 'press CTRL + C to stop the loop'
loop do
  # modify me if you like something fancier
  [color_red, color_blue, color_green].each do |c|
    picopixel.write(reg_array_start_address, c * n_pixels)
    sleep 1
  end
end
