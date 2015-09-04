
require "modelParsers"
require "ActiveNetflix"

class Rating < ActiveNetflix
  
  def self.find(urlRefs,session)
    return find_title_refs(urlRefs, :get_ratings, RatingListParser, :ratings, session )
  end
  
  def self.find_actual(urlRefs,session)
    return find_title_refs(urlRefs, :get_actual_ratings, RatingListParser, :ratings, session )
  end
  
  def self.find_predicted(urlRefs,session)
    return find_title_refs(urlRefs, :get_predicted_ratings,  RatingListParser, :ratings, session )
  end

  def self.save(urlRef, rating, session)
    parser = RatingStatusParser.new(:ratings)
    ratingObj = self.find_actual(urlRef, session)
    if ratingObj
      ratingId = urlRef.split('/').last
      return getData(parser, :update_rating, "Data", {:rating_id => ratingId, :rating => rating}, session)
    else
      return getData(parser, :create_rating, "Data", {:title_ref => urlRef, :rating => rating}, session)
    end 
 end
  def self.debug(urlRefs,session)
    connector = NetflixApiConnector.new(session)
    xmlData = connector.debugNetflixData(:get_ratings, {:title_refs => urlRefs})
    return xmlData
  end
  
end
