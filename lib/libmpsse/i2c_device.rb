module LibMpsse
  # Namespace for libmpsse
  class I2CDevice
    # Abstract class of I2C device. A class that represents I2C device.
    # Provides methods to talk to I2C slave device.

    include LibMpsse::SerialProtocol
    include LibMpsse::I2C

    # @return [Integer] I2C address of the slave
    attr_reader :address
    # @return [LibMpsse::ClockRates] I2C clock frequency
    attr_reader :freq
    # @return [LibMpsse::Mpsse] MPSSE context
    attr_reader :mpsse

    # Create a {LibMpsse::I2CDevice}.
    #
    # @param address [Integer] I2C slave address
    # @param freq [LibMpsse::ClockRates] I2C clock frequency
    # @param device [Hash] choose device with specific attributes. see
    #   device parameter of {LibMpsse::Mpsse#initialize}. Additionally, the
    #   following attributes are supported:
    #   * :with_repeated_start (Bool) if true, use repeated start condition
    #     during I2C read transaction. if false read operation will be performed
    #     in two I2C transaction. set this to false if the device does not
    #     support repeated start. default is true.
    # @return [LibMpsse::I2CDevice] I2CDevice object
    def initialize(address:, freq: ClockRates[:one_hundred_khz], device: {})
      @address = address
      @freq = freq
      @device = device
      @repeated_start_required = device.key?(:with_repeated_start) ? device[:with_repeated_start] : true
      @mpsse = new_context
    end

    # Create {LibMpsse::Mpsse} context object
    #
    # @return [LibMpsse::Mpsse] new {LibMpsse::Mpsse} context
    def new_context
      Mpsse.new(mode: Modes[:i2c], freq: @freq, endianess: MSB, device: @device)
    end
  end
end
