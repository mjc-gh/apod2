ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def teardown
    FakeWeb.clean_registry
  end

  def html_parser(file)
    Nokogiri::HTML(fixture_file(file))
  end

  def fixture_file(*path)
    File.read(Rails.root.join('test', 'fixtures', *path))
  end
end

require 'mocha'
