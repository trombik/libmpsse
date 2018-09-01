module LibMpsse
  module I2C
    # Constant that represents ACK has been received
    ACK = 0
    # Constant that represents ACK has not been received
    NACK = 1

    # Write bytes of data to the device
    #
    # @param register [Integer] register address
    # @param value [Array<Integer>, Integer] a value, or array of values, to
    #   write to the bus
    def write(register, value)
      transaction do
        data = [address_frame(:write), register]
        if value.is_a?(Array)
          data += value
        else
          data << value
        end
        @mpsse.write(data)
      end
    end

    # Read one or more register values from I2C device. ACK from the slave is
    # always checked, thorws {LibMpsse::NoAckReceivedError} when expected ACK has
    # not been received during the transaction. Repeated start is used before
    # reading register values. if repeated start is not requested upon object
    # initialization, end the transaction and start new transaction before
    # reading values.
    #
    # @param [Integer] register address
    # @param [Integer] size in byte to read
    # @return [Array<Integer>] array of register values
    def read(register, size)
      transaction do
        data = []
        @mpsse.write([address_frame(:write), register])
        ensure_ack
        repeated_start
        @mpsse.write([address_frame(:read)])
        ensure_ack
        data = @mpsse.read(size - 1) if size > 1
        @mpsse.send_nacks
        data << @mpsse.read(1).first
      end
    end

    # Send repeated start, or start new I2C transaction if disabling repeated
    # start is requested upon object initialization.
    def repeated_start
      @mpsse.stop unless @repeated_start_required
      @mpsse.start
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

    # Ensure the device sends ACK back.
    #
    # @raise [NoAckReceivedError] when the device does not send ACK back
    def ensure_ack
      raise NoAckReceivedError if @mpsse.ack != ACK
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
    class NoAckReceivedError < Error
      def to_s
        'no ack from slave'
      end
    end
  end
end
