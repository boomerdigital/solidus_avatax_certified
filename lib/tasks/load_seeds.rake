# frozen_string_literal: true

namespace :solidus_avatax_certified do
  desc "Loads seed data."
  task load_seeds: :environment do
    SolidusAvataxCertified::Seeder.seed!
  end

  task load_use_codes: :environment do
    SolidusAvataxCertified::Seeder.seed_use_codes!
  end
end
