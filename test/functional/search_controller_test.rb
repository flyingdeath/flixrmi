require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  def setup
    getIndifferentFixtures :session
  end
  
  def teardown
    @session = nil
  end 

  test "should list Search One " do
    get(:search_start, {:term => 'La Femme Nikita'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should Search list pagination " do
    s = @session['session']
    s[:term] = 'La Femme Nikita'
    #s['listSearch'] = {:index=> 0, :inc => 25 }
    get(:search_pagination, {}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
  end

  test "should list Search autocomplete " do
    get(:autocomplete, {:query => 'La Femme Nikita'}, @session['session'])
    assert_response :success
    h = ActiveResource::Formats::JsonFormat.decode(@response.body)
    assert_not_nil h["ResultSet"]
  end
  
  
end
