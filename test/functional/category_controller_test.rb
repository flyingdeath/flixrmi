require 'test_helper'

class CategoryControllerTest < ActionController::TestCase

  def setup
    @ltitle = Factory.create(:ltitle_full)
    
    getIndifferentFixtures :session
  end
  
  def teardown
    @session = nil
    @ltitle = nil
  end 
  
  test "should list Category first " do
    get(:listCategory, {:id => @ltitle.lgenres[0].id}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:genre)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should Category list pagination " do
    s = @session['session']
    s[:genresid] = @ltitle.lgenres[0].id
    get(:listCategory_pagination, {}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:genre)
  end
  
  test "should list Category Sort Availability " do
    get(:listCategory, {:id => @ltitle.lgenres[0].id, :Sort => 'Availability'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:genre)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list Category Sort Rating Average " do
    get(:listCategory, {:id => @ltitle.lgenres[0].id, :Sort => 'RatingAverage'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:genre)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list Category Availability filter " do
    s = @session['session']
    s[:genresid] = @ltitle.lgenres[0].id
    get(:listCategory, {:filterKey => "availability", :AtMost => "Today", :AtLeast => "Minus 1 Year"}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:genre)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list Category formatType filter " do
    s = @session['session']
    s[:genresid] = @ltitle.lgenres[0].id
    get(:listCategory, {:filterKey => "formatType", :FormatType => "Blu-ray"}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:genre)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list Category formatType availability filter " do
    s = @session['session']
    s[:genresid] = @ltitle.lgenres[0].id
    session[:filterSet] = {:formatType => {:FormatType => "Blu-ray"}}
    get(:listCategory, {:filterKey => "availability", :AtMost => "Today", :AtLeast => "Minus 1 Year"}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:genre)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list Category Rating Average filter " do
    s = @session['session']
    s[:genresid] = @ltitle.lgenres[0].id
    get(:listCategory, {:filterKey => "rating", :FliterRatingType => "Average",  :AtMost => "5.0", :AtLeast => "3.5"}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:genre)
    assert_not_nil assigns(:paginationVars)
  end
  
end
