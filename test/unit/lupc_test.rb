require 'test_helper'

class LupcTest < ActiveSupport::TestCase

  def setup 
    @lupc = Factory.create(:ltitle_full).lupcs[0]
  end 
  
  def teardown
    @lupc = nil
  end 

  
  test "find Lupc one" do
    upc1  = Lupc.find(@lupc.id) 
    assert upc1
    assert (upc1 == @lupc)
  end
 
  test "create Lupc one" do
    upc1  = Lupc.create(@lupc.attributes)
    assert(upc1.save)
    upc1 = Lupc.find(upc1.id)
    assert_equal(upc1, upc1)
  end
 
  test "update Lupc one" do
    upc1 = Lupc.find(@lupc.id)
    upc1.number = 100000001
    assert upc1.save
    assert upc1.update_attributes({:number => 3300001})
  end
 
  test "destroy Lupc one" do
    upc1 = Lupc.find(@lupc.id)
    assert upc1.destroy
  end
  
end
