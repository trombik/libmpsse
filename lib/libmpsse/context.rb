require 'ftdi'

module Ftdi
  # overide Ftdi::Context
  #
  # as LibMpsse::Context includes Ftdi::Context, when the context object is
  # outof scope, Ftdi::Context gets free()ed, which is not desired because
  # libmpsse manages the Ftdi::Context. libftdi-ruby should call Ftdi.free()
  # when and only when it allocates Ftdi::Context. the patched version does not
  # free() Ftdi::Context if the object is created by others. without the patch,
  # applications crush.
  class Context
    def initialize(ptr = nil)
      if ptr.nil?
        ptr = Ftdi.ftdi_new
        @release_me = true
      else
        @release_me = false
      end
      super(ptr)
    end

    # free the pointer when and only when memory pointer is allocated by the
    # class itself
    def self.release(ptr)
      super(ptr) if @release_me
    end
  end
end

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
