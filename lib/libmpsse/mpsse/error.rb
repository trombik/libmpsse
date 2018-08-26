module LibMpsse
  class Mpsse
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
