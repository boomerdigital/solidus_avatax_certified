# frozen_string_literal: true

class Spree::AvataxConfiguration < Spree::Preferences::Configuration
  preference :company_code, :string, default: ENV['AVATAX_COMPANY_CODE']
  preference :account, :string, default: ENV['AVATAX_ACCOUNT']
  preference :license_key, :string, default: ENV['AVATAX_LICENSE_KEY']
  preference :environment, :string, default: -> { default_environment }
  preference :log, :boolean, default: true
  preference :log_to_stdout, :boolean, default: false
  preference :address_validation, :boolean, default: true
  preference :address_validation_enabled_countries, :array, default: ['United States', 'Canada']
  preference :tax_calculation, :boolean, default: true
  preference :document_commit, :boolean, default: true
  preference :origin, :string, default: '{}'
  preference :refuse_checkout_address_validation_error, :boolean, default: false
  preference :customer_can_validate, :boolean, default: false
  preference :raise_exceptions, :boolean, default: false

  def self.boolean_preferences
    %w(tax_calculation document_commit log log_to_stdout address_validation refuse_checkout_address_validation_error customer_can_validate raise_exceptions)
  end

  def self.storable_env_preferences
    %w(company_code account license_key environment)
  end

  def default_environment
    if ENV['AVATAX_ENVIRONMENT'].present?
      ENV['AVATAX_ENVIRONMENT']
    else
      Rails.env.production? ? 'production' : 'sandbox'
    end
  end
end
