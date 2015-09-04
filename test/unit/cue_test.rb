
$LOAD_PATH << File.dirname(__FILE__) + "/../"

require 'test_helper'

class CueTest < ActiveSupport::TestCase

  def setup
    getFixtures :cues
    getSymbolizedFixtures :session
  end
  
  def teardown
    updatedata = Cue.destroy(@session['session'],
                    @cues['reference2'].title_id, true)
    updatedata = Cue.destroy(@session['session'],
                    @cues['reference2'].title_id)
    @cues = nil
    @session = nil
  end 
  
  test "should find reference" do
    cue = Cue.find(@session['session'])
    assert(checkSets(@cues['queues'],cue))
  end
  
  test "should find defined reference" do
    cues = Cue.find_defined(@session['session'])
    assert(isDataSet(cues))
    assert(isArraySet(cues.set))
    assert(checkAttributes(@cues['details1'],cues.details))
    assert(checkArrayAttributes(@cues['titleinfo0'],cues.set))
  end
  
  test "should find defined 2 reference" do
    cues = Cue.find_defined2(@session['session'])
    assert(isDataSet(cues))
    assert(isArraySet(cues.set))
    assert(checkAttributes(@cues['details1'],cues.details))
    assert(checkArrayAttributes(@cues['titleinfo0'],cues.set))
  end
  
  test "should Disc Queue: save, edit, destroy" do
   #-------------------------------------------------------#  
   # save
   #-------------------------------------------------------#
    updatedata = Cue.save(@session['session'],
                    @cues['reference1'].title_ref,"","")
    assert(checkSets(@cues['status0'],updatedata.details))
   # assert(checkArrayAttributes(@cues['titleinfo0'],updatedata.set))
   #-------------------------------------------------------#  
   # move first
   #-------------------------------------------------------# 
    updatedata = Cue.edit(@session['session'],
                    @cues['reference1'].title_ref,"",
                    @cues['reference1'].position2)
    assert(checkSets(@cues['status1'],updatedata.details))
    assert(checkArrayAttributes(@cues['titleinfo0'],updatedata.set))
   #-------------------------------------------------------#  
   # move second
   #-------------------------------------------------------#
    
    updatedata = Cue.edit(@session['session'],
                    @cues['reference1'].title_ref,"",
                    @cues['reference1'].position1)
    assert(checkSets(@cues['status1'],updatedata.details))
    assert(checkArrayAttributes(@cues['titleinfo0'],updatedata.set))
    
   #-------------------------------------------------------#  
   # destroy
   #-------------------------------------------------------#
    updatedata = Cue.destroy(@session['session'],
                    @cues['reference2'].title_id)
    assert(checkSets(@cues['deleteStatus'],updatedata.details))
   #-------------------------------------------------------#
  end
  
  test "should Instant Queue: save, edit, destroy" do
   #-------------------------------------------------------#  
   # save
   #-------------------------------------------------------#
    updatedata = Cue.save(@session['session'],
                    @cues['reference1'].title_ref,"","", true)
    assert(checkSets(@cues['status0'],updatedata.details))
   # assert(checkArrayAttributes(@cues['titleinfo0'],updatedata.set))
   #-------------------------------------------------------#  
   # move first
   #-------------------------------------------------------# 
    updatedata = Cue.edit(@session['session'],
                    @cues['reference1'].title_ref,"",
                    @cues['reference1'].position2, true)
    assert(checkSets(@cues['status1'],updatedata.details))
    assert(checkArrayAttributes(@cues['titleinfo0'],updatedata.set))
   #-------------------------------------------------------#  
   # move second
   #-------------------------------------------------------#
    
    updatedata = Cue.edit(@session['session'],
                    @cues['reference1'].title_ref,"",
                    @cues['reference1'].position1, true)
    assert(checkSets(@cues['status1'],updatedata.details))
    assert(checkArrayAttributes(@cues['titleinfo0'],updatedata.set))
    
   #-------------------------------------------------------#  
   # destroy
   #-------------------------------------------------------#
    updatedata = Cue.destroy(@session['session'],
                    @cues['reference2'].title_id, true)
    assert(checkSets(@cues['deleteStatus'],updatedata.details))
   #-------------------------------------------------------#
  end
  
  
  
end
