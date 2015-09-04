
$LOAD_PATH << File.dirname(__FILE__) + "/../"

require 'test_helper'

class RentalHistoryTest < ActiveSupport::TestCase

  def setup
    getFixtures :rental_histories
    getSymbolizedFixtures :session
  end
  
  def teardown
    @rentalhistory = nil
    @session = nil
  end 
  
  test "should find rental history" do
    rentalhistory = RentalHistory.find(@session['session'])
    assert(isArraySet(rentalhistory.set))
    assert(checkArrayAttributes(@rental_histories['HistoryItem'],rentalhistory.set))
    assert(checkAttributes(@rental_histories['Historydetails'], rentalhistory.details))
  end
  test "should find rental history shipped" do
    rentalhistory = RentalHistory.find_shipped(@session['session'])
    assert(isArraySet(rentalhistory.set))
    assert(checkArrayAttributes(@rental_histories['HistoryItem'],rentalhistory.set))
    assert(checkAttributes(@rental_histories['Historydetails'], rentalhistory.details))
  end
  test "should find rental history returned" do
    rentalhistory = RentalHistory.find_returned(@session['session'])
    assert(isArraySet(rentalhistory.set))
    assert(checkArrayAttributes(@rental_histories['HistoryItem'],rentalhistory.set))
    assert(checkAttributes(@rental_histories['Historydetails'], rentalhistory.details))
  end
  test "should find rental history watched" do
    rentalhistory = RentalHistory.find_watched(@session['session'])
    assert(isArraySet(rentalhistory.set))
    assert(checkArrayAttributes(@rental_histories['HistoryItem'],rentalhistory.set))
    assert(checkAttributes(@rental_histories['Historydetails'], rentalhistory.details))
  end
  test "should find rental history at home" do
    rentalhistory = RentalHistory.find_at_home(@session['session'])
    assert(isArraySet(rentalhistory.set))
    assert(checkArrayAttributes(@rental_histories['HistoryItem'],rentalhistory.set))
    assert(checkAttributes(@rental_histories['Historydetails'], rentalhistory.details))
  end
  
end
