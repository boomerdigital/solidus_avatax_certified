# frozen_string_literal: true

factory_path = "#{File.dirname(__FILE__)}/factories/**/*_factory.rb"
Dir[factory_path].each { |f| require File.expand_path(f) }
