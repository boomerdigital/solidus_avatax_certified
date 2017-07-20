require 'spec_helper'

describe Spree::Payment, :vcr do
  let(:order) { create(:avalara_order) }

  let(:gateway) do
    gateway = Spree::Gateway::Bogus.new( :active => true, :name => 'Bogus gateway')
    allow(gateway).to receive_messages :environment => 'test'
    allow(gateway).to receive_messages :source_required => true
    gateway
  end

  let(:card) do
    Spree::CreditCard.create!(
      number: '4111111111111111',
      month: '12',
      year: Time.now.year + 1,
      verification_value: '123',
      name: 'Name',
      imported: false
    )
  end

  let(:payment) do
    payment = Spree::Payment.new
    payment.source = card
    payment.order = order
    payment.payment_method = gateway
    payment.amount = order.total
    payment.save
    payment
  end

  let(:amount_in_cents) { (payment.amount * 100).round }

  let!(:success_response) do
    double('success_response', :success? => true,
           :authorization => '123',
           :avs_result => { 'code' => 'avs-code' },
           :cvv_result => { 'code' => 'cvv-code', 'message' => 'CVV Result'})
  end

  let(:failed_response) { double('gateway_response', :success? => false) }

  before(:each) do
    allow(payment.log_entries).to receive(:create!)
  end


  describe '#purchase!' do
    subject do
      order.avalara_capture_finalize
      payment.purchase!
    end

    it 'receive avalara_finalize' do
      expect(payment).to receive(:avalara_finalize)
      subject
    end
  end

  describe '#avalara_finalize' do
    subject do
      order.avalara_capture_finalize
      payment.complete!
    end

    it 'should receive avalara_finalize' do
      expect(payment).to receive(:avalara_finalize)

      subject
    end
  end

  describe '#void_transaction!' do
    it 'receive cancel_avalara' do
      expect(payment).to receive(:cancel_avalara)
      payment.void_transaction!
    end
  end

  describe '#cancel_avalara' do
    context 'uncommitted order' do
      let!(:order) { create(:avalara_order) }

      describe 'should fail' do
        it 'returns error key' do
          response = payment.cancel_avalara
          expect(response['error']).to be_present
        end
      end
    end

    context 'committed order' do
      let(:order) { create(:completed_avalara_order) }

      subject do
        order.avalara_capture_finalize
        payment.cancel_avalara
      end

      describe 'should be successful' do
        it 'status returns Cancelled' do
          expect(subject['status']).to eq('Cancelled')
        end
      end
    end
  end
end
