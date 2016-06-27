namespace :solidus_avatax_certified do
  desc "Loads seed data."
  task load_seeds: :environment do
    SolidusAvataxCertified::Seeder.seed!
  end
end
