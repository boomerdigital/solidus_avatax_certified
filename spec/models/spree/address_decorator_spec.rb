require 'spec_helper'

describe Spree::Address, type: :model do
  let(:address) { build(:address) }

  describe '#validation_enabled?' do
    it 'returns true if preference is true and country validation is enabled' do
      Spree::AvalaraPreference.address_validation.update_attributes(value: 'true')
      Spree::AvalaraPreference.validation_enabled_countries.update_attributes(value: 'United States,Canada')

      expect(address.validation_enabled?).to be_truthy
    end

    it 'returns false if address validation preference is false' do
      Spree::AvalaraPreference.address_validation.update_attributes(value: 'false')

      expect(address.validation_enabled?).to be_falsey
    end

    it 'returns false if enabled country is not present' do
      Spree::AvalaraPreference.validation_enabled_countries.update_attributes(value: 'Canada')

      expect(address.validation_enabled?).to be_falsey
    end
  end

  describe '#country_validation_enabled?' do
    it 'returns true if the current country is enabled' do
      expect(address.country_validation_enabled?).to be_truthy
    end
  end

  describe '#validation_enabled_countries' do
    it 'returns an array' do
      expect(Spree::Address.validation_enabled_countries).to be_kind_of(Array)
    end

    it 'includes United States' do
      Spree::AvalaraPreference.validation_enabled_countries.update_attributes(value: 'United States,Canada')

      expect(Spree::Address.validation_enabled_countries).to include('United States')
    end
  end
end
