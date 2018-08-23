module LibMpsse
  class Mpsse
    attr_reader :context

    def initialize(mode:, freq: ClockRates[:four_hundred_khz], endianess: MSB)
      @context = new_context(mode, freq, endianess)
      raise CannotOpenError if (@context[:open]).zero?
    end

    def new_context(mode, freq, endianess)
      @context = Context.new(LibMpsse::MPSSE(mode, freq, endianess))
    end

    def start
      LibMpsse::Start(context)
    end

    def stop
      LibMpsse::Stop(context)
    end

    def close
      LibMpsse::Close(context)
    end

    def read(size)
      data_ptr = LibMpsse::Read(context, size)
      data_ptr.read_array_of_type(FFI::TYPE_UINT8, :read_uint8, size)
    end

    def read_bits(size = 8)
      LibMpsse::ReadBits(context, size)
    end

    def write(data)
      data = data.pack('C*')
      data_ptr = FFI::MemoryPointer.new(:uint8, data.bytesize)
      data_ptr.put_bytes(0, data)
      LibMpsse::Write(context, data_ptr, data.bytesize)
    end

    def ack
      LibMpsse::GetAck(context)
    end

    def ack=(ack_type)
      LibMpsse::SetAck(context, ack_type)
    end

    def send_nacks
      LibMpsse::SendNacks(context)
    end

    def send_acks
      LibMpsse::SendAcks(context)
    end

    def error_string
      LibMpsse::ErrorString(context)
    end

    def description
      str_p = LibMpsse::GetDescription(context)
      str_p.read_string
    end

    # Sets the input/output direction of all pins. For use in BITBANG mode
    # only.
    #
    # @param direction [Integer] Byte indicating input/output direction of
    #   each bit. 0 is input, and 1 is output.
    #
    # @raise [StatusCodeError] if SetDirection does not return
    #   {LibMpsse::MPSSE_OK}
    # @raise [InvalidMode] When mode is not :bitbang
    def direction(direction)
      raise InvalidMode.new(context[:mode], 'bitbang') unless context[:mode] == :bitbang
      err = LibMpsse::SetDirection(context, direction)
      check_libmpsse_error(err)
    end

    # Set a pin to specified state, either high or low.
    #
    # @param pin [Integer] Pin number
    # @param mode [Symbol] `:high` or `:low`
    # @raise [ArgumentError] if mode is invalid
    # @raise [StatusCodeError] if libmpsse does not return {LibMpsse::MPSSE_OK}
    def pin_mode(pin, mode)
      case mode
      when :high
        check_libmpsse_error(LibMpsse::PinHigh(pin))
      when :low
        check_libmpsse_error(LibMpsse::PinLow(pin))
      else
        raise ArgumentError, format('invalid mode `%<mode>s`: mode must be either :high or :low', mode: mode)
      end
    end

    # Sets the input/output value of all pins. For use in BITBANG mode only.
    #
    # @param bits [Integer] Byte indicating bit hi/low value of each bit.
    # @raise [InvalidMode] When mode is not :bitbang
    def write_pins(bits)
      raise InvalidMode.new(context[:mode], 'bitbang') unless context[:mode] == :bitbang
      check_libmpsse_error(LibMpsse::WritePins(context, bits))
    end

    # Reads the state of the chip's pins. For use in BITBANG mode only.
    #
    # @raise [InvalidMode] When mode is not :bitbang
    # @return [Integer] a byte with the corresponding pin's bits set to 1 or 0.
    def read_pins
      raise InvalidMode.new(context[:mode], 'bitbang') unless context[:mode] == :bitbang
      LibMpsse::ReadPins(context)
    end

    private

    def check_libmpsse_error(err)
      raise StatusCodeError.new(err, error_string) if err != LibMpsse::MPSSE_OK
    end

    # Base error of LibMpsse::Mpsse
    class Error < RuntimeError
    end

    # When device cannot be opened
    class CannotOpenError < Error
    end

    # Error with status code and strings from libmpsse
    #
    class StatusCodeError < Error
      attr_reader :status_code

      # Creates StatusCodeError.
      #
      # @param status_code [Integer] status code returned by libmpsse
      # @param message [String] error message
      def initialize(status_code, message)
        super(message)
        @status_code = status_code
      end

      def to_s
        "#{status_code}: #{super}"
      end
    end

    # When a method not designed for the current mode is called
    class InvalidMode < Error
      def initialize(mode, valid_mode)
        message = format(
          'this method is for %<valid_mode>s only. current mode is %<mode>s',
          valid_mode: valid_mode, mode: mode
        )
        super(message)
      end
    end
  end
end
