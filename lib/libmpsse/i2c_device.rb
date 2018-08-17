module LibMpsse
  class I2CDevice
    ACK = 0
    NACK = 1

    attr_reader :address, :mpsse

    def initialize(address)
      @address = address
      @mpsse = new_context

      # Perform a software reset
      transaction do
        @mpsse.write([0x00, 0x06])
      end
    end

    def new_context
      Mpsse.new(mode: Modes[:i2c])
    end

    def transaction
      @mpsse.start
      yield
    ensure
      @mpsse.stop
    end

    def write(register, value)
      transaction do
        @mpsse.write([address_frame(false), register, value & 0xFF])
      end
    end

    def read(size, register)
      transaction do
        @mpsse.write([address_frame(false), register])
        @mpsse.start
        @mpsse.write([address_frame])
        data = @mpsse.read(size)
        @mpsse.send_nacks
        @mpsse.read(1)
        @mpsse.send_acks
        data
      end
    end

    def read8(register)
      transaction do
        @mpsse.write([address_frame, register])
        @mpsse.start
        @mpsse.read_bits
      end
    end

    def ack
      @mpsse.ack
    end

    def ping
      transaction do
        @mpsse.write([address_frame(false)])
        ack == ACK
      end
    end

    private

    def address_frame(read = true)
      frame = address << 1
      read ? frame | 0x01 : frame
    end
  end
end
