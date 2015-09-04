require 'test_helper'

class TitleControllerTest < ActionController::TestCase

  def setup
    @ltitle = Factory.create(:ltitle_full)
    
    getIndifferentFixtures :session
  end
  
  def teardown
    @session = nil
    @ltitle = nil
  end 
  
  test "should list New first " do
    get(:getNew, {}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should New list pagination " do
    s = @session['session']
    #s['listNew'] = {:index=> 0, :inc => 25 }
    get(:getNew_pagination, {}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
  end
  
  test "should list New Sort Availability " do
    get(:getNew, {:Sort => 'Availability'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list New Sort Rating Average " do
    get(:getNew, { :Sort => 'RatingAverage'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list New Availability filter " do
    s = @session['session']
    get(:getNew, {:filterKey => "availability", :AtMost => "Today", :AtLeast => "Minus 1 Year"}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list New formatType filter " do
    s = @session['session']
    get(:getNew, {:filterKey => "formatType", :FormatType => "Blu-ray"}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list New formatType availability filter " do
    s = @session['session']
    session[:filterSet] = {:formatType => {:FormatType => "Blu-ray"}}
    get(:getNew, {:filterKey => "availability", :AtMost => "Today", :AtLeast => "Minus 1 Year"}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list New Rating Average filter " do
    s = @session['session']
    get(:getNew, {:filterKey => "rating", :FliterRatingType => "Average",  :AtMost => "5.0", :AtLeast => "3.5"}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list Recommendations " do
    s = @session['session']
    get(:getRecommendations, {}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:titlesData)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list Recommendations pagination" do
    s = @session['session']
    #s['listRecommendations'] = {:index=> 0, :inc => 25 }
    get(:getRecommendations, {}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:titlesData)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:paginationVars)
  end
  
  test "should list Simlars " do
    s = @session['session']
    Rails.cache.write("simlars",[])
    Rails.cache.write("indexSimlars",0)
    Rails.cache.write("simlars_id",@ltitle.ext_id)
    get(:getSimlars, {}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:titlesData)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
  end
  
  test "should list change Simlars Index " do
    s = @session['session']
    Rails.cache.write("simlars",[@ltitle.ext_id, @ltitle.ext_id])
    Rails.cache.write("indexSimlars",0)
    get(:changeSimlarsIndex, {:direction => 'simlars_forward'}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:titlesData)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
  end
  
  test "should show Title " do
    s = @session['session']
    get(:showTitle, {:id => @ltitle.id}, s)
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:titlesData)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:extended_title)
    assert_not_nil assigns(:synopsis)
    assert_not_nil assigns(:LanguagesAudio)
    assert_not_nil assigns(:awards)
    assert_not_nil assigns(:rating)
    assert_not_nil assigns(:state)
  end
  
  test "should extended Title Data" do
    s = @session['session']
    get(:extendedTitleData, {:id => @ltitle.id}, s)
    assert_response :success
    assert_not_nil assigns(:title)
    assert_not_nil assigns(:synopsis)
  end
  
  
  
end
