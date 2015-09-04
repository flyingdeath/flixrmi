require 'test_helper'

class CueControllerTest < ActionController::TestCase
  def setup
    @ltitle = Factory.create(:ltitle_full)
    getIndifferentFixtures :session
  end
  
  def teardown
    get(:deleteTitle, {:ext_id => @ltitle.ext_id, :queueType => 'Instant'}, @session['session'])
    get(:deleteTitle, {:ext_id => @ltitle.ext_id}, @session['session'])
    @session = nil
    @ltitle = nil
  end 
  
  test "should list Disc Queue " do
    get(:listQueue, {:QueueType => 'Disc'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:queueType)
  end
  
  test "should list Instant Queue " do
    get(:listQueue, {:QueueType => 'Instant'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:titles)
    assert_not_nil assigns(:listType)
    assert_not_nil assigns(:states)
    assert_not_nil assigns(:ratings)
    assert_not_nil assigns(:queueType)
  end
  
  test "should do all queue actions Disc " do
   #-------------------------------------------------------#  
   # addDisc
   #-------------------------------------------------------#
    get(:addDisc, {:ext_id => @ltitle.ext_id}, @session['session'])
    assert_response :redirect 
    cueStatus =  Rails.cache.read("cueStatus")
    assert_equal("success",cueStatus.details.attributes['message'])
   #-------------------------------------------------------#  
   # saveDisc
   #-------------------------------------------------------#
    get(:saveDisc, {:ext_id => @ltitle.ext_id}, @session['session'])
    assert_response :redirect 
    cueStatus =  Rails.cache.read("cueStatus")
    assert_equal("Title Saved to Queue",cueStatus.details.attributes['message'])
   #-------------------------------------------------------#  
   # deleteTitle
   #-------------------------------------------------------#
    get(:deleteTitle, {:ext_id => @ltitle.ext_id}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:status)
    assert_equal("Title deleted from Queue", assigns['status'].details.attributes['message'])
   #-------------------------------------------------------#  
   # undoDeleteTitle
   #-------------------------------------------------------#
    get(:undoDeleteTitle, {:ext_id => @ltitle.ext_id}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:status)
    assert_equal("Title Added to Queue", assigns['status'].details.attributes['message'])
   #-------------------------------------------------------#  
   # moveTitle
   #-------------------------------------------------------#
    get(:moveTitle, {:ext_id => @ltitle.ext_id, :position => 25}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:status)
    assert_equal("Title Moved", assigns['status'].details.attributes['message'])
   #-------------------------------------------------------#  
   # deleteTitle
   #-------------------------------------------------------#
    get(:deleteTitle, {:ext_id => @ltitle.ext_id}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:status)
    assert_equal("Title deleted from Queue", assigns['status'].details.attributes['message'])
   #-------------------------------------------------------#  
  end
  
  test "should do all queue actions Instant" do
   #-------------------------------------------------------#  
   # addInstant
   #-------------------------------------------------------#
    get(:addInstant, {:ext_id => @ltitle.ext_id}, @session['session'])
    assert_response :redirect
    cueStatus =  Rails.cache.read("cueStatus")
    assert_equal("Title Added to Queue",cueStatus.details.attributes['message'])
   #-------------------------------------------------------#  
   # deleteTitle
   #-------------------------------------------------------#
    get(:deleteTitle, {:ext_id => @ltitle.ext_id, :queueType => 'Instant'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:status)
    assert_equal("Title deleted from Queue", assigns['status'].details.attributes['message'])
   #-------------------------------------------------------#  
   # undoDeleteTitle
   #-------------------------------------------------------#
    get(:undoDeleteTitle, {:ext_id => @ltitle.ext_id, :queueType => 'Instant'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:status)
    assert_equal("Title Added to Queue", assigns['status'].details.attributes['message'])
   #-------------------------------------------------------#  
   # moveTitle
   #-------------------------------------------------------#
    get(:moveTitle, {:ext_id => @ltitle.ext_id, :queueType => 'Instant', :position => 25}, @session['session'])
    assert_response :success
    #"Move successful" 
    assert_not_nil assigns(:status)
    assert_equal("Title Moved", assigns['status'].details.attributes['message'])
   #-------------------------------------------------------#  
   # deleteTitle
   #-------------------------------------------------------#
    get(:deleteTitle, {:ext_id => @ltitle.ext_id, :queueType => 'Instant'}, @session['session'])
    assert_response :success
    assert_not_nil assigns(:status)
    assert_equal("Title deleted from Queue", assigns['status'].details.attributes['message'])
   #-------------------------------------------------------#  
  end
  
  
end
