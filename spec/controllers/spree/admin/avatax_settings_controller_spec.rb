require 'spec_helper'

describe Spree::Admin::AvataxSettingsController, :type => :controller do

  stub_authorization!

  describe '/avatax_settings' do
    subject { get :show }
    it { should be_success }
  end

  describe '/avatax_settings/edit' do
    subject { get :edit }
    it { should be_success }
  end

  describe '/avatax_settings/download_avatax_log' do
    before { File.new("#{Rails.root}/log/avatax.log", 'w') }
    after { File.delete("#{Rails.root}/log/avatax.log") }

    subject { get :download_avatax_log }
    it { should be_success }
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
      response.should be_success
      flash.should_not be_nil
    end
  end

  describe '#update' do
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
    subject { put :update, params: params }

    it { is_expected.to redirect_to(spree.admin_avatax_settings_path) }
  end
end
