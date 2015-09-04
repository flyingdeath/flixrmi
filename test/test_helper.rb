ENV["RAILS_ENV"] = "test"


require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'factory_girl'
require "ApiFixtures"
require "NetflixObjectTestHelper"

require File.dirname(__FILE__) + "/factories/factories"


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  
  self.use_instantiated_fixtures  = true
  self.use_transactional_fixtures = true
  
  include ApiFixtures
  include NetflixObjectTestHelper

  # Add more helper methods to be used by all tests here...
end
