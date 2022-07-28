# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  Spree::PermittedAttributes.user_attributes.concat(%i[avalara_entity_use_code_id exemption_number vat_id])
  Rails.application.config.spree.calculators.tax_rates << Spree::Calculator::AvalaraTransaction
  Spree::Config.tax_adjuster_class = SolidusAvataxCertified::OrderAdjuster
end
