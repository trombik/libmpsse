require "spec_helper"

describe LibMpsse::I2CDevice do
  let(:address) { 0x20 }
  let(:address_read) { (address << 1 | 1) }
  let(:address_write) { address << 1 }
  let(:i2c) { described_class.new(address) }
  let(:mpsse) { instance_double("mpsse") }

  before(:each) do
    allow_any_instance_of(LibMpsse::I2CDevice).to receive(:get_new_context).and_return(mpsse)
    allow(mpsse).to receive(:stop)
    allow(mpsse).to receive(:start)
    allow(mpsse).to receive(:write).with([0x00, 0x06])
  end

  describe "#initialize" do
    it "does not raise" do
      expect { i2c }.not_to raise_error
    end
  end

  describe ".ping" do
    context "when no ack from i2c device" do
      it "returns false" do
        allow(mpsse).to receive(:write).with([address_write])
        allow(mpsse).to receive(:ack).and_return(1)
        expect(i2c.ping).to eq false
      end
    end

    context "when ack from i2c device" do
      it "returns true" do
        allow(mpsse).to receive(:write).with([address_write])
        allow(mpsse).to receive(:ack).and_return(0)
        expect(i2c.ping).to eq true
      end
    end
  end
end
