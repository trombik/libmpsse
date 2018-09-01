module LibMpsse
  # Common methods for serial protocol
  module SerialProtocol
    # Wrap transaction with `start` and `stop`
    def transaction
      @mpsse.start
      yield
    ensure
      @mpsse.stop
    end

    # Start a transaction
    def start
      @mpsse.start
    end

    # Stop a transaction
    def stop
      @mpsse.stop
    end
  end
end
