
require "netflix_api_connector"
require "modelParsers"
require "ActiveNetflix"

class User < ActiveNetflix

  def self.find(session)
    return getData(UserParser.new(0), :get_current_user,  "Single",  {}, session)
  end  
  
#------------------------------------------------------------------------#  
  
  def self.find_feeds(session)
    return getData(UserfeedsParser.new(0), :get_feeds,  "Single",  {}, session)
  end  
  #----------------------------------------------------------------------------------------------#
 
  def self.find_reviews(session, urls, start_index = 0, max_results= 100, updated_min = "")
    connector = NetflixApiConnector.new(session)
    xmlData = connector.getNetflixData(:get_reviews, {:title_refs => urls,
                                                     :start_index => start_index, 
                                                     :max_results => max_results, 
                                                     :updated_min => updated_min}, false) 
    return parseData(xmlData, UserReviewsParser,0)
  end  
end
