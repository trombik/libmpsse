module LibMpsse
  # Supported MPSSE modes
  Modes = enum(
    :spi0, 1, # SPI MODE0 - data are captured on rising edge and propagated on falling edge
    :spi1,    # SPI MODE1 - data are captured on falling edge and propagated on rising edge
    :spi2,    # SPI MODE2 - data are captured on falling edge and propagated on rising edge
    :spi3,    # SPI MODE3 - data are captured on rising edge and propagated on falling edge
    :i2c,
    :gpio,
    :bitbang
  )
end
