

$LOAD_PATH << File.dirname(__FILE__) + "/../"

require 'test_helper'

class RatingTest < ActiveSupport::TestCase

  def setup
    getFixtures :ratings
    getSymbolizedFixtures :session
  end
  
  def teardown
    @ratings = nil
    @session = nil
  end 
  
  test "should find reference" do
    rating = Rating.find(@ratings['reference1'].title_ref, @session['session'])
    assert(checkAttributes(@ratings['ratingDetails'],rating[@ratings['reference1'].title_ref]))
  end
  
  test "should find actual" do
    rating = Rating.find_actual(@ratings['reference1'].title_ref, @session['session'])
    assert(checkAttributes(@ratings['ratingDetailsActual'],rating[@ratings['reference1'].title_ref]))
  end
  
  test "should find predicted" do
    rating = Rating.find_predicted(@ratings['reference1'].title_ref, @session['session'])
    assert(checkAttributes(@ratings['ratingDetailsPredicted'],rating[@ratings['reference1'].title_ref]))
  end
  
  test "should save First" do
    rating = Rating.save(@ratings['reference1'].title_ref,@ratings['reference1'].rating1,  @session['session'])
    assert(checkSets(@ratings['status'],rating.details))
  end
  
  test "should save Second" do
    rating = Rating.save(@ratings['reference1'].title_ref,@ratings['reference1'].rating2,  @session['session'])
    assert(checkSets(@ratings['status'],rating.details))
  end
end
