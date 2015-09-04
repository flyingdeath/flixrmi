require 'test_helper'

class LactorTest < ActiveSupport::TestCase

  def setup 
    @lactor = Factory.create(:ltitle_full).lactors[0]
  end 
  
  def teardown
    @lactor = nil
  end 

  test "find actor one" do
    actor  = Lactor.find(@lactor.id) 
    assert actor
    assert (actor == @lactor)
  end
 
  test "create actor one" do
    actor  = Lactor.create(@lactor.attributes)
    assert(actor.save)
    one_actor = Lactor.find(actor.id)
    assert_equal(actor, one_actor)
  end
 
  test "update actor one" do
    actor = Lactor.find(@lactor.id)
    actor.name = "Dude"
    assert actor.save
    assert actor.update_attributes({:name => "Man"})
  end
 
  test "destroy actor one" do
    actor = Lactor.find(@lactor.id)
    assert actor.destroy
  end
  
end
