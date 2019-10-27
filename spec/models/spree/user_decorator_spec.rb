# frozen_string_literal: true

require 'spec_helper'

describe Spree.user_class do
  it { is_expected.to belong_to(:avalara_entity_use_code).optional }
end
