require 'spec_helper'

describe Spree::AvalaraPreference, type: :model do
  it { should validate_uniqueness_of :name }
  it { should validate_presence_of :name }
  it { should validate_presence_of :object_type }

  describe '#booleans' do
    it 'should return records with object_type of boolean' do
      boolean_pref = create(:avalara_preference, object_type: 'boolean')
      other_pref = create(:avalara_preference, object_type: 'string')

      expect(Spree::AvalaraPreference.booleans).to include(boolean_pref)
      expect(Spree::AvalaraPreference.booleans).to_not include(other_pref)
    end
  end

  describe '#strings' do
    it 'should return records with object_type of string' do
      string_pref = create(:avalara_preference, object_type: 'string')
      other_pref = create(:avalara_preference, object_type: 'boolean')

      expect(Spree::AvalaraPreference.strings).to include(string_pref)
      expect(Spree::AvalaraPreference.strings).to_not include(other_pref)
    end
  end

  describe '#arrays' do
    it 'should return records with object_type of array' do
      array_pref = create(:avalara_preference, object_type: 'array')
      other_pref = create(:avalara_preference, object_type: 'boolean')

      expect(Spree::AvalaraPreference.arrays).to include(array_pref)
      expect(Spree::AvalaraPreference.arrays).to_not include(other_pref)
    end
  end

  describe '#jsons' do
    it 'should return records with object_type of json' do
      json_pref = create(:avalara_preference, object_type: 'json')
      other_pref = create(:avalara_preference, object_type: 'boolean')

      expect(Spree::AvalaraPreference.jsons).to include(json_pref)
      expect(Spree::AvalaraPreference.jsons).to_not include(other_pref)
    end
  end

  describe '#storeable_env' do
    it 'should return records with that have name is either company_code, license_key, account and endpoint' do
      storable_pref = Spree::AvalaraPreference.company_code
      other_pref = create(:avalara_preference, name: 'other')

      expect(Spree::AvalaraPreference.storable_envs).to include(storable_pref)
      expect(Spree::AvalaraPreference.storable_envs).to_not include(other_pref)
    end
  end

  describe '#company_code' do
    it 'should return object with the same name' do
      company_code = Spree::AvalaraPreference.find_by(name: 'company_code')

      expect(Spree::AvalaraPreference.company_code).to eq(company_code)
    end
  end

  describe '#license_key' do
    it 'should return object with same name' do
      license_key = Spree::AvalaraPreference.find_by(name: 'license_key')

      expect(Spree::AvalaraPreference.license_key).to eq(license_key)
    end
  end

  describe '#account' do
    it 'should return object with same name' do
      account = Spree::AvalaraPreference.find_by(name: 'account')

      expect(Spree::AvalaraPreference.account).to eq(account)
    end
  end

  describe '#endpoint' do
    it 'should return object with same name' do
      endpoint = Spree::AvalaraPreference.find_by(name: 'endpoint')

      expect(Spree::AvalaraPreference.endpoint).to eq(endpoint)
    end
  end

  describe '#origin_address' do
    it 'should return object with same name' do
      origin_address = Spree::AvalaraPreference.find_by(name: 'origin_address')

      expect(Spree::AvalaraPreference.origin_address).to eq(origin_address)
    end
  end

  describe '#log' do
    it 'should return object with same name' do
      log = Spree::AvalaraPreference.find_by(name: 'log')

      expect(Spree::AvalaraPreference.log).to eq(log)
    end
  end

  describe '#log_to_stdout' do
    it 'should return object with same name' do
      log_to_stdout = Spree::AvalaraPreference.find_by(name: 'log_to_stdout')

      expect(Spree::AvalaraPreference.log_to_stdout).to eq(log_to_stdout)
    end
  end

  describe '#address_validation' do
    it 'should return object with same name' do
      address_validation = Spree::AvalaraPreference.find_by(name: 'address_validation')

      expect(Spree::AvalaraPreference.address_validation).to eq(address_validation)
    end
  end

  describe '#refuse_checkout_address_validation_error' do
    it 'should return object with same name' do
      pref = Spree::AvalaraPreference.find_by(name: 'refuse_checkout_address_validation_error')

      expect(Spree::AvalaraPreference.refuse_checkout_address_validation_error).to eq(pref)
    end
  end

  describe '#tax_calculation' do
    it 'should return object with same name' do
      tax_calculation = Spree::AvalaraPreference.find_by(name: 'tax_calculation')

      expect(Spree::AvalaraPreference.tax_calculation).to eq(tax_calculation)
    end
  end

  describe '#document_commit' do
    it 'should return object with same name' do
      document_commit = Spree::AvalaraPreference.find_by(name: 'document_commit')

      expect(Spree::AvalaraPreference.document_commit).to eq(document_commit)
    end
  end

  describe '#validation_enabled_countries' do
    it 'should return object with name address_validation_enabled_countries' do
      validation_enabled_countries = Spree::AvalaraPreference.find_by(name: 'address_validation_enabled_countries')

      expect(Spree::AvalaraPreference.validation_enabled_countries).to eq(validation_enabled_countries)
    end
  end

  describe '#validation_enabled_countries_array' do
    it 'should return the objects value as an array' do
      value = ['United States', 'Canada']

      expect(Spree::AvalaraPreference.validation_enabled_countries_array).to eq(value)
    end
  end

  describe '#is_true?' do
    it 'should return true if value is a string of true or false' do
      expect(Spree::AvalaraPreference.tax_calculation.is_true?).to be_in([true, false])
    end

    it 'should return false if value is an empty string' do
      Spree::AvalaraPreference.origin_address.update_attributes(value: "")

      expect(Spree::AvalaraPreference.origin_address.is_true?).to be_falsey
    end
  end
end
