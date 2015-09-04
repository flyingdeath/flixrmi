require 'test_helper'

class DconnectorTest < ActiveSupport::TestCase

  def setup 
    @dconnector = Factory.create(:dconnector)
  end 
  
  def teardown
    @dconnector = nil
  end 

  test "find dconnector one" do
    dconnector  = Dconnector.find(@dconnector.id) 
    assert dconnector
    assert (dconnector == @dconnector)
  end
 
  test "create dconnector one" do
    dconnector  = Dconnector.create(@dconnector.attributes)
    assert(dconnector.save)
    one_dconnector = Dconnector.find(dconnector.id)
    assert_equal(dconnector, one_dconnector)
  end
 
  test "update dconnector one" do
    dconnector = Dconnector.find(@dconnector.id)
    dconnector.ldirectors_id = 342794
    assert dconnector.save
    assert dconnector.update_attributes({:ldirectors_id => 43545})
  end
 
  test "destroy dconnector one" do
    dconnector = Dconnector.find(@dconnector.id)
    assert dconnector.destroy
  end
  
end
