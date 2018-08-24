require 'ftdi'

module LibMpsse
  # libpsse context
  class Context < FFI::ManagedStruct
    layout :description,      :string,
           :ftdi_context,     Ftdi::Context,
           :mode,             Modes,
           :status,           LowBitsStatus,
           :flush_after_read, :int,
           :vid,              :int,
           :pid,              :int,
           :clock,            :int,
           :xsize,            :int,
           :open,             :int,
           :endianess,        :int,
           :tris,             :uint8,
           :pstart,           :uint8,
           :pstop,            :uint8,
           :pidle,            :uint8,
           :gpioh,            :uint8,
           :trish,            :uint8,
           :bitbang,          :uint8,
           :tx,               :uint8,
           :rx,               :uint8,
           :txrx,             :uint8,
           :tack,             :uint8,
           :rack,             :uint8
    # a method to auto-release the object when it is out-of-scope
    def self.release(context)
      LibMpsse::Close(context)
    end
  end
end
