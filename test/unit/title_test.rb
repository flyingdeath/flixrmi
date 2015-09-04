
$LOAD_PATH << File.dirname(__FILE__) + "/../"

require 'test_helper'

class TitleTest < ActiveSupport::TestCase
  
  def setup
    getFixtures :titles
    getSymbolizedFixtures :session
  end
  
  def teardown
    @titles = nil
    @session = nil
  end 
  
  test "should find by name" do
    title = Title.find_by_name(@session['session'], @titles['search'].name)
    assert(checkAttributes(@titles['searchDetails'],title.details))
    assert(checkFristOccurrence(@titles['searchFirstTitle'],title.set))
  end
  
  test "should find recommendations" do
    title = Title.find_recommendations(@session['session'])
    assert(checkAttributes(@titles['recommendationsDetails'],title.details))
    assert(checkArrayAttributes(@titles['recommendation'],title.set))
  end
  
  test "should find by name autocomplete" do
    title = Title.find_by_name(@session['session'], @titles['search'].name, true)
    assert(checkAutoCompleteJsonResponse(@titles['autocomplete'].firstTitle, title))
  end
  
  test "should find reference" do
    title = Title.find(@session['session'], @titles['reference'].title_ref)
    assert(checkAttributes(@titles['TitleAttributes'],title))
  end
  
  test "should find similars" do
    title = Title.find_similars(@session['session'], @titles['reference'].title_ref)
     assert(checkAttributes(@titles['searchDetails'],title.details))
     assert(checkFristOccurrence(@titles['similarsFirstTitle'],title.set))
  end
  
  test "should find cast" do
    cast = Title.find_cast(@session['session'], @titles['reference'].title_ref)
    assert(checkArraySet(@titles['cast'],cast))
  end
  
  test "should find directors" do
    directors = Title.find_directors(@session['session'], @titles['reference'].title_ref)
    assert(checkArraySet(@titles['director'],directors))
  end
  
  test "should find format availability" do
    availability = Title.find_format_availability(@session['session'], @titles['reference'].title_ref)
    assert(isArraySet(availability))
  end

  test "should find awards" do
    awards = Title.find_awards(@session['session'], @titles['reference'].title_ref)
    
    assert(checkArraySet(@titles['awards'],awards))
  end
  
  test "should find screen formats" do
    screen_formats = Title.find_screen_formats(@session['session'], @titles['reference'].title_ref)
    assert(checkArrayAttributes(@titles['screen_formats'][0],screen_formats))
  end
  
  test "should find languages and audio" do
    languages_and_audio = Title.find_languages_and_audio(@session['session'], @titles['reference'].title_ref)
    assert(checkArrayAttributes(@titles['AudioFormats'][0],languages_and_audio))
  end
  
  test "should find synopsis" do
    synopsis = Title.find_synopsis(@session['session'], @titles['reference'].title_ref)
    assert(checkSets(@titles['synopsis2'],synopsis))
  end
      
  
end
