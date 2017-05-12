require 'spec_helper'

describe Spree::Adjustment, type: :model do
  let(:order) { build(:avalara_order) }

  describe '#avatax_cache_key' do
    it 'should respond with a cache key' do
      adjustment = build(:adjustment, id: 1, amount: 20.0, order: order)

      expected_response = 'Spree::Adjustment-1-20.0'

      expect(adjustment.avatax_cache_key).to eq(expected_response)
    end
  end
end
