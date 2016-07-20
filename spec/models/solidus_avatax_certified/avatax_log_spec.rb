require 'spec_helper'

describe SolidusAvataxCertified::AvataxLog, :type => :model do
  let(:logger) { SolidusAvataxCertified::AvataxLog.new('test_log', 'test_file.rb', 'test info') }


  before do
    Spree::AvalaraPreference.log_to_stdout.update_attributes(value: 'false')
  end

  describe '#enabled?' do
    it 'returns a boolean value' do
      Spree::AvalaraPreference.log.update_attributes(value: 'true')
      
      expect(logger.enabled?).to be_truthy
    end
  end

  describe '#progname' do
    it 'sets the logger progname' do
      Spree::AvalaraPreference.log_to_stdout.update_attributes(value: 'false')
      Spree::AvalaraPreference.log.update_attributes(value: 'true')
      logger = SolidusAvataxCertified::AvataxLog.new('test_log', 'test_file.rb', 'test info')

      expect{ logger.progname('changed') }.to change{ logger.progname }.from('test_file').to('changed')
    end

    it 'returns nil if logger is not enabled' do
      Spree::AvalaraPreference.log.update_attributes(value: 'false')

      expect(logger.progname('this_wont_change')).to be_nil
    end
  end

  describe '#info' do
    it 'logs info with given message' do
      logger = SolidusAvataxCertified::AvataxLog.new('test_log', 'test_file.rb', 'test info')

      expect(logger.logger).to receive(:info).with('[AVATAX] Hyah!')
      logger.info('Hyah!')
    end

    it 'returns nil if logger is not enabled' do
      Spree::AvalaraPreference.log.update_attributes(value: 'false')

      expect(logger.info('this_wont_change')).to be_nil
    end
  end

  describe '#info_and_debug' do
    it 'recieves info and debug messages' do
      logger = SolidusAvataxCertified::AvataxLog.new('test_log', 'test_file.rb', 'test info')

      expect(logger.logger).to receive(:info).with('[AVATAX] Hyah!')
      expect(logger.logger).to receive(:debug).with("[AVATAX] [\"Heuh!\"]")
      
      logger.info_and_debug('Hyah!', ['Heuh!'])
    end

    it 'returns nil if logger is not enabled' do
      Spree::AvalaraPreference.log.update_attributes(value: 'false')

      expect(logger.info_and_debug('Hyah!', ['Heuh!'])).to be_nil
    end
  end

  describe '#debug' do
    it 'receives debug with message' do
      logger = SolidusAvataxCertified::AvataxLog.new('test_log', 'test_file.rb', 'test info')

      expect(logger.logger).to receive(:debug).with("[AVATAX] [\"Heuh!\"]")
      
      logger.debug(['Heuh!'])
    end

    it 'returns nil if logger is not enabled' do
      Spree::AvalaraPreference.log.update_attributes(value: 'false')

      expect(logger.debug(['Heuh!'])).to be_nil
    end
  end
end
