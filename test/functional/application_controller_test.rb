require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase

  def setup
    getSymbolizedFixtures :session
  end
  
  def teardown
    @session = nil
  end 
  
  test "should list Pagination  " do
    s = @session['session']
    s['listRecommendations'] = { :inc => 25  }
    get(:listPagination, {:listAction => 'recommendationsPanel', :page => 0}, s)
    assert_response :redirect
    assert_equal("http://test.host/flixrmi/Title/getRecommendations_pagination",@response.redirect_url)
    
  end
  
  test "should list Control" do
    s = @session['session']
    get(:listControl, {:listAction => 'recommendationsPanel'}, s)
    assert_response :redirect
    assert_equal("http://test.host/flixrmi/Title/getRecommendations",@response.redirect_url)
    
  end
  
  test "should List Vars Update " do
    s = @session['session']
    get(:ListVarsUpdate, {:listAction => 'recommendationsPanel'}, s)
    assert_response :redirect
    assert_equal("http://test.host/flixrmi/Title/getRecommendations",@response.redirect_url)
    
  end
  
  
  
  
  test "should check session " do
    get(:check_session)
    assert_response :redirect
  end
  
  
  test "should Get Control Options" do
    s = @session['session']
    get(:listGetControlOptions, {:panelName => 'recommendationsPanel'}, s)
    assert_response :success
    assert_not_nil(@response.body.index('FilterEnvelop'))
  end 
  
  
end
