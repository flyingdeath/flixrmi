require 'test_helper'

class LtitleTest < ActiveSupport::TestCase

  def setup 
    @ltitle = Factory.create(:ltitle_full)
  end 
  
  def teardown
    @ltitle = nil
  end 

  test "find title one" do
    title1  = Ltitle.find(@ltitle.id) 
    assert title1
    assert (title1 == @ltitle)
  end
 
  test "create title one" do
    title1  = Ltitle.create(@ltitle.attributes)
    assert(title1.save)
    title1_copy = Ltitle.find(title1.id)
    assert_equal(title1_copy, title1)
  end
 
  test "update title one" do
    title1_copy = Ltitle.find(@ltitle.id)
    title1_copy.title = "Nikita"
    assert title1_copy.save
    assert title1_copy.update_attributes({:title => "La Femme Nikita"})
  end
 
  test "destroy title one" do
    title1_copy = Ltitle.find(@ltitle.id)
    assert title1_copy.destroy
  end
end
