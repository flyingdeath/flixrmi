

require "netflix_api_connector"
require "modelParsers"
require "ActiveNetflix"

class RentalHistory  < ActiveNetflix

  def self.find(session, start = 0, max = 500, givenDate = "")
    return getFullData(TitleUserIndexListParser, :get_rental_history, "Data", 
                           {:start_index => start, 
                            :max_results => max, 
                            :updated_min => givenDate }, :rental_history, session)
  end
  
  
  def self.find_shipped(session, start = 0, max = 500, givenDate = "")
    return getFullData(TitleUserIndexListParser, :get_shipped, "Data", 
                            {:start_index => start, 
                             :max_results => max, 
                             :updated_min => givenDate }, :rental_history, session)
  end
  
  def self.find_returned(session, start = 0, max = 500, givenDate = "")
    return getFullData(TitleUserIndexListParser, :get_returned, "Data", 
                             {:start_index => start, 
                              :max_results => max, 
                              :updated_min => givenDate }, :rental_history, session)
  end

  def self.find_watched(session, start = 0, max = 500, givenDate = "")
    return getFullData(TitleUserIndexListParser, :get_watched, "Data", 
                             {:start_index => start, 
                              :max_results => max, 
                              :updated_min => givenDate }, :rental_history, session)
  end
  def self.find_at_home(session, start = 0, max = 500, givenDate = "")
    return getData(TitleUserIndexListParser.new(:at_home), :get_at_home, "Data", 
                             {:start_index => start, 
                              :max_results => max, 
                              :updated_min => givenDate }, session)
  end


end
