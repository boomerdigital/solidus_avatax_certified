# frozen_string_literal: true

module SolidusAvataxCertified
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/solidus_avatax_certified\n"
        append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/solidus_avatax_certified\n"
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=solidus_avatax_certified'
      end

      def auto_migrate?
        ENV['AUTO_RUN_MIGRATIONS'] =~ /true/i
      end

      def run_migrations
        # hiding this inside parent method so it's not auto-run by rails generator
        def migration_prompt_approved?
          result = ask('Would you like to run the migrations now? [Y/n]')
          result !~ /n/i
        end

        if auto_migrate? || migration_prompt_approved?
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end

      def include_seed_data
        append_file "db/seeds.rb", <<~SEEDS
                  \n
          SolidusAvataxCertified::Engine.load_seed if defined?(SolidusAvataxCertified::Engine)
        SEEDS
      end
    end
  end
end
