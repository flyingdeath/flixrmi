require "netflix_api_connector"
require "ActiveNetflix"

class Genre < ActiveNetflix

  def self.find(session)
    connector = NetflixApiConnector.new(session)
    return connector.getNetflixData(:get_genres,{}, true) 
  end
  
end
