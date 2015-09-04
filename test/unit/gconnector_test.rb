require 'test_helper'

class GconnectorTest < ActiveSupport::TestCase

  def setup 
    @gconnector = Factory.create(:gconnector)
  end 
  
  def teardown
    @gconnector = nil
  end 


  test "find gconnector one" do
    gconnector  = Gconnector.find(@gconnector.id) 
    assert gconnector
    assert (gconnector == @gconnector)
  end
 
  test "create gconnector one" do
    gconnector  = Gconnector.create(@gconnector.attributes)
    assert(gconnector.save)
    one_gconnector = Gconnector.find(gconnector.id)
    assert_equal(gconnector, one_gconnector)
  end
 
  test "update gconnector one" do
    gconnector = Gconnector.find(@gconnector.id)
    gconnector.lgenres_id = 342794
    assert gconnector.save
    assert gconnector.update_attributes({:lgenres_id => 43545})
  end
 
  test "destroy gconnector one" do
    gconnector = Gconnector.find(@gconnector.id)
    assert gconnector.destroy
  end
  
end
