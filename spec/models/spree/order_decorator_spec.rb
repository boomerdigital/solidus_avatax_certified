require 'spec_helper'

describe Spree::Order, type: :model do
  it { should have_one :avalara_transaction }
end
