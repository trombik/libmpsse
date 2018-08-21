require 'spec_helper'

describe LibMpsse::Mpsse do
  let(:libmpsse) { class_double('LibMpsse').as_stubbed_const(transfer_nested_constants: true) }
  let(:mpsse) { described_class.new(mode: :i2c) }
  let(:context) do
    { open: 1 }
  end

  describe '#initialize' do
    context 'when mode is i2c' do
      context 'when device is successfully opened' do
        let(:context) do
          { open: 1 }
        end

        it 'does not raise' do
          allow_any_instance_of(LibMpsse::Mpsse).to receive(:new_context).and_return(context)
          expect { mpsse }.not_to raise_error
        end
      end

      context 'when device cannot be opened' do
        let(:context) do
          { open: 0 }
        end

        it 'raises LibMpsse::Mpsse::CannotOpenError' do
          allow_any_instance_of(LibMpsse::Mpsse).to receive(:new_context).and_return(context)
          expect { mpsse }.to raise_error(LibMpsse::Mpsse::CannotOpenError)
        end
      end
    end
  end

  describe '.description' do
    it 'returns description' do
      allow_any_instance_of(LibMpsse::Mpsse).to receive(:new_context).and_return(context)

      expect(libmpsse).to receive(:GetDescription).and_return(FFI::MemoryPointer.from_string('My device'))
      expect(mpsse.description).to eq 'My device'
    end
  end
end
