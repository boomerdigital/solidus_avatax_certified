# frozen_string_literal: true

require 'spec_helper'

describe Spree::Admin::AvataxSettingsController, type: :controller do
  stub_authorization!

  describe '/avatax_settings' do
    subject { get :show }

    it { is_expected.to be_successful }
  end

  describe '/avatax_settings/edit' do
    subject { get :edit }

    it { is_expected.to be_successful }
  end

  describe '/avatax_settings/download_avatax_log' do
    subject { get :download_avatax_log }

    before { File.new("#{Rails.root}/log/avatax.log", 'w') }

    after { File.delete("#{Rails.root}/log/avatax.log") }

    it { is_expected.to be_successful }
  end

  describe '/avatax_settings/erase_data' do
    it 'erases the log' do
      Dir.mkdir('log') unless Dir.exist?('log')
      file = File.open("log/avatax.log", 'w') { |f| f.write('Hyah!') }

      expect(File.read('log/avatax.log')).to eq('Hyah!')

      get :erase_data

      expect(File.read('log/avatax.log')).to eq('')
    end
  end

  describe '/avatax_settings/ping_my_service' do
    subject do
      VCR.use_cassette('ping', allow_playback_repeats: true) do
        get :ping_my_service
      end
    end

    it 'flashes message' do
      subject
      expect(response).to be_successful
      expect(flash).not_to be_nil
    end
  end

  describe '#update' do
    subject { put :update, params: params }

    let(:params) do
      {
        address: {
          Line1: "",
          Line2: "",
          City: "",
          Region: "",
          PostalCode: "",
          Country: ""
        },
        settings: {
          account: '123456789',
          address_validation_enabled_countries: []
        }
      }
    end

    it { is_expected.to redirect_to(spree.admin_avatax_settings_path) }
  end
end
