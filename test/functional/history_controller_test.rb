require 'test_helper'

class HistoryControllerTest < ActionController::TestCase

  def setup
    getIndifferentFixtures :session
  end
  
  def teardown
    @session = nil
  end 
  
  test "should list History All " do
    get(:listHistory, {:HistoryType => 'All'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should History list pagination " do
    s = @session['session']
    s[:HistoryType] = 'All'
    #s['listHistory'] = {:index=> 0, :inc => 25 }
    get(:history_pagination, {}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
  end
  
  test "should list History At Home " do
    get(:listHistory, {:HistoryType => 'At Home'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list History Shipped " do
    get(:listHistory, {:HistoryType => 'Shipped'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list History Returned " do
    get(:listHistory, {:HistoryType => 'Returned'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list History Watched " do
    get(:listHistory, {:HistoryType => 'Watched'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
end
