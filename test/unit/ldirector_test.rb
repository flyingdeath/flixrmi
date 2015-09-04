require 'test_helper'

class LdirectorTest < ActiveSupport::TestCase

  def setup 
    @ldirector = Factory.create(:ltitle_full).ldirectors[0]
  end 
  
  def teardown
    @ldirector = nil
  end 
  
  test "find director one" do
    director  = Ldirector.find(@ldirector.id) 
    assert director
    assert (director == @ldirector)
  end
 
  test "create director one" do
    director  = Ldirector.create(@ldirector.attributes)
    assert(director.save)
    one_director = Ldirector.find(director.id)
    assert_equal(director, one_director)
  end
 
  test "update director one" do
    director = Ldirector.find(@ldirector.id)
    director.name = "dave"
    assert director.save
    assert director.update_attributes({:name => "Bob"})
  end
 
  test "destroy director one" do
    director = Ldirector.find(@ldirector.id)
    assert director.destroy
  end
end
