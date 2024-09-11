# frozen_string_literal: true

FactoryBot.define do
  factory :request_hash, class: Hash do
    createTransactionModel {
      {
        code: "TEST-#{SecureRandom.hex(10)}",
        date: Date.today.strftime('%F'),
        discount: '0.0',
        commit: false,
        type: 'SalesOrder',
        lines: [
          {
            number: '1-LI',
            description: 'Product #1 - 1825',
            taxCode: 'PC030000',
            itemCode: 'SKU-1',
            quantity: 1,
            amount: 10.0,
            customerUsageType: nil,
            discounted: false,
            taxIncluded: false,
            addresses: {
              shipFrom: {
                line1: '1600 Pennsylvania Ave NW',
                line2: nil,
                city: 'Washington',
                region: 'DC',
                country: 'US',
                postalCode: '20500'
              },
              shipTo: {
                line1: '915 S Jackson St',
                line2: nil,
                city: 'Montgomery',
                region: 'AL',
                country: 'US',
                postalCode: '36104'
              }
            }
          }
        ],
        customerCode: 1,
        customerUsageType: nil,
        exemptionNo: nil,
        referenceCode: 'R250707809',
        currencyCode: 'USD'
      }
    }

    initialize_with { attributes.deep_symbolize_keys }
  end

  factory :avalara_transaction_calculator, class: Spree::Calculator::AvalaraTransaction do
  end
end
