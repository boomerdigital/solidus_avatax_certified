require 'spec_helper'

describe Spree::AvalaraTransaction, :vcr do

  it { should belong_to :order }
  it { should validate_presence_of :order }
  it { should validate_uniqueness_of :order_id }
  it { should have_db_index :order_id }

  let(:included_in_price) { false }
  let(:order) { create(:avalara_order, tax_included: included_in_price) }

  context 'captured orders' do
    # 0.4 tax is for line item
    # 0.2 is for shipment
    before do
      VCR.use_cassette('order_capture', allow_playback_repeats: true) do
        order.avalara_capture
      end
    end

    describe '#lookup_avatax' do
      subject do
        VCR.use_cassette('order_capture', allow_playback_repeats: true) do
          order.avalara_transaction.lookup_avatax
        end
      end

      it 'should look up avatax' do
        expect(subject['totalTax']).to eq(0.6)
      end
    end

    describe '#commit_avatax' do
      subject do
        VCR.use_cassette('order_capture', allow_playback_repeats: true) do
          order.avalara_transaction.commit_avatax('SalesOrder')
        end
      end

      it 'should commit avatax' do
        expect(subject['totalTax']).to eq(0.6)
      end

      context 'tax calculation disabled' do
        it 'should respond with total tax of 0' do
          Spree::Avatax::Config.tax_calculation = false
          expect(order.avalara_transaction.commit_avatax('SalesOrder')[:totalTax]).to eq(0.0)
        end
      end
    end

    context 'promo' do
      let(:promotion) { create(:promotion, :with_order_adjustment) }

      before do
        create(:adjustment, order: order, source: promotion.promotion_actions.first, adjustable: order)
        order.updater.update
      end

      subject do
        VCR.use_cassette('order_capture_with_promo', allow_playback_repeats: true) do
          order.avalara_transaction.commit_avatax('SalesOrder')
        end
      end

      it 'applies discount' do
        expect(subject['lines'][0]['discountAmount']).to eq(10.0)
      end
    end

    context 'included_in_price' do
      let(:included_in_price) { true }

      subject do
        VCR.use_cassette("tax_included_order") do
          order.avalara_transaction.commit_avatax('SalesOrder')
        end
      end

      it 'calculates the included tax amount from item total' do
        expect(subject['totalTax']).to eq(0.57)
      end
    end

    describe '#commit_avatax_final' do
      subject do
        VCR.use_cassette("order_capture_finalize", allow_playback_repeats: true) do
          order.avalara_transaction.commit_avatax_final('SalesInvoice')
        end
      end

      it 'should commit avatax final' do
        expect(subject['totalTax']).to eq(0.6)
      end

      it 'should fail to commit to avatax if settings are false' do
        Spree::Avatax::Config.document_commit = false

        expect(subject).to eq('Avalara Document Committing Disabled')
      end

      context 'tax calculation disabled' do
        it 'should respond with total tax of 0' do
          Spree::Avatax::Config.tax_calculation = false
          expect(subject[:totalTax]).to eq(0.0)
        end
      end

      context 'with CustomerUsageType' do
        let(:use_code) { create(:avalara_entity_use_code) }

        before do
          order.user.update_attributes(avalara_entity_use_code: use_code)
        end

        subject do
          VCR.use_cassette('capture_with_customer_usage_type', allow_playback_repeats: true) do
            order.avalara_transaction.commit_avatax('SalesInvoice')
          end
        end

        it 'does not add additional tax' do
          expect(subject['totalTax']).to eq(0)
        end
      end
    end


    describe '#cancel_order' do

      describe 'when successful' do
        let(:order) { create(:completed_avalara_order) }
        subject do
          VCR.use_cassette('order_cancel', allow_playback_repeats: true) do
            order.avalara_capture_finalize
            order.avalara_transaction.cancel_order
          end
        end

        it 'should receive status of cancelled' do
          expect(subject['status']).to eq('Cancelled')
        end
      end

      context 'error' do
        it 'should receive error' do
          order = create(:order)
          order.avalara_transaction = Spree::AvalaraTransaction.create
          expect(order.avalara_transaction).to receive(:cancel_order_to_avalara).and_return('Error in Tax')
          order.avalara_transaction.cancel_order
        end
      end
    end
  end

  context 'return orders' do
    let(:order) { create(:completed_avalara_order) }
    let(:reimbursement) { create(:reimbursement, order: order) }
    let(:refund) { build(:refund, payment: order.payments.first, amount: order.total.to_f) }

    before do
      VCR.use_cassette('order_capture_finalize', allow_playback_repeats: true) do
        order.avalara_capture_finalize
        order.reload
      end
    end

    describe '#commit_avatax' do
      subject do
        VCR.use_cassette('order_return_capture', allow_playback_repeats: true) do
          order.avalara_transaction.commit_avatax('ReturnOrder', refund)
        end
      end

      it 'should receive totalTax key' do
        expect(subject['totalTax']).to be_present
      end

      it 'should have a totalTax equal to additional_tax_total' do
        expect(subject['totalTax']).to eq(-order.additional_tax_total.to_f)
      end
    end

    describe '#commit_avatax_final' do
      subject do
        VCR.use_cassette('order_return_capture', allow_playback_repeats: true) do
          order.avalara_transaction.commit_avatax_final('ReturnOrder', refund)
        end
      end

      it 'should commit avatax final' do
        expect(subject).to be_kind_of(Hash)
        expect(subject['totalTax']).to eq(-order.additional_tax_total.to_f)
      end

      it 'should receive post_order_to_avalara' do
        expect(order.avalara_transaction).to receive(:post_return_to_avalara)
        subject
      end
    end
  end
end
