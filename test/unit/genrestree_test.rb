require 'test_helper'

class GenrestreeTest < ActiveSupport::TestCase

  def setup 
    @genrestree = Factory.create(:genrestree)
  end 
  
  def teardown
    @genrestree = nil
  end 

  test "find genrestree one" do
    genrestree  = Genrestree.find(@genrestree.id) 
    assert genrestree
    assert (genrestree == @genrestree)
  end
 
  test "create genrestree one" do
    genrestree  = Genrestree.create(@genrestree.attributes)
    assert(genrestree.save)
    one_genrestree = Genrestree.find(genrestree.id)
    assert_equal(genrestree, one_genrestree)
  end
 
  test "update genrestree one" do
    genrestree = Genrestree.find(@genrestree.id)
    genrestree.child_id = 342794
    assert genrestree.save
    assert genrestree.update_attributes({:child_id => 43545})
  end
 
  test "destroy genrestree one" do
    genrestree = Genrestree.find(@genrestree.id)
    assert genrestree.destroy
  end
  
end
