require 'test_helper'

class FconnectorTest < ActiveSupport::TestCase

  def setup 
    @fconnector = Factory.create(:fconnector)
  end 
  
  def teardown
    @fconnector = nil
  end 


  test "find fconnector one" do
    fconnector  = Fconnector.find(@fconnector.id) 
    assert fconnector
    assert (fconnector == @fconnector)
  end
 
  test "create fconnector one" do
    fconnector  = Fconnector.create(@fconnector.attributes)
    assert(fconnector.save)
    one_fconnector = Fconnector.find(fconnector.id)
    assert_equal(fconnector, one_fconnector)
  end
 
  test "update fconnector one" do
    fconnector = Fconnector.find(@fconnector.id)
    fconnector.availability_int = 342794
    assert fconnector.save
    assert fconnector.update_attributes({:availability_int => 43545})
  end
 
  test "destroy fconnector one" do
    fconnector = Fconnector.find(@fconnector.id)
    assert fconnector.destroy
  end
  
end
