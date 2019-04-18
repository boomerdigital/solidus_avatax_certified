# frozen_string_literal: true

Spree::Adjustment.class_eval do
  def avatax_cache_key
    key = ['Spree::Adjustment']
    key << id
    key << amount
    key.join('-')
  end
end
