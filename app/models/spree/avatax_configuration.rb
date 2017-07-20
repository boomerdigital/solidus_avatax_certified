class Spree::AvataxConfiguration < Spree::Preferences::Configuration
  preference :company_code, :string
  preference :account, :string
  preference :license_key, :string
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
    %w(company_code account license_key)
  end

  def self.environment
    if Rails.env.production?
      :production
    else
      :sandbox
    end
  end
end
