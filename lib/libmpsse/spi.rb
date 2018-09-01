module LibMpsse
  # SPI protocol-specific methods for SPIDevice
  module SPI
    # write array of data to SPI bus
    #
    # @param data [Array<Integer>] array of data to write
    def write(data)
      @mpsse.write(data)
    end

    # read `size` byte of data from SPI bus
    #
    # @param size [Integer] bytes to read
    # @return [Array<Integer>] array of bytes
    def read(size)
      @mpsse.read(size)
    end
  end
end
