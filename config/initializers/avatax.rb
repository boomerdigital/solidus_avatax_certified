# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  Spree::Avatax.init
end
