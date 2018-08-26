module LibMpsse
  # Namespace for libmpsse
  class I2CDevice
    # Abstract class of I2C device. A class that represents I2C device.
    # Provides methods to talk to I2C slave device.

    # Constant that represents ACK has been received
    ACK = 0
    # Constant that represents ACK has not been received
    NACK = 1

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
    #   {LibMpsse::Mpsse#initialize}
    # @return [LibMpsse::I2CDevice] I2CDevice object
    def initialize(address:, freq: ClockRates[:one_hundred_khz], device: {})
      @address = address
      @freq = freq
      @device = device
      @mpsse = new_context
    end

    # Create {LibMpsse::Mpsse} context object
    #
    # @return [LibMpsse::Mpsse] new {LibMpsse::Mpsse} context
    def new_context
      Mpsse.new(mode: Modes[:i2c], freq: @freq, endianess: MSB, device: @device)
    end

    # Wrap I2c transaction with I2C start and stop
    def transaction
      @mpsse.start
      yield
    ensure
      @mpsse.stop
    end

    def write(register, value)
      transaction do
        @mpsse.write([address_frame(:write), register, value & 0xFF])
      end
    end

    # Read one or more register values from I2C device. ACK from the slave is
    # always checked, thorws {LibMpsse::NoAckReceived} when expected ACK has
    # not been received during the transaction. Repeated start is used before
    # reading register values.
    #
    # @param [Integer] register address
    # @param [Integer] size in byte to read
    # @return [Array<Integer>] array of register values
    def read(register, size)
      transaction do
        data = []
        @mpsse.write([address_frame(:write), register])
        raise NoAckReceived if @mpsse.ack != ACK
        @mpsse.start
        @mpsse.write([address_frame(:read)])
        raise NoAckReceived if @mpsse.ack != ACK
        data = @mpsse.read(size - 1) if size > 1
        @mpsse.send_nacks
        data << @mpsse.read(1).first
      end
    end

    # Read a byte from a 8 bit register
    #
    # @param [Integer] register address
    # @return [Integer] register value
    def read8(register)
      read(register, 1).first
    end

    # Read bits from a 8 bit register.
    #
    # @param [Integer] register address
    # @param [Integer] mask bit mask to read. must not be zero
    # @return [Integer] masked register value. the value is right-shifted so
    #   that it represents the value of masked bits.
    # @raise [ArgumentError] when mask is zero
    def read8_bits(register, mask)
      raise ArgumentError, 'mask must not be zero' if mask.zero?
      value = read8(register) & mask
      right_shift_lsb(value, mask)
    end

    # Read two bytes from a 16 bit register
    #
    # @param [Integer] register address
    # @return [Integer] register value
    def read16(register)
      (first, last) = read(register, 2)
      ((first << 8) & 0xff00) | (last & 0xff)
    end

    # Read bits from a 16 bit register.
    #
    # @param [Integer] register address
    # @param [Integer] mask bit mask to read. must not be zero
    # @return [Integer] masked register value. the value is right-shifted so
    #   that it represents the value of masked bits.
    # @raise [ArgumentError] when mask is zero
    def read16_bits(register, mask)
      raise ArgumentError, 'mask must not be zero' if mask.zero?
      value = read16(register) & mask
      right_shift_lsb(value, mask)
    end

    # Get an ACK from the slave. Return value is either
    # {LibMpsse::I2CDevice::ACK}, or 0, when ack has been received,
    # {LibMpsse::I2CDevice::NACK}, or 1, when not.
    #
    # @return [Integer]
    def ack
      @mpsse.ack
    end

    # Ping the I2C slave by writing address of the slave, and confirming the
    # slave returns ACK back.  Does not raise when ACK is not received.
    #
    # @return [Boolean] `true` if the device has responded, `false` on
    # failure.
    def ping
      transaction do
        @mpsse.write([address_frame(:write)])
        ack == ACK
      end
    end

    private

    def address_frame(operation)
      unless %i[read write].include? operation
        raise ArgumentError, format(
          'Unknown operation, must be :read or :write `%<operation>s`',
          operation: operation
        )
      end
      frame = address << 1
      operation == :read ? frame | 0x01 : frame
    end

    def right_shift_lsb(value, mask)
      raise ArgumentError, 'mask must not be zero' if mask.zero?
      return 0 if value.zero?
      while (mask & 1).zero?
        value = value >> 1
        mask = mask >> 1
      end
      value
    end

    # Base class for all error class for {LibMpsse::I2CDevice}
    #
    class Error < RuntimeError
    end

    # Error class when slave does not send ACK back. Indicates the slave I2C
    # device did not send ACK back to master during I2C transaction.
    class NoAckReceived < Error
      def to_s
        'no ack from slave'
      end
    end
  end
end
