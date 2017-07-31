require 'spec_helper'

RSpec.describe SolidusAvataxCertified::Lines::Refund do
  let(:authorization) { generate(:refund_transaction_id) }
  let(:payment_amount) { 10*2 }
  let(:payment_method) { build(:credit_card_payment_method) }
  let(:payment) { build(:payment, amount: payment_amount, payment_method: payment_method, order: order) }
  let(:refund_reason) { build(:refund_reason) }
  let(:gateway_response) {
    ActiveMerchant::Billing::Response.new(
      gateway_response_success,
      gateway_response_message,
      gateway_response_params,
      gateway_response_options
    )
  }
  let(:gateway_response_success) { true }
  let(:gateway_response_message) { '' }
  let(:gateway_response_params) { {} }
  let(:gateway_response_options) { {} }

  let(:refund) {Spree::Refund.new(payment: payment, amount: BigDecimal.new(10), reason: refund_reason, transaction_id: nil)}
  let(:order) { build(:shipped_order) }
  subject { described_class.new(order, 'SalesOrder', refund) }

  describe 'build_lines' do
    it 'receives method refund_lines' do
      expect(subject).to receive(:refund_lines)
      subject.build_lines
    end
  end
  describe '#refund_line' do
    it 'returns an Hash' do
      expect(subject.refund_line).to be_kind_of(Hash)
    end
  end
  describe '#refund_line' do
    it 'returns an Array' do
      expect(subject.refund_lines).to be_kind_of(Array)
    end
  end
end
