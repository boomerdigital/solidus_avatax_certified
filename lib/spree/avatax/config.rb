# frozen_string_literal: true

module Spree
  module Avatax
    def self.init
      const_set 'Config', Spree::AvataxConfiguration.new
    end
  end
end
