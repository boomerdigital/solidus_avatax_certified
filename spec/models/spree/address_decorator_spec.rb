# frozen_string_literal: true

require 'spec_helper'

describe Spree::Address, type: :model do
  let(:address) { build(:address) }

  describe '#validation_enabled?' do
    it 'returns true if preference is true and country validation is enabled' do
      Spree::Avatax::Config.address_validation = true
      Spree::Avatax::Config.address_validation_enabled_countries = ['United States', 'Canada']

      expect(address).to be_validation_enabled
    end

    it 'returns false if address validation preference is false' do
      Spree::Avatax::Config.address_validation = false

      expect(address).not_to be_validation_enabled
    end

    it 'returns false if enabled country is not present' do
      Spree::Avatax::Config.address_validation_enabled_countries = ['Canada']

      expect(address).not_to be_validation_enabled
    end
  end

  describe '#country_validation_enabled?' do
    it 'returns true if the current country is enabled' do
      expect(address).to be_country_validation_enabled
    end
  end

  describe '#validation_enabled_countries' do
    it 'returns an array' do
      expect(Spree::Address.validation_enabled_countries).to be_kind_of(Array)
    end

    it 'includes United States' do
      Spree::Avatax::Config.address_validation_enabled_countries = ['United States', 'Canada']

      expect(Spree::Address.validation_enabled_countries).to include('United States')
    end
  end
end
