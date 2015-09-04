
require "netflix_api_connector"
require "modelParsers"
require "ActiveNetflix"

class People < ActiveNetflix

  def self.find_Data_Url(session, urlRef)
    connector = NetflixApiConnector.new(session)
    return connector.getNetflixData(:genaral_request,  {:url => urlRef },false) 
  end
  
  def self.find(session, id)
    return getData(PersonListParser.new(0), :get_person, "Single", {:person_id => id }, session)
  end
  
  def self.find_filmography(session, id)
    return getData(TitleListParser.new(:filmography), :get_filmography, "Data", {:person_id => id }, session)
  end
  
  def self.find_by_name(session, name, autocomplete = false, start = 0, max = 100)
    if autocomplete 
      return getData(AutocompleteXMLparser.new, :autocomplete, "Json", {:term => name }, session)
    else
      return getData(PersonListParser.new(0), :search_people, "Data", 
											 {:term =>     name, 
                                              :start_index => start, 
                                              :max_results => max}, session)
    end
  end
  
end
