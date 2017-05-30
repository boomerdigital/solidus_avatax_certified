require 'spec_helper'

RSpec.describe TaxSvc, :vcr do
  let(:taxsvc) { TaxSvc.new }
  let(:request_hash) { attributes_for(:request_hash) }

  describe '#get_tax' do
    subject { taxsvc.get_tax(request_hash) }

    it 'gets tax when all credentials are there' do
      expect(subject.tax_result['ResultCode']).to eq('Success')
    end

    context 'fails' do
      it 'fails when no params are given' do
        expect(taxsvc.get_tax({}).tax_result['ResultCode']).to eq('Error')
      end

      it 'responds with error when result code is not a success' do
        req = attributes_for(:request_hash)
        req[:Lines][0][:TaxCode] = 'sdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdf'
        result = taxsvc.get_tax(req).tax_result

        expect(result['ResultCode']).to eq('Error')
      end

      it 'fails when no lines are given' do
        result = taxsvc.get_tax(attributes_for(:request_hash, Lines: [])).tax_result

        expect(result['ResultCode']).to eq('Error')
      end
    end
  end

  describe '#cancel_tax' do
    let(:request_hash) {  attributes_for(:request_hash, Commit: true, DocDate: Date.today.strftime('%F'), DocType: 'SalesInvoice', DocCode: 'testcancel123') }

    it 'should raise error if no transaction_code is passed' do
      expect { taxsvc.cancel_tax(nil) }.to raise_error
    end

    it 'respond with success' do
      success_res = taxsvc.get_tax(request_hash)
      result = taxsvc.cancel_tax(request_hash[:DocCode])

      expect(result.tax_result['status']).to eq('Cancelled')
    end
  end

  describe '#ping' do
    it 'should return estimate' do
      result = taxsvc.ping
      expect(result['ResultCode']).to eq('Success')
    end
  end
end

