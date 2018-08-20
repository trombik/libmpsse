module LibMpsse
  class I2CDevice
    # Base error of LibMpsse::Mpsse
    class Error < RuntimeError
    end

    # When slave does not send ACK back
    class NoAckReceived < Error
      def to_s
        'no ack from slave'
      end
    end

    ACK = 0
    NACK = 1

    attr_reader :address, :mpsse

    def initialize(address)
      @address = address
      @mpsse = new_context
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
        data = []
        @mpsse.write([address_frame(false), register])
        raise NoAckReceived if @mpsse.ack != ACK
        @mpsse.start
        @mpsse.write([address_frame])
        raise NoAckReceived if @mpsse.ack != ACK
        data = @mpsse.read(size - 1) if size > 1
        @mpsse.send_nacks
        data << @mpsse.read(1).first
      end
    end

    def read8(register)
      read(1, register).first
    end

    def read16(register)
      (first, last) = read(2, register)
      ((first << 8) & 0xff00) | (last & 0xff)
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
