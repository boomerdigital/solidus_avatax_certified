# frozen_string_literal: true

require 'spec_helper'

describe Spree.user_class do
  it { is_expected.to belong_to(:avalara_entity_use_code).optional }
end

# Regression: host apps using solidus_auth_devise get a Spree::User that does
# NOT inherit from Spree::LegacyUser (it sets Spree.user_class = "Spree::User"
# in its own engine initializer). The dummy app's Spree.user_class is
# force-set to Spree::LegacyUser, masking that mismatch, so this simulates
# the auth-gem scenario directly by repointing Spree.user_class and
# reloading the decorator, exactly as config.to_prepare does on every boot.
describe "when Spree.user_class resolves to an auth-gem-provided class" do
  around do |example|
    original_user_class = Spree.user_class_name
    Spree.user_class = "Spree::User"
    example.run
  ensure
    Spree.user_class = original_user_class
    load SolidusAvataxCertified::Engine.root.join(
      "app/decorators/models/solidus_avatax_certified/spree/user_decorator.rb"
    )
  end

  it "prepends the decorator onto the configured user class" do
    load SolidusAvataxCertified::Engine.root.join(
      "app/decorators/models/solidus_avatax_certified/spree/user_decorator.rb"
    )

    expect(Spree::User.new).to respond_to(:avalara_entity_use_code)
  end
end
