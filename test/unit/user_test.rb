
$LOAD_PATH << File.dirname(__FILE__) + "/../"

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    getFixtures :users
    getSymbolizedFixtures :session
  end
  
  def teardown
    @users = nil
    @session = nil
  end 
  
  test "should find reference" do
    user = User.find(@session['session'])
    assert(checkSets(@users['userData'],user))
  end
  
  test "should find feeds" do
    feeds = User.find_feeds(@session['session'])
    assert(checkSets(@users['feedsPartail'],feeds, true))
  end
  
end
