require 'spec_helper'

describe LibMpsse::I2CDevice do
  let(:address) { 0x20 }
  let(:address_read) { (address << 1 | 1) }
  let(:address_write) { address << 1 }
  let(:i2c) { described_class.new(address: address) }
  let(:mpsse) { spy('mpsse') }
  let(:register_address) { 0x01 }
  let(:register_value_first) { 0xbe }
  let(:register_value_last) { 0xfe }
  let(:register_value) { (register_value_first << 8) | register_value_last }

  before(:each) do
    allow_any_instance_of(LibMpsse::I2CDevice).to receive(:new_context).and_return(mpsse)
    allow(mpsse).to receive(:start)
    allow(mpsse).to receive(:stop)
  end

  describe '#initialize' do
    it 'does not raise' do
      expect { i2c }.not_to raise_error
    end

    context 'when freq is ommited' do
      it 'defaults to one_hundred_khz' do
        expect(i2c.freq).to eq LibMpsse::ClockRates[:one_hundred_khz]
      end
    end

    context 'when LibMpsse::ClockRates[:four_hundred_khz] is given' do
      let(:i2c) do
        described_class.new(
          address: address,
          freq: LibMpsse::ClockRates[:four_hundred_khz]
        )
      end

      it 'sets freq to four_hundred_khz' do
        expect(i2c.freq).to eq LibMpsse::ClockRates[:four_hundred_khz]
      end
    end
  end

  describe '.ping' do
    context 'when no ack from i2c device' do
      it 'returns false' do
        allow(mpsse).to receive(:write)
        allow(mpsse).to receive(:ack).and_return(1)

        expect(i2c.ping).to eq false
        expect(mpsse).to have_received(:write).with([address_write]).once
      end
    end

    context 'when ack from i2c device' do
      it 'returns true' do
        allow(mpsse).to receive(:write)
        allow(mpsse).to receive(:ack).and_return(0)

        expect(i2c.ping).to eq true
        expect(mpsse).to have_received(:write).with([address_write]).once
      end
    end
  end

  describe '.read' do
    context 'when slave responds to read request to a 16 bit register without error' do
      it 'returns register value as an array' do
        allow(mpsse).to receive(:write)
        allow(mpsse).to receive(:ack).and_return(LibMpsse::I2CDevice::ACK)
        allow(mpsse).to receive(:read).and_return(
          [register_value_first],
          [register_value_last]
        )
        allow(mpsse).to receive(:send_nacks)

        expect(i2c.read(register_address, 2)).to eq [register_value_first, register_value_last]
        expect(mpsse).to have_received(:write).with([address_write, register_address]).once.ordered
        expect(mpsse).to have_received(:write).with([address_read]).once.ordered
        expect(mpsse).to have_received(:send_nacks).once.ordered
        expect(mpsse).to have_received(:stop).ordered
        expect(mpsse).to have_received(:start).twice
        expect(mpsse).to have_received(:ack).twice
      end
    end
    context 'when with_repeated_start is false' do
      let(:i2c) { described_class.new(address: address, device: { with_repeated_start: false }) }

      it 'sends stop twice' do
        allow(mpsse).to receive(:write)
        allow(mpsse).to receive(:ack).and_return(LibMpsse::I2CDevice::ACK)
        allow(mpsse).to receive(:read).and_return(
          [register_value_first],
          [register_value_last]
        )
        allow(mpsse).to receive(:send_nacks)

        expect(i2c.read(register_address, 2)).to eq [register_value_first, register_value_last]
        expect(mpsse).to have_received(:stop).twice
      end
    end

    context 'when slave does not send ACK back' do
      it 'raises LibMpsse::I2C::NoAckReceivedError' do
        allow(mpsse).to receive(:write)
        allow(mpsse).to receive(:ack).and_return(LibMpsse::I2C::NACK)

        expect { i2c.read(register_address, 2) }.to raise_error LibMpsse::I2C::NoAckReceivedError
      end
    end
  end

  describe '.read8' do
    context 'when slave responds to read request to a 8 bit register without error' do
      it 'returns a byte of the register value' do
        allow(mpsse).to receive(:write)
        allow(mpsse).to receive(:ack).and_return(LibMpsse::I2C::ACK)
        allow(mpsse).to receive(:read).and_return([register_value_first])
        allow(mpsse).to receive(:send_nacks)

        expect(i2c.read8(register_address)).to eq register_value_first
      end
    end
  end

  describe '.read16' do
    context 'when slave responds to read request to a 16 bit register without error' do
      it 'returns 16 bit value of the register value' do
        allow(mpsse).to receive(:write)
        allow(mpsse).to receive(:ack).and_return(LibMpsse::I2C::ACK)
        allow(mpsse).to receive(:read).and_return(
          [register_value_first],
          [register_value_last]
        )
        allow(mpsse).to receive(:send_nacks)

        expect(i2c.read16(register_address)).to eq register_value
      end
    end
  end

  describe '.read8_bits' do
    context 'when register value is 0b11111111 and mask is 0b11110000' do
      it 'returns 0b1111' do
        allow(i2c).to receive(:read8).and_return(0xff)

        expect(i2c.read8_bits(register_address, 0b11110000)).to eq 0b1111
      end
    end

    context 'when register value is 0b00101111 and mask is 0b11110000' do
      it 'returns 0b0010' do
        allow(i2c).to receive(:read8).and_return(0b00101111)

        expect(i2c.read8_bits(register_address, 0b11110000)).to eq 0b0010
      end
    end

    context 'when register value is 0b00001111 and mask is 0b11110000' do
      it 'returns 0' do
        allow(i2c).to receive(:read8).and_return(0b00001111)

        expect(i2c.read8_bits(register_address, 0b11110000)).to eq 0
      end
    end

    context 'when register value is 0 and mask is 0b11110000' do
      it 'returns 0' do
        allow(i2c).to receive(:read8).and_return(0)

        expect(i2c.read8_bits(register_address, 0b11110000)).to eq 0
      end
    end

    context 'when mask is zero' do
      it 'raises ArgumentError' do
        expect { i2c.read8_bits(register_address, 0) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.read16_bits' do
    context 'when mask is zero' do
      it 'raises ArgumentError' do
        expect { i2c.read16_bits(register_address, 0) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.write' do
    context 'when writing a value' do
      it 'does not raise' do
        allow(mpsse).to receive(:write)
        expect { i2c.write(0x01, 'foobar') }.not_to raise_error
      end
    end

    context 'when mpsse raises' do
      it 'raises StatusCodeError' do
        allow(mpsse).to receive(:write).and_raise(LibMpsse::Mpsse::StatusCodeError.new(-1, 'failed'))

        expect { i2c.write(0x01, 'foobar') }.to raise_error(LibMpsse::Mpsse::StatusCodeError)
      end
    end

    context 'when given a single value' do
      it 'appends the value to data frame' do
        i2c.write(register_address, 0xdeadbeef)
        expect(mpsse).to have_received(:write).with([address_write, register_address, 0xdeadbeef])
      end
    end

    context 'when given an array' do
      it 'cancates the array to data frame' do
        i2c.write(register_address, [0xdead, 0xbeef])
        expect(mpsse).to have_received(:write).with([address_write, register_address, 0xdead, 0xbeef])
      end
    end
  end
end
