require 'spec_helper'

RSpec.describe SolidusAvataxCertified::Response::Base do
  subject { described_class.new(response_hash) }

  describe '#success?' do
    let(:response_hash) { build(:response_hash_success) }

    it 'returns true when totalTax is present' do
      expect(subject.success?).to be true
    end
  end

  describe '#error?' do
    let(:response_hash) { build(:response_hash_error) }

    it 'returns true with totalTax is not present' do
      expect(subject.error?).to be true
    end
  end
end
