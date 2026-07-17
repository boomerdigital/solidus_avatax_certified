# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Admin::UsersController do
  let(:user) { FactoryBot.create(:user) }

  stub_authorization!

  before do
    DatabaseCleaner.clean
  end

  describe 'PUT avalara_information' do
    subject do
      put :avalara_information, params: { id: user.id, user: { exemption_number: 'FED-EX-12345' } }
    end

    it 'sets a resolved success flash message, not a missing translation' do
      subject
      expect(flash[:success]).to eq('Account updated')
    end
  end
end
