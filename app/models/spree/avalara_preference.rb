module Spree
  class AvalaraPreference < Spree::Base
    validates_uniqueness_of :name
    validates_presence_of :name, :object_type

    scope :booleans, -> { where(object_type: 'boolean') }
    scope :strings, -> { where(object_type: 'string') }
    scope :arrays, -> { where(object_type: 'array') }
    scope :jsons, -> { where(object_type: 'json') }
    scope :storable_envs, -> { where(name: ['company_code', 'license_key', 'account', 'endpoint']) }

    def self.company_code
      find_by(name: 'company_code')
    end

    def self.license_key
      find_by(name: 'license_key')
    end

    def self.account
      find_by(name: 'account')
    end

    def self.endpoint
      find_by(name: 'endpoint')
    end

    def self.origin_address
      find_by(name: 'origin_address')
    end

    def self.log
      find_by(name: 'log')
    end

    def self.log_to_stdout
      find_by(name: 'log_to_stdout')
    end

    def self.address_validation
      find_by(name: 'address_validation')
    end

    def self.refuse_checkout_address_validation_error
      find_by(name: 'refuse_checkout_address_validation_error')
    end

    def self.tax_calculation
      find_by(name: 'tax_calculation')
    end

    def self.document_commit
      find_by(name: 'document_commit')
    end

    def self.validation_enabled_countries
      find_by(name: 'address_validation_enabled_countries')
    end

    def self.validation_enabled_countries_array
      find_by(name: 'address_validation_enabled_countries').value.split(',')
    end

    def self.customer_can_validate
      find_by(name: 'customer_can_validate')
    end

    def is_true?
      [true, 1, "1", "t", "T", "true", "TRUE", "on", "ON"].include?(value)
    end
  end
end
