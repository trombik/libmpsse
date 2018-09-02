require 'spec_helper'

describe LibMpsse::SPIDevice do
  let(:mode) { LibMpsse::Modes[:spi0] }
  let(:freq) { LibMpsse::ClockRates[:one_hundred_khz] }
  let(:endianess) { LibMpsse::LSB }
  let(:libmpsse) { class_spy(LibMpsse) }
  let(:spi) { described_class.new(mode: mode, freq: freq, endianess: endianess) }
  let(:context) do
    ptr = FFI::MemoryPointer.new(LibMpsse::Context.size)
    struct = LibMpsse::Context.new FFI::Pointer.new(ptr)
    struct[:open] = 1
    struct
  end
  let(:err_string_ptr) { FFI::MemoryPointer.from_string('some string') }

  before(:each) do
    allow_any_instance_of(LibMpsse::Mpsse).to receive(:new_context).and_return(context)
    allow(libmpsse).to receive(:MPSSE).and_return(context)
    allow(libmpsse).to receive(:Stop).and_return(0)
    allow(libmpsse).to receive(:Start).and_return(0)
    allow(libmpsse).to receive(:ErrorString).and_return(err_string_ptr)
    stub_const('LibMpsse', libmpsse, transfer_nested_constants: true)
  end

  describe '#initialize' do
    it 'does not raise' do
      expect { spi }.not_to raise_error
    end
  end

  describe '.transaction' do
    context 'with empty block' do
      it 'calls :Start and :Stop' do
        spi.transaction do
          # noop
        end
        expect(libmpsse).to have_received(:Start).once
        expect(libmpsse).to have_received(:Stop).once
      end
    end

    context 'with start and stop in a block' do
      it 'calls :Start and :Stop twice' do
        spi.transaction do
          spi.stop
          spi.start
        end
        expect(libmpsse).to have_received(:Start).twice
        expect(libmpsse).to have_received(:Stop).twice
      end
    end
  end

  describe '.read' do
    it 'reads bytes and return an array of the bytes' do
      bytes = [0xdead, 0xbeef]
      buffer = LibC.malloc(bytes.first.size * bytes.size)
      allow(libmpsse).to receive(:Read).and_return(buffer)
      bytes = []

      spi.transaction do
        bytes = spi.read(2)
      end

      expect(libmpsse).to have_received(:Read).with(instance_of(LibMpsse::Context), 2)
      expect(bytes).to eq bytes
      LibC.free(buffer)
    end
  end

  describe '.write' do
    context 'when given an array' do
      it 'writes butes to SPI bus' do
        bytes = [0xdead, 0xbeef]
        allow(libmpsse).to receive(:Write).and_return(0)
        status = 1

        expect do
          spi.transaction do
            status = spi.write(bytes)
          end
        end.not_to raise_error
        expect(libmpsse).to have_received(:Write).with(
          instance_of(LibMpsse::Context), instance_of(FFI::MemoryPointer), bytes.length
        )
      end
    end

    context 'when given a single param' do
      it 'writes a byte to SPI bus' do
        byte = 0xdead
        allow(libmpsse).to receive(:Write).and_return(0)
        status = 1

        expect do
          spi.transaction do
            status = spi.write(byte)
          end
        end.not_to raise_error
        expect(libmpsse).to have_received(:Write).with(
          instance_of(LibMpsse::Context), instance_of(FFI::MemoryPointer), 1
        )
      end
    end
  end

  describe '.cs_idle' do
    context 'when given :high' do
      it 'calles SetCSIdle with 1' do
        allow(libmpsse).to receive(:SetCSIdle)

        spi.cs_idle(:high)

        expect(libmpsse).to have_received(:SetCSIdle).with(
          instance_of(LibMpsse::Context), 1
        )
      end
    end

    context 'when give :low' do
      it 'calles SetCSIdle with 0' do
        allow(libmpsse).to receive(:SetCSIdle)

        spi.cs_idle(:low)

        expect(libmpsse).to have_received(:SetCSIdle).with(
          instance_of(LibMpsse::Context), 0
        )
      end
    end
  end
end
