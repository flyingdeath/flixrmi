require 'test_helper'

class LgenreTest < ActiveSupport::TestCase

  def setup 
    @lgenre = Factory.create(:ltitle_full).lgenres[0]
  end 
  
  def teardown
    @lgenre = nil
  end 

  test "find genre one" do
    genre  = Lgenre.find(@lgenre.id) 
    assert genre
    assert (genre == @lgenre)
  end
 
  test "create genre one" do
    genre  = Lgenre.create(@lgenre.attributes)
    assert(genre.save)
    genre = Lgenre.find(genre.id)
    assert_equal(genre, genre)
  end
 
  test "update genre one" do
    genre = Lgenre.find(@lgenre.id)
    genre.name = "Action"
    assert genre.save
    assert genre.update_attributes({:name => "Action & Adventure"})
  end
 
  test "destroy genre one" do
    genre = Lgenre.find(@lgenre.id)
    assert genre.destroy
  end
  
end
