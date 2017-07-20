require 'spec_helper'

describe ToAvataxHash do
  it 'with Spree::Address' do
    address = create(:address)

    expect(address.to_avatax_hash).to be_kind_of(Hash)
  end

  it 'with Spree::StockLocation' do
    address = create(:stock_location)

    expect(address.to_avatax_hash).to be_kind_of(Hash)
  end
end
