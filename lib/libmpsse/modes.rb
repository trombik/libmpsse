module LibMpsse
  # Supported MPSSE modes
  Modes = enum(
    :spi0, 1,
    :spi1,
    :spi2,
    :spi3,
    :i2c,
    :gpio,
    :bitbang
  )
end
