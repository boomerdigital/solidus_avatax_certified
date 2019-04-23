# frozen_string_literal: true

Spree::StockLocation.class_eval do
  include ToAvataxHash
end
