# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TaxSvc, :vcr do
  let(:taxsvc) { TaxSvc.new }
  let(:request_hash) { build(:request_hash) }

  describe '#get_tax' do
    it 'returns tax data' do
      response = taxsvc.get_tax(request_hash)

      expect(response).to be_success
      expect(response.tax_result['totalTax']).to be_present
    end

    it 'returns error response when no params are given' do
      response = taxsvc.get_tax({})

      expect(response).to be_error
      expect(response.tax_result.keys.first).to eq('error')
    end

    it 'returns error response when taxCode is too long' do
      req = build(:request_hash)
      req[:createTransactionModel][:lines][0][:taxCode] = 'sdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdf'
      response = taxsvc.get_tax(req)

      expect(response).to be_error
      expect(response.tax_result.keys.first).to eq('error')
    end

    it 'returns error response when no lines are given' do
      req = build(:request_hash)
      req[:createTransactionModel][:lines] = []
      response = taxsvc.get_tax(req)

      expect(response).to be_error
      expect(response.tax_result.keys.first).to eq('error')
    end
  end

  describe '#cancel_tax' do
    let(:request_hash) {
      req = build(:request_hash)
      req[:createTransactionModel][:commit] = true
      req[:createTransactionModel][:type] = 'SalesInvoice'
      req
    }

    it 'returns successful response' do
      taxsvc.get_tax(request_hash)
      response = taxsvc.cancel_tax(request_hash[:createTransactionModel][:code])

      expect(response).to be_success
      expect(response.tax_result['status']).to eq('Cancelled')
    end

    it 'returns error response if no transaction_code is passed' do
      response = taxsvc.cancel_tax(nil)

      expect(response).to be_error
    end
  end

  describe '#ping' do
    it 'returns successful response' do
      expect(taxsvc.ping).to be_success
    end
  end

  describe '#validate_address' do
    it 'returns validated address data if address resolved' do
      response = taxsvc.validate_address(build(:address_hash))

      expect(response).to be_success
      expect(response.validated_address).to include('latitude', 'longitude')
    end

    it 'returns failure messages if address not resolved' do
      address_data = build(:address_hash)
      address_data[:city] = 'NON EXISTENT CITY'
      address_data[:postalCode] = '42'
      response = taxsvc.validate_address(address_data)

      expect(response).to be_failed
      expect(response.validated_address).to be_blank
      expect(response.messages.first).to include(
        "details" => "Address cannot be geocoded."
      )
    end
  end
end
