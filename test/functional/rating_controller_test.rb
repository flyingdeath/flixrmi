require 'test_helper'

class RatingControllerTest < ActionController::TestCase
  def setup
    @ltitle = Factory.create(:ltitle_full)
    getIndifferentFixtures :session
  end
  
  def teardown
    @session = nil
    @ltitle = nil
  end 
  
  test "should set rating " do
    get(:setRating, {:ext_id => @ltitle.ext_id, :rating => 5}, @session['session'])
    assert_response :success 
    status = @response.body
    assert_equal("Saved",status)
  end
  
end
