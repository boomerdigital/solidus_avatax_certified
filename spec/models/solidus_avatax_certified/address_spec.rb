require 'spec_helper'

describe SolidusAvataxCertified::Address, :type => :model do
  let(:address){ build(:address) }
  let(:order) { build(:order_with_line_items, ship_address: address) }

  before do
    Spree::Avatax::Config.address_validation = true
  end

  let(:address_lines) { SolidusAvataxCertified::Address.new(order) }

  describe '#initialize' do
    it 'should have order' do
      expect(address_lines.order).to eq(order)
    end
    it 'should have addresses be an array' do
      expect(address_lines.addresses).to be_kind_of(Array)
    end
  end

  describe '#build_addresses' do
    it 'receives origin_address' do
        expect(address_lines).to receive(:origin_address)
        address_lines.build_addresses
    end
    it 'receives order_ship_address' do
        expect(address_lines).to receive(:order_ship_address)
        address_lines.build_addresses
    end
    it 'receives origin_ship_addresses' do
        expect(address_lines).to receive(:origin_ship_addresses)
        address_lines.build_addresses
    end
  end

  describe '#origin_address' do
    it 'returns an array' do
      expect(address_lines.origin_address).to be_kind_of(Array)
    end

    it 'has the origin address return a hash' do
      expect(address_lines.origin_address[0]).to be_kind_of(Hash)
    end
  end

  describe '#order_ship_address' do
    it 'returns an array' do
      expect(address_lines.order_ship_address).to be_kind_of(Array)
    end

    it 'has the origin address return a hash' do
      expect(address_lines.order_ship_address[0]).to be_kind_of(Hash)
    end
  end

  describe '#validate', :vcr do
    subject do
      VCR.use_cassette('address_validation_success', allow_playback_repeats: true) do
        address_lines.validate
      end
    end

    it "validates address with success" do
      expect(subject["ResultCode"]).to eq("Success")
    end

    it "does not validate when config settings are false" do
      Spree::Avatax::Config.address_validation = false

      expect(subject).to eq("Address validation disabled")
    end

    context 'error' do
      let(:order) { create(:order_with_line_items) }

      subject do
        VCR.use_cassette('address_validation_failure', allow_playback_repeats: true) do
          order.ship_address.update_attributes(city: nil, zipcode: nil)
          address_lines.validate
        end
      end

      it 'fails when information is incorrect' do
        expect(subject['ResultCode']).to eq('Error')
      end

      it 'raises exception if preference is set to true' do
        Spree::Avatax::Config.raise_exceptions = true

        expect { subject }.to raise_exception(SolidusAvataxCertified::RequestError)
      end
    end
  end
end
