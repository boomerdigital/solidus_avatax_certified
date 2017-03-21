require 'spec_helper'

describe Spree::Order do

  it { should have_one :avalara_transaction }
  let(:order) { build(:avalara_order, ship_address: build(:address)) }
  let(:completed_order) { create(:completed_avalara_order) }

  describe "#avalara_tax_enabled?" do
    it "should return true" do
      expect(order.avalara_tax_enabled?).to eq(true)
    end
  end

  describe "#cancel_avalara" do

    describe 'successful response', :vcr do
      it 'return a hash with a ResultCode of Success' do
        VCR.use_cassette("Spree_Order/_capture_finalize") do
          completed_order.avalara_capture_finalize
        end

        response = completed_order.cancel_avalara

        expect(response["ResultCode"]).to eq("Success")
        expect(response).to be_kind_of(Hash)
      end
    end

    it 'should receive cancel_order when cancel_avalara is called' do
      expect(completed_order.avalara_transaction).to receive(:cancel_order)
      completed_order.cancel_avalara
    end

    context 'state machine event cancel' do
      it 'should recieve cancel_avalara when event cancel is called' do
        expect(completed_order).to receive(:cancel_avalara)
        completed_order.cancel!
      end

      it 'avalara_transaction should recieve cancel_order when event cancel is called' do
        expect(completed_order.avalara_transaction).to receive(:cancel_order)
        completed_order.cancel!
      end
    end
  end

  describe "#avalara_capture", :vcr do
    it "should response with Hash object" do
      expect(order.avalara_capture).to be_kind_of(Hash)
    end
    it "creates new avalara_transaction" do
      expect{order.avalara_capture}.to change{Spree::AvalaraTransaction.count}.by(1)
    end
    it 'should have a ResultCode of success' do
      expect(order.avalara_capture['ResultCode']).to eq('Success')
    end
  end

  describe "#avalara_capture_finalize", :vcr do
    subject { completed_order.avalara_capture_finalize }

    before do
      VCR.use_cassette("Spree_Order/_capture_finalize") do
        completed_order.avalara_capture_finalize
      end
    end

    it "should response with Hash object" do
      expect(subject).to be_kind_of(Hash)
    end

    it 'should have a ResultCode of success' do
      expect(subject['ResultCode']).to eq('Success')
    end

    # Spec fails when using VCR since dates are involved.

    # context 'commit on completed at date' do
    #   before do
    #     completed_order.update_attributes(completed_at: 5.days.ago)
    #   end

    #   it 'has a docdate of completed at date' do
    #     response = completed_order.avalara_capture_finalize
    #     expect(response['DocDate']).to eq(5.days.ago.strftime('%F'))
    #   end
    # end
  end

  describe '#avatax_cache_key' do
    it 'should respond with a cache key' do
      expected_response = "Spree::Order-#{order.number}-#{order.promo_total}"

      expect(order.avatax_cache_key).to eq(expected_response)
    end
  end

  describe '#customer_usage_type' do
    let(:use_code) { build(:avalara_entity_use_code) }

    before do
      order.user.update_attributes(avalara_entity_use_code: use_code)
    end

    it 'should respond with user usage type' do
      expect(order.customer_usage_type).to eq('A')
    end
    it 'should respond with blank string if no user' do
      order.update_attributes(user: nil)
      expect(order.customer_usage_type).to eq('')
    end
  end

  describe '#validate_ship_address', :vcr do
    it 'should return the response if validation is success' do
      Spree::AvalaraPreference.address_validation.update_attributes(value: 'true')
      response = order.validate_ship_address

      expect(response['ResultCode']).to eq('Success')
    end

    it 'should return the response if refuse checkout on address validation is disabled' do
      Spree::AvalaraPreference.refuse_checkout_address_validation_error.update_attributes(value: 'false')
      response = order.validate_ship_address

      expect(response['ResultCode']).to eq('Success')
    end

    it 'should return false if validation failed' do
      Spree::AvalaraPreference.refuse_checkout_address_validation_error.update_attributes(value: 'true')
      order.ship_address.update_attributes(zipcode: nil, city: nil, address1: nil)
      response = order.validate_ship_address

      expect(response).to eq(false)
    end
  end

  describe '#address_validation_enabled?' do
    it 'should return false if ship address is nil' do
      order.ship_address = nil

      expect(order.address_validation_enabled?).to be_falsey
    end

    it 'returns true if preference is true and country validation is enabled' do
      Spree::AvalaraPreference.address_validation.update_attributes(value: 'true')
      Spree::AvalaraPreference.validation_enabled_countries.update_attributes(value: 'United States,Canada')

      expect(order.address_validation_enabled?).to be_truthy
    end

    it 'returns false if address validation preference is false' do
      Spree::AvalaraPreference.address_validation.update_attributes(value: 'false')

      expect(order.address_validation_enabled?).to be_falsey
    end

    it 'returns false if enabled country is not present' do
      Spree::AvalaraPreference.validation_enabled_countries.update_attributes(value: 'Canada')

      expect(order.address_validation_enabled?).to be_falsey
    end
  end
end
