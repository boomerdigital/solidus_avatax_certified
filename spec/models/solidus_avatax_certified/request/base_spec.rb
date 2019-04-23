# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusAvataxCertified::Request::Base do
  subject { described_class.new(order) }

  let(:order) { Spree::Order.new }

  describe '#generate' do
    it 'raises error' do
      expect{ subject.generate }.to raise_error('Method needs to be implemented in subclass.')
    end
  end
end
