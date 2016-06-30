namespace :solidus_avatax_certified do
  desc "Loads seed data."
  task load_seeds: :environment do
    SolidusAvataxCertified::Seeder.seed!
    SolidusAvataxCertified::PreferenceSeeder.seed!
  end

  task load_preferences: :environment do
    SolidusAvataxCertified::PreferenceSeeder.seed!
  end
end
