# frozen_string_literal: true

module SolidusAvataxCertified
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace Spree
    engine_name 'solidus_avatax_certified'

    include SolidusSupport::EngineExtensions

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.frontend_available?
      const_defined?('::Spree::Frontend::Engine')
    end
  end
end
