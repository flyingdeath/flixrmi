require 'test_helper'

class PeopleControllerTest < ActionController::TestCase

  def setup
    @ltitle = Factory.create(:ltitle_full)
    getIndifferentFixtures :session
  end
  
  def teardown
    @session = nil
    @ltitle = nil
  end 

  test "should show person" do
    get(:showPerson, {:type => 'actor', :id => @ltitle.lactors[0].id}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:person)
    assert_not_nil assigns(:extendedPerson)
    assert_not_nil assigns(:filmography)
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:listType)
  end
  
end
