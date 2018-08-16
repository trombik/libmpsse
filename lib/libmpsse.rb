require 'ffi'
require 'libmpsse/version'

module LibMpsse
  extend FFI::Library
  ffi_lib ['libmpsse', 'libmpsse.a', 'libmpsse.so']

  LowBitsStatus = enum(
    :started,
    :stopped
  )

  require 'libmpsse/modes'
  require 'libmpsse/clock_rates'
  require 'libmpsse/context'

  MPSSE_OK = 0
  MPSSE_FAIL = -1
  MSB = 0x00
  LSB = 0x08

  attach_function :MPSSE, [Modes, :int, :int], :pointer
  attach_function :Open, [:int, :int, Modes, :int, :int, :int, :string, :string], :pointer
  attach_function :OpenIndex, [:int, :int, Modes, :int, :int, :int, :string, :string, :int], :pointer
  attach_function :Close, [:pointer], :void
  attach_function :Start, [:pointer], :int
  attach_function :Stop, [:pointer], :int
  attach_function :Tristate, [:pointer], :int

  # SPI functions

  # I2C functions
  attach_function :GetAck, [:pointer], :int
  attach_function :SetAck, [:pointer, :int], :void
  attach_function :SendAcks, [:pointer], :void
  attach_function :SendNacks, [:pointer], :void

  attach_function :ErrorString, [:pointer], :string

  attach_function :Write, [:pointer, :pointer, :int], :int
  attach_function :Read, [:pointer, :int], :pointer
  attach_function :ReadBits, [:pointer, :int], :uint8
  attach_function :Transfer, [:pointer, :string, :int], :string

  require 'libmpsse/mpsse'
  require 'libmpsse/i2c_device'
end
