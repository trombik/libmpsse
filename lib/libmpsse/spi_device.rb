module LibMpsse
  class SPIDevice
    include LibMpsse::SerialProtocol
    include LibMpsse::SPI
    # Abstract class of SPI device. A class that represents SPI device.
    # Provides methods to talk to I2C slave device.

    # @return [LibMpsse::Mpsse] MPSSE context
    attr_reader :mpsse

    # Initialize {LibMpsse::SPIDevice}.
    # @param mode [LibMpsse::Modes] SPI mode to use
    # @param freq [LibMpsse::ClockRates] the clock rate of SPI bus in Hz
    # @param endianess [LibMpsse::LSB, LibMpsse::MSB] endianess
    # @param device [Hash] choose device with specific attributes. see device
    #   parameter of {LibMpsse::Mpsse#initialize}.
    def initialize(mode:, freq:, endianess:, device: {})
      @mode = mode
      @freq = freq
      @endianess = endianess
      @device = device
      @mpsse = new_context
    end

    # Create new Mpsse context
    # @return [LibMpsse::Mpsse]
    def new_context
      Mpsse.new(mode: @mode, freq: @freq, endianess: @endianess, device: @device)
    end
  end
end
