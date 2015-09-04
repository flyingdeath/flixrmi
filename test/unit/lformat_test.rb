require 'test_helper'

class LformatTest < ActiveSupport::TestCase

  def setup 
    @lformat = Factory.create(:ltitle_full).lformats[0]
  end 
  
  def teardown
    @lformat = nil
  end 

  test "find format one" do
    format  = Lformat.find(@lformat.id) 
    assert format
    assert (format == @lformat)
  end
 
  test "create format one" do
    format  = Lformat.create(@lformat.attributes)
    assert(format.save)
    format_one = Lformat.find(format.id)
    assert_equal(format, format_one)
  end
 
  test "update format one" do
    format = Lformat.find(@lformat.id)
    format.name = "Instant"
    assert format.save
    assert format.update_attributes({:name => "DVD"})
  end
 
  test "destroy format one" do
    format = Lformat.find(@lformat.id)
    assert format.destroy
  end
end
