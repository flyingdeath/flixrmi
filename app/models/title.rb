 require "netflix_api_connector"
 require "modelParsers"
 require "ActiveNetflix"
 
class Title  < ActiveNetflix

  def self.find_Data_Url(urlRef, session)
    connector = NetflixApiConnector.new(session)
    return connector.getNetflixData(:genaral_request,  {:url => urlRef }) 
  end
  
#----------------------------------------------------------------------------------------------#
  
  def self.find(session,id)
    return getData(TitleParser.new(0), :get_title, "Single",  {:title_id => id }, session)
  end
  
  def self.find_by_name(session, name, autocomplete = false, start = 0, max = 100)
    if autocomplete
      return getData(TitlesAutoListParser.new(1), :autocomplete, "Json",  {:term => name }, session)
    else
      return getData(TitleListParser.new(:title), :search_tiles, "Data",  {:term => name, 
                                                           :start_index => start, 
                                                           :max_results => max}, session)
    end
  end
  
 # def self.find_recommendations(session, start = 0, max = 100)
 #     return getData(TitleUserIndexListParser.new(:recommendation), :get_recommendations, 
 #          "Data",  {:start_index => start,    :max_results => max}, session)
 # end
  
  def self.find_recommendations(session, start = 0, max = 500)
      return getFullData(TitleUserIndexListParser, :get_recommendations, 
           "Data",  {:start_index => start,    :max_results => max}, :recommendation, session)
  end
  
  
  
  def self.find_similars(session, id, start = 0, max = 100)
      return getData(TitleListParser.new(:similars), :get_similars, 
           "Data",  {:title_id => id, 
                               :start_index => start, 
                               :max_results => max}, session)
  end
  
  
#----------------------------------------------------------------------------------------------#
  def self.find_cast(session, id)
    return getData(PersonListParser.new(0), :get_cast, 
           "Set",  {:title_id => id }, session)
  end
  
  def self.find_directors(session, id)
    return getData(PersonListParser.new(0), :get_directors, 
           "Set",  {:title_id => id }, session)
  end
#----------------------------------------------------------------------------------------------#
  
  def self.find_format_availability(session, id)
    return getData(AvailabilityParser.new(0), :get_format_availability, 
           "Set",  {:title_id => id }, session)
  end
  
  def self.find_awards(session, id)
    return getData(AwardParser.new(0), :get_awards, 
           "Set",  {:title_id => id }, session)
  end
  
  def self.find_screen_formats(session, id)
    return getData(ScreenFormatParser.new(0), :get_screen_formats, 
           "Set",  {:title_id => id }, session)
  end
  
  def self.find_languages_and_audio(session, id)
    return getData(LanguageAudioParser.new(0), :get_languages_and_audio, 
           "Set",  {:title_id => id }, session)
  end
  
  def self.find_synopsis(session, id)
    return getData(SynopsisParser.new(0), :get_synopsis, 
           "Single",  {:title_id => id }, session)
  end
  
  def self.find_box_art(session, id)
   # return getData(SynopsisParser.new(0), :get_box_art, 
   #        "Single",  {:title_id => id }, session)
     connector = NetflixApiConnector.new(session)
     return connector.getNetflixData(:get_box_art,  {:title_id => id }, false) 
  end
   
#----------------------------------------------------------------------------------------------#
end
