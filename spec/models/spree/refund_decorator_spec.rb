# frozen_string_literal: true

require 'spec_helper'

describe Spree::Refund, :vcr do
  subject(:order) do
    order = create(:shipped_order)
    Spree::AvalaraTransaction.create(order: order)
    order.reload
  end

  let(:reimbursement) { create(:reimbursement) }
  let(:gateway_response_options) { {} }
  let(:gateway_response_params) { {} }
  let(:gateway_response_message) { '' }
  let(:gateway_response_success) { true }
  let(:gateway_response) {
    ActiveMerchant::Billing::Response.new(
      gateway_response_success,
      gateway_response_message,
      gateway_response_params,
      gateway_response_options
    )
  }
  let(:refund_reason) { create(:refund_reason) }
  let(:payment) { create(:payment, amount: payment_amount, payment_method: payment_method, order: order) }
  let(:payment_method) { create(:credit_card_payment_method) }
  let(:authorization) { generate(:refund_transaction_id) }
  let(:amount_in_cents) { amount * 100 }
  let(:amount) { 10.0 }

  let(:refund) { Spree::Refund.new(payment: payment, amount: BigDecimal(10), reason: refund_reason, transaction_id: nil, reimbursement: reimbursement) }
  let(:payment_amount) { amount * 2 }

  before do
    allow(payment.payment_method)
      .to receive(:credit)
      .with(amount_in_cents, payment.source, payment.transaction_id, originator: an_instance_of(Spree::Refund))
      .and_return(gateway_response)
    order.reload
  end

  it { is_expected.to have_one :avalara_transaction }

  describe '#avalara_tax_enabled?' do
    it 'returns true' do
      expect(Spree::Refund.new.avalara_tax_enabled?).to eq(true)
    end
  end

  describe '#avalara_capture_finalize' do
    subject do
      refund.save
    end

    it 'recieves avalara_capture_finalize and return hash' do
      expect(refund).to receive(:avalara_capture_finalize).and_return(Hash)
      subject
    end
  end

  context 'full refund' do
    subject do
      order.reload
      refund.avalara_capture_finalize
    end

    let(:order) { create(:completed_avalara_order) }
    let(:refund) { build(:refund, payment: order.payments.first, amount: order.total.to_f) }

    it 'returns correct tax calculations' do
      expect(subject['totalAmount'].to_f.abs).to eq(order.total - order.additional_tax_total)
      expect(subject['totalTax'].to_f.abs).to eq(0.6)
    end
  end
end
