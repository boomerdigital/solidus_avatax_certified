# frozen_string_literal: true

module SolidusAvataxCertified
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace Spree
    engine_name 'solidus_avatax_certified'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
