require 'ffi'
require 'libmpsse/version'

module LibMpsse
  # Name space for LibMpsse
  extend FFI::Library
  ffi_lib ['libmpsse', 'libmpsse.a', 'libmpsse.so']

  LowBitsStatus = enum(
    :started,
    :stopped
  )

  require 'libmpsse/modes'
  require 'libmpsse/clock_rates'
  require 'libmpsse/context'
  require 'libmpsse/interface'

  # libmpsse return value on success
  MPSSE_OK = 0
  # libmpsse return value on failure
  MPSSE_FAIL = -1

  # MSB first
  MSB = 0x00
  # LSB first
  LSB = 0x08

  attach_function :MPSSE, [Modes, :int, :int], :pointer
  attach_function :Open, [:int, :int, Modes, :int, :int, :int, :string, :string], :pointer
  attach_function :OpenIndex, [:int, :int, Modes, :int, :int, :int, :string, :string, :int], :pointer
  attach_function :Close, [Context.by_ref], :void
  attach_function :Start, [Context.by_ref], :int
  attach_function :Stop, [Context.by_ref], :int
  attach_function :Tristate, [Context.by_ref], :int
  attach_function :GetDescription, [Context.by_ref], :pointer
  attach_function :Version, [:void], :pointer
  attach_function :SetDirection, [Context.by_ref, :int], :int
  attach_function :PinHigh, [Context.by_ref, :int], :int
  attach_function :PinLow, [Context.by_ref, :int], :int
  attach_function :WritePins, [Context.by_ref, :int], :int
  attach_function :ReadPins, [Context.by_ref], :int

  # SPI functions

  # I2C functions
  attach_function :GetAck, [Context.by_ref], :int
  attach_function :SetAck, [Context.by_ref, :int], :void
  attach_function :SendAcks, [Context.by_ref], :void
  attach_function :SendNacks, [Context.by_ref], :void

  attach_function :ErrorString, [Context.by_ref], :pointer

  attach_function :Write, [Context.by_ref, :pointer, :int], :int
  attach_function :Read, [Context.by_ref, :int], :pointer
  attach_function :ReadBits, [Context.by_ref, :int], :uint8
  attach_function :Transfer, [Context.by_ref, :string, :int], :string

  require 'libmpsse/mpsse'
  require 'libmpsse/i2c_device'
end
