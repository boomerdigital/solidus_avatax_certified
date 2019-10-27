# frozen_string_literal: true

require 'spec_helper'

describe SolidusAvataxCertified::Address, type: :model do
  let(:address){ build(:address) }
  let(:order) { build(:order_with_line_items, ship_address: address) }

  before do
    Spree::Avatax::Config.address_validation = true
  end

  let(:address_lines) { SolidusAvataxCertified::Address.new(order) }

  describe '#initialize' do
    it 'has order' do
      expect(address_lines.order).to eq(order)
    end
    it 'has addresses be a Hash' do
      expect(address_lines.addresses).to be_kind_of(Hash)
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
  end

  describe '#origin_address' do
    it 'returns a hash with correct keys' do
      expect(address_lines.origin_address).to be_kind_of(Hash)
      expect(address_lines.origin_address[:line1]).to be_present
    end
  end

  describe '#order_ship_address' do
    it 'returns a Hash with correct keys' do
      expect(address_lines.order_ship_address).to be_kind_of(Hash)
      expect(address_lines.order_ship_address[:line1]).to be_present
    end
  end

  describe '#validate', :vcr do
    subject do
      address_lines.validate
    end

    it "validates address with success" do
      expect(subject).to be_success
    end

    it "does not validate when config settings are false" do
      Spree::Avatax::Config.address_validation = false

      expect(subject).to eq("Address validation disabled")
    end

    context 'error' do
      subject do
        order.ship_address.update(city: nil, zipcode: nil)
        address_lines.validate
      end

      let(:order) { create(:order_with_line_items) }

      it 'fails when information is incorrect' do
        expect(subject).to be_error
      end

      it 'raises exception if preference is set to true' do
        Spree::Avatax::Config.raise_exceptions = true

        expect { subject }.to raise_exception(SolidusAvataxCertified::RequestError)
      end
    end
  end
end
