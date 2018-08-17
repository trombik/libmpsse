require "spec_helper"

describe LibMpsse::I2CDevice do
  describe "#initialize" do
    let(:address) { 0x20 }
    let(:i2c) { described_class.new(address) }
    let(:mpsse) { instance_double("mpsse") }

    before(:each) do
      allow(mpsse).to receive(:stop)
      allow(mpsse).to receive(:start)
    end

    it "resets the device" do
      allow_any_instance_of(LibMpsse::I2CDevice).to receive(:get_new_context).and_return(mpsse)
      allow(mpsse).to receive(:write).with([0x00, 0x06])
      expect { i2c }.not_to raise_error
    end
  end
end

