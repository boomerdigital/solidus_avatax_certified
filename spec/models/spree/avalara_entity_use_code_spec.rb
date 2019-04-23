# frozen_string_literal: true

require 'spec_helper'

describe Spree::AvalaraEntityUseCode, type: :model do
  it { is_expected.to have_many :users }
end
