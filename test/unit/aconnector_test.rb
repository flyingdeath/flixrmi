require 'test_helper'

class AconnectorTest < ActiveSupport::TestCase

  def setup 
    @aconnector = Factory.create(:aconnector)
  end 
  
  def teardown
    @aconnector = nil
  end 

  test "find aconnector one" do
    aconnector  = Aconnector.find(@aconnector.id) 
    assert aconnector
    assert (aconnector == @aconnector)
  end
 
  test "create aconnector one" do
    aconnector  = Aconnector.create(@aconnector.attributes)
    assert(aconnector.save)
    one_aconnector = Aconnector.find(aconnector.id)
    assert_equal(aconnector, one_aconnector)
  end
 
  test "update aconnector one" do
    aconnector = Aconnector.find(@aconnector.id)
    aconnector.lactors_id = 342794
    assert aconnector.save
    assert aconnector.update_attributes({:lactors_id => 43545})
  end
 
  test "destroy aconnector one" do
    aconnector = Aconnector.find(@aconnector.id)
    assert aconnector.destroy
  end
  
end
