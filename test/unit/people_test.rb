
$LOAD_PATH << File.dirname(__FILE__) + "/../"

require 'test_helper'

class PeopleTest < ActiveSupport::TestCase

  def setup
    getFixtures :people
    getSymbolizedFixtures :session
  end
  
  def teardown
    @people = nil
  end 
  
  test "should find by name" do
    people = People.find_by_name(@session['session'], @people['search'].name)
    assert(checkAttributes(@people['searchDetails'],people.details))
    assert(checkFristOccurrence(@people['firstPerson'],people.set))
  end
  
  test "should find reference" do
    person = People.find(@session['session'], @people['reference'].person_id)
    assert(checkSets(@people['person1'],person))
  end
  
  test "should find filmography" do
    filmList = People.find_filmography(@session['session'], @people['fullReference'].person_ref)
    assert(checkArrayAttributes(@people['roles'][0],filmList.set))
  end
  
end
