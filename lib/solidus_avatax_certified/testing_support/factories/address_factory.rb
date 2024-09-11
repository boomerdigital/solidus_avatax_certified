# frozen_string_literal: true

FactoryBot.define do
  factory :valid_address, parent: :address do
    address1 { '47 W 13th St' }
    city { 'New York' }
    zipcode { '10011' }
    state_code { 'NY' }
  end
end
