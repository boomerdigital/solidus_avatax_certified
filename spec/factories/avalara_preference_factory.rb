FactoryGirl.define do
  factory :avalara_preference, class: Spree::AvalaraPreference do
    name { "AvalaraPreference - #{rand(999999)}" }
    value '54321'
    object_type 'string'
  end
end
