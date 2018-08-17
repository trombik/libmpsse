require "spec_helper"

describe LibMpsse::Mpsse do
  describe "#initialize" do
    context "when mode is i2c" do
      let(:mpsse) { described_class.new(:mode => :i2c) }

      context "when device is successfully opened" do
        let(:context) do
          { open: 1 }
        end

        it "does not raise" do
          allow_any_instance_of(LibMpsse::Mpsse).to receive(:get_new_context).and_return(context)
          expect { mpsse }.not_to raise_error
        end
      end

      context "when device cannot be opened" do
        let(:context) do
          { open: 0 }
        end

        it "raises LibMpsse::Mpsse::CannotOpenError" do
          allow_any_instance_of(LibMpsse::Mpsse).to receive(:get_new_context).and_return(context)
          expect { mpsse }.to raise_error(LibMpsse::Mpsse::CannotOpenError)
        end
      end
    end
  end
end
